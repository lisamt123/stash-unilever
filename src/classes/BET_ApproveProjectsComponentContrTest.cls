@isTest
private class BET_ApproveProjectsComponentContrTest {
	
	@isTest static void gettersTest() {
		IPM_Project__c leadProject = BET_TestUtils.createIPMProject('Unit Test Lead IPM Project');
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		bet.IPM_Project__c = leadProject.id;
		insert bet;
		IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test IPM Project');
		BET_TestUtils.createNewFollowRequest(bet,project);
		BET_ApproveProjectsComponentController controller = new BET_ApproveProjectsComponentController();
		controller.betIdentifier = bet.id;

		String tld = controller.ipmProjectTLD;
		String lead = controller.ipmProjectLead;
		String reminder = controller.remainder;
		System.assertEquals(controller.ipmProjectName,'Unit Test IPM Project');
	}
	
}