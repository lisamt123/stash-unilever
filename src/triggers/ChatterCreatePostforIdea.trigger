trigger ChatterCreatePostforIdea on Idea (Before Insert, After Insert) {
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
    
  for(Idea i : trigger.new)
  {
  
  IdeaTheme ideaTheme=[SELECT Id,Idea_Theme_Poster_URL__c FROM IdeaTheme where id=:i.IdeaThemeId];
  User u=[Select Id from user where id=:i.CreatedById];
  
         FeedItem post = new FeedItem();
         post.ParentId = u.id;
         post.CreatedById=i.CreatorName;
         post.type='ContentPost';
         post.Body ='I have just submitted a new Idea.Please take a look and tell me what you think:\n'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+i.id;
         
         if(ideaTheme.Idea_Theme_Poster_URL__c!=null)
         {
         ContentVersion content= [SELECT ContentDocumentId,Id,Title FROM ContentVersion WHERE ContentDocumentId =:ideaTheme.Idea_Theme_Poster_URL__c];
         post.RelatedRecordId=content.Id;
         }
         
         else {
         List<ChatterIdeaThemes__c> IdeaThemesPic_null =[select DefaultIdeaCreatedPic__c from ChatterIdeaThemes__c limit 1 ];
         post.RelatedRecordId=IdeaThemesPic_null[0].DefaultIdeaCreatedPic__c;        
         }
         insert post;
   }
  } 
 }
 catch(Exception ex){}
}