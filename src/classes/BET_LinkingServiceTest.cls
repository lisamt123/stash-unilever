@isTest
private class BET_LinkingServiceTest {
	
	private static final String IPM_PROJECT_NAME = 'Unit Test IPM Project';

	@isTest static void setASLeadTest() {
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		BET_LinkingService.setASLead(ProjectId, BetId);
		bet = [select IPM_Project__c from uw_Bet__c where id=:BetId];
		System.assertEquals(bet.IPM_Project__c,ProjectId);
		Test.stopTest();
	}
	
	@isTest static void FollowTest() {
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		
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
		Test.stopTest();
	}

	@isTest static void FollowTestWithoutMemberRequestIfSameAsBETOwner() {
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		
		BET_LinkingService.Follow(ProjectId, BetId, new List<Id>{UserInfo.getUserId()});
		List<BET_Member_Request__c> relatedMemberRequests = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c =: BetId];
		List<BET_Follow_Request__c> followRequests = [select id from BET_Follow_Request__c where Brand_Experience_Toolkit__c =: BetId];
		System.assertEquals(relatedMemberRequests.size(),0);
		System.assertEquals(followRequests.size(),1);
		Test.stopTest();
	}

	@isTest static void FollowBetNotExistsTest() {
		Test.startTest();
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		try{
			BET_LinkingService.Follow(ProjectId, null, new List<Id> {UserInfo.getUserId()});
			throw new BET_CustomBETException('unit test');
		}catch(BET_CustomBETException e){
			System.assertEquals(e.getMessage(),Label.BET_FollowBetNotExistsMessage);
		}
		Test.stopTest();
	}

	@isTest static void FollowBetArchivedTest() {
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		bet.Is_Archived__c = true;
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		try{
			BET_LinkingService.Follow(ProjectId, BetId, new List<Id> {UserInfo.getUserId()});
			throw new BET_CustomBETException('unit test');
		}catch(BET_CustomBETException e){
			System.assertEquals(e.getMessage(),Label.BET_FollowBetArchivedMessage);
		}
		Test.stopTest();
	}

	@isTest static void UnFollowTest() {
		Test.startTest();
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		bet.IPM_Project__c = ProjectId;
		insert bet;
		Id BetId = bet.id;
		BET_LinkingService.UnFollow(ProjectId, BetId);
		bet = [select IPM_Project__c from uw_Bet__c where id=:BetId];
		System.assert(bet.IPM_Project__c == null);
		Test.stopTest();
	}

	@isTest static void UnFollowLeadNoOtherProjectsTest(){
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		bet.IPM_Project__c = ProjectId;
		update bet;
		BET_LinkingService.UnFollow(ProjectId, BetId);
		bet = [select IPM_Project__c from uw_Bet__c where id=:BetId];
		System.assert(bet.IPM_Project__c == null);
		Test.stopTest();
	}

	@isTest static void UnFollowLeadWithOtherProjectsTest(){
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		bet.IPM_Project__c = ProjectId;
		update bet;

		IPM_Project__c fproject = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME+'_1');
		fproject.BET__c = bet.id;
		fproject.IPM_Target_Launch_Dates__c = date.today();
		update fproject;

		BET_LinkingService.UnFollow(ProjectId, BetId);
		bet = [select IPM_Project__c from uw_Bet__c where id=:BetId];
		System.assertEquals(bet.IPM_Project__c,fproject.id);
		Test.stopTest();
	}

	@isTest static void checkIfFollowRequestShouldBeAutoapprovedTest(){
		Test.startTest();
		uw_Bet__c relatedBet = BET_TestUtils.getTestBet();
		relatedBet.ownerid = UserInfo.getUserId();
		insert relatedBet;
		System.assert(BET_LinkingService.checkIfFollowRequestShouldBeAutoapproved(relatedBet , new List<Id> {UserInfo.getUserId()}));
		Test.stopTest();
	}

	@isTest static void createFollowRequestTest(){
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_BETWrapper project = new IPM_BETWrapper(BET_TestUtils.createIPMProject(IPM_PROJECT_NAME));
		BET_Follow_Request__c request = BET_LinkingService.createFollowRequest(project, 
										bet, new List<Id> {UserInfo.getUserId()});
		System.assertEquals(request.Status__c,BET_LinkingService.FOLLOW_STATUS_NEW);
		Test.stopTest();
	}

	@isTest static void createRelatedMemberRequestsTest(){
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_BETWrapper project = new IPM_BETWrapper(BET_TestUtils.createIPMProject(IPM_PROJECT_NAME));
		BET_Follow_Request__c request = BET_LinkingService.createFollowRequest(project, 
										bet, new List<Id> {UserInfo.getUserId()});
		List<Id> requests = BET_LinkingService.createRelatedMemberRequests(request,bet,new List<Id> {UserInfo.getUserId()});
		System.assertEquals(requests.size(),1);
		Test.stopTest();
	}

	@isTest static void shouldMarkRequestAsLeadRequestTest(){
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		System.assert(BET_LinkingService.shouldMarkRequestAsLeadRequest(bet));
		Test.stopTest();
	}
	
}