trigger AF_Bonus_ResultsTrigger on AF_Bonus_Results__c(after delete, after insert, after undelete,after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(AF_Bonus_Results__c.sObjectType);  
}