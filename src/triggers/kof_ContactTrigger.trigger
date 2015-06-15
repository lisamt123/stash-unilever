trigger kof_ContactTrigger on kof_Contact__c (before insert) {
	kof_ContactTriggerHandler handler = new kof_ContactTriggerHandler();
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
			handler.onBeforeInsert(trigger.new, trigger.newMap);
        }
    } 
}