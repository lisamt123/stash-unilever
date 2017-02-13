/*************************************************************** 
    Name: Win_ChatterDeletedEndpoint_Test
    Copyright © 2016 Accenture
    ======================================================
    Purpose:
    -------
    Testing class for the ChatterDeletedEndpoint API
    ======================================================
    History
    -------
    VERSION     AUTHOR          DATE        DETAIL          Description
    1.0         Nicola Tassini  31/01/2017  Initial Dev     First version
***************************************************************/
@isTest
private class Win_ChatterDeletedEndpoint_Test {

	/**
	*	Test the API that returns the deleted chatter posts
	*/
	@isTest static void testDeleteFeed() {
		FeedItem feedItem = new FeedItem();
		feedItem.ParentId = UserInfo.getUserId();
		feedItem.Body = 'Test of my message....';
		insert feedItem;

		RestRequest req = new RestRequest();
    	System.RestContext.request = req;
		DateTime startTime = DateTime.now().addHours(-1);
		DateTime endTime = DateTime.now().addHours(1);
		req.addParameter('start', JSON.serialize(startTime).replace('"', ''));
		req.addParameter('end', JSON.serialize(endTime).replace('"', ''));
		
		Test.startTest();
		delete feedItem;
		WIN_ChatterDeletedEndpoint.GetDeletedResult result = WIN_ChatterDeletedEndpoint.getDeletedFeedItems();
		System.assertEquals(1, result.deletedRecords.size());
		Test.stopTest();
	}

	/**
	*	Test the API that returns the deleted chatter posts
	*/
	@isTest static void testDeleteFeedEmpty() {
		RestRequest req = new RestRequest();
    	System.RestContext.request = req;
		
		Test.startTest();
		WIN_ChatterDeletedEndpoint.GetDeletedResult result = WIN_ChatterDeletedEndpoint.getDeletedFeedItems();
		System.assertEquals(0, result.deletedRecords.size());
		Test.stopTest();
    }
}