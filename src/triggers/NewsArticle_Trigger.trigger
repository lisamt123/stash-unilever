trigger NewsArticle_Trigger on News_Article__c (Before Insert, After Insert) {
    
       if (trigger.isBefore) {
           for(News_Article__c rec : trigger.new)
               rec.name=rec.title__c;
           }
         else {
            Core_NC_NewsArticleHandler newsArtclHandle = new Core_NC_NewsArticleHandler();
            newsArtclHandle.handleAfterInsert(trigger.new);
            }
     }