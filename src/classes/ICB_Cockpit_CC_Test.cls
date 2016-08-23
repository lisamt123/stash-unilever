@isTest(seeAllData=true)
public class ICB_Cockpit_CC_Test 
{

    private static Account acc;
    private static Contact contact;
    private static User user;
    private static Product2 product;
    private static ICB_Inventory__c inventory;
    private static ICB_Inventory_Line_Item__c inventoryLineItem;
    private static PriceBook2 priceBook2;
    private static PriceBookEntry priceBookEntry;
    private static String inventoryList;
    
    Static
    {
        acc = new Account();
        contact = new Contact();
        user = new User();
        product = new Product2();
        inventory = new ICB_Inventory__c();
        inventoryLineItem = new ICB_Inventory_Line_Item__c();
        priceBook2 = new PriceBook2();
        priceBookEntry = new PriceBookEntry();
        inventoryList = '';
    }
    
    public static testMethod void initialScenario_Test()
    {
        System.Test.startTest();
        createInstances();
        System.runAs(user)
        {
            ICB_Cockpit_CC.getContacts(false);
            List<ICB_Wrapper_Cockpit_CC> listWrapper = ICB_Cockpit_CC.getInventories(acc.Name, 'open', contact.Id);
            for(ICB_Wrapper_Cockpit_CC wrapper : listWrapper)
            {
                wrapper.quantity = 50;
            }
            ICB_Cockpit_CC.createOpportunity(contact.Id, 'Test Opp', acc.Name, acc.Id, JSON.serializePretty(listWrapper));
            ICB_Cockpit_CC.getContacts(false);
            Opportunity opp = [Select Id,ICB_OLD_QUANTITY_RETURNED__c,StageName from Opportunity Order by createdDate desc limit 1];
            ICB_Cockpit_CC.updateOpportunity(opp, JSON.serializePretty(listWrapper), false);
            ICB_Cockpit_CC.updateOppItem(JSON.serializePretty(listWrapper), 'open');
        }
        System.Test.stopTest();
    }
    public static testMethod void getInventories_Test()
    {
        System.Test.startTest();
        createInstances();
        System.runAs(user)
        {
            List<ICB_Wrapper_Cockpit_CC> listWrapper = ICB_Cockpit_CC.getInventories(acc.Name, 'open', contact.Id);
            for(ICB_Wrapper_Cockpit_CC wrapper : listWrapper)
            {
                wrapper.quantity = 50;
            }
            ICB_Cockpit_CC.createOpportunity(contact.Id, 'Test Opp', acc.Name, acc.Id, JSON.serializePretty(listWrapper));
            Opportunity opp = [Select Id,ICB_OLD_QUANTITY_RETURNED__c,StageName from Opportunity Order by createdDate desc limit 1];
            opp.StageName = 'Closed';
            Database.update(opp);
            ICB_Cockpit_CC.updateOpportunity(opp, JSON.serializePretty(listWrapper), true);
            ICB_Cockpit_CC.getContacts(true);
            ICB_Cockpit_CC.getInventories(acc.Name, 'closed', contact.Id);
            OpportunityLineItem oppLineItem = [Select Id,ICB_STATUS_SALES__c,Quantity,ICB_ITEMS_RETURNED__c from OpportunityLineItem Order by createdDate desc limit 1];
            oppLineItem.ICB_STATUS_SALES__c = 'stock';
            Database.update(oppLineItem);
            ICB_Cockpit_CC.getInventories(acc.Name, 'open', contact.Id);
            oppLineItem.ICB_STATUS_SALES__c = 'sold pending stock';
            Database.update(oppLineItem);
            ICB_Cockpit_CC.getInventories(acc.Name, 'open', contact.Id);
            oppLineItem.ICB_STATUS_SALES__c = 'sold pending stock';
            Database.update(oppLineItem);
            opp.StageName = 'Pending';
            Database.update(opp);
            ICB_Cockpit_CC.getInventories(acc.Name, 'Solicitation', contact.Id);
            opp.StageName = 'Available';
            Database.update(opp);
            ICB_Cockpit_CC.getInventories(acc.Name, 'open', contact.Id);
        }
        System.Test.stopTest();
    }
   /* public static testMethod void updateOppItem_Test()
    {
        System.Test.startTest();
        createInstances();
        System.runAs(user)
        {
            List<ICB_Wrapper_Cockpit_CC> listWrapper = ICB_Cockpit_CC.getInventories(acc.Name, 'closed', contact.Id);
            for(ICB_Wrapper_Cockpit_CC wrapper : listWrapper)
            {
                wrapper.quantity = 30;
            }
            ICB_Cockpit_CC.createOpportunity(contact.Id, 'Test Opp', acc.Name, acc.Id, JSON.serializePretty(listWrapper));
            Opportunity opp = [Select Id,ICB_OLD_QUANTITY_RETURNED__c,StageName from Opportunity Order by createdDate desc limit 1];
            opp.StageName = 'Closed';
            Database.update(opp);
            ICB_Cockpit_CC.updateOpportunity(opp, JSON.serializePretty(listWrapper), true);
            OpportunityLineItem oppLineItem = [Select Id,ICB_STATUS_SALES__c,Quantity,ICB_ITEMS_RETURNED__c from OpportunityLineItem Order by createdDate desc limit 1];
            oppLineItem.Quantity = 60;
            Database.update(oppLineItem);
            System.debug('PASSOU DO UPDATE ##### + ' + JSON.serializePretty(listWrapper));
            ICB_Cockpit_CC.updateOppItem(JSON.serializePretty(listWrapper), 'isClosed');
            System.debug('PASSOU DO METODO #####');
        }
        System.Test.stopTest();
    }*/
    public static testMethod void error_Test()
    {
        createInstances();
        ICB_Cockpit_CC.getContacts(false);
        List<ICB_Wrapper_Cockpit_CC> listWrapper = ICB_Cockpit_CC.getInventories(acc.Name, 'open', contact.Id);
        for(ICB_Wrapper_Cockpit_CC wrapper : listWrapper)
        {
            wrapper.quantity = 50;
        }
        ICB_Cockpit_CC.createOpportunity(null, 'Test Opp', null, null, null);
    }
    private static void createInstances()
    {
        acc = ICB_SobjectInstance_Test.insertAccount('Catanduva Distribuidora', ICB_RecordTypeMemory.getRecType('Account', 'Standard'));
        contact = ICB_SobjectInstance_Test.insertContact('Test', ICB_RecordTypeMemory.getRecType(Label.ICB_SOBJECT_CONTACT, Label.ICB_REC_TYPE_STANDARD_CONTACT), acc.Id);
        user = ICB_SobjectInstance_Test.insertUserPartnerCommunity('Partner Community',contact.Id);
        product = ICB_SobjectInstance_Test.insertProduct2('Frutare Coco', 'impulse', 'Frutare_coco.png');
        inventory = ICB_SobjectInstance_Test.insertInventory('Catanduva Distribuidora');
        inventoryLineItem = ICB_SobjectInstance_Test.insertInventoryLineItem(product.Id, inventory.Id,50,10);
        priceBook2 = ICB_SobjectInstance_Test.insertPriceBook2(product.Name);
        priceBookEntry = ICB_SobjectInstance_Test.insertPriceBookEntry(product.Id,priceBook2.Id);
       
    }
}