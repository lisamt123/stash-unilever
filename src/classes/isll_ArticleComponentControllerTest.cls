/**********************************************************************
 Name:  isll_ArticleComponentControllerTest
 Copyright © 2013  Unilever
======================================================
Purpose:                                                            
Test class for isll_ArticleComponentController
======================================================
History
-------
VERSION     AUTHOR              DATE            DETAIL              Description
   1.0      Liza Romanenko      30/07/2013      INITIAL DEVELOPMENT 
***********************************************************************/
@isTest
private class isll_ArticleComponentControllerTest {

    static testMethod void test_isll_ArticleComponentController() {
    	//create test data
    	
    	CMS_Article__c a = isll_TestData.createCMSArticle();
    	insert a;
    	
    	isll_ArticleComponentController contr = new isll_ArticleComponentController();
    	system.assertEquals(null, contr.article);
    	
    	contr.aName = a.Name;
    	system.assertEquals(a.Id, contr.article.Id);
    	
    	contr.getShowEditLink();
    	
    	system.assert(!contr.getShowMediaContent());
    }
}