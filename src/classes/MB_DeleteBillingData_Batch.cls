global with sharing class MB_DeleteBillingData_Batch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        // fetching Billing Entries older than 225 days
        
        String query = 'SELECT Id,CreatedDate FROM MB_Billing_Entity__c WHERE CreatedDate < LAST_N_MONTHS:7';
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC, List<MB_Billing_Entity__c> billingList)
    {   
      // Delete list of billing entries 
        if(billingList!=null && billingList.size()>0){
            delete billingList;
        }       
    }  
    global void finish(Database.BatchableContext BC)
    {
        // Logic to be Executed at finish
    }
}