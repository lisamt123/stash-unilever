/*****************************************************************************************************************************
Name: BET_MDODataMigrationAndTransformBatch
Copyright © 2015 Unilever. 

Purpose: One  off  update  in  BET  to  update  all  BET records  to refer  to  the  new
master data reference tables

History
-------
VERSION AUTHOR                  		DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   m.bluj@polsource.com            02/09/2015      INITIAL DEVELOPMENT
*******************************************************************************************************************************/
global class BET_MDODataMigrationAndTransformBatch implements Database.Batchable<sObject> {
	
	String query = 'SELECT id,uw_Brand__c,Product_Brand__c,Category__c,Category_Group__c,Sub_Category__c,Product_Category__c,Brand_Position__c '+
				   'FROM uw_Bet__c '+
				   'WHERE Brand_Position__c == null';
	
	global BET_MDODataMigrationAndTransformBatch() {}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		update proceedWithDataTransormation((List<uw_Bet__c>)scope);
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}

	global List<uw_Bet__c> proceedWithDataTransormation(List<uw_Bet__c> scope){
		System.debug('Entering proceedWithDataTransormation : ' + scope);
		System.debug('Exit proceedWithDataTransormation : ' + scope);
		return scope;
	}
	
}