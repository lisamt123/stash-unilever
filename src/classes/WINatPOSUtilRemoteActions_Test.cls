/**********************************************************************
Name: WINatPOSUtilRemoteActions_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for WINatPOSPurgeStats
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          27/10/2014      INITIAL DEVELOPMENT
***********************************************************************/
@isTest
private class WINatPOSUtilRemoteActions_Test {
    
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
        Purpose: Helper method to create custom setting for WinAtPOSRemoteActions custom setting
        Parameters: Void
        Returns: Void
        Throws [Exceptions]: [optional]
        ********************************************************************/
        public void setCustomSettingForRemoteConf(){
            List<WinAtPOSRemoteActions__c> remConfLst=[SELECT Default_Image_Size__c,Default_Image_Url__c,Max_file_size__c,WinAtPosGroup__c,Name FROM WinAtPOSRemoteActions__c where name='WinAtPOSRemoteActionConf'];
            if(remConfLst.size()>0){
                //custom setting data is set modify data for test porpous
                WinAtPOSRemoteActions__c remConf=remConfLst.get(0);
                remConf.Default_Image_Size__c=12288;
                remConf.Default_Image_Url__c='/resource/winatposapp/images/emptydetail.png';
                remConf.Max_file_size__c=0;
                remConf.WinAtPosGroup__c='Global WIN@POS';
                update remConf;
            }else{
                //custom setting data not exist set data for test porpous
                WinAtPOSRemoteActions__c remConf = new WinAtPOSRemoteActions__c();
                remConf.Default_Image_Size__c=12288;
                remConf.Default_Image_Url__c='/resource/winatposapp/images/emptydetail.png';
                remConf.Max_file_size__c=0;
                remConf.WinAtPosGroup__c='Global WIN@POS';
                remConf.Name='WinAtPOSRemoteActionConf';
                insert remConf;
            }
        }
        
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
            asset.Country__c='UK';
            asset.Carousel_Published__c=true;
            asset.Description__c='test';
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
            finalTestAsset.add(asset4);
            
            insert finalTestAsset;
            //insert asset;
            //create file and feed for assets
            File__c file = new File__c();
            file.Name = 'TestFile';
            file.Asset__c = asset.Id;
            file.Type__c = 'Image';
            file.Is_Primary_Image__c=true;
            file.File_Size_Bytes__c=2000;
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
            file1.File_Size_Bytes__c=2000;
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
    Purpose: Method testing if menu for brands and Categories is retrived properly
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testGetMenuMethod(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        Test.startTest();
        WINatPOSRemoteActionWrapper response=WINatPOSUtilRemoteActions.getMenu();
        Test.stopTest();
        
        //check if proper data was returned
        system.debug(response);
        system.assertEquals('0',response.status,'method sould return 0 if no errors');   
        List<WINatPOSRemoteActionWrapper.MenuWrapper> menuWraps = (List<WINatPOSRemoteActionWrapper.MenuWrapper>)response.data;
        system.assertEquals(2, menuWraps.size(), 'method should return brands and categories');
    }
	
