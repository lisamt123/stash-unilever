trigger cp_EventTrigger on cp_Event__c (after delete, after insert, after undelete, 
                                                        after update, before delete, before insert, before update) 
{
    cp_EventTriggerHandler handler = new cp_EventTriggerHandler(true,200);

    if (Trigger.isBefore)
    {
    // before trigger
        if (Trigger.isInsert)
        {
            handler.OnBeforeInsert(trigger.new, trigger.newMap);

        }
        else if (Trigger.isUpdate)
        {
            handler.OnBeforeUpdate(trigger.old, trigger.new, trigger.newMap, trigger.oldMap);
        }
    // after trigger    
    }
    else
    {
        if (Trigger.isUpdate)
        {
            handler.OnAfterUpdate(trigger.old, trigger.new, trigger.newMap, trigger.oldMap);
        }
    }
}