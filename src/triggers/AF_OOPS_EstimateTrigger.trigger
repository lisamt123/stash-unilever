trigger AF_OOPS_EstimateTrigger on AF_OOPS_Estimate__c(after delete, after insert, after undelete,after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(AF_OOPS_Estimate__c.sObjectType);  
}