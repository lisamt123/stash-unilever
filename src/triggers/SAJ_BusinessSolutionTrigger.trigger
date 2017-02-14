trigger SAJ_BusinessSolutionTrigger on Task(after insert, after update, after delete)
{
if(trigger.isInsert)
{
SAJ_BusinessSolutionTriggerHandller.insertTask(trigger.newMap);
}
else if(trigger.isUpdate)
{
SAJ_BusinessSolutionTriggerHandller.updateTask(Trigger.newMap, Trigger.OldMap);
}
else if(trigger.isDelete)
{
SAJ_BusinessSolutionTriggerHandller.deleteTask(trigger.oldMap);
}
}