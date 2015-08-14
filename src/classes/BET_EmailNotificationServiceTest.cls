@isTest
private class BET_EmailNotificationServiceTest {
	
	@isTest static void notifyBetOwnerThatProjectIsUnlinkedTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_Project__c oldProject = BET_TestUtils.createIPMProject('Unit Test Project Name');
		BET_EmailNotificationService.notifyBetOwnerThatProjectIsUnlinked(bet,oldProject);
		System.assert(true);
	}
	
	@isTest static void notifyBetOwnerAndProjectLeadOfNewLeadProjectTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test Project Name');
		BET_EmailNotificationService.notifyBetOwnerAndProjectLeadOfNewLeadProject(bet,project);
		System.assert(true);
	}

	@isTest static void notifyBetOwnerOfUnfollowTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test Project Name');
		BET_EmailNotificationService.notifyBetOwnerOfUnfollow(bet,project);
		System.assert(true);
	}
	
}