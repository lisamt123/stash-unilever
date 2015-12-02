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
    public static void inviteResponseNofitification(string activityId, string teamid , string responseText){
        system.debug('=============='+activityId);
        system.debug('=============='+teamid );
        system.debug('=============='+responseText);
        List<EA_Team_Member__c>  teamList=new  List<EA_Team_Member__c>();
      
         teamList = [SELECT Id, Invited_By__c, Participant__c FROM EA_Team_Member__c WHERE Id =: teamid];
           //if(teamList.size()>0){
            system.debug('=============='+teamList);
       if(String.isNotBlank(activityId) && String.isNotBlank(teamList[0].Invited_By__c) && String.isNotBlank( teamList[0].Participant__c)){
       
        
          
          
            
            Everyday_Activity__c actObj = EA_Utils.getActivitydetails(activityId);
            String actName=actObj.name;
            system.debug('=============='+actName);
                        List<User> userList = [SELECT id, Name FROM User Where id =: userinfo.getUserID()];
            
           // if(actObj != null) actName = actObj.Name;
          //  if(userList.size()>0 && userList != null) participantName = userList[0].Name;
                      String participantName=userList[0].name;
                      system.debug('================='+participantName);
           string msgLabel=responseText ;
           system.debug('================='+responseText );
            if(responseText == EA_Constants.INVITATION_STATUS_ACCEPTED) msgLabel = Label.EA_Activity_Accepted;      
            if(responseText == EA_Constants.INVITATION_STATUS_DECLINED) msgLabel = Label.EA_Activity_Declined ;
            
            if(String.isNotBlank(actName) && String.isNotBlank(participantName)&& String.isNotBlank(msgLabel)){
                
                EA_Utils.postCommentAtUserFeed(activityId,teamList[0].Invited_By__c, teamList[0].Participant__c, participantName + msgLabel + actName);
                updateParticipantResponse(activityId, teamList[0].Participant__c, responseText);
       //  }
            }
        }
    }
    
    /* Invite multiple users through chatter feed to do an Activity */ 
    
   /* @AuraEnabled
    public static void inviteUsersToDoActivity(string activityId, List<String> userIds){
        
        if(userIds.size()>0 && userIds != null && String.isNotBlank(activityId)){
            
            for(String userId : userIds){
                inviteUserToDoActivity(activityId, userId);
            }
        }
        
    }
    
    /* Invite single user through chatter feed to do an Activity */
    
    /*@AuraEnabled
    public static void inviteUserToDoActivity(string activityId, string userId){
        
        if(String.isNotBlank(activityId) && String.isNotBlank(userId)){
            //EA_Utils.postCommentAtUserFeed(activityId, userId, Label.EA_Invite_Message + 'http://www.google.com'); // Sample hyper link to Accept/Decline pop up
            
        }
    } 
    */
    
   /* Submit Invitation Response */ 
    
  @AuraEnabled
  
   public static void updateParticipantResponse(string activityId, string participantId, string responseText){
             system.debug('========'+participantId);
    system.debug('========'+responseText);     
     system.debug('========'+activityId);   
        EA_Team_Member__c partcipantTeamMeberRec = EA_Utils.getParticipantTeamMemberRec(activityId, participantId);
                      
        if(partcipantTeamMeberRec != null){
            
            if(responseText == EA_Constants.INVITATION_STATUS_ACCEPTED) partcipantTeamMeberRec.Invitation_Status__c = EA_Constants.INVITATION_STATUS_ACCEPTED; 
             // partcipantTeamMeberRec.Everyday_Activity__r.Activity_Points__c=+partcipantTeamMeberRec.Activity_Points__c;
           //  }    
            if(responseText == EA_Constants.INVITATION_STATUS_DECLINED) partcipantTeamMeberRec.Invitation_Status__c = EA_Constants.INVITATION_STATUS_DECLINED;
            
            update partcipantTeamMeberRec;
        }      
      
    }  
    
    /* This method sends feedback reminder for an Activity to participant user*/
    
    @AuraEnabled
    public static void sendFeedbackReminder(string activityId,string inviteeId ,string participantId){
    
        EA_Utils.postCommentAtUserFeed(activityId,inviteeId , participantId, Label.EA_Feedback_Reminder + 'Activity URL'); // hyper link to Feedback pop up
    }
    @AuraEnabled
    public static List<EA_Wrapper_Class.EA_UserProfile_Wrapper> getuserimage(String activityId, string teamid){
    system.debug('========'+teamid);
    system.debug('========'+activityId);
        EA_Team_Member__c objMember=new EA_Team_Member__c ();
        objMember=[SELECT Id,Invited_By__c,Participant__c FROM EA_Team_Member__c where id=:teamid];
         
        
        List<EA_Wrapper_Class.EA_UserProfile_Wrapper> userprofileList=new List<EA_Wrapper_Class.EA_UserProfile_Wrapper>();
        Everyday_Activity__c objActivity = [SELECT Id,Name, RecordType.Name, Rating__c  FROM Everyday_Activity__c Where  Active__c =true AND id =: activityId ];
        User objUser1=[select name,smallphotourl from User where id=:objMember.Invited_By__c AND isactive=true];
       
        EA_Wrapper_Class.EA_UserProfile_Wrapper objUser=new  EA_Wrapper_Class.EA_UserProfile_Wrapper();
        objUser.userPhotoUrl=objUser1.smallphotourl;
        objUser.userName=objUser1.name;
        objUser.Eaname=objActivity.Name;
        objUser.EaRecordtype=objActivity.RecordType.Name;
        objUser.participant_rating=objActivity.Rating__c;
       
        userprofileList.add(objUser);
        
       return userprofileList;
      
     }
     
   }