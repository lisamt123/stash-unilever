/* This Trigger post a group feed for the specified group and on user profile upon creation of Ideas 
** Initial Write By : Mindtree for user feed to post. 
** Updated By : Mindtree to change the condition for user feed to post and added group feed. Date: 05-Jun-2015
*/
trigger CORE_IC_ChatterCreatePostforIdea on Idea (Before Insert, After Insert) {
  try {
  
  if (trigger.isBefore) 
  {
    Set<ID> setIdeaThemeIds=new Set<ID>();
    for(Idea i : trigger.new){
      setIdeaThemeIds.add(i.IdeaThemeId);
    }
    Map<Id,IdeaTheme> mapIdeaTheme=new Map<Id,IdeaTheme>([SELECT Id, Title FROM IdeaTheme where id IN : setIdeaThemeIds]);
    for (Idea rec: trigger.new) {
        rec.Idea_Theme__c = mapIdeaTheme.get(rec.IdeaThemeId).Title;
    }
  } 
    
  else { 
  List<feeditem> lstFeedItem=new List<feeditem>();
  
  Set<ID> setIdeaThemeIds=new Set<ID>();
  for(Idea i : trigger.new){
      setIdeaThemeIds.add(i.IdeaThemeId);
  }
  Map<Id,IdeaTheme> mapIdeaTheme=new Map<Id,IdeaTheme>([SELECT Id,Idea_Theme_Poster_URL__c,Title,Groups_to_Post__c FROM IdeaTheme where id in:setIdeaThemeIds]);
  //IdeaTheme ideaTheme=[SELECT Id,Idea_Theme_Poster_URL__c,Title,Groups_to_Post__c FROM IdeaTheme where id in:setIdeaThemeIds];
  //User u=[Select Id from user where id=:i.CreatedById];
  
  Set<ID> setContentDocIds=new Set<ID>();
  Map<Id,Id> mapIdsForContent=new Map<Id,Id>();
  for(IdeaTheme rec : mapIdeaTheme.values()){
      setContentDocIds.add(rec.Idea_Theme_Poster_URL__c);
  }
  List<ContentVersion> lstContentVersion= [SELECT ContentDocumentId,Id,Title FROM ContentVersion WHERE ContentDocumentId in:setContentDocIds];
  for(ContentVersion content:lstContentVersion){
      mapIdsForContent.put(content.ContentDocumentId,content.Id);
  }
  Id idDefaultImage=[SELECT Id FROM ContentVersion WHERE ContentDocumentId =:Core_Ideation__c.getinstance('DefaultIdeaImageId').Text_Value__c].Id;
  
  
  for(Idea i : trigger.new)
  {  
 
  IdeaTheme ideaTheme= mapIdeaTheme.get(i.IdeaThemeId);//=[SELECT Id,Idea_Theme_Poster_URL__c,Title,Groups_to_Post__c FROM IdeaTheme where id=:i.IdeaThemeId];
  //User u=[Select Id from user where id=:i.CreatedById];
         
         
         if(Core_Ideation__c.getinstance('IdeaPostInGroup').Checkbox_Value__c || Core_Ideation__c.getinstance('IdeaPostInUserProfile').Checkbox_Value__c){
                 //system.debug('~~~~True1');
                 if(Core_Ideation__c.getinstance('IdeaPostInUserProfile').Checkbox_Value__c){
                     //system.debug('~~~~True2');
                     FeedItem post = new FeedItem();
                 post.CreatedById=i.CreatorName;
                 post.type='ContentPost';
                 post.Body =Core_Ideation__c.getinstance('IdeaPostNotificationText').Text_Value__c+'\n'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/CORE_IC_NavigateToApp?articleId='+i.id+'&articleType=Idea';
                 
                 if(ideaTheme.Idea_Theme_Poster_URL__c!=null)
                 {
                     //ContentVersion content= [SELECT ContentDocumentId,Id,Title FROM ContentVersion WHERE ContentDocumentId =:ideaTheme.Idea_Theme_Poster_URL__c];
                     post.RelatedRecordId=mapIdsForContent.get(ideaTheme.Idea_Theme_Poster_URL__c);
                 }
                 else {
                     //ContentVersion content= [SELECT ContentDocumentId,Id,Title FROM ContentVersion WHERE ContentDocumentId =:Core_Ideation__c.getinstance('DefaultIdeaImageId').Text_Value__c];
                     post.RelatedRecordId=idDefaultImage;//content.Id;        
                 }
             
                 post.ParentId = i.CreatedById;//u.id;
                 lstFeedItem.add(post);
             }
             if(Core_Ideation__c.getinstance('IdeaPostInGroup').Checkbox_Value__c){
                 //system.debug('~~~~True3');
                 string strGroupIds;
                 string[] lstGroupIds=new string[]{};
                 if(ideaTheme.Groups_to_Post__c!=null && ideaTheme.Groups_to_Post__c!=''){
                     strGroupIds=ideaTheme.Groups_to_Post__c; 
                     lstGroupIds= strGroupIds.Split(',');
                 }
                 for(String strGpId :lstGroupIds){
                     //system.debug('~~~~True~~~IteratingForGroup');
                     FeedItem post = new FeedItem();
                     post.CreatedById=i.CreatorName;
                     post.type='ContentPost';
                     post.Body =Core_Ideation__c.getinstance('IdeaPostNotificationText').Text_Value__c+'\n'+URL.getSalesforceBaseUrl().toExternalForm()+'/apex/CORE_IC_NavigateToApp?articleId='+i.id+'&articleType=Idea';
                     
                     if(ideaTheme.Idea_Theme_Poster_URL__c!=null)
                     {
                         //ContentVersion content= [SELECT ContentDocumentId,Id,Title FROM ContentVersion WHERE ContentDocumentId =:ideaTheme.Idea_Theme_Poster_URL__c];
                         post.RelatedRecordId=mapIdsForContent.get(ideaTheme.Idea_Theme_Poster_URL__c);//content.Id;
                     }
                     else {
                         //ContentVersion content= [SELECT ContentDocumentId,Id,Title FROM ContentVersion WHERE ContentDocumentId =:Core_Ideation__c.getinstance('DefaultIdeaImageId').Text_Value__c];
                         post.RelatedRecordId=idDefaultImage;//content.Id;       
                     }
                     strGpId=strGpId.trim();
                     post.ParentId = Id.Valueof(strGpId);
                     lstFeedItem.add(post);
                 }
             }
         }
   }
   //system.debug('~~~~list'+lstFeedItem);
   if(lstFeedItem.size()>0)
   insert lstFeedItem;
  } 
 }
 catch(Exception ex){
 System.debug('An exception occurred: ' + ex);
 }
}