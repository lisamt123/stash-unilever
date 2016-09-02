/**********************************************************************
Name: ICB_SetupPhotoMobileChannel_Test
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Class responsible for test: ICB_SetupPhotoMobileChannel.apx AND ICB_FeedItemMobileChannel.trigger.
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
1.1    Antonio Raul 	25/08/2016  Class Updated
1.0	   Thiago Oliveira 	25/08/2016  Class Created
***********************************************************************/
@isTest
public class ICB_SetupPhotoMobileChannel_Test 
{
    private static Account acc;
    private static Contact contact;
    private static User user;
    
    Static
    {
        acc = new Account();
        contact = new Contact();
        user = new User();
    }
    /*******************************************************************
    Purpose: Method for test ICB_SetupPhotoMobileChannel
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    static testMethod void changePhoto_Test()
    {
        createInstances();
         System.runAs(user)
        {
            List<FeedItem> FeedList = new List<FeedItem>();
            FeedItem Feed = new FeedItem();
            Feed.ParentId = acc.id;
            Feed.body = '#foto';
            FeedList.add(Feed);
            database.insert(FeedList);
            
            System.assertNotEquals(null, [Select id from FeedItem Where Id =: Feed.Id]);
            
            ICB_SetupPhotoMobileChannel Stmobile = new ICB_SetupPhotoMobileChannel();
            Stmobile.changePhoto(FeedList); 
        }
        
    } 
    /*******************************************************************
    Purpose: Method to instance all objects used for tests
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    private static void createInstances()
    {
        acc = ICB_SobjectInstance_SP2_Test.insertAccount('Catanduva Distribuidora', ICB_RecordTypeMemory.getRecType('Account', 'Standard'));
        contact = ICB_SobjectInstance_SP2_Test.insertContact('Test', ICB_RecordTypeMemory.getRecType(Label.ICB_SOBJECT_CONTACT, Label.ICB_REC_TYPE_STANDARD_CONTACT), acc.Id, '','test@email.com');
        user = ICB_SobjectInstance_SP2_Test.insertUserPartnerCommunity('Partner Community',contact.Id, 'Test','acc','Testac', 'test@accenture.com', 'test@accenture.com.Unilever','testNick');
    }
}