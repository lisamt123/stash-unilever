trigger uw_ContentDocument_before_after_delete on ContentDocument (after delete, before delete) {
    if (trigger.isDelete) {
    	if (trigger.isBefore) {
    		system.debug('contentDocument trigger: isBefore');
    		
    		uw_TriggerHandler h = new uw_TriggerHandler();
    		h.handleContentDocumentDelete(trigger.old, trigger.oldMap);
     	} else if (trigger.isAfter) {
            system.debug('contentDocument trigger: isAfter');    		
    	}
    }
}