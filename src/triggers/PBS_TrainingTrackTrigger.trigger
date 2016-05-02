trigger PBS_TrainingTrackTrigger on Almond__Training_Track__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    PBS_TriggerFactory.createHandler(Almond__Training_Track__c.sObjectType);
}