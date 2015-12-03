trigger IPM_ProjectTrigger on IPM_Project__c (before insert,after insert,before update,after update,before delete,after delete) {
    TriggerFactory.createHandler(IPM_Project__c.sObjectType);    
}