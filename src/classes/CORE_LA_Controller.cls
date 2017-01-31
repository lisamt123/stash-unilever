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
    @AuraEnabled
    public static List<CORE_LA_EventWrapperClass.Event> getOccurenceDetail(String eventId){
     List<CORE_LA_Event__c > occurenceData= [SELECT ID,Name,Banner__c,Details__c,From_Date__c,Recurring_Details__c,Recurring__c,Short_Description__c,To_Date__c FROM CORE_LA_Event__c Where Id=:eventId ];
     List<CORE_LA_EventWrapperClass.Event> occurenceList = new List<CORE_LA_EventWrapperClass.Event>();
      for (CORE_LA_Event__c occurence: occurenceData){
        CORE_LA_EventWrapperClass.Event occurenceDetail= new CORE_LA_EventWrapperClass.Event();
                  occurenceDetail.eventId= occurence.id;
                  occurenceDetail.eventName=occurence.Name;
                  
                  occurenceDetail.recurring= occurence.Recurring__c;
                 // eventDetails.contentURLBannerImage=event.Banner__c;
                  
                  occurenceDetail.fromDate=occurence.From_Date__c;
                  occurenceDetail.toDate=occurence.To_Date__c;

                 
                
                  occurenceDetail.details=occurence.Details__c;
                  occurenceDetail.recurringDetails=occurence.Recurring_Details__c;
                  
                 occurenceList.add(occurenceDetail);
    
    
    }
    return occurenceList ;

}
    //Bharath Code
@AuraEnabled
    public static List<CORE_LA_EventWrapperClass.Event> retriveAllEvents(String filterType,String sortType,Integer limitRecords,Integer offsetValue,String trainerId,String eventStatus,Boolean showMoreStatus,String externalEmail,Boolean commonActionBarHide){
        //String loggedInUserId= UserInfo.getUserId();
        //'AND CreatedById =\''+UserInfo.getUserId()+'\''
        String registeredClause=' AND Status__c =\''+'Registered'+'\'';
        String savedClause=' AND Status__c = \''+'Saved'+'\'';
        String recurringClause=' AND Event__r.Recurring__c= true';
        String nonRecurringClause= 'AND Event__r.Recurring__c= false';
        String dateSortClause=' ORDER BY  Event__r.From_Date__c ASC';
        String nameSortClause=' ORDER BY Event__r.Name ASC';
        String paginationQuery=' LIMIT '+limitRecords+' OFFSET '+offsetValue;
        Id loggedInUserId= UserInfo.getUserId();
        System.debug('LoggedInUserId===> '+loggedInUserId);
        String loggedInUser='Participant_Name__c =\''+loggedInUserId+'\'';
        String eventStatusCheck=' AND Event__r.Status__c=\''+eventStatus+'\'';
        String roleClause=' AND Role__c = \''+'Admin'+'\''; 
        String trainerClause=' AND Role__c = \''+'Trainer'+'\''; 
        String externaltrainerAsUser='ExternalTrainerEmail__c=\''+externalEmail+'\'';
        System.debug('Participant_Name__c===> '+loggedInUser);
        String trainerAsUser='Participant_Name__c=\''+trainerId+'\'';
        String soqlQuery='SELECT Event__c,Event__r.OwnerId,Event__r.Name,Event__r.No_of_Attendees__c,Event__r.Recurring__c,Event__r.Banner__c,Event__r.Short_Description__c,Event__r.From_Date__c,Event__r.To_Date__c,Event__r.Location__c,Event__r.Prerequisite__c,Event__r.Agenda__c,Event__r.Details__c,Event__r.Recurring_Details__c,Event__r.Faclities__c,Id,Role__c,Status__c ,Rating__c,Attending_After_Party__c,Dietary_Plan__c,Participant_Name__c FROM CORE_LA_Participant__c WHERE ';
        List<CORE_LA_Event__c> OwnerIDs=[Select OwnerId from CORE_LA_Event__c];
        
        if((trainerId!= null)&& (trainerId!='')){            
            soqlQuery=soqlQuery+trainerAsUser+trainerClause;
            System.debug('Inside Trainer===> '+soqlQuery);
        }
        
        else if((externalEmail!= null)&& (externalEmail!='')){
            soqlQuery=soqlQuery+externaltrainerAsUser+trainerClause;
        }
      
        //For Create Events Page
        else if(eventStatus=='Posted' || eventStatus=='Draft'){
            soqlQuery=soqlQuery+loggedInUser+eventStatusCheck+roleClause;
            System.debug('Inside Create Event==>'+soqlQuery);
           
        }
        //For Profile Page
        else{
             soqlQuery=soqlQuery+loggedInUser;
            System.debug('Inside Participant===> '+soqlQuery);
        }
            
            
        if((filterType!= null) && (filterType!='')){
            if(filterType=='Registered'){
                soqlQuery=soqlQuery+registeredClause;
            }
            else if(filterType=='Saved'){
                soqlQuery=soqlQuery+savedClause;
            }
            else if(filterType=='recurring'){
                soqlQuery=soqlQuery+recurringClause;
            }
            else if(filterType=='Non-Recurring'){
                soqlQuery=soqlQuery+nonRecurringClause;
            }
        }
        
        if(sortType=='Name')
        {
            soqlQuery=soqlQuery+nameSortClause;
        }
        else 
        {
            soqlQuery=soqlQuery+dateSortClause;
        }
        soqlQuery=soqlQuery+paginationQuery;
        System.debug('Soql Query==>'+soqlQuery);
        List<CORE_LA_Participant__c > EventParticipants =  database.query(soqlquery);
        
        /*List<CORE_LA_Participant__c > EventParticipants= [SELECT Event__c,Event__r.Name,Event__r.No_of_Attendees__c,Event__r.Recurring__c,
Event__r.Banner__c,Event__r.Short_Description__c,Event__r.From_Date__c,Event__r.To_Date__c,
Event__r.Location__c,Event__r.Prerequisite__c,Event__r.Agenda__c,
Event__r.Details__c,Event__r.Recurring_Details__c,Event__r.Faclities__c,Id,Role__c,Status__c ,Rating__c,Attending_After_Party__c,Dietary_Plan__c,Participant_Name__c FROM CORE_LA_Participant__c WHERE Participant_Name__c =: UserInfo.getUserId() ];*/
        List<CORE_LA_EventWrapperClass.Event> eventParticipantList = new List<CORE_LA_EventWrapperClass.Event>();
        for (CORE_LA_Participant__c participant :EventParticipants){
            CORE_LA_EventWrapperClass.Event eventDetails= new CORE_LA_EventWrapperClass.Event();
            eventDetails.eventID=participant.Event__c;
            eventDetails.eventName=participant.Event__r.Name;
            eventDetails.numberOfAttendees= participant.Event__r.No_of_Attendees__c;
            eventDetails.recurring= participant.Event__r.Recurring__c;
           // eventDetails.contentURLBannerImage=participant.Event__r.Banner__c;
            eventDetails.shortDescription=participant.Event__r.Short_Description__c;
            eventDetails.fromDate=participant.Event__r.From_Date__c;
            eventDetails.toDate=participant.Event__r.To_Date__c;
            eventDetails.Location=participant.Event__r.Location__c;
            eventDetails.userRole=participant.Role__c;
            eventDetails.userRegistrationStatus=participant.Status__c;
            eventDetails.eventRating=participant.Rating__c;
            eventDetails.accessibilityNeeds=true;//participant.Attending_After_Party__c;
            eventDetails.dietaryPlan=true;//participant.Dietary_Plan__c;
            eventDetails.prerequisite=participant.Event__r.Prerequisite__c;
            eventDetails.agenda=participant.Event__r.Agenda__c;
            eventDetails.details=participant.Event__r.Details__c;
            eventDetails.recurringDetails=participant.Event__r.Recurring_Details__c;
            //eventDetails.floorPlan=participant.Event__r.Location__c;
            //eventDetails.trainer=
            eventDetails.facilities=participant.Event__r.Faclities__c;
            eventParticipantList.add(eventDetails);
        }
        System.debug('Event list with details======>'+eventParticipantList);
        
        return eventParticipantList;
    }
}