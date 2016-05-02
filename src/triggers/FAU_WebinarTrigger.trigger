trigger FAU_WebinarTrigger on FAU_Webinar__c (
	after delete,
	after insert,
	after undelete, 
	after update,
	before delete,
	before insert,
	before update) {
	
	TriggerFactory.createHandler(FAU_Webinar__c.sObjectType);

}