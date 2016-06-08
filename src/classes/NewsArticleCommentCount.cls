public with sharing Class NewsArticleCommentCount{
  
   public static void newsArticleCount (Id newsArticleid){
    
    Decimal decFeedItemCnt=0.00;
    Decimal decFeedCommentCnt=0.00;
    Decimal decTotalCount=0.00;
  

  //System.debug('***** Parent id ' + newsArticleid);
    
   decFeedItemCnt=[SELECT count() FROM News_Article__Feed WHERE ParentId =: newsArticleid];
  // decFeedItemCnt=[SELECT count() FROM FeedItem WHERE ParentId =: newsArticleid];
  //System.debug('***** feedItemCnt ' + decFeedItemCnt);
  
   if(decFeedItemCnt>0) decFeedCommentCnt=(Decimal) [SELECT sum(CommentCount)cnt FROM News_Article__Feed WHERE ParentId =: newsArticleid][0].get('cnt');
   // if(decFeedItemCnt>0) decFeedCommentCnt= [SELECT count() FROM FeedComment WHERE ParentId =: newsArticleid];
   decTotalCount=decFeedItemCnt+decFeedCommentCnt;
   News_Article__c newsArt=new  News_Article__c(id=newsArticleid,Comment_Count__c=decTotalCount);
   update newsArt;
  }  
}