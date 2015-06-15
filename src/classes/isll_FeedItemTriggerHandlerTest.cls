/**********************************************************************
 Name:  isll_FeedItemHandlerTest
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose: The test class for the feed item handler                                                        
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Shyam Bhundia     30/07/2013        INITIAL DEVELOPMENT         Story id:USLL-191  	
 
***********************************************************************/

@IsTest
private class isll_FeedItemTriggerHandlerTest {
	private static List<FeedItem> chatterFeeds;
	
	/*******************************************************************
   	Purpose:  Sets up the data
 	********************************************************************/
	static private void initData(){
		id chatterGroupID; 
		List<CollaborationGroup> groups = [select id, name from CollaborationGroup where name = :isll_FeedItemTriggerHandler.GROUP_NAME];
		

		for(CollaborationGroup cg : groups){
			if(cg.Name == isll_FeedItemTriggerHandler.GROUP_NAME){
				chatterGroupID = cg .id;
			}
		}
		
		if(null == chatterGroupID){
			CollaborationGroup grp = new CollaborationGroup();
			grp.Name = isll_FeedItemTriggerHandler.GROUP_NAME;   
			grp.CollaborationType = 'Public'; 
			insert grp;
			chatterGroupID = grp.id;
		}
	    
	    chatterFeeds = new List<FeedItem>();
		
		for(integer i = 0; i < 10; i++){
			chatterFeeds.add(new FeedItem(ParentId = chatterGroupID, Type = 'TextPost', Body = 'test body: '+i));
		}
		
		insert chatterFeeds;
		
	}
	
	/*******************************************************************
   	Purpose:  Tests that when posts are deleted a chatter history record is created.
 	********************************************************************/
    static testMethod void deleteChatterPostTest() {
    	initData();
		test.startTest();
    
		delete chatterFeeds[0];
 
		test.stopTest();
    
		List<Chatter_History__c> chatterHistory = [select id, Feed_Owner__c, Deleting_Moderator__c, Feed_Contents__c from Chatter_History__c];
		
		system.assertNotEquals(null, chatterHistory);
		system.assert(chatterHistory.size() > 0);
		
		boolean found = false;
		for(Chatter_History__c ch : chatterHistory){
			if(ch.Feed_Contents__c == chatterFeeds[0].Body){
				found = true;
			}
		}
		
		system.assert(found);

    }

    /*******************************************************************
   	Purpose:  Tests that when posts are deleted a chatter history record is created.
 	********************************************************************/
    static testMethod void deleteChatterPostBulkTest() {
    	initData();
		test.startTest();
    
		delete chatterFeeds;
 
		test.stopTest();
    
		List<Chatter_History__c> chatterHistory = [select id, Feed_Owner__c, Deleting_Moderator__c, Feed_Contents__c from Chatter_History__c];
		
		system.assertNotEquals(null, chatterHistory);
		system.assertEquals(chatterFeeds.size(), chatterHistory.size());
		


    }
}