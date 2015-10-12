/*************************************************************************************
Name : BET_DataFixReleaseDate

Purpose : Class responsible for update first and final due dates 
History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  20-08-2015  Initial
*************************************************************************************/
/* Batch class, with sharing is not needed */
global class BET_DataFixReleaseDate_Batch implements Database.Batchable<sObject> {
    
    String query = 'Select First_Release_Due_Date__c, Final_Release_Due_Date__c, Launch_Date__c from uw_BET__c where (First_Release_Due_Date__c = null or Final_Release_Due_Date__c = null) and Launch_Date__c <> null';
    String unitTestQuery = 'Select First_Release_Due_Date__c, Final_Release_Due_Date__c, Launch_Date__c from uw_BET__c where  Launch_Date__c != null';

    global BET_DataFixReleaseDate_Batch() {}
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('Entering start');
        return Test.isRunningTest() ? Database.getQueryLocator(unitTestQuery) : Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.debug('Entering execute : ' + scope);
        List<uw_BET__c> bets = new List<uw_BET__c>();
        for(sObject obj : scope){
            uw_BET__c bet = (uw_BET__c)obj;
            bet.Final_Release_Due_Date__c = BET_BETService.getFinalReleaseDueDate(bet.Launch_Date__c);
            bet.First_Release_Due_Date__c = BET_BETService.getFirstReleaseDueDate(bet.Launch_Date__c);
            bets.add(bet);
        }
        update bets;
        System.debug('Exit execute : ' + bets);
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug('Finish batch process');
    }
    
}