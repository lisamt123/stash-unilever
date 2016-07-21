/**********************************************************************
 Name:  isll_ArticleEditControllerTest
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose: The test class for the feed item isll_ArticleEditController                                                        
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Shyam Bhundia     30/07/2013        INITIAL DEVELOPMENT         Story id:  
 
***********************************************************************/

@IsTest
private class  isll_ArticleEditControllerTest {

 public static string sample1='Something new';
 
    static testMethod void articleEditDataTest() {
        CMS_Article__c theArticle = isll_TestData.createCMSArticle();
        insert theArticle;

        ApexPages.StandardController sc = new ApexPages.standardController(theArticle);
        ApexPages.currentPage().getParameters().put('order','1');
        
        test.startTest();
            isll_ArticleEditController controller = new isll_ArticleEditController(sc);
        test.stopTest();

        system.assertEquals(theArticle.id , controller.article.id);
        system.assertEquals(theArticle.Body__c , controller.article.Body__c);
    }

    static testMethod void articleNewDataTest() {
        CMS_Article__c theArticle = isll_TestData.createCMSArticle();
        insert theArticle;

        ApexPages.StandardController sc = new ApexPages.standardController(new CMS_Article__c());
        
        test.startTest();
            isll_ArticleEditController controller = new isll_ArticleEditController(sc);
        test.stopTest();

        system.assertEquals(null , controller.article.id);
        system.assertEquals(null , controller.article.Body__c);
    }

    static testMethod void contentTypeListTest(){
        CMS_Article__c theArticle = isll_TestData.createCMSArticle();
        insert theArticle;

        ApexPages.StandardController sc = new ApexPages.standardController(theArticle);
        isll_ArticleEditController controller = new isll_ArticleEditController(sc);
        
        test.startTest();
            system.assertEquals(2,controller.contentTypeList.size());
        test.stopTest();
    }

    static testMethod void saveTest() {
        CMS_Article__c theArticle = isll_TestData.createCMSArticle();
        insert theArticle;

        ApexPages.StandardController sc = new ApexPages.standardController(theArticle);
        
        test.startTest();
            isll_ArticleEditController controller = new isll_ArticleEditController(sc);
            controller.article.Body__c = sample1;
            controller.contentType = 'Image';
            controller.save();
        test.stopTest();
        
        system.assertEquals(sample1, [select Body__c from CMS_Article__c where id = : theArticle.id].Body__c);
    }

    static testMethod void saveExistingMediaTest() {
        CMS_Article__c theArticle   = isll_TestData.createCMSArticle();
        insert theArticle;

        CMS_Content__c content      = isll_TestData.createCMSContent('Video');//new CMS_Content__c(Type__c = 'Video',   Name = 'blah');
        insert content;

        theArticle.Media_Content__c = content.id;
        update theArticle;
        
        ApexPages.StandardController sc = new ApexPages.standardController(theArticle);
        
        test.startTest();
            isll_ArticleEditController controller = new isll_ArticleEditController(sc);
            controller.article.Body__c = sample1;
            controller.save();
        test.stopTest();
        
        system.assertEquals(sample1, [select Body__c from CMS_Article__c where id = : theArticle.id].Body__c);
    }

    static testMethod void saveWithAttachmentTest() {
        CMS_Article__c theArticle = isll_TestData.createCMSArticle();
        insert theArticle;

        ApexPages.StandardController sc = new ApexPages.standardController(theArticle);
        isll_ArticleEditController controller = new isll_ArticleEditController(sc);
        controller.forPage = 'TestPage';
        controller.attachment.Name = 'Attachment';
        controller.attachment.Body =  Blob.valueOf('Attach body');

        test.startTest();
            controller.contentType = 'Image';
            controller.save();
        test.stopTest();
        
        theArticle = ([select Media_Content__c from CMS_Article__c where id = :theArticle.id]);
        system.assertEquals(1,[select id from Attachment where parentid = :theArticle.Media_Content__c].size());
    }

    static testMethod void saveBackTest() {
        CMS_Article__c theArticle = isll_TestData.createCMSArticle();
        insert theArticle;

        PageReference ret;
        ApexPages.StandardController sc = new ApexPages.standardController(theArticle);
        isll_ArticleEditController controller = new isll_ArticleEditController(sc);
        controller.retPage = 'http://www.google.com';
        
        test.startTest();
            controller.article.Body__c = sample1;
            controller.contentType = 'Image';
            ret = controller.saveAndBack();
        test.stopTest();
        
        system.assertEquals('http://www.google.com', ret.getUrl());
    }

    static testMethod void cancelTest() {
        CMS_Article__c theArticle = isll_TestData.createCMSArticle();
        insert theArticle;

        PageReference ret;
        ApexPages.StandardController sc = new ApexPages.standardController(theArticle);
        isll_ArticleEditController controller = new isll_ArticleEditController(sc);
        controller.retPage = 'http://www.google.com';
        
        test.startTest();
            controller.contentType = 'Image';
            ret = controller.cancel();
        test.stopTest();
        
        system.assertEquals('http://www.google.com', ret.getUrl());
    }

}