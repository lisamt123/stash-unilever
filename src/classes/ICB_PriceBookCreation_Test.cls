@isTest
public class ICB_PriceBookCreation_Test {

private static Account acc;
    private static Contact contact;
    private static User user;
    private static Product2 product;
    private static product2 products2;
    private static ICB_Inventory__c inventory2;
    private static ICB_Inventory_Line_Item__c inventoryLineItem;
    private static PriceBook2 priceBook2;
    private static PriceBookEntry priceBookEntry;

    
    Static
    {
        acc = new Account();
        contact = new Contact();
        user = new User();
        product = new Product2();
        inventory2 = new ICB_Inventory__c();
        inventoryLineItem = new ICB_Inventory_Line_Item__c();
        priceBook2 = new PriceBook2();
        priceBookEntry = new PriceBookEntry();
    }   
	
     static testMethod void ICB_changeProductStructure_test()
    {
        System.Test.startTest();
        createInstances();
        List<id> ids = new List<id>();
        List<id> ids2 = new List<id>(); 
        ids.add(products2.id);
        ids2.add(product.id);
        system.debug('priceBook2:'+ priceBook2);
        ICB_PriceBookCreation.changeProductStructure(ids);
        
        ICB_PriceBookCreation.changeProductStructure(ids2);
        
        
        /*
        String idProd;
        for(Product2 prod: vProducts){
            idProd = prod.id;
        }
        
        ICB_Inventory__c Inventory = new ICB_Inventory__c(); 
        ICB_Inventory_Line_Item__c iventoryLine = new ICB_Inventory_Line_Item__c();
        
        Inventory.Name = 'Inventory';
        database.insert(Inventory);
        
        iventoryLine.ICB_Product__c = idProd;
        iventoryLine.ICB_Inventory__c = Inventory.id;
        iventoryLine.ICB_Quantity_Boxes__c = 2;
        iventoryLine.ICB_Quantity_Unit__c = 1;
        iventoryLine.ICB_Active__c = true;
        
        database.insert(iventoryLine);
        for(Database.SaveResult savedResult : srList) {
            if(savedResult.isSuccess()) {
                system.debug('TESTE ID\'s: ' + savedResult.getId());
            }
        }
		
        
       
        //Database.update(inactiveProduct);
        */
         System.Test.stopTest();
    }
    
    static testMethod void ICB_changeProductStructure2_test()
    {
        ICB_PriceBookCreation Price= new ICB_PriceBookCreation();
        List<id> ids2 = new List<id>();
        Product2[] vProducts = new List<Product2> {new Product2(Name = 'Frutare Manga',
                                                                Family = 'Impulse',
                                                                IsActive = true), new Product2(Name = 'Frutare Test',
                                                                                               Family = 'Impulse',
                                                                                               IsActive = false) };
                                                                                                   
                                                                                                   
                                                                                                   
        Database.SaveResult[] srList = Database.insert(vProducts, false);
        ids2.add(null);
        ICB_PriceBookCreation.changeProductStructure(ids2);
        
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
        user = ICB_SobjectInstance_SP2_Test.insertUserPartnerCommunity('Partner Community',contact.Id, 'Test','acc','Testac', 'test@accenture.com', 'test@accenture.com.Unilever','testNick');
        product = ICB_SobjectInstance_SP2_Test.insertProduct2('Frutare Coco', 'impulse', 'Frutare_coco.png');
        products2 = ICB_SobjectInstance_SP2_Test.insertProduct2('Magnum', 'impulse', 'Magnum.png');
        inventory2 = ICB_SobjectInstance_SP2_Test.insertInventory('Catanduva Distribuidora');
        inventoryLineItem = ICB_SobjectInstance_SP2_Test.insertInventoryLineItem(product.Id, inventory2.Id,50,10);
        priceBook2 = ICB_SobjectInstance_SP2_Test.insertPriceBook2(product.Name);
        priceBookEntry = ICB_SobjectInstance_SP2_Test.insertPriceBookEntry(product.Id,pricebookId);
        ICB_SobjectInstance_SP2_Test.insertPriceBookEntry(product.Id,priceBook2.id);
        
        
        
    }
    
}