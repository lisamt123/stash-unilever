/**********************************************************************
 Name:  isll_EditPageContentController
 Copyright © 2013  Unilever
======================================================
Purpose:                                                            
Controller for  component.
get Articles added to current page
======================================================
History
-------
VERSION     AUTHOR              DATE            DETAIL              Description
   1.0      Liza Romanenko      30/07/2013      INITIAL DEVELOPMENT 
***********************************************************************/
public with sharing class isll_AdditionalContentController {
	public List<CMS_Page_Article__c> articlesList {get; set;}
	public List<ArticleWrapper> articles {get; set;}
	
	/*******************************************************************
    Purpose: return Name of the current Page
    ********************************************************************/
	private String getPageName(){
		URL u = new URL('http://test.com'+ApexPages.CurrentPage().getUrl());
		String pageName = u.getPath();
		pageName = pageName.replaceFirst('/apex/','');          // IT ALWAYS STARTS WITH /APEX/ SO REMOVE IT                           
		
		return pageName;                                       
	}
	
	public isll_AdditionalContentController(){
		getContent();
	}
	
	/*******************************************************************
    Purpose: load Articles added to the current Page
    ********************************************************************/
	private void getContent(){
		String pageName = getPageName();
		pageName = pageName.toLowerCase();
		
		articlesList = new List<CMS_Page_Article__c>();
		articles = new List<ArticleWrapper>();
		Map<Id, ArticleWrapper> articlesMap = new Map<Id, ArticleWrapper>();
		//select articles
		for(CMS_Page_Article__c pa : [SELECT Page_Name__c, Order__c, CMS_Article__c,
							CMS_Article__r.Title__c, CMS_Article__r.Body__c,
							CMS_Article__r.Media_Content__c, CMS_Article__r.Media_Content__r.Content__c,
							CMS_Article__r.Media_Content__r.Link__c, CMS_Article__r.Media_Content__r.ThumbnailLink__c
						FROM CMS_Page_Article__c WHERE Page_Name__c = : pageName
						ORDER BY Order__c]) {
			articlesList.add(pa);
			ArticleWrapper a = new ArticleWrapper(pa);
			articles.add(a);
			articlesMap.put(pa.CMS_Article__c, a);
		}
		
		//select related links
		for(CMS_Article_Link__c al : [SELECT CMS_Article__c, CMS_Link__c, CMS_Link__r.Name,CMS_Link__r.Content__c, CMS_Link__r.Type__c 
								FROM CMS_Article_Link__c 
								WHERE CMS_Article__c IN : articlesMap.keySet()
								ORDER BY CMS_Link__r.Name]){
			articlesMap.get(al.CMS_Article__c).links.add(al.CMS_Link__r);
		}
	}
	
	/*******************************************************************
    Purpose: wrapper class for article with links
    ********************************************************************/
	public class ArticleWrapper{
		public CMS_Article__c article {get; set;}
		public List<CMS_Content__c> links {get; set;}
		public Integer index {get; set;}
		
		public ArticleWrapper(CMS_Page_Article__c pageArticle){
			article = pageArticle.CMS_Article__r;
			index = Integer.valueOf(pageArticle.Order__c);
			links = new List<CMS_Content__c>();
		}
	}
	
	/*******************************************************************
    Purpose: method check if current user is cms Admin and 
    should Edit link be shown or not
    ********************************************************************/
	public Boolean getShowEditLink(){
		Boolean res = isll_Utility.isCurrentUserAdmin();
		return res;
	}
}