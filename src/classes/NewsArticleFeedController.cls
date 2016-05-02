public with sharing class NewsArticleFeedController{
    public String paramArticleId {get; set;}
   
    public PageReference likeArticle() {
       
       if(NewsArticleLikeRec == null){ //like only if not liked previously
           try{
               NewsArticleLikeRec = New NewsArticleLike__c( News_Article__c=articleId,User__c=UserInfo.getUserId());
               insert NewsArticleLikeRec;
               News_Article__c news_info=[ Select Id, Title__c, Sharepoint_URL__c, Socialise_Activity__c,Summary__c from News_Article__c 
                    where Id= :articleId];
               if(news_info.Summary__c==null || news_info.Summary__c=='')
                    news_info.Summary__c=' ';
               //Only Socialise to User Feed if configured on the Article
               if(newsArtRec.Socialise_Activity__c){
                   FeedItem post = new FeedItem();
                   post.ParentId = UserInfo.getUserId(); 
                   post.Body = 'Liked this article\n'+'Summary: '+news_info.Summary__c;
                   post.Title = NewsArtRec.Title__c;
                   //post.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/'+articleId;
                    post.LinkUrl = NewsArtRec.Sharepoint_URL__c;
                   insert post;
               }
            }
            catch(System.DMLException ex){
                System.debug(LoggingLevel.ERROR, 'Exception Liking News Article ' + ex.getMessage());
            }      
           init();
       }
       return null;
    }
 
 public PageReference doNothing(){
     init();
     return null;
 }
 
 public PageReference unlikeArticle() {
 
   if(NewsArticleLikeRec!=null)
   {
       delete NewsArticleLikeRec;
       NewsArticleLikeRec=null;
   }
   
   init();
        return null;
  }
    

public Id articleId {get; set;}
public NewsArticleLike__c NewsArticleLikeRec {get;set;}
public News_Article__c NewsArtRec {get;set;}
public boolean maintenanceMsg {get;set;}
public string Msg {get;set;}
public string strMsg {get;set;}
public NewsArticleFeedController(){
    
    if( CORE_NEWS_ARTICLE__c.getInstance('MAINTENANCE_ALERT').Checkbox_Value__c ){
        maintenanceMsg=true;
        strMsg = CORE_NEWS_ARTICLE__c.getInstance('MAINTENANCE_ALERT').Text_Value__c;
    }
    
    paramArticleId = ApexPages.currentPage().getParameters().get('articleId');
    articleId = Id.valueOf(paramArticleId);
    init();
    
}

private void init(){
    try{
         newsArtRec= [Select Id, Like_Count_RSF__c,Title__c, Sharepoint_URL__c, Comment_Count__c, Socialise_Activity__c,
                 (select id from NewsArticleLikes__r where News_Article__c=:articleId and User__c=:UserInfo.getUserId())
                     from News_Article__c where Id = :articleId];
         if(!newsArtRec.NewsArticleLikes__r.isEmpty())
             NewsArticleLikeRec= newsArtRec.NewsArticleLikes__r[0];
    }catch(Exception ex){
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
    }
 }
 }