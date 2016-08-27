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
    private static Contact contactSales;
    private static FeedItem feedSales;
    private static ContentVersion contentSales;
    
     Static
    {
        acc = new Account();
        contactSales = new Contact();
        feedSales = new FeedItem();
        contentSales = new ContentVersion();
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
        ICB_SobjectInstance_SP2_Test.insertUserPartnerCommunity('Partner Community',contactSales.Id,'Test Sales','User SL','tusl','user.sales@email.com',
                                                                           'user.sales@unilever.com','testSales');
        contentSales = insertContentVersionFeedItem('Test', 'test.png', Blob.valueOf('Test'));
        feedSales = insertFeedItem(contactSales.Id, contentSales.Id, '#foto');
        insertSetupPhoto(feedSales);
    }
      /*******************************************************************
    Purpose: Insert ContentVersion for using in test methods of classes: ICB_PhotoMobileChannel_Batch_Test
    Parameters: [NONE]
    Returns: ContentVersion
    Throws [Exceptions]: [NONE] 
    ********************************************************************/
    public static ContentVersion insertContentVersionFeedItem(String title, String pathOnClient, Blob versionData)
    {
        ContentVersion content = new ContentVersion(Title = title,
                                                   	PathOnClient = pathOnClient,
                                                    VersionData = versionData);
        insert content;
        return content;
    }
    /*******************************************************************
    Purpose: Insert FeedItem for using in test methods of classes: ICB_PhotoMobileChannel_Batch_Test
    Parameters: [NONE]
    Returns: FeedItem
    Throws [Exceptions]: [NONE] 
    ********************************************************************/
    public static FeedItem insertFeedItem(Id parentId, Id relatedRecordId, String body)
    {
        FeedItem feed = new FeedItem(ParentId = parentId,
                                     RelatedRecordId = relatedRecordId,
                                     Body = body);
        insert feed;
        return feed;
    }
    /*******************************************************************
    Purpose: Insert ICB_Setup_Photo__c for using in test methods of classes: ICB_PhotoMobileChannel_Batch_Test
    Parameters: [NONE]
    Returns: FeedItem
    Throws [Exceptions]: [NONE] 
    ********************************************************************/
    public static ICB_Setup_Photo__c insertSetupPhoto(FeedItem feed)
    {
        ICB_Setup_Photo__c setupPhotoInstance = new ICB_Setup_Photo__c(ICB_Parent_Id__c = feed.ParentId,
                                                               ICB_Related_Record_Id__c = feed.RelatedRecordId);
        insert setupPhotoInstance;
        return setupPhotoInstance;
    }
}