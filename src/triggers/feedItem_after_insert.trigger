trigger feedItem_after_insert on FeedItem (after insert) {
    
    List<FeedItem> newsArticleFeeds = new List<FeedItem>();
    Schema.SObjectType newsArticleType = Schema.News_Article__c.sObjectType;
    
    for(FeedItem rec : trigger.new){
        
      if(rec.ParentId != null && rec.ParentId.getSobjectType() == newsArticleType){
            newsArticleFeeds.add(rec);
        }
    
    }
    
    FeedItemCommentHandler fiHandler = new FeedItemCommentHandler();
    
  
    if(!newsArticleFeeds.isEmpty())
        fiHandler.handleNewsArticleComments(newsArticleFeeds);
  
}