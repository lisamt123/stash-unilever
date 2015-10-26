@isTest
private class BET_NewBetControllerTest {
	
	@isTest static void newBetTest() {
		Test.startTest();
		BET_NewBetController controller = new BET_NewBetController(new ApexPages.StandardController(new uw_BET__c()));
		System.assert(controller.bet.id == null,'Bet id should be null');
		Test.stopTest();
	}
	
	@isTest static void existingBetTest() {
		uw_BET__c bet = BET_TestUtils.getTestBet();
		insert bet;
		ApexPages.currentPage().getParameters().put('id',bet.id);
		Test.startTest();
		BET_NewBetController controller = new BET_NewBetController(new ApexPages.StandardController(new uw_BET__c()));
		System.assertEquals(controller.bet.id,bet.id,'Bet is should match');
		Test.stopTest();
	}
	
}