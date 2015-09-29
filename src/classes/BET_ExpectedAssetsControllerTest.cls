@isTest
private class BET_ExpectedAssetsControllerTest {
	
	@isTest static void noExpectedAssetsDataTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_ExpectedAssetsController controller = new BET_ExpectedAssetsController();
		controller.betIdentifier = bet.id;

		System.assert(!controller.expectedAssetsForBET.isEmpty());

		for(BET_ExpectedAssetsController.ExpectedAssetsWrapper wrap : controller.expectedAssetsForBET){
			wrap.assetTypeNameExpectedNumber = 1;
		}
		Test.startTest();
		controller.upsertExceptedAssets();
		Test.stopTest();
		List<BET_ExpectedAssets__c> eAssets = [select Actual__c,Expected__c,Type__c from BET_ExpectedAssets__c where Brand_Experience_Toolkit__c =: bet.id and Expected__c = 1];
		System.assert(!eAssets.isEmpty());
	}

	@isTest static void expectedAssetsDataTest() {
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_ExpectedAssetsController controller = new BET_ExpectedAssetsController();
		controller.betIdentifier = bet.id;
		
		System.assert(!controller.expectedAssetsForBET.isEmpty());

		for(BET_ExpectedAssetsController.ExpectedAssetsWrapper wrap : controller.expectedAssetsForBET){
			wrap.assetTypeNameExpectedNumber = 1;
		}
		controller.upsertExceptedAssets();

		BET_ExpectedAssetsController controller_1 = new BET_ExpectedAssetsController();
		controller_1.betIdentifier = bet.id;

		for(BET_ExpectedAssetsController.ExpectedAssetsWrapper wrap : controller.expectedAssetsForBET){
			wrap.assetTypeNameExpectedNumber = 2;
		}
		controller.upsertExceptedAssets();

		List<BET_ExpectedAssets__c> eAssets = [select Actual__c,Expected__c,Type__c from BET_ExpectedAssets__c where Brand_Experience_Toolkit__c =: bet.id and Expected__c = 2];
		System.assert(!eAssets.isEmpty());
		Test.stopTest();
	}
	
}