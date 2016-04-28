trigger AF_Bonus_ThresholdTrigger on AF_Bonus_Threshold__c(after delete, after insert, after undelete,after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(AF_Bonus_Threshold__c.sObjectType);  
}