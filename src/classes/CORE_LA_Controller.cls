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
 //[eventId] parameter is Used to display list of trainers for an event and External Trainer Details .The name of paramenter should not be confused. 
       List<Document> lstDocument=[SELECT Id FROM Document where Name=:'DefaultExternalImage'];
  //Id of Default External Image in Document Object
        Id attachid;
        String registeredClause=' AND Role__c =\''+'Trainer'+'\'';
        String paramTrainerList =  'Event__c =:eventId ';
        String paramExternaltrainerList = 'ExternalTrainerEmail__c =:eventId ';
       // String paramTrainerDetail='Id = :eventId ';
        String soqlQuery='SELECT Participant_Name__c,Participant_Name__r.SmallPhotoUrl,Participant_Name__r.Name,Participant_Name__r.Title,ExternalTrainerContact__c,ExternalTrainerEmail__c,ExternalTrainerLocation__c,ExternalTrainerName__c,ExternalTrainerImage__c,ExternalTrainerTitle__c FROM CORE_LA_Participant__c WHERE ';
	if(eventId.contains('@')){
	         soqlQuery+=paramExternaltrainerList+registeredClause;//for External Trainer
	    }
	else {
	        soqlQuery+=paramTrainerList+registeredClause;//For Internal Trainers
	    }
	   List<CORE_LA_Participant__c > trainerData = database.query(soqlquery);	  
  //Final List to be Populated and Returned
      List<CORE_LA_EventWrapperClass.TrainerWrapper> trainerListToReturn = new List<CORE_LA_EventWrapperClass.TrainerWrapper>();
      for (CORE_LA_Participant__c event: trainerData){
        CORE_LA_EventWrapperClass.TrainerWrapper trainerDetails= new CORE_LA_EventWrapperClass.TrainerWrapper();
    //Internal Trainer Details
                  trainerDetails.Participant_Id= event.Participant_Name__c;
                  trainerDetails.Participant_SmallPhotoUrl=event.Participant_Name__r.SmallPhotoUrl; 
                  trainerDetails.Participant_Name= event.Participant_Name__r.Name;
                  trainerDetails.Participant_Title=event.Participant_Name__r.Title;
    //External Trainer Details and checking for Null pointer Exception via If Block and mandatory fields to be filled
      if(event.ExternalTrainerName__c!=null && event.ExternalTrainerEmail__c!=null ){
                  trainerDetails.ExternalTitle=event.ExternalTrainerTitle__c;
                  trainerDetails.ExternalName=event.ExternalTrainerName__c;
                  trainerDetails.ExternalLocation=event.ExternalTrainerLocation__c;
                  trainerDetails.ExternalEmail=event.ExternalTrainerEmail__c;
                  trainerDetails.ExternalContact=event.ExternalTrainerContact__c;
    //Extracting SRC for use in Image Tag out of Rich Text field 
                  if(event.ExternalTrainerImage__c!=null ){
                          String externalTraineImageUrl=event.ExternalTrainerImage__c; 
                            externalTraineImageUrl=externalTraineImageUrl.substringBetween('src="','"');
                            trainerDetails.ExternalImage=  externalTraineImageUrl.remove('amp;');
                  } else{
                      //DefaultExternalImage ID
                            attachid=lstDocument[0].Id;
                            String imageURL ='/servlet/servlet.FileDownload?file=';
                            String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm() + imageURL + attachid;
                            trainerDetails.ExternalImage=fullFileURL;    
                  }   
              }
    //add all the details to final list of the type CORE_LA_EventWrapperClass.TrainerWrapper which to be returned.
                  trainerListToReturn.add(trainerDetails);  
                  
            }   
        return trainerListToReturn ;
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