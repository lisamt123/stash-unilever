trigger SAJ_BusinessSolutionTriggerUpdate on Task (after update) {
SAJ_BusinessSolutionTriggerHandller.updateTask(Trigger.newMap, Trigger.OldMap);
}