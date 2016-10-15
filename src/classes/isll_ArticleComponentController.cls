/**********************************************************************
 Name:  isll_ArticleComponentController
 Copyright © 2013  Unilever
======================================================
Purpose:                                                            
Controller for isll_ArticleFullView component.
get Article by name
======================================================
History
-------
VERSION     AUTHOR              DATE            DETAIL              Description
   1.0      Liza Romanenko      30/07/2013      INITIAL DEVELOPMENT 
***********************************************************************/
public with sharing class isll_ArticleComponentController {
	
	public String aName {get; set;}
	
	public CMS_Article__c article {get{
		if(article == null){
			try{
				article = [SELECT Title__c, Body__c, Media__c, Media_Content__r.Content__c, Media_Content__r.ThumbnailLink__c,
								Media_Content__r.Type__c,
							(SELECT CMS_Link__c, CMS_Link__r.Name,CMS_Link__r.Content__c, CMS_Link__r.Type__c 
							FROM CMS_Article_Links__r ORDER BY CMS_Link__r.Name) 
						FROM CMS_Article__c WHERE Name = :aName LIMIT 1];
			} catch(Exception ex){}
		}
		return article;
	} set;}
	
	/*******************************************************************
    Purpose: method check if current user is cms Admin and 
    should Edit link be shown or not
    ********************************************************************/
	public Boolean getShowEditLink(){
		Boolean res = isll_Utility.isCurrentUserAdmin();
		return res;
	}
	
	/*******************************************************************
    Purpose: check if Media content is not null or empty
    ********************************************************************/
	public Boolean getShowMediaContent(){
		Boolean res = article.Media_Content__r != null && article.Media_Content__r.Content__c != null && article.Media_Content__r.Content__c != '';
		return res;
	}

}