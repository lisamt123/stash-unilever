@isTest
private class BET_AssetHandlerClsTest {

	private static final String MEDIA_TYPE = 'Test Media Type';

	@isTest static void updateBETStatusAccordinglyTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		bet.Status__c = 'First Release';
		insert bet;
		uw_Asset__c asset = new uw_Asset__c(uw_Bet__c = bet.id,Studio_Asset_Type__c = uw_CustomAssetUploadExtension.BET_ASSET_TYPE_BEP,Status__c = uw_CustomAssetUploadExtension.BET_ASSET_APPROVED);
		bet = [select Status__c from uw_Bet__c where id =: bet.id];
		System.assertEquals(bet.Status__c,'First release');
		Test.startTest();
		BET_AssetHandlerCls.updateBETStatusAccordingly(new List<uw_Asset__c>{asset});
		Test.stopTest();
		bet = [select Status__c from uw_Bet__c where id =: bet.id];
		System.assertEquals(bet.Status__c,'Unreleased','Status should be set to Unreleased');
	}

	@isTest static void updateBETStatusAccordinglyCWTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		bet.Status__c = 'First Release';
		insert bet;
		uw_Asset__c asset = new uw_Asset__c(uw_Bet__c = bet.id,Media_Type__c = uw_CustomAssetUploadExtension.BET_ASSET_MEDIA_TYPE_KW,Studio_Asset_Type__c = uw_CustomAssetUploadExtension.BET_ASSET_TYPE_CW,Status__c = uw_CustomAssetUploadExtension.BET_ASSET_APPROVED);
		bet = [select Status__c from uw_Bet__c where id =: bet.id];
		System.assertEquals(bet.Status__c,'First release');
		Test.startTest();
		BET_AssetHandlerCls.updateBETStatusAccordingly(new List<uw_Asset__c>{asset});
		Test.stopTest();
		bet = [select Status__c from uw_Bet__c where id =: bet.id];
		System.assertEquals(bet.Status__c,'Unreleased','Status should be set to Unreleased');
	}
	
	@isTest static void getExpectedAssetsForRelatedBetsTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_Asset__c asset = new uw_Asset__c(uw_Bet__c = bet.id,Media_Type__c = MEDIA_TYPE);
		BET_ExpectedAssets__c eassest = new BET_ExpectedAssets__c(Brand_Experience_Toolkit__c = bet.id,Type__c = MEDIA_TYPE,Actual__c = 1,Expected__c = 2);
		insert eassest;
		Test.startTest();
		Map<Id,List<BET_ExpectedAssets__c>> mapka = BET_AssetHandlerCls.getExpectedAssetsForRelatedBets(new List<uw_Asset__c>{asset});
		Test.stOPTest();
		System.assertEquals(eassest.id,mapka.get(bet.id).get(0).id,'Identifiers must match');
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

		System.assertEquals(increased.Actual__c,2,'Actual should equals 2');

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

		System.assertEquals(increased.Actual__c,0,'Actual should equals 0');
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

		System.assertEquals(increased.Actual__c,2,'Actual should equals 2');
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

		System.assertEquals(increased.Actual__c,0,'Actual should equals 0');
	}
	
}