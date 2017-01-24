trigger AF_Bonus_SummaryTrigger on AF_Bonus_Summary__c (after delete, after insert, after undelete,after update, before delete, before insert, before update)  {
    TriggerFactory.createHandler(AF_Bonus_Summary__c.sObjectType);  
}