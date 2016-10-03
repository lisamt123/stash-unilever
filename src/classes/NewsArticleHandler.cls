//Create a Chatter post in the Mentioned groups for a new News Article record.
public without sharing class NewsArticleHandler{
    
    public void handleAfterInsert(List<News_Article__c> triggerNew){
        try{
            List<FeedItem> feedItemsToInsert = new List<FeedItem>();
            
            String newsCentreAvatarId = CORE_NEWS_ARTICLE__c.getInstance('NEWS_ARTICLE_AVATAR_USER').Text_Value__c;
                 
            for(News_Article__c newsArticle : triggerNew){ 
                                
                Id postedById = newsCentreAvatarId != null ? newsCentreAvatarId : newsArticle.OwnerId;
                
                // Validate the Chatter Group id and check whether it exist in Sandbox.
                if(newsArticle.Post_to_NewsCentre__c && newsArticle.Chatter_Groups__c!=null && newsArticle.Chatter_Groups__c!=''){
                    for(String strGrp:newsArticle.Chatter_Groups__c.split(','))
                    if(strGrp != '' && strGrp != null){
                        List<CollaborationGroup> lstColbGrp=[SELECT Id FROM CollaborationGroup WHERE Id =:strGrp];
                        if(!lstColbGrp.isempty()){
                            //Format a FeedItem to post on group wall.
                            feedItemsToInsert.add(new FeedItem( Type = 'LinkPost', Body = newsArticle.Title__c, ParentId =strGrp,
                            LinkURL = newsArticle.Sharepoint_URL__c+newsArticle.Post_GA_URL__c, Title = newsArticle.Name, CreatedById = postedById));
                        }
                    }
                }               
            }
                   
            //Insert FeedItem.
            if(!feedItemsToInsert.isEmpty())
            Database.insert(feedItemsToInsert, false);
        }
        catch(Exception e){ System.debug('The following exception has occurred: ' + e.getMessage()); }
        
    }
}