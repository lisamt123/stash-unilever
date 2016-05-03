public with sharing class NewsArticleLikeHandler{
    
    public void handleNewsArticleLike (List<NewsArticleLike__c> newsArticleLikes){
        Map<Id, List<Id>> articleUserMap = new Map<Id, List<Id>>{};
        
        for(NewsArticleLike__c newsArticleLike : newsArticleLikes){
               
            List<Id> userIds = articleUserMap.get(newsArticleLike.News_Article__c);
            if(userIds == null){
                userIds = new List<Id>{};
                articleUserMap.put(newsArticleLike.News_Article__c, userIds);
            }
            userIds.add(newsArticleLike.CreatedById);
        }
        
        socialiseToUserFeed(articleUserMap, 'Liked ');
    }
 
    public void socialiseToUserFeed(Map<Id, List<Id>> articleUserMap, String operation){
        
        List<FeedItem> feedItems = new List<FeedItem>{};
        
        for(News_Article__c newsArticle : [Select Id, Title__c, Sharepoint_URL__c, Socialise_Activity__c,Summary__c,Like_GA_URL__c from News_Article__c 
                    where Id IN :articleUserMap.keySet()])
        {   
            String strLikeGAURL= (newsArticle.Like_GA_URL__c!= null && newsArticle.Like_GA_URL__c!='') ? newsArticle.Like_GA_URL__c: '';
            //Only socialise to User Feed if configured on Article
            if(newsArticle.Socialise_Activity__c) 
                for(Id userId : articleUserMap.get(newsArticle.Id)){
system.debug('test vvo' +userId);                
                    if(newsArticle.Summary__c==null || newsArticle.Summary__c=='')
                    newsArticle.Summary__c='abc';
                    feedItems.add(new FeedItem(ParentId = userId, Body = operation + 'this article'+'\n'+'Article summary: '+newsArticle.Summary__c, 
                           Title = newsArticle.Title__c, LinkUrl = newsArticle.Sharepoint_URL__c+strLikeGAURL)); 
                           }  
        }
        
        if(feedItems != null && !feedItems.isEmpty())
            Database.insert(feedItems, false);
                    
    }
    
}