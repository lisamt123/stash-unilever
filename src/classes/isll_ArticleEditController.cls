/**********************************************************************
 Name:  isll_ArticleEditController
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose: The controller for article edit.                                                    
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Liza     30/07/2013        INITIAL DEVELOPMENT         Story id:  
 
***********************************************************************/
public with sharing class isll_ArticleEditController {
	public CMS_Article__c article {get; set;}
//	public List<CMS_Article_Link__c> links;
	public CMS_Content__c newLink {get; set;}
	public String retPage {get; set;}
	public String forPage {get; set;}
	public Integer orderForPage {get; set;}
	public Attachment attachment {get;set;}
	public String contentType{get;set;}
	public List<SelectOption> contentTypeList{
		get{
			if (null == contentTypeList){
				contentTypeList = new List<SelectOption>();
				contentTypeList.add(new SelectOption('Image', 'Image'));
				contentTypeList.add(new SelectOption('Video', 'Video'));
			}
			return contentTypeList;
		}
		set;
	}
	
	public isll_ArticleEditController(ApexPages.StandardController stdController) {
     //   this.article = (CMS_Article__c)stdController.getRecord();
        Id articleId = stdController.getId();
        
        if(articleId != null){
        	//Load data
        	try {
        		article = [SELECT Name, Title__c, Body__c, Media__c, MediaType__c, Media_Content__c,Media_Content__r.Content__c, Media_Content__r.Type__c, Media_Content__r.ThumbnailLink__c,
        					(SELECT CMS_Link__c, CMS_Link__r.Name FROM CMS_Article_Links__r) FROM CMS_Article__c WHERE Id = :articleId];
        //		links = article.CMS_Article_Links__r;
        	} catch (Exception ex){}
        } else {
        	// Create new article
        	article = new CMS_Article__c();
  //      	links = new List<CMS_Article_Link__c>();
        }
        
        retPage = ApexPages.currentPage().getParameters().get('returnPage');
        forPage = ApexPages.currentPage().getParameters().get('forPage');
        String orderStr = ApexPages.currentPage().getParameters().get('order');
        if(orderStr!= null && orderStr != ''){
        	try{
        		orderForPage = Integer.valueOf(orderStr);
        	}catch(Exception ex){}
        } else {
        	orderForPage = -1;
        }
        attachment = new Attachment();
        contentType = article.Media_Content__r.Type__c;
    }
    
    public void save(){
    	Savepoint sp = Database.setSavePoint();
    	try {
    		CMS_Content__c content;
    		if(null == article.Media_Content__c){
				content = new CMS_Content__c();
				content.Type__c = contentType;
				content.Name = article.name;
				insert content;
				article.Media_Content__c = content.id;
			}
			else{
				content = new CMS_Content__c(id = article.Media_Content__c, Type__c = contentType, 	Name = article.name);
			}
    			
    		Boolean isNew = article.Id == null;
    		upsert article;
    		
    		if(isNew && forPage != null && forPage != ''){
    			CMS_Page_Article__c newPA = new CMS_Page_Article__c(
						Page_Name__c = forPage
						, CMS_Article__c = article.Id
						, Order__c = orderForPage);
						
				insert newPA;
    		}
    		
    		//save attachment
    		
    		if(null != attachment.body && String.isNotBlank(attachment.name)){
    			//delete old attachments, should only be one
    			delete [select id from Attachment where parentId = :article.Media_Content__c];
    			attachment.parentId  = content.id;
    			insert attachment;
    			content.Content__c = '/servlet/servlet.FileDownload?file='+attachment.Id;
    			content.ThumbnailLink__c = article.Media_Content__r.ThumbnailLink__c;
    			update content;
    			
    		}
    		else{
				if(null != article.Media_Content__c){
	    			content.Content__c = article.Media_Content__r.Content__c;
	    			content.ThumbnailLink__c = article.Media_Content__r.ThumbnailLink__c;
		    		update content;				
				}
    		}
    		
    		
    	} catch (Exception ex) {
            system.debug(ex);
    			Database.rollback(sp);
    	}
    }
    
    public PageReference saveAndBack(){
    	PageReference res = null;
    	
    	save();
    	
    	if(retPage != null && retPage != ''){
    		res = new PageReference(retPage);
    	}
    	return res;
    }
    
    public PageReference cancel(){
    	PageReference res = null;
    	if(retPage != null && retPage != ''){
    		res = new PageReference(retPage);
    	}
    	return res;
    }
 /*   
    public List<CMS_Article_Link__c> getLinks(){
    	List<CMS_Article_Link__c> links = [SELECT CMS_Article__c, CMS_Link__c, CMS_Link__r.Name, CMS_Link__r.Content__c, 
    										CMS_Link__r.Type__c, CMS_Link__r.LinkTitle__c 
    								FROM CMS_Article_Link__c WHERE CMS_Article__c = : article.Id ORDER BY CMS_Link__r.Name];
    	return links;
    }
    
    public void addLink(){
    	newLink = new CMS_Content__c(Type__c='Link');
    }
    public void cancelLink(){
    	newLink = null;
    }
    
    public void saveLink(){
    	insert newLink;
    	CMS_Article_Link__c jObj = new CMS_Article_Link__c(CMS_Article__c=article.Id, CMS_Link__c=newLink.Id);
    	insert jObj;
    	newLink = null;
    	getLinks();
    }*/
}