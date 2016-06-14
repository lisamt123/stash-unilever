/**********************************************************************
Name: ICB_CheckInCheckOut_CC_Test
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Test class for ICB_CheckInCheckOut_CC controller class.
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Antonio Raul 13/06/2016  Class creation  
***********************************************************************/
@IsTest
public class ICB_CheckInCheckOut_CC_Test
{
	
    /*******************************************************************
    Purpose: Test the method getVisits(Event.id)
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    private static testMethod void getVisit_Test()
    {
        System.Test.startTest();
        System.assert(ICB_CheckInCheckOut_CC.getVisit(insertEvent().Id) != null);
        System.Test.stopTest();
    }
    /*******************************************************************
    Purpose: Test the method getVisits(Event.id) to throw Exception
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    private static testMethod void getVisitException_Test()
    {
        System.Test.startTest();
        Event evento = insertEvent();
        Id eventoId = evento.Id;
        delete(evento);
        System.assert(ICB_CheckInCheckOut_CC.getVisit(eventoId) == null);
        System.Test.stopTest();
    }
    /*******************************************************************
    Purpose: Test the method getCognosFile()
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    private static testMethod void getCognosFile_Test()
    {
        System.Test.startTest();
        User user = insertUser();
        System.runAs(user){
            ICB_Territory_Management__c territory = insertTerritory(UserInfo.getUserId());
            insertContentVersion(territory);
            System.assert(ICB_CheckInCheckOut_CC.getCognosFile() != null);    
        }
        
        System.Test.stopTest();
    }
     /*******************************************************************
    Purpose: Test the method getCognosFile() when file is null
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    private static testMethod void getCognosFileNull_Test()
    {
        System.Test.startTest();
        User user = insertUser();
        System.runAs(user){
            System.assert(ICB_CheckInCheckOut_CC.getCognosFile() == null);    
        }
        
        System.Test.stopTest();
    }
  
    
    /*******************************************************************
    Purpose: Test the method getEvent(Event.id)
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    private static testMethod void getEvent_Test()
    {
        System.Test.startTest();
        Id visitId = insertEvent().Id;
        Event event = ICB_CheckInCheckOut_CC.getEvent(visitId);
        System.assertEquals(visitId, event.Id);
        System.Test.stopTest();
    }    
    /*******************************************************************
    Purpose: Test the method getEvent(Event.id) to throw Exception
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    private static testMethod void getEventNull_Test()
    {
        System.Test.startTest();
        Event evento = insertEvent();
        Id visitId = evento.Id;
        delete(evento);
        Event event = ICB_CheckInCheckOut_CC.getEvent(visitId);
        ICB_CheckInCheckOut_CC.newCheckIn(visitId, 1.1, 1.1, true);
        ICB_CheckInCheckOut_CC.newCheckOut(visitId, 1.1, 1.1, true);
        System.assert(event == null);
        System.Test.stopTest();
    }
   
    /*******************************************************************
    Purpose: Test the method newCheckIn(Event.id,Latitude,Logitude,Confirm) When Confirm param is true
    Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    private static testMethod void newCheckInConfirmTrue_Test()
    {
        System.Test.startTest();
        Id visitId = insertEvent().Id;
        String chkinResult = ICB_CheckInCheckOut_CC.newCheckIn(visitId, 1.1, 1.2, true);
        System.assertEquals(Label.ICB_SUCCESS_CHECKIN_SUCCESSFULLY, chkinResult);
        System.Test.stopTest();
    }
    /*******************************************************************
    Purpose: Test the method newCheckIn(Event.id,Latitude,Logitude,Confirm) When Confirm param is false
    Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE] 
    ********************************************************************/
    private static testMethod void newCheckInConfirmFalse_Test()
    {
        System.Test.startTest();
        Event visit = insertEvent();
        visit.ICB_CustomerGeolocation__Latitude__s = 1.1;
        visit.ICB_CustomerGeolocation__Longitude__s = 1.1;
        update visit;
        String chkinResult = ICB_CheckInCheckOut_CC.newCheckIn(visit.Id, 1.1, 1.2, false);
        System.assertEquals(Label.ICB_ALERT_CHECKIN_OUT_CUSTOMER, chkinResult);
        System.Test.stopTest();
    }
    /*******************************************************************
    Purpose: Test the method newCheckIn(Event.id,Latitude,Logitude,Confirm) When ICB_GeolocationCheckIn__Latitude__s have value
    Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]  
    ********************************************************************/
    private static testMethod void newCheckInLatitude_Test()
    {
        System.Test.startTest();
        Event visit = insertEvent();
        visit.ICB_GeolocationCheckIn__Latitude__s = 1.1;
        visit.ICB_GeolocationCheckIn__Longitude__s = 1.1;
        update visit;
        String chkinResult = ICB_CheckInCheckOut_CC.newCheckIn(visit.Id, 1.1, 1.2, false);
        System.assertEquals(Label.ICB_WARNING_CHECKIN_SUCCESSFULLY, chkinResult);
        System.Test.stopTest();
    }
    /*******************************************************************
    Purpose: Test the method newCheckIn(Event.id,Latitude,Logitude,Confirm) When Latitude passed by parameter is 0
    Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE] 
    ********************************************************************/
    private static testMethod void newCheckInLatitudeParam_Test()
    {
        System.Test.startTest();
        Event visit = insertEvent();
        String chkinResult = ICB_CheckInCheckOut_CC.newCheckIn(visit.Id, 0, 1.2, false);
        System.assertEquals(Label.ICB_WARNING_CANT_POSSIBLE_RETURN_GEO, chkinResult);
        System.Test.stopTest();
    }
    /*******************************************************************
    Purpose: Test the method newCheckOut(Event.id,Latitude,Logitude,Confirm) When CheckOut not have Chekin
    Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE] 
    ********************************************************************/
    private static testMethod void newCheckOutWithoutChekin_Test()
    {
        System.Test.startTest();
        Id visitId = insertEvent().Id;
        String chkOutResult = ICB_CheckInCheckOut_CC.newCheckOut(visitId, 1.1, 1.2, true);
        System.assertEquals(Label.ICB_ERROR_CHECKIN_BEFORE_CHECKOUT, chkOutResult);
        System.Test.stopTest();
    }
    /*******************************************************************
    Purpose: Test the method newCheckOut(Event.id,Latitude,Logitude,Confirm)  When Confirm parameter is true
    Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    private static testMethod void newCheckOutConfirmTrue_Test()
    {
        System.Test.startTest();
        Id visitId = insertEvent().Id;
        ICB_CheckInCheckOut_CC.newCheckIn(visitId,1.1, 1.2, true);
        String chkOutResult = ICB_CheckInCheckOut_CC.newCheckOut(visitId, 1.1, 1.2, true);
        System.assertEquals(Label.ICB_SUCCESS_CHECKOUT_SUCCESSFULLY, chkOutResult);
        System.Test.stopTest();
    }
    /*******************************************************************
    Purpose: Test the method newCheckOut(Event.id,Latitude,Logitude,Confirm) When Confirm parameter is false
    Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE] 
    ********************************************************************/
    private static testMethod void newCheckOutConfirmFalse_Test()
    {
        System.Test.startTest();
        Event visit = insertEvent();
        visit.ICB_CustomerGeolocation__Latitude__s = 1.1;
        visit.ICB_CustomerGeolocation__Longitude__s = 1.1;
        update visit;
        ICB_CheckInCheckOut_CC.newCheckIn(visit.Id,1.1, 1.2, true);
        String chkOutResult = ICB_CheckInCheckOut_CC.newCheckOut(visit.Id, 1.1, 1.2, false);
        System.assertEquals(Label.ICB_ALERT_CHECKOUT_OUT_CUSTOMER, chkOutResult);
        System.Test.stopTest();
    }
    /*******************************************************************
    Purpose: Test the method newCheckOut(Event.id,Latitude,Logitude,Confirm) When Latitude passed by parameter is 0
    Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]  
    ********************************************************************/
    private static testMethod void newCheckOutLatitudeParam_Test()
    {
        System.Test.startTest();
        Event visit = insertEvent();
        ICB_CheckInCheckOut_CC.newCheckIn(visit.Id, 1.0, 1.2, true);
        String chkOutResult = ICB_CheckInCheckOut_CC.newCheckOut(visit.Id, 0, 1.2, false);
        System.assertEquals(Label.ICB_WARNING_CANT_POSSIBLE_RETURN_GEO, chkOutResult);
        System.Test.stopTest();
    }
    /*******************************************************************
    Purpose: Test the method newCheckOut(Event.id,Latitude,Logitude,Confirm) Checkout success
    Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]  
    ********************************************************************/
    private static testMethod void newCheckOutSuccess_Test()
    {
        System.Test.startTest();
        Event visit = insertEvent();
        visit.ICB_GeolocationCheckOut__Latitude__s = 1.1;
        visit.ICB_GeolocationCheckOut__Longitude__s = 2.2;
        update(visit);
        ICB_CheckInCheckOut_CC.newCheckIn(visit.Id, 1.0, 1.2, true);
        String chkOutResult = ICB_CheckInCheckOut_CC.newCheckOut(visit.Id, 0, 1.2, false);
        System.assertEquals(Label.ICB_WARNING_CHECKOUT_SUCCESSFULLY, chkOutResult);
        System.Test.stopTest();
    }
    /*******************************************************************
     Purpose: Inser Event for using in test methods
     Parameters: [NONE]
	 Returns: Event
	 Throws [Exceptions]: [NONE] 
     ********************************************************************/
    private static Event insertEvent()
    {
        Event event = new Event(Subject = 'Call',
                                StartDateTime = System.now(),
                                EndDateTime = System.now(),
                                OwnerId = insertUser().Id,
                                RecordTypeId=ICB_RecordTypeMemory.getRecType(
                                    Label.ICB_SOBJECT_EVENT, Label.ICB_REC_TYPE_ICE_CREAM_VISIT)); 
        insert event;
        return event;
    }
    /*******************************************************************
    Purpose: Inser User for using in test methods
    Parameters: [NONE]
    Returns: User
    Throws [Exceptions]: [NONE] 
    ********************************************************************/
    private static User insertUser()
    {
        Profile profile = [Select Id From Profile Where Name = 'System Administrator'];
        User user = new User(FirstName = 'Test',
                             LastName = 'User',
                             Alias = 'tUser',
                             Email = 'testUser@email.com',
                             UserName = 'testUser@email.com.unilever',
                             CommunityNickname = 'testUser',
                             TimeZoneSidKey = 'America/Los_Angeles',
                             LocaleSidKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LanguageLocaleKey='en_US',
                             ProfileId = profile.id
                            );
        insert user;
        return user;
    }
 	/*******************************************************************
     Purpose: Inser ICB_Territory_Management__c for using in test methods
     Parameters: userId
	 Returns: ICB_Territory_Management__c
	 Throws [Exceptions]: [NONE] 
     ********************************************************************/
    private static ICB_Territory_Management__c insertTerritory(Id userId)
    {
        ICB_Territory_Management__c territory = new ICB_Territory_Management__c(Name = 'Test',
                                                                                SetupOwnerId = userId,
                                                                                ICB_Territory_Code__c ='123' 
                                                                               );
        insert territory;
        return territory;
    }
    /*******************************************************************
    Purpose: Inser ContentVersion for using in test methods
    Parameters: territory
    Returns: [VOID]
    Throws [Exceptions]: [NONE]  
    ********************************************************************/
    private static void insertContentVersion(ICB_Territory_Management__c territory)
    {
        ContentVersion doc = new ContentVersion(Title = territory.ICB_Territory_Code__c,
                                                PathOnClient = territory.ICB_Territory_Code__c,
                                                VersionData = Blob.valueOf(territory.ICB_Territory_Code__c)
                                                );
        insert doc;
    }
}