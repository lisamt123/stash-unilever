trigger PBS_ProfileTrigger on PBS_Profile__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	PBS_TriggerFactory.createHandler(PBS_Profile__c.sObjectType);
}