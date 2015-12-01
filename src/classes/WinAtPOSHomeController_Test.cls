/**********************************************************************
Name: WinAtPOSHomeController_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for WinAtPOSHomeController_Test
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Karol Szepietowski          29/10/2014      INITIAL DEVELOPMENT
***********************************************************************/
@isTest
public class WinAtPOSHomeController_Test {
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
                WinAtPOSRemoteActions__c remConf=remConfLst.get(0);
                remConf.Default_Image_Size__c=12288;
                remConf.Default_Image_Url__c='/resource/winatposapp/images/emptydetail.png';
                remConf.Max_file_size__c=60;
                remConf.WinAtPosGroup__c='Global WIN@POS';
                update remConf;
            }else{
                WinAtPOSRemoteActions__c remConf = new WinAtPOSRemoteActions__c();
                remConf.Default_Image_Size__c=12288;
                remConf.Default_Image_Url__c='/resource/winatposapp/images/emptydetail.png';
                remConf.Max_file_size__c=60;
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
    Purpose: Method testing application usage 
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testMethod void testApplicationUsage(){
        test.startTest();
        WinAtPOSHomeController homeContr=new WinAtPOSHomeController();
        WinAtPOSHomeController.upsertAppUsage();
        system.assertEquals(true, [select id from Application_Usage__c where User__c =: UserInfo.getUserId()].size()>0, 'application usage should be added to object');
        test.stopTest();
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
        WINatPOSRemoteActionWrapper response=WinAtPOSHomeController.getMenu();
        Test.stopTest();
        
        //check if proper data was returned
        system.debug(response);
        system.assertEquals('0',response.status,'method sould return 0 if no errors');   
        List<WINatPOSRemoteActionWrapper.MenuWrapper> menuWraps = (List<WINatPOSRemoteActionWrapper.MenuWrapper>)response.data;
        system.assertEquals(2, menuWraps.size(), 'method should return brands and categories');
    }
    /*******************************************************************
    Purpose: Method testing getWinAtPOSGroupName property
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    public static testMethod void testGetWinAtPOSGroupName(){
        TestingHelper th=new TestingHelper();
        th.setCustomSettingForRemoteConf();
        WinAtPOSHomeController cont=new WinAtPOSHomeController();
        String groupName=cont.getWinAtPOSGroupName();
        System.assertEquals(true, groupName!= null);
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
        WINatPOSRemoteActionWrapper response=WinAtPOSHomeController.getHomePageCarusel();
        Test.stopTest();
        
        //check if proper data was returned
        system.debug(response);
        system.assertEquals('0',response.status,'method sould return 0 if no errors');   
        List<WINatPOSRemoteActionWrapper.AssetCaruselWrapper> assetsHomeCaruselPublished = (List<WINatPOSRemoteActionWrapper.AssetCaruselWrapper>)response.data;
        system.assertEquals(true, assetsHomeCaruselPublished.size()>0, 'method should return at least one asset for carusel');
    }
    
    /*******************************************************************
    Purpose: Method testing search method keyword with all additional filters
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testCombineSearchWithAllFilters(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        ts.setCustomSettingForRemoteConf();
        Test.startTest();
        //test keyword search where keyword = asset name
        system.debug('*****testtestCombineSearch initialize keyword search');
        system.debug(ts.finalTestAsset.get(0).Name);
        List<id> assetsToReturn = new List<Id>();
        for(Asset__c a: ts.finalTestAsset){
            assetsToReturn.add(a.id);
        }
        assetsToReturn.add(ts.finalTestAssetGroup.get(0).id);
        test.setFixedSearchResults(assetsToReturn);
        
        WINatPOSRemoteActionWrapper response=WinAtPOSHomeController.search(WinAtPOSUtil.keywordSearch, ts.finalTestAsset.get(0).Brand__c,ts.finalTestAsset.get(0).Category__c,ts.finalTestAsset.get(0).Name,ts.finalTestAsset.get(0).POS_Asset_Type__c,ts.finalTestAsset.get(0).Channels__c,ts.finalTestAsset.get(0).Market_Cluster__c,'','',15,1,true);
        WINatPOSRemoteActionWrapper responsePdfResult=WinAtPOSHomeController.getSearchResultListPdf(WinAtPOSUtil.keywordSearch, ts.finalTestAsset.get(0).Brand__c,ts.finalTestAsset.get(0).Category__c,ts.finalTestAsset.get(0).Name,ts.finalTestAsset.get(0).POS_Asset_Type__c,ts.finalTestAsset.get(0).Channels__c,ts.finalTestAsset.get(0).Market_Cluster__c,'','',15,1);
        system.assertEquals('0', response.status, 'method should response with success');
        system.assertEquals('0', responsePdfResult.status);
        List<WINatPOSRemoteActionWrapper.SearchWrapper> searchResult=(List<WINatPOSRemoteActionWrapper.SearchWrapper>)response.data;
        List<WINatPOSRemoteActionWrapper.AssetResultWrapper> assetResults=searchResult.get(0).assetSearchResult;
        system.assertEquals(true, assetResults.size()>0, 'search method should return at least one record');
        system.assertEquals(null, responsePdfResult.data, 'results should not be returned for pdf only information if pdf page can be rendered');
        Test.stopTest();
        
    }
    
    /*******************************************************************
    Purpose: Method testing adding download to download statistics for single file
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    @isTest(SeeAllData=true)
    static  void testRetriveStats(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        File__c inputFile=ts.finalTestFiles.get(0);
        test.startTest();
        WinAtPOSHomeController.addRecordToDonwloadStatistics(inputFile.Feed_ID__c, inputFile.id);
        Map<String,List<WINatPOSRemoteActionWrapper.AssetDetailStats>> mapOfStats=WINatPOSUtilRemoteActions.retriveStatistics(ts.finalTestFiles.get(0).id,ts.finalTestAsset.get(0).id);
        test.stopTest();
        
        //check if file was added to downloadStats
        List<Download_Statistics__c> downloadStats=[select id from Download_Statistics__c where Downloaded_By__c =: UserInfo.getUserId() and FileId__c =: inputFile.id];
        system.assertEquals(1, downloadStats.size(), 'file should be counted to dwonload statistics');
        system.assertEquals(true, mapOfStats.containsKey('downloadStatistics'), 'method retrive statistics shour return stasitic for download');
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
        Test.startTest();
        WINatPOSRemoteActionWrapper responseAsset=WinAtPOSHomeController.getAssetDetailData(ts.finalTestAsset.get(0).id);
        WINatPOSRemoteActionWrapper responseAssetGroup=WinAtPOSHomeController.getAssetDetailData(ts.finalTestAssetGroup.get(0).id);
        Test.stopTest();
        
        //check if proper data was returned
        system.debug(responseAsset);
        system.assertEquals('0',responseAsset.status,'method sould return 0 if no errors');
        system.assertEquals('0',responseAssetGroup.status,'method sould return 0 if no errors');
        List<WINatPOSRemoteActionWrapper.AssetsDetaislWrapper> assetsDetail = (List<WINatPOSRemoteActionWrapper.AssetsDetaislWrapper>)responseAsset.data;
        List<WINatPOSRemoteActionWrapper.AssetsDetaislWrapper> assetsGroupDetail = (List<WINatPOSRemoteActionWrapper.AssetsDetaislWrapper>)responseAsset.data;
        system.assertEquals(true, assetsDetail.size()>0, 'method should return at least one asset for asset detail page');
        system.assertEquals(true, assetsGroupDetail.size()>0, 'method should return at least one asset for asset Group detail page');
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
        WinAtPOSHomeController.addFollower(ts.finalTestAsset.get(0).id);
        //ass follow on asset group
        WinAtPOSHomeController.addFollower(ts.finalTestAssetGroup.get(0).id);
        Map<String,List<WINatPOSRemoteActionWrapper.AssetDetailStats>> mapOfStats=WinAtPOSHomeController.retriveStatistics(ts.finalTestFiles.get(0).id,ts.finalTestAsset.get(0).id);
        system.assertEquals(true, mapOfStats.containsKey('followStatistics'), 'method retriveStatistics should return follow statistics');
        
        //check if follow was added to asset
        system.assertEquals(true,[select ParentId, SubscriberId from EntitySubscription where ParentId =:ts.finalTestAsset.get(0).id and SubscriberId=:UserInfo.getUserId()].size() == 1,'user should be added to follow the asset');
        //test invalid parameter for removeFollow
        WinAtPOSHomeController.removeFollower('test');
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
        WinAtPOSHomeController.addFollower('test');
        system.assertEquals(true,[select ParentId, SubscriberId from EntitySubscription where ParentId =:ts.finalTestAsset.get(0).id and SubscriberId=:UserInfo.getUserId()].size() == 0,'user should not be added to follow invailid id was passed');
        
        
        Test.stopTest();
        
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
        WinAtPOSHomeController.shareAssetFile(ts.finalTestFiles.get(0).Feed_ID__c,UserInfo.getUserId());
         Map<String,List<WINatPOSRemoteActionWrapper.AssetDetailStats>> mapOfStats=WinAtPOSHomeController.retriveStatistics(ts.finalTestFiles.get(0).id,ts.finalTestAsset.get(0).id);
        test.stopTest();
        
        //check if file was added to downloadStats
        //check if retrive method for statistics work properly shoud return download for asset
        system.assertEquals(true, mapOfStats.containsKey('shareStatistics'), 'method retrive statistics should return stasitic for share');
        //system.assertEquals(true, mapOfStats.get('shareStatistics').size()>0, 'method retrive statistics should return stasitic for share');
        
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
        WINatPOSRemoteActionWrapper response=WinAtPOSHomeController.retriveUserFromWinAtPosGroup();
        Test.stopTest();
        
        List<WINatPOSRemoteActionWrapper.ChatterGroupMember> chatGroup=(List<WINatPOSRemoteActionWrapper.ChatterGroupMember>)response.data;
        system.assertEquals('0', response.status, 'method should return status 0 == no errors');
        system.assertEquals(2, chatGroup.size(), 'method should return 2 members of group global Win@POS');
    }
    
    /*******************************************************************
    Purpose: Method testing if retrive annoucement from group
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    
    static testMethod void testGetAnnouncementForGroup(){
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
        WINatPOSRemoteActionWrapper response=WinAtPOSHomeController.getAnnouncementForGroup(null);
        Test.stopTest();
        
        List<feedItem> fItemLst=[select id FROM FeedItem WHERE Type = 'AdvancedTextPost' and ParentId =:colGroup.id ];
        system.assertEquals(true, fItemLst.size() == 1 , 'There should be created only one announcement in test group');
    }
    
    /*******************************************************************
    Purpose: Method testing controller initialization
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    
    static testMethod void testContollerInitialization(){
        TestingHelper ts=new TestingHelper();
        ts.prepareTestDataEnv();
        
      	//crate a group
        CollaborationGroup colGroup=new CollaborationGroup();
        colGroup.CollaborationType='Public';
        colGroup.Name=WinAtPOSUtil.winAtPostChatterGroupForTest;
        insert colGroup;
        
        Test.startTest();
        WinAtPOSHomeController ctrl = new WinAtPOSHomeController();
        system.assertEquals(true, ctrl.winAtPosGroupId != null, 'winAtPosGroupId property should be set while controller initialization');
        ctrl.entityId=ts.finalTestAsset.get(0).id;
        PageReference pageRef=ctrl.updateChatterFeed();
        system.assertEquals(ctrl.winAtPosGroupId, ts.finalTestAsset.get(0).id, 'winAtPosGroupId property should be changed to assetID');
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
        brandAndCategoryId.add(ts.finalTestAsset.get(0).Category__c);
        brandAndCategoryId.add(ts.finalTestAsset.get(0).Brand__c);
        test.setFixedSearchResults(brandAndCategoryId);
        WINatPOSRemoteActionWrapper responseForCategoryCarusel=WinAtPOSHomeController.getCaruselForBrandOrCategory(WinAtPOSUtil.keywordSearch, null,null,'Deodorants Test or Axe Test');
        List<WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper> categoryCaruselResult=(List<WINatPOSRemoteActionWrapper.BrandCategoryCaruselWrapper>)responseForCategoryCarusel.data;
        system.assertEquals(true, categoryCaruselResult.size()==2, 'method should find 2 carusels one for Category and one for brand');
        Test.stopTest();
        
    }
}