    /*******************************************************************
    Purpose: Method testing home page carusel
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testGetHomePageCarusel(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        Test.startTest();
        WINatPOSRemoteActionWrapper response=WINatPOSUtilRemoteActions.getHomePageCarusel();
        Test.stopTest();
        
        //check if proper data was returned
        system.debug(response);
        system.assertEquals('0',response.status,'method sould return 0 if no errors');   
        List<WINatPOSRemoteActionWrapper.AssetCaruselWrapper> assetsHomeCaruselPublished = (List<WINatPOSRemoteActionWrapper.AssetCaruselWrapper>)response.data;
        system.assertEquals(true, assetsHomeCaruselPublished.size()>0, 'method should return at least one asset for carusel');
    }
    
    /*******************************************************************
    Purpose: Method testing home page carusel
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testAddRemoveFollower(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        Test.startTest();
        //add follow on asset
        WINatPOSUtilRemoteActions.addFollower(ts.finalTestAsset.get(0).id);
        //execute with invailid id 
        WINatPOSUtilRemoteActions.addFollower('1234');
        //ass follow on asset group
        WINatPOSUtilRemoteActions.addFollower(ts.finalTestAssetGroup.get(0).id);
        Map<String,List<WINatPOSRemoteActionWrapper.AssetDetailStats>> mapOfStats=WINatPOSUtilRemoteActions.retriveStatistics(ts.finalTestFiles.get(0).id,ts.finalTestAsset.get(0).id);
        system.assertEquals(true, mapOfStats.containsKey('followStatistics'), 'method retriveStatistics should return follow statistics');
        
        //check if follow was added to asset
        system.assertEquals(true,[select ParentId, SubscriberId from EntitySubscription where ParentId =:ts.finalTestAsset.get(0).id and SubscriberId=:UserInfo.getUserId()].size() == 1,'user should be added to follow the asset');
        //test invalid parameter for removeFollow
        WINatPOSUtilRemoteActions.removeFollower('test');
        system.assertEquals(true,[select ParentId, SubscriberId from EntitySubscription where ParentId =:ts.finalTestAsset.get(0).id and SubscriberId=:UserInfo.getUserId()].size() == 1,'user should not be removed from follow the asset invailid id was passed');
        //check if follow was added for user to asset group
        system.assertEquals(true,[select ParentId, SubscriberId from EntitySubscription where ParentId =:ts.finalTestAssetGroup.get(0).id and SubscriberId=:UserInfo.getUserId()].size() == 1,'user should be added to follow the asset group');   
        
        //remove follow on asset
        WINatPOSUtilRemoteActions.removeFollower(ts.finalTestAsset.get(0).id);
        //remove follow on asset group
        WINatPOSUtilRemoteActions.removeFollower(ts.finalTestAssetGroup.get(0).id);
        
        //check if follow was added to asset
        system.assertEquals(true,[select ParentId, SubscriberId from EntitySubscription where ParentId =:ts.finalTestAsset.get(0).id and SubscriberId=:UserInfo.getUserId()].size() == 0,'user should not have set follow on asset');
        //check if follow was added for user to asset group
        system.assertEquals(true,[select ParentId, SubscriberId from EntitySubscription where ParentId =:ts.finalTestAssetGroup.get(0).id and SubscriberId=:UserInfo.getUserId()].size() == 0,'user should not have set follow on asset group');   
        
        //test invalid parameter for addFollow
        WINatPOSUtilRemoteActions.addFollower('test');
        system.assertEquals(true,[select ParentId, SubscriberId from EntitySubscription where ParentId =:ts.finalTestAsset.get(0).id and SubscriberId=:UserInfo.getUserId()].size() == 0,'user should not be added to follow invailid id was passed');
        
        
        Test.stopTest();
        
    }
    
    /*******************************************************************
    Purpose: Method testing home page carusel
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testGetAssetDetailData(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        
        CollaborationGroup colGroup=new CollaborationGroup();
        colGroup.CollaborationType='Private';
        colGroup.Name=WinAtPOSUtil.winAtPostChatterGroupForTest;
        insert colGroup;
        
        Profile p = [select id from profile where name='Standard User'];
        User u = new User(alias = 'WinPT21', email='standarduser21@testorg.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username='standarduserTest21@testorg.com');
		insert u;
        
        CollaborationGroupMember colMember=new CollaborationGroupMember();
        colMember.CollaborationGroupId=colGroup.id;
        colMember.MemberId=u.id;
        insert colMember;
        
        Asset_Group__c assetGroup=new Asset_Group__c();
        assetGroup.Name='TestAssetGroup';
        assetGroup.Type__c='Masterbrand';
        assetGroup.Category__c=null;
        insert assetGroup;
        
        Test.startTest();
        WINatPOSRemoteActionWrapper responseAssetInvailidId=WINatPOSUtilRemoteActions.getAssetDetailData('1234');
        //follow the asset
        WINatPOSUtilRemoteActions.addFollower(ts.finalTestAsset.get(0).id);
        //follow the asset group
        WINatPOSUtilRemoteActions.addFollower(assetGroup.id);
        //share asset file with current use
        WINatPOSUtilRemoteActions.shareAssetFile(ts.finalTestFiles.get(0).Feed_ID__c,u.id);
        WINatPOSRemoteActionWrapper responseAsset=WINatPOSUtilRemoteActions.getAssetDetailData(ts.finalTestAsset.get(0).id);
        WINatPOSRemoteActionWrapper responseAssetGroup=WINatPOSUtilRemoteActions.getAssetDetailData(ts.finalTestAssetGroup.get(0).id);
        WINatPOSRemoteActionWrapper responseEmptyAssetGroup=WINatPOSUtilRemoteActions.getAssetDetailData(assetGroup.id);
        Test.stopTest();
        
        //check if proper data was returned
        system.debug(responseAsset);
        system.assertEquals('0',responseAsset.status,'method sould return 0 if no errors');
        system.assertEquals('0',responseAssetGroup.status,'method sould return 0 if no errors');
        system.assertEquals('0',responseEmptyAssetGroup.status,'method sould return 0 if no errors');
        //system.assertEquals('0',responseAssetInvailidId.status,'method sould return 1 invailid id was passed');
        List<WINatPOSRemoteActionWrapper.AssetsDetaislWrapper> assetsDetail = (List<WINatPOSRemoteActionWrapper.AssetsDetaislWrapper>)responseAsset.data;
        List<WINatPOSRemoteActionWrapper.AssetsDetaislWrapper> assetsGroupDetail = (List<WINatPOSRemoteActionWrapper.AssetsDetaislWrapper>)responseAsset.data;
        system.assertEquals(true, assetsDetail.size()>0, 'method should return at least one asset for asset detail page');
        system.assertEquals(true, assetsGroupDetail.size()>0, 'method should return at least one asset for asset Group detail page');
    }
    
    /*******************************************************************
    Purpose: Method testing retriving files for brand
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testGetFilesForBrandId(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        //crete file for brand
        File__c file = new File__c();
        file.Name = 'TestFile for Brand';
        file.Brand__c = ts.finalTestBrands.get(0).id;
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
        Test.startTest();
        WINatPOSRemoteActionWrapper responseFail=WINatPOSUtilRemoteActions.getFilesForBrandId('');
        system.assertEquals('1', responseFail.status, 'invailid parameter was passed method should return error');
        WINatPOSRemoteActionWrapper responseFilesForBrand=WINatPOSUtilRemoteActions.getFilesForBrandId(ts.finalTestBrands.get(0).id);       
        Test.stopTest();
        
        system.assertEquals('0', responseFilesForBrand.status, 'method should response with success');
        List<File__c> listOfFilesForBrand=(List<File__c>)responseFilesForBrand.data;
        system.assertEquals(1,listOfFilesForBrand.size(),'method should return one file');
        
    }
    /*******************************************************************
    Purpose: Method testing if retrive users from group working properly
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static void testRetriveUserFromWinAtPosGroup(){
      	//global Win@POS
        CollaborationGroup colGroup=new CollaborationGroup();
        colGroup.CollaborationType='Private';
        colGroup.Name=WinAtPOSUtil.winAtPostChatterGroupForTest;
        insert colGroup;
        
        Profile p = [select id from profile where name='Standard User'];
        User u = new User(alias = 'WinPT21', email='standarduser21@testorg.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username='standarduserTest21@testorg.com');
		insert u;
        
        CollaborationGroupMember colMember=new CollaborationGroupMember();
        colMember.CollaborationGroupId=colGroup.id;
        colMember.MemberId=u.id;
        insert colMember;
        Test.startTest();
        WINatPOSRemoteActionWrapper response=WINatPOSUtilRemoteActions.retriveUserFromWinAtPosGroup();
        Test.stopTest();
        
        List<WINatPOSRemoteActionWrapper.ChatterGroupMember> chatGroup=(List<WINatPOSRemoteActionWrapper.ChatterGroupMember>)response.data;
        system.assertEquals('0', response.status, 'method should return status 0 == no errors');
        system.assertEquals(2, chatGroup.size(), 'method should return 2 members of group global Win@POS');
    }
    /*******************************************************************
    Purpose: Method testing adding download to download statistics for single file
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testaddRecordToDonwloadStatistics(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        File__c inputFile=ts.finalTestFiles.get(0);
        test.startTest();
        WINatPOSUtilRemoteActions.addRecordToDonwloadStatistics(inputFile.Feed_ID__c, inputFile.id);
        test.stopTest();
        
        //check if file was added to downloadStats
        List<Download_Statistics__c> downloadStats=[select id from Download_Statistics__c where Downloaded_By__c =: UserInfo.getUserId() and FileId__c =: inputFile.id];
        system.assertEquals(1, downloadStats.size(), 'file should be counted to dwonload statistics');
    }
    
    /*******************************************************************
    Purpose: Method testing adding download to download statistics for multipe files
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testaddRecordsToDonwloadStatisticsAndRetrive(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        //prepare initial map of files which will be added to download statistics
        Map<String,String> inputFileMap=new Map<String,String>{ts.finalTestFiles.get(0).id => ts.finalTestFiles.get(0).Feed_ID__c,
            												   ts.finalTestFiles.get(1).id => ts.finalTestFiles.get(1).Feed_ID__c};
       
        test.startTest();
        WINatPOSUtilRemoteActions.addRecordsToDonwloadStatistics(inputFileMap);
         Map<String,List<WINatPOSRemoteActionWrapper.AssetDetailStats>> mapOfStats=WINatPOSUtilRemoteActions.retriveStatistics(ts.finalTestFiles.get(0).id,ts.finalTestAsset.get(0).id);
        test.stopTest();
        
        //check if file was added to downloadStats
        List<Download_Statistics__c> downloadStats=[select id from Download_Statistics__c where Downloaded_By__c =: UserInfo.getUserId() and FileId__c in : inputFileMap.keySet()];
        system.assertEquals(2, downloadStats.size(), 'files should be counted to dwonload statistics');
        //check if retrive method for statistics work properly shoud return download for asset
        system.assertEquals(true, mapOfStats.containsKey('downloadStatistics'), 'method retrive statistics shour return stasitic for download');
    }
    
    /*******************************************************************
    Purpose: Method testing add share on file and check if was added to statistics
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testshareFileRecordAndRetriveStatistic(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        //prepare initial map of files which will be added to share statistics
       
        test.startTest();
        WINatPOSUtilRemoteActions.shareAssetFile(ts.finalTestFiles.get(0).Feed_ID__c,UserInfo.getUserId());
         Map<String,List<WINatPOSRemoteActionWrapper.AssetDetailStats>> mapOfStats=WINatPOSUtilRemoteActions.retriveStatistics(ts.finalTestFiles.get(0).id,ts.finalTestAsset.get(0).id);
        test.stopTest();
        
        //check if file was added to downloadStats
        //check if retrive method for statistics work properly shoud return download for asset
        system.assertEquals(true, mapOfStats.containsKey('shareStatistics'), 'method retrive statistics shour return stasitic for share');
    }
    
    /*******************************************************************
    Purpose: Method testing retriving files for brand
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testGetFilesForCategoryId(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        //crete file for brand
        File__c file = new File__c();
        file.Name = 'TestFile for Brand';
        file.Category__c = ts.finalTestCategory.get(0).id;
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
        Test.startTest();
        WINatPOSRemoteActionWrapper responseFail=WINatPOSUtilRemoteActions.getFilesForCategoryId('');
        system.assertEquals('1', responseFail.status, 'invailid parameter was passed method should return error');
        WINatPOSRemoteActionWrapper responseFilesForCategory=WINatPOSUtilRemoteActions.getFilesForCategoryId(ts.finalTestCategory.get(0).id);       
        Test.stopTest();
        
        system.assertEquals('0', responseFilesForCategory.status, 'method should response with success');
        List<File__c> listOfFilesForCategory=(List<File__c>)responseFilesForCategory.data;
        system.assertEquals(1,listOfFilesForCategory.size(),'method should return one file');
        
    }
    
    /*******************************************************************
    Purpose: Method testing retriving files for asset
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testGetFileListForAsset(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        Test.startTest();
        WINatPOSRemoteActionWrapper responseFail=WINatPOSUtilRemoteActions.getFileListForAsset('');
        system.assertEquals('1', responseFail.status, 'invailid parameter was passed method should return error');
        WINatPOSRemoteActionWrapper responseFilesForAsset=WINatPOSUtilRemoteActions.getFileListForAsset(ts.finalTestAsset.get(0).id);       
        Test.stopTest();
        
        system.assertEquals('0', responseFilesForAsset.status, 'method should response with success');
        List<File__c> listOfFilesForAsset=(List<File__c>)responseFilesForAsset.data;
        system.assertEquals(1,listOfFilesForAsset.size(),'method should return one file');
        
    }
    
    /*******************************************************************
    Purpose: Method testing search method keyword combinations
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testSearchByKeyword(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        ts.setCustomSettingForRemoteConf();
        Test.startTest();
        //test keyword search where keyword = asset name
        system.debug('*****testSearchByKeyword initialize keyword search');
        List<id> assetsToReturn =new List<Id>();
        for(Asset__c a: ts.finalTestAsset){
            assetsToReturn.add(a.id);
        }
        assetsToReturn.add(ts.finalTestAssetGroup.get(0).id);
        test.setFixedSearchResults(assetsToReturn);
        WINatPOSRemoteActionWrapper response=WINatPOSUtilRemoteActions.search(WinAtPOSUtil.keywordSearch, '','',ts.finalTestAsset.get(0).Name,'','','','','',15,1,true);
        system.assertEquals('0', response.status, 'method should response with success');
        WINatPOSRemoteActionWrapper responseForPDF=WINatPOSUtilRemoteActions.getSearchResultListPdf(WinAtPOSUtil.keywordSearch, '','',ts.finalTestAsset.get(0).Name,'','','','','',15,1,true);
        system.assertEquals('-1', responseForPDF.status);
        List<WINatPOSRemoteActionWrapper.SearchWrapper> searchResult=(List<WINatPOSRemoteActionWrapper.SearchWrapper>)response.data;
        List<WINatPOSRemoteActionWrapper.AssetResultWrapper> assetResults=searchResult.get(0).assetSearchResult;
        system.assertEquals(true, assetResults.size()>0, 'search method should return at least one record');
        List<WINatPOSRemoteActionWrapper.AssetDetailForPDF> searchPDFResult=(List<WINatPOSRemoteActionWrapper.AssetDetailForPDF>)responseForPDF.data;
        system.assertEquals(true, searchPDFResult.size()==0);
        
        
        WINatPOSRemoteActionWrapper responseForCategoryCarusel=WINatPOSUtilRemoteActions.getCaruselForBrandOrCategory(WinAtPOSUtil.keywordSearch, null,null,'Hair Test or Axe Test');
        List<WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper> categoryCaruselResult=(List<WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper>)responseForCategoryCarusel.data;
        //system.assertEquals(true, categoryCaruselResult.size()>0, 'search method should return at least one record for category');
        Test.stopTest();
        
    }
    
    /*******************************************************************
    Purpose: Method testing search for brand and category carusel
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testForBrandCategoryCarusel(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        File__c file = new File__c();
        file.Name = 'TestFile';
        file.Category__c = ts.finalTestAsset.get(0).Category__c;
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
        
        File__c file1 = new File__c();
        file1.Name = 'TestFile';
        file1.Brand__c = ts.finalTestAsset.get(0).Brand__c;
        file1.Type__c = 'Image';
        insert file1;
        
        FeedItem feedItem1 = new FeedItem();
        feedItem1.Type = 'ContentPost';
        feedItem1.parentId = file.Id;
        feedItem1.Title = 'Dove';
        feedItem1.ContentFileName = 'Dove.jpeg';
        feedItem1.ContentData = Blob.ValueOf('/9j/4QAYRXhpZgAASUkqAAg');
        feedItem1.Body = 'Promo is the UK';
        insert feedItem1;
        
        file1.Feed_ID__c = feedItem1.Id;
        update file1;
        Test.startTest();
        //test keyword search where keyword = asset name
        system.debug('*****testSearchByKeyword initialize keyword search');
        List<id> brandAndCategoryId =new List<Id>();
        brandAndCategoryId.add(ts.finalTestAsset.get(0).Brand__c);
        brandAndCategoryId.add(ts.finalTestAsset.get(0).Category__c);
        test.setFixedSearchResults(brandAndCategoryId);
        WINatPOSRemoteActionWrapper responseForCategoryCarusel=WINatPOSUtilRemoteActions.getCaruselForBrandOrCategory(WinAtPOSUtil.keywordSearch, null,null,'Deodorants Test or Axe Test');
        List<WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper> categoryCaruselResult=(List<WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper>)responseForCategoryCarusel.data;
        system.assertEquals(true, categoryCaruselResult.size() == 2, 'method should find 2 carusels one for Category and one for brand');
        Test.stopTest();
        
    }
    
    /*******************************************************************
    Purpose: Method testing search method categorySearch
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testSearchByCategory(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        File__c file = new File__c();
        file.Name = 'TestFile';
        file.Category__c = ts.finalTestAsset.get(0).Category__c;
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
        
        Test.startTest();
        //test keyword search where keyword = asset name
        WINatPOSRemoteActionWrapper response=WINatPOSUtilRemoteActions.search(WinAtPOSUtil.categorySearch, '',ts.finalTestAsset.get(0).Category__c,'','','','','','',15,1,true);
        WINatPOSRemoteActionWrapper responseInvCategoryId=WINatPOSUtilRemoteActions.search(WinAtPOSUtil.categorySearch, '','1234','','','','','','',15,1,true);
        WINatPOSRemoteActionWrapper responseInvWithoutSearchType=WINatPOSUtilRemoteActions.search('', '','','','','','','','',15,1,true);
        
        system.assertEquals('0', response.status, 'method should response with success');
        List<WINatPOSRemoteActionWrapper.SearchWrapper> searchResult=(List<WINatPOSRemoteActionWrapper.SearchWrapper>)response.data;
        List<WINatPOSRemoteActionWrapper.AssetResultWrapper> assetResults=searchResult.get(0).assetSearchResult;
        system.assertEquals(true, assetResults.size()>0, 'search method should return at least one record');
        system.assertEquals('1', responseInvCategoryId.status, 'search method was executed with ivailid category id and status should be 1');
        system.assertEquals('1', responseInvWithoutSearchType.status, 'search method was executed without search type method should return status= 1');
        
        WINatPOSRemoteActionWrapper responseForCategoryCarusel=WINatPOSUtilRemoteActions.getCaruselForBrandOrCategory(WinAtPOSUtil.categorySearch, null,ts.finalTestAsset.get(0).Category__c,null);
        List<WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper> categoryCaruselResult=(List<WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper>)responseForCategoryCarusel.data;
        system.assertEquals(true, categoryCaruselResult.size()>0, 'search method should return at least one record for category');
        Test.stopTest();
        
    }
    
    /*******************************************************************
    Purpose: Method testing search method brandSearch
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testSearchByBrand(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        File__c file = new File__c();
        file.Name = 'TestFile';
        file.Brand__c = ts.finalTestAsset.get(0).Brand__c;
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
        Test.startTest();
        //test keyword search where keyword = asset name
        WINatPOSRemoteActionWrapper response=WINatPOSUtilRemoteActions.search(WinAtPOSUtil.brandSearch, ts.finalTestAsset.get(0).Brand__c,'','','','','','','',15,1,true);
        WINatPOSRemoteActionWrapper responseForBrandCarusel=WINatPOSUtilRemoteActions.getCaruselForBrandOrCategory(WinAtPOSUtil.brandSearch, ts.finalTestAsset.get(0).Brand__c,null,null);
        WINatPOSRemoteActionWrapper responseInvBrandId=WINatPOSUtilRemoteActions.search(WinAtPOSUtil.brandSearch, '124','','','','','','','',15,1,true);
        system.assertEquals('0', response.status, 'method should response with success');
        system.assertEquals('0', responseForBrandCarusel.status, 'method should response with success');
        List<WINatPOSRemoteActionWrapper.SearchWrapper> searchResult=(List<WINatPOSRemoteActionWrapper.SearchWrapper>)response.data;
        List<WINatPOSRemoteActionWrapper.AssetResultWrapper> assetResults=searchResult.get(0).assetSearchResult;
        
        List<WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper> brandCaruselResult=(List<WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper>)responseForBrandCarusel.data;
         system.assertEquals(true, brandCaruselResult.size()>0, 'search method should return at least one record');
        
        system.assertEquals(true, assetResults.size()>0, 'search method should return at least one record');
        system.assertEquals('1', responseInvBrandId.status, 'search method was executed with ivailid brand id and status should be 1');
        Test.stopTest();
        
    }
    
    /*******************************************************************
    Purpose: Method testing search method innovation search
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testInnovationSearch(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        Test.startTest();
        //test keyword search where keyword = asset name
        WINatPOSRemoteActionWrapper response=WINatPOSUtilRemoteActions.search(WinAtPOSUtil.innovationSearch, '','','','','','','','',15,1,true);
        WINatPOSRemoteActionWrapper responseInvPar=WINatPOSUtilRemoteActions.search(WinAtPOSUtil.innovationSearch, '','','',ts.finalTestAsset.get(0).POS_Asset_Type__c,'','','','',15,1,true);
        system.assertEquals('0', response.status, 'method should response with success');
        List<WINatPOSRemoteActionWrapper.SearchWrapper> searchResult=(List<WINatPOSRemoteActionWrapper.SearchWrapper>)response.data;
        List<WINatPOSRemoteActionWrapper.AssetResultWrapper> assetResults=searchResult.get(0).assetSearchResult;
        system.assertEquals(true, assetResults.size()>0, 'search method should return at least one record');
        system.assertEquals('1', responseInvPar.status, 'search method executed with wrong parameter should return errror');
        Test.stopTest();
        
    }
    
    /*******************************************************************
    Purpose: Method testing search method instoreSearch search
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testInstoreSearch(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        Test.startTest();
        //test keyword search where keyword = asset name
        WINatPOSRemoteActionWrapper response=WINatPOSUtilRemoteActions.search(WinAtPOSUtil.bestPracticesSearch, '','','','','','','','',15,1,true);
        WINatPOSRemoteActionWrapper responseInvPar=WINatPOSUtilRemoteActions.search(WinAtPOSUtil.bestPracticesSearch, '','','',ts.finalTestAsset.get(0).POS_Asset_Type__c,'','','','',15,1,true);
        system.assertEquals('0', response.status, 'method should response with success');
        List<WINatPOSRemoteActionWrapper.SearchWrapper> searchResult=(List<WINatPOSRemoteActionWrapper.SearchWrapper>)response.data;
        List<WINatPOSRemoteActionWrapper.AssetResultWrapper> assetResults=searchResult.get(0).assetSearchResult;
        system.assertEquals(true, assetResults.size()>0, 'search method should return at least one record');
        system.assertEquals('1', responseInvPar.status, 'search method executed with wrong parameter should return errror');
        Test.stopTest();
        
    }
    
    /*******************************************************************
    Purpose: Method testing search method repetableSearch 
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testRepetableSearch(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        Test.startTest();
        //test keyword search where keyword = asset name
        WINatPOSRemoteActionWrapper response=WINatPOSUtilRemoteActions.search(WinAtPOSUtil.repetableSearch, '','','','','','','','',15,1,true);
        WINatPOSRemoteActionWrapper responseInvPar=WINatPOSUtilRemoteActions.search(WinAtPOSUtil.repetableSearch, '','','',ts.finalTestAsset.get(0).POS_Asset_Type__c,'','','','',15,1,true);
        system.assertEquals('0', response.status, 'method should response with success');
        List<WINatPOSRemoteActionWrapper.SearchWrapper> searchResult=(List<WINatPOSRemoteActionWrapper.SearchWrapper>)response.data;
        List<WINatPOSRemoteActionWrapper.AssetResultWrapper> assetResults=searchResult.get(0).assetSearchResult;
        system.assertEquals(true, assetResults.size()>0, 'search method should return at least one record');
        system.assertEquals('1', responseInvPar.status, 'search method executed with wrong parameter should return errror');
        Test.stopTest();
        
    }
    
    /*******************************************************************
    Purpose: Method testing search method keyword and additional filters
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testCombineSearch(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        Test.startTest();
        //test keyword search where keyword = asset name
        system.debug('*****testtestCombineSearch initialize keyword search');
        system.debug(ts.finalTestAsset.get(0).Name);
        List<id> assetsToReturn =new List<Id>();
        for(Asset__c a: ts.finalTestAsset){
            assetsToReturn.add(a.id);
        }
        assetsToReturn.add(ts.finalTestAssetGroup.get(0).id);
        test.setFixedSearchResults(assetsToReturn);
        WINatPOSRemoteActionWrapper response=WINatPOSUtilRemoteActions.search(WinAtPOSUtil.keywordSearch, '','',ts.finalTestAsset.get(0).Name,'','',ts.finalTestAsset.get(0).Market_Cluster__c,'','',15,1,true);
        system.assertEquals('0', response.status, 'method should response with success');
        List<WINatPOSRemoteActionWrapper.SearchWrapper> searchResult=(List<WINatPOSRemoteActionWrapper.SearchWrapper>)response.data;
        List<WINatPOSRemoteActionWrapper.AssetResultWrapper> assetResults=searchResult.get(0).assetSearchResult;
        system.assertEquals(true, assetResults.size()>0, 'search method should return at least one record');
        Test.stopTest();
        
    }
    
    /*******************************************************************
    Purpose: Method testing search method keyword with all additional filters
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testCombineSearchWithAllFilters(){
        Test.startTest();
        WINatPOSRemoteActionWrapper responseWithEmptySearch=WINatPOSUtilRemoteActions.search(WinAtPOSUtil.keywordSearch, '','','','','','','Test','',15,1,true);
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        
        //test keyword search where keyword = asset name
        system.debug('*****testtestCombineSearch initialize keyword search');
        system.debug(ts.finalTestAsset.get(0).Name);
        List<id> assetsToReturn = new List<Id>();
        for(Asset__c a: ts.finalTestAsset){
            assetsToReturn.add(a.id);
        }
        assetsToReturn.add(ts.finalTestAssetGroup.get(0).id);
        test.setFixedSearchResults(assetsToReturn);
        
        WINatPOSRemoteActionWrapper response=WINatPOSUtilRemoteActions.search(WinAtPOSUtil.keywordSearch, ts.finalTestAsset.get(0).Brand__c,ts.finalTestAsset.get(0).Category__c,ts.finalTestAsset.get(0).Name,ts.finalTestAsset.get(0).POS_Asset_Type__c,ts.finalTestAsset.get(0).Channels__c,ts.finalTestAsset.get(0).Market_Cluster__c,ts.finalTestAsset.get(0).Placement__c,ts.finalTestAsset.get(0).Country__c,15,1,true);
        system.assertEquals('0', response.status, 'method should response with success');
        String outputKeyword=WINatPOSUtilRemoteActions.buildKeyword('smaple or test');
        system.assertEquals(true, outputKeyword.contains('"'));
        String outputKeyword1=WINatPOSUtilRemoteActions.processSearchTerms('smaple test');
        system.assertEquals(true, outputKeyword1.contains('OR'));                     
        List<WINatPOSRemoteActionWrapper.SearchWrapper> searchResult=(List<WINatPOSRemoteActionWrapper.SearchWrapper>)response.data;
        List<WINatPOSRemoteActionWrapper.AssetResultWrapper> assetResults=searchResult.get(0).assetSearchResult;
        system.assertEquals(true, assetResults.size()>0, 'search method should return at least one record');
        Test.stopTest();
        
    }
    
    /*******************************************************************
    Purpose: Method testing if retrive annoucement from group
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    
    static testMethod void testgetAccoucmentForGroupWithError(){
      	//crate a group
        CollaborationGroup colGroup=new CollaborationGroup();
        colGroup.CollaborationType='Public';
        colGroup.Name=WinAtPOSUtil.winAtPostChatterGroupForTest;
        insert colGroup;
        
        //create annoucement 
        FeedItem fItem = new FeedItem();
        fItem.Body='Test Annoucment ';
        fItem.ParentId=colGroup.id;
        fItem.Type='AdvancedTextPost';
        fItem.Title='Welcome in Test';
        insert fItem;
        
        Test.startTest();
        WINatPOSRemoteActionWrapper response=WINatPOSUtilRemoteActions.getAnnouncementForGroup(null);
        Test.stopTest();
        
        List<feedItem> fItemLst=[select id FROM FeedItem WHERE Type = 'AdvancedTextPost' and ParentId =:colGroup.id ];
        system.assertEquals(true, fItemLst.size() == 1 , 'There should be created only one announcement in test group');
    }
    
    /*******************************************************************
    Purpose: Method testing if retrive annoucement from group
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testgetAccoucmentForGroupWith(){
      	//crate a group
        CollaborationGroup colGroup=new CollaborationGroup();
        colGroup.CollaborationType='Public';
        colGroup.Name=WinAtPOSUtil.winAtPostChatterGroupForTest;
        insert colGroup;
        Test.startTest();
        WINatPOSRemoteActionWrapper responseWithoutAnnoucement=WINatPOSUtilRemoteActions.getAnnouncementForGroup(null);
        //create annoucement 
        FeedItem fItem = new FeedItem();
        fItem.Body='Test Annoucment ';
        fItem.ParentId=colGroup.id;
        fItem.Type='AdvancedTextPost';
        fItem.Title='Welcome in Test';
        insert fItem;
        
        
        WINatPOSRemoteActionWrapper response=WINatPOSUtilRemoteActions.getAnnouncementForGroup(null);
        Test.stopTest();
        
        List<feedItem> fItemLst=[select id FROM FeedItem WHERE Type = 'AdvancedTextPost' and ParentId =:colGroup.id ];
        system.assertEquals(true, fItemLst.size() == 1 , 'There should be created only one announcement in test group');
    }
    
    /*******************************************************************
    Purpose: Method testing adding sharing
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testHandleAssetAgenciesShares(){
    	
    	List<Asset__c> assetsList = new List<Asset__c>();
    	
    	
    	Group test1 = new Group();
		test1.Name = 'Win@POS_Test1';
		insert test1;
		
		List<Group> winAtPosPublicGroups = [SELECT Name, Id FROM Group WHERE Name like 'Win@POS%' ORDER BY Name];

        Asset__c asset = new Asset__c();
        asset.Name = 'Uniq Test Asset';
        asset.Placement__c = 'Primary';
        asset.POS_Asset_Type__c = 'Masterbrand';
        asset.Market_Cluster__c = 'Global';
        asset.Channels__c = 'Cash & Carry;Convenience';
        asset.Status__c = 'Approved';
        asset.Country__c = 'UK';
        asset.Description__c = 'test';
        assetsList.add(asset);
        
        Test.startTest();
        	System.assert(winAtPosPublicGroups.size() > 0);
        	insert assetsList;
        	
        	System.assert([SELECT Id FROM Asset__Share].size() == 0);
        	
        	assetsList[0].Agency_Edit_Access_Text__c = winAtPosPublicGroups[0].Name;
        	
        	update assetsList;
        	
        	System.assert([SELECT Id FROM Asset__Share].size() == 1);
        	System.assert([SELECT Id, AccessLevel FROM Asset__Share].get(0).AccessLevel == 'Edit');
        
        Test.stopTest();
    }
    
    /*******************************************************************
    Purpose: Method testing adding sharing
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testHandleAssetAgenciesShares2(){
    	
    	List<Asset__c> assetsList = new List<Asset__c>();
    	
    	Group test1 = new Group();
		test1.Name = 'Win@POS_Test1';
		insert test1;
		
		Group test2 = new Group();
		test2.Name = 'Win@POS_Test2';
		insert test2;
		
    	List<Group> winAtPosPublicGroups = [SELECT Name, Id FROM Group WHERE Name like 'Win@POS%' ORDER BY Name];
    	
        Asset__c asset = new Asset__c();
        asset.Name = 'Uniq Test Asset';
        asset.Placement__c = 'Primary';
        asset.POS_Asset_Type__c = 'Masterbrand';
        asset.Market_Cluster__c = 'Global';
        asset.Channels__c = 'Cash & Carry;Convenience';
        asset.Status__c = 'Approved';
        asset.Country__c = 'UK';
        asset.Description__c = 'test';
        assetsList.add(asset);
        
        Test.startTest();
			System.assert(winAtPosPublicGroups.size() > 1);
			
			assetsList[0].Agency_Read_Access_Text__c = winAtPosPublicGroups[0].Name + ';' + winAtPosPublicGroups[1].Name;
			
        	insert assetsList;
        	
        	System.assert([SELECT Id FROM Asset__Share].size() == 2);
        	System.assert([SELECT Id, AccessLevel FROM Asset__Share].get(0).AccessLevel == 'Read');
        	System.assert([SELECT Id, AccessLevel FROM Asset__Share].get(1).AccessLevel == 'Read');
        
        Test.stopTest();
    }
}