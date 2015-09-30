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
		Test.startTest();
		List<BET_LinkedProjectsComponentController.FollowRequestWrapper> linkedprojects = controller.getLinkedProjects();
		Test.stopTest();
		System.assertEquals(linkedprojects.size(),2,'List should contain 2 elements');
	}

	@isTest static void setAsLeadProjectTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		Id BetId = bet.id;
		Id ProjectId = BET_TestUtils.createIPMProject('Unit Test Lead IPM Project').id;
		BET_LinkedProjectsComponentController controller = new BET_LinkedProjectsComponentController();
		controller.selectedProjectId = ProjectId;
		controller.betIdentifier = BetId;
		Test.startTest();
		controller.setAsLeadProject();
		Test.stopTest();
		bet = [select IPM_Project__c from uw_Bet__c where id=:BetId];
		System.assertEquals(bet.IPM_Project__c,ProjectId,'Project identifiers must match');
	}
	
}