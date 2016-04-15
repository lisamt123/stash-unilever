/**********************************************************************
 Name: UID_StockCoverTrigger() 
 Copyright © 2015 Salesforce 
 ====================================================== 
 ====================================================== 
 Purpose: 
 1. Trigger to Calculate the Stock Cover for each Stocked Product Summary
 ====================================================== 
 ====================================================== 
 History 
 ------- 
 VERSION AUTHOR DATE DETAIL Description 
 1.0 Bolima 13/12/2015 INITIAL DEVELOPMENT for Stock Cover Calculation
 ***********************************************************************/
trigger UID_StockCoverTrigger on UID_Stocked_Product__c (after update) {

    UID_StockCoverTriggerHandler handler = new UID_StockCoverTriggerHandler();
    
    if(Trigger.isUpdate && Trigger.isAfter)
    {
        handler.onAfterUpdate(Trigger.newMap , trigger.oldMap);
    }
}