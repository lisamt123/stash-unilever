@isTest
private class BET_MultiUploadAssetsControllerTest {
	
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
		Test.startTest();
		System.assert(!BET_MultiUploadAssetsController.isVisualApproved(bet.id),'Should not be visual approved');
		Test.stopTest();
	}
	
}