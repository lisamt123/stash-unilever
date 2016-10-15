trigger UserTrigger on User (before update) {
    UserTriggerHelper.checkisocurrency(trigger.newMap);
}