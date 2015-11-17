trigger IPM_FinancialTrigger on IPM_Financial__c (before insert,after insert,before update,after update,before delete,after delete) {
    TriggerFactory.createHandler(IPM_Financial__c.sObjectType);    
}