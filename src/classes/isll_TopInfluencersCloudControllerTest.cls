/**********************************************************************
 Name:  isll_TopInfluencersCloudControllerTest
 Copyright © 2013  Unilever
======================================================
Purpose:                                                            
Test Class for isll_TopInfluencersCloudController
======================================================
History
-------
VERSION     AUTHOR              DATE            DETAIL              Description
   1.0      Liza Romanenko      30/07/2013      INITIAL DEVELOPMENT 
***********************************************************************/
@IsTest
private class isll_TopInfluencersCloudControllerTest {

	static private void initData(){  

		ISLL_Custom_Settings__c chatterGroupName 	= isll_TestData.createISLLCustomSetting(isll_TestData.CHATTER_GROUP);
		chatterGroupName.String_Value__c 			= isll_TestData.ISLL_NAME + ' TestSEC';
		insert chatterGroupName;

		CollaborationGroup grp = isll_TestData.createChatterGroup(isll_TestData.ISLL_NAME + ' TestSEC');
		insert grp;

		List<FeedItem> chatterFeeds = new List<FeedItem>();
		for (Integer i = 0; i < 10; i++) {
			chatterFeeds.add(isll_TestData.createFeedItem(grp.Id, 'Test body: ' + i));
		}
		insert chatterFeeds;

		FeedComment feedComment = isll_TestData.createFeedComment(chatterFeeds[0].Id);
		insert feedComment;
		
	}

    static testMethod void testTopInfluencersCloud() {
    	initData();
        isll_TopInfluencersCloudController controller = new isll_TopInfluencersCloudController();
        controller.numOfInfluencers = 39;
	
		Test.startTest();

		List<isll_TopInfluencersCloudController.userWrapper> usersWrapped = controller.getTopInfluencers();
		system.assertNotEquals(null, usersWrapped);
		system.assert(usersWrapped.size() > 0);
		
		Test.stopTest();
    }
}