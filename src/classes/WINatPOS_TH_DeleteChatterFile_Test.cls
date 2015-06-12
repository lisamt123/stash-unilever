/**********************************************************************
Name: WINatPOS_TH_DeleteChatterFile_Test
Copyright © 2014 Unilever.
============================================================================
============================================================================
Purpose: Test class for WinatPOS_TH_DeleteChatterFile
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          17/09/2014                INITIAL DEVELOPMENT CSR:
***********************************************************************/

@isTest(SeeAllData=true)
public class WINatPOS_TH_DeleteChatterFile_Test {
    /*******************************************************************
    Purpose: Method to test WINatPOS 
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testDeleteFile () {
          // Create test data
        Category__c mainCat = new Category__c();
        mainCat.Name = 'Personal Care';
        mainCat.Type__c = 'Category Group';
        insert mainCat;
        
        Category__c cat = new Category__c();
        cat.Name = 'Deodorants';     
        cat.Type__c = 'Category';
        cat.Parent_Category__c = mainCat.Id;
        insert cat;
        
        Asset__c asset = new Asset__c();
        asset.Name = 'TestAsset';
        asset.Category__c = cat.Id;
        asset.Placement__c = 'Primary';
        asset.POS_Asset_Type__c = 'Masterbrand';
        asset.Market_Cluster__c = 'Global';
        asset.Status__c = 'Approved';
        insert asset;
        
        File__c file = new File__c();
        file.Name = 'TestFile';
        file.Asset__c = asset.Id;
        file.Type__c = 'Image';
        insert file;
        
        FeedItem feedItem = new FeedItem();
        feedItem.Type = 'ContentPost';
        feedItem.parentId = file.Id;
        feedItem.Title = 'Dove';
        feedItem.ContentFileName = 'Dove.jpeg';
        feedItem.ContentData = Blob.ValueOf('/9j/4QAYRXhpZgAASUkqAAg');
        feedItem.Body = 'Promo is the UK';
        insert feedItem;
        
        file.Feed_ID__c = feedItem.Id;
        update file;
        
        ConnectApi.FeedItem fi = ConnectApi.ChatterFeeds.getFeedItem(null, file.Feed_ID__c);      
        ConnectApi.ContentAttachment ca = (ConnectApi.ContentAttachment) fi.attachment;
        
        
        // Run the code that we want to test
        Test.startTest();
        delete file;
        Test.stopTest();
        
        List<File__c> fileList = [SELECT Id FROM File__c WHERE Id = :file.Id];
        List<FeedItem> feedItemList = [SELECT Id FROM FeedItem WHERE Id = :feedItem.Id];
        List<ContentDocument> contentDocumentList = [SELECT Id FROM ContentDocument WHERE Id = :ca.Id];
        
         // Assert test results
        System.assertEquals(0, fileList.size());
        System.assertEquals(0, feedItemList.size());
        System.assertEquals(0, contentDocumentList.size());
        
    }
    
    
        /*******************************************************************
    Purpose: Method to test WINatPOS 
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testDeleteFileWithDMLDeleteException () {
          // Create test data
        Category__c mainCat = new Category__c();
        mainCat.Name = 'Personal Care';
        mainCat.Type__c = 'Category Group';
        insert mainCat;
        
        Category__c cat = new Category__c();
        cat.Name = 'Deodorants';     
        cat.Type__c = 'Category';
        cat.Parent_Category__c = mainCat.Id;
        insert cat;
        
        Asset__c asset = new Asset__c();
        asset.Name = 'TestAsset';
        asset.Category__c = cat.Id;
        asset.Placement__c = 'Primary';
        asset.POS_Asset_Type__c = 'Masterbrand';
        asset.Market_Cluster__c = 'Global';
        asset.Status__c = 'Approved';
        insert asset;
        
        File__c file = new File__c();
        file.Name = 'DummyFileForDMLDeleteExceptionTest';
        file.Asset__c = asset.Id;
        file.Type__c = 'Image';
        insert file;
        
        FeedItem feedItem = new FeedItem();
        feedItem.Type = 'ContentPost';
        feedItem.parentId = file.Id;
        feedItem.Title = 'DummyFeedItemForDMLDeleteExceptionTest';
        feedItem.ContentFileName = 'DummyFileForDMLDeleteExceptionTest.jpeg';
        feedItem.ContentData = Blob.ValueOf('/9j/4QAYRXhpZgAASUkqAAg');
        feedItem.Body = 'Promo is the UK';
        insert feedItem;
        
        file.Feed_ID__c = feedItem.Id;
        update file;
        
        ConnectApi.FeedItem fi = ConnectApi.ChatterFeeds.getFeedItem(null, file.Feed_ID__c);      
        ConnectApi.ContentAttachment ca = (ConnectApi.ContentAttachment) fi.attachment;
        
        
        // Run the code that we want to test
        Test.startTest();
        delete file;
        Test.stopTest();
        
        List<File__c> fileList = [SELECT Id FROM File__c WHERE Id = :file.Id];
        
         // Assert test results
        System.assertEquals(0, fileList.size());
        
    }
    
}