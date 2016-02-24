/*
@Author Jayprakash Bharti(M1033242)
Batch Class to process Pworf Ageing
*/

global class CPA_batchProrfAgeUpdate implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('>>>>>> CPA_batchProrfAgeUpdate : Started...');
        
        String query = 'select id,PWORF_ID__c, dat_Resubmitted_Date__c,txt_Status__c,dat_Submitted_Date__c,num_Total_PWORF_Ageing_Days__c,num_PWORF_Age__c from CPA_PWORF_Ageing__c';
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