trigger AF_Agency_EstimateTrigger on AF_Agency_Estimate__c(after delete, after insert, after undelete,after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(AF_Agency_Estimate__c.sObjectType);  
}