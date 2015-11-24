@isTest
private class BET_ExpectedAssetsControllerTest {
	
	@isTest static void noExpectedAssetsDataTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_ExpectedAssetsController controller = new BET_ExpectedAssetsController();
		controller.betIdentifier = bet.id;

		System.assert(!controller.expectedAssetsForBET.isEmpty(),'Expected assets data should be initialized');

		for(BET_ExpectedAssetsController.ExpectedAssetsWrapper wrap : controller.expectedAssetsForBET){
			wrap.assetTypeNameExpected= true;
		}
		Test.startTest();
		controller.upsertExceptedAssets();
		Test.stopTest();
		List<BET_ExpectedAssets__c> eAssets = [select Actual__c,Expected__c,Type__c from BET_ExpectedAssets__c where Brand_Experience_Toolkit__c =: bet.id and Expected__c = 1];
		System.assert(!eAssets.isEmpty(),'There should be excpected assets set created for given BET with expected value of 1');
	}

	@isTest static void expectedAssetsDataTest() {
		Test.startTest();
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_ExpectedAssetsController controller = new BET_ExpectedAssetsController();
		controller.betIdentifier = bet.id;
		
		System.assert(!controller.expectedAssetsForBET.isEmpty(),'Expected assets data should be initialized');

		for(BET_ExpectedAssetsController.ExpectedAssetsWrapper wrap : controller.expectedAssetsForBET){
			wrap.assetTypeNameExpected = true;
		}
		controller.upsertExceptedAssets();

		BET_ExpectedAssetsController controller_1 = new BET_ExpectedAssetsController();
		controller_1.betIdentifier = bet.id;

		for(BET_ExpectedAssetsController.ExpectedAssetsWrapper wrap : controller.expectedAssetsForBET){
			wrap.assetTypeNameExpected = false;
		}
		controller.upsertExceptedAssets();

		List<BET_ExpectedAssets__c> eAssets = [select Actual__c,Expected__c,Type__c from BET_ExpectedAssets__c where Brand_Experience_Toolkit__c =: bet.id and Expected__c = 0];
		System.assert(!eAssets.isEmpty(),'There should be excpected assets set created for given BET with expected value of 0');
		Test.stopTest();
	}
	
}