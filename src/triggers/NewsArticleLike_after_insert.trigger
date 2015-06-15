trigger NewsArticleLike_after_insert on NewsArticleLike__c (after insert) {
 List<NewsArticleLike__c> newsArticleLikes = new List<NewsArticleLike__c>();
    Schema.SObjectType newsArticleType = Schema.News_Article__c.sObjectType;
    
    for(NewsArticleLike__c rec : trigger.new){
        
      if(rec.News_Article__c!= null && rec.News_Article__c.getSobjectType() == newsArticleType){
            newsArticleLikes.add(rec);
        }
    
    }
    
    NewsArticleLikeHandler likeHandler = new NewsArticleLikeHandler();
    
  
    if(!newsArticleLikes.isEmpty())
        likeHandler.handleNewsArticleLike(newsArticleLikes);
}