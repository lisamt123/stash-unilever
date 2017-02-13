trigger SAJ_BusinessSolutionTriggerInsert on Task(after insert)
{
    SAJ_BusinessSolutionTriggerHandller.insertTask(trigger.newMap);
}