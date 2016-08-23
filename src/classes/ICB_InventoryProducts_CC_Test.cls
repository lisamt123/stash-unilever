/**********************************************************************
Name: ICB_InventoryProducts_CC_Test
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Class responsible for test: 
ICB_getProducts_CC.apx
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
1.0    Thiago Oliveira 05/08/2016  Class creation  
***********************************************************************/
@IsTest
public class ICB_InventoryProducts_CC_Test 
{
    
    static testMethod void ICB_getProducts_Test()
    {
        /*
        account acc = new account();
        acc.name = 'Testeacc';
        database.insert(acc);
        
        
        contact cont = new contact(FirstName = 'FirstTest',
                                   LastName = 'LastTest',
                                   title = 'Operador',
                                   phone ='9999-9999',
                                   email = 'PartnerCommunity@testaccenture.com',
                                   accountId = acc.id
                                  );
        database.insert(cont);
        
     	system.debug('cont:'+ cont.id);
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'Partner' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='Partner Community']; 
        User u = new User(Alias = 'System', Email='PartnerCommunity@testaccenture.com',
                          ContactId = cont.Id,
                          UserRoleId = portalRole.Id,
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='PartnerCommunity@testaccenture.com'
                         );
        
       
        User user = new User();
        System.runAs(new User(Id = UserInfo.getUserId())) {
            database.insert(u);
        }        
       */
        
		
        
        User user1 = [select id, ContactId from user where ContactId != null Limit 1];
       
        
       
        /*
        ICB_Inventory__c inventory = new ICB_Inventory__c(Name = acc.Name);
        
        database.insert(inventory);
        
        product2 prod = new product2(Name ='ProdTest',ICB_Reference_Unit__c = 100.10, Product_Image__c= 'Frutare_coco', Family = 'Impulse');
        
        database.insert(prod);
        
        ICB_Inventory_Line_Item__c inventLine = new ICB_Inventory_Line_Item__c(ICB_Quantity_Unit__c = 10,
                                                                               ICB_Quantity_Boxes__c = 2,
                                                                               ICB_Sales_Price__c = 100,
                                                                               ICB_Quantity_ToBe_Updated__c = 2,
                                                                               ICB_Inventory__c = inventory.id,
                                                                               ICB_Product__c = prod.id);
        database.insert(inventLine);
        */
        Test.startTest();
            ICB_InventoryProducts_CC.getProducts();
        Test.stopTest();
        
    }
    static testMethod void ICB_updateOperatorInventory_Test(){
        
        ICB_Inventory__c inventory = new ICB_Inventory__c(Name ='Test');
        
        database.insert(inventory);
        
        product2 prod = new product2(Name ='ProdTest',ICB_Reference_Unit__c = 100, Product_Image__c= 'Frutare_coco', Family = 'Impulse');
        
        database.insert(prod);
        
       List<ICB_Inventory_Line_Item__c> inventLine = new List<ICB_Inventory_Line_Item__c>();
        List<ICB_Inventory_Line_Item__c> inventLineCatch = new List<ICB_Inventory_Line_Item__c>();
       ICB_Inventory_Line_Item__c inventoryLine = new ICB_Inventory_Line_Item__c( ICB_Quantity_Unit__c = 10,
                                                                               ICB_Quantity_Boxes__c = 2,
                                                                               ICB_Sales_Price__c = 100,
                                                                               ICB_Quantity_ToBe_Updated__c = 2,
                                                                               ICB_Inventory__c = inventory.id,
                                                                               ICB_Product__r = prod);
       
        inventLine.add(inventoryLine);
        database.insert(inventLine);
        system.debug('@@@:'+inventLine.get(0).ICB_Product__r.ICB_Reference_Unit__c);
        ICB_InventoryProducts_CC.updateOperatorInventory(inventLine);
        
        
        for(ICB_Inventory_Line_Item__c inv: inventLine){
            inv.ICB_Product__r = null;
            inventLineCatch.add(inv);
        }
        
        ICB_InventoryProducts_CC.updateOperatorInventory(inventLineCatch);
    }
    
}