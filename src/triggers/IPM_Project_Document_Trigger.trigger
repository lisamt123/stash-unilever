trigger IPM_Project_Document_Trigger on IPM_Project_Document__c (after update) {
    
    IPM_PDocumentTriggerHandler handler = new IPM_PDocumentTriggerHandler(Trigger.isExecuting);
    if(Trigger.isUpdate && Trigger.isAfter){
        handler.onAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}