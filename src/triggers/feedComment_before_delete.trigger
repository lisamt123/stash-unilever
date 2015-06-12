trigger feedComment_before_delete on FeedComment (before delete) 
{
    try {
          if (Trigger.isBefore && Trigger.isDelete)
            {
              uw_TriggerHandler handler = new uw_TriggerHandler();
        
              handler.handleFeedCommentBeforeDelete(Trigger.oldMap);
        
            }
        }
   catch(Exception ex){}       
}