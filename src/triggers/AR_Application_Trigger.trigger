trigger AR_Application_Trigger on ar_Application__c (after update) {
	AR_Application_Trigger_Handler handler = AR_Application_Trigger_Handler.getInstance();
	
	// After insert
	if(Trigger.isUpdate && Trigger.isAfter){
		handler.onAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
	}
	
}