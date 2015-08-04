@isTest
private class BET_LinkingSeviceTest {
	
	private static final String IPM_PROJECT_NAME = 'Unit Test IPM Project';

	@isTest static void setASLeadTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		try{
			BET_LinkingSevice.setASLead(ProjectId, BetId);
			System.assert(true);
		}catch(Exception e){
			System.assert(false);
		}
	}
	
	@isTest static void FollowTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		try{
			BET_LinkingSevice.Follow(ProjectId, BetId, new List<Id> {UserInfo.getUserId()});
			System.assert(true);
		}catch(Exception e){
			System.assert(false);
		}
	}

	@isTest static void FollowBetNotExistsTest() {
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		try{
			BET_LinkingSevice.Follow(ProjectId, null, new List<Id> {UserInfo.getUserId()});
			System.assert(false);
		}catch(BET_CustomBETException e){
			System.assertEquals(e.getMessage(),Label.BET_FollowBetNotExistsMessage);
		}
	}

	@isTest static void FollowBetArchivedTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		bet.Is_Archived__c = true;
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		try{
			BET_LinkingSevice.Follow(ProjectId, BetId, new List<Id> {UserInfo.getUserId()});
			System.assert(false);
		}catch(BET_CustomBETException e){
			System.assertEquals(e.getMessage(),Label.BET_FollowBetArchivedMessage);
		}
	}

	@isTest static void FollowProjectNotExistsTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id BetId = bet.id;
		try{
			BET_LinkingSevice.Follow(null, BetId, new List<Id> {UserInfo.getUserId()});
			System.assert(false);
		}catch(BET_CustomBETException e){
			System.assertEquals(e.getMessage(),Label.BET_FollowProjectNotExistsMessage);
		}
	}

	@isTest static void UnFollowTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		try{
			BET_LinkingSevice.UnFollow(ProjectId, BetId);
			System.assert(true);
		}catch(Exception e){
			System.assert(false);
		}
	}

	@isTest static void checkIfFollowRequestShouldBeAutoapprovedTest(){
		uw_Bet__c relatedBet = BET_TestUtils.getTestBet();
		relatedBet.ownerid = UserInfo.getUserId();
		insert relatedBet;
		System.assert(BET_LinkingSevice.checkIfFollowRequestShouldBeAutoapproved(relatedBet , new List<Id> {UserInfo.getUserId()}));
	}

	@isTest static void createFollowRequestTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_Follow_Request__c request = BET_LinkingSevice.createFollowRequest(BET_TestUtils.createIPMProject(IPM_PROJECT_NAME), 
										bet, new List<Id> {UserInfo.getUserId()},true);
		System.assertEquals(request.Status__c,BET_LinkingSevice.FOLLOW_STATUS_APPROVED);
	}

	@isTest static void createRelatedMemberRequestsTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_Follow_Request__c request = BET_LinkingSevice.createFollowRequest(BET_TestUtils.createIPMProject(IPM_PROJECT_NAME), 
										bet, new List<Id> {UserInfo.getUserId()},true);
		List<Id> requests = BET_LinkingSevice.createRelatedMemberRequests(request,bet,new List<Id> {UserInfo.getUserId()});
		System.assertEquals(requests.size(),1);
	}

	@isTest static void shouldMarkRequestAsLeadRequestTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		System.assert(BET_LinkingSevice.shouldMarkRequestAsLeadRequest(bet));
	}
	
}