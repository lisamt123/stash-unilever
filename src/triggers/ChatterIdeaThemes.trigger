trigger ChatterIdeaThemes on IdeaTheme (Before Insert, After Insert, After Update) {
 try
     {
       if (trigger.isBefore) 
       {
             for(IdeaTheme rec : trigger.new)
              {          
                 rec.Zone_Id__c = rec.CommunityId;
              }
        } 
 
       else 
       {                  
         List<feeditem> lstFeedItem=new List<feeditem>();
         Boolean IsPost=false;
         
         for(IdeaTheme rec : trigger.new)
         {
             if (Trigger.isInsert) {
             IsPost= Boolean.valueOf(rec.Active_Challenge__c);
             }
         
             else if (Trigger.isUpdate && rec.Active_Challenge__c==true){
             IdeaTheme before = System.Trigger.oldMap.get(rec.Id);
             Boolean boololdvalue = Boolean.valueOf(before.Active_Challenge__c);
             if(boololdvalue==false)
             IsPost=true;
             }
                 
          if(IsPost == True)
             {
                 string strGroupIds;
                 strGroupIds=rec.Groups_to_Post__c; 
                 string[] lstGroupIds= strGroupIds.Split(',');
        
                 for(String strGpId :lstGroupIds)
                 {
                    feeditem item=new feeditem();
                    item.CreatedById=rec.CreatedbyId;
                    item.body=rec.Idea_Theme_Title__c+'\n'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/ChatterIdeaThemes?id='+rec.id;
                    item.ParentId=strGpId;
                    item.type='ContentPost';
                      if(rec.Idea_Theme_Poster_URL__c!=null)
                        { 
                        ContentVersion content= [SELECT ContentDocumentId,Id,Title FROM ContentVersion WHERE ContentDocumentId =:rec.Idea_Theme_Poster_URL__c];
                            if(content!=null)
                            {
                               item.RelatedRecordId=content.id;
                            }
                            else
                            {
                               List<ChatterIdeaThemes__c> IdeaThemesPic_notnull =[select DefaultIdeaThemeCreatedPic__c from ChatterIdeaThemes__c limit 1 ];
                               item.RelatedRecordId=IdeaThemesPic_notnull[0].DefaultIdeaThemeCreatedPic__c ;
                            }
                        }
                      else
                        {
                         List<ChatterIdeaThemes__c> IdeaThemesPic_null =[select DefaultIdeaThemeCreatedPic__c from ChatterIdeaThemes__c limit 1 ];
                         item.RelatedRecordId=IdeaThemesPic_null[0].DefaultIdeaThemeCreatedPic__c ;
                        }
                 
            
                lstFeedItem.add(item);
                }
             }
          
          if(lstFeedItem.size()>0)
          insert lstFeedItem; 
         }
       }
     }
  
  catch(Exception ex){}
}