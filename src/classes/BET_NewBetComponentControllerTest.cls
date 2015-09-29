@isTest
private class BET_NewBetComponentControllerTest {
	
	@isTest static void cancelBETTest(){
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		System.assert(controller.cancelBET() != null);
	}

	@isTest static void saveBETTest(){
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		uw_BET__c betObject = BET_TestUtils.getTestBet();
		controller.bet = betObject;
		controller.compData = new BET_CategoryComponentData(betObject);
		System.assert(controller.saveBET() == null);
	}

	@isTest static void saveBETandAddMembersTest(){
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		uw_BET__c betObject = BET_TestUtils.getTestBet();
		controller.bet = betObject;
		controller.compData = new BET_CategoryComponentData(betObject);
		System.assert(controller.saveBETandAddMembers() == null);
	}

	@isTest static void proceedWithSaveTest(){
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		uw_BET__c betObject = BET_TestUtils.getTestBet();
		controller.bet = betObject;
		controller.compData = new BET_CategoryComponentData(betObject);
		controller.proceedWithSave(true);
		System.assert(controller.bet.Inoplan_Project__c != null);
	}

	@isTest static void moveComponentDataToBETTest() {
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		controller.bet = BET_TestUtils.getTestBet();
		controller.compData = new BET_CategoryComponentData(BET_TestUtils.getTestBet());
		controller.compData.categoryMigrated = false;
		controller.bet = controller.moveComponentDataToBET(controller.bet,controller.compData);
		System.assert(controller.bet.Inoplan_Project__c != null);
	}
	
	@isTest static void validateBETTest() {
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		uw_BET__c betObject = BET_TestUtils.getTestBet();
		controller.compData = new BET_CategoryComponentData(betObject);
		controller.compData.categoryMigrated = false;
		List<String> errors = controller.validateBET(betObject);
		System.assert(!errors.isEmpty());
	}

	@isTest static void displayErrorsTest(){
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		controller.displayErrors(new List<String>{'Something went wrong'});
	}
	
}