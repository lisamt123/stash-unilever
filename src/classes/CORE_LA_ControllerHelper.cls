/***************************************************************
Class Name: CORE_LA_ControllerHelper
Copyright © 2017 Salesforce

Purpose:
Requirement/Project Name: EVENTS APPLICATION
Requirement/Description: Helper class For EVENTS APPLICATION.

History:
VERSION     AUTHOR         DATE              DETAIL Description
1.0         Mindtree       11/01/2017        Helper class For EVENTS APPLICATION
***************************************************************/

public with sharing class CORE_LA_ControllerHelper{

        
 //Display Trainer List Based On Event Used in Event Detail Page , Trainer & Attendee List Page,Trainer Detail Page 
   @AuraEnabled
    public static List<CORE_LA_EventWrapperClass.TrainerWrapper> getTrainerWrapperDetails(String eventId){
 //[eventId] parameter is Used to display list of trainers for an event and External Trainer Details .The name of paramenter should not be confused. 
       List<Document> lstDocument=[SELECT Id FROM Document where Name=:'DefaultExternalImage'];
  //Id of Default External Image in Document Object
        Id attachid;
        String registeredClause=' AND Role__c =\''+'Trainer'+'\' ORDER BY Participant_Name__r.Name';
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
    
    //Event Card Helper use in Profile Page,Upcoming Page ,Trainer Detail Page, Create Page both 'posted' and 'Draft' Section.
    @AuraEnabled
    public static List<CORE_LA_EventWrapperClass.Event> retriveEvents(String filterType,String sortType,Integer limitRecords,Integer offsetValue,String trainerId,String eventStatus,Boolean showMoreStatus,String externalEmail,Boolean commonActionBarHide){
        //String loggedInUserId= UserInfo.getUserId();
        //'AND CreatedById =\''+UserInfo.getUserId()+'\''
        String registeredClause=' AND Status__c =\''+'Registered'+'\'';
        String savedClause=' AND Status__c = \''+'Saved'+'\'';
        String recurringClause=' AND Event__r.Recurring__c= true';
        String nonRecurringClause= 'AND Event__r.Recurring__c= false';
        String dateSortClause=' ORDER BY  Event__r.From_Date__c ASC';
        String nameSortClause=' ORDER BY Event__r.Name ASC';
        String numberOfAttendeesSortClause=' ORDER BY Event__r.No_of_Attendees__c DESC ';
        String paginationQuery=' LIMIT '+limitRecords+' OFFSET '+offsetValue;
        Datetime todaysDate = System.now();
        //String pastEvent=' AND Event__r.To_Date__c > \''+todaysDate+'\'';
        String pastEvent=' AND Event__r.To_Date__c < TODAY ';
        String upcomingEvent=' AND Event__r.To_Date__c > TODAY ';
        Id loggedInUserId= UserInfo.getUserId();
        System.debug('LoggedInUserId===> '+loggedInUserId);
        String loggedInUser='Participant_Name__c =\''+loggedInUserId+'\'';
        String eventStatusCheck=' AND Event__r.Status__c=\''+eventStatus+'\'';
        String roleClause=' AND Role__c = \''+'Admin'+'\''; 
        String trainerClause=' AND Role__c = \''+'Trainer'+'\''; 
        String externaltrainerAsUser='ExternalTrainerEmail__c=\''+externalEmail+'\'';
        System.debug('Participant_Name__c===> '+loggedInUser);
        String trainerAsUser='Participant_Name__c=\''+trainerId+'\'';
        String soqlQuery='SELECT Event__c,Event__r.OwnerId,Event__r.Name,Event__r.No_of_Attendees__c,Event__r.Total_Rating__c,Event__r.Recurring__c,Event__r.Banner__c,Event__r.From_Date__c,Event__r.To_Date__c,Event__r.Location__c,Event__r.Prerequisite__c,Event__r.Agenda__c,Event__r.Details__c,Event__r.Recurring_Details__c,Event__r.Faclities__c,Id,Participant_Name__r.Name,Role__c,Status__c ,Rating__c,Participant_Name__c FROM CORE_LA_Participant__c WHERE ';

       // for trainer Detail page Internal Trainer
        if((trainerId!= null)&& (trainerId!='')){            
            soqlQuery=soqlQuery+trainerAsUser+trainerClause+upcomingEvent;
            System.debug('Inside Trainer===> '+soqlQuery);
        }
        //for trainer Detail page External Trainer
        else if((externalEmail!= null)&& (externalEmail!='')){
            soqlQuery=soqlQuery+externaltrainerAsUser+trainerClause+upcomingEvent;
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
            else if(filterType=='Past'){
                soqlQuery=soqlQuery+pastEvent;
            }
            else if(filterType=='Saved'){
                soqlQuery=soqlQuery+savedClause;
            }
            else if(filterType=='MultiEvent'){
                soqlQuery=soqlQuery+recurringClause;
            }
        }
        
        if(sortType=='EventName')
        {
            soqlQuery=soqlQuery+nameSortClause;
        }
        else if(sortType=='NumberOfAttendees')
        {
            soqlQuery=soqlQuery+numberOfAttendeesSortClause;
        }
        else 
        {
            soqlQuery=soqlQuery+dateSortClause;
        }
        soqlQuery=soqlQuery+paginationQuery;
        System.debug('Soql Query==>'+soqlQuery);
        List<CORE_LA_Participant__c > EventParticipants =  database.query(soqlquery);
        List<CORE_LA_EventWrapperClass.Event> eventParticipantList = new List<CORE_LA_EventWrapperClass.Event>();
        System.debug('testclass for loop#####'+EventParticipants);
        for (CORE_LA_Participant__c participant :EventParticipants){
            CORE_LA_EventWrapperClass.Event eventDetails= new CORE_LA_EventWrapperClass.Event();
            eventDetails.eventID=participant.Event__c;
            eventDetails.IdofParticicpant=participant.Id;
            eventDetails.ParticipantName=participant.Participant_Name__r.Name;
            eventDetails.eventName=participant.Event__r.Name;
            eventDetails.numberOfAttendees= participant.Event__r.No_of_Attendees__c; 
            eventDetails.totalRatingPerEvent= participant.Event__r.Total_Rating__c;
            //Checking for System.MathException: Divide by 0
            if(participant.Event__r.No_of_Attendees__c >0){
                  eventDetails.avgRatingPerEvent= (participant.Event__r.Total_Rating__c/ participant.Event__r.No_of_Attendees__c); 
            } 
            else{
                //assigning default avaergae rating if not one rated
                 eventDetails.avgRatingPerEvent=0;
            }
            eventDetails.recurring= participant.Event__r.Recurring__c;
           // eventDetails.contentURLBannerImage=participant.Event__r.Banner__c;
          //  eventDetails.shortDescription=participant.Event__r.Short_Description__c;
            eventDetails.fromDate=participant.Event__r.From_Date__c;
            eventDetails.toDate=participant.Event__r.To_Date__c;
            eventDetails.location=participant.Event__r.Location__c;
            eventDetails.userRole=participant.Role__c;
            eventDetails.userRegistrationStatus=participant.Status__c;
            eventDetails.eventRating=participant.Rating__c;
            eventDetails.prerequisite=participant.Event__r.Prerequisite__c;
            eventDetails.agenda=participant.Event__r.Agenda__c;
            eventDetails.details=participant.Event__r.Details__c;
            eventDetails.recurringDetails=participant.Event__r.Recurring_Details__c;
            eventDetails.facilities=participant.Event__r.Faclities__c;
            Datetime endDate =participant.Event__r.To_Date__c;
            //Checking if event should be designated  Completed.
            if(todaysDate > endDate ){ 
                //designated  Completed
            eventDetails.userEventStatus=True;
              }
            else{
                eventDetails.userEventStatus=False;
            }
            
            eventParticipantList.add(eventDetails);
        }
        System.debug('Event list with details======>'+eventParticipantList);
        
        return eventParticipantList;
    }
    
    

    
}