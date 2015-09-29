@isTest
private class BET_EmailNotificationServiceTest {

	private static final String TEST_PROJECT_NAME = 'Unit Test Project Name';
	
	@isTest static void notifyBetOwnerThatProjectIsUnlinkedTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_Project__c oldProject = BET_TestUtils.createIPMProject(TEST_PROJECT_NAME);
		IPM_BETWrapper project = new IPM_BETWrapper(oldProject);
		List<Messaging.SingleEmailMessage> mails = BET_EmailNotificationService.notifyBetOwnerThatProjectIsUnlinked(bet,project,project);
		System.assertEquals(mails.size(),1);
	}
	
	@isTest static void notifyBetOwnerOfNewLeadProjectTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		List<Messaging.SingleEmailMessage> mails = BET_EmailNotificationService.notifyBetOwnerOfNewLeadProject(bet,new IPM_BETWrapper(BET_TestUtils.createIPMProject(TEST_PROJECT_NAME)));
		System.assertEquals(mails.size(),1);
	}

	@isTest static void notifyBetOwnerOfUnfollowTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_BETWrapper project = new IPM_BETWrapper(BET_TestUtils.createIPMProject(TEST_PROJECT_NAME));
		List<Messaging.SingleEmailMessage> mails = BET_EmailNotificationService.notifyBetOwnerOfUnfollow(bet,project);
		System.assertEquals(mails.size(),1);
	}

	@isTest static void notifyBetOwnerOfMultipleMemberRequestsFromIPMTest(){
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_BETWrapper project = new IPM_BETWrapper(BET_TestUtils.createIPMProject(TEST_PROJECT_NAME));
		List<Messaging.SingleEmailMessage> mails = BET_EmailNotificationService.notifyBetOwnerOfMultipleMemberRequestsFromIPM(bet.id, project.projectId);
		System.assertEquals(mails.size(),1);
	}

	@isTest static void notifyBetOwnerOfLeadProjectFollowRequestTest(){
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		IPM_BETWrapper project = new IPM_BETWrapper(BET_TestUtils.createIPMProject(TEST_PROJECT_NAME));
		List<Messaging.SingleEmailMessage> mails = BET_EmailNotificationService.notifyBetOwnerOfLeadProjectFollowRequest(bet,project);
		System.assertEquals(mails.size(),1);
	}
	
}