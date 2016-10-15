/**********************************************************************
 Name:  isll_DeleteChatterHistoryControllerTest
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose:The test class for isll_DeleteChatterHistoryController                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Shyam Bhundia     31/07/2013        INITIAL DEVELOPMENT         Story id:USLL-180   	
 
***********************************************************************/
@isTest
private class isll_DeleteChatterHistoryControllerTest {
	
	static private void initData() {
		List<Chatter_History__c> chatterHistoryList = new List<Chatter_History__c>();
		
		for (integer i = 0; i < 10; i++) {
			chatterHistoryList.add(isll_TestData.createChatterHistory());
		}
		insert chatterHistoryList;
	}
	
	static testMethod void deleteNoChatterHistory() {
		isll_DeleteChatterHistoryController controller = new isll_DeleteChatterHistoryController();
		
		Test.startTest();
		
		controller.deleteAllChatterHistory();
		
		List<Apexpages.Message> msgs = ApexPages.getMessages();
		boolean found = false;
		for (Apexpages.Message msg:msgs) {
		    if (msg.getDetail().contains('No Chatter history to delete')){
		    	 found = true;
		    }
		}
		system.assert(found);
		
		Test.stopTest();
	}
	
	static testMethod void deleteChatterHistorySuccess() {
		initData();
		isll_DeleteChatterHistoryController controller = new isll_DeleteChatterHistoryController();
		
		Test.startTest();
		
		controller.deleteAllChatterHistory();
		
		List<Apexpages.Message> msgs = ApexPages.getMessages();
		boolean found = false;
		for (Apexpages.Message msg:msgs) {
		    if (msg.getDetail().contains('Chatter history cleared')){
		    	 found = true;
		    }
		}
		system.assert(found);
		
		Test.stopTest();
	}
}