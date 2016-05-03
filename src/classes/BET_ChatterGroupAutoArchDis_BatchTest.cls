@isTest
private class BET_ChatterGroupAutoArchDis_BatchTest {
	
	@isTest static void batchTest() {

		uw_bet__c bet = BET_TestUtils.getTestBet();
		insert bet;

		bet = [select Studio_Chatter_Group__c from uw_bet__c where id=:bet.id];

		CollaborationGroup cgroup = [select id , IsAutoArchiveDisabled from CollaborationGroup where id = : bet.Studio_Chatter_Group__c];
		cgroup.IsAutoArchiveDisabled = false;
		update cgroup;

		Test.startTest();
		Database.executeBatch(new BET_ChatterGroupAutoArchiveDisable_Batch());
		Test.stopTest();
		
		cgroup = [select id, IsAutoArchiveDisabled from CollaborationGroup where id = : bet.Studio_Chatter_Group__c];
		System.assert(cgroup.IsAutoArchiveDisabled,'Group auto archive should be disabled');

	}
	
}