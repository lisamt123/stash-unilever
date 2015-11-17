trigger IPM_CountryTrigger on IPM_Country__c (before insert,after insert,before update,after update,before delete,after delete) {
    TriggerFactory.createHandler(IPM_Country__c.sObjectType);    
}