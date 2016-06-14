/**********************************************************************
Name: CalculatePlanDistaance_Batch_Test
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Class responsible for test: ICB_CalculatePlanDistaance_Batch.
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Antonio Raul 13/06/2016  Class creation  
***********************************************************************/
@IsTest
private class ICB_CalculatePlanDistaance_Batch_Test
{
	
    /*******************************************************************
    Purpose: Test Class Batchable ICB_CalculatePlanDistaance_Batch
    Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]  
    ********************************************************************/
    private static testMethod void calculatePlanDistaance_Batch_Test()
    {
        System.Test.startTest();
   		insertEvent();
        ICB_CalculatePlanDistaance_Batch batch = new ICB_CalculatePlanDistaance_Batch();
        Id batchId = Database.executeBatch(batch);
        System.assert(batchId != null);
        System.Test.stopTest();
        
    }
     private static testMethod void calculatePlanDistaance_Batch_Test2()
    {
        System.Test.startTest();
   		        ICB_CalculatePlanDistaance_Batch batch = new ICB_CalculatePlanDistaance_Batch();
        Id batchId = Database.executeBatch(batch);
        System.assert(batchId != null);
        System.Test.stopTest();
        
    }
    /*******************************************************************
    Purpose: Inser Event for using in test methods
    Parameters: [NONE]
    Returns: User
    Throws [Exceptions]: [NONE] 
    ********************************************************************/
    private static Event insertEvent()
    {
        Id recordTypeId = ICB_RecordTypeMemory.getRecType(Label.ICB_SOBJECT_EVENT, Label.ICB_REC_TYPE_ICE_CREAM_VISIT);
        Event event = new Event(Subject = 'Call',
                                StartDateTime = System.now(),
                                EndDateTime = System.now(),
                                OwnerId = insertUser().Id,
                                RecordTypeId = recordTypeId); 
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
}