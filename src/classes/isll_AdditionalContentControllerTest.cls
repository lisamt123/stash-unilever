/**********************************************************************
 Name:  isll_AdditionalContentControllerTest
 Copyright © 2013  Unilever
======================================================
Purpose:                                                            
Test class for isll_AdditionalContentController
======================================================
History
-------
VERSION     AUTHOR              DATE            DETAIL              Description
   1.0      Liza Romanenko      30/07/2013      INITIAL DEVELOPMENT 
***********************************************************************/
@isTest
private class isll_AdditionalContentControllerTest {
	static testMethod void testisll_AdditionalContentController() {
		
		CMS_Article__c a 		= isll_TestData.createCMSArticle();
		insert a;
		
		CMS_Page_Article__c pa 	= isll_TestData.createCMSPageArticle('isll_Home',a.Id);
		insert pa;
		
		CMS_Content__c c 		= isll_TestData.createCMSContent('Link');
		insert c;
		
		CMS_Article_Link__c al 	= isll_TestData.createCMSArticleLink(a.Id,c.Id);
		insert al;
		
		system.Test.setCurrentPage(Page.isll_Home);
		
		isll_AdditionalContentController contr = new isll_AdditionalContentController();
		
		system.assertEquals(1, contr.articlesList.size());
		
		system.assertEquals(1, contr.articles[0].links.size());
		
		contr.getShowEditLink();
		
	}
}