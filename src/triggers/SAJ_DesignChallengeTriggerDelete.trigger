trigger SAJ_DesignChallengeTriggerDelete on task(after delete)
{
    SAJ_DesignChallengeTriggerHandller.deleteTask(trigger.oldMap);
}