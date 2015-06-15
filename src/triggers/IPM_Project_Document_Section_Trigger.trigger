trigger IPM_Project_Document_Section_Trigger on IPM_Project_Document_Section__c (after update) {
    
    IPM_PDSectionTriggerHandler handler = new IPM_PDSectionTriggerHandler(Trigger.isExecuting);
    if(Trigger.isUpdate && Trigger.isAfter){
        handler.onAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}