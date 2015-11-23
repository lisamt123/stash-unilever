/*
    Class Name: EA_Notification_Controller.cls
    Author : Mindtree
    Date: 20th Nov 2015
    Requirement/Project Name: Unilever Salesforce Engagement
    Requirement/Description: Everyday action app Controller class for handling all Chatter Notification events.
*/

public with sharing class EA_Notification_Controller {
    
    /* Activity Accepted or declined notification post to Invitee*/ 
    
    @AuraEnabled
    public static void inviteResponseNofitification(string activityId, string inviteeId , string participantId , string responseText){
        
        String actName;
        String participantName;
        String msgLabel;
        
        if(String.isNotBlank(activityId) && String.isNotBlank(inviteeId) && String.isNotBlank(participantId)){
            
            Everyday_Activity__c actObj = EA_Utils.getActivitydetails(activityId);
            
            List<User> userList = [SELECT id, Name FROM User WHERE id =: participantId];
            
            if(actObj != null) actName = actObj.Name;
            if(userList.size()>0 && userList != null) participantName = userList[0].Name;
            
            if(responseText == EA_Constants.INVITATION_STATUS_ACCEPTED) msgLabel = Label.EA_Activity_Accepted;      
            if(responseText == EA_Constants.INVITATION_STATUS_DECLINED) msgLabel = Label.EA_Activity_Declined ;
            
            if(String.isNotBlank(actName) && String.isNotBlank(participantName)&& String.isNotBlank(msgLabel)){
            	
                EA_Utils.postCommentAtUserFeed(activityId, inviteeId, participantName + msgLabel + actName);
                updateParticipantResponse(activityId, participantId, responseText);
            }
        }
    }
    
    /* Invite multiple users through chatter feed to do an Activity */ 
    
    @AuraEnabled
    public static void inviteUsersToDoActivity(string activityId, List<String> userIds){
        
        if(userIds.size()>0 && userIds != null && String.isNotBlank(activityId)){
            
            for(String userId : userIds){
                inviteUserToDoActivity(activityId, userId);
            }
        }
        
    }
    
    /* Invite single user through chatter feed to do an Activity */
    
    @AuraEnabled
    public static void inviteUserToDoActivity(string activityId, string userId){
        
        if(String.isNotBlank(activityId) && String.isNotBlank(userId)){
            EA_Utils.postCommentAtUserFeed(activityId, userId, Label.EA_Invite_Message + 'http://www.google.com'); // Sample hyper link to Accept/Decline pop up
            
        }
    } 
    
    
   /* Submit Invitation Response */ 
    
    @AuraEnabled
    public static void updateParticipantResponse(string activityId, string participantId, string responseText){
    
    	//Get EA_Team_Member__c record
    	    	
    	EA_Team_Member__c partcipantTeamMeberRec = EA_Utils.getParticipantTeamMemberRec(activityId, participantId);
    	
    	// Update EA_Team_Member__c record
    	
    	if(partcipantTeamMeberRec != null){
    		
    		if(responseText == EA_Constants.INVITATION_STATUS_ACCEPTED) partcipantTeamMeberRec.Invitation_Status__c = EA_Constants.INVITATION_STATUS_ACCEPTED;      
            if(responseText == EA_Constants.INVITATION_STATUS_DECLINED) partcipantTeamMeberRec.Invitation_Status__c = EA_Constants.INVITATION_STATUS_DECLINED;
            
            update partcipantTeamMeberRec;
    	}      
      
    }  
    
    /* This method sends feedback reminder for an Activity to participant user*/
    
    @AuraEnabled
    public static void sendFeedbackReminder(string activityId, string participantId){
    
    	EA_Utils.postCommentAtUserFeed(activityId, participantId, Label.EA_Feedback_Reminder + 'Activity URL'); // hyper link to Feedback pop up
    }
   
    
}