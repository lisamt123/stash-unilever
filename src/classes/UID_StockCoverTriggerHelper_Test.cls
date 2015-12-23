/**********************************************************************
 Name: UID_StockCoverTriggerHelper_Test() 
 Copyright © 2015 Salesforce 
 ====================================================== 
 ====================================================== 
 Purpose: 
 1. Test class of UID_InventoryTriggerHelper
 ====================================================== 
 ====================================================== 
 History 
 ------- 
 VERSION AUTHOR DATE DETAIL Description 
 1.0 Mangaoang 11/11/2015 INITIAL DEVELOPMENT Test inventory field population
 ***********************************************************************/
@isTest(seealldata=false)
public class UID_StockCoverTriggerHelper_Test{
    
    static Account testAccount00;
    static Account secondaryAccount00;
    
    static Id pricebookId;
    static Product2 testProduct00;
    static PricebookEntry productStandardPrice;
    
    static Order primaryOrderCurrentMonth;
    static Order secondaryOrderCurrentMonth;
    static Order secondaryOrderPrevMonth;
    static Order secondaryOrderPrev2Month;
    static Order secondaryOrderPrev3Month;
    
    /******************************************************************* 
    Purpose: test setReportMonthOnInsert
    Parameters: 
    Returns: void
    ********************************************************************/     
    static testMethod void setReportMonthOnInsertTest(){
        prepareData(10);
        Test.startTest();
        
        UID_Stocked_Product__c testStockedProduct00 = new UID_Stocked_Product__c();
            testStockedProduct00.UID_Start_Date__c = System.today().AddMonths(0);
            testStockedProduct00.UID_End_Date__c = System.today().AddMonths(0);
            testStockedProduct00.UID_Distributor__c = testAccount00.Id;
            testStockedProduct00.UID_Stock_Cover_Calculation_Flag__c = False;
        
        database.insert(testStockedProduct00, FALSE);
        
        UID_Stocked_Product_Summary__c testStockedSummary00 = new UID_Stocked_Product_Summary__c();
            testStockedSummary00.UID_Avail_Quantity__c = 100;
            testStockedSummary00.UID_Material__c = testProduct00.Id;
            testStockedSummary00.UID_Stocked_Product__c = testStockedProduct00.Id;
       
       database.insert(testStockedSummary00, FALSE);
       
          
       UID_Stocked_Product__c testStockedProduct01 = new UID_Stocked_Product__c();
            testStockedProduct01.UID_Start_Date__c = System.today().AddMonths(-1);
            testStockedProduct01.UID_End_Date__c = System.today().AddMonths(-1);
            testStockedProduct01.UID_Distributor__c = testAccount00.Id;
            testStockedProduct01.UID_Stock_Cover_Calculation_Flag__c = False;
        
        database.insert(testStockedProduct01, FALSE);
            
        UID_Stocked_Product_Summary__c testStockedSummary01 = new UID_Stocked_Product_Summary__c();
            testStockedSummary01.UID_Avail_Quantity__c = 200;
            testStockedSummary01.UID_Material__c = testProduct00.Id;
            testStockedSummary01.UID_Stocked_Product__c = testStockedProduct01.Id;
            
        database.insert(testStockedSummary01, FALSE);
          
        List <UID_Stocked_Product__c> testStockList = [Select ID, UID_Stock_Cover_Calculation_Flag__c From UID_Stocked_Product__c Where Id =: testStockedProduct00.id];
        for (UID_Stocked_Product__c t : testStockList) {
            t.UID_Stock_Cover_Calculation_Flag__c = True;
            
        }
        
        update testStockList;
        Test.stopTest();
        
        List <UID_Stocked_Product__c> testStockList1 = [Select ID, UID_Stock_Cover_Calculation_Flag__c, UID_Start_Date__c, UID_End_Date__c From UID_Stocked_Product__c Where Id =: testStockedProduct00.id];
        System.assertEquals(System.today().AddMonths(0), testStockList1[0].UID_Start_Date__c);
        System.assertEquals(System.today().AddMonths(0), testStockList1[0].UID_End_Date__c);
        
        List <UID_Stocked_Product__c> testStockList2 = [Select ID, UID_Stock_Cover_Calculation_Flag__c, UID_Start_Date__c, UID_End_Date__c From UID_Stocked_Product__c Where Id =: testStockedProduct01.id];
        System.assertEquals(System.today().AddMonths(-1), testStockList2[0].UID_Start_Date__c);
        System.assertEquals(System.today().AddMonths(-1), testStockList2[0].UID_End_Date__c);
        
        List<UID_Stocked_Product_Summary__c> testStockSummaryList1 = [Select ID, UID_Avail_Quantity__c, UID_Stock_Cover__c
                                                                     	From UID_Stocked_Product_Summary__c Where Id =: testStockedSummary00.id];
		
		
        //Check Stock Cover
        System.assertEquals(100, testStockSummaryList1[0].UID_Avail_Quantity__c);
        System.assertEquals(6000, testStockSummaryList1[0].UID_Stock_Cover__c);
        
        List<UID_Stocked_Product_Summary__c> testStockSummaryList2 = [Select ID, UID_Avail_Quantity__c, UID_Stock_Cover__c
                                                                     	From UID_Stocked_Product_Summary__c Where Id =: testStockedSummary01.id];
		
        //Check Stock Cover
        System.assertEquals(100, testStockSummaryList1[0].UID_Avail_Quantity__c);
        System.assertEquals(null, testStockSummaryList2[0].UID_Stock_Cover__c);
                
    }
    
    /******************************************************************* 
    Purpose: CalculationFlag is set to False
    Parameters: 
    Returns: void
    ********************************************************************/
    static testMethod void stockCoverIsNull(){
    	prepareData(5);
        Test.startTest();
        UID_Stocked_Product__c testStockedProduct00 = new UID_Stocked_Product__c();
            testStockedProduct00.UID_Start_Date__c = System.today().AddMonths(0);
            testStockedProduct00.UID_End_Date__c = System.today().AddMonths(0);
            testStockedProduct00.UID_Distributor__c = testAccount00.Id;
            testStockedProduct00.UID_Stock_Cover_Calculation_Flag__c = False;
        
        database.insert(testStockedProduct00, FALSE);
        
        UID_Stocked_Product_Summary__c testStockedSummary00 = new UID_Stocked_Product_Summary__c();
            testStockedSummary00.UID_Avail_Quantity__c = 100;
            testStockedSummary00.UID_Material__c = testProduct00.Id;
            testStockedSummary00.UID_Stocked_Product__c = testStockedProduct00.Id;
       
       database.insert(testStockedSummary00, FALSE);
        
        List <UID_Stocked_Product__c> testStockList = [Select ID, UID_Stock_Cover_Calculation_Flag__c From UID_Stocked_Product__c 
                                                       Where Id =: testStockedProduct00.id];
        
        for (UID_Stocked_Product__c t : testStockList) {
            t.UID_Stock_Cover_Calculation_Flag__c = False;
            
        }
        update testStockList;
        Test.stopTest();
        
        List<UID_Stocked_Product_Summary__c> testStockSummaryList1 = [Select ID, UID_Avail_Quantity__c, UID_Stock_Cover__c
                                                                     	From UID_Stocked_Product_Summary__c Where Id =: testStockedSummary00.id];
		
        //Check Stock Cover
        System.assertEquals(100, testStockSummaryList1[0].UID_Avail_Quantity__c);
        System.assertEquals(null, testStockSummaryList1[0].UID_Stock_Cover__c);
        
    }
    
    /******************************************************************* 
    Purpose: CalculationFlag is set to True
    Parameters: 
    Returns: void
    ********************************************************************/
    static testMethod void stockCoverIsNotNull(){
    	prepareData(15);
        Test.startTest();
        UID_Stocked_Product__c testStockedProduct00 = new UID_Stocked_Product__c();
            testStockedProduct00.UID_Start_Date__c = System.today().AddMonths(0);
            testStockedProduct00.UID_End_Date__c = System.today().AddMonths(0);
            testStockedProduct00.UID_Distributor__c = testAccount00.Id;
            testStockedProduct00.UID_Stock_Cover_Calculation_Flag__c = False;
        
        database.insert(testStockedProduct00, FALSE);
        
        UID_Stocked_Product_Summary__c testStockedSummary00 = new UID_Stocked_Product_Summary__c();
            testStockedSummary00.UID_Avail_Quantity__c = 100;
            testStockedSummary00.UID_Material__c = testProduct00.Id;
            testStockedSummary00.UID_Stocked_Product__c = testStockedProduct00.Id;
       
       database.insert(testStockedSummary00, FALSE);
       
       UID_Stocked_Product__c testStockedProduct01 = new UID_Stocked_Product__c();
            testStockedProduct01.UID_Start_Date__c = System.today().AddMonths(-1);
            testStockedProduct01.UID_End_Date__c = System.today().AddMonths(-1);
            testStockedProduct01.UID_Distributor__c = testAccount00.Id;
            testStockedProduct01.UID_Stock_Cover_Calculation_Flag__c = False;
        
        database.insert(testStockedProduct01, FALSE);
            
        UID_Stocked_Product_Summary__c testStockedSummary01 = new UID_Stocked_Product_Summary__c();
            testStockedSummary01.UID_Avail_Quantity__c = 200;
            testStockedSummary01.UID_Material__c = testProduct00.Id;
            testStockedSummary01.UID_Stocked_Product__c = testStockedProduct01.Id;
            
        database.insert(testStockedSummary01, FALSE);
        
        List <UID_Stocked_Product__c> testStockList = [Select ID, UID_Stock_Cover_Calculation_Flag__c From UID_Stocked_Product__c 
                                                       Where Id =: testStockedProduct00.id];
        
        for (UID_Stocked_Product__c t : testStockList) {
            t.UID_Stock_Cover_Calculation_Flag__c = True;
            
        }
        update testStockList;
        Test.stopTest();
        
        List<UID_Stocked_Product_Summary__c> testStockSummaryList1 = [Select ID, UID_Avail_Quantity__c, UID_Stock_Cover__c
                                                                     	From UID_Stocked_Product_Summary__c Where Id =: testStockedSummary00.id];
		
        //Check Stock Cover
        System.assertEquals(100, testStockSummaryList1[0].UID_Avail_Quantity__c);
        System.assertEquals(6000, testStockSummaryList1[0].UID_Stock_Cover__c);
        
        List<UID_Stocked_Product_Summary__c> testStockSummaryList2 = [Select ID, UID_Avail_Quantity__c, UID_Stock_Cover__c
                                                                     	From UID_Stocked_Product_Summary__c Where Id =: testStockedSummary01.id];
		
        //Check Stock Cover
        System.assertEquals(100, testStockSummaryList1[0].UID_Avail_Quantity__c);
        System.assertEquals(6000, testStockSummaryList1[0].UID_Stock_Cover__c);
        
        /*        
        List <UID_Stocked_Product__c> testStockList1 = [Select ID, UID_Stock_Cover_Calculation_Flag__c, UID_Start_Date__c, UID_End_Date__c 
                                                        From UID_Stocked_Product__c Where Id =: testStockedProduct00.id];
        System.assertEquals(FALSE, testStockList1[0].UID_Stock_Cover_Calculation_Flag__c);
        */
        
    }
    
    
    /******************************************************************* 
    Purpose: Ensure that the trigger does not fail at the max. batch size
    Parameters: 
    Returns: void
    ********************************************************************/
    static testMethod void bulkRecordTest(){
        prepareData(2);
        Test.startTest();
        
        boolean allStockedProductsSaved = true;
        boolean allStockedProductSummariesSaved = true;
        
        List<UID_Stocked_Product__c> stockedProducts = new List<UID_Stocked_Product__c>();
        List<UID_Stocked_Product_Summary__c> stockedProductSummaries = new List<UID_Stocked_Product_Summary__c>();
        
        for(Integer i=0; i< 200; i++) {
            UID_Stocked_Product__c stockedProduct = new UID_Stocked_Product__c();
            stockedProduct.UID_Start_Date__c = System.today().AddMonths(0);
            stockedProduct.UID_End_Date__c = System.today().AddMonths(0);
            stockedProduct.UID_Distributor__c = testAccount00.Id;
            stockedProduct.UID_Stock_Cover_Calculation_Flag__c = false;
            
            stockedProducts.add(stockedProduct);
        }
        
        insert(stockedProducts);

        for(UID_Stocked_Product__c sp: stockedProducts) {
            UID_Stocked_Product_Summary__c stockedProductSummary = new UID_Stocked_Product_Summary__c();
            stockedProductSummary.UID_Avail_Quantity__c = 100;
            stockedProductSummary.UID_Material__c = testProduct00.Id;
            stockedProductSummary.UID_Stocked_Product__c = sp.Id;   
            
            stockedProductSummaries.add(stockedProductSummary);  
            
            if(sp.id == null) { // If any of the records didn't save, flag it.
                allStockedProductsSaved = false;
            }
               
        }
        
        insert stockedProductSummaries;
        
        // Fire off the calculation
        for(UID_Stocked_Product__c sp: stockedProducts) {
            sp.UID_Stock_Cover_Calculation_Flag__c = true;
        }        
        
        update stockedProducts;
        
        for(UID_Stocked_Product_Summary__c sps: stockedProductSummaries) {
            if(sps.id == null) {
                allStockedProductSummariesSaved = false;
            }
        }

        Test.stopTest();
        
        System.assertEquals(allStockedProductsSaved, true, 'Bulk processing of StockedProducts did not complete.');
        System.assertEquals(allStockedProductSummariesSaved, true, 'Bulk processingof StockedProductSummaries did not complete.');        
        
    } 
    
    
    
    /******************************************************************* 
    Purpose: prepare account and product;create custom settings
    Parameters: 
    Returns: void
    ********************************************************************/  
    static void prepareData(Integer unitPrice){
        Id primaryAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Primary Account').getRecordTypeId();
        Id secondaryAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Secondary Account').getRecordTypeId();
        List<Account> newAccounts = new List<Account>();
        List<Order> newOrders = new List<Order>();
        List<OrderItem> newOrderItems = new List<OrderItem>();
        
        String STATUS_DRAFT = 'Draft';
        
        //create trigger switch(custom settings)
        UID_TriggerSwitch__c settingTriggerSwitch = UID_TriggerSwitch__c.getOrgDefaults();
            settingTriggerSwitch.Inventory_Trigger_Switch__c = TRUE;
            settingTriggerSwitch.Order_Trigger_Switch__c = TRUE;
        database.insert(settingTriggerSwitch, FALSE);
        //create products
        testProduct00 = new Product2();
            testProduct00.Name = 'testProduct00';
            testProduct00.UID_Material_ID__c = '920151111';
            testProduct00.UID_Brand__c = 'PEPSODENT';
            testProduct00.UID_Category__c = 'ORAL CARE';
        database.insert(testProduct00, FALSE);
        
        //create pricebook entry
        pricebookId = Test.getStandardPricebookId();
        productStandardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = testProduct00.Id,
            UnitPrice = unitPrice, 
            IsActive = true);
        database.insert(productStandardPrice, FALSE);
       
        testAccount00 = new Account();
            testAccount00.RecordTypeId = primaryAccountRecordType;
            testAccount00.Name = 'testAccount00';
            testAccount00.UID_Region__c = 'SOUTH EAST ASIA';
            testAccount00.UID_Segment__c = 'PI CUSTOMERS';
            testAccount00.UID_Geography__c = 'OTHERS';
            testAccount00.AccountNumber = '915113204';
        database.insert(testAccount00, FALSE);
        
        //create account(type Secondary account)
        secondaryAccount00 = new Account();
            secondaryAccount00.RecordTypeId = secondaryAccountRecordType;
            secondaryAccount00.Name = 'secondaryAccount00';
            secondaryAccount00.UID_Region__c = 'SOUTH EAST ASIA';
            secondaryAccount00.UID_Segment__c = 'PI CUSTOMERS';
            secondaryAccount00.UID_Geography__c = 'OTHERS';
            secondaryAccount00.AccountNumber = '915113204';
        newAccounts.add(secondaryAccount00);
        
        database.insert(newAccounts, FALSE);
        
        primaryOrderCurrentMonth = new Order();
            primaryOrderCurrentMonth.AccountId = testAccount00.Id;
            primaryOrderCurrentMonth.UID_Distributor__c = testAccount00.Id;
            primaryOrderCurrentMonth.EffectiveDate = System.today();
            primaryOrderCurrentMonth.Status = STATUS_DRAFT;
            primaryOrderCurrentMonth.UID_Invoice_Number__c = '920151111';
            primaryOrderCurrentMonth.RecordTypeId = primaryAccountRecordType;
            primaryOrderCurrentMonth.Pricebook2Id =  pricebookId;       
        newOrders.add(primaryOrderCurrentMonth);
        
        secondaryOrderCurrentMonth = new Order();
            secondaryOrderCurrentMonth.AccountId = secondaryAccount00.Id;
            secondaryOrderCurrentMonth.UID_Distributor__c = testAccount00.Id;
            secondaryOrderCurrentMonth.EffectiveDate = System.today();
            secondaryOrderCurrentMonth.Status = STATUS_DRAFT;
            secondaryOrderCurrentMonth.UID_Invoice_Number__c = '11/18/2015/secondaryOrderCurrentMonth';
            secondaryOrderCurrentMonth.RecordTypeId = secondaryAccountRecordType;
            secondaryOrderCurrentMonth.Pricebook2Id =  pricebookId;  
        newOrders.add(secondaryOrderCurrentMonth);
        
        secondaryOrderPrevMonth = new Order();
            secondaryOrderPrevMonth.AccountId = secondaryAccount00.Id;
            secondaryOrderPrevMonth.UID_Distributor__c = testAccount00.Id;
            secondaryOrderPrevMonth.EffectiveDate = System.today().AddMonths(-1);
            secondaryOrderPrevMonth.Status = STATUS_DRAFT;
            secondaryOrderPrevMonth.UID_Invoice_Number__c = '11/18/2015/secondaryOrderPrevMonth';
            secondaryOrderPrevMonth.RecordTypeId = secondaryAccountRecordType;
            secondaryOrderPrevMonth.Pricebook2Id =  pricebookId;  
        newOrders.add(secondaryOrderPrevMonth);
        
        secondaryOrderPrev2Month = new Order();
            secondaryOrderPrev2Month.AccountId = secondaryAccount00.Id;
            secondaryOrderPrev2Month.UID_Distributor__c = testAccount00.Id;
            secondaryOrderPrev2Month.EffectiveDate = System.today().AddMonths(-2);
            secondaryOrderPrev2Month.Status = STATUS_DRAFT;
            secondaryOrderPrev2Month.UID_Invoice_Number__c = '11/18/2015/secondaryOrderPrev2Month';
            secondaryOrderPrev2Month.RecordTypeId = secondaryAccountRecordType;
            secondaryOrderPrev2Month.Pricebook2Id =  pricebookId;  
        newOrders.add(secondaryOrderPrev2Month);
        
        secondaryOrderPrev3Month = new Order();
            secondaryOrderPrev3Month.AccountId = secondaryAccount00.Id;
            secondaryOrderPrev3Month.UID_Distributor__c = testAccount00.Id;
            secondaryOrderPrev3Month.EffectiveDate = System.today().AddMonths(-3);
            secondaryOrderPrev3Month.Status = STATUS_DRAFT;
            secondaryOrderPrev3Month.UID_Invoice_Number__c = '11/18/2015/secondaryOrderPrev3Month';
            secondaryOrderPrev3Month.RecordTypeId = secondaryAccountRecordType;
            secondaryOrderPrev3Month.Pricebook2Id =  pricebookId;
        newOrders.add(secondaryOrderPrev3Month);
        
        database.insert(newOrders, FALSE);
        
        //create primary sales of the month
        OrderItem primarySaleCurrentMonth = new OrderItem();
            primarySaleCurrentMonth.UID_Order_Quantity__c = 60;
            primarySaleCurrentMonth.OrderId = primaryOrderCurrentMonth.Id;
            primarySaleCurrentMonth.Quantity = 1;
            primarySaleCurrentMonth.PricebookEntryId = productStandardPrice.Id;
            primarySaleCurrentMonth.UnitPrice = unitPrice;
        newOrderItems.add(primarySaleCurrentMonth);
        //create secondary sales of the month
        OrderItem secondarySaleCurrentMonth = new OrderItem();
            secondarySaleCurrentMonth.UID_Order_Quantity__c = 10;
            secondarySaleCurrentMonth.OrderId = secondaryOrderCurrentMonth.Id;
            secondarySaleCurrentMonth.Quantity = 1;
            secondarySaleCurrentMonth.PricebookEntryId = productStandardPrice.Id;
            secondarySaleCurrentMonth.UnitPrice = unitPrice;
        newOrderItems.add(secondarySaleCurrentMonth);
        //create secondary sales previous month
        OrderItem secondarySalePrevMonth = new OrderItem();
            secondarySalePrevMonth.UID_Order_Quantity__c = 10;
            secondarySalePrevMonth.OrderId = secondaryOrderPrevMonth.Id;
            secondarySalePrevMonth.Quantity = 1;
            secondarySalePrevMonth.PricebookEntryId = productStandardPrice.Id;
            secondarySalePrevMonth.UnitPrice = unitPrice;
        newOrderItems.add(secondarySalePrevMonth);
        //create secondary sales previous 2 month
        OrderItem secondarySalePrev2Month = new OrderItem();
            secondarySalePrev2Month.UID_Order_Quantity__c = 10;
            secondarySalePrev2Month.OrderId = secondaryOrderPrev2Month.Id;
            secondarySalePrev2Month.Quantity = 1;
            secondarySalePrev2Month.PricebookEntryId = productStandardPrice.Id;
            secondarySalePrev2Month.UnitPrice = unitPrice;
        newOrderItems.add(secondarySalePrev2Month);
        //create secondary sales previous 3 month
        OrderItem secondarySalePrev3Month = new OrderItem();
            secondarySalePrev3Month.UID_Order_Quantity__c = 10;
            secondarySalePrev3Month.OrderId = secondaryOrderPrev3Month.Id;
            secondarySalePrev3Month.Quantity = 1;
            secondarySalePrev3Month.PricebookEntryId = productStandardPrice.Id;
            secondarySalePrev3Month.UnitPrice = 1;
        newOrderItems.add(secondarySalePrev3Month);
        database.insert(newOrderItems,FALSE);
        
    }


}