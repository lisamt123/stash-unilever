trigger UserTrigger on User (after delete, after update) {
    
    
    /*Call to IPM_UserTriggerHandler is written in user_after_update.trigger.
      Commented after delete if because user is never deleted.*/
    
    IPM_UserTriggerHandler handler = new IPM_UserTriggerHandler(Trigger.isExecuting);
    if(Trigger.isUpdate && Trigger.isAfter){
        //handler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
        handler.bulkAfter();
    } else if(Trigger.isDelete && Trigger.isAfter) {
        handler.OnAfterDelete(Trigger.old);
    }
}