trigger SAJ_BusinessSolutionTriggerDelete on task(after delete)
{
    SAJ_BusinessSolutionTriggerHandller.deleteTask(trigger.oldMap);
}