@isTest
private class BET_AssetServiceTest {
	
	private static final String APPROVED_STATUS = 'Approved';
	private static final String BAD_FILE_ID = '123321';

	private static BET_TestingHelper.BET_TestingData prepareData() {
        return prepareData(false, BET_TestingHelper.BET_STATUS_UNRELEASED);
    }

    private static BET_TestingHelper.BET_TestingData prepareData(Boolean addMember, String status) {
        BET_TestingHelper.BET_TestingData betWrapper = BET_TestingHelper.initBET(
            BET_TestingHelper.getDefaultOwner(), 'UT_BET', status, true, true);

        if (addMember) {
            betWrapper.addMember();
        }

        Id parentId = betWrapper.BET.Studio_Chatter_Group__c; 
            
        System.Test.setCurrentPageReference(Page.uw_CustomAssetUpload);
        System.currentPageReference().getParameters().put('id', parentId);

        return betWrapper; 
    }

	@isTest static void grantAccessToBetsAssetsTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;

		BET_TestingHelper.BET_TestingData betWrapper = prepareData();
		betWrapper.addUnlabelledFile('new file.pdf');

		uw_Asset__c asset = new uw_Asset__c(name = 'test123321', uw_Bet__c = bet.id,File_Id__c = betWrapper.unlabelledFeedItem.Id);
		insert asset;

		BET_AssetService.grantAccessToBetsAssets(bet.Id,UserInfo.getUserId());

		uw_Asset__c asset1 = new uw_Asset__c(name = 'test123321', uw_Bet__c = bet.id,File_Id__c = BAD_FILE_ID);
		insert asset1;
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
		System.assert(!BET_AssetService.expectedAssetsSetForBet(null),'There should be no expected assets for this bet');
		System.assert(BET_AssetService.expectedAssetsSetForBet(bet.id),'There should be expected assets for this bet');
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

		uw_Asset__c asset1 = new uw_Asset__c(name = 'test123321a', uw_Bet__c = bet.id,File_Id__c = BAD_FILE_ID,Order_Of_Display__c = null,Status__c = APPROVED_STATUS);
		uw_Asset__c asset2 = new uw_Asset__c(name = 'test123321b', uw_Bet__c = bet.id,File_Id__c = BAD_FILE_ID,Order_Of_Display__c = 1.0,Status__c = APPROVED_STATUS);
		uw_Asset__c asset3 = new uw_Asset__c(name = 'test123321c', uw_Bet__c = bet.id,File_Id__c = BAD_FILE_ID,Order_Of_Display__c = 1.0,Status__c = APPROVED_STATUS);
		uw_Asset__c asset4 = new uw_Asset__c(name = 'test123321d', uw_Bet__c = bet.id,File_Id__c = BAD_FILE_ID,Order_Of_Display__c = 2.0,Status__c = APPROVED_STATUS);

		List<uw_Asset__c> assets = new List<uw_Asset__c>{asset1,asset2,asset3,asset4};
		insert assets;
		BET_AssetService.forceAssetReordering(''+bet.id);

		assets = [select id from uw_Asset__c where uw_Bet__c =: bet.id];
		Test.startTest();
		System.assertEquals(assets.size(),4,'There should be 4 records');
		Test.stopTest();
	}

	@isTest static void getAssetFileIdentifierTest(){
		Id identifier = UserInfo.getUserId();
		uw_Asset__c asset = new uw_Asset__c(URL_of_Asset__c = '/download/'+identifier);
		Test.startTest();
		System.assertEquals(BET_AssetService.getAssetFileIdentifier(asset),identifier,'Identifier must match');
		Test.stopTest();
	}

	@istest static void approvedAssetTypesNumerMapTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;

		uw_Asset__c asset1 = new uw_Asset__c(name = 'test123321a', uw_Bet__c = bet.id,File_Id__c = BAD_FILE_ID,Order_Of_Display__c = null,Status__c = APPROVED_STATUS,Media_Type__c = 'type1');
		uw_Asset__c asset2 = new uw_Asset__c(name = 'test123321b', uw_Bet__c = bet.id,File_Id__c = BAD_FILE_ID,Order_Of_Display__c = 1.0,Status__c = APPROVED_STATUS,Media_Type__c = 'type2');
		uw_Asset__c asset3 = new uw_Asset__c(name = 'test123321c', uw_Bet__c = bet.id,File_Id__c = BAD_FILE_ID,Order_Of_Display__c = 1.0,Status__c = APPROVED_STATUS,Media_Type__c = 'type3');
		uw_Asset__c asset4 = new uw_Asset__c(name = 'test123321d', uw_Bet__c = bet.id,File_Id__c = BAD_FILE_ID,Order_Of_Display__c = 2.0,Status__c = APPROVED_STATUS,Media_Type__c = 'type4');

		List<uw_Asset__c> assets = new List<uw_Asset__c>{asset1,asset2,asset3,asset4};
		insert assets;

		Map<String,Integer> nmap = BET_AssetService.approvedAssetTypesNumerMap(bet.id);
		Test.startTest();
		System.assertEquals(nmap.keySet().size(),4,'There should be 4 records');
		Test.stopTest();
	}
	
}