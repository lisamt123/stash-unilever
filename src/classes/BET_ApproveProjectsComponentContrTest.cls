@isTest
private class BET_ApproveProjectsComponentContrTest {
	
	@isTest static void getPendingRequestsTest() {
		IPM_Project__c leadProject = BET_TestUtils.createIPMProject('Unit Test Lead IPM Project');
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		bet.IPM_Project__c = leadProject.id;
		insert bet;
		IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test IPM Project');
		BET_TestUtils.createNewFollowRequest(bet,project);
		BET_ApproveProjectsComponentController controller = new BET_ApproveProjectsComponentController();
		controller.betIdentifier = bet.id;
		Test.startTest();
		System.assertEquals(controller.getPendingRequests().size(),1,'There should be only one pending request');
		Test.stopTest();
	}

	@isTest static void doApproveTest(){
		IPM_Project__c leadProject = BET_TestUtils.createIPMProject('Unit Test Lead IPM Project');
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		bet.IPM_Project__c = leadProject.id;
		insert bet;
		IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test IPM Project');
		BET_Follow_Request__c freq = BET_TestUtils.createNewFollowRequest(bet,project);
		BET_ApproveProjectsComponentController controller = new BET_ApproveProjectsComponentController();
		controller.betIdentifier = bet.id;
		controller.elementId = freq.id;
		Test.startTest();
		controller.doApprove();
		Test.stopTest();
		BET_Follow_Request__c freqApproved = [select Status__c from BET_Follow_Request__c where id =: freq.id];
		System.assertEquals(freqApproved.Status__c,'Approved','Follow Request should be approved');
	}

	@isTest static void doDenyTest(){
		IPM_Project__c leadProject = BET_TestUtils.createIPMProject('Unit Test Lead IPM Project');
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		bet.IPM_Project__c = leadProject.id;
		insert bet;
		IPM_Project__c project = BET_TestUtils.createIPMProject('Unit Test IPM Project');
		BET_Follow_Request__c freq = BET_TestUtils.createNewFollowRequest(bet,project);
		BET_ApproveProjectsComponentController controller = new BET_ApproveProjectsComponentController();
		controller.betIdentifier = bet.id;
		controller.elementId = freq.id;
		Test.startTest();
		controller.doDeny();
		Test.stopTest();
		BET_Follow_Request__c freqApproved = [select Status__c from BET_Follow_Request__c where id =: freq.id];
		System.assertEquals(freqApproved.Status__c,'Rejected','Follow Request should be rejected');
	}
	
}