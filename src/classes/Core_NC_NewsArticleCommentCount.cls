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
    
    //Ask Paul Handler Method
   public   void chatterPostAskPaul(List<FeedItem> newTrigger){
    
       boolean   resultGrp=false;
     // Fetching the  ParentId's from Custom setting       
       string    strParentIdsToCheck;   
       strParentIdsToCheck = CORE_NEWS_ARTICLE__c.getinstance('GroupsToPost').Text_Value__c;  
      
              for(FeedItem objFI: newTrigger){ 
                //Enter only when ParentId is not Null            
                    if(objFI.ParentId !=null   ){
                 
                       // check if newly inserted Chatter post (record in feeditem) has ParentId matching to one of the values in the custom setting instance value
                       for(String strGrp:strParentIdsToCheck.split(',')){ 
                          String strGrpsToCheck = objFI.ParentId;
                           if(strGrpsToCheck == strGrp){
                              
                              resultGrp=true;  
                             }
                           
                          }
                         //check if  if newly inserted FeedItem body is not Null 
                         if(objFI.Body!= null ) {
                           if( objFI.Body.contains('?')  && resultGrp==true){
                              
                               //Change FeedItem Type to Qyestion Post
                                  objFI.Type = 'QuestionPost'; 
                                  resultGrp=false;
                               }
                             }
                        // check if newly inserted FeedItem post title is not null     
                         if(objFI.Title!= null ) {
                           if( objFI.Title.contains('?')  && resultGrp==true){
                            
                               //Change FeedItem Type to Qyestion Post 
                                  objFI.Type = 'QuestionPost'; 
                                  resultGrp=false;
                               }
                             }
                             
                          }//end of Parent If
                      }// end of Parent for
                  }
   
   }