/**********************************************************************
Name: ICB_Cockpit_CC_Test
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Test class for ICB_Cockpit_CC controller class.
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Antonio Raul 22/08/2016  Class creation 
***********************************************************************/
@isTest
public class ICB_Cockpit_CC_Test 
{

    private static Account acc;
    private static Contact contactOperator;
    private static Contact contactSales;
    private static User userOperator;
    private static User userSales;
    private static Product2 product;
    private static ICB_Inventory__c inventory;
    private static PriceBook2 priceBook2;
    private static String statusOpen;
    private static String testeOpp;
    
    Static
    {
        acc = new Account();
        contactOperator = new Contact();
        contactSales = new Contact();
        userOperator = new User();
        userSales = new User();
        product = new Product2();
        inventory = new ICB_Inventory__c();
        priceBook2 = new PriceBook2();
        statusOpen = 'open';
        testeOpp = 'Test Opp';
    }
    /*******************************************************************
    Purpose: Test the initial scenario to operator
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    public static testMethod void initialScenarioOperator_Test()
    {
        System.Test.startTest();
        
        createInstances();  
        System.runAs(userOperator)
        {
            ICB_Cockpit_CC.getContacts(false);
            List<ICB_Wrapper_Cockpit_CC> listWrapper = ICB_Cockpit_CC.getInventories(acc.Name, statusOpen, contactSales.Id);
            
            System.assert(!listWrapper.isEmpty());
            
            for(ICB_Wrapper_Cockpit_CC wrapper : listWrapper)
            {
                System.assertNotEquals(null,wrapper.invetoryItem);
                wrapper.quantity = 50;
                System.assertEquals(null, wrapper.oppItem);
            }
            
            Opportunity opp = ICB_Cockpit_CC.createOpportunity(contactSales.Id, testeOpp, acc.Name, acc.Id, JSON.serializePretty(listWrapper));
            
            System.assertEquals(testeOpp, opp.Name);
            
            ICB_Cockpit_CC.getContacts(false);
            ICB_Cockpit_CC.updateOpportunity(opp, JSON.serializePretty(listWrapper), false);
            
            System.assertEquals('Pending', [Select StageName From Opportunity Order By CreatedDate DESC LIMIT 1].StageName);
            
            ICB_Cockpit_CC.updateOppItem(JSON.serializePretty(listWrapper), statusOpen);
        }
        System.Test.stopTest();
    }
     /*******************************************************************
    Purpose: Test the initial scenario to sales man
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    /*public static testMethod void initialScenarioSales_Test()
    {
        System.Test.startTest();
       
        createInstances();  
        System.runAs(userSales)
        {
            ICB_Cockpit_CC.getContacts(false);
            List<ICB_Wrapper_Cockpit_CC> listWrapper = ICB_Cockpit_CC.getInventories(acc.Name, statusOpen, contactSales.Id);
            
            System.assert(!listWrapper.isEmpty());
            
            for(ICB_Wrapper_Cockpit_CC wrapper : listWrapper)
            {
                System.assertNotEquals(null,wrapper.invetoryItem);
                wrapper.quantity = 50;
                System.assertEquals(null, wrapper.oppItem);
            }
            
            ICB_Cockpit_CC.createOpportunity(contactSales.Id, testeOpp, acc.Name, acc.Id, JSON.serializePretty(listWrapper));
            
            System.assertEquals(testeOpp, [Select Name From Opportunity Order By CreatedDate DESC LIMIT 1].Name);
            
            ICB_Cockpit_CC.getContacts(false);
            Opportunity opp = [Select Id,ICB_OLD_QUANTITY_RETURNED__c,StageName from Opportunity Order by createdDate desc limit 1];
            ICB_Cockpit_CC.updateOpportunity(opp, JSON.serializePretty(listWrapper), false);
            
            System.assertEquals('Pending', [Select StageName From Opportunity Order By CreatedDate DESC LIMIT 1].StageName);
            
            ICB_Cockpit_CC.updateOppItem(JSON.serializePretty(listWrapper), statusOpen);
        }
        System.Test.stopTest();
    }*/
    /*******************************************************************
    Purpose: Test the method getInventories, all scenarios
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    /*public static testMethod void getInventories_Test()
    {
        System.Test.startTest();
        createInstances();  
   
        System.runAs(userOperator)
        {
            List<ICB_Wrapper_Cockpit_CC> listWrapper = ICB_Cockpit_CC.getInventories(acc.Name, statusOpen, contactSales.Id);
            
            System.assert(!listWrapper.isEmpty());
            
            for(ICB_Wrapper_Cockpit_CC wrapper : listWrapper)
            {
                System.assertNotEquals(null,wrapper.invetoryItem);
                wrapper.quantity = 50;
                wrapper.quantityMin = 05;
                System.assertEquals(null, wrapper.oppItem);
            }
            
            ICB_Cockpit_CC.createOpportunity(contactSales.Id, testeOpp, acc.Name, acc.Id, JSON.serializePretty(listWrapper));
            
            //System.assertEquals(testeOpp, [Select Name From Opportunity Order By CreatedDate DESC LIMIT 1].Name);
            
            Opportunity opp = [Select Id,ICB_OLD_QUANTITY_RETURNED__c,StageName from Opportunity Order by createdDate desc limit 1];
            opp.StageName = 'Closed';
            Database.update(opp);
            ICB_Cockpit_CC.updateOpportunity(opp, JSON.serializePretty(listWrapper), true);
            
            System.assertEquals('Closed', [Select StageName From Opportunity Order By CreatedDate DESC LIMIT 1].StageName);
            
            ICB_Cockpit_CC.getContacts(true);
            
            System.assertNotEquals(null,ICB_Cockpit_CC.getInventories(acc.Name, 'closed', contactSales.Id));
            
            OpportunityLineItem oppLineItem = [Select Id,ICB_STATUS_SALES__c,Quantity,ICB_ITEMS_RETURNED__c from OpportunityLineItem Order by createdDate desc limit 1];
            oppLineItem.ICB_STATUS_SALES__c = 'stock';
            Database.update(oppLineItem);
            
            System.assertEquals('stock',oppLineItem.ICB_STATUS_SALES__c);
            System.assertNotEquals(null,ICB_Cockpit_CC.getInventories(acc.Name, statusOpen, contactSales.Id));
            
            oppLineItem.ICB_STATUS_SALES__c = 'sold pending stock';
            Database.update(oppLineItem);
            
            System.assertEquals('sold pending stock',oppLineItem.ICB_STATUS_SALES__c);
            
            ICB_Cockpit_CC.getContacts(false);
            opp.StageName = 'Pending';
            Database.update(opp);
            
            System.assertEquals('Pending', opp.StageName);
            System.assertNotEquals(null,ICB_Cockpit_CC.getInventories(acc.Name, 'Solicitation', contactSales.Id));
            
            opp.StageName = 'Available';
            Database.update(opp);
            
            System.assertEquals('Available', opp.StageName);
            ICB_Cockpit_CC.getInventories(acc.Name, statusOpen, contactSales.Id);
        }
        
        System.Test.stopTest();
    }*/
    /*******************************************************************
    Purpose: Test the method updateOppItem, all scenarios
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    /*public static testMethod void updateOppItem_Test()
    {
        System.Test.startTest();
        
        createInstances();  
        System.runAs(userOperator)
        {
            ICB_Cockpit_CC.getContacts(true);
            List<ICB_Wrapper_Cockpit_CC> listWrapper = ICB_Cockpit_CC.getInventories(acc.Name, 'closed', contactSales.Id);
            
            System.assert(!listWrapper.isEmpty());
            
            for(ICB_Wrapper_Cockpit_CC wrapper : listWrapper)
            {
                System.assertNotEquals(null,wrapper.invetoryItem);
                wrapper.quantity = 30;
                System.assertEquals(null, wrapper.oppItem);
            }
            ICB_Cockpit_CC.createOpportunity(contactSales.Id, testeOpp, acc.Name, acc.Id, JSON.serializePretty(listWrapper));
            
            //System.assertEquals(testeOpp, [Select Name From Opportunity Order By CreatedDate DESC LIMIT 1].Name);
            
            Opportunity opp = [Select Id, ICB_OLD_QUANTITY_RETURNED__c, StageName, Name from Opportunity Order by createdDate desc limit 1];
            opp.StageName = 'Available';
            Database.update(opp);
            
            //System.assertEquals('Available', [Select StageName From Opportunity Order By CreatedDate DESC LIMIT 1].StageName);
            
            ICB_Cockpit_CC.updateOpportunity(opp, JSON.serializePretty(listWrapper), false);
            OpportunityLineItem oppLineItem = [Select Id,ICB_STATUS_SALES__c,Quantity,ICB_ITEMS_RETURNED__c from OpportunityLineItem Order by createdDate desc limit 1];
            oppLineItem.Quantity = 60;
            Database.update(oppLineItem);
            
            //System.assertEquals(60, [Select Quantity From OpportunityLineItem Order By CreatedDate DESC LIMIT 1].Quantity);
            
            ICB_Cockpit_CC.updateOppItem(JSON.serializePretty(listWrapper), 'isClosed');
            ICB_Cockpit_CC.updateOppItem(JSON.serializePretty(listWrapper), '');
        }
        System.Test.stopTest();
    }*/
    /*******************************************************************
    Purpose: Test the methods for the error scenarios
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    /*public static testMethod void error_Test()
    {
        System.Test.startTest();
        
        createInstances();  
        System.runAs(userOperator)
        {
            System.assertNotEquals(null,ICB_Cockpit_CC.getContacts(false));
            
            ICB_Cockpit_CC.createOpportunity(null, testeOpp, null, null, null);
            ICB_Cockpit_CC.updateOpportunity(null,null,false);
            ICB_Cockpit_CC.updateOppItem(null,null);
        }
        System.Test.stopTest();
    }*/
    /*******************************************************************
    Purpose: Method to instance all objects used for tests
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    private static void createInstances()
    {
        acc = ICB_SobjectInstance_SP2_Test.insertAccount('Catanduva Distribuidora', ICB_RecordTypeMemory.getRecType('Account', 'Standard'));
        contactOperator = ICB_SobjectInstance_SP2_Test.insertContact('Test Operator', ICB_RecordTypeMemory.getRecType(Label.ICB_SOBJECT_CONTACT, Label.ICB_REC_TYPE_STANDARD_CONTACT), acc.Id,'Operator');
        contactSales = ICB_SobjectInstance_SP2_Test.insertContact('Test Sales', ICB_RecordTypeMemory.getRecType(Label.ICB_SOBJECT_CONTACT, Label.ICB_REC_TYPE_STANDARD_CONTACT), acc.Id,'Ice Cream Salesman');
        userOperator = ICB_SobjectInstance_SP2_Test.insertUserPartnerCommunity('Partner Community',contactOperator.Id,'Test Operator','User OP','tuop','user.operator@email.com',
                                                                           'user.operator@unilever.com','testOperator');
        userSales = ICB_SobjectInstance_SP2_Test.insertUserPartnerCommunity('Partner Community',contactSales.Id,'Test Sales','User SL','tusl','user.sales@email.com',
                                                                           'user.sales@unilever.com','testSales');
        
        product = ICB_SobjectInstance_SP2_Test.insertProduct2('Frutare Coco', 'impulse', 'Frutare_coco.png');
        inventory = ICB_SobjectInstance_SP2_Test.insertInventory('Catanduva Distribuidora');
        ICB_SobjectInstance_SP2_Test.insertInventoryLineItem(product.Id, inventory.Id,50,10);
        String priceBook2Id = Test.getStandardPricebookId();
        ICB_SobjectInstance_SP2_Test.insertPriceBookEntry(product.Id,priceBook2Id);
        priceBook2 = ICB_SobjectInstance_SP2_Test.insertPriceBook2(product.Name);
        ICB_SobjectInstance_SP2_Test.insertPriceBookEntry(product.Id,priceBook2.Id);
       
    }
}