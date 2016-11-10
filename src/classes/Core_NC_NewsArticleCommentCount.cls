/*
  Class Name: Core_NC_NewsArticleCommentCount
  Author : Mindtree
  Date: 8 march 2016
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description:Count the number of comments and  class name modified as per unilever standard
  August 2016 :Auto Question Requirement  for Ask Paul Group Implemented
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
    
    //Auto Question for Ask Paul Requirement
    
   public void chatterPostAskPaul(List<FeedItem> newTrigger){
     Boolean   resultGrp=false;
     String  strParentIdsToCheck; 
      for(FeedItem objFI: newTrigger){ 
                //Enter only when ParentId is not Null && check if  if newly inserted FeedItem body is not Null            
                    if(objFI.ParentId !=null && objFI.Body!= null && objFI.Body.contains('?')  && objFI.Type=='TextPost'){
                  
                         String modifiedTitle =objFI.Body;
                         modifiedTitle = modifiedTitle.replaceAll('&nbsp;',' ');
                         modifiedTitle = modifiedTitle.replaceAll('\\<[^>]*>',' ');
                         modifiedTitle = modifiedTitle.replace('@', ' ');
                         modifiedTitle = modifiedTitle.replaceAll('#[A-Za-z0-9]+','');
                         String finalTitle=  modifiedTitle .mid(0, 60);
                         Integer checkLength= objFI.Body.length();
                         if(checkLength > 60){
                            finalTitle=finalTitle+'...';
                         }
                          // Fetching the  GroupId's from Custom setting 
         strParentIdsToCheck = CORE_NEWS_ARTICLE__c.getinstance('GroupsToPost').Text_Value__c;  
                       // check if newly inserted Chatter post (record in feeditem) has ParentId matching to one of the values in the custom setting instance value
                  for(String strGrp:strParentIdsToCheck.split(',')){ 
                          String strGrpsToCheck = objFI.ParentId;
                           if(strGrpsToCheck == strGrp){
                                resultGrp=true;  
                             }
                          }
                      //if grp ids match and title does not contain # and @ then Change FeedItem Type to Question Post
                        if( resultGrp ){
                                       objFI.Title=finalTitle;
                                       objFI.Type = 'QuestionPost'; 
                                       resultGrp=false; 
                                }
                                 
                           
                          }//end of Parent If
                      }// end of Parent for 
                 
                 
                }
   }