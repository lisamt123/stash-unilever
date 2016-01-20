/**********************************************************************
Name: uw_BETDetailService_Test
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: test for uw_BETDetailService
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             22/12/2014      INITIAL DEVELOPMENT
**********************************************************************/

@isTest
private class uw_BETDetailService_Test {
    public class TestingHelper{
        public User testUserOne;
        public User testUserTwo;
        public Id aid;

        public uw_Asset__c testAssetOne;
        public FeedItem testAssetDraftOne;

        public uw_Brand__c testBrand;
        public uw_BET__c testBet;

        private void prepareData(){
            BET_TestingHelper.BET_TestingData BETWrapper = BET_TestingHelper.initBET('BET UT Test', true);
            BETWrapper.addManager();

            uw_BET__c bet = BETWrapper.BET;

            testUserOne = BET_TestingHelper.getDefaultManager();
            testUserTwo = BET_TestingHelper.createAdminUser('Test2BET', 'test2BET@force.com', 'Test2BET');

            testAssetDraftOne = new FeedItem(ParentId = bet.Studio_Chatter_Group__c, Body = 'Some Content3', Type='ContentPost', ContentFileName='test.jpg', ContentData=EncodingUtil.base64Decode('test'));
            insert testAssetDraftOne;

            uw_Asset__c file1 = BETWrapper.addCreativeWork('Test 1', BET_TestingHelper.ASSET_STATUS_APPROVED, BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL);
            FeedComment fComment = new FeedComment(FeedItemId = file1.Related_Feed_Item__c, CommentBody = 'Test');
            insert fComment;
            file1.Related_Feed_Comment__c = fComment.Id;
            update file1;
          
            uw_Asset__c file2 = BETWrapper.addCreativeWork('Test2', BET_TestingHelper.ASSET_STATUS_DRAFT, BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL);

            uw_Asset__c file3 = BETWrapper.addAsset('Test1', BET_TestingHelper.ASSET_SUBFUNCTION_BB, '', BET_TestingHelper.ASSET_STATUS_SHARED, BET_TestingHelper.ASSET_MEDIATYPE_SOCIALMEDIA);

            testAssetOne = file1;
            testBet = bet;
        }
    }

    static testMethod void testMethodOne(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();

        System.runAs(helper.testUserOne){
            uw_BETDetailService.getBETDetails(helper.testBet.Id, helper.testUserOne.Id);
        }

        System.runAs(helper.testUserTwo){
            uw_BETDetailService.getBETDetails(helper.testBet.Id, helper.testUserTwo.Id);
            try{            
                uw_BETDetailService.getBETDetails('invalid Id', helper.testUserTwo.Id);
            }catch(Exception qe){
                System.assertEquals('No BET found.', qe.getMessage());    
            }
        }
        
        uw_BETWrapper.AssetWrapper wrap = uw_BETDetailService.getBETAssets(helper.testBet.Id, BET_TestingHelper.ASSET_MEDIATYPE_SOCIALMEDIA, BET_TestingHelper.UT_COUNTRY, BET_TestingHelper.ASSET_SUBFUNCTION_BB, 1, 1, true, false, 'assetLastUpdated');
        List<uw_BETWrapper.AssetItem> assetList = wrap.assetResult;
        System.assertEquals(1, assetList.size());

        List<uw_BETWrapper.FilterLineItemWrapper> filterList = wrap.searchFilters;
        System.assertEquals(1, assetList.size());

    }

    static testMethod void testMethodTwo(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();

        uw_BET__c bet = helper.testBet;     

        uw_BETWrapper.AssetWrapper wrap2 = uw_BETDetailService.getBETAssets(helper.testBet.Id, BET_TestingHelper.ASSET_MEDIATYPE_KEYVISUAL, BET_TestingHelper.UT_COUNTRY,BET_TestingHelper.ASSET_SUBFUNCTION_BD, 1, 1, false, false, 'assetMediaType');
        List<uw_BETWrapper.AssetItem> assetList2 = wrap2.assetResult;
        System.assertEquals(1, assetList2.size());

        List<uw_BETWrapper.FilterLineItemWrapper> filterList2 = wrap2.searchFilters;
        System.assertEquals(0, filterList2.size());
    }

    static testMethod void testMethodThree(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();

        uw_BET__c bet = helper.testBet;     

        uw_BETWrapper.AssetWrapper wrap3 = uw_BETDetailService.getBETAssets(helper.testBet.Id, '', '',BET_TestingHelper.ASSET_STATUS_DRAFT, 1, 1, true, false, '');
        List<uw_BETWrapper.AssetItem> assetList3 = wrap3.assetResult;
        System.assertEquals(1, assetList3.size());
    }

    static testMethod void testMethodFour(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();

        uw_BET__c bet = helper.testBet;     

        uw_BETWrapper.AssetWrapper wrap4 = uw_BETDetailService.getBETAssets(helper.testBet.Id, 'Key', '',BET_TestingHelper.ASSET_STATUS_DRAFT, 1, 1, true, false, '');
        System.assertEquals(null, wrap4.assetResult);
    }

    static testMethod void testMethodFive(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();

        System.runAs(helper.testUserOne){
            uw_BETDetailService.deleteBETAsset(helper.testBet.Id, helper.testAssetOne.Id);
        }
    }

    static testMethod void testMethodSix(){
      TestingHelper helper = new TestingHelper();
      helper.prepareData();

      uw_BET__c bet = helper.testBet;   

      List<uw_BETWrapper.DraftItem> wrapList =  uw_BETDetailService.getBETChatterFiles(helper.testBet.Id, 1, 1, false, 'draftCreatedDate');
      System.assertEquals(1, wrapList.size());

      System.runAs(helper.testUserOne){
         uw_BETDetailService.chatterFileToDraftAsset(helper.testBet.Id, helper.testAssetDraftOne.Id);
      }
      List<uw_BETWrapper.DraftItem> wrapList2 =  uw_BETDetailService.getBETChatterFiles(helper.testBet.Id, 1, 1, false, 'draftCreatedDate');
      System.assertEquals(0, wrapList2.size());
    }

    static testMethod void testMethodSeven(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();

        uw_BET__c bet = helper.testBet;   
        List<uw_BETWrapper.DraftItem> wrapList;
        System.runAs(helper.testUserOne){
           wrapList =  uw_BETDetailService.getBETChatterFiles(helper.testBet.Id, 1, 1, false, 'draftCreatedDate');
        }
        System.assertEquals(1, wrapList.size());
    }

    static testMethod void testMethodEight(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();

        uw_BET__c bet = helper.testBet;
        List<uw_BETWrapper.DraftItem> wrapList;
        System.runAs(helper.testUserOne){
            uw_BETDetailService.deleteChatterFileDraft(helper.testAssetDraftOne.Id);
            wrapList = uw_BETDetailService.getBETChatterFiles(helper.testBet.Id, 1, 1, false, 'CreatedDate');
        }
        System.assertEquals(0, wrapList.size());
    }

    static testMethod void testMethodNine(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();

        uw_BET__c bet = helper.testBet;  
        
        List<uw_BETWrapper.AssetItem> assetList3;
        System.runAs(helper.testUserOne){
            uw_BETWrapper.AssetWrapper wrap3 = uw_BETDetailService.getBETAssets(helper.testBet.Id, '', '',BET_TestingHelper.ASSET_STATUS_DRAFT, 1, 1, true, false, '');
            assetList3 = wrap3.assetResult;
        }
        System.assertEquals(1, assetList3.size());
    }

    static testMethod void testMethodTen(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST', true);

        List<uw_BET_Team_Member__c> members = [SELECT Id FROM uw_BET_Team_Member__c WHERE Team_Member__c =: wrap.owner.Id];
        delete members;

        System.runAs(wrap.owner){
            uw_BETDetailService.getBETDetails(wrap.BET.Id, wrap.owner.Id);  
        }
    }
    
    static testMethod void testMethodEleven(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST', true);

        FeedItem assetFeedItem = new FeedItem(
            ParentId = wrap.BET.Studio_Chatter_Group__c,
            Body = 'Some Content',
            ContentFileName = 'fileName',
            ContentData = EncodingUtil.base64Decode('test')
        );

        insert assetFeedItem;

        System.runAs(wrap.owner){
            uw_BETDetailService.chatterFileToDraftAsset(wrap.BET.Id, assetFeedItem.Id);  
        }

        List<uw_Asset__c> assetList = [select Id from uw_Asset__c where uw_BET__c =: wrap.BET.Id];

        System.assertEquals(1, assetList.size());
    }
}