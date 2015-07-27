@isTest
private class BET_NewBetComponentControllerTest {
	
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
		controller.bet = new uw_BET__c();
		controller.compData = new BET_CategoryComponentData(BET_TestUtils.getTestBet());
		controller.bet = controller.moveComponentDataToBET(controller.bet,controller.compData);
		System.assert(controller.bet.Inoplan_Project__c != null);
	}
	
	@isTest static void validateBETTest() {
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		uw_BET__c betObject = BET_TestUtils.getTestBet();
		List<String> errors = controller.validateBET(betObject);
		System.assert(!errors.isEmpty());
	}

	@isTest static void displayErrorsTest(){
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		controller.displayErrors(new List<String>{'Something went wrong'});
	}
	
}