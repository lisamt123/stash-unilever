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
public class ICB_SobjectInstance_Test {
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
    public static User insertUser(String profileName, String firstName, String lastName,
                                  String alias, String email, String userName, String communityNickName,
                                  String timeZoneSidKey, String localeSidKey, String emailEncodingKey,
                                  String languageLocaleKey)
    {
        Profile profile = [Select Id From Profile Where Name =: profileName];
        User user = new User(FirstName = firstName,
                             LastName = lastName,
                             Alias = alias,
                             Email = email,
                             UserName = userName,
                             CommunityNickname = communityNickName,
                             TimeZoneSidKey = timeZoneSidKey,
                             LocaleSidKey = localeSidKey,
                             EmailEncodingKey = emailEncodingKey,
                             LanguageLocaleKey=languageLocaleKey,
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
    public static ICB_Territory_Management__c insertTerritory(Id userId,String name, String code)
    {
        ICB_Territory_Management__c territory = new ICB_Territory_Management__c(Name = name,
                                                                                SetupOwnerId = userId,
                                                                                ICB_Territory_Code__c = code 
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
    public static ContentVersion insertContentVersion(ICB_Territory_Management__c territory)
    {
        ContentVersion doc = new ContentVersion(Title = territory.ICB_Territory_Code__c,
                                                PathOnClient = territory.ICB_Territory_Code__c,
                                                VersionData = Blob.valueOf(territory.ICB_Territory_Code__c)
                                               );
        insert doc;
        return doc;
    }
}