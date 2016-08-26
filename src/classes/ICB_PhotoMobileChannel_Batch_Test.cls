/**********************************************************************
Name: ICB_PhotoMobileChannel_Batch_Test
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Class responsible for test: ICB_PhotoMobileChannel_Batch.
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Antonio Raul 25/08/2016  Class creation  
***********************************************************************/
@IsTest
public class ICB_PhotoMobileChannel_Batch_Test
{

    private static Account acc;
    private static Contact contactOperator;
    private static Contact contactSales;
    private static User userOperator;
    private static User userSales;
    private static FeedItem feedSales;
    private static ContentVersion contentSales;
    private static ICB_Setup_Photo__c setupPhoto;
    
     Static
    {
        acc = new Account();
        contactOperator = new Contact();
        contactSales = new Contact();
        userOperator = new User();
        userSales = new User();
        feedSales = new FeedItem();
        contentSales = new ContentVersion();
        setupPhoto = new ICB_Setup_Photo__c();
    }
    /*******************************************************************
    Purpose: Method for test batch ICB_PhotoMobileChannel_Batch
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    public static testMethod void icb_PhotoMobileChannel_Batch_Test()
    {
        createInstances();
        System.Test.startTest();
        
        System.assertNotEquals(null, [Select Id From ICB_Setup_Photo__c]);
        ICB_PhotoMobileChannel_Batch batch = new ICB_PhotoMobileChannel_Batch();
        Id batchId = Database.executeBatch(batch);
        System.assert(batchId != null);
        
        System.Test.stopTest();
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
        contactSales = ICB_SobjectInstance_SP2_Test.insertContact('Test Sales', ICB_RecordTypeMemory.getRecType(Label.ICB_SOBJECT_CONTACT, Label.ICB_REC_TYPE_STANDARD_CONTACT), acc.Id,'Ice Cream Salesman');
        userSales = ICB_SobjectInstance_SP2_Test.insertUserPartnerCommunity('Partner Community',contactSales.Id,'Test Sales','User SL','tusl','user.sales@email.com',
                                                                           'user.sales@unilever.com','testSales');
        contentSales = ICB_SobjectInstance_SP2_Test.insertContentVersionFeedItem('Test', 'test.png', Blob.valueOf('Test'));
        feedSales = ICB_SobjectInstance_SP2_Test.insertFeedItem(contactSales.Id, contentSales.Id, '#foto');
        setupPhoto = ICB_SobjectInstance_SP2_Test.insertSetupPhoto(feedSales);
    }
}