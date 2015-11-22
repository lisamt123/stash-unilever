trigger IPM_AssessmentTrigger on IPM_Assessment__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(IPM_Assessment__c.sObjectType);
}