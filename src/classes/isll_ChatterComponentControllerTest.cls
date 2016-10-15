@IsTest
public with sharing class isll_ChatterComponentControllerTest {
	
	private static ID chatterGroupID;
	private static List<FeedItem> chatterFeeds;
	
	static private void initData(){ 

		// Constant values
		String CHATTER_GROUP 	= 'ISLL Chatter Group';
		String ISLL_NAME		= 'Internal Sustainable Living Lab Test';

		// Custom Settings
		ISLL_Custom_Settings__c chatterGroupName 	= isll_TestData.createISLLCustomSetting(CHATTER_GROUP);
		chatterGroupName.String_Value__c 			= ISLL_NAME;
		insert chatterGroupName;
		
		CollaborationGroup chatterGroup = isll_TestData.createChatterGroup(ISLL_NAME);             
		insert chatterGroup;
			
		chatterGroupID = chatterGroup.id;
		
		chatterFeeds = new List<FeedItem>();
		
		for(integer i = 0; i < 10; i++) {
			//chatterFeeds.add(new FeedItem(ParentId = chatterGroupID, Type = 'TextPost', Body = 'test body: '+i));
			chatterFeeds.add(isll_TestData.createFeedItem(chatterGroupID, 'Test Body: ' + i));
		}
		 
		insert chatterFeeds;
	}
	
	static testMethod void testGetIsllChatterGroupID(){
		initData();
		test.startTest();
			system.assertEquals(chatterGroupID, isll_ChatterComponentController.isllChatterGroupID);
		test.stopTest();	 	
	}
	
	static testMethod void testGetGroupFeed(){
		initData();
		test.startTest();
			system.assert(isll_ChatterComponentController.getGroupFeed().size() > 0);
		test.stopTest();
	}
	 

	static testMethod void testShareFile(){
		initData();
		ContentVersion cv = isll_TestData.createContentVersion();
        insert cv;
        
        cv = [select ContentDocumentId from ContentVersion where id = :cv.id];
        
        isll_ChatterComponentController controller = new isll_ChatterComponentController();
        
        test.startTest();
        	controller.postText = 'from test';
        	controller.shareFile(cv.id);

        	controller.shareNews('http://link.com','Test Link');
        test.stopTest();
	}
	
	static testMethod void testExpertsFeed(){
		initData();
		
		Apexpages.currentPage().getParameters().put('chatterId', chatterGroupID);
		isll_ChatterComponentController cntr = new isll_ChatterComponentController();
		
		system.assertNotEquals(0, cntr.getExpertsFeed().size());
		
		cntr.isFiltered = true;
		system.assertEquals(0, cntr.getExpertsFeed().size());
	} 
	  
}