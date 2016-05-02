trigger IPM_Project_Resource_Trigger on IPM_Project_Resource__c (before insert,after insert,before update,after update,before delete,after delete, after undelete) {
    TriggerFactory.createHandler(IPM_Project_Resource__c.sObjectType);    
   
}