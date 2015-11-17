trigger IPM_CompanyCardTrigger on IPM_Company_Card__c (before insert,after insert,before update,after update,before delete,after delete) {
    TriggerFactory.createHandler(IPM_Company_Card__c.sObjectType);    
       
}