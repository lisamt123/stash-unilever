global with sharing class WU_SetCurrentMonthBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id,Name,Is_In_Current_Month__c,WU_CurrentMonth__c FROM WU_Warehouse_Capacity_Detail__c';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<WU_Warehouse_Capacity_Detail__c> scope) {
         for(WU_Warehouse_Capacity_Detail__c wcd : scope)
         {
             if(wcd.Is_In_Current_Month__c)
             {
                 wcd.WU_CurrentMonth__c = 'Yes';
             }
             else if(!wcd.Is_In_Current_Month__c)
             {
                 wcd.WU_CurrentMonth__c = 'No';
             }
         }
         update scope;
    }   
    
    global void finish(Database.BatchableContext BC) 
    {
        system.debug(':::::::::Execution finished');
    }
}