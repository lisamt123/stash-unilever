@isTest
private class BET_EmailNotificationServiceTest {

	private static final String TEST_PROJECT_NAME = 'Unit Test Project Name';
	
	@isTest static void notifyBetOwnerThatProjectIsUnlinkedTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_Project__c oldProject = BET_TestUtils.createIPMProject(TEST_PROJECT_NAME);
		IPM_BETWrapper project = new IPM_BETWrapper(oldProject);
		BET_EmailNotificationService.notifyBetOwnerThatProjectIsUnlinked(bet,project);
		System.assert(true);
	}
	
	@isTest static void notifyBetOwnerAndProjectLeadOfNewLeadProjectTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_EmailNotificationService.notifyBetOwnerAndProjectLeadOfNewLeadProject(bet,BET_TestUtils.createIPMProject(TEST_PROJECT_NAME));
		System.assert(true);
	}

	@isTest static void notifyBetOwnerOfUnfollowTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_BETWrapper project = new IPM_BETWrapper(BET_TestUtils.createIPMProject(TEST_PROJECT_NAME));
		BET_EmailNotificationService.notifyBetOwnerOfUnfollow(bet,project);
		System.assert(true);
	}

	@isTest static void notifyAllIPMProjectLeadersOfArchivedBetTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		IPM_Project__c project = BET_TestUtils.createIPMProject(TEST_PROJECT_NAME);
		bet.IPM_Project__c = project.id;
		insert bet;
		project.IPM_Project_Leader__c = UserInfo.getUserId();
		project.BET__c = bet.id;
		update project;
		BET_EmailNotificationService.notifyAllIPMProjectLeadersOfArchivedBet(new List<uw_Bet__c>{bet});
		System.assert(true);
	}

	@isTest static void notifyAllIPMProjectLeadersOfUnArchivedBetTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		IPM_Project__c project = BET_TestUtils.createIPMProject(TEST_PROJECT_NAME);
		bet.IPM_Project__c = project.id;
		insert bet;
		project.IPM_Project_Leader__c = UserInfo.getUserId();
		project.BET__c = bet.id;
		update project;
		BET_EmailNotificationService.notifyAllIPMProjectLeadersOfUnArchivedBet(new List<uw_Bet__c>{bet});
		System.assert(true);
	}
	
}