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
    
    

    
}