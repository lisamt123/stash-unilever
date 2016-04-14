/*
  Class Name: Core_NC_NewsArticleCommentCount
  Author : Mindtree
  Date: 8 march 2016
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description:Count the number of comments and  class name modified as per unilever standard
*/
public with sharing Class Core_NC_NewsArticleCommentCount{
   public static void newsArticleCount (Id newsArticleid){
    Decimal decFeedItemCnt=0.00;
    Decimal decFeedCommentCnt=0.00;
    Decimal decTotalCount=0.00;
    decFeedItemCnt=[SELECT count() FROM News_Article__Feed WHERE ParentId =: newsArticleid];
   if(decFeedItemCnt>0){
   decFeedCommentCnt=(Decimal) [SELECT sum(CommentCount)cnt FROM News_Article__Feed WHERE ParentId =: newsArticleid][0].get('cnt');
}
   decTotalCount=decFeedItemCnt+decFeedCommentCnt;
   News_Article__c newsArt=new  News_Article__c(id=newsArticleid,Comment_Count__c=decTotalCount);
   update newsArt;
  }  
}