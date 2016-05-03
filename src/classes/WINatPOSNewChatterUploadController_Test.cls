/**********************************************************************
Name: WINatPOSNewChatterUploadController_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for WINatPOSNewChatterUploadController
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          27/10/2014      INITIAL DEVELOPMENT
***********************************************************************/
@isTest(SeeAllData=true)
public class WINatPOSNewChatterUploadController_Test {
	/*******************************************************************
    Purpose: Method to test WINatPOSNewChatterUploadController with new files 
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
        file.Sub_Type__c='Download Image';      
        String url = '/' + asset.Id + '?retUrl=' + asset.Id;
        System.Debug('url: ' + url);
        PageReference pageRef = new PageReference(url);
        Test.setCurrentPage(pageRef); 
        
        // Run the code that we want to test
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(file);
        WINatPOSNewChatterUploadController uploadController = new WINatPOSNewChatterUploadController(sc);
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
        file.Sub_Type__c='Download Image';
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
        WINatPOSNewChatterUploadController uploadController = new WINatPOSNewChatterUploadController(sc);
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
    Purpose: Method to test WINatPOSChatterUploadController with existing files
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testLinkChatterPost_ExistingFile1 () {
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
        file.Sub_Type__c='Download Image';
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
        WINatPOSNewChatterUploadController uploadController = new WINatPOSNewChatterUploadController(sc);
        PageReference page2 = uploadController.save();    
        Test.stopTest();
        
        // Assert test result
        String retUrl = asset.Id;
        // End Modified by ISzegedi 
        System.assertEquals(retUrl, page2.getUrl());  
           
    }
    
     /*******************************************************************
    Purpose: Method to test WINatPOSChatterUploadController with existing files
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testLinkChatterPost_TestRetrivingPiclists () {
        List<Category__c> finalTestCategory=new List<Category__c>();
        List<Brand_Master__c> finalTestBrands=new List<Brand_Master__c>();
        List<Category_Brands__c> finalCategoryBrand=new List<Category_Brands__c>();
        list<Asset__c> finalTestAsset=new List<Asset__c>();
        list<File__c> finalTestFiles=new List<File__c>();
        List<Asset_Group__c> finalTestAssetGroup = new List<Asset_Group__c>();
        List<Category__c> testCategories=new List<Category__c>();
        List<Brand_Master__c> testBrands=new List<Brand_Master__c>();
        List<Category_Brands__c> testCategoryBrand=new List<Category_Brands__c>();
        
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
        
        
        
        
        Category__c cat1 = new Category__c();
        cat1.Name = 'Hair Test';     
        cat1.Type__c = 'Category';
        cat1.Category_Logo__c='<img alt="User-added image" data-cke-saved-src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png" src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png">';
        cat1.Parent_Category__c = mainCat.Id;
        testCategories.add(cat1);
        
        insert cat1;
        
        
        
        //crete brands
        Brand_Master__c brandAxe=new Brand_Master__c();
        brandAxe.Primary_Category__c=cat.id;
        brandAxe.Name='Axe Test';
        brandAxe.Brand_Logo__c='<img alt="User-added image" data-cke-saved-src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png" src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png">';
        testBrands.add(brandAxe);
        
        Brand_Master__c brandDove=new Brand_Master__c();
        brandDove.Primary_Category__c=cat1.id;
        brandDove.Name='Dove Test';
        brandDove.Brand_Logo__c='<img alt="User-added image" data-cke-saved-src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png" src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png">';
        testBrands.add(brandDove);
        insert testBrands;
        
        
        //create category brand mappings
        Category_Brands__c catBrand=new Category_Brands__c();
        catBrand.Name='Deodorants - Axe Test';
        catBrand.Brand__c=brandAxe.id;
        catBrand.Category__c=cat.id;
        testCategoryBrand.add(catBrand);
        
        Category_Brands__c catBrand1=new Category_Brands__c();
        catBrand1.Name='Deodorants - Dove Test';
        catBrand1.Brand__c=brandDove.id;
        catBrand1.Category__c=cat.id;
        testCategoryBrand.add(catBrand1);
        
        Category_Brands__c catBrand2=new Category_Brands__c();
        catBrand2.Name='Hair - Axe Test';
        catBrand2.Brand__c=brandAxe.id;
        catBrand2.Category__c=cat1.id;
        testCategoryBrand.add(catBrand2);
        
        Category_Brands__c catBrand3=new Category_Brands__c();
        catBrand3.Name='Hair - Dove Test';
        catBrand3.Brand__c=brandDove.id;
        catBrand3.Category__c=cat1.id;
        testCategoryBrand.add(catBrand3);
        
        insert  testCategoryBrand;
        
        
        //create Assets
        Asset_Group__c assetGroup=new Asset_Group__c();
        assetGroup.Name='TestAssetGroup';
        assetGroup.Type__c='Masterbrand';
        assetGroup.Category__c=cat.Id;
        insert assetGroup;
        
        
        Asset__c asset1 = new Asset__c();
        asset1.Name = 'Uniq Test Asset 1';
        asset1.Category__c = cat1.Id;
        asset1.Brand__c=brandDove.id;
        asset1.Placement__c = 'Secondary';
        asset1.POS_Asset_Type__c = 'Innovation';
        asset1.Market_Cluster__c = 'Global';
        asset1.Channels__c='Hypermarkets';
        asset1.Status__c = 'Approved';
        asset1.Description__c='test';
        finalTestAsset.add(asset1);
        
        
        Asset__c asset2 = new Asset__c();
        asset2.Name = 'Uniq Test Asset 2';
        asset2.Category__c = cat1.Id;
        asset2.Brand__c=brandDove.id;
        asset2.Placement__c = 'Secondary';
        asset2.POS_Asset_Type__c = 'Innovation';
        asset2.Market_Cluster__c = 'Global';
        asset2.Channels__c='Hypermarkets';
        asset2.Status__c = 'Approved';
        asset2.Description__c='test';
        finalTestAsset.add(asset2);
        
        Asset__c asset3 = new Asset__c();
        asset3.Name = 'Uniq Test Asset 3';
        asset3.Category__c = cat1.Id;
        asset3.Brand__c=brandDove.id;
        asset3.Placement__c = 'Secondary';
        asset3.POS_Asset_Type__c = 'Best Practices';
        asset3.Market_Cluster__c = 'Global';
        asset3.Channels__c='Hypermarkets';
        asset3.Status__c = 'Approved';
        asset3.Description__c='test';
        finalTestAsset.add(asset3);
        
        Asset__c asset4 = new Asset__c();
        asset4.Name = 'Uniq Test Asset 4';
        asset4.Category__c = cat1.Id;
        asset4.Brand__c=brandDove.id;
        asset4.Placement__c = 'Secondary';
        asset4.POS_Asset_Type__c = 'Repeatable Model';
        asset4.Market_Cluster__c = 'Global';
        asset4.Channels__c='Hypermarkets';
        asset4.Status__c = 'Approved';
        asset4.Description__c='test';
        
        File__c file = new File__c();
        file.Name = 'TestFile';
        file.Asset__c = asset.Id;
        file.Type__c = 'Image';
        file.Sub_Type__c='Download Image';
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
        WINatPOSNewChatterUploadController uploadController = new WINatPOSNewChatterUploadController(sc);
        List<selectOption> catList=uploadController.getCategories();
        List<selectOption> brandList=uploadController.getBrands();
        List<selectOption> assetGroupList= uploadController.getAssetGroups();
        PageReference page2 = uploadController.save();    
        Test.stopTest();
        
        // Assert test result
        String retUrl = asset.Id;
        
        System.assertEquals(retUrl, page2.getUrl()); 
        System.assertEquals(true, catList.size()>0);
        System.assertEquals(true, brandList.size()>0);
        System.assertEquals(true, assetGroupList.size()>0);
           
    }
    /*******************************************************************
    Purpose: Method to test WINatPOSNewChatterUploadController with no return URL provided 
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
        file.Sub_Type__c='Download Image';
               
        String url = '/' + asset.Id;
        System.Debug('url: ' + url);
        PageReference pageRef = new PageReference(url);
        Test.setCurrentPage(pageRef); 
        
        // Run the code that we want to test
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(file);
        WINatPOSNewChatterUploadController uploadController = new WINatPOSNewChatterUploadController(sc);
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
    Purpose: Method to test WINatPOSNewChatterUploadController with new files 
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
        file.Sub_Type__c='Download Image';
              
        String url = '/' + asset.Id + '?retUrl=' + asset.Id;
        System.Debug('url: ' + url);
        PageReference pageRef = new PageReference(url);
        Test.setCurrentPage(pageRef); 
        
        // Run the code that we want to test
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(file);
        WINatPOSNewChatterUploadController uploadController = new WINatPOSNewChatterUploadController(sc);
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
    Purpose: Method to test WINatPOSNewChatterUploadController with new files 
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
        file.Sub_Type__c='Download Image';
              
        String url = '/' + asset.Id + '?retUrl=' + asset.Id;
        System.Debug('url: ' + url);
        PageReference pageRef = new PageReference(url);
        Test.setCurrentPage(pageRef); 
        
        // Run the code that we want to test
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(file);
        WINatPOSNewChatterUploadController uploadController = new WINatPOSNewChatterUploadController(sc);
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
        //System.assertEquals(null, page2);
        System.assertEquals(true, fList.size()>0);    
    }
    
    /*******************************************************************
    Purpose: Method to test WINatPOSNewChatterUploadController with new files 
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testCreateFileUnderParent () {
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
        
        //create Asset Group
        Asset_Group__c assetGroup=new Asset_Group__c();
        assetGroup.Name='TestAssetGroup';
        assetGroup.Type__c='Masterbrand';
        assetGroup.Category__c=cat.Id;
        insert assetGroup;

        //crete brands
        Brand_Master__c brandAxe=new Brand_Master__c();
        brandAxe.Primary_Category__c=cat.id;
        brandAxe.Name='Axe Test';
        brandAxe.Brand_Logo__c='<img alt="User-added image" data-cke-saved-src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png" src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png">';
        insert brandAxe;
        
        File__c fileForCategory = new File__c();
        fileForCategory.Name = 'File Created Under Category';
        fileForCategory.Category__c = cat.Id;
        fileForCategory.Type__c = 'Image';
        fileForCategory.Sub_Type__c='Download Image';
        fileForCategory.Is_Primary_Image__c=true;
        
        File__c fileForBrand = new File__c();
        fileForCategory.Name = 'File Created Under Brand';
        fileForBrand.Brand__c = brandAxe.Id;
        fileForBrand.Type__c = 'Image';
        fileForBrand.Sub_Type__c='Download Image';
        
        File__c fileForAsset = new File__c();
        fileForAsset.Name = 'File Created Under Asset';
        fileForAsset.Asset__c = asset.Id;
        fileForAsset.Type__c = 'Image';
        fileForAsset.Sub_Type__c='Download Image';
        fileForAsset.Is_Primary_Image__c=true;
        
        File__c fileForAssetGroup = new File__c();
        fileForAssetGroup.Name = 'File Created Under AssetGroup';
        fileForAssetGroup.Asset_Group__c = assetGroup.Id;
        fileForAssetGroup.Type__c = 'Image';
        fileForAssetGroup.Sub_Type__c='Download Image';
        
        File__c fileInvalidFileEmptySubType = new File__c();
        fileInvalidFileEmptySubType.Name = 'File Created Under AssetGroup';
        fileInvalidFileEmptySubType.Asset_Group__c = assetGroup.Id;
        fileInvalidFileEmptySubType.Type__c = 'Image';
        //fileForAssetGroup.Sub_Type__c='Download Image';
        //
        File__c fileCreatedUnderFileTab = new File__c();
        fileCreatedUnderFileTab.Name = 'File Created Under AssetGroup';
        fileCreatedUnderFileTab.Type__c = 'Image';
        fileCreatedUnderFileTab.Sub_Type__c='Download Image';
              
        //String url = '/' + cat.Id + '?retUrl=' + cat.Id;
        //System.Debug('url: ' + url);
        //PageReference pageRef = new PageReference(url);
        //Test.setCurrentPage(pageRef); 
        
        // Run the code that we want to test
        Test.startTest();
        ApexPages.StandardController scCategory = new ApexPages.StandardController(fileForCategory);
        WINatPOSNewChatterUploadController uploadController = new WINatPOSNewChatterUploadController(scCategory);
        List<selectOption> fileTypeSelctOptions=uploadController.getFileSubType();
        PageReference page1 = uploadController.saveAndDisplayChatterFeed();
        
        ApexPages.StandardController scBrand = new ApexPages.StandardController(fileForBrand);
        WINatPOSNewChatterUploadController uploadController1 = new WINatPOSNewChatterUploadController(scBrand);
        PageReference page2 = uploadController1.saveAndDisplayChatterFeed();
        
        ApexPages.StandardController scAsset = new ApexPages.StandardController(fileForAsset);
        WINatPOSNewChatterUploadController uploadController2 = new WINatPOSNewChatterUploadController(scAsset);
        PageReference page3 = uploadController2.saveAndDisplayChatterFeed();
        
        ApexPages.StandardController scAssetGroup = new ApexPages.StandardController(fileForAssetGroup);
        WINatPOSNewChatterUploadController uploadController3 = new WINatPOSNewChatterUploadController(scAssetGroup);
        PageReference page4 = uploadController3.saveAndDisplayChatterFeed();
        
        ApexPages.StandardController scAssetGroupInvFile = new ApexPages.StandardController(fileInvalidFileEmptySubType);
        WINatPOSNewChatterUploadController uploadController4 = new WINatPOSNewChatterUploadController(scAssetGroupInvFile);
        PageReference page5 = uploadController4.saveAndDisplayChatterFeed();
        Schema.DescribeSObjectResult r = File__c.sObjectType.getDescribe();
		String fileKeyPrefix = r.getKeyPrefix();
        String url='/'+fileKeyPrefix+'/o';
        ApexPages.currentPage().getParameters().put('retURL',url);
        ApexPages.StandardController scfileCreatedUnderFileTab = new ApexPages.StandardController(fileCreatedUnderFileTab);
        WINatPOSNewChatterUploadController uploadController5 = new WINatPOSNewChatterUploadController(scfileCreatedUnderFileTab);
        PageReference page6 = uploadController5.saveAndDisplayChatterFeed();
        PageReference page7 = uploadController5.rerenderFieldAccessiblity();
        
        //check primary image validation 
        File__c fileForAsset1 = new File__c();
        fileForAsset1.Name = 'File Created Under Asset 1';
        fileForAsset1.Asset__c = asset.Id;
        fileForAsset1.Type__c = 'Image';
        fileForAsset1.Sub_Type__c='Download Image';
        fileForAsset1.Is_Primary_Image__c=true; 
        
        ApexPages.StandardController scfilePrimaryImageVal = new ApexPages.StandardController(fileForAsset1);
        WINatPOSNewChatterUploadController uploadController6 = new WINatPOSNewChatterUploadController(scfilePrimaryImageVal);
        PageReference page8 = uploadController6.save();
        Test.stopTest();
        //check if data from asset was populated
        System.assertEquals(true, fileForAsset1.id == null);
        System.assertEquals(true, fileForAssetGroup.id != null);
    }
    
}