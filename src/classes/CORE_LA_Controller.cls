/***************************************************************
Class Name: CORE_LA_CONTROLLER
Copyright © 2017 Salesforce

Purpose:
Requirement/Project Name: EVENTS APPLICATION
Requirement/Description: Controller class For EVENTS APPLICATION.

History:
VERSION     AUTHOR         DATE              DETAIL Description
1.0         Mindtree       11/01/2017        Controller class For EVENTS APPLICATION
***************************************************************/

public with sharing class CORE_LA_Controller{
    
    
    
//Display Trainer List Based On Event Used in Event Detail Page , Trainer & Attendee List Page,Trainer Detail Page 
   @AuraEnabled
    public static List<CORE_LA_EventWrapperClass.TrainerWrapper> getTrainerWrapper(String eventId){
       
        return Core_LA_ControllerHelper.getTrainerWrapperDetails(eventId);
    }
    
 //Event Card Controller use in Profile Page,Upcoming Page ,Trainer Detail Page, Create Page both 'posted' and 'Draft' Section.
   @AuraEnabled
    public static List<CORE_LA_EventWrapperClass.Event> retriveAllEvents(String filterType,String sortType,Integer limitRecords,Integer offsetValue,String trainerId,String eventStatus,Boolean showMoreStatus,String externalEmail,Boolean commonActionBarHide){
      
        return Core_LA_ControllerHelper.retriveEvents(filterType,sortType,limitRecords,offsetValue,trainerId,eventStatus,showMoreStatus,externalEmail,commonActionBarHide);
    }

//Display Logged in User Details
    @AuraEnabled
    public static User  getLoggedInUser() {

      User toReturn = [SELECT Id,MediumPhotoUrl,Name,Title,State,Country,MobilePhone,Email,
                      AboutMe FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        return toReturn;
    }
    
//Trainer Details fetched on Trainer Detail Page
    @AuraEnabled
    public static User  getTrainerDetails(String trainerId) {

      User toReturn = [SELECT Id,MediumPhotoUrl,Name,Title,State,Country,MobilePhone,Email,
                       AboutMe FROM User WHERE Id = :trainerId LIMIT 1];
        return toReturn;
    }
 // Related to  Upcoming occurence
         @AuraEnabled 
          public static List<CORE_LA_Participant__c > getOccurenceList(String eventId){
          String loggedInUserId= UserInfo.getUserId();
           Date currentDate= date.today();
         return [ SELECT Event__r.Name,Event__r.From_Date__c,Event__r.To_Date__c FROM CORE_LA_Participant__c  WHERE Event__r.ParentEvent__c = :eventId AND Participant_Name__c = :loggedInUserId AND Event__r.To_Date__c >= :currentDate];
       
    }
 // Related to  Past occurence
          @AuraEnabled 
          public static List<CORE_LA_Participant__c > getPastOccurenceList(String eventId){
           Date currentDatePast= date.today();
           String loggedInUserId= UserInfo.getUserId();
           Date currentDate= date.today();
         return [ SELECT Event__r.Name,Event__r.From_Date__c,Event__r.To_Date__c FROM CORE_LA_Participant__c  WHERE Event__r.ParentEvent__c = :eventId AND Participant_Name__c = :loggedInUserId AND Event__r.To_Date__c < :currentDatePast];
         }
    
 //Display Attendee List Based On Event 
    @AuraEnabled 
    public static List<CORE_LA_Participant__c> getAttendeList(String eventId,Integer limitRecords, Integer OffsetLimit){
        Integer recordLimit= integer.valueof(limitRecords);
        Integer  recordOffsetLimit=integer.valueof(OffsetLimit);
  
    return [ SELECT Participant_Name__c,Participant_Name__r.SmallPhotoUrl,Participant_Name__r.Name,Participant_Name__r.Title,Rating__c,
            Feedback__c,Status__c FROM CORE_LA_Participant__c WHERE Event__c =:eventId AND Role__c = 'Attendee' ORDER BY Participant_Name__r.Name
            LIMIT :recordLimit  OFFSET :recordOffsetLimit ]; 
       
    }
    
 /*   @AuraEnabled 
    public static List<CORE_LA_Participant__c> getExternalTrainerDetails(String email){
     return [ SELECT ExternalTrainerContact__c,ExternalTrainerEmail__c,ExternalTrainerLocation__c,ExternalTrainerName__c,
            ExternalTrainerImage__c,ExternalTrainerTitle__c FROM CORE_LA_Participant__c 
            WHERE ExternalTrainerEmail__c =:email AND Role__c = 'Trainer'];  
        
    }*/
    
    /************************************************/
        
    // related to event detail page
    @AuraEnabled
    public static List<CORE_LA_EventWrapperClass.Event> getEventDetail(String eventId){
    Datetime todaysDate = System.now();
    String loggedInUserId= UserInfo.getUserId();
     List<CORE_LA_Participant__c > eventData= [SELECT Event__c,Event__r.Name,Event__r.No_of_Attendees__c,Event__r.Total_Rating__c,Event__r.Recurring__c,Event__r.Banner__c,Event__r.From_Date__c,Event__r.To_Date__c,Event__r.Location__c,Event__r.Prerequisite__c,Event__r.Agenda__c,Event__r.Details__c,Event__r.Recurring_Details__c,Event__r.Faclities__c,Id,Participant_Name__r.Name,Role__c,Status__c ,Rating__c,Participant_Name__c FROM CORE_LA_Participant__c WHERE Event__c=:eventId AND Participant_Name__c = :loggedInUserId];
      List<CORE_LA_EventWrapperClass.Event> eventList = new List<CORE_LA_EventWrapperClass.Event>();
       for (CORE_LA_Participant__c participant : eventData){
        CORE_LA_EventWrapperClass.Event eventDetails= new CORE_LA_EventWrapperClass.Event();
            eventDetails.eventId=participant.Event__c;
            eventDetails.IdofParticicpant=participant.Id;
            eventDetails.ParticipantName=participant.Participant_Name__r.Name;
            eventDetails.eventName=participant.Event__r.Name;
            eventDetails.numberOfAttendees= participant.Event__r.No_of_Attendees__c; 
            eventDetails.recurring= participant.Event__r.Recurring__c;
            eventDetails.fromDate=participant.Event__r.From_Date__c;
            eventDetails.toDate=participant.Event__r.To_Date__c;
            eventDetails.location=participant.Event__r.Location__c;
           // eventDetails.userRole=participant.Role__c;
            eventDetails.userRegistrationStatus=participant.Status__c;
            //eventDetails.eventRating=participant.Rating__c;
            eventDetails.prerequisite=participant.Event__r.Prerequisite__c;
            eventDetails.agenda=participant.Event__r.Agenda__c;
            eventDetails.details=participant.Event__r.Details__c;
            eventDetails.recurringDetails=participant.Event__r.Recurring_Details__c;
            eventDetails.facilities=participant.Event__r.Faclities__c;
            //Datetime endDate =participant.Event__r.To_Date__c;
             Datetime endDate =participant.Event__r.To_Date__c;
            //Checking if event should be designated  Completed.
            if(todaysDate > endDate ){ 
                //designated  Completed
            eventDetails.userEventStatus=True;
              }
            else{
                eventDetails.userEventStatus=False;
            }
            
            //eventDetails.totalRatingPerEvent= participant.Event__r.Total_Rating__c;
                 eventList.add(eventDetails);
                 
                 List<Attachment> lstAttachment=[SELECT Id FROM Attachment where parentId=:eventId];
             
                // Id attachid;
                 //attachid=lstAttachment[0].Id;
                 //if(attachid!=null){
                 String imageURL ='/servlet/servlet.FileDownload?file=';
             
                 String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm() + imageURL + '00PV0000001mJtO';
                  eventDetails.contentURLBannerImage=fullFileURL;
                  //}
                  
      }
      System.debug('Event  with details======>'+eventList);
      
        return eventList ;
    }
//Related to Agenda List of particular Event
            @AuraEnabled 
          public static List<CORE_LA_Agenda__c> getAgendaList(String eventId){
           Date currentDate= date.today();
         return [SELECT Name,From_Time__c,To_Time__c,Summary__c FROM CORE_LA_Agenda__c WHERE Event__c =:eventId ORDER BY createdDate ASC];
         }
//Admin Add Attendee ,Admin
   @AuraEnabled
     public static CORE_LA_EventWrapperClass.TrainerWrapper getParticipantListWrapper(String eventId, List<User> participantList,String Role, String Status){
         CORE_LA_EventWrapperClass.TrainerWrapper eventDetails= new CORE_LA_EventWrapperClass.TrainerWrapper();
         system.debug('List'+participantList);
         
         If(participantList.size()!=0){
           for(User u:participantList){  
               CORE_LA_Participant__c ParticipantObj= new CORE_LA_Participant__c();
               ParticipantObj.Role__c=Role;
               ParticipantObj.Event__c= eventId;
               ParticipantObj.Status__c=Status;
               ParticipantObj.Participant_Name__c=u.Id;
               insert ParticipantObj; 
           }
         }      
         return eventDetails;
     }
    //*******************************************//
    /**
     * Aura enabled method to search a specified SObject for a specific string
     */
    @AuraEnabled
    public static Result[] lookup(String searchString, String sObjectAPIName, String recordType)
    {
        // Sanitize the input
        String sanitizedSearchString = String.escapeSingleQuotes(searchString);
        String sanitizedSObjectAPIName = String.escapeSingleQuotes(sObjectAPIName);
        String sanitizedSObjectFieldName = String.escapeSingleQuotes(recordType);
        
        String searchQuery='';
        List<Result> results = new List<Result>();
     
         // Build our SOSL query
        if(sanitizedSObjectFieldName == 'null' )
        {
            searchQuery = 'FIND \'' + sanitizedSearchString + '*\' IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name) Limit 10 '; 
        }
        else {
             searchQuery = 'FIND \'' + sanitizedSearchString + '*\' IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name where RecordType.Name=\''+ sanitizedSObjectFieldName +'\') Limit 10'; 
        }
       
        // Execute the Query
        List<List<SObject>> searchList = search.query(searchQuery);
 
        // Create a list of matches to return
        for (SObject so : searchList[0])
        {
            results.add(new Result((String)so.get('Name'), so.Id));
        }
         
        return results;
    }
     
    /**
     * Inner class to wrap up an SObject Label and its Id
     */
    public class Result
    {
        @AuraEnabled public String SObjectLabel {get; set;}
        @AuraEnabled public Id SObjectId {get; set;}
         
        public Result(String sObjectLabel, Id sObjectId)
        {
            this.SObjectLabel = sObjectLabel;
            this.SObjectId = sObjectId;
        }
    }

// Related to Save Faculty Detail
   @AuraEnabled
   public static void saveTrainerDetail(String role,String EventId,String externalName,String externalTitle,String externalContact,String externalEmail,String externalProfile) {
    
    try{
    CORE_LA_Participant__c  trainerDetail= new CORE_LA_Participant__c ();
    System.debug('save data @@@@@@'+ trainerDetail.Event__c );
    trainerDetail.Event__c=EventId;
    trainerDetail.ExternalTrainerName__c=externalName;
    trainerDetail.ExternalTrainerContact__c=externalContact;
    trainerDetail.ExternalTrainerEmail__c=externalEmail;
    trainerDetail.ExternalTrainerProfile__c=externalProfile;
    trainerDetail.ExternalTrainerTitle__c=externalTitle;
    trainerDetail.Role__c=role;
                  
    insert trainerDetail;
    }
    catch(exception e){}
    //return trainerDetail;
    
}
    
    
}