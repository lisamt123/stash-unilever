/**********************************************************************
Name: CPA_batchProrfAgeUpdate()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: Batch Class to process Pworf Ageing.
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR               DATE            DETAIL Description
1.0         Jayprakash Bharti    01/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
global with sharing class CPA_batchProrfAgeUpdate implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('>>>>>> CPA_batchProrfAgeUpdate : Started...');
        
        String query = 'select id, PWORF_ID__c, fml_Status__c, fml_Submitted_Date__c, fml_Resubmitted_Date__c, num_PWORF_Age__c, num_Total_PWORF_Ageing_Days__c from CPA_PWORF_Ageing__c';
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC, List<CPA_PWORF_Ageing__c> scope)
    {   // Calling the static method   
        CPA_PWORFAgeing.PworfAgeUpdateScheduler(scope);  
    }  
    global void finish(Database.BatchableContext BC)
    {
        System.debug('>>>>>> CPA_batchProrfAgeUpdate : Ends');
    }
}