/* This Trigger post a group feed for the specified group and on user profile upon creation of Ideas 
** Initial Write By : Mindtree for user feed to post. 
** Updated By : Mindtree to change the condition for user feed to post and added group feed. Date: 05-Jun-2015
*/
trigger CORE_IC_ChatterCreatePostforIdea on Idea (Before Insert, After Insert) {
  try {
  if (trigger.isBefore) 
  {
    
     for(Idea rec : trigger.new)
     {
      IdeaTheme ideaThemeRec=[SELECT Id,Title FROM IdeaTheme where id=:rec.IdeaThemeId];          
            rec.Idea_Theme__c = ideaThemeRec.Title;
     }
  } 
    
  else { 
  List<feeditem> lstFeedItem=new List<feeditem>();
  for(Idea i : trigger.new)
  {
  
  IdeaTheme ideaTheme=[SELECT Id,Idea_Theme_Poster_URL__c,Title,Groups_to_Post__c FROM IdeaTheme where id=:i.IdeaThemeId];
  User u=[Select Id from user where id=:i.CreatedById];
         
         
         if(Core_Ideation__c.getinstance('IdeaPostInGroup').Checkbox_Value__c==true || Core_Ideation__c.getinstance('IdeaPostInUserProfile').Checkbox_Value__c==true){
                 system.debug('~~~~True1');
                 if(Core_Ideation__c.getinstance('IdeaPostInUserProfile').Checkbox_Value__c==true){
                     system.debug('~~~~True2');
                     FeedItem post = new FeedItem();
                 post.CreatedById=i.CreatorName;
                 post.type='ContentPost';
                 post.Body =Core_Ideation__c.getinstance('IdeaPostNotificationText').Text_Value__c+'\n'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/Core_IC_IdeationHomePage?ideaId='+i.id;
                 
                 if(ideaTheme.Idea_Theme_Poster_URL__c!=null)
                 {
                     ContentVersion content= [SELECT ContentDocumentId,Id,Title FROM ContentVersion WHERE ContentDocumentId =:ideaTheme.Idea_Theme_Poster_URL__c];
                     post.RelatedRecordId=content.Id;
                 }
                 else {
                     ContentVersion content= [SELECT ContentDocumentId,Id,Title FROM ContentVersion WHERE ContentDocumentId =:Core_Ideation__c.getinstance('DefaultIdeaImageId').Text_Value__c];
                     post.RelatedRecordId=content.Id;        
                 }
             
                 post.ParentId = u.id;
                 lstFeedItem.add(post);
             }
             if(Core_Ideation__c.getinstance('IdeaPostInGroup').Checkbox_Value__c){
                 system.debug('~~~~True3');
                 string strGroupIds;
                 string[] lstGroupIds=new string[]{};
                 if(ideaTheme.Groups_to_Post__c!=null && ideaTheme.Groups_to_Post__c!=''){
                     strGroupIds=ideaTheme.Groups_to_Post__c; 
                     lstGroupIds= strGroupIds.Split(',');
                 }
                 for(String strGpId :lstGroupIds){
                     system.debug('~~~~True~~~IteratingForGroup');
                     FeedItem post = new FeedItem();
                     post.CreatedById=i.CreatorName;
                     post.type='ContentPost';
                     post.Body =Core_Ideation__c.getinstance('IdeaPostNotificationText').Text_Value__c+'\n'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/Core_IC_IdeationHomePage?ideaId='+i.id;
                     
                     if(ideaTheme.Idea_Theme_Poster_URL__c!=null)
                     {
                         ContentVersion content= [SELECT ContentDocumentId,Id,Title FROM ContentVersion WHERE ContentDocumentId =:ideaTheme.Idea_Theme_Poster_URL__c];
                         post.RelatedRecordId=content.Id;
                     }
                     else {
                         ContentVersion content= [SELECT ContentDocumentId,Id,Title FROM ContentVersion WHERE ContentDocumentId =:Core_Ideation__c.getinstance('DefaultIdeaImageId').Text_Value__c];
                         post.RelatedRecordId=content.Id;       
                     }
                     strGpId=strGpId.trim();
                     post.ParentId = Id.Valueof(strGpId);
                     lstFeedItem.add(post);
                 }
             }
         }
         system.debug('~~~~list'+lstFeedItem);
         if(lstFeedItem.size()>0)
          insert lstFeedItem;
   }
  } 
 }
 catch(Exception ex){}
}