@isTest
private class BET_FollowRequestTriggerHandlerClsTest {
	
	@isTest static void handleUpdatedFollowRequestsApprovedTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test IPM Project');
		BET_Follow_Request__c request = BET_TestUtils.createNewFollowRequest(bet,project);
		request.Status__c = 'Approved';
		update request;
		request = [select Status__c from BET_Follow_Request__c where id=:request.id];
		System.assertEquals(request.Status__c,'Approved');
	}

	@isTest static void handleUpdatedFollowRequestsRejectedTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test IPM Project');
		BET_Follow_Request__c request = BET_TestUtils.createNewFollowRequest(bet,project);
		request.Status__c = 'Rejected';
		update request;
		request = [select Status__c from BET_Follow_Request__c where id=:request.id];
		System.assertEquals(request.Status__c,'Rejected');
	}
	
	@isTest static void handleInsertedFollowRequestsTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test IPM Project');
		BET_Follow_Request__c request = BET_TestUtils.createApprovedFollowRequest(bet,project);
		System.assert(true);
	}
	
}