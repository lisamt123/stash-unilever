@isTest
private class BET_LinkingSeviceTest {
	
	private static final String IPM_PROJECT_NAME = 'Unit Test IPM Project';

	@isTest static void setASLeadTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		BET_LinkingSevice.setASLead(ProjectId, BetId);
	}
	
	@isTest static void FollowTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		BET_LinkingSevice.Follow(ProjectId, BetId, new List<Id> {UserInfo.getUserId()});
	}

	@isTest static void UnFollowTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		BET_LinkingSevice.UnFollow(ProjectId, BetId);
	}
	
}