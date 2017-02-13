@isTest
public class CORE_LA_Controller_Test {
    @isTest
    static void testCreateEvent(){
        
        Profile p = [Select Id from Profile where Name = 'System Administrator' LIMIT 1];     
        User usr = new User(ProfileId = p.Id, Username = 'test@email.com.event', Email = 'test@email.com',
                            FirstName = 'EventUser', LastName = 'TestUser', alias='tx1234', EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles'); 
        User usr2 = new User(ProfileId = p.Id, Username = 'test2@email.com.event', Email = 'test@email.com',
                            FirstName = 'EventUser2', LastName = 'TestUser2', alias='tx1234', EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles'); 
        
        //Select Name From Profile Where Id = :UserInfo.getProfileId()
     
        Test.startTest();
         CORE_LA_Event__c eventPosted = new CORE_LA_Event__c(Name = 'Event 1', Status__c = 'Posted');
        CORE_LA_Event__c eventDraft = new CORE_LA_Event__c(Name = 'Event 1', Status__c = 'Draft');
        //CORE_LA_Event__c eventSaved = new CORE_LA_Event__c(Name = 'Event 1', Status__c = 'Saved',);
        CORE_LA_Event__c eventSaved = new CORE_LA_Event__c(Name = 'Event 1', Status__c = 'Saved',Recurring__c= true,Banner__c='xyz',Location__c = 'xyy',Prerequisite__c='xxx',Agenda__c='sss',Details__c='hhh',Faclities__c='Wheelchair');//,From_Date__c='2017-02-13T09:22:00.000Z',To_Date__c='2017-03-13T09:22:00.000Z',Recurring_Details__c='2017-01-13T09:22:00.000Z');
        insert usr;           
             
        insert eventPosted;
        insert eventDraft;
        insert eventSaved;
        CORE_LA_Participant__c participantAdmin = new CORE_LA_Participant__c(Role__c='Admin', Event__c= eventSaved.Id, Status__c='Saved',Participant_Name__c =usr.id );
        CORE_LA_Participant__c participantAttendee = new CORE_LA_Participant__c(Role__c='Attendee', Event__c= eventPosted.Id, Status__c='Registered',Participant_Name__c =usr.id );
        CORE_LA_Participant__c participantTrainer = new CORE_LA_Participant__c(Role__c='Trainer', Event__c= eventSaved.Id, Status__c='Invited',Participant_Name__c =usr2.id );
        CORE_LA_Participant__c participantExternalUser = new CORE_LA_Participant__c(Role__c='Trainer', Event__c= eventSaved.Id, Status__c='Registered',ExternalTrainerName__c='ExternalTrainer',ExternalTrainerEmail__c='externaltrainer@email.com', ExternalTrainerLocation__c='America/Los_Angeles', ExternalTrainerContact__c='0987654321');
        //Event__c,Event__r.OwnerId,Event__r.Name,Event__r.No_of_Attendees__c,Event__r.Total_Rating__c,Event__r.Recurring__c,Event__r.Banner__c,Event__r.From_Date__c,Event__r.To_Date__c,Event__r.Location__c,Event__r.Prerequisite__c,Event__r.Agenda__c,Event__r.Details__c,Event__r.Recurring_Details__c,Event__r.Faclities__c,Id,Participant_Name__r.Name,Role__c,Status__c ,Rating__c,Participant_Name__c
         
       insert participantAdmin;
       insert participantAttendee;
       insert participantTrainer;
        
     //  CORE_LA_Controller LAcontroller = new CORE_LA_Controller();
        List<CORE_LA_EventWrapperClass.TrainerWrapper> listTrainerWrapper = CORE_LA_Controller.getTrainerWrapper(eventSaved.id); 
        List<CORE_LA_EventWrapperClass.Event>  allPastEventsList = CORE_LA_Controller.retriveAllEvents('Past','NumberOfAttendees',1,1,participantTrainer.Id,eventSaved.Status__c, true,'abc@email.com', true);
        List<CORE_LA_EventWrapperClass.Event>  allEventNameList = CORE_LA_Controller.retriveAllEvents('EventName','NumberOfAttendees',1,1,participantExternalUser.Id,eventSaved.Status__c, true,'abc@email.com', true);
      
         List<CORE_LA_EventWrapperClass.TrainerWrapper> allEventsListExternal = CORE_LA_Controller.getTrainerWrapper('external@gmail.com'); 
        List<CORE_LA_Agenda__c>  agendaList = CORE_LA_Controller.getAgendaList(eventSaved.id);
       User u =CORE_LA_Controller.getLoggedInUser();
      // User u1 = CORE_LA_Controller.getTrainerDetails(participantTrainer.Id);
       //system.assertEquals(u.id, UserInfo.getProfileId());
       List<CORE_LA_Participant__c > occList =CORE_LA_Controller.getOccurenceList(eventSaved.id); 
       List<CORE_LA_Participant__c > pastOccList =CORE_LA_Controller.getPastOccurenceList(eventSaved.id); 
       List<CORE_LA_Participant__c > attendeeList =CORE_LA_Controller.getAttendeList(eventSaved.id, 1,1); 
       Test.stopTest(); 
    }

}