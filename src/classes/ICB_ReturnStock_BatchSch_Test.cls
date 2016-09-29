/**********************************************************************
Name: ICB_ReturnStock_BatchSch_Test
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Test class for ICB_ReturnStock_BacthSchedule.
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Antonio Raul 	26/08/2016  Class creation 
***********************************************************************/
@isTest
public class ICB_ReturnStock_BatchSch_Test 
{
  
    /*******************************************************************
    Purpose: Test class ICB_ReturnStock
	Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]
    ********************************************************************/
    public static testMethod void myUniTest()
    {
        String cronExp = '0 0 0 15 12 ? 2050';
        createInstances();
        System.Test.startTest();
        
        String jobId = System.schedule('ICB_ReturnStock_BacthSchedule_TestClass', cronExp, new ICB_ReturnStock_BacthSchedule());
        
        CronTrigger cronTrigger = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id =: jobId];
        
        System.assertEquals(jobId, cronTrigger.Id);
        System.assertEquals(cronExp, cronTrigger.CronExpression);
        System.assertEquals(0, cronTrigger.TimesTriggered);
        System.assertEquals('2050-12-15 00:00:00', String.valueOf(CronTrigger.NextFireTime));
        
        System.Test.stopTest();
    }
    /*******************************************************************
    Purpose: Method to instance all objects used for tests
    Parameters: [NONE]
    Returns: [Opportunity]
    Throws [Exceptions]: [NONE]
    ********************************************************************/
    private static void createInstances()
    {
        Account acc = ICB_SobjectInstance_SP2_Test.insertAccount('Catanduva Distribuidora', ICB_RecordTypeMemory.getRecType('Account', 'Standard'));
        System.assertNotEquals(null,acc);
        Product2 product = ICB_SobjectInstance_SP2_Test.insertProduct2('Frutare Coco', 'impulse', 'Frutare_coco.png');
        System.assertNotEquals(null,product);
        ICB_Inventory__c inventory = ICB_SobjectInstance_SP2_Test.insertInventory(acc.Name);
        System.assertNotEquals(null,inventory);
        ICB_Inventory_Line_Item__c ivtLineItem = ICB_SobjectInstance_SP2_Test.insertInventoryLineItem(product.Id,inventory.Id,20,20);
        System.assertNotEquals(null,ivtLineItem);
        String priceBook2Id = Test.getStandardPricebookId();
        PriceBookEntry price = ICB_SobjectInstance_SP2_Test.insertPriceBookEntry(product.Id,priceBook2Id);
        System.assertNotEquals(null,price);
        Opportunity opp = insertOpp(acc.Id);
        insertOppLineItem(opp.Id,price.Id);
        insertOppLineItem(opp.Id,price.Id);
    }
    /*******************************************************************
    Purpose: Method to create instance Opportunity objects used for tests
    Parameters: [NONE]
    Returns: [Opportunity]
    Throws [Exceptions]: [NONE]
    ********************************************************************/
    private static Opportunity insertOpp(String accountId)
    {
        Opportunity opp = new Opportunity(Name = 'Test Opp',
                                          AccountId = accountId,
                                          OwnerId = UserInfo.getUserId(),
                                          StageName = 'Closed',
                                          CloseDate = System.today());
        insert opp;
        return opp;
    }
    /*******************************************************************
    Purpose: Method to create instance Opportunity Line Items objects used for tests
    Parameters: [NONE]
    Returns: [OpportunityLineItem]
    Throws [Exceptions]: [NONE]
    ********************************************************************/
    private static OpportunityLineItem insertOppLineItem(String oppId,String priceId)
    {
        OpportunityLineItem oppLineItem = new OpportunityLineItem(OpportunityId = oppId,
                                                                  Quantity = 10,
                                                                  TotalPrice = 10*2,
                                                                  ICB_ITEMS_RETURNED__c = 2,
                                                                  PricebookEntryId = priceId
                                                                  );
        insert oppLineItem;
        return oppLineItem;
    }
}