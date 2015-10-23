trigger IPM_Project_Resource on IPM_Project_Resource__c (after update) {
    IPM_ProjectResourceHandler handler = new IPM_ProjectResourceHandler(Trigger.isExecuting);
    if(Trigger.isUpdate && Trigger.isAfter){
        handler.OnAfterUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);
    }
}