@isTest
private class BET_AssetHandlerClsTest {

	private static final String MEDIA_TYPE = 'Test Media Type';
	
	@isTest static void getExpectedAssetsForRelatedBetsTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_Asset__c asset = new uw_Asset__c(uw_Bet__c = bet.id,Media_Type__c = MEDIA_TYPE);
		BET_ExpectedAssets__c eassest = new BET_ExpectedAssets__c(Brand_Experience_Toolkit__c = bet.id,Type__c = MEDIA_TYPE,Actual__c = 1,Expected__c = 2);
		insert eassest;
		Test.startTest();
		Map<Id,List<BET_ExpectedAssets__c>> mapka = BET_AssetHandlerCls.getExpectedAssetsForRelatedBets(new List<uw_Asset__c>{asset});
		Test.stOPTest();
		System.assertEquals(eassest.id,mapka.get(bet.id).get(0).id);
	}
	
	@isTest static void increaseActualAssetNumberTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_Asset__c asset = new uw_Asset__c(uw_Bet__c = bet.id,Media_Type__c = MEDIA_TYPE);
		BET_ExpectedAssets__c eassest = new BET_ExpectedAssets__c(Brand_Experience_Toolkit__c = bet.id,Type__c = MEDIA_TYPE,Actual__c = 1,Expected__c = 2);
		insert eassest;
		Test.startTest();
		BET_AssetHandlerCls.increaseActualAssetNumber(new List<uw_Asset__c>{asset});
		Test.stopTest();
		BET_ExpectedAssets__c increased = [select Actual__c from BET_ExpectedAssets__c where id =: eassest.id];

		System.assertEquals(increased.Actual__c,2);

	}

	@isTest static void decreaseActualAssetNumberTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_Asset__c asset = new uw_Asset__c(uw_Bet__c = bet.id,Media_Type__c = MEDIA_TYPE);
		BET_ExpectedAssets__c eassest = new BET_ExpectedAssets__c(Brand_Experience_Toolkit__c = bet.id,Type__c = MEDIA_TYPE,Actual__c = 1,Expected__c = 2);
		insert eassest;
		Test.startTest();
		BET_AssetHandlerCls.decreaseActualAssetNumber(new List<uw_Asset__c>{asset});
		Test.stopTest();
		BET_ExpectedAssets__c increased = [select Actual__c from BET_ExpectedAssets__c where id =: eassest.id];

		System.assertEquals(increased.Actual__c,0);
	}

	@isTest static void updateActualAssetsNumberOnInsertTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_Asset__c asset = new uw_Asset__c(uw_Bet__c = bet.id,Media_Type__c = MEDIA_TYPE,Status__c = 'Approved');
		BET_ExpectedAssets__c eassest = new BET_ExpectedAssets__c(Brand_Experience_Toolkit__c = bet.id,Type__c = MEDIA_TYPE,Actual__c = 1,Expected__c = 2);
		insert eassest;
		Test.startTest();
		BET_AssetHandlerCls.updateActualAssetsNumber(new List<uw_Asset__c>{asset});
		Test.stopTest();
		BET_ExpectedAssets__c increased = [select Actual__c from BET_ExpectedAssets__c where id =: eassest.id];

		System.assertEquals(increased.Actual__c,2);
	}

	@isTest static void updateActualAssetsNumberOnDeleteTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_Asset__c asset = new uw_Asset__c(uw_Bet__c = bet.id,Media_Type__c = MEDIA_TYPE,Status__c = 'Approved');
		BET_ExpectedAssets__c eassest = new BET_ExpectedAssets__c(Brand_Experience_Toolkit__c = bet.id,Type__c = MEDIA_TYPE,Actual__c = 1,Expected__c = 2);
		insert eassest;
		Test.startTest();
		BET_AssetHandlerCls.updateActualAssetsNumberAfterDeletion(new List<uw_Asset__c>{asset});
		Test.stopTest();
		BET_ExpectedAssets__c increased = [select Actual__c from BET_ExpectedAssets__c where id =: eassest.id];

		System.assertEquals(increased.Actual__c,0);
	}
	
}