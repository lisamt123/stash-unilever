/**********************************************************************
 Name:  isll_CmsContentComponentController
 Copyright © 2013  Unilever
======================================================
Purpose:                                                            
Controller for isll_CmsContentComponent.
get Content from CMS_Component obj by Name passed from Component.
======================================================
History
-------
VERSION     AUTHOR              DATE            DETAIL              Description
   1.0      Liza Romanenko      16/07/2013      INITIAL DEVELOPMENT 
***********************************************************************/
public with sharing class isll_CmsContentComponentController {
    // passed from Component
    public String cmsComponentName {get; set;}
    public String cmsComponentId {get; set;}
    public String contentType {
        get {
            if (contentType == null) {
                if(cmsContent == null){
                    loadCmsContent();
                }
                if(cmsContent != null){
                    contentType = cmsContent.Type__c;
                }
            }
            return contentType;
        } set;
    }
    public String cmsComponentContent {
        get {
            if (cmsComponentContent == null) {
                if(cmsContent == null){
                    loadCmsContent();
                }
                if(cmsContent != null){
                    cmsComponentContent = cmsContent.Content__c;
                }
            }
            return cmsComponentContent;
        } set;
    }
    public String contentName {get; set;}
    public CMS_Content__c cmsContent {get; set;}
    public Boolean isEditMode {get; set;}
    public Boolean isInlineEditMode {get; set;}
    public String showMode {get; set;}
    public Boolean isEditable {get; set;}
   
    public Attachment attach {get; set;}
    
    public Boolean showEvent {
    	get{
    		String se = Apexpages.CurrentPage().getParameters().get('event');
    		return se == 'true';
    	}
    }
    
    public Integer daysToGo {
		get{
			if(cmsContent == null || cmsContent.Event__r == null || cmsContent.Event__r.Start_Date_Time__c == null){
				return -100;
			}
			return Date.today().daysBetween(cmsContent.Event__r.Start_Date_Time__c.date());
		}
	}
    
    /*******************************************************************
    Purpose: load CMS_Content__c obj by the name from component atributes cmsComponentName
    ********************************************************************/
    private void loadCmsContent(){
        if((cmsComponentName != null && cmsComponentName != '') || (cmsComponentId != null && cmsComponentId != '')){
            List<CMS_Content__c> contents = 
                    [SELECT Name, Content__c, Type__c, ThumbnailLink__c, Link__c, LinkTitle__c, MediaDescription__c,
                    		MediaType__c, ShortMediaDescription__c, ThumbnailText__c, (select id from Attachments),
                    		Event__c, Event__r.Locked__c, Event__r.Start_Date_Time__c
                    FROM CMS_Content__c WHERE Name = :cmsComponentName OR Id=:cmsComponentId];
                    
            if(contents != null && !contents.isEmpty()){
                cmsContent = contents[0];
                cmsComponentName = cmsContent.Name;
                cmsComponentId = cmsContent.Id;
                
                if(showMode == 'edit'){
                	attach = new Attachment(ParentId = cmsComponentId);
                }
            }
        }
    }
    
    public void deleteContent(){
        try{
            delete new CMS_Content__c(Id=cmsComponentId);
        } catch(Exception ex){}
    }
    
    public void editContent(){
        showMode = 'inlineEdit';
        isInlineEditMode = true;
        
        cmsContent = new CMS_Content__c(
            Id = cmsComponentId,
            Name = cmsComponentName,
            Content__c = cmsComponentContent);
    }
    
     public void saveInline(){
    	save();
        showMode = 'view';
        isInlineEditMode = false;
    }
    
    public PageReference save(){
    	Savepoint sp  = Database.setSavepoint();
    	try{
	    	if(null != attach.body && String.isNotBlank(attach.name)){
	    		//delete old attachment
	    		if(null != cmsContent.Attachments && cmsContent.Attachments.size() > 0 ){
	    			delete cmsContent.Attachments[0];
	    		}
	    		insert attach;
	    		if(cmsContent.Type__c != 'Video'){
	    			cmsContent.Content__c = '/servlet/servlet.FileDownload?file='+attach.Id;
	    		} else {
	    			cmsContent.ThumbnailLink__c = '/servlet/servlet.FileDownload?file='+attach.Id;
	    		}
	    		
	    	}	
	    	if(cmsContent.Event__c != null){
	    		cmsContent.Link__c = 'isll_EventsDetail?id='+ cmsContent.Event__c;
	    	}	
        	update cmsContent;
    	}
    	catch (Exception e){
    		Database.rollback(sp);
    	}
    	
        
        return ApexPages.currentPage();
    }
    
     public PageReference saveAndBack(){
    	save();
    	
    	return goBack();
    }
    
    public PageReference goBack(){
    	PageReference res = null;
    	
    	String retPage = String.escapeSingleQuotes(
    		ApexPages.currentPage().getParameters().get('returnPage') != null ?
    			ApexPages.currentPage().getParameters().get('returnPage') : ''
    	);
    	
    	if(retPage != null && retPage != ''){
			//Absolute & Relative URL Patterns
			Pattern absoluteUrlPttrn = Pattern.compile('([a-zA-Z0-9]+://)?([a-zA-Z0-9_]+:[a-zA-Z0-9_]+@)?([a-zA-Z0-9.-]+\\.[A-Za-z]{2,4})(:[0-9]+)?(/.*)?');
			Pattern relativeUrlPttrn = Pattern.compile('(/[\\w~,;\\-\\./?%&+#=]*)');
			
			//Check if the return URL matches with one of them
			if (absoluteUrlPttrn.matcher(retPage).matches() ||
				relativeUrlPttrn.matcher(retPage).matches()) {
				res = new PageReference(retPage);
			}
    	}
    	return res;
    }
    
    public void cancel(){
        showMode = 'view';
        isInlineEditMode = false;
    }
   
	
	public Boolean getShowEditLink(){
		if(isEditable == null){
			isEditable = false;
		}
		Boolean res = isEditable && isll_Utility.isCurrentUserAdmin();
		return res;
	}
    
    public Boolean isChangeTypeMode {get; set;}
    public String originType {get; set;}
    
    public void changeType(){
    	isChangeTypeMode = true;
    	originType = cmsContent.Type__c;
    }
    
    public void changeTypeSave(){
    //	update cmsContent;
    	isChangeTypeMode = false;
    }
    
    public void changeTypeCancel(){
    	isChangeTypeMode = false;
    	cmsContent.Type__c = originType;
    }
	
}