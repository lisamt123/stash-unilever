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
 1.1    Antonio Raul 14/06/2016  Class updated      
 1.0    Antonio Raul 13/06/2016  Class creation 
***********************************************************************/
@IsTest
public class ICB_CheckInCheckOut_CC_Test
{
    private static Id recordTypeId;
    private static User user;
    private static Event event;
	
    Static
    {
        recordTypeId = ICB_RecordTypeMemory.getRecType(Label.ICB_SOBJECT_EVENT, Label.ICB_REC_TYPE_ICE_CREAM_VISIT);
        user = new User();
        event = new Event();
    }
    
    /*******************************************************************
    Purpose: Test the method getVisits for success and exception scenarios
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    private static testMethod void getVisit_Test()
    {
        createInstances();
        System.Test.startTest();
        
        //Test Success
        System.assert(ICB_CheckInCheckOut_CC.getVisit(event.Id) != null);
        //Test Exception
        Id eventId = event.Id;
        delete(event);
        System.assert(ICB_CheckInCheckOut_CC.getVisit(eventId) == null);
        
        System.Test.stopTest();
    }
   
    /*******************************************************************
    Purpose: Test the method getCognosFile for file is not null and file is null
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    private static testMethod void getCognosFile_Test()
    {
        User userCognos =  ICB_SobjectInstance_Test.insertUser('System Administrator');
        System.Test.startTest();
        
        System.runAs(userCognos)
        {
            //File is not null
            Territory__c territory = ICB_SobjectInstance_Test.insertTerritory(userCognos.Id, '1010');
            ContentVersion content = ICB_SobjectInstance_Test.insertContentVersion(territory);
            System.assert(ICB_CheckInCheckOut_CC.getCognosFile() != null);  
            //File is null
            delete territory;
            delete [Select id From ContentDocument Where Title =: content.Title];
            System.assert(ICB_CheckInCheckOut_CC.getCognosFile() == null); 
        }
        
        System.Test.stopTest();
    }
   
    
    /*******************************************************************
    Purpose: Test the method getEvent when Success and exception scenarios
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    private static testMethod void getEvent_Test()
    {
        createInstances();
        
        System.Test.startTest();
        System.assert(ICB_CheckInCheckOut_CC.getEvent(event.Id) != null);
        System.Test.stopTest();
    }    
    
   
    /*******************************************************************
    Purpose: Test the method newCheckIn and newCheckOut to success and exception scenarios
    Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    *******************************************************************/
    private static testMethod void newCheckInOutConfirmTrue_Test()
    {
        createInstances();
        
        System.Test.startTest();
        
        //Success scenario
        String chkinResult = ICB_CheckInCheckOut_CC.newCheckIn(event.Id, 1.1, 1.2, true);
        System.assertEquals(Label.ICB_SUCCESS_CHECKIN_SUCCESSFULLY, chkinResult);
        
        String chkOutResult = ICB_CheckInCheckOut_CC.newCheckOut(event.Id, 1.1, 1.2, true);
        System.assertEquals(Label.ICB_SUCCESS_CHECKOUT_SUCCESSFULLY, chkOutResult);
        
        //exception scenario
        Id visitId = event.Id;
        delete(event);
       	System.assert(ICB_CheckInCheckOut_CC.getEvent(visitId) == null);
        String msgError;
        msgError = ICB_CheckInCheckOut_CC.newCheckIn(visitId, 1.1, 1.1, true);
        System.assert(msgError.contains('Error'));
        msgError = ICB_CheckInCheckOut_CC.newCheckOut(visitId, 1.1, 1.1, true);
        System.assert(msgError.contains('Error'));

        System.Test.stopTest();
    }
    /*******************************************************************
    Purpose: Test the method newCheckIn and newCheckOut When Confirm param is false
    Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE] 
    ********************************************************************/
    private static testMethod void newCheckInCheckOutConfirmFalse_Test()
    {
        createInstances();
        Event eventCheckOut = ICB_SobjectInstance_Test.insertEvent('Call', System.now(), System.now(), user.Id, recordTypeId);
        
        System.Test.startTest();
        
        //Test CheckIn
        event.ICB_CustomerGeolocation__Latitude__s = 1.1;
        event.ICB_CustomerGeolocation__Longitude__s = 1.1;
        update event;
        String chkinResult = ICB_CheckInCheckOut_CC.newCheckIn(event.Id, 1.1, 1.2, false);
        System.assertEquals(Label.ICB_ALERT_CHECKIN_OUT_CUSTOMER, chkinResult);
        //Test CheckOut
        ICB_CheckInCheckOut_CC.newCheckIn(eventCheckOut.Id, 1.1, 1.2, true);
        eventCheckOut.ICB_CustomerGeolocation__Latitude__s = 1.1;
        eventCheckOut.ICB_CustomerGeolocation__Longitude__s = 1.1;
        update eventCheckOut;
        String chkOutResult = ICB_CheckInCheckOut_CC.newCheckOut(eventCheckOut.Id, 1.1, 1.2, false);
        System.assertEquals(Label.ICB_ALERT_CHECKOUT_OUT_CUSTOMER, chkOutResult);
        
        System.Test.stopTest();
    }
    /*******************************************************************
    Purpose: Test the method newCheckIn and checkOut When Latitude passed by parameter is 0
    Parameters: [NONE]
    Returns: [VOID]
    Throws [Exceptions]: [NONE] 
    ********************************************************************/
    private static testMethod void newCheckInOutLatitudeZero_Test()
    {
        createInstances();
        
        System.Test.startTest();
        
        //Test CheckIn
        String chkinResult = ICB_CheckInCheckOut_CC.newCheckIn(event.Id, 0, 1.2, false);
        System.assertEquals(Label.ICB_WARNING_CANT_POSSIBLE_RETURN_GEO, chkinResult);
        //Test CheckOut
        chkinResult = ICB_CheckInCheckOut_CC.newCheckIn(event.Id, 1.1, 1.2, true);
        System.assertEquals(Label.ICB_SUCCESS_CHECKIN_SUCCESSFULLY, chkinResult);
        String checkOutResult = ICB_CheckInCheckOut_CC.newCheckOut(event.Id, 0, 0, false);
        System.assertEquals(Label.ICB_WARNING_CANT_POSSIBLE_RETURN_GEO, checkOutResult);
        
        System.Test.stopTest();
    }
    /*******************************************************************
    Purpose: Method responsible for Create the instances and atributed values to statics variables
    Parameters: [NONE]
    Returns: [VOID]
    Throws [Exceptions]: [NONE] 
    ********************************************************************/
    private static void createInstances()
    {
        user =  ICB_SobjectInstance_Test.insertUser('System Administrator');
        event = ICB_SobjectInstance_Test.insertEvent('Call', System.now(), System.now(), user.Id, recordTypeId);
    }
    
    private static testMethod void setGoldenMinuteOpenReturnTrue_Test(){
 		createInstances();
        System.Test.startTest();
        system.assert( ICB_CheckInCheckOut_CC.setGoldenMinuteOpen( event.Id ) );
        System.Test.stopTest();
    }
    
    private static testMethod void setGoldenMinuteOpenReturnFalse_Test(){
 		createInstances();
        System.Test.startTest();
        system.assert( !ICB_CheckInCheckOut_CC.setGoldenMinuteOpen( '3432' ));
        System.Test.stopTest();
    }
}