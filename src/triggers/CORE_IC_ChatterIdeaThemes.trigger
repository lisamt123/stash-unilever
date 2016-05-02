/* This Trigger post a group feed for the specified group upon creation of Idea Campaigns 
** Initial Write By : Mindtree for group feed to post. 
** Updated By : Mindtree to change the condition for group feed to post. Date: 05-Jun-2015
*/
trigger CORE_IC_ChatterIdeaThemes on IdeaTheme (Before Insert, After Insert, After Update) {
 try
     {
       if (trigger.isBefore) 
       {
             for(IdeaTheme rec : trigger.new)
              {          
                 rec.Zone_Id__c = rec.CommunityId;
                 system.debug('@@@@Start date'+rec.StartDate+'System date'+System.now());
                 
                 
              }
        } 
 
       else 
       {                  
         List<feeditem> lstFeedItem=new List<feeditem>();
         Boolean IsPost=false;
         
         Set<ID> setContentDocIds=new Set<ID>();
         Map<Id,Id> mapIdsForContent=new Map<Id,Id>();
         for(IdeaTheme rec : trigger.new){
             setContentDocIds.add(rec.Idea_Theme_Poster_URL__c);
         }
         List<ContentVersion> lstContentVersion= [SELECT ContentDocumentId,Id,Title FROM ContentVersion WHERE ContentDocumentId in:setContentDocIds];
         for(ContentVersion content:lstContentVersion){
             mapIdsForContent.put(content.ContentDocumentId,content.Id);
         }
         Id idDefaultImage=[SELECT Id FROM ContentVersion WHERE ContentDocumentId =:Core_Ideation__c.getinstance('DefaultIdeaImageId').Text_Value__c].Id;
         
         for(IdeaTheme rec : trigger.new)
         {
             if(Trigger.isInsert && rec.StartDate>System.now() && rec.Chatter_Post__c){  rec.Chatter_Post__c.addError(Core_Ideation__c.getinstance('ChatterPostErrorMessage').Text_Value__c);
             }
             else if(Trigger.isInsert && rec.EndDate<System.now() && rec.Chatter_Post__c){   rec.Chatter_Post__c.addError(Core_Ideation__c.getinstance('ChatterPostErrorMessageForEndDate').Text_Value__c);
             }
             else if((Trigger.isInsert || (Trigger.isUpdate && !System.Trigger.oldMap.get(rec.Id).Chatter_Post__c)) && rec.Chatter_Post__c && ((rec.Groups_to_Post__c==null||rec.Groups_to_Post__c=='') || (rec.Idea_Theme_Title__c==null||rec.Idea_Theme_Title__c==''))){ rec.Chatter_Post__c.addError(Core_Ideation__c.getinstance('ChatterPostRequiredErrorMessage').Text_Value__c);
             }
             else if(Trigger.isUpdate && rec.Chatter_Post__c && !System.Trigger.oldMap.get(rec.Id).Chatter_Post__c && rec.StartDate>System.now()){   rec.Chatter_Post__c.addError(Core_Ideation__c.getinstance('ChatterPostErrorMessage').Text_Value__c);
             }
             else if(Trigger.isUpdate && rec.Chatter_Post__c && !System.Trigger.oldMap.get(rec.Id).Chatter_Post__c && rec.EndDate<System.now()){   rec.Chatter_Post__c.addError(Core_Ideation__c.getinstance('ChatterPostErrorMessageForEndDate').Text_Value__c);
             }
             else if (Trigger.isUpdate && rec.Chatter_Post__c && !System.Trigger.oldMap.get(rec.Id).Chatter_Post__c && rec.StartDate<=System.now() && rec.EndDate>=System.now()){  IsPost=Boolean.valueOf(rec.Chatter_Post__c);
             }
             else if (Trigger.isInsert && rec.StartDate<=System.now() && rec.EndDate>=System.now() && rec.Chatter_Post__c) { IsPost= Boolean.valueOf(rec.Chatter_Post__c);
             }
             //system.debug('~~~~'+IsPost);   
          if(IsPost)
             {
                 string strGroupIds;
                 strGroupIds=rec.Groups_to_Post__c; 
                 string[] lstGroupIds= strGroupIds.Split(',');
                 //system.debug('~~~~'+lstGroupIds); 
                 for(String strGpId :lstGroupIds)
                 {
                    feeditem item=new feeditem();
                    item.CreatedById=rec.CreatedbyId;
                    item.body=rec.Idea_Theme_Title__c+'\n'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/Core_IC_IdeationHomePage?campaignId='+rec.id;
                    item.ParentId=strGpId;
                    item.type='ContentPost';
                      if(rec.Idea_Theme_Poster_URL__c!=null) {  Id content; if(mapIdsForContent.get(rec.Idea_Theme_Poster_URL__c)!=null) content=mapIdsForContent.get(rec.Idea_Theme_Poster_URL__c);  if(content!=null) {
                               item.RelatedRecordId=content;
                            }  else {  
                                //ContentVersion content1= [SELECT ContentDocumentId,Id,Title FROM ContentVersion WHERE ContentDocumentId =:Core_Ideation__c.getinstance('DefaultIdeaImageId').Text_Value__c];                               
                                item.RelatedRecordId=idDefaultImage;//content1.Id;   
                               //system.debug('~~~~2'+item.RelatedRecordId);
                            }
                        }
                      else
                        {
                         //ContentVersion content2= [SELECT ContentDocumentId,Id,Title FROM ContentVersion WHERE ContentDocumentId =:Core_Ideation__c.getinstance('DefaultIdeaImageId').Text_Value__c];
                         item.RelatedRecordId=idDefaultImage;//content2.Id;   
                         //system.debug('~~~~2'+item.RelatedRecordId);
                        }
                 
            
                lstFeedItem.add(item);
                //system.debug('~~~~'+lstFeedItem); 
                }
             }
           
         }
         //system.debug('~~~~'+lstFeedItem);
         if(lstFeedItem.size()>0)
          insert lstFeedItem;
       }
     }
  
  catch(Exception ex){
  System.debug('An exception occurred: ' + ex);
  }
}