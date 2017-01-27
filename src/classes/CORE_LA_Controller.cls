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
    
 //Display Attendee List Based On Event 
    @AuraEnabled 
    public static List<CORE_LA_Participant__c> getAttendeList(String eventId,Integer limitRecords, Integer OffsetLimit){
        Integer recordLimit= integer.valueof(limitRecords);
        Integer  recordOffsetLimit=integer.valueof(OffsetLimit);
  
    return [ SELECT Participant_Name__c,Participant_Name__r.SmallPhotoUrl,Participant_Name__r.Name,Participant_Name__r.Title
            FROM CORE_LA_Participant__c WHERE Event__c =:eventId AND Role__c = 'Attendee' ORDER BY Participant_Name__r.Name
            LIMIT :recordLimit  OFFSET :recordOffsetLimit ]; 
       
    }
    
 /*   @AuraEnabled 
    public static List<CORE_LA_Participant__c> getExternalTrainerDetails(String email){
     return [ SELECT ExternalTrainerContact__c,ExternalTrainerEmail__c,ExternalTrainerLocation__c,ExternalTrainerName__c,
            ExternalTrainerImage__c,ExternalTrainerTitle__c FROM CORE_LA_Participant__c 
            WHERE ExternalTrainerEmail__c =:email AND Role__c = 'Trainer'];  
        
    }*/
    
     
 //Display Trainer List Based On Event Used in Event Detail Page , Trainer & Attendee List Page,Trainer Detail Page 
   @AuraEnabled
    public static List<CORE_LA_EventWrapperClass.TrainerWrapper> getTrainerWrapper(String eventId){
       
        return Core_LA_ControllerHelper.getTrainerWrapperDetails(eventId);
    }

    
    
    /************************************************/
        
    
    @AuraEnabled
    public static List<CORE_LA_EventWrapperClass.Event> getEventDetail(String eventId){
    //String loggedInUserId= UserInfo.getUserId();
      List<CORE_LA_Event__c > eventData= [SELECT ID,Name,Agenda__c,Banner__c,Details__c,Faclities__c,From_Date__c,Language__c,Location__c,No_of_Attendees__c,Prerequisite__c,Recurring_Details__c,Recurring__c,Short_Description__c,To_Date__c FROM CORE_LA_Event__c Where Id=:eventId ];
      List<CORE_LA_EventWrapperClass.Event> eventList = new List<CORE_LA_EventWrapperClass.Event>();
      for (CORE_LA_Event__c event: eventData){
        CORE_LA_EventWrapperClass.Event eventDetails= new CORE_LA_EventWrapperClass.Event();
           
                  eventDetails.eventId= event.id;
                  eventDetails.eventName=event.Name;
                  
                  eventDetails.recurring= event.Recurring__c;
                 // eventDetails.contentURLBannerImage=event.Banner__c;
                  //eventDetails.shortDescription=event.Short_Description__c;
                  eventDetails.fromDate=event.From_Date__c;
                  eventDetails.toDate=event.To_Date__c;
                  eventDetails.location=event.Location__c;
                  eventDetails.prerequisite=event.Prerequisite__c;
                  eventDetails.agenda=event.Agenda__c;
                  eventDetails.details=event.Details__c;
                  eventDetails.recurringDetails=event.Recurring_Details__c;
                  eventDetails.facilities=event.Faclities__c;
                 eventList.add(eventDetails);
                 
                 List<Attachment> lstAttachment=[SELECT Id FROM Attachment where parentId=:eventId];
             
                // Id attachid;
                 //attachid=lstAttachment[0].Id;
                 //if(attachid!=null){
                 String imageURL ='/servlet/servlet.FileDownload?file=';
             
                 String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm() + imageURL + '00PV0000001Qvto';
                  eventDetails.contentURLBannerImage=fullFileURL;
                  //}
                  
      }
      System.debug('Event  with details======>'+eventList);
      
        return eventList ;
    }

}