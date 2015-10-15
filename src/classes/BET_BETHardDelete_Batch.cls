/*****************************************************************************************************************************
Name: BET_BETHardDelete_Batch
Copyright © 2015 Unilever. 

Purpose: Deletes BETs marked for deletion after 90 days period.

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   m.bluj@polsource.com            15/10/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
global class BET_BETHardDelete_Batch implements Database.Batchable<sObject> {
	
	global BET_BETHardDelete_Batch() {}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		Date deletionDate = Date.today().addDays(-90);
		String query = 'select id from uw_Bet__c where Is_Deleted__c = true and Deletion_Date__c =: deletionDate';
		System.debug('query ' + query);
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		System.debug('scope ' + scope);
		delete scope;
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}