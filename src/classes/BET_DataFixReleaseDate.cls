/*************************************************************************************
Name : BET_DataFixReleaseDate

Purpose : Class responsible for update due dates 
History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  20-08-2015  Initial
*************************************************************************************/
global class BET_DataFixReleaseDate implements Database.Batchable<sObject> {
	
	String query = 'Select First_Release_Due_Date__c, Final_Release_Due_Date__c, Launch_Date__c from uw_BET__c where (First_Release_Due_Date__c = null or Final_Release_Due_Date__c = null) and Launch_Date__c <> null';
	String unitTestQuery = 'Select First_Release_Due_Date__c, Final_Release_Due_Date__c, Launch_Date__c from uw_BET__c where  Launch_Date__c != null';

	global BET_DataFixReleaseDate() {}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		System.debug('Finish batch process');
		return Test.isRunningTest() ? Database.getQueryLocator(unitTestQuery) : Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		System.debug('Executing batch process');
   		List<uw_BET__c> bets = new List<uw_BET__c>();
		for(sObject obj : scope){
			uw_BET__c bet = (uw_BET__c)obj;
			bet.Final_Release_Due_Date__c = BET_BETService.getFinalReleaseDueDate(bet.Launch_Date__c);
			bet.First_Release_Due_Date__c = BET_BETService.getFirstReleaseDueDate(bet.Launch_Date__c);
			bets.add(bet);
		}
		update bets;
	}
	
	global void finish(Database.BatchableContext BC) {
		System.debug('Finish batch process');
	}
	
}