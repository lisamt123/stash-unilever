trigger uw_BET_before_insert on uw_BET__c (before insert) {
    
    if (Trigger.isBefore && Trigger.isInsert)
    {
        uw_TriggerHandler handler = new uw_TriggerHandler();
        handler.handleBetBeforeInserts(Trigger.new);
    }
}