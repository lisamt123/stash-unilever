/**********************************************************************
 Name:  isll_EditPageContentControllerTest
 Copyright © 2013  Unilever
======================================================
Purpose:                                                            
Test class for isll_EditPageContentController
======================================================
History
-------
VERSION     AUTHOR              DATE            DETAIL              Description
   1.0      Liza Romanenko      30/07/2013      INITIAL DEVELOPMENT 
***********************************************************************/
@isTest
private class isll_EditPageContentControllerTest {

    static testMethod void testController() {
    	
      CMS_Content__c img = isll_TestData.createCMSContent('Image');
    	insert img;
    	
      CMS_Article__c article    = isll_TestData.createCMSArticle();
      article.Media_Content__c  = img.Id;     
    	insert article;
        
       	
      ApexPages.currentPage().getParameters().put('page', 'Home');
       	
      isll_EditPageContentController contr = new isll_EditPageContentController();
       	
      contr.addContent();
      system.assertEquals('add', contr.pageMode);
      contr.cancel();
      system.assertEquals('view', contr.pageMode);
       	
     	contr.searchText = 'te';
     	contr.doSearch();
     	system.assertEquals(null, contr.searchedArticles);
       	
     	contr.searchText = 'Title';
     	contr.doSearch();
     	contr.searchedArticles = new List<isll_EditPageContentController.articleWrapper>();
     	contr.searchedArticles.add(new isll_EditPageContentController.articleWrapper(article));
     	system.assertEquals(1, contr.searchedArticles.size());
       	
     	contr.searchedArticles[0].isSelected = true;
     	contr.addSelected();
     	system.assertEquals(0, contr.searchedArticles.size());
     	system.assertEquals(1, contr.articlesList.size());
       	
     	contr.aId = contr.articlesList[0].Id;
       	
     	contr.deleteArticle();
     	system.assertEquals(0, contr.articlesList.size());
       	
     	contr.cerateNew();
    }
}