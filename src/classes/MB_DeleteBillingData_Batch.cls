global with sharing class MB_DeleteBillingData_Batch implements Database.Batchable<sObject> {
	global Database.QueryLocator start(Database.BatchableContext BC)
    {
        // fetching Billing Entries older than 180 days
        Date d = system.today().addDays(-180);
        String query = 'SELECT Id,CreatedDate FROM MB_Billing_Entity__c WHERE CreatedDate <=: d';
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
        
    }
}