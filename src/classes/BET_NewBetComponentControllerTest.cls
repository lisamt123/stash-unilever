@isTest
private class BET_NewBetComponentControllerTest {
	
	@isTest static void cancelBETTest(){
		Test.startTest();
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		System.assert(controller.cancelBET() != null);
		Test.stopTest();
	}

	@isTest static void saveBETTest(){
		Test.startTest();
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		uw_BET__c betObject = BET_TestUtils.getTestBet();
		controller.bet = betObject;
		controller.compData = new BET_CategoryComponentData(betObject);
		System.assert(controller.saveBET() == null);
		Test.stopTest();
	}

	@isTest static void saveBETandAddMembersTest(){
		Test.startTest();
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		uw_BET__c betObject = BET_TestUtils.getTestBet();
		controller.bet = betObject;
		controller.compData = new BET_CategoryComponentData(betObject);
		System.assert(controller.saveBETandAddMembers() == null);
		Test.stopTest();
	}

	@isTest static void proceedWithSaveTest(){
		Test.startTest();
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		uw_BET__c betObject = BET_TestUtils.getTestBet();
		controller.bet = betObject;
		controller.compData = new BET_CategoryComponentData(betObject);
		controller.proceedWithSave(true);
		System.assert(controller.bet.Inoplan_Project__c != null);
		Test.stopTest();
	}

	@isTest static void moveComponentDataToBETTest() {
		Test.startTest();
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		controller.bet = BET_TestUtils.getTestBet();
		controller.compData = new BET_CategoryComponentData(BET_TestUtils.getTestBet());
		controller.compData.categoryMigrated = false;
		controller.bet = controller.moveComponentDataToBET(controller.bet,controller.compData);
		System.assert(controller.bet.Inoplan_Project__c != null);
		Test.stopTest();
	}
	
	@isTest static void validateBETTest() {
		Test.startTest();
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		uw_BET__c betObject = BET_TestUtils.getTestBet();
		controller.compData = new BET_CategoryComponentData(betObject);
		controller.compData.categoryMigrated = false;
		List<String> errors = controller.validateBET(betObject);
		System.assert(!errors.isEmpty());
		Test.stopTest();
	}

	@isTest static void displayErrorsTest(){
		Test.startTest();
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		controller.displayErrors(new List<String>{'Something went wrong'});
		Test.stopTest();
	}
	
}