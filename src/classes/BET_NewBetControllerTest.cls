@isTest
private class BET_NewBetControllerTest {
	
	@isTest static void newBetTest() {
		BET_NewBetController controller = new BET_NewBetController(new ApexPages.StandardController(new uw_BET__c()));
		System.assert(controller.bet.id == null);
	}
	
	@isTest static void existingBetTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		ApexPages.currentPage().getParameters().put('id',bet.id);
		BET_NewBetController controller = new BET_NewBetController(new ApexPages.StandardController(new uw_BET__c()));
		System.assertEquals(controller.bet.id,bet.id);
	}
	
}