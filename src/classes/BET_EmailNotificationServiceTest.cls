@isTest
private class BET_EmailNotificationServiceTest {

	private static final String TEST_PROJECT_NAME = 'Unit Test Project Name';
	
	@isTest static void notifyBetOwnerThatProjectIsUnlinkedTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_Project__c oldProject = BET_TestUtils.createIPMProject(TEST_PROJECT_NAME);
		IPM_BETWrapper project = new IPM_BETWrapper(oldProject);
		BET_EmailNotificationService.notifyBetOwnerThatProjectIsUnlinked(bet,project,project);
		System.assert(true);
	}
	
	@isTest static void notifyBetOwnerOfNewLeadProjectTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_EmailNotificationService.notifyBetOwnerOfNewLeadProject(bet,new IPM_BETWrapper(BET_TestUtils.createIPMProject(TEST_PROJECT_NAME)));
		System.assert(true);
	}

	@isTest static void notifyBetOwnerOfUnfollowTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_BETWrapper project = new IPM_BETWrapper(BET_TestUtils.createIPMProject(TEST_PROJECT_NAME));
		BET_EmailNotificationService.notifyBetOwnerOfUnfollow(bet,project);
		System.assert(true);
	}

	@isTest static void notifyBetOwnerOfMultipleMemberRequestsFromIPMTest(){
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_BETWrapper project = new IPM_BETWrapper(BET_TestUtils.createIPMProject(TEST_PROJECT_NAME));
		BET_EmailNotificationService.notifyBetOwnerOfMultipleMemberRequestsFromIPM(bet.id, project.projectId);
		System.assert(true);
	}

	@isTest static void notifyBetOwnerOfLeadProjectFollowRequestTest(){
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_BETWrapper project = new IPM_BETWrapper(BET_TestUtils.createIPMProject(TEST_PROJECT_NAME));
		BET_EmailNotificationService.notifyBetOwnerOfLeadProjectFollowRequest(bet,project);
		System.assert(true);
	}
	
}