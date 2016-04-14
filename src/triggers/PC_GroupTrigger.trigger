trigger PC_GroupTrigger on PC_Group__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    PBS_TriggerFactory.createHandler(PC_Group__c.sObjectType);
}