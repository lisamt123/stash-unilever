trigger AF_OOPS_ActualTrigger on AF_OOPS_Actual__c(after delete, after insert, after undelete,after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(AF_OOPS_Actual__c.sObjectType);  
}