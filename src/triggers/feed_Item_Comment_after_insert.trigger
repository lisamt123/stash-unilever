trigger feed_Item_Comment_after_insert on FeedComment (after insert) {
    List<FeedComment> newsArticleFeeds = new List<FeedComment>();
    Schema.SObjectType newsArticleType = Schema.News_Article__c.sObjectType;
    
    for(FeedComment rec : trigger.new){
        
      if(rec.ParentId != null && rec.ParentId.getSobjectType() == newsArticleType){
            newsArticleFeeds.add(rec);
        }
    
    }
    
    FeedCommentHandler fiHandler = new FeedCommentHandler();
    
  
    if(!newsArticleFeeds.isEmpty())
        fiHandler.handleNewsArticleComments(newsArticleFeeds);
  

}