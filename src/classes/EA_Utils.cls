/*
Class Name: EA_Utils
Author : Mindtree
Date: 29 oct 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description:  class for Everyday action app which has null check methods.
*/
public with sharing class EA_Utils{
    /*******************************************************************************************************
    * @description This method returns true if the input string is null or its length is zero.
    * @param String 
    * @return boolean value 
    */ 
    public static boolean isEmpty( String str ){
        if(string.isNotBlank(str)){
            return true;
        }
        return false;
    }
    /*******************************************************************************************************
    * @description This method returns true if the Sobject  List is null or is empty.
    * @param List 
    * @return boolean value 
    */
    public static boolean isEmpty( List<SObject>  lstActivity ){
        if( lstActivity  == null || lstActivity .isEmpty() ){
            return true;
        }
        return false;
    }
    /* This method returns Activty details for given Activity ID*/
    @AuraEnabled
    public static Everyday_Activity__c getActivitydetails(String ActivityID){
        Everyday_Activity__c actObj = new Everyday_Activity__c(); 
        if(String.isNotBlank(ActivityID)){
            List<Everyday_Activity__c> actList = [SELECT Active__c,Activity_Points__c,CreatedById,CreatedDate,Description__c,Id,
                                                  Minutes_to_Complete_Action__c,Name,OwnerId,Participants_Required__c,Rating__c,RecordTypeId,Top_Tip__c 
                                                  FROM   Everyday_Activity__c 
                                                  WHERE  Active__c =true AND id =: ActivityID ];                                           
            if(actList != null && actList.size()>0){      
                actObj = actList[0];
            }   
        }  
        return actObj;
    } 
    /*
    postCommentAtUserFeed - Method to post chatter comment on user's wall 
    activityId - Activity for which comment is posted
    userId - User who needs to be mentioned in Activity.
    postComment - Text comments which is required to post 
    */    
    @AuraEnabled
    public static void postCommentAtUserFeed(string activityId, string inviteeid, string participantId, string postComment){
      
        
        if(String.isNotBlank(activityId) && String.isNotBlank(participantId) && String.isNotBlank(postComment)){
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();               
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();      
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();       
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();       
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            mentionSegmentInput.id = participantId;
            messageBodyInput.messageSegments.add(mentionSegmentInput);   
            textSegmentInput.text = postComment;
            messageBodyInput.messageSegments.add(textSegmentInput);              
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            
			feedItemInput.subjectId = participantId;
			            
            ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(null, feedItemInput, null);
            
            
        }
    } 
    
    /* Get Team member record for participant user to update Participant response actions*/
    public static EA_Team_Member__c getParticipantTeamMemberRec(string activityId, string participantId){
        EA_Team_Member__c participantTeamMemRec = new EA_Team_Member__c();
        if(String.isNotBlank(activityId) && String.isNotBlank(participantId)){
            system.debug('%%%'+activityId);
            List<EA_Team_Member__c> tmList= [SELECT id, Activity_Due_Day__c, Everyday_Activity__c, Participant__c, 
                                             Rating_By_Participant__c, Invitation_Status__c, Type__c
                                             FROM   EA_Team_Member__c
                                             WHERE  Participant__c=: participantId AND Everyday_Activity__c =: activityId AND Invitation_Status__c=: EA_Constants.INVITATION_STATUS_INVITED  ];                  
            if(tmList.size()>0 && tmList!= null){   
                participantTeamMemRec=  tmList[0];
            }
        }
        return participantTeamMemRec;
    } 
    /* This method posts chatter comment for given parent ID */
    @AuraEnabled
    public static void postOnChatter(string parentId, string chatterPostComment){
        if(parentId != null && string.isNotBlank(chatterPostComment)){         
            FeedItem chatterPost = new FeedItem(ParentId = parentId , Body = chatterPostComment);     
            insert chatterPost;
        }
    }   
    /* This method returns all team member records for an Activity*/    
    @AuraEnabled
    public static List<EA_Team_Member__c> getTeamMebersForActivity(string activityId){     
        List<EA_Team_Member__c> tmList = new List<EA_Team_Member__c>();
        if(string.isNotBlank(activityId)){    
            List<EA_Team_Member__c> membersList = [SELECT Activity_Due_Day__c,Activity_Points__c,CreatedById,CreatedDate,Everyday_Activity__c,Feedback_Comments__c,Id,
                                                   Invitation_Status__c,Invitation_Text__c,Invited_By__c,
                                                   Name,Participant__c,Rating_By_Participant__c,Type__c 
                                                   FROM   EA_Team_Member__c
                                                   WHERE  Everyday_Activity__c =: activityId];          
            if(membersList != null && membersList.size()>0){           
                tmList.addAll(membersList);
            }     
        }    
        return tmList;                
    } 
    /* This method is used to round of the decimal rating to integer rating
    if avg rating is 3.48 , Act rating is 3
    if avg rating is 3.49 , Act rating is 3
    if avg rating is 3.50 , Act rating is 4
    if avg rating is 3.51 , Act rating is 4
    */  
    @AuraEnabled
    public static Integer getactivityRating(decimal avgRating){
        Integer result=0;
        if(((avgRating - 0.5) - (avgRating.intValue() - 1)) >= 1) {           
            result = (avgRating.intValue()+1);
        } 
        else if(((avgRating - 0.5) - (avgRating.intValue() - 1)) < 1) {       
            result = (avgRating.intValue());
        }       
        return result;
    }
   
   
}