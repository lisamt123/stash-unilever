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
        try{
        EA_Team_Member__c teamList = [SELECT Id, Everyday_Activity__c,Invited_By__c, Participant__c FROM EA_Team_Member__c WHERE Id=:teamid];
      //  if(teamList.Invited_By__c <>null){     
          //  if(String.isNotBlank(activityId) && String.isNotBlank(teamList.Invited_By__c) && String.isNotBlank( teamList.Participant__c)){
              Everyday_Activity__c actObj = EA_Utils.getActivitydetails(activityId);
              String actName=actObj.name;
               // String actName=teamList.Everyday_Activity__c;
                List<User> userList = [SELECT id, Name FROM User Where id =: userinfo.getUserID()];                                
                String participantName=userList[0].name;
               // string msgLabel=responseText ;
                string msgLabel='';
                
                if(responseText == EA_Constants.INVITATION_STATUS_ACCEPTED){
                     msgLabel += 'Your invitation to do ';
                     msgLabel +='"'+actName+'" ';
                     msgLabel += ' activity has been accepted by ';                     
                     msgLabel += participantName;
                     msgLabel += '.';
                     
                }      
                if(responseText == EA_Constants.INVITATION_STATUS_DECLINED){
                     msgLabel += 'Your invitation to do ';
                     msgLabel +='"'+actName+'" ';
                     msgLabel += ' activity has been declined by ';                    
                     msgLabel += participantName;
                     msgLabel += '.';
                }

								
                if(String.isNotBlank(actName) && String.isNotBlank(participantName)&& String.isNotBlank(msgLabel)){               
                    EA_Utils.postOnChatter(teamList.Invited_By__c, msgLabel);
                    updateParticipantResponse(activityId, teamList.Participant__c, responseText);
               // }
           // }
            }
        }catch(exception e){System.debug('Exception caught: ' + e.getMessage());}
    }
    
    /* Submit Invitation Response */ 
    @AuraEnabled
    public static void updateParticipantResponse(string activityId, string participantId, string responseText){ 
        String actvityName = '';
        String activityDesc = '';
        Decimal points = 0; 
        List<Everyday_Activity__c> acts=new List<Everyday_Activity__c>();
        
        acts= [SELECT Name, Rating__c, Participants_Required__c,
               Minutes_to_Complete_Action__c,Top_Tip__c, RecordType.Name,
               Description__c,Activity_Points__c  FROM Everyday_Activity__c 
               where id=:activityId];
        
        for(Everyday_Activity__c act : acts){
            actvityName = act.Name;
            activityDesc = act.Description__c;
            points = act.Activity_Points__c;
        } 
                     
        EA_Team_Member__c partcipantTeamMeberRec = EA_Utils.getParticipantTeamMemberRec(activityId, participantId);                      
        if(partcipantTeamMeberRec != null){           
            if(responseText == EA_Constants.INVITATION_STATUS_ACCEPTED) {
                partcipantTeamMeberRec.Invitation_Status__c = EA_Constants.INVITATION_STATUS_ACCEPTED; 
                partcipantTeamMeberRec.Activity_Points__c = points ;
            }
            else if(responseText == EA_Constants.INVITATION_STATUS_DECLINED) partcipantTeamMeberRec.Invitation_Status__c = EA_Constants.INVITATION_STATUS_DECLINED;          
            update partcipantTeamMeberRec;
        }      
    }  
    @AuraEnabled
    public static void sendFeedbackReminder(string activityId,string inviteeId ,string participantId){   
        EA_Utils.postCommentAtUserFeed(activityId,inviteeId , participantId, Label.EA_Feedback_Reminder + 'Activity URL'); // hyper link to Feedback pop up
    }
    @AuraEnabled
    public static List<EA_Wrapper_Class.EA_UserProfile_Wrapper> getuserimage(String activityId, string teamid){
        EA_Team_Member__c objMember=new EA_Team_Member__c ();
        objMember=[SELECT Id,Invited_By__c,Participant__c FROM EA_Team_Member__c  where id=:teamid];
        List<EA_Wrapper_Class.EA_UserProfile_Wrapper> userprofileList=new List<EA_Wrapper_Class.EA_UserProfile_Wrapper>();
        Everyday_Activity__c objActivity = [SELECT Id,Name, RecordType.Name, Rating__c  FROM Everyday_Activity__c Where  Active__c =true  AND id =: activityId ];
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