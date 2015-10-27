@isTest
private class BET_AssetServiceTest {
	

	@isTest static void grantAccessToBetsAssetsTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_Asset__c asset = new uw_Asset__c(name = 'test123321', uw_Bet__c = bet.id,File_Id__c = '123321');
		insert asset;
		BET_AssetService.grantAccessToBetsAssets(bet.Id,UserInfo.getUserId());
		Test.startTest();
		System.assertEquals(1,1,'Method should run without exception');
		Test.stopTest();
	}

	@isTest static void expectedAssetsSetForBetTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		BET_ExpectedAssets__c ea = new BET_ExpectedAssets__c(Brand_Experience_Toolkit__c = bet.id, Expected__c = 1, Type__c = 'Test');
		insert ea;
		Test.startTest();
		System.assert(BET_AssetService.expectedAssetsSetForBet(bet.id),'There sould be expected asets for this bet');
		Test.stopTest();
	}

	@isTest static void betContainsExpectedAssetsRecordTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;

		List<BET_ExpectedAssets__c> expectedAssets = [select id from BET_ExpectedAssets__c where Brand_Experience_Toolkit__c =: bet.id];
		System.assert(expectedAssets.isEmpty(),'There should be no expected assets');

		BET_AssetService.createExpectedAssetsRecordsForBet(new List<Id>{bet.id});
		Test.startTest();
		Map<Id,Boolean> mapka = BET_AssetService.betContainsExpectedAssetsRecord(new List<Id>{bet.id});
		Test.stopTest();
		System.assert(mapka.get(bet.id),'Bet should have coresponding expected assets records');
	}
	
	@isTest static void createExpectedAssetsRecordsForBetTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;

		List<BET_ExpectedAssets__c> expectedAssets = [select id from BET_ExpectedAssets__c where Brand_Experience_Toolkit__c =: bet.id];
		System.assert(expectedAssets.isEmpty(),'There should be no expected assets');
		Test.startTest();
		BET_AssetService.createExpectedAssetsRecordsForBet(new List<Id>{bet.id});
		Test.stopTest();
		expectedAssets = [select id from BET_ExpectedAssets__c where Brand_Experience_Toolkit__c =: bet.id];
		System.assert(!expectedAssets.isEmpty(),'Expected assets should exist for given bet record');
	}

	@isTest static void getBetIdsFromAssetsTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_Asset__c asset = new uw_Asset__c(uw_Bet__c = bet.id,Media_Type__c = 'Test Media Type');
		Test.startTest();
		List<Id> bets = BET_AssetService.getBetIdsFromAssets(new List<uw_Asset__c> {asset});
		Test.stopTest();
		System.assert(!bets.isEmpty(),'BETs collection should not be empty');

	}

	@isTest static void forceAssetReorderingTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;

		uw_Asset__c asset1 = new uw_Asset__c(name = 'test123321a', uw_Bet__c = bet.id,File_Id__c = '123321',Order_Of_Display__c = null);
		uw_Asset__c asset2 = new uw_Asset__c(name = 'test123321b', uw_Bet__c = bet.id,File_Id__c = '123321',Order_Of_Display__c = 1.0);
		uw_Asset__c asset3 = new uw_Asset__c(name = 'test123321c', uw_Bet__c = bet.id,File_Id__c = '123321',Order_Of_Display__c = 1.0);
		uw_Asset__c asset4 = new uw_Asset__c(name = 'test123321d', uw_Bet__c = bet.id,File_Id__c = '123321',Order_Of_Display__c = 2.0);

		List<uw_Asset__c> assets = new List<uw_Asset__c>{asset1,asset2,asset3,asset4};
		insert assets;
		BET_AssetService.forceAssetReordering(''+bet.id);

		assets = [select id from uw_Asset__c where uw_Bet__c =: bet.id];
		Test.startTest();
		System.assertEquals(assets.size(),4,'There should be 4 records');
		Test.stopTest();
	}
	
}