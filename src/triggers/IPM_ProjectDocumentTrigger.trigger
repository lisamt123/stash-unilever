trigger IPM_ProjectDocumentTrigger on IPM_Project_Document__c (before insert,after insert,before update,after update,before delete,after delete) {
   
  if(!IPM_ProjectDocumentHelper.SKIP_TRIGGER_EXECUTION){ 
    TriggerFactory.createHandler(IPM_Project_Document__c.sObjectType);
  }    
}