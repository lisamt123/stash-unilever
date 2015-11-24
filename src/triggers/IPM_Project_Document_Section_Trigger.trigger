<<<<<<< HEAD
trigger IPM_Project_Document_Section_Trigger on IPM_Project_Document_Section__c (after update) {
    
    IPM_PDSectionTriggerHandler handler = new IPM_PDSectionTriggerHandler(Trigger.isExecuting);
    if(Trigger.isUpdate && Trigger.isAfter){
        handler.onAfterUpdate(Trigger.new, Trigger.oldMap);
    }
=======
trigger IPM_Project_Document_Section_Trigger on IPM_Project_Document_Section__c (before insert,after insert,before update,after update,before delete,after delete) {
    TriggerFactory.createHandler(IPM_Project_Document_Section__c.sObjectType);
   
>>>>>>> FETCH_HEAD
}