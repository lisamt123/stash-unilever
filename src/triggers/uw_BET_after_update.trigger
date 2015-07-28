trigger uw_BET_after_update on uw_BET__c (after update) {
	
	if (Trigger.isAfter && Trigger.isUpdate)
	{
		uw_TriggerHandler handler = new uw_TriggerHandler();
		
		handler.handleBetAfterUpdates(Trigger.newMap,Trigger.oldMap);
	}

}