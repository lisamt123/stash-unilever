trigger IPM_ProjectTrigger on IPM_Project__c (after insert, after update) {
    
    IPM_ProjectTriggerHandler handler = new IPM_ProjectTriggerHandler(Trigger.isExecuting);
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            handler.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
        if(Trigger.isInsert){
            handler.onAfterInsert(Trigger.new);
        }
    }
}