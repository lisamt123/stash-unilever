/**********************************************************************
Name: WINatPOSChatterUploadController_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for WINatPOSChatterUploadController
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          17/09/2014      INITIAL DEVELOPMENT
***********************************************************************/

@isTest(SeeAllData=true)
public class WINatPOSChatterUploadController_Test {
    /*******************************************************************
    Purpose: Method to test WINatPOSChatterUploadController with new files 
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testLinkChatterPost_NewFile () {
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
              
        String url = '/' + asset.Id + '?retUrl=' + asset.Id;
        System.Debug('url: ' + url);
        PageReference pageRef = new PageReference(url);
        Test.setCurrentPage(pageRef); 
        
        // Run the code that we want to test
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(file);
        WINatPOSChatterUploadController uploadController = new WINatPOSChatterUploadController(sc);
        PageReference page1 = uploadController.saveAndDisplayChatterFeed();
        
        FeedItem feedItem = new FeedItem();
        feedItem.Type = 'ContentPost';
        feedItem.parentId = file.Id;
        feedItem.Title = 'Dove';
        feedItem.ContentFileName = 'Dove.jpeg';
        feedItem.ContentData = Blob.ValueOf('/9j/4QAYRXhpZgAASUkqAAg');
        feedItem.Body = 'Promo is the UK';
        insert feedItem;
        
        PageReference page2 = uploadController.linkChatterContentPost();  
        System.Debug('page1: ' + page1);
        System.Debug('page2: ' + page2);  
        File__c f = [SELECT Id, Feed_Id__c FROM File__c WHERE Id = :file.Id];    
        Test.stopTest();
        
        // Assert test results
        System.assertEquals(url, page1.getUrl());
        // Begin Modified by ISzegedi 
        //String retUrl = '/' + asset.Id;
        String retUrl = asset.Id;
        // End Modified by ISzegedi 
        System.assertEquals(retUrl, page2.getUrl());
        //String retUrl = '/' + file.Id;
        //System.assertEquals(retUrl, page2.getUrl()); 
        
        System.assertEquals(f.Id, file.Id);  
        System.assertEquals(f.Feed_Id__c, feedItem.Id);  
    }
    
    /*******************************************************************
    Purpose: Method to test WINatPOSChatterUploadController with existing files
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testLinkChatterPost_ExistingFile () {
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
        
        
        System.Debug('**Asset Id: ' + asset.Id);
        System.Debug('**File Id: ' + file.Id);
        String url = '/' + file.Id + '?retUrl=' + asset.Id;
        System.Debug('url: ' + url);
        PageReference pageRef = new PageReference(url);
        Test.setCurrentPage(pageRef); 
        
        // Run the code that we want to test
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(file);
        WINatPOSChatterUploadController uploadController = new WINatPOSChatterUploadController(sc);
        PageReference page1 = uploadController.saveAndDisplayChatterFeed();
        PageReference page2 = uploadController.linkChatterContentPost();  
        System.Debug('page1: ' + page1);
        System.Debug('page2: ' + page2);  
        File__c f = [SELECT Id, Feed_Id__c FROM File__c WHERE Id = :file.Id];     
        Test.stopTest();
        
        // Assert test results
        System.assertEquals(url, page1.getUrl());
        // Begin Modified by ISzegedi 
        //String retUrl = '/' + asset.Id;
        String retUrl = asset.Id;
        // End Modified by ISzegedi 
        System.assertEquals(retUrl, page2.getUrl());  
        
        System.assertEquals(f.Id, file.Id);
        System.assertEquals(f.Feed_Id__c, feedItem.Id);    
    }
    
    /*******************************************************************
    Purpose: Method to test WinatPOSChatterUploadController with no return URL provided 
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testLinkChatterPost_NoRetUrl () {
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
               
        String url = '/' + asset.Id;
        System.Debug('url: ' + url);
        PageReference pageRef = new PageReference(url);
        Test.setCurrentPage(pageRef); 
        
        // Run the code that we want to test
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(file);
        WINatPOSChatterUploadController uploadController = new WINatPOSChatterUploadController(sc);
        PageReference page1 = uploadController.saveAndDisplayChatterFeed();
        
        FeedItem feedItem = new FeedItem();
        feedItem.Type = 'ContentPost';
        feedItem.parentId = file.Id;
        feedItem.Title = 'Dove';
        feedItem.ContentFileName = 'Dove.jpeg';
        feedItem.ContentData = Blob.ValueOf('/9j/4QAYRXhpZgAASUkqAAg');
        feedItem.Body = 'Promo is the UK';
        insert feedItem;
        
        PageReference page2 = uploadController.linkChatterContentPost();  
        System.Debug('page1: ' + page1);
        System.Debug('page2: ' + page2);  
        File__c f = [SELECT Id, Feed_Id__c FROM File__c WHERE Id = :file.Id];    
        Test.stopTest();
        
        // Assert test results
        System.assertEquals(url, page1.getUrl());
        String fid = file.Id;
        String noRetUrl = '/' + fid.substring(0,15);  // Use 15-digit version of the Id
        System.assertEquals(noRetUrl, page2.getUrl());   
        
        System.assertEquals(f.Id, file.Id);  
        System.assertEquals(f.Feed_Id__c, feedItem.Id);  
    }
    
    
     /*******************************************************************
    Purpose: Method to test WINatPOSChatterUploadController with new files 
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testLinkChatterPost_NewFilewithDMLException () {
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
        file.Category__c = cat.Id;  // You can only have either Asser or Category set - see File validation rules
        file.Type__c = 'Image';
              
        String url = '/' + asset.Id + '?retUrl=' + asset.Id;
        System.Debug('url: ' + url);
        PageReference pageRef = new PageReference(url);
        Test.setCurrentPage(pageRef); 
        
        // Run the code that we want to test
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(file);
        WINatPOSChatterUploadController uploadController = new WINatPOSChatterUploadController(sc);
        PageReference page1 = uploadController.saveAndDisplayChatterFeed();
        
        //PageReference page2 = uploadController.linkChatterContentPost();  
        System.Debug('page1: ' + page1);
        //System.Debug('page2: ' + page2);  
        List<File__c> fList = [SELECT Id, Feed_Id__c FROM File__c WHERE Id = :file.Id];    
        Test.stopTest();
        
        // Assert test results
        System.assertEquals(null, page1);
        System.assertEquals(0, fList.size());    
    }
    
    
    /*******************************************************************
    Purpose: Method to test WINatPOSChatterUploadController with new files 
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testLinkChatterPost_WithDMLUpdateException () {
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
        file.Name = 'DummyFileForDMLUpdateException';
        file.Asset__c = asset.Id;
        file.Type__c = 'Image';
              
        String url = '/' + asset.Id + '?retUrl=' + asset.Id;
        System.Debug('url: ' + url);
        PageReference pageRef = new PageReference(url);
        Test.setCurrentPage(pageRef); 
        
        // Run the code that we want to test
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(file);
        WINatPOSChatterUploadController uploadController = new WINatPOSChatterUploadController(sc);
        PageReference page1 = uploadController.saveAndDisplayChatterFeed();
        FeedItem feedItem = new FeedItem();
        feedItem.Type = 'ContentPost';
        feedItem.parentId = file.Id;
        feedItem.Title = 'Dove';
        feedItem.ContentFileName = 'Dove.jpeg';
        feedItem.ContentData = Blob.ValueOf('/9j/4QAYRXhpZgAASUkqAAg');
        feedItem.Body = 'Promo is the UK';
        insert feedItem;
        
        PageReference page2 = uploadController.linkChatterContentPost();  
        System.Debug('page1: ' + page1);
        //System.Debug('page2: ' + page2);  
        List<File__c> fList = [SELECT Id, Feed_Id__c FROM File__c WHERE Id = :file.Id];    
        Test.stopTest();
        
        // Assert test results
        System.assertEquals(null, page2);
        System.assertEquals(0, fList.size());    
    }
}