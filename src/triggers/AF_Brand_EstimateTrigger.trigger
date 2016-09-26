trigger AF_Brand_EstimateTrigger on AF_Brand_Estimate__c (after delete, after insert, after undelete,after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(AF_Brand_Estimate__c.sObjectType);  
}