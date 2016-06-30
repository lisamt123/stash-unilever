trigger PBS_TrainingTrackTrigger on PBS_Training_Track__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    PBS_TriggerFactory.createHandler(PBS_Training_Track__c.sObjectType);
}