/**********************************************************************
Name: BET_BatchFixOldBetStatus_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for BET_BatchFixOldBetStatus
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Wojciech Migas          05/02/2015      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class BET_BatchFixOldBetStatus_Test { 
    /*******************************************************************
    Purpose: Method to test setting first release state for old BETs
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void populateOldBETFirstRelease(){
        //BET 1
        BET_TestingHelper.BET_TestingData betWrapper1 = BET_TestingHelper.initBET('Test BET UT', true);
        
        uw_Asset__c asset1 = createOldPresentation(betWrapper1.BET);
        insert asset1;


        uw_BET__c bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];
        System.assertEquals(BET_TestingHelper.BET_STATUS_UNRELEASED, bet1.Status__c);

        // Start test
        Test.startTest();
        BET_BatchFixOldBetStatus batchMapping = new BET_BatchFixOldBetStatus();
        Database.executeBatch(batchMapping, 10);
        Test.stopTest();

        bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];

        System.assertEquals(BET_TestingHelper.BET_STATUS_FIRSTRELEASE, bet1.Status__c);
    }

    /*******************************************************************
    Purpose: Method to test setting first release state for new BETs
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void populateNewBETFirstRelease(){
        //BET 1
        BET_TestingHelper.BET_TestingData betWrapper1 = BET_TestingHelper.initBET('Test BET UT', true);
        
        uw_Asset__c asset1 = createNewPresentation(betWrapper1.BET);
        insert asset1;

        uw_BET__c bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];
        System.assertEquals(BET_TestingHelper.BET_STATUS_UNRELEASED, bet1.Status__c);

        // Start test
        Test.startTest();
        BET_BatchFixOldBetStatus batchMapping = new BET_BatchFixOldBetStatus();
        Database.executeBatch(batchMapping, 10);
        Test.stopTest();

        bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];

        System.assertEquals(BET_TestingHelper.BET_STATUS_FIRSTRELEASE, bet1.Status__c);
    }

    /*******************************************************************
    Purpose: Method to test setting final release state for old BETs
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void populateOldBETFinalRelease(){
        //BET 1
        BET_TestingHelper.BET_TestingData betWrapper1 = BET_TestingHelper.initBET('Test BET UT', true);
        
        List<uw_Asset__c> assets = new List<uw_Asset__c>();
        assets.add(createOldPresentation(betWrapper1.BET));
        assets.add(createOldKeyVisual(betWrapper1.BET));
        insert assets;

        uw_BET__c bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];

        System.assertEquals(BET_TestingHelper.BET_STATUS_UNRELEASED, bet1.Status__c);

        // Start test
        Test.startTest();
        BET_BatchFixOldBetStatus batchMapping = new BET_BatchFixOldBetStatus();
        Database.executeBatch(batchMapping, 10);
        Test.stopTest();

        bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];

        System.assertEquals(BET_TestingHelper.BET_STATUS_FINALRELEASE, bet1.Status__c);
    }

    /*******************************************************************
    Purpose: Method to test setting final release state for old BETs
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void populateOldBETWithNewPresentationFinalRelease(){
        //BET 1
        BET_TestingHelper.BET_TestingData betWrapper1 = BET_TestingHelper.initBET('Test BET UT', true);
        
        List<uw_Asset__c> assets = new List<uw_Asset__c>();
        assets.add(createOldPresentation(betWrapper1.BET));
        assets.add(createnewKeyVisual(betWrapper1.BET));
        insert assets;

        uw_BET__c bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];

        System.assertEquals(BET_TestingHelper.BET_STATUS_UNRELEASED, bet1.Status__c);

        // Start test
        Test.startTest();
        BET_BatchFixOldBetStatus batchMapping = new BET_BatchFixOldBetStatus();
        Database.executeBatch(batchMapping, 10);
        Test.stopTest();

        bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];

        System.assertEquals(BET_TestingHelper.BET_STATUS_FINALRELEASE, bet1.Status__c);
    }

    /*******************************************************************
    Purpose: Method to test setting final release state for new BETs
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void populateNewBETFinalReleaseOne(){
        //BET 1
        BET_TestingHelper.BET_TestingData betWrapper1 = BET_TestingHelper.initBET('Test BET UT', true);
        
        List<uw_Asset__c> assets = new List<uw_Asset__c>();
        assets.add(createnewPresentation(betWrapper1.BET));
        assets.add(createnewKeyVisual(betWrapper1.BET));
        insert assets;

        uw_BET__c bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];

        System.assertEquals(BET_TestingHelper.BET_STATUS_UNRELEASED, bet1.Status__c);

        // Start test
        Test.startTest();
        BET_BatchFixOldBetStatus batchMapping = new BET_BatchFixOldBetStatus();
        Database.executeBatch(batchMapping, 10);
        Test.stopTest();

        bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];

        System.assertEquals(BET_TestingHelper.BET_STATUS_FINALRELEASE, bet1.Status__c);
    }

    /*******************************************************************
    Purpose: Method to test setting final release state for new BETs
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void populateNewBETFinalReleaseTwo(){
        //BET 1
        BET_TestingHelper.BET_TestingData betWrapper1 = BET_TestingHelper.initBET('Test BET UT', true);
        
        List<uw_Asset__c> assets = new List<uw_Asset__c>();
        assets.add(createnewPresentation(betWrapper1.BET));
        assets.add(createoldKeyVisual(betWrapper1.BET));
        insert assets;

        uw_BET__c bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];

        System.assertEquals(BET_TestingHelper.BET_STATUS_UNRELEASED, bet1.Status__c);

        // Start test
        Test.startTest();
        BET_BatchFixOldBetStatus batchMapping = new BET_BatchFixOldBetStatus();
        Database.executeBatch(batchMapping, 10);
        Test.stopTest();

        bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];

        System.assertEquals(BET_TestingHelper.BET_STATUS_FINALRELEASE, bet1.Status__c);
    }

    /*******************************************************************
    Purpose: Method to test setting final release state for new BETs
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void populateNewBETFinalReleaseDryRun(){
        //BET 1
        BET_TestingHelper.BET_TestingData betWrapper1 = BET_TestingHelper.initBET('Test BET UT', true);
        
        List<uw_Asset__c> assets = new List<uw_Asset__c>();
        assets.add(createnewPresentation(betWrapper1.BET));
        assets.add(createoldKeyVisual(betWrapper1.BET));
        insert assets;

        uw_BET__c bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];

        System.assertEquals(BET_TestingHelper.BET_STATUS_UNRELEASED, bet1.Status__c);

        // Start test
        Test.startTest();
        BET_BatchFixOldBetStatus batchMapping = new BET_BatchFixOldBetStatus();
        batchMapping.dryRun = true;
        Database.executeBatch(batchMapping, 10);
        Test.stopTest();

        bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];

        System.assertEquals(BET_TestingHelper.BET_STATUS_UNRELEASED, bet1.Status__c);
    }

    /*******************************************************************
    Purpose: Method to test if system does not change status to lower level
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void preventDowngradingStatusOne(){
        //BET 1
        BET_TestingHelper.BET_TestingData betWrapper1 = BET_TestingHelper.initBET('Test BET UT', true);
        betWrapper1.BET.Status__c = BET_TestingHelper.BET_STATUS_FINALRELEASE;
        update betWrapper1.BET;

        List<uw_Asset__c> assets = new List<uw_Asset__c>();
        assets.add(createOldPresentation(betWrapper1.BET));
        insert assets;

        uw_BET__c bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];

        System.assertEquals(BET_TestingHelper.BET_STATUS_FINALRELEASE, bet1.Status__c);

        // Start test
        Test.startTest();
        BET_BatchFixOldBetStatus batchMapping = new BET_BatchFixOldBetStatus();
        Database.executeBatch(batchMapping, 10);
        Test.stopTest();

        bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];

        System.assertEquals(BET_TestingHelper.BET_STATUS_FINALRELEASE, bet1.Status__c);
    }

    /*******************************************************************
    Purpose: Method to test if system does not change status to lower level
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void preventDowngradingStatusTwo(){
        //BET 1
        BET_TestingHelper.BET_TestingData betWrapper1 = BET_TestingHelper.initBET('Test BET UT', true);
        betWrapper1.BET.Status__c = BET_TestingHelper.BET_STATUS_FINALRELEASE;
        update betWrapper1.BET;

        uw_BET__c bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];

        System.assertEquals(BET_TestingHelper.BET_STATUS_FINALRELEASE, bet1.Status__c);

        // Start test
        Test.startTest();
        BET_BatchFixOldBetStatus batchMapping = new BET_BatchFixOldBetStatus();
        Database.executeBatch(batchMapping, 10);
        Test.stopTest();

        bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];

        System.assertEquals(BET_TestingHelper.BET_STATUS_FINALRELEASE, bet1.Status__c);
    }

    /*******************************************************************
    Purpose: Method to test if system does not change status to lower level
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void preventDowngradingStatusThree(){
        //BET 1
        BET_TestingHelper.BET_TestingData betWrapper1 = BET_TestingHelper.initBET('Test BET UT', true);
        betWrapper1.BET.Status__c = BET_TestingHelper.BET_STATUS_FIRSTRELEASE;
        update betWrapper1.BET;

        uw_BET__c bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];

        System.assertEquals(BET_TestingHelper.BET_STATUS_FIRSTRELEASE, bet1.Status__c);

        // Start test
        Test.startTest();
        BET_BatchFixOldBetStatus batchMapping = new BET_BatchFixOldBetStatus();
        Database.executeBatch(batchMapping, 10);
        Test.stopTest();

        bet1 = [SELECT Id, Status__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];

        System.assertEquals(BET_TestingHelper.BET_STATUS_FIRSTRELEASE, bet1.Status__c);
    }

    static uw_Asset__c createOldPresentation(uw_BET__c BET) {
        uw_Asset__c asset = createAsset(BET);
        asset.Big_Think_Pack__c     = true;
        asset.promoted__c           = true;
        asset.Status__c             = BET_TestingHelper.ASSET_STATUS_APPROVED;
        return asset;        
    }

    static uw_Asset__c createNewPresentation(uw_BET__c BET) {
        uw_Asset__c asset = createAsset(BET);
        asset.Status__c             = BET_TestingHelper.ASSET_STATUS_APPROVED;
        asset.Sub_Function__c       = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
        asset.Studio_Asset_Type__c  = BET_TestingHelper.ASSET_STUDIOTYPE_PRESENTATION;
        return asset;
    }

    static uw_Asset__c createOldKeyVisual(uw_BET__c BET) {
        uw_Asset__c asset = createAsset(BET);
        asset.Other_Media_Channel__c    = 'Key Visual';
        asset.Status__c                 = BET_TestingHelper.ASSET_STATUS_APPROVED;
        asset.Studio_Asset_Type__c      = BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK;
        return asset;        
    }

    static uw_Asset__c createNewKeyVisual(uw_BET__c BET) {
        uw_Asset__c asset = createAsset(BET);
        asset.Sub_Function__c       = BET_TestingHelper.ASSET_SUBFUNCTION_BD;
        asset.Status__c             = BET_TestingHelper.ASSET_STATUS_APPROVED;
        asset.Studio_Asset_Type__c  = BET_TestingHelper.ASSET_STUDIOTYPE_CREATIVEWORK;
        asset.Media_Type__c         = BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL;
        return asset;
    }

    static uw_Asset__c createAsset(uw_BET__c BET) {
        String fileName = 'Some file name.doc';
        feedItem assetFeedItem = new FeedItem(
            ParentId        = BET.Studio_Chatter_Group__c,
            Body            = 'Some Content',
            ContentFileName = fileName,
            ContentData     = EncodingUtil.base64Decode('test')
        );

        insert assetFeedItem;

        //WE CANNOT USE CONNECT API ON DATA WHICH HAS BEEN CREATED DUERING UT
        //ConnectApi.FeedItem fi = ConnectApi.ChatterFeeds.getFeedItem(null, assetFeedItem.Id);
        //ConnectApi.ContentAttachment ca = (ConnectApi.ContentAttachment) fi.attachment;

        uw_Asset__c asset = new uw_Asset__c(
            Name                 = fileName,
            uw_BET__c            = BET.Id,
            Related_Feed_Item__c = assetFeedItem.Id,
            Country__c           = BET_TestingHelper.UT_COUNTRY,
            //connect API
            URL_of_Asset__c      = BET_TestingHelper.UT_ASSETDOWNLOADLINK,
            thumbnail__c         = BET_TestingHelper.UT_ASSETTHUMBLINK
        );
        return asset;
    }
}