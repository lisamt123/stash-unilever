/**
* @date        -   
* @description -  Wrapper object on the Events
* @modifiedby  -
*/
public class CORE_LA_EventWrapperClass{
    
    /**
* @date        -   
* @description -  Wrapper object on the Events as a card
* @modifiedby  -
*/
    public class Event extends CORE_BaseApplicationWrapper{
         
         @AuraEnabled
        public String occurenceId; // Id of occurence event
    
        @AuraEnabled
        public String eventId;      //Id of the Event
         @AuraEnabled
        public String IdofParticicpant; 
        @AuraEnabled
        public String eventName;            // name of the event
        @AuraEnabled
        public Decimal totalRatingPerEvent;  
        @AuraEnabled
        public Decimal numberOfAttendees;           //number of attendees for the event
        @AuraEnabled
        public Decimal avgRatingPerEvent;
        @AuraEnabled
        public Boolean recurring;       //event reoccur
        @AuraEnabled
        public String contentDocumentIdBannerImage;     //Content Document Id Banner Image of the event
        @AuraEnabled
        public String contentURLBannerImage;        //Content URL Banner Image of the event
        @AuraEnabled
        public String shortDescription;     //short Description of the event
        @AuraEnabled
        public Datetime fromDate;       //start time of the event
        @AuraEnabled
        public Datetime toDate;     //end time of the event
        @AuraEnabled
        public String location;     //Location of the event
        @AuraEnabled
        public String userRole;     //Role of the user
        @AuraEnabled
        public String userRegistrationStatus;       //Status of the user for the event
         @AuraEnabled
        public Boolean userEventStatus;     //if event completed
        @AuraEnabled
        public Decimal eventRating;     //Rating of the event giving by user
        //@AuraEnabled
       // public Datetime currentDateTime;  //current date and time of the user 
        @AuraEnabled
        public Boolean accessibilityNeeds;          //user attending After Party
        @AuraEnabled
        public Boolean dietaryPlan;     //dietary plan of the user .
        @AuraEnabled
        public String prerequisite;         // related to pre-requisite details of the event
        @AuraEnabled   
        public String contentDocumentIdPrerequisite; //Content Document Id prerequisite of the event
        @AuraEnabled
        public String agenda;           //agenda of the event   
        @AuraEnabled
        public List<CORE_LA_Agenda__c> agendaList;
         @AuraEnabled
        public List<CORE_LA_Participant__c> adminList;
        @AuraEnabled 
        public String contentDocumentIdAgenda; //Content Document Id agenda of the event
        //@AuraEnabled
       // public String banner;         //banner details of the event       
        @AuraEnabled
        public String details;      // complete details of the event    
        @AuraEnabled
        public Datetime recurringDetails;       // re-occuring details of the event 
         @AuraEnabled
        public String floorPlan;            //agenda of the floorPlan   
        @AuraEnabled 
        public String contentDocumentIdFloorPlan; //Content Document Id floorPlan of the event
        @AuraEnabled
        public User trainer;            //trainer   
        @AuraEnabled
        public String facilities; //facilities provided on the event
        @AuraEnabled
        public String ParticipantName;
       
    }
    
    public class TrainerWrapper extends CORE_BaseApplicationWrapper{
         //External Trainer Details Wrapper 
         @AuraEnabled
        public String ExternalProfile;
        @AuraEnabled
        public String ExternalName;
        @AuraEnabled
        public String ExternalTitle;
        @AuraEnabled
        public String ExternalLocation;
        @AuraEnabled
        public String ExternalImage;
        @AuraEnabled
        public String ExternalEmail;
        @AuraEnabled
        public String ExternalContact;
       //Wrapper for Internal Trainer
        @AuraEnabled
        public String Participant_Id;//to be used in Admin part also
         @AuraEnabled
        public String Participant_SmallPhotoUrl;
         @AuraEnabled
        public String Participant_Name;
         @AuraEnabled
        public String Participant_Title;
        //wrapper for Admin Part
          @AuraEnabled
        public String Participant_Status;
         @AuraEnabled
        public String Participant_Role;
         @AuraEnabled
        public String Participant_Event;
        
        
        
    }
    
}