trigger feedItem_before_insert on FeedItem (before insert) {
	
	if (Trigger.isBefore && Trigger.isInsert)
	{
		uw_TriggerHandler handler = new uw_TriggerHandler();
		
		handler.handleFeedItemBeforeInsert(Trigger.new);
		
	}
}