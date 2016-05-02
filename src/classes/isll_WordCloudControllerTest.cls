/**********************************************************************
 Name:  isll_WordCloudControllerTest
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose:the test class for the word cloud                                                         
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Shyam Bhundia     30/07/2013        INITIAL DEVELOPMENT         Story id:USLL-179  	
 
***********************************************************************/
@IsTest
private class isll_WordCloudControllerTest {
	static testMethod void testWordCloud() {

		ISLL_Custom_Settings__c chatterGroupName 	= isll_TestData.createISLLCustomSetting(isll_TestData.CHATTER_GROUP);
		chatterGroupName.String_Value__c 			= isll_TestData.ISLL_NAME + ' TestWCC';
		insert chatterGroupName;

		CollaborationGroup grp = isll_TestData.createChatterGroup(isll_TestData.ISLL_NAME + ' TestWCC');
		insert grp;

		List<FeedItem> feedlist = new List<FeedItem>();
		for (Integer i = 0; i < 10; i++) {
			FeedItem fi = isll_TestData.createFeedItem(grp.Id, '#topic1');
			feedlist.add(fi);
		}
		for (Integer i = 0; i < 5; i++) {
			FeedItem fi = isll_TestData.createFeedItem(grp.Id, '#topic2');
			feedlist.add(fi);
		}
		for (Integer i = 0; i < 2; i++) {
			FeedItem fi = isll_TestData.createFeedItem(grp.Id, '#topic3');
			feedlist.add(fi);
		}
		insert feedList;

		isll_WordCloudController controller = new isll_WordCloudController();

		Test.startTest();

		List<isll_WordCloudController.topicWrapper> topicsWrapped = controller.getTrendingTopics();
		system.assertNotEquals(null, topicsWrapped);
		system.assert(topicsWrapped.size() > 0);
		
		Test.stopTest();
	}
}