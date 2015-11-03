/*****************************************************************************************************************************
Name: BET_BETHardDelete_BatchSchedule
Copyright © 2015 Unilever. 

Purpose: Scheduler for Bet hard delete batch

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   m.bluj@polsource.com            17/10/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
/* class without sharing modifier due to this is a batch scheduler */
global class BET_BETHardDelete_BatchSchedule implements Database.Batchable<sObject>,Schedulable {
	
	global BET_BETHardDelete_BatchSchedule() {}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		Integer daysPast = BET_Settings__c.getOrgDefaults().SoftDeletePeriod__c == null ? 90 : (Integer)BET_Settings__c.getOrgDefaults().SoftDeletePeriod__c;
		Date deletionDate = Date.today().addDays(-daysPast);
		String query = 'select id from uw_Bet__c where Is_Deleted__c = true and Deletion_Date__c <=: deletionDate';
		System.debug('query ' + query);
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		System.debug('scope ' + scope);
		delete scope;
	}
	
	global void finish(Database.BatchableContext BC) {
		System.debug('Finish');
	}

	global void execute(SchedulableContext sc) {
		BET_BETHardDelete_BatchSchedule batch = new BET_BETHardDelete_BatchSchedule();
		database.executebatch(batch);
   	}
	
}