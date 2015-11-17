trigger IPM_RolloutTrigger on IPM_Project_Rollout__c (before insert,after insert,before update,after update,before delete,after delete) {
    TriggerFactory.createHandler(IPM_Project_Rollout__c.sObjectType);    
}