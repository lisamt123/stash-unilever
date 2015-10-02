@isTest
private class BET_FollowRequestTriggerHandlerClsTest {
	
	@isTest static void handleUpdatedFollowRequestsApprovedTest() {
		Test.startTest();
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test IPM Project');
		BET_Follow_Request__c request = BET_TestUtils.createNewFollowRequest(bet,project);
		request.Status__c = BET_LinkingService.FOLLOW_STATUS_APPROVED;
		update request;
		request = [select Status__c from BET_Follow_Request__c where id=:request.id];
		System.assertEquals(request.Status__c,BET_LinkingService.FOLLOW_STATUS_APPROVED,'Request should be Approved');
		Test.stopTest();
	}

	@isTest static void handleUpdatedFollowRequestsRejectedTest() {
		Test.startTest();
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test IPM Project');
		BET_Follow_Request__c request = BET_TestUtils.createNewFollowRequest(bet,project);
		request.Status__c = BET_LinkingService.FOLLOW_STATUS_REJECTED;
		update request;
		request = [select Status__c from BET_Follow_Request__c where id=:request.id];
		System.assertEquals(request.Status__c,BET_LinkingService.FOLLOW_STATUS_REJECTED,'Request should be Rejected');
		Test.stopTest();
	}
	
	@isTest static void handleInsertedFollowRequestsTest() {
		Test.startTest();
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test IPM Project');
		BET_Follow_Request__c request = BET_TestUtils.createApprovedFollowRequest(bet,project);
		request = [select Status__c from BET_Follow_Request__c where id=:request.id];
		System.assertEquals(request.Status__c,BET_LinkingService.FOLLOW_STATUS_APPROVED,'Request should be Approved');
		Test.stopTest();
	}
	
}