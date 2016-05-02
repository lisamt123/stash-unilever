@isTest
private class BET_MultiUploadAssetsControllerTest {

	private static final String NULL_EXPECTED = 'Method should return null';
	
	@isTest static void getAvailableMediaTypesTest() {
		BET_MultiUploadAssetsController controller = new BET_MultiUploadAssetsController();
		Test.startTest();
		System.assert(controller.getAvailableMediaTypes()!=null,'There should be media types available');
		Test.stopTest();
	}
	
	@isTest static void getAvailableCountriesTest() {
		Test.startTest();
		BET_MultiUploadAssetsController controller = new BET_MultiUploadAssetsController();
		System.assert(controller.getAvailableCountries()!=null,'There should be countries available');
		Test.stopTest();
	}

	@isTest static void getAvailableStatusTest(){
		Test.startTest();
		BET_MultiUploadAssetsController controller = new BET_MultiUploadAssetsController();
		System.assert(controller.getAvailableStatus()!=null,'There should be statuses available');
		Test.stopTest();
	}

	@isTest static void isVisualApprovedTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		uw_Asset__c asset = new uw_Asset__c(name = 'test123321', uw_Bet__c = bet.id);
		insert asset;
		Test.startTest();
		System.assert(BET_MultiUploadAssetsController.isVisualApproved(bet.id),'Should be visual approved');
		Test.stopTest();
	}

	@isTest static void saveFileAndConnectTest(){
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		insert bet;
		String betId = (String)bet.id;
		Test.startTest();
		System.assertEquals(BET_MultiUploadAssetsController.saveFileAndConnect(null,'Unit test asset name',uw_CustomAssetUploadExtension.BET_ASSET_MEDIA_TYPE_KW,'Global',uw_CustomAssetUploadExtension.BET_ASSET_APPROVED,betId) ,'Final release',NULL_EXPECTED);
		System.assertEquals(BET_MultiUploadAssetsController.saveFileAndConnect(null,'Unit test asset name',uw_CustomAssetUploadExtension.BET_ASSET_MEDIA_TYPE_KW,'Global','First release',betId) ,'Final release',NULL_EXPECTED);
		System.assertEquals(BET_MultiUploadAssetsController.saveFileAndConnect(null,null,uw_CustomAssetUploadExtension.BET_ASSET_MEDIA_TYPE_KW,'Global','First release',betId) ,'Final release',NULL_EXPECTED);
		Test.stopTest();
	}
	
}