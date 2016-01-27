trigger IPM_AssessmentTrigger on IPM_Assessment__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    if(!IPM_AssesmentHandler_Helper.SKIP_TRIGGER_EXECUTION) {
    	TriggerFactory.createHandler(IPM_Assessment__c.sObjectType);
    }
}