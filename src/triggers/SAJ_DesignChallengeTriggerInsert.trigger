trigger SAJ_DesignChallengeTriggerInsert on Task(after insert)
{
    SAJ_DesignChallengeTriggerHandller.insertTask(trigger.newMap);
}