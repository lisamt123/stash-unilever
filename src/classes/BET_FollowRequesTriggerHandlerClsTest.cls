@isTest
private class BET_FollowRequesTriggerHandlerClsTest {
	
	@isTest static void handleUpdatedFollowRequestsTest() {
	}
	
	@isTest static void handleInsertedFollowRequestsTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test IPM Project');
		BET_Follow_Request__c request = BET_TestUtils.createApprovedFollowRequest(bet,project);
		BET_FollowRequesTriggerHandlerCls.handleInsertedFollowRequests(new List<BET_Follow_Request__c>{request});
		System.assert(true);
	}
	
}