/**********************************************************************
Name: ICB_InventoryProducts_CC_Test
Copyright © 2016 Unilever

Purpose:
Class responsible for test: 
ICB_getProducts_CC.apx
======================================================

History
VERSION AUTHOR    		DATE 		DETAIL 			Description
1.0    Thiago Oliveira 05/08/2016  Class creation  
***********************************************************************/
@isTest
public class ICB_InventoryProducts_CC_Test 
{
    
    private static Account acc;
    private static Contact contact;
    private static User user;
    private static Product2 product;
    private static ICB_Inventory__c inventory2;
    private static ICB_Inventory_Line_Item__c inventoryLineItem;
    private static PriceBookEntry priceBookEntry;

    Static
    {
        acc = new Account();
        contact = new Contact();
        user = new User();
        product = new Product2();
        inventory2 = new ICB_Inventory__c();
        inventoryLineItem = new ICB_Inventory_Line_Item__c();
        priceBookEntry = new PriceBookEntry();
    }
    
	/*******************************************************************
    Purpose: Test the method getProducts, all scenarios
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/    
    static testMethod void ICB_getProducts_Test()
    {
        List<ICB_Inventory_Line_Item__c> inventLine = new List<ICB_Inventory_Line_Item__c>();
        createInstances();
        System.runAs(user)
        {
            ICB_InventoryProducts_CC.getProducts();
            system.assert(inventoryLineItem != null);
        }
        
       inventLine = ICB_InventoryProducts_CC.getProducts();
        system.assert(inventLine.isEmpty());
    }
    /*******************************************************************
    Purpose: Test the method updateOperatorInventory, all scenarios
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/ 
    
    static testMethod void ICB_updateOperatorInventory_Test()
    {
        createInstances();
        List<ICB_Inventory_Line_Item__c> inventLineGetreturnCatch = new List<ICB_Inventory_Line_Item__c>();
        
        ICB_InventoryProducts_CC.updateOperatorInventory( JSON.serializePretty(inventLineGetreturnCatch));
        system.assert(inventLineGetreturnCatch.isEmpty());
       
    }
    /*******************************************************************
    Purpose: Test the method getProductPrice, all scenarios
	Parameters: List<PriceBookEntry>
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/ 
    static testMethod void ICB_getProductPrice_Test()
    {
        List<PriceBookEntry> pbRetrieveList = new List<PriceBookEntry>();
        createInstances();
        System.runAs(user)
        {
            ICB_InventoryProducts_CC.getProductPrice();
            system.assert(priceBookEntry != null);
        }
        pbRetrieveList = ICB_InventoryProducts_CC.getProductPrice();
        system.assert(pbRetrieveList.isEmpty());
        
    }
    /*******************************************************************
    Purpose: Test the method updateValues, all scenarios
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    static testMethod void ICB_updateValues_Test()
    {
        List<PriceBookEntry> listPBUpdate = new List<PriceBookEntry>();
        List<PriceBookEntry> listPBUpdateIf = new List<PriceBookEntry>();
        List<PriceBookEntry> listPBUpdateretriveValue = new List<PriceBookEntry>();
        
        createInstances();
        System.runAs(user)
        {
            listPBUpdate.add(priceBookEntry);
            system.assertNotEquals(null,[SELECT id from PriceBookEntry ORDER BY CreatedDate DESC LIMIT 1]);
            ICB_InventoryProducts_CC.updateValues(listPBUpdate);
        }
        listPBUpdateIf = null;
        listPBUpdateretriveValue =ICB_InventoryProducts_CC.updateValues(listPBUpdateIf);
        system.assert(listPBUpdateretriveValue == null);
    }
    
    /*******************************************************************
    Purpose: Method to instance all objects used for tests
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
     private static void createInstances()
    {
        Id pricebookId = Test.getStandardPricebookId();
        acc = ICB_SobjectInstance_SP2_Test.insertAccount('Catanduva Distribuidora', ICB_RecordTypeMemory.getRecType('Account', 'Standard'));
<<<<<<< HEAD
        contact = ICB_SobjectInstance_SP2_Test.insertContact('Test', ICB_RecordTypeMemory.getRecType(Label.ICB_SOBJECT_CONTACT, Label.ICB_REC_TYPE_STANDARD_CONTACT), acc.Id, '');
        user = ICB_SobjectInstance_SP2_Test.insertUserPartnerCommunity('Partner Community',contact.Id, 'Test','acc','Testac', 'test@accenture.com', 'test@accenture.com.Unilever','testNick');
=======
        contact = ICB_SobjectInstance_SP2_Test.insertContact('Test', ICB_RecordTypeMemory.getRecType(Label.ICB_SOBJECT_CONTACT, Label.ICB_REC_TYPE_STANDARD_CONTACT), String.valueOf(acc.Id), '', 'emailunilever@unilever.com');
        user = ICB_SobjectInstance_SP2_Test.insertUserPartnerCommunity('Partner Community Login User',contact.Id, 'Test','acc','Testac', 'test@accenture.com', 'test@accenture.com.Unilever','testNick');
>>>>>>> develop
        product = ICB_SobjectInstance_SP2_Test.insertProduct2('Frutare Coco', 'impulse', 'Frutare_coco.png');
        inventory2 = ICB_SobjectInstance_SP2_Test.insertInventory('Catanduva Distribuidora');
        inventoryLineItem = ICB_SobjectInstance_SP2_Test.insertInventoryLineItem(product.Id, inventory2.Id,50,10);
        ICB_SobjectInstance_SP2_Test.insertPriceBook2(product.Name);
        priceBookEntry = ICB_SobjectInstance_SP2_Test.insertPriceBookEntry(product.Id,pricebookId);
    }
}