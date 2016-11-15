trigger NewsArticle_Before_After on News_Article__c (Before Insert, After Insert) {
    
       if (trigger.isBefore) {
           for(News_Article__c rec : trigger.new)
               rec.name=rec.title__c;
           }
         else {
            NewsArticleHandler newsArtclHandle = new NewsArticleHandler();
            newsArtclHandle.handleAfterInsert(trigger.new);
            }
     }