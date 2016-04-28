trigger AF_Sub_ResultTrigger on AF_Sub_Result__c (after delete, after insert, after undelete,after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(AF_Sub_Result__c.sObjectType); 
}