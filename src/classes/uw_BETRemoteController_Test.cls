/**********************************************************************
Name: uw_BETRemoteController_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for uw_BETRemoteController
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             29/10/2014      INITIAL DEVELOPMENT
1.1 -   Maciej Krol             22/12/2014      REFACTORING
***********************************************************************/
@isTest
private class uw_BETRemoteController_Test {
    static testMethod void initReadWriteAccess() {
        User adminUser = BET_TestingHelper.createAdminUser('test', 'test@test.com', 'test');
        User marketingUser = BET_TestingHelper.getDefaultNotMember();
        uw_BETRemoteController controller;
        System.runAs(adminUser){
            controller = new uw_BETRemoteController();
            System.assertEquals('true', controller.hasReadAll);
            System.assertEquals('true', controller.hasModifyAll);
            System.assertEquals(uw_BET__c.SObjectType.getDescribe().getKeyPrefix(), controller.betPrefix);
            System.assertEquals('', controller.newBetId);
        }

        System.runAs(marketingUser){
            controller = new uw_BETRemoteController();
            System.assertEquals('false', controller.hasReadAll);
            System.assertEquals('false', controller.hasModifyAll);
            System.assertEquals(uw_BET__c.SObjectType.getDescribe().getKeyPrefix(), controller.betPrefix);
            System.assertEquals('', controller.newBetId);
        }
    }

    static testMethod void initReadWriteAccessExtension() {
        BET_TestingHelper.BET_TestingData betWrapper = BET_TestingHelper.initBET('UT_BET', true);
        User adminUser = BET_TestingHelper.createAdminUser('test', 'test@test.com', 'test');
        User marketingUser = BET_TestingHelper.getDefaultNotMember();
        uw_BETRemoteController controller;

        System.runAs(adminUser){
            controller = new uw_BETRemoteController(new ApexPages.StandardController(betWrapper.BET));
            System.assertEquals('true', controller.hasReadAll);
            System.assertEquals('true', controller.hasModifyAll);
            System.assertEquals(uw_BET__c.SObjectType.getDescribe().getKeyPrefix(), controller.betPrefix);
            System.assertEquals(betWrapper.BET.Id, controller.newBetId);
        }

        System.runAs(marketingUser){
            controller = new uw_BETRemoteController(new ApexPages.StandardController(betWrapper.BET));
            System.assertEquals('false', controller.hasReadAll);
            System.assertEquals('false', controller.hasModifyAll);
            System.assertEquals(uw_BET__c.SObjectType.getDescribe().getKeyPrefix(), controller.betPrefix);
            System.assertEquals(betWrapper.BET.Id, controller.newBetId);
        }
    }

    static testMethod void testMethodOne(){
        //just call for code coverage because tested in uw_BETSearchService_Test
        uw_BETRemoteController.getMyBETs();
        uw_BETRemoteController.search('', '', 'test', 1, 1, true, false, '');
        //just call for code coverage because tested in uw_BETSearchService_Test. Will cover catch block
        uw_BETRemoteController.search('test', '', 'test', 1, 1, true, false, '');
    }

    static testMethod void testMethodTwo(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET1_'+system.now(), true);

        BET_TestingHelper.BET_TestingData wrap2 = BET_TestingHelper.initBET('Test BET2_'+system.now(), true);
        Id tmpId = wrap2.BET.Id;
        delete wrap2.BET;

        User usr = BET_TestingHelper.getDefaultNotMember();

        uw_BETWrapper response;
        System.runAs(usr){
            response = uw_BETRemoteController.requestBETAccess(wrap.BET.Id);
        }

        System.assertEquals(response.status, '0');

        System.runAs(usr){
            response = uw_BETRemoteController.requestBETAccess(wrap.BET.Id);
        }

        System.assertEquals(response.status, '-2');

        System.runAs(usr){
            response = uw_BETRemoteController.requestBETAccess(tmpId);
        }

        System.assertEquals(response.status, '-1');
    }

    static testMethod void testMethodThree(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET2_'+system.now(), true);
        wrap.addMember();

        BET_TestingHelper.BET_TestingData wrap2 = BET_TestingHelper.initBET('Test BET3_'+system.now(), true);
        wrap2.addMember();

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.removeMeFromBET(wrap2.BET.Id);  
        }
        System.assertEquals(response.status, '-1');

        System.runAs(wrap.member){
            response = uw_BETRemoteController.removeMeFromBET(wrap.BET.Id);
        }
        System.assertEquals(response.status, '0');
    }

    static testMethod void testMethodFour(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET2_'+system.now(), true);
        wrap.addMember();

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.getBETDetails(wrap.BET.Id);  
        }

        delete wrap.BET;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.getBETDetails(wrap.BET.Id);  
        }     

        System.assertEquals(response.status, '-1'); 
    }

    static testMethod void testMethodFive(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST_'+system.now(), true);
        wrap.addAsset('TEST', BET_TestingHelper.ASSET_SUBFUNCTION_BD, BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK, BET_TestingHelper.ASSET_STATUS_APPROVED, BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION);

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.getBETBDAssets(wrap.BET.Id, BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION, BET_TestingHelper.UT_COUNTRY, 5, 1, true, false, '');
        }   
        System.assertEquals(response.status, '0'); 

        Map<String, Object> wraps = (Map<String, Object>)response.data;

        List<uw_BETWrapper.AssetItem> assetList = (List<uw_BETWrapper.AssetItem>) wraps.get('assets');
        System.AssertEquals(1, assetList.size());  

        List<uw_BETWrapper.FilterLineItemWrapper> filterList = (List<uw_BETWrapper.FilterLineItemWrapper>) wraps.get('filters'); 
        filterList = (List<uw_BETWrapper.FilterLineItemWrapper>) wraps.get('filters'); 
        System.AssertEquals(2, filterList.size());
    }

    static testMethod void testMethodSix(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST_'+system.now(), true);

        uw_Asset__c presentation = wrap.addPresentation('Test Presentation.PPT', BET_TestingHelper.ASSET_STATUS_DRAFT);

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.getBETDraftAssets(wrap.BET.Id, BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION, 'United Kingdom', 5, 1, true, false, '');
        }   
        System.assertEquals(response.status, '0'); 

        Map<String, Object> wraps = (Map<String, Object>)response.data;

        List<uw_BETWrapper.AssetItem> assetList = (List<uw_BETWrapper.AssetItem>) wraps.get('assets');
        System.AssertEquals(1, assetList.size());  

        List<uw_BETWrapper.FilterLineItemWrapper> filterList = (List<uw_BETWrapper.FilterLineItemWrapper>) wraps.get('filters'); 
        filterList = (List<uw_BETWrapper.FilterLineItemWrapper>) wraps.get('filters'); 
        System.AssertEquals(2, filterList.size());
    }

    static testMethod void testMethodSeven(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST_'+system.now(), true);
        wrap.addAsset('Test Presentation.PPT', BET_TestingHelper.ASSET_SUBFUNCTION_BB, BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK, BET_TestingHelper.ASSET_STATUS_SHARED, BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL);

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.getBETBBAssets(wrap.BET.Id, BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL, 'United Kingdom', 5, 1, true, false, '');
        }   
        System.assertEquals(response.status, '0'); 

        Map<String, Object> wraps = (Map<String, Object>)response.data;
        wraps = (Map<String, Object>)response.data;

        List<uw_BETWrapper.AssetItem> assetList = (List<uw_BETWrapper.AssetItem>) wraps.get('assets');
        System.AssertEquals(1, assetList.size());  

        List<uw_BETWrapper.FilterLineItemWrapper> filterList = (List<uw_BETWrapper.FilterLineItemWrapper>) wraps.get('filters'); 
        filterList = (List<uw_BETWrapper.FilterLineItemWrapper>) wraps.get('filters'); 
        System.AssertEquals(2, filterList.size());
    }

    static testMethod void testMethodEight(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST_'+system.now(), true);
        wrap.addAsset('TEST', BET_TestingHelper.ASSET_SUBFUNCTION_BD, BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK, BET_TestingHelper.ASSET_STATUS_APPROVED, BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION);
        uw_Asset__c presentation = wrap.addPresentation('Test Presentation.PPT', BET_TestingHelper.ASSET_STATUS_DRAFT);
        wrap.addAsset('Test Presentation.PPT', BET_TestingHelper.ASSET_SUBFUNCTION_BB, BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK, BET_TestingHelper.ASSET_STATUS_SHARED, BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL);

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.getBETAssets(wrap.BET.Id, BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION, 'United Kingdom', BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION,5, 1, true, false, '');
        }                                  
        System.assertEquals(response.status, '0'); 

        Map<String, Object> wraps = (Map<String, Object>)response.data;
        wraps = (Map<String, Object>)response.data;

        List<uw_BETWrapper.AssetItem> assetList = (List<uw_BETWrapper.AssetItem>) wraps.get('assets');
        System.AssertEquals(1, assetList.size());  

        List<uw_BETWrapper.FilterLineItemWrapper> filterList = (List<uw_BETWrapper.FilterLineItemWrapper>) wraps.get('filters'); 
        filterList = (List<uw_BETWrapper.FilterLineItemWrapper>) wraps.get('filters'); 
        System.AssertEquals(2, filterList.size());
    }

    static testMethod void testMethodNine(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST_'+system.now(), true);
        wrap.addPresentation('TEST', BET_TestingHelper.ASSET_STATUS_APPROVED);

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.deleteBETAsset(wrap.BET.Id, wrap.presentation.Id);
        }                                  
        System.assertEquals(response.status, '0'); 

        Map<String, Object> wraps = (Map<String, Object>)response.data;
        wraps = (Map<String, Object>)response.data;

        Boolean refresh = (Boolean) wraps.get('refreshPresentation');
        System.AssertEquals(refresh, true);  
    }

    static testMethod void testMethodTen(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST_'+system.now(), true);
        
        FeedItem assetFeedItem = new FeedItem(
            ParentId = wrap.BET.Studio_Chatter_Group__c,
            Body = 'Some Content',
            ContentFileName = 'fileName',
            ContentData = EncodingUtil.base64Decode('test')
        );

        insert assetFeedItem;

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.getBETChatterFiles(wrap.BET.Id, 5, 1, false, '');
        }                                  
        System.assertEquals(response.status, '0'); 
        
        Map<String, Object> wraps = (Map<String, Object>)response.data;
        wraps = (Map<String, Object>)response.data;

        List<uw_BETWrapper.DraftItem> assetList = (List<uw_BETWrapper.DraftItem>) wraps.get('drafts');
        System.AssertEquals(1, assetList.size());
    }

    static testMethod void testMethodEleven(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST_'+system.now(), true);
        
        FeedItem assetFeedItem = new FeedItem(
            ParentId = wrap.BET.Studio_Chatter_Group__c,
            Body = 'Some Content',
            ContentFileName = 'fileName',
            ContentData = EncodingUtil.base64Decode('test')
        );

        insert assetFeedItem;

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.deleteChatterFileDraft(assetFeedItem.Id);
        }                                  
        System.assertEquals(response.status, '0'); 
    }

    //cover catch block
    static testMethod void testMethodTwelve(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST_'+system.now(), true);
        wrap.addAsset('TEST', BET_TestingHelper.ASSET_SUBFUNCTION_BD, BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK, BET_TestingHelper.ASSET_STATUS_APPROVED, BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION);

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.getBETBDAssets('Wrong Id', BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION, BET_TestingHelper.UT_COUNTRY, 5, 1, true, false, '');
        }  
        System.assertEquals(response.status, '-1');
    }
    
    //cover catch block
    static testMethod void testMethodThirteen(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST_'+system.now(), true);

        uw_Asset__c presentation = wrap.addPresentation('Test Presentation.PPT', BET_TestingHelper.ASSET_STATUS_DRAFT);

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.getBETDraftAssets('Wrong Id', BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION, 'United Kingdom', 5, 1, true, false, '');
        }   
        System.assertEquals(response.status, '-1'); 
    }
    
    //cover catch block
    static testMethod void testMethodFourteen(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST_'+system.now(), true);
        wrap.addAsset('Test Presentation.PPT', BET_TestingHelper.ASSET_SUBFUNCTION_BB, BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK, BET_TestingHelper.ASSET_STATUS_SHARED, BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL);

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.getBETBBAssets('Wrong Id', BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL, 'United Kingdom', 5, 1, true, false, '');
        }   
        System.assertEquals(response.status, '-1'); 	
    }
    
    //cover catch block
    static testMethod void testMethodFifteen(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST_'+system.now(), true);
        wrap.addAsset('TEST', BET_TestingHelper.ASSET_SUBFUNCTION_BD, BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK, BET_TestingHelper.ASSET_STATUS_APPROVED, BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION);
        uw_Asset__c presentation = wrap.addPresentation('Test Presentation.PPT', BET_TestingHelper.ASSET_STATUS_DRAFT);
        wrap.addAsset('Test Presentation.PPT', BET_TestingHelper.ASSET_SUBFUNCTION_BB, BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK, BET_TestingHelper.ASSET_STATUS_SHARED, BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL);

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.getBETAssets('Wrong Id', BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION, 'United Kingdom', BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION,5, 1, true, false, '');
        }                                  
        System.assertEquals(response.status, '-1'); 
    }
    /*
    static testMethod void testMethodTwelve(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST', true);
        uw_Asset__c asset = wrap.addAsset('TEST', BET_TestingHelper.ASSET_SUBFUNCTION_BD, BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK, BET_TestingHelper.ASSET_STATUS_APPROVED, BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION);

        delete asset;
        delete wrap.BET;        

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.getBETBDAssets(wrap.BET.Id, BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION, BET_TestingHelper.UT_COUNTRY, 5, 1, true, false, '');
        }   
        System.assertEquals(response.status, '-1');
    }

    //cover catch block
    static testMethod void testMethodThirteen(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST', true);

        uw_Asset__c presentation = wrap.addPresentation('Test Presentation.PPT', BET_TestingHelper.ASSET_STATUS_DRAFT);

        delete presentation;
        delete wrap.BET;        

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.getBETDraftAssets(wrap.BET.Id, BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION, 'United Kingdom', 5, 1, true, false, '');
        }   
        System.assertEquals(response.status, '-1');
    }

    //cover catch block
    static testMethod void testMethodFourteen(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST', true);
        uw_Asset__c asset = wrap.addAsset('Test Presentation.PPT', BET_TestingHelper.ASSET_SUBFUNCTION_BB, BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK, BET_TestingHelper.ASSET_STATUS_SHARED, BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL);
        
        delete asset;
        delete wrap.BET;

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.getBETBBAssets(wrap.BET.Id, BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL, 'United Kingdom', 5, 1, true, false, '');
        }   
        System.assertEquals(response.status, '-1'); 
    }

    //cover catch block
    static testMethod void testMethodFifteen(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST', true);
        uw_Asset__c asset = wrap.addAsset('TEST', BET_TestingHelper.ASSET_SUBFUNCTION_BD, BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK, BET_TestingHelper.ASSET_STATUS_APPROVED, BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION);
        uw_Asset__c presentation = wrap.addPresentation('Test Presentation.PPT', BET_TestingHelper.ASSET_STATUS_DRAFT);
        uw_Asset__c asset2 =wrap.addAsset('Test Presentation.PPT', BET_TestingHelper.ASSET_SUBFUNCTION_BB, BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK, BET_TestingHelper.ASSET_STATUS_SHARED, BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL);
        
        delete asset;
        delete asset2;
        delete presentation;
        delete wrap.BET;

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.getBETAssets(wrap.BET.Id, BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION, 'United Kingdom', BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION,5, 1, true, false, '');
        }                                  
        System.assertEquals(response.status, '-1'); 
    }
    */

    //cover catch block
    static testMethod void testMethodSixteen(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST_'+system.now(), true);
        wrap.addPresentation('TEST', BET_TestingHelper.ASSET_STATUS_APPROVED);

        delete wrap.BET;

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.deleteBETAsset(wrap.BET.Id, wrap.presentation.Id);
        }                                  
        System.assertEquals(response.status, '-1');
    }

    //cover catch block
    static testMethod void testMethodSeventeen(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST_'+system.now(), true);
        
        FeedItem assetFeedItem = new FeedItem(
            ParentId = wrap.BET.Studio_Chatter_Group__c,
            Body = 'Some Content',
            ContentFileName = 'fileName',
            ContentData = EncodingUtil.base64Decode('test')
        );

        insert assetFeedItem;

        delete wrap.BET;

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.getBETChatterFiles(wrap.BET.Id, 5, 1, false, '');
        }                                  
        System.assertEquals(response.status, '-1'); 
    }

    //cover catch block
    static testMethod void testMethodEighteen(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST_'+system.now(), true);
        
        FeedItem assetFeedItem = new FeedItem(
            ParentId = wrap.BET.Studio_Chatter_Group__c,
            Body = 'Some Content',
            ContentFileName = 'fileName',
            ContentData = EncodingUtil.base64Decode('test')
        );

        insert assetFeedItem;

        delete wrap.BET;

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.deleteChatterFileDraft(assetFeedItem.Id);
        }                                  
        System.assertEquals(response.status, '-1'); 
    }

    static testMethod void testMethodNineteen(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST_'+system.now(), true);
        
        FeedItem assetFeedItem = new FeedItem(
            ParentId = wrap.BET.Studio_Chatter_Group__c,
            Body = 'Some Content',
            ContentFileName = 'fileName',
            ContentData = EncodingUtil.base64Decode('test')
        );

        insert assetFeedItem;

        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.chatterFileToDraftAsset(wrap.BET.Id, assetFeedItem.Id);
        }                                  
        System.assertEquals(response.status, '0'); 
    }

    //cover catch block
    static testMethod void testMethodTwenty(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST_'+system.now(), true);
        
        FeedItem assetFeedItem = new FeedItem(
            ParentId = wrap.BET.Studio_Chatter_Group__c,
            Body = 'Some Content',
            ContentFileName = 'fileName',
            ContentData = EncodingUtil.base64Decode('test')
        );

        insert assetFeedItem;

        delete wrap.BET;
        
        uw_BETWrapper response;
        System.runAs(wrap.owner){
            response = uw_BETRemoteController.chatterFileToDraftAsset(wrap.BET.Id, assetFeedItem.Id);
        }                                  
        System.assertEquals(response.status, '-1'); 
    }
}