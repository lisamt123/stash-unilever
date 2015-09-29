@isTest
private class BET_AssetServiceTest {
	
	@isTest static void betContainsExpectedAssetsRecordTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;

		List<BET_ExpectedAssets__c> expectedAssets = [select id from BET_ExpectedAssets__c where Brand_Experience_Toolkit__c =: bet.id];
		System.assert(expectedAssets.isEmpty());

		BET_AssetService.createExpectedAssetsRecordsForBet(new List<Id>{bet.id});
		Test.startTest();
		Map<Id,Boolean> mapka = BET_AssetService.betContainsExpectedAssetsRecord(new List<Id>{bet.id});
		Test.stopTest();
		System.assert(mapka.get(bet.id));
	}
	
	@isTest static void createExpectedAssetsRecordsForBetTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;

		List<BET_ExpectedAssets__c> expectedAssets = [select id from BET_ExpectedAssets__c where Brand_Experience_Toolkit__c =: bet.id];
		System.assert(expectedAssets.isEmpty());
		Test.startTest();
		BET_AssetService.createExpectedAssetsRecordsForBet(new List<Id>{bet.id});
		Test.stopTest();
		expectedAssets = [select id from BET_ExpectedAssets__c where Brand_Experience_Toolkit__c =: bet.id];
		System.assert(!expectedAssets.isEmpty());
	}

	@isTest static void getBetIdsFromAssetsTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_Asset__c asset = new uw_Asset__c(uw_Bet__c = bet.id,Media_Type__c = 'Test Media Type');
		Test.startTest();
		List<Id> bets = BET_AssetService.getBetIdsFromAssets(new List<uw_Asset__c> {asset});
		Test.stopTest();
		System.assert(!bets.isEmpty());

	}
	
}