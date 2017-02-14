trigger SAJ_DesignChallengeTrigger on Task(after insert, after update, after delete)
{
if(trigger.isInsert)
{
SAJ_DesignChallengeTriggerHandller.insertTask(trigger.newMap);
}
else if(trigger.isUpdate)
{
SAJ_DesignChallengeTriggerHandller.updateTask(Trigger.newMap, Trigger.OldMap);
}
else if(trigger.isDelete)
{
SAJ_DesignChallengeTriggerHandller.deleteTask(trigger.oldMap);
}
}