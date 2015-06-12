trigger kof_AccountTrigger on kof_Account__c (before insert, before update, after insert) {
	
	kof_AccountTriggerHandler handler = new kof_AccountTriggerHandler();
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            handler.onBeforeUpdate(trigger.old, trigger.new, trigger.newMap);
        }
    } else {
    	if (Trigger.isInsert) {
                handler.onAfterInsert(trigger.new, trigger.newMap);
        }
    }
}