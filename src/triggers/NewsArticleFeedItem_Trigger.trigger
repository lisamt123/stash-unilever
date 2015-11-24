trigger NewsArticleFeedItem_Trigger on FeedItem  (after insert, after delete) {
  
   Schema.SObjectType newsArticleType = Schema.News_Article__c.sObjectType;
   
   if(Trigger.isInsert){
     for(FeedItem objFI : trigger.new){  
             
         if(objFI .ParentId != null  && objFI .ParentId.getSobjectType() == newsArticleType){
              NewsArticleCommentCount.NewsArticleCount(objFI .ParentId); 
           }
        }
     }
     
     
    if(Trigger.isDelete) {
       for(FeedItem objFI : trigger.old){ 
               
         if(objFI .ParentId != null  && objFI .ParentId.getSobjectType() == newsArticleType){
              NewsArticleCommentCount.NewsArticleCount(objFI .ParentId);
           }
        }
     }
     
  /*  System.debug('**** Trigger Started');
     List<News_Article__c> lstNewsArt = new List<News_Article__c>();
     
      if(Trigger.isInsert){
        for(FeedItem objFC : Trigger.new){
            List<News_Article__c> lstNewsArticle = [select id, Comment_Count__c from News_Article__c where id=:objFC.ParentId ];
            if(lstNewsArticle.size()>0){
            News_Article__c objArtTemp =  lstNewsArticle[0];
            objArtTemp.Comment_Count__c=objArtTemp.Comment_Count__c+1;
            //System.debug('**** objNA ' + objArtTemp);
            lstNewsArt.add(objArtTemp);
          }
        }
    
    }
    if(Trigger.isDelete){
        for(FeedItem objFC : Trigger.old){
            List<News_Article__c> lstNewsArticle = [select id, Comment_Count__c from News_Article__c where id=:objFC.ParentId ];
            List<FeedItem>  stFeedItem=[select CommentCount from FeedItem where parentid=:objFC.ParentId];

                if(lstNewsArticle.size()>0){
                News_Article__c objArtTemp =  lstNewsArticle[0];
             //   objArtTemp.Comment_Count__c=objArtTemp.Comment_Count__c-1;
               objArtTemp.Comment_Count__c=objArtTemp.Comment_Count__c-(stFeedItem[0].CommentCount+1) ;     
                //System.debug('**** objNA old ' + objArtTemp);
                lstNewsArt.add(objArtTemp);
          }
        }
    }  
     
    
    
    if(lstNewsArt.size()>0)
        update lstNewsArt;
        
    
   
    System.debug('**** Trigger Ended'); */

}