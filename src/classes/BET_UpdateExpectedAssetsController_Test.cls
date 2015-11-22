@isTest
private class BET_UpdateExpectedAssetsController_Test {
	
	@isTest static void onSaveTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		System.CurrentPageReference().getParameters().put('id', bet.id);
		BET_UpdateExpectedAssetsController controller = new BET_UpdateExpectedAssetsController();
		Test.startTest();
		System.assert(controller.onSave() == null,'Method should return null');
		Test.stopTest();
	}
	
	
}