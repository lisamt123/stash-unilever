trigger IPM_Task_Trigger on IPM_Task__c (before insert,after insert,before update,after update,before delete,after delete, after undelete) {
    TriggerFactory.createHandler(IPM_Task__c.sObjectType);    
   
}