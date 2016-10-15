trigger AF_CurrencyTrigger on AF_Currency__c(after delete, after insert, after undelete,after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(AF_Currency__c.sObjectType);  
}