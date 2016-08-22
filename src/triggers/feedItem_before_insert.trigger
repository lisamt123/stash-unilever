trigger feedItem_before_insert on FeedItem (before insert) {
    
  
    if (Trigger.isBefore && Trigger.isInsert )
        {
           
            uw_TriggerHandler handler = new uw_TriggerHandler();
            handler.handleFeedItemBeforeInsert(Trigger.new);
       
         // Ask paul Logic handler Call   
            Core_NC_NewsArticleCommentCount handlerFeed=new Core_NC_NewsArticleCommentCount();
            handlerFeed.chatterPostAskPaul(Trigger.new);
          
         
    }
}