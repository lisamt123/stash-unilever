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
public class ICB_SobjectInstance_SP2_Test 
{
     
    /*******************************************************************
    Purpose: Insert Account for using in test methods of classes: 
			 ICB_Cockpit_CC_Test,
			 ICB_PhotoMobileChannel_Batch_Test,
			 ICB_ContactPartnerUserCreation_Test,
			 ICB_PartnerUserCreation_BatchSch_Test,
			 ICB_PhotoMobileChannel_Batch_Test,
			 ICB_SetupPhotoMobileChannel_Test
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
	Purpose: Insert Contact for using in test methods of classes: 
			 ICB_Cockpit_CC_Test,
			 ICB_PhotoMobileChannel_Batch_Test,
			 ICB_ContactPartnerUserCreation_Test,
			 ICB_PartnerUserCreation_BatchSch_Test,
			 ICB_PhotoMobileChannel_Batch_Test,
			 ICB_SetupPhotoMobileChannel_Test
    Parameters: Name, recordTypeId,accountId
    Returns: [Account]
    Throws [Exceptions]: [NONE]  
    ********************************************************************/
    public static Contact insertContact(String lastName, String recordTypeId, String accountId, String IcbType, String email)
    {
        Contact contact = new Contact(LastName = lastName,
                                      RecordTypeId = recordTypeId,
                                      AccountId = accountId,
                                      ICB_Type__c = IcbType,
                                      Email = email
                                     );
        insert contact;
        return contact;
    }
        
    /*******************************************************************
    Purpose: Insert User for using in test methods of classes: 
			 ICB_Cockpit_CC_Test,
			 ICB_PhotoMobileChannel_Batch_Test,
			 ICB_SetupPhotoMobileChannel_Test
    Parameters: [NONE]
    Returns: User
    Throws [Exceptions]: [NONE] 
    ********************************************************************/
    public static User insertUserPartnerCommunity(String profileName,String contactId,String firstName, String lastName, String alias,String email,String userName,String nickName)
    {
        String profile2 = 'Partner Community Login Basic';
        Profile profile = [Select Id From Profile Where Name =: profileName OR Name=: profile2 LIMIT 1];
        User user = new User(FirstName = firstName,
                             LastName = lastName,
                             Alias = alias,
                             Email = email,
                             UserName = userName,
                             CommunityNickname = nickName,
                             TimeZoneSidKey = 'America/Los_Angeles',
                             LocaleSidKey = 'en_US',
                             EmailEncodingKey = 'UTF-8',
                             LanguageLocaleKey='en_US',
                             ProfileId = profile.id,
                             ContactId = contactId
                            );
        insert user;
        return user;
    }
    /*******************************************************************
    Purpose: Insert Product2 for using in test methods of classes: ICB_Cockpit_CC_Test
    Parameters: [NONE]
    Returns: User
    Throws [Exceptions]: [NONE] 
    ********************************************************************/
    public static Product2 insertProduct2(String name,String family,String image)
    {
        Product2 product = new Product2(Name = name, Family = family,Product_Image__c = image,isActive=true,ICB_Price__c = 3.60);
        insert product;
        return product;
    }
    /*******************************************************************
    Purpose: Insert ICB_Inventory__c for using in test methods of classes: ICB_Cockpit_CC_Test
    Parameters: [NONE]
    Returns: User
    Throws [Exceptions]: [NONE] 
    ********************************************************************/
    public static ICB_Inventory__c insertInventory(String name)
    {
        ICB_Inventory__c inventory = new ICB_Inventory__c(Name = name);
        insert inventory;
        return inventory;
    }
    /*******************************************************************
    Purpose: Insert ICB_Inventory_Line_Item__c for using in test methods of classes: ICB_Cockpit_CC_Test
    Parameters: [NONE]
    Returns: User
    Throws [Exceptions]: [NONE] 
    ********************************************************************/
    public static ICB_Inventory_Line_Item__c insertInventoryLineItem(String productId, String inventoryId,Decimal quantityUnit,Decimal quantityBoxes)
    {
        ICB_Inventory_Line_Item__c inventoryLineItem = new ICB_Inventory_Line_Item__c(	ICB_Product__c = productId,
                                                                                        ICB_Inventory__c = inventoryId,
                                                                                        ICB_Quantity_Unit__c = quantityUnit,
                                                                                        ICB_Quantity_Boxes__c = quantityBoxes,
                                                                                     	ICB_Quantity_ToBe_Updated__c = 1);
        insert inventoryLineItem;
        return inventoryLineItem;
    }
    /*******************************************************************
    Purpose: Insert PriceBook2 for using in test methods of classes: ICB_Cockpit_CC_Test
    Parameters: [NONE]
    Returns: User
    Throws [Exceptions]: [NONE] 
    ********************************************************************/
    public static PriceBook2 insertPriceBook2(String name)
    {
        PriceBook2 priceBook2 = new PriceBook2(Name = name,isActive = true);
        insert priceBook2;
        return priceBook2;
    }
    /*******************************************************************
    Purpose: Insert PriceBookEntry for using in test methods of classes: ICB_Cockpit_CC_Test
    Parameters: [NONE]
    Returns: User
    Throws [Exceptions]: [NONE] 
    ********************************************************************/
    public static PriceBookEntry insertPriceBookEntry(String productId, String priceBook2Id)
    {
        PriceBookEntry priceBookEntry = new PriceBookEntry(Product2Id = productId,
                                                           PriceBook2Id = priceBook2Id,
                                                           UnitPrice = 3.90,
                                                           UseStandardPrice = false,
                                                           isActive=true,
                                                           ICB_Purchase_Price__c = 4,
                                                           ICB_Manufacture_Price__c = 4);
        insert priceBookEntry;
        return priceBookEntry;
    }
  
     /*******************************************************************
    Purpose: Insert ICB_ContactTypes__c for using in test methods of classes: 
			 ICB_ContactPartnerUserCreation_Test,
		     ICB_PartnerUserCreation_BatchSch_Test
    Parameters: [NONE]
    Returns: FeedItem
    Throws [Exceptions]: [NONE] 
    ********************************************************************/
    public static ICB_ContactTypes__c insertContactTypes(String name, String value)
    {
        ICB_ContactTypes__c types = new ICB_ContactTypes__c(Name = name, Value__c = value);
        insert types;
        return types;
    }
}