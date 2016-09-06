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
    Purpose: Insert Territory__c for using in test methods of classes: ICB_CheckInCheckOut_CC_Test, 
			 ICB_CalculatePlanDistance_BatchSch_Test, ICB_CalculatePlanDistance_BatchSchedule_Test
    Parameters: userID : User ID, code : Territory code
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
    Parameters: Territory__c
    Returns: [ContentVersion]
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
    /*******************************************************************
    Purpose: Insert Account for using in test methods of classes: ICB_ImportVisits_Test, ICB_Cockpit_CC_Test,ICB_PhotoMobileChannel_Batch_Test
    Parameters: Name, recordTypeId
    Returns: [Account]
    Throws [Exceptions]: [NONE]  
    ********************************************************************/
    public static Account insertAccount(String name, String recordTypeId)
    {
        Account account = new Account(Name = name,
                                      RecordTypeId = recordTypeId
                                     );
        insert account;
        return account;
    }
    /*******************************************************************
    Purpose: Insert Account for using in test methods of classes: ICB_Cockpit_CC_Test,ICB_PhotoMobileChannel_Batch_Test
    Parameters: Name, recordTypeId,accountId
    Returns: [Account]
    Throws [Exceptions]: [NONE]  
    ********************************************************************/
    public static Contact insertContact(String lastName, String recordTypeId, String accountId, String IcbType)
    {
        Contact contact = new Contact(LastName = lastName,
                                      RecordTypeId = recordTypeId,
                                      AccountId = accountId,
                                      ICB_Type__c = IcbType
                                     );
        insert contact;
        return contact;
    }
    /*******************************************************************
    Purpose: Insert Sales_Area__c for using in test methods of classes: ICB_ImportVisits_Test
    Parameters: Sales_Area__c
    Returns: [Sales_Area__c]
    Throws [Exceptions]: [NONE]  
    ********************************************************************/
    public static Sales_Area__c insertSalesArea(String name, String externalKey,String channel, String division, Id territory,Id account)
    {
        Sales_Area__c sales = new Sales_Area__c(Name = name,
                                                External_Key__c = externalKey,
                                                Channel__c = channel,
                                                Division__c = division,
                                                Territory__c = territory,
                                                Account__c = account
        										);
        insert sales;
        return sales;
    }  
     

}