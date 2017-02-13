trigger SAJ_DesignChallengeTriggerUpdate on Task (after update) {
SAJ_DesignChallengeTriggerHandller.updateTask(Trigger.newMap, Trigger.OldMap);
}