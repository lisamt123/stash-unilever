public with sharing class FeedCommentHandler{
    
    public void handleNewsArticleComments(List<FeedComment> newsArticleFeeds){
        Map<Id, List<Id>> articleUserMap = new Map<Id, List<Id>>{};
        
        for(FeedComment newsArticleFeed : newsArticleFeeds){
               
            List<Id> userIds = articleUserMap.get(newsArticleFeed.ParentId);
            if(userIds == null){
                userIds = new List<Id>{};
                articleUserMap.put(newsArticleFeed.ParentId, userIds);
            }
            userIds.add(newsArticleFeed.CreatedById);
        }
        
        socialiseToUserFeed(articleUserMap, 'Commented on');
    }
 
    public void socialiseToUserFeed(Map<Id, List<Id>> articleUserMap, String operation){
        
        List<FeedItem> feedItems = new List<FeedItem>{};
        
        for(News_Article__c newsArticle : [Select Id, Title__c, Sharepoint_URL__c, Socialise_Activity__c,Summary__c,Comment_GA_URL__c from News_Article__c 
                    where Id IN :articleUserMap.keySet()])
        {   
            String strCommentGAURL = (newsArticle.Comment_GA_URL__c != '' && newsArticle.Comment_GA_URL__c != null) ? newsArticle.Comment_GA_URL__c: '';
            //Only socialise to User Feed if configured on Article
            if(newsArticle.Socialise_Activity__c) 
                for(Id userId : articleUserMap.get(newsArticle.Id)){
                if(newsArticle.Summary__c==null || newsArticle.Summary__c=='')
                   newsArticle.Summary__c=' ';
                          feedItems.add(new FeedItem(ParentId = userId, Body = operation + ' this article'+'\n'+'Article summary: '+newsArticle.Summary__c, 
                       Title = newsArticle.Title__c, LinkUrl = newsArticle.Sharepoint_URL__c + strCommentGAURL)); 
                 //  feedItems.add(new FeedItem(ParentId = userId,Title='hello', Body = operation + ' this article '+'\n' +newsArticle.Title__c+' ('+newsArticle.Sharepoint_URL__c+')'+'\n'+newsArticle.Summary__c, type='textpost')); 
                }    
        }
        
        if(feedItems != null && !feedItems.isEmpty())
            Database.insert(feedItems, false);
                    
    }
    
}