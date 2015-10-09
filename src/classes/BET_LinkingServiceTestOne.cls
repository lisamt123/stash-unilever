@isTest
private class BET_LinkingServiceTestOne {
	
	private static final String IPM_PROJECT_NAME = 'Unit Test IPM Project';

	@isTest static void UnFollowTest() {
		Test.startTest();
		Id ProjectId = BET_TestUtils.createIPMProject(IPM_PROJECT_NAME).id;
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		bet.IPM_Project__c = ProjectId;
		insert bet;
		Id BetId = bet.id;
		BET_LinkingService.UnFollow(ProjectId, BetId);
		bet = [select IPM_Project__c from uw_Bet__c where id=:BetId];
		System.assert(bet.IPM_Project__c == null,'Bet should not have lead ipm project set');
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
		System.assert(bet.IPM_Project__c == null,'Bet should not have lead ipm project set');
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
		System.assertEquals(bet.IPM_Project__c,fproject.id,'Should have lead project set for BET');
		Test.stopTest();
	}

	@isTest static void checkIfFollowRequestShouldBeAutoapprovedTest(){
		Test.startTest();
		uw_Bet__c relatedBet = BET_TestUtils.getTestBet();
		relatedBet.ownerid = UserInfo.getUserId();
		insert relatedBet;
		System.assert(BET_LinkingService.checkIfFollowRequestShouldBeAutoapproved(relatedBet , new List<Id> {UserInfo.getUserId()}),'Follow request should be autoapproved');
		Test.stopTest();
	}

	@isTest static void createFollowRequestTest(){
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_BETWrapper project = new IPM_BETWrapper(BET_TestUtils.createIPMProject(IPM_PROJECT_NAME));
		BET_Follow_Request__c request = BET_LinkingService.createFollowRequest(project, 
										bet, new List<Id> {UserInfo.getUserId()});
		System.assertEquals(request.Status__c,BET_LinkingService.FOLLOW_STATUS_NEW,'Request status should be set to New');
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
		System.assertEquals(requests.size(),1,'There should be one request');
		Test.stopTest();
	}

	@isTest static void shouldMarkRequestAsLeadRequestTest(){
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		System.assert(BET_LinkingService.shouldMarkRequestAsLeadRequest(bet),'Request should be marked as lead request');
		Test.stopTest();
	}
}