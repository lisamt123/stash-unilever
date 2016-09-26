trigger AF_Bonus_MatrixTrigger on AF_Bonus_Matrix__c(after delete, after insert, after undelete,after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(AF_Bonus_Matrix__c.sObjectType);  
}