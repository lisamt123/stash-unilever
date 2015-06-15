trigger FeedComment_after_insert on FeedComment (after insert) {
  try {  
        if (Trigger.isAfter && Trigger.isInsert)
            {
              uw_TriggerHandler handler = new uw_TriggerHandler();
        
              handler.handleFeedCommentAfterInsert(Trigger.newMap);
            }

      }
      
  catch(Exception ex){}      
}