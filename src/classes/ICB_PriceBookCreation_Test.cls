@isTest
public class ICB_PriceBookCreation_Test {

    private static Account acc;
    private static Contact contact;
    private static Product2 product;
    private static product2 products2;
    private static ICB_Inventory__c inventory2;
    private static PriceBook2 priceBook2;
    
    Static
    {
        acc = new Account();
        contact = new Contact();
        product = new Product2();
        inventory2 = new ICB_Inventory__c();
        priceBook2 = new PriceBook2();
    }   
    
	/*******************************************************************
    Purpose: Test the method ICB_changeProductStructure, with pricebbok
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
     static testMethod void ICB_changeProductStructure_test()
    {
        System.Test.startTest();
        createInstances();
        List<id> ids = new List<id>();
        List<id> ids2 = new List<id>(); 
        ids.add(products2.id);
        ids2.add(product.id);
        
        ICB_PriceBookCreation.changeProductStructure(ids);
        system.assert(product.IsActive);
        ICB_PriceBookCreation.changeProductStructure(ids2);
        system.assert(products2.IsActive);
         System.Test.stopTest();
    }
    
    /*******************************************************************
    Purpose: Test the method ICB_changeProductStructure, whitout pricebook
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/   
    static testMethod void ICB_changeProductStructure2_test()
    {
        List<id> ids2 = new List<id>();
        Product2 vProducts = new Product2(Name = 'Frutare Manga', Family = 'Impulse');                                                      
        Database.insert(vProducts);
        ids2.add(null);
        ICB_PriceBookCreation.changeProductStructure(ids2);
        system.assert(!vProducts.IsActive);
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
        contact = ICB_SobjectInstance_SP2_Test.insertContact('Test', ICB_RecordTypeMemory.getRecType(Label.ICB_SOBJECT_CONTACT, Label.ICB_REC_TYPE_STANDARD_CONTACT), acc.Id, '');
        ICB_SobjectInstance_SP2_Test.insertUserPartnerCommunity('Partner Community',contact.Id, 'Test','acc','Testac', 'test@accenture.com', 'test@accenture.com.Unilever','testNick');
        product = ICB_SobjectInstance_SP2_Test.insertProduct2('Frutare Coco', 'impulse', 'Frutare_coco.png');
        products2 = ICB_SobjectInstance_SP2_Test.insertProduct2('Magnum', 'impulse', 'Magnum.png');
        inventory2 = ICB_SobjectInstance_SP2_Test.insertInventory('Catanduva Distribuidora');
        ICB_SobjectInstance_SP2_Test.insertInventoryLineItem(product.Id, inventory2.Id,50,10);
        priceBook2 = ICB_SobjectInstance_SP2_Test.insertPriceBook2(product.Name);
        ICB_SobjectInstance_SP2_Test.insertPriceBookEntry(product.Id,pricebookId);
        ICB_SobjectInstance_SP2_Test.insertPriceBookEntry(product.Id,priceBook2.id);   
    }   
}