trigger user_after_update on User (after update) 
{
    if (Trigger.isAfter && Trigger.isUpdate)
    {
        uw_TriggerHandler handler = new uw_TriggerHandler();
        handler.handleUserAfterUpdates(Trigger.newMap, Trigger.oldMap);     
    }
}