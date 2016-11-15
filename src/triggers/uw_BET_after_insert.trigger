trigger uw_BET_after_insert on uw_BET__c (after insert) {
    
    if (Trigger.isAfter && Trigger.isInsert)
    {
        uw_TriggerHandler handler = new uw_TriggerHandler();
        handler.handleBetAfterInserts(Trigger.new);
    }

}