trigger IPM_FinancialYearTrigger on IPM_Financial_Year__c (after update) {
    IPMFinancialYearTriggerHandler handler = new IPMFinancialYearTriggerHandler();
    
    if(System.Trigger.isBefore){

    }else if(System.Trigger.isAfter){
        if(System.Trigger.isUpdate){
            handler.onAfterUpdate(trigger.newMap, trigger.oldMap);
        }
    }
}