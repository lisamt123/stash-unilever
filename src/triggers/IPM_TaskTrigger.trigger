trigger IPM_TaskTrigger on IPM_Task__c (after insert, after delete, after undelete, after update) {
    
    IPM_TaskTriggerHandler handler = new IPM_TaskTriggerHandler(Trigger.isExecuting);
    if(Trigger.isDelete && Trigger.isAfter){
        handler.OnAfterDelete(Trigger.old);
    }else if(Trigger.isInsert && Trigger.isAfter){
        handler.onAfterInsert(Trigger.new);
    }else if(Trigger.isUnDelete && Trigger.isAfter){
        handler.onAfterUnDelete(Trigger.new);
    }else if(Trigger.isUpdate && Trigger.isAfter){
        handler.onAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}