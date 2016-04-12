/***********************************************
  Class Name: NewsArticleFeedItemAfterInsertAfterDelete
  Author : Mindtree
  Date: 16 March 2016
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description:  Trigger for calculating comment count
**********************************************************/
trigger NewsArticleFeedItemAfterInsertAfterDelete on FeedItem  (after insert, after delete) {
  
   Schema.SObjectType newsArticleType = Schema.News_Article__c.sObjectType;
   
   if(Trigger.isInsert){
     for(FeedItem objFI : trigger.new){  
             
         if(objFI .ParentId != null  && objFI .ParentId.getSobjectType() == newsArticleType){
              Core_NC_NewsArticleCommentCount.NewsArticleCount(objFI .ParentId); 
           }
        }
     }
     
     
    if(Trigger.isDelete) {
       for(FeedItem objFI : trigger.old){ 
               
         if(objFI .ParentId != null  && objFI .ParentId.getSobjectType() == newsArticleType){
              Core_NC_NewsArticleCommentCount.NewsArticleCount(objFI .ParentId);
           }
        }
     }
     
 

}