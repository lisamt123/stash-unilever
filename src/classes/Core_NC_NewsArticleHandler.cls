public with sharing class Core_NC_NewsArticleHandler{
    public void handleAfterInsert(List<News_Article__c> triggerNew){
        try{
            List<FeedItem> feedItemsToInsert = new List<FeedItem>();
            
            String newsCentreAvatarId = CORE_NEWS_ARTICLE__c.getInstance('NEWS_ARTICLE_AVATAR_USER').Text_Value__c; 
           //custom setting used when site type and site name is 'Paul's Blog', on the after insert trigger for news article object and set FeedItem body for Chatter post created  :News Centre Enhancements   
            String siteDetails = CORE_NEWS_ARTICLE__c.getInstance('Site').Text_Value__c;    
            String postTitle = CORE_NEWS_ARTICLE__c.getInstance('chatterBody').Text_Value__c;    
            
            for(News_Article__c newsArticle : triggerNew){ 
                                
                Id postedById = newsCentreAvatarId != null ? newsCentreAvatarId : newsArticle.OwnerId;                
                
                // Validate the Chatter Group id and check whether it exist in Sandbox.
                //private boolean executeCode = ((newsArticle.Archived__c==false && newsArticle.Hidden__c==false && newsArticle.Video_Article__c==false)?true:false);
               boolean executeCode = (!newsArticle.Archived__c && !newsArticle.Hidden__c && !newsArticle.Video_Article__c?true:false);
                if(newsArticle.Post_to_NewsCentre__c && newsArticle.Chatter_Groups__c!=null && newsArticle.Chatter_Groups__c!='' && executeCode ){
                    for(String strGrp:newsArticle.Chatter_Groups__c.split(',')) {
                    //create chatter post when site type and site name is 'Paul's Blog':News Centre Enhancements
                        if(strGrp != '' && strGrp != null && newsArticle.Site_Name__c==siteDetails && newsArticle.Site_Type__c==siteDetails){
                            //List<CollaborationGroup> lstColbGrp=[SELECT Id FROM CollaborationGroup WHERE Id =:strGrp];
                            //if(!lstColbGrp.isempty()){
                                //Format a FeedItem to post on group wall.
                                feedItemsToInsert.add(new FeedItem( Type = 'LinkPost', Body =postTitle , ParentId =strGrp,
                                LinkURL = newsArticle.Sharepoint_URL__c+newsArticle.Post_GA_URL__c, Title = newsArticle.Name, CreatedById = postedById));
                            //} 
                        }
                        //create chatter post when site type and site name is News Centre:News Centre Enhancements
                        else if(strGrp != '' && strGrp != null){
                             feedItemsToInsert.add(new FeedItem( Type = 'LinkPost', Body =newsArticle.Title__c , ParentId =strGrp,
                                LinkURL = newsArticle.Sharepoint_URL__c+newsArticle.Post_GA_URL__c, Title = newsArticle.Name, CreatedById = postedById));
                            
                        }
                    }
                }               
            }           
                
            //Insert FeedItem
            if(!feedItemsToInsert.isEmpty())
            Database.insert(feedItemsToInsert, false);
        }
        catch(Exception e){ System.debug('The following exception has occurred: ' + e.getMessage()); }
        
    }
}