trigger feedItem_before_after_delete on FeedItem (after delete, before delete) {
    if (trigger.isDelete) {
    	if (trigger.isBefore) {
    		system.debug('feeditem: before delete');
    		uw_TriggerHandler h = new uw_TriggerHandler();
    		h.handleFeedItemBeforeDelete(trigger.old, trigger.oldMap);
            /*
            for (FeedItem fi:trigger.old) {
            	fi.addError('Cannot delete FeedItem: code under test');
            }
            */
    	} else if (trigger.isAfter) {
            system.debug('feeditem: after delete');    		
    	}
    }
}