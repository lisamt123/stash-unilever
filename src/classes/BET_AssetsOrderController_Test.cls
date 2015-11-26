@isTest
private class BET_AssetsOrderController_Test {
	
	@isTest static void updateAssetsOrderTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_Asset__c asset = new uw_Asset__c(uw_Bet__c = bet.id,Country__c = 'Algieria;Argentina',Status__c = 'Approved');
		insert asset;
		System.CurrentPageReference().getParameters().put('betid', bet.id);
		BET_AssetsOrderController controller = new BET_AssetsOrderController();
		Test.startTest();
		System.assertEquals(controller.liAssets.size(),1,'There should be one asset');
		BET_AssetsOrderController.updateAssetsOrder(new List<String>{''+asset.id});
		Test.stopTest();
	}
	
}