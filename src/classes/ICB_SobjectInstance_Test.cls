/**********************************************************************
Name: ICB_SobjectInstance_Test
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Class for creating instances which will be used to test classes from Ice Cream's project
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Antonio Raul 14/06/2016  Class creation  
***********************************************************************/
@IsTest
public class ICB_SobjectInstance_Test 
{
    /*******************************************************************
    Purpose: Insert Event for using in test methods of classes: ICB_CheckInCheckOut_CC_Test, 
			 ICB_CalculatePlanDistance_BatchSch_Test, ICB_CalculatePlanDistance_BatchSchedule_Test
    Parameters: [NONE]
    Returns: Event
    Throws [Exceptions]: [NONE] 
	********************************************************************/
    public static Event insertEvent(String subject, DateTime startDateTime, DateTime endDateTime, Id ownerId, Id recordTypeId)
    {
        Event event = new Event(Subject = subject,
                                StartDateTime = startDateTime,
                                EndDateTime = endDateTime,
                                OwnerId = ownerId,
                                RecordTypeId= recordTypeId); 
        insert event;
        return event;
    }
    /*******************************************************************
    Purpose: Insert User for using in test methods of classes: ICB_CheckInCheckOut_CC_Test, 
			 ICB_CalculatePlanDistance_BatchSch_Test, ICB_CalculatePlanDistance_BatchSchedule_Test
    Parameters: [NONE]
    Returns: User
    Throws [Exceptions]: [NONE] 
    ********************************************************************/
    public static User insertUser(String profileName)
    {
        Profile profile = [Select Id From Profile Where Name =: profileName];
        User user = new User(FirstName = 'Test',
                             LastName = 'USER',
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
    Purpose: Insert ICB_Territory_Management__c for using in test methods of classes: ICB_CheckInCheckOut_CC_Test, 
			 ICB_CalculatePlanDistance_BatchSch_Test, ICB_CalculatePlanDistance_BatchSchedule_Test
    Parameters: userId
    Returns: ICB_Territory_Management__c
    Throws [Exceptions]: [NONE] 
    ********************************************************************/
    public static Territory__c insertTerritory(Id userId,String code)
    {
        Territory__c territory = new Territory__c(User__c = userId,
                                                  Territory_ID__c = code 
                                                 ); 
        insert territory;
        return territory;
    }
    /*******************************************************************
    Purpose: Insert ContentVersion for using in test methods of classes: ICB_CheckInCheckOut_CC_Test, 
			 ICB_CalculatePlanDistance_BatchSch_Test, ICB_CalculatePlanDistance_BatchSchedule_Test
    Parameters: territory
    Returns: [VOID]
    Throws [Exceptions]: [NONE]  
    ********************************************************************/
    public static ContentVersion insertContentVersion(Territory__c territory)
    {
        ContentVersion doc = new ContentVersion(Title = territory.Territory_ID__c,
                                                PathOnClient = territory.Territory_ID__c,
                                                VersionData = Blob.valueOf(territory.Territory_ID__c)
                                               );
        insert doc;
        return doc;
    }
}