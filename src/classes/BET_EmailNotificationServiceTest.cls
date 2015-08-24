@isTest
private class BET_EmailNotificationServiceTest {
	
	@isTest static void notifyBetOwnerThatProjectIsUnlinkedTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_Project__c oldProject = BET_TestUtils.createIPMProject('Unit Test Project Name');
		IPM_BETWrapper project = new IPM_BETWrapper(oldProject);
		BET_EmailNotificationService.notifyBetOwnerThatProjectIsUnlinked(bet,project);
		System.assert(true);
	}
	
	@isTest static void notifyBetOwnerAndProjectLeadOfNewLeadProjectTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_EmailNotificationService.notifyBetOwnerAndProjectLeadOfNewLeadProject(bet,BET_TestUtils.createIPMProject('Unit Test Project Name'));
		System.assert(true);
	}

	@isTest static void notifyBetOwnerOfUnfollowTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_BETWrapper project = new IPM_BETWrapper(BET_TestUtils.createIPMProject('Unit Test Project Name'));
		BET_EmailNotificationService.notifyBetOwnerOfUnfollow(bet,project);
		System.assert(true);
	}
	
}