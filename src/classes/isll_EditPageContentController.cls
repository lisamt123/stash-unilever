/**********************************************************************
 Name:  isll_EditPageContentController
 Copyright © 2013  Unilever
======================================================
Purpose:                                                            
Controller for isll_EditPageContent.
provide articles related to page, passed through params 
provides the ability to relate new articles and to remove old
======================================================
History
-------
VERSION     AUTHOR              DATE            DETAIL              Description
   1.0      Liza Romanenko      30/07/2013      INITIAL DEVELOPMENT 
***********************************************************************/
public with sharing class isll_EditPageContentController {
	public String pageName {get; set;}
	public List<CMS_Page_Article__c> articlesList {get; set;}
	public String pageMode {get; set;}
	public String aId {get; set;}
	public String searchText {get; set;}
	public List<articleWrapper> searchedArticles {get; set;}
	public Boolean showSearchRes {get{return (searchedArticles != null && !searchedArticles.isEmpty());}}
	public Boolean showContentRes {get{return (articlesList != null && !articlesList.isEmpty());}}
	
	Set<Id> articleIds {get; set;}
	
	public isll_EditPageContentController(){
		pageMode = 'view';
		pageName = ApexPages.currentPage().getParameters().get('page');
		
		if(pageName != null && pageName != ''){
			getContent();
		}
	}
	
	/*******************************************************************
    Purpose: fill list of Articles related to Page passed through params
    ********************************************************************/
	private void getContent(){
		articlesList = new List<CMS_Page_Article__c>();
		articleIds = new Set<Id>();
		for(CMS_Page_Article__c pa : [SELECT Page_Name__c, Order__c, CMS_Article__c,
							CMS_Article__r.Title__c, CMS_Article__r.Body__c,
							CMS_Article__r.Media_Content__c, CMS_Article__r.Media_Content__r.Content__c
						FROM CMS_Page_Article__c WHERE Page_Name__c = : pageName
						ORDER BY Order__c]) {
			articlesList.add(pa);
			articleIds.add(pa.CMS_Article__c);
		}
	}
	
	/*******************************************************************
    Purpose: delete relation between Article and Page
    ********************************************************************/
	public void deleteArticle(){
		CMS_Page_Article__c pa = new CMS_Page_Article__c(Id=aId);
		delete pa;
		getContent();
	}
	
	/*******************************************************************
    Purpose: change Page mode to add new Articles to page
    ********************************************************************/
	public void addContent(){
		pageMode = 'add';
	}
	
	/*******************************************************************
    Purpose: change Page mode to view currently related Articles to page
    ********************************************************************/
	public void cancel(){
		pageMode = 'view';
	}
	
	/*******************************************************************
    Purpose: redirect to isll_ArticleEdit Page to create new Article 
    	for currently edited page
    ********************************************************************/
	public PageReference cerateNew(){
		
		Integer iOrder = 0;
		if(!articlesList.isEmpty()){
			iOrder = Integer.valueOf(articlesList[articlesList.size()-1].Order__c + 1);
		}
		
		PageReference res = Page.isll_ArticleEdit;
		res.getParameters().put('returnPage', apexpages.currentpage().getURL());
		res.getParameters().put('forPage', pageName);
		res.getParameters().put('order', String.valueOf(iOrder));
		res.setRedirect(true);
		return res;
	}
	
	/*******************************************************************
    Purpose: fill articles search results
    	articles could be added to current page
    ********************************************************************/
	public void doSearch(){
		
		if(searchText.length() > 2){
			searchText = searchText.trim();
			string temp = searchText.replace(' ', '*') + '*';
			
			searchedArticles = new List<articleWrapper>();
			
			List<List<SObject>> searchList = [FIND :temp IN ALL FIELDS
			    RETURNING CMS_Article__c (Title__c, Body__c, Media_Content__c, Media_Content__r.Content__c 
				WHERE (Id NOT IN : articleIds AND Media_Content__r.Type__c = 'Image' )
			        ORDER BY Title__c)];
			CMS_Article__c [] articles = ((List<CMS_Article__c>)searchList[0]);
			
			for(CMS_Article__c a : articles){
				searchedArticles.add(new articleWrapper(a));
			}
			
			if(searchedArticles.isEmpty()){
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No content found.'));
			}
		} else {
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'To search it should be entered at least 3 symbols.'));
		}
		
	}
	
	/*******************************************************************
    Purpose: add selected Articles to current Page
    ********************************************************************/
	public void addSelected(){
		List<CMS_Page_Article__c> addedArticles = new List<CMS_Page_Article__c>();
		//calculate order of new articles
		Integer iOrder = 0;
		if(!articlesList.isEmpty()){
			iOrder = Integer.valueOf(articlesList[articlesList.size()-1].Order__c + 1);
		}
		
		//go through search results and look which one selected
		for(articleWrapper aw : searchedArticles){
			if(aw.isSelected){
				CMS_Page_Article__c newPA = new CMS_Page_Article__c(
						Page_Name__c = pageName
						, CMS_Article__c = aw.article.Id
						, Order__c = iOrder);
				iOrder++;
				addedArticles.add(newPA);
			}
		}
		
		if(!addedArticles.isEmpty()){
			insert addedArticles;
			getContent();
			doSearch();	
		}
	}
	
	/*******************************************************************
    Purpose: wrapper class for search results
    ********************************************************************/
	public class articleWrapper{
		public CMS_Article__c article {get; set;}
		public Boolean isSelected {get; set;}
		
		public articleWrapper(CMS_Article__c article){
			this.article = article;
			isSelected = false;
		}
	}

}