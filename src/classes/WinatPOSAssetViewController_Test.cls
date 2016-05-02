/**********************************************************************
Name: WINatPOSUtilRemoteActions_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for WinatPOSAssetViewController_Test
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          06/11/2014      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class WinatPOSAssetViewController_Test {
  /*******************************************************************
    Purpose: Helper class to create test data
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public class TestingHelper{
        public TestingHelper(){}
        public List<Category__c> finalTestCategory=new List<Category__c>();
        public List<Brand_Master__c> finalTestBrands=new List<Brand_Master__c>();
        public List<Category_Brands__c> finalCategoryBrand=new List<Category_Brands__c>();
        public list<Asset__c> finalTestAsset=new List<Asset__c>();
        public list<File__c> finalTestFiles=new List<File__c>();
        public List<Asset_Group__c> finalTestAssetGroup = new List<Asset_Group__c>();
        
        /*******************************************************************
        Purpose: Helper method to create test data
        Parameters: Void
        Returns: Void
        Throws [Exceptions]: [optional]
        ********************************************************************/
        public void prepareTestDataEnv(){
            List<Category__c> testCategories=new List<Category__c>();
            List<Brand_Master__c> testBrands=new List<Brand_Master__c>();
            List<Category_Brands__c> testCategoryBrand=new List<Category_Brands__c>();
            //start creating categories
            Category__c mainCat = new Category__c();
            mainCat.Name = 'Personal Care Test';
            mainCat.Type__c = 'Category Group';
            insert mainCat;
            
            //subCategory
            Category__c cat = new Category__c();
            cat.Name = 'Deodorants Test';     
            cat.Type__c = 'Category';
            cat.Category_Logo__c='<img alt="User-added image" data-cke-saved-src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png" src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png">';
            cat.Parent_Category__c = mainCat.Id;
            testCategories.add(cat);
            
            Category__c cat1 = new Category__c();
            cat1.Name = 'Hair Test';     
            cat1.Type__c = 'Category';
            cat1.Category_Logo__c='<img alt="User-added image" data-cke-saved-src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png" src="/resource/1413243108000/WinAtPosBrandsLogo/brands/axe.png">';
            cat1.Parent_Category__c = mainCat.Id;
            testCategories.add(cat1);
            
            insert testCategories;
            finalTestCategory=testCategories;
            
            
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
            finalTestBrands=testBrands;
            
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
            finalCategoryBrand=testCategoryBrand;
            
            //create Assets
            Asset_Group__c assetGroup=new Asset_Group__c();
            assetGroup.Name='TestAssetGroup';
            assetGroup.Type__c='Masterbrand';
            assetGroup.Category__c=cat.Id;
            insert assetGroup;
            finalTestAssetGroup.add(assetGroup);
            
            Asset__c asset = new Asset__c();
            asset.Name = 'Uniq Test Asset';
            asset.Asset_Group__c=assetGroup.id;
            asset.Category__c = cat.Id;
            asset.Brand__c = brandAxe.id;
            asset.Placement__c = 'Primary';
            asset.POS_Asset_Type__c = 'Masterbrand';
            asset.Market_Cluster__c = 'Global';
            asset.Channels__c='Cash & Carry;Convenience';
            asset.Status__c = 'Approved';
            asset.Carousel_Published__c=true;
            finalTestAsset.add(asset);
            
            Asset__c asset1 = new Asset__c();
            asset1.Name = 'Uniq Test Asset 1';
            asset1.Category__c = cat1.Id;
            asset1.Brand__c=brandDove.id;
            asset1.Placement__c = 'Secondary';
            asset1.POS_Asset_Type__c = 'Innovation';
            asset1.Market_Cluster__c = 'Global';
            asset1.Channels__c='Hypermarkets';
            asset1.Status__c = 'Approved';
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
            finalTestAsset.add(asset4);
            
            insert finalTestAsset;
            //insert asset;
            //create file and feed for assets
            File__c file = new File__c();
            file.Name = 'TestFile';
            file.Asset__c = asset.Id;
            file.Type__c = 'Image';
            file.Is_Primary_Image__c=true;
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
            file.Feed_Thumbnail_URL__c=null;
            update file;
            system.debug('file feed id after update: '+ file.Feed_ID__c);
            
            //create file for asset1
            File__c file1 = new File__c();
            file1.Name = 'TestFile';
            file1.Asset__c = asset1.Id;
            file1.Type__c = 'Image';
            file1.Is_Primary_Image__c=true;
            insert file1;
            
            FeedItem feedItem1 = new FeedItem();
            feedItem1.Type = 'ContentPost';
            feedItem1.parentId = file1.Id;
            feedItem1.Title = 'Dove';
            feedItem1.ContentFileName = 'Dove.jpeg';
            feedItem1.ContentData = Blob.ValueOf('/9j/4QAYRXhpZgAASUkqAAg');
            feedItem1.Body = 'Promo is the UK';
            insert feedItem1;
            
            file1.Feed_ID__c = feedItem1.Id;
            update file;
            
            file1.Feed_Thumbnail_URL__c=null;
            update file1;
            system.debug('file feed id after update: '+ file.Feed_ID__c);
            finalTestFiles.add(file);
            finalTestFiles.add(file1);
            
            
        }
    }
    
    /*******************************************************************
    Purpose: Method testing Controller and forward action 
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testApplicationUsage(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        Test.startTest();
        PageReference pageRef = Page.WinatPOSAssetViewForwarder;
        pageRef.getParameters().put('id',ts.finalTestAsset.get(0).id);
        Test.setCurrentPage(pageRef);
        WinatPOSAssetViewController assetViewCtrl=new WinatPOSAssetViewController(new ApexPages.StandardController(ts.finalTestAsset.get(0)));
        
        //test redirection to internal administrative page
        PageReference retrunedPageRef=assetViewCtrl.doAction();
        system.assertEquals(true, retrunedPageRef.getUrl().contains('WinatPOSAssetView'), 'user should be redirected to internal administrative asset page');
        //test redirection to WinAtPOS Asset detail page
        pageRef.getHeaders().put('Referer','apex/WinatPOSHomePage');
        WinatPOSAssetViewController assetViewCtrlWinAtPosPage=new WinatPOSAssetViewController(new ApexPages.StandardController(ts.finalTestAsset.get(0)));
        PageReference retrunedPageRef1=assetViewCtrlWinAtPosPage.doAction();
        system.assertEquals(true, retrunedPageRef1.getUrl().contains('WinatPOSHomePage'), 'user should be redirected to WinAtPOS asset detail page');
        test.stopTest();
    }
}