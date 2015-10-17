@isTest
private class BET_BETHardDelete_BatchTest {
	
	@isTest static void deleteTest() {
		uw_Bet__c bet = BET_TestUtils.getTestBet();
		bet.Is_Deleted__c = true;
		bet.Deletion_Date__c = Date.today().addDays(-90);
		insert bet;

		Test.startTest();

		Date deletionDate = Date.today().addDays(-90);
		String query = 'select id from uw_Bet__c where Is_Deleted__c = true and Deletion_Date__c =: deletionDate';
		List<sObject> objects = Database.query(query);

		System.assert(!objects.isEmpty(),'BET should be there');

		BET_BETHardDelete_Batch batch = new BET_BETHardDelete_Batch();
		Database.executeBatch(batch);
		Test.stopTest();

		List<uw_Bet__c> bets = [select id from uw_Bet__c where id =: bet.id];
		System.assert(bets.isEmpty(),'BET should be removed');
	}
	
}