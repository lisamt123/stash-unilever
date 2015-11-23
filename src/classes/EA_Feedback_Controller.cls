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
        if(ActivityID!=null){
            actvList = [SELECT Id,Name, RecordType.Name, Rating__c,Top_Tip__c, Description__c,Activity_Points__c,(SELECT Activity_Points__c,Everyday_Activity__c,Participant__c FROM Team_Members__r), Minutes_to_Complete_Action__c,Participants_Required__c FROM Everyday_Activity__c Where  Active__c =true AND id =: ActivityID ];
        }
        return actvList;
    } 
    

    /* This method is used to submit the feedback */
    
    @AuraEnabled
    public static boolean submitFeedback(string activityId,  string feedbackText, integer rating){
    
    //share feedback on Activity Chatter Feed
    //system.debug('@@@'+participantId);
    string participantId=userinfo.getuserid();
     system.debug('@@@'+feedbackText);
      system.debug('@@@'+rating);
      system.debug('@@@'+activityId);
      
        //FeedItem post = new FeedItem();
       // post.ParentId =  'a6kc0000000068E'; //Activity ID..
        //post.Body = 'commented';
        //insert post;
    
        //if(String.isNotBlank(activityId) && feedbackText != null){
           // Id activity = Id.valueOf(activityId);
           // EA_Utils.postCommentAtUserFeed(activityId,participantId,feedbackText);
     
          // FeedItem chatterPost = new FeedItem(ParentId = activity , Body = feedbackText);
       
            //insert chatterPost;
    
        //}   
    
    // Update Team Member Record with Rating
    
    // if((activityId  !=' ') && (participantId!=' ') && (rating !=null && rating>0)){
           system.debug('$$'+participantId);
        
            submitRating(activityId, participantId, rating);
  // } 
       return true;
    
    }
    
    /* This method is used update feedback rating for an Activity */
    
   // @AuraEnabled
    public static void submitRating(string activityId, string participantId, integer rating){
        
        
       //if((activityId !=NUll) && (participantId !=NULL) && (rating !=null && rating>0)){
            
            EA_Team_Member__c partcipantTeamMeberRec = new EA_Team_Member__c();     
                        
            partcipantTeamMeberRec = EA_Utils.getParticipantTeamMemberRec(activityId, participantId);
            
            system.debug('!!!!'+partcipantTeamMeberRec.Id);
            
            if(partcipantTeamMeberRec != null){
            
                if(partcipantTeamMeberRec.Rating_By_Participant__c == 0 ){
                
                    partcipantTeamMeberRec.Rating_By_Participant__c = rating;
                    
                    update partcipantTeamMeberRec;
                    
                    updateActivityRating(activityId); // Update parent Activity overall rating
               //}           
                
            }       
            
         }  
    }
    
    /* This method is used to update Activity rating based on it's associate Team Member records ratings*/
    
    @AuraEnabled
    public static void updateActivityRating(string activityId){
    
        decimal ratingsTotal = 0;
        integer ratedRecs = 0; 
        decimal avgRating =  0;
        integer finalRating = 0; 
        system.debug(activityId);
        if(String.isNotBlank(activityId)){
            
            List<EA_Team_Member__c> tmList = EA_Utils.getTeamMebersForActivity(activityId);
            
            if(tmList != null && tmList.size()>0){
                
                for(EA_Team_Member__c etmObj : tmList){
                    
                    if(etmObj.Rating_By_Participant__c != null && etmObj.Rating_By_Participant__c >0){
                        
                        ratedRecs = ratedRecs+1;
                        
                        ratingsTotal= ratingsTotal+ etmObj.Rating_By_Participant__c;
                    }
                    
                }
                
                if(ratingsTotal >0 && ratedRecs >0){
                
                    Everyday_Activity__c eaObj = EA_Utils.getActivitydetails(activityId);
                    
                    if(eaObj != null){
                        
                        avgRating = ratingsTotal/ratedRecs;
                        
                        finalRating = EA_Utils.getactivityRating(avgRating);
                        
                        if(eaObj.Rating__c != finalRating){
                            
                            eaObj.Rating__c = finalRating;
                            
                            update eaObj;
                        }
                    }
                }
            }           
            
        }
        
    }
    
       
}