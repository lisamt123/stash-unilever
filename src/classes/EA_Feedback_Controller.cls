/*
Class Name: EA_Feedback_Controller.cls
Author : Mindtree
Date: 20th Nov 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Everyday action app Controller class for handling all feedback events.
*/
public with sharing class EA_Feedback_Controller {
    @AuraEnabled
    public static List<Everyday_Activity__c> getactivitydetail(String ActivityID){
        List<Everyday_Activity__c> actvList = new List<Everyday_Activity__c>();
        //if(ActivityID!=null){
            actvList = [SELECT Id,Name, RecordType.Name, Rating__c,Top_Tip__c, Description__c,Activity_Points__c,(SELECT Activity_Points__c,Everyday_Activity__c,Participant__c FROM Team_Members__r), Minutes_to_Complete_Action__c,Participants_Required__c FROM Everyday_Activity__c Where  Active__c =true AND id =: ActivityID ];
      //  }
        return actvList;
    } 
    /* This method is used to submit the feedback */
    @AuraEnabled
    public static boolean submitFeedback(string activityId,  string feedbackText, integer rating,string teamId){   
        string participantId=userinfo.getuserid();
      /*  boolean strId=EA_Utils.isEmpty(activityId);
      //  boolean strText=EA_Utils.isEmpty(feedbackText);
        boolean strteamId=EA_Utils.isEmpty(teamId);*/
        // Update Team Member Record with Rating
        integer activity_rating=integer.valueOf(rating );
        if( activity_rating>0){
            EA_Team_Member__c objMember=[Select Id,Rating_By_Participant__c from EA_Team_Member__c where id=:teamId];
            objMember.Rating_By_Participant__c=integer.ValueOf(rating);
            update objMember;
          //  updateActivityRating(activityId);
           // system.debug('&&&'+objMember.Rating_By_Participant__c);
        }  
        EA_Utils.postOnChatter(activityId,feedbackText);          
        updateActivityRating(activityId);
        return true;    
    }    
    /* This method is used update feedback rating for an Activity */    
    // @AuraEnabled
    public static void submitRating(string activityId, string participantId, integer rating){        
        //if((activityId !=NUll) && (participantId !=NULL) && (rating !=null && rating>0)){            
        EA_Team_Member__c partcipantTeamMeberRec = new EA_Team_Member__c();                             
        partcipantTeamMeberRec = EA_Utils.getParticipantTeamMemberRec(activityId, participantId);                                    
        partcipantTeamMeberRec.Rating_By_Participant__c = integer.valueof(rating);                   
        update partcipantTeamMeberRec;
        updateActivityRating(activityId); // Update parent Activity overall rating             
    }   
    /* This method is used to update Activity rating based on it's associate Team Member records ratings*/   
    @AuraEnabled
    public static void updateActivityRating(string activityId){   
        decimal ratingsTotal = 0;
        integer ratedRecs = 0; 
        decimal avgRating =  0;
        integer finalRating = 0; 
      //  if(String.isNotBlank(activityId)){           
            List<EA_Team_Member__c> tmList = EA_Utils.getTeamMebersForActivity(activityId);           
           // if(tmList != null && tmList.size()>0){               
                for(EA_Team_Member__c etmObj : tmList){                   
                    if(etmObj.Rating_By_Participant__c != null && etmObj.Rating_By_Participant__c >0){                       
                        ratedRecs = ratedRecs+1;                      
                        ratingsTotal= ratingsTotal+ etmObj.Rating_By_Participant__c;
                    }                  
                }               
                if(ratingsTotal >0 && ratedRecs >0){                
                    Everyday_Activity__c eaObj = EA_Utils.getActivitydetails(activityId);                   
                   // if(eaObj != null){                       
                        avgRating = ratingsTotal/ratedRecs;                      
                        finalRating = EA_Utils.getactivityRating(avgRating);                       
                        if(eaObj.Rating__c != finalRating){                           
                            eaObj.Rating__c = finalRating;                           
                            update eaObj;
                      //  }
                   // }
               // }
            }                       
        }        
    }
    @AuraEnabled
    public static List<Everyday_Activity__c> provideRating(String ActivityID,integer rating){
        Everyday_Activity__c objActivity= new  Everyday_Activity__c();
        List<Everyday_Activity__c> activtyList=new List<Everyday_Activity__c>();
        objActivity.Rating__c=integer.valueof(rating);
        activtyList.add(objActivity);
        return activtyList;
    }      
       
}