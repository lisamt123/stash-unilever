/**********************************************************************
Name: BET_PresentationBatch_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for BET_PresentationBatch
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Wojciech Migas          21/01/2015      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class BET_PresentationBatch_Test { 
    /*******************************************************************
    Purpose: Method to test populating presentation ID
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void populatePresentation(){
        //BET 1
        BET_TestingHelper.BET_TestingData betWrapper1 = BET_TestingHelper.initBET('Test BET UT', true);
        betWrapper1.addPresentation('test.pdf', 'Approved');
        betWrapper1.addPresentation('test.pdf', 'Approved');
        uw_Asset__c asset1 = betWrapper1.addPresentation('test.pdf', 'Approved');
        asset1.Big_Think_Pack__c = true;
        asset1.Promoted__c = true;
        update asset1;
        FeedItem f1 = [SELECT Id, RelatedRecordId FROM FeedItem WHERE Id =: asset1.Related_Feed_Item__c AND Type = 'ContentPost' LIMIT 1];
        ContentVersion cv1 = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: f1.RelatedRecordId LIMIT 1];


        //BET 2
        BET_TestingHelper.BET_TestingData betWrapper2 = BET_TestingHelper.initBET('Test BET UT2', true);
        betWrapper2.addPresentation('test.pdf', 'Approved');
        betWrapper2.addPresentation('test.pdf', 'Approved');
        uw_Asset__c asset2 = betWrapper2.addPresentation('test.pdf', 'Approved');
        asset2.Big_Think_Pack__c = true;
        asset2.Promoted__c = true;
        update asset2;
        FeedItem f2 = [SELECT Id, RelatedRecordId FROM FeedItem WHERE Id =: asset2.Related_Feed_Item__c AND Type = 'ContentPost' LIMIT 2];
        ContentVersion cv2 = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: f2.RelatedRecordId LIMIT 2];

        //BET 3
        BET_TestingHelper.BET_TestingData betWrapper3 = BET_TestingHelper.initBET('Test BET UT3', true);
        betWrapper3.addPresentation('test.pdf', 'Approved');

        uw_BET__c bet1 = [SELECT Id, Presentation_Id__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];
        uw_BET__c bet2 = [SELECT Id, Presentation_Id__c FROM uw_BET__c WHERE Id =: betWrapper2.BET.Id];
        uw_BET__c bet3 = [SELECT Id, Presentation_Id__c FROM uw_BET__c WHERE Id =: betWrapper2.BET.Id];

        System.assertEquals(null, bet1.Presentation_Id__c);
        System.assertEquals(null, bet2.Presentation_Id__c);
        System.assertEquals(null, bet3.Presentation_Id__c);

        // Start test
        Test.startTest();
        BET_PresentationBatch batchMapping = new  BET_PresentationBatch();
        Database.executeBatch(batchMapping, 10);
        Test.stopTest();

        bet1 = [SELECT Id, Presentation_Id__c FROM uw_BET__c WHERE Id =: betWrapper1.BET.Id];
        bet2 = [SELECT Id, Presentation_Id__c FROM uw_BET__c WHERE Id =: betWrapper2.BET.Id];
        bet3 = [SELECT Id, Presentation_Id__c FROM uw_BET__c WHERE Id =: betWrapper3.BET.Id];

        System.assertEquals(cv1.ContentDocumentId, bet1.Presentation_Id__c);
        System.assertEquals(cv2.ContentDocumentId, bet2.Presentation_Id__c);
        System.assertEquals(null, bet3.Presentation_Id__c);
    }

static testmethod void testerror() {
   

        user u = BET_TestingHelper.getDefaultOwner();
        uw_Asset__c asset2;
        BET_TestingHelper.BET_TestingData betWrapper2;
        system.runAs(u) {
            //BET 2
            betWrapper2 = BET_TestingHelper.initBET('Test BET UT2', true);
            betWrapper2.addPresentation('test.pdf', 'Approved');
            betWrapper2.addPresentation('test.pdf', 'Approved');
            asset2 = betWrapper2.addPresentation('test.pdf', 'Approved');
            asset2.Big_Think_Pack__c = true;
            asset2.Promoted__c = true;
            update asset2;
        }
        FeedItem f2 = [SELECT Id, RelatedRecordId FROM FeedItem WHERE Id =: asset2.Related_Feed_Item__c AND Type = 'ContentPost' LIMIT 2];

        uw_BET__c bet2 = [SELECT Id, Presentation_Id__c FROM uw_BET__c WHERE Id =: betWrapper2.BET.Id];

        System.assertEquals(null, bet2.Presentation_Id__c);

        // Start test
        Test.startTest();
        BET_PresentationBatch batchMapping = new  BET_PresentationBatch();
        Database.executeBatch(batchMapping, 10);
        Test.stopTest();

        bet2 = [SELECT Id, Presentation_Id__c FROM uw_BET__c WHERE Id =: betWrapper2.BET.Id];

        System.assertNotEquals(null, bet2.Presentation_Id__c);
    }

    /*******************************************************************
    Purpose: Method to test populating presentation ID
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void populatePresentation1000BETs(){
        integer BETNo = 10;
        integer maxAssets = 20;        
        integer assetsPerBet = maxAssets/BETNo;
        integer makeEachXthAssetPresentation = 2;

        User userOne = BET_TestingHelper.createAdminUser('Test2BET', 'test2BET@force.com', 'Test2BET');

        system.runAs(userOne) {
            //create BETs
            List<uw_BET__c> bets = new List<uw_BET__c>();
            for( integer i=0; i<BETNo; i++) {
                BET_TestingHelper.BET_TestingData betWrapper = BET_TestingHelper.initBET('TEST BET UT' + String.valueOf(i), false);
                bets.add(betWrapper.BET);
            }

            insert bets;
            bets = [SELECT Status__c, Sharing__c, Inoplan_Project__c, Studio_Chatter_Group__c, Id, Name, Category__c,
                            Sub_Category__c, Brand_Keyword_Search__c, Inoplan_Project_Keyword_Search__c, 
                            Category_Keyword_Search__c, Owner_Keyword_Search__c, uw_Brand__c, OwnerId, Owner.Email,
                            Owner.Name, Presentation_Id__c, Is_Archived__c, Banner_1_Location__c, Icon_Location__c, First_release_date__c,
                            Final_release_date__c, Launch_Date__c FROM uw_BET__c WHERE Id =: bets];

            List<uw_Asset__c> assets = createAssetsForBets(bets, assetsPerBet);


            List<uw_Asset__c> presentationAssets = new List<uw_Asset__c>();
            Map<Id, uw_Asset__c> BETIdToAsset = new Map<Id, uw_Asset__c>();
            for(integer i=0; i<assets.size(); i++) {
                if (Math.mod(i, makeEachXthAssetPresentation)==0) {
                    uw_Asset__c asset = assets[i];
                    asset.Big_Think_Pack__c = true;
                    asset.Promoted__c = true;
                    asset.Think_Big_Promotion_Date__c = Datetime.newInstance(getRandomInt(2013,2017), getRandomInt(1,10), getRandomInt(1,28), getRandomInt(1,11), getRandomInt(1,59), getRandomInt(1,59));
                    presentationAssets.add(asset);
                    if (BETIdToAsset.containsKey(asset.uw_BET__c)) {
                        if (BETIdToAsset.get(asset.uw_BET__c).Think_Big_Promotion_Date__c < asset.Think_Big_Promotion_Date__c) {
                            BETIdToAsset.put(asset.uw_BET__c, asset);
                        }
                    } else {
                        BETIdToAsset.put(asset.uw_BET__c, asset);
                    }
                }
            }
            
            update presentationAssets;//all presentation assets, but only the last one is set as presentationId
            presentationAssets = BETIdToAsset.values();


            Map<Id, Id> BETIdToFeedItemId = new Map<Id, Id>();
            Map<Id, Id> feedItemIdToContentVersionId = new Map<Id, Id>();
            Map<Id, Id> contentVersionIdToContentDocumentId = new Map<Id, Id>();
            Set<Id> feedItemIds = new Set<Id>();
            for(uw_Asset__c presentationAsset : presentationAssets) {
                feedItemIds.add(presentationAsset.Related_Feed_Item__c);
                BETIdToFeedItemId.put(presentationAsset.uw_BET__c, presentationAsset.Related_Feed_Item__c);
            }

    system.debug(feedItemIds);       
            //get content version Id object related to feed item
            for (CollaborationGroupFeed f: [SELECT Id, RelatedRecordId FROM CollaborationGroupFeed WHERE Id =: feedItemIds AND Type = 'ContentPost']){
                if (f.RelatedRecordId == null) {
                    continue;
                }
                feedItemIdToContentVersionId.put(f.Id, f.RelatedRecordId);
            }

    system.debug(feedItemIdToContentVersionId);
            //get content document id related to the contentVerion
            Set<Id> relatedRecordIds = new Set<id>();
            relatedRecordIds.addAll(feedItemIdToContentVersionId.values());
            for (ContentVersion cv : [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: relatedRecordIds]) {
                contentVersionIdToContentDocumentId.put(cv.Id, cv.ContentDocumentId);
            }

    system.debug(contentVersionIdToContentDocumentId);       

            // Start test
            Test.startTest();
            BET_PresentationBatch batchMapping = new  BET_PresentationBatch();
            Database.executeBatch(batchMapping, bets.size());
            Test.stopTest();

            bets = [SELECT Id, Presentation_Id__c FROM uw_BET__c WHERE Id =: bets];

            //populate presentation Id if there is a content Document object related to the feed item
            Id feedItemId;
            Id contentVersionId;
            integer counter = 0;
            for(uw_BET__c bet : bets){
                if(bet.Presentation_Id__c != null) {
                    if (!BETIdToFeedItemId.containsKey(bet.ID)) {
                        System.assert(false);
                    } else {
                        feedItemId = BETIdToFeedItemId.get(bet.ID);
                        if (!feedItemIdToContentVersionId.containsKey(feedItemId)) {
                            system.assert(false);
                        } else {
                            contentVersionId = feedItemIdToContentVersionId.get(feedItemId);
                            if (!contentVersionIdToContentDocumentId.containsKey(contentVersionId)) {
                                system.assert(false);
                            } else {
                                bet.Presentation_Id__c = contentVersionIdToContentDocumentId.get(contentVersionId);
                                counter++;
                            }
                        }
                    }
                }
            }
            system.assertEquals(presentationAssets.size(), counter);
        }
    }

    private static List<uw_Asset__c> createAssetsForBets(List<uw_BET__c> BETS, integer assetsPerBet) {
        List<uw_Asset__c> assets = new List<uw_Asset__c>();
        List<FeedItem> feedItems = new List<FeedItem>();
        integer counter = 0;
        for(uw_BET__c BET : BETS) {
            for(integer i=0; i<assetsPerBet; i++) {
                feedItem assetFeedItem = new FeedItem(
                    ParentId = BET.Studio_Chatter_Group__c,
                    Body = BET.Id,
                    ContentFileName = 'Presentation' + String.valueOf(counter) + '.ppt',
                    ContentData = EncodingUtil.base64Decode('test')
                );
                feedItems.add(assetFeedItem);
            }
        }
        insert feedItems;

        for (FeedItem fi : feedItems) {
            uw_Asset__c asset = new uw_Asset__c(
                Name                 = fi.ContentFileName,
                uw_BET__c            = fi.Body,
                Sub_Function__c      = BET_TestingHelper.ASSET_SUBFUNCTION_BD,
                Studio_Asset_Type__c = BET_TestingHelper.ASSET_STUDIOTYPE_PRESENTATION,
                Media_Type__c        = BET_TestingHelper.ASSET_MEDIATYPE_BETPRESENTATION,
                Status__c            = BET_TestingHelper.ASSET_STATUS_APPROVED,
                Related_Feed_Item__c = fi.id,
                Country__c           = BET_TestingHelper.UT_COUNTRY,
                URL_of_Asset__c      = BET_TestingHelper.UT_ASSETDOWNLOADLINK,
                thumbnail__c         = BET_TestingHelper.UT_ASSETTHUMBLINK
            );
            assets.add(asset);
        }
        insert assets;

        return assets;
    }

    private static Integer getRandomInt (Integer lower, Integer upper){
        return Math.round(Math.random() * (upper - lower)) + lower;
    }
}