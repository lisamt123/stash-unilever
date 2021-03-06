/**********************************************************************
Name: uw_BETDetailService_Test3
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
private class uw_BETDetailService_Test3 {
    public class TestingHelper{
        public User testUserOne;
        public User testUserTwo;
        public Id aid;

        public uw_Asset__c testAssetOne;
        public FeedItem testAssetDraftOne;

        public uw_Brand__c testBrand;
        public BET_Category__c testCategory;
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

    static testMethod void testMethodEighteen(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST', true);
        uw_Asset__c presentation = wrap.addPresentation('Test Presentation.PPT', BET_TestingHelper.ASSET_STATUS_APPROVED);

        FeedComment fComment = new FeedComment(FeedItemId = presentation.Related_Feed_Item__c, CommentBody = 'Test');
        insert fComment;

        presentation.Related_Feed_Comment__c = fComment.Id;
        update presentation;
        
        System.runAs(wrap.owner){
            try{            
                uw_BETDetailService.deleteBETAsset(wrap.BET.Id, presentation.Id);
            }catch(Exception qe){

            }                 
        }
    }
    
    //to cover exception
    static testMethod void testMethodTwelve(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();

        uw_BET__c bet = helper.testBet;  
        delete bet; 

        try{            
            uw_BETDetailService.deleteChatterFileDraft(helper.testAssetDraftOne.Id);
        }catch(Exception qe){

        }  
    }
    //to cover exception
    static testMethod void testMethodThirteen(){
        TestingHelper helper = new TestingHelper();
        helper.prepareData();

        uw_BET__c bet = helper.testBet;   
        delete bet;
        System.runAs(helper.testUserOne){
            try{         
                uw_BETDetailService.deleteBETAsset(helper.testBet.Id, helper.testAssetOne.Id);
            }catch(Exception qe){
                System.assertEquals(qe.getMessage(), 'No Asset found.');
            } 
        }
    }
    //to cover exception
    static testMethod void testMethodFourteen(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST', true);
        wrap.addMember();

        wrap.BET.Sharing__c = 'Public';
        update wrap.BET;   

        System.runAs(wrap.owner){
            uw_BETDetailService.getBETDetails(wrap.BET.Id, wrap.owner.Id);  
        }
    }
    //to cover exception
    static testMethod void testMethodFifteen(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('BETTEST', true);
        uw_Asset__c presentation = wrap.addPresentation('Test Presentation.PPT', BET_TestingHelper.ASSET_STATUS_APPROVED);
        System.runAs(wrap.owner){
            try{             
                uw_BETDetailService.deleteBETAsset(wrap.BET.Id, presentation.Id);
            }catch(Exception qe){
                System.assertEquals(qe.getMessage(), 'No Asset found.');    
            } 
        } 
    }
}