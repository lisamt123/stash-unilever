@isTest
private class BET_LinkingServiceTest {
	
	private static final String IPM_PROJECT_NAME = 'Unit Test IPM Project';

	@isTest static void setASLeadTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		try{
			BET_LinkingService.setASLead(ProjectId, BetId);
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
			Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        	User testUser = new User(Alias = 'newBet', Email='nebetTestUSr@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='newBetTestUsr', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='nebetTestUSr@testorg.com',isActive = true);
        	insert testUser;
			BET_LinkingService.Follow(ProjectId, BetId, new List<Id>{testUser.id});
			List<BET_Member_Request__c> relatedMemberRequests = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c =: BetId];
			List<BET_Follow_Request__c> followRequests = [select id from BET_Follow_Request__c where Brand_Experience_Toolkit__c =: BetId];
			System.assertEquals(relatedMemberRequests.size(),1);
			System.assertEquals(followRequests.size(),1);
		}catch(Exception e){
			System.assert(false);
		}
	}

	@isTest static void FollowTestWithoutMemberRequestIfSameAsBETOwner() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		try{
			BET_LinkingService.Follow(ProjectId, BetId, new List<Id>{UserInfo.getUserId()});
			List<BET_Member_Request__c> relatedMemberRequests = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c =: BetId];
			List<BET_Follow_Request__c> followRequests = [select id from BET_Follow_Request__c where Brand_Experience_Toolkit__c =: BetId];
			System.assertEquals(relatedMemberRequests.size(),0);
			System.assertEquals(followRequests.size(),1);
		}catch(Exception e){
			System.assert(false);
		}
	}

	@isTest static void FollowBetNotExistsTest() {
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		try{
			BET_LinkingService.Follow(ProjectId, null, new List<Id> {UserInfo.getUserId()});
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
			BET_LinkingService.Follow(ProjectId, BetId, new List<Id> {UserInfo.getUserId()});
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
			BET_LinkingService.Follow(null, BetId, new List<Id> {UserInfo.getUserId()});
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
			BET_LinkingService.UnFollow(ProjectId, BetId);
			System.assert(true);
		}catch(Exception e){
			System.assert(false);
		}
	}

	@isTest static void checkIfFollowRequestShouldBeAutoapprovedTest(){
		uw_Bet__c relatedBet = BET_TestUtils.getTestBet();
		relatedBet.ownerid = UserInfo.getUserId();
		insert relatedBet;
		System.assert(BET_LinkingService.checkIfFollowRequestShouldBeAutoapproved(relatedBet , new List<Id> {UserInfo.getUserId()}));
	}

	@isTest static void createFollowRequestTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_Follow_Request__c request = BET_LinkingService.createFollowRequest(BET_TestUtils.createIPMProject(IPM_PROJECT_NAME), 
										bet, new List<Id> {UserInfo.getUserId()});
		System.assertEquals(request.Status__c,BET_LinkingService.FOLLOW_STATUS_NEW);
	}

	@isTest static void createRelatedMemberRequestsTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_Follow_Request__c request = BET_LinkingService.createFollowRequest(BET_TestUtils.createIPMProject(IPM_PROJECT_NAME), 
										bet, new List<Id> {UserInfo.getUserId()});
		List<Id> requests = BET_LinkingService.createRelatedMemberRequests(request,bet,new List<Id> {UserInfo.getUserId()});
		System.assertEquals(requests.size(),1);
	}

	@isTest static void shouldMarkRequestAsLeadRequestTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		System.assert(BET_LinkingService.shouldMarkRequestAsLeadRequest(bet));
	}
	
}