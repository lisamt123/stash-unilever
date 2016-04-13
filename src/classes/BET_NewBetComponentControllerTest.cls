@isTest
private class BET_NewBetComponentControllerTest {
	
	@isTest static void cancelBETTest(){
		Test.startTest();
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		System.assert(controller.cancelBET() != null,'Page reference should not be null');
		Test.stopTest();
	}

	@isTest static void saveBETTest(){
		Test.startTest();
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		uw_BET__c betObject = BET_TestUtils.getTestBet();
		controller.bet = betObject;
		controller.compData = new BET_CategoryComponentData(betObject);
		System.assert(controller.saveBET() == null,'Page reference should be null');
		Test.stopTest();
	}

	@isTest static void saveBETandAddMembersTest(){
		Test.startTest();
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		uw_BET__c betObject = BET_TestUtils.getTestBet();
		controller.bet = betObject;
		controller.compData = new BET_CategoryComponentData(betObject);
		System.assert(controller.saveBETandAddMembers() == null,'Page reference should be null');
		Test.stopTest();
	}

	@isTest static void proceedWithSaveTest(){
		Test.startTest();
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		uw_BET__c betObject = BET_TestUtils.getTestBet();
		controller.bet = betObject;
		controller.compData = new BET_CategoryComponentData(betObject);
		controller.proceedWithSave(true);
		System.assert(controller.bet.Inoplan_Project__c != null,'Inoplan Project should be set');
		Test.stopTest();
	}

	@isTest static void proceedWithSaveExceptionsTest(){
		Test.startTest();
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		uw_BET__c betObject = BET_TestUtils.getTestBet();
		controller.bet = betObject;
		controller.compData = new BET_CategoryComponentData(betObject);
		controller.compData.category = null;
		controller.proceedWithSave(true);
		System.assert(!controller.compData.categoryMigrated ,'Category should be marked as not migrated');
		Test.stopTest();
	}

	@isTest static void moveComponentDataToBETTest() {
		Test.startTest();
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		controller.bet = BET_TestUtils.getTestBet();
		controller.compData = new BET_CategoryComponentData(BET_TestUtils.getTestBet());
		controller.compData.categoryMigrated = false;
		controller.bet = controller.moveComponentDataToBET(controller.bet,controller.compData);
		System.assert(controller.bet.Inoplan_Project__c != null,'Inoplan Project should be set');
		Test.stopTest();
	}
	
	@isTest static void validateBETTest() {
		Test.startTest();
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		uw_BET__c betObject = BET_TestUtils.getTestBet();
		controller.compData = new BET_CategoryComponentData(betObject);
		controller.compData.categoryMigrated = false;
		List<String> errors = controller.validateBET(betObject);
		System.assert(!errors.isEmpty(),'There should be validation errors');
		Test.stopTest();
	}

	@isTest static void displayErrorsTest(){
		Test.startTest();
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		List<ApexPages.Message> displayed = controller.displayErrors(new List<String>{'Something went wrong'});
		System.assertEquals(displayed.size(),1,'Displayed errors list size must be 1');
		Test.stopTest();
	}

	@isTest static void ownerOrManagerTest(){
		BET_NewBetComponentController controller = new BET_NewBetComponentController();
		uw_BET__c betObject = BET_TestUtils.getTestBet();
		insert betObject;
		controller.bet = betObject;
		Test.startTest();
		System.assertEquals(controller.ownerOrManager,true,'User is bet owner');
		controller.ownerOrManager = false;
		Test.stopTest();
	}
	
}