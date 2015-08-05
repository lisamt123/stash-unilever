@isTest
private class BET_LinkedProjectsComponentContrTest {
	
	@isTest static void getLinkedProjectsTest() {
		IPM_Project__c leadProject = BET_TestUtils.createIPMProject('Unit Test Lead IPM Project');
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		bet.IPM_Project__c = leadProject.id;
		insert bet;
		IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test IPM Project');
		BET_TestUtils.createApprovedFollowRequest(bet,project);
		BET_LinkedProjectsComponentController controller = new BET_LinkedProjectsComponentController();
		controller.betIdentifier = bet.id;
		List<BET_LinkedProjectsComponentController.FollowRequestWrapper> linkedprojects = controller.getLinkedProjects();
		System.assertEquals(linkedprojects.size(),2);
	}
	
}