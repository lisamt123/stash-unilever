trigger NewsArticleFeedCommentAfterInsertDelete on FeedComment (after insert, after delete) {
    
    Schema.SObjectType newsArticleType = Schema.News_Article__c.sObjectType;
    
    if(Trigger.isInsert){
       for(FeedComment objFC : trigger.new){
            
          if(objFC.ParentId != null && objFC.ParentId.getSobjectType() == newsArticleType){
              Core_NC_NewsArticleCommentCount.NewsArticleCount(objFC.ParentId); 
           }
        }
     }
    
    if(Trigger.isDelete){
       for(FeedComment objFC : trigger.old){
            
         if(objFC.ParentId != null && objFC.ParentId.getSobjectType() == newsArticleType){
              Core_NC_NewsArticleCommentCount.NewsArticleCount(objFC.ParentId); 
           }
        }
     }
    
   /* System.debug('**** Trigger Started');
    List<News_Article__c> lstNewsArt = new List<News_Article__c>();
    
    if(Trigger.isInsert){
        for(FeedComment objFC : Trigger.new){
            List<News_Article__c> lstNewsArticle = [select id, Comment_Count__c from News_Article__c where id=:objFC.ParentId ];
            if(lstNewsArticle.size()>0){
           News_Article__c objArtTemp =  lstNewsArticle[0];
            objArtTemp.Comment_Count__c=objArtTemp.Comment_Count__c+1;
            System.debug('**** objNA ' + objArtTemp);
             lstNewsArt.add(objArtTemp);
          }
        }
    }
    
    if(Trigger.isDelete){
        for(FeedComment objFC : Trigger.old){
            List<News_Article__c> lstNewsArticle = [select id, Comment_Count__c from News_Article__c where id=:objFC.ParentId ];
            if(lstNewsArticle.size()>0){
                News_Article__c objArtTemp =  lstNewsArticle[0];
                objArtTemp.Comment_Count__c=objArtTemp.Comment_Count__c-1;
                System.debug('**** objNA old ' + objArtTemp);
                lstNewsArt.add(objArtTemp);
          }
        }
    }    
    
    if(lstNewsArt.size()>0)
            update lstNewsArt;    
    System.debug('**** Trigger Ended'); */

}