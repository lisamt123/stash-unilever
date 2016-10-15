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
 1.1 Barcenas  03/08/2015 Update the code to cater the Unique field setting 
                             of Stocked Product External ID field of Stock Product
 ***********************************************************************/
@isTest(seealldata=false)
public class UID_StockCoverTriggerHelper_Test{
    
    static Account testAccount00;
    static Account secondaryAccount00;
    
    static Id pricebookId;
    static Product2 testProduct00;
    static PricebookEntry productStandardPrice;
    
    //0 primaryOrderCurrentMonth
    //1 secondaryOrderCurrentMonth
    //2 secondaryOrderPrevMonth
    //3 secondaryOrderPrev2Month
    //4 secondaryOrderPrev3Month
    static List<Order> orderList;
    
    static Id primaryAccountRecordType;
    static Id secondaryAccountRecordType;
    
    static Id primarySalesRecordType;
    static Id secondarySalesRecordType;
    
    static String STATUS_DRAFT = 'Draft';
    static final String PRIMARY_SALES_RECORDTYPE_NAME = 'Primary Sales';
    static final String SECONDARY_SALES_RECORDTYPE_NAME = 'Secondary Sales';
    
    /******************************************************************* 
    Purpose: test setReportMonthOnInsert
    Parameters: 
    Returns: void
    ********************************************************************/     
    static testMethod void setReportMonthOnInsertTest(){
        prepareData(10);
        Test.startTest();
        
        UID_Stocked_Product__c testStockedProduct00 = prepareStockedProduct(0);
        database.insert(testStockedProduct00, FALSE);
        
        UID_Stocked_Product_Summary__c testStockedSummary00 = UID_StockProductUtility_Test.createStockedSummary(testProduct00, 100, 60, testStockedProduct00.Id); 
        database.insert(testStockedSummary00, FALSE);
       
       	UID_Stocked_Product__c testStockedProduct01 = prepareStockedProduct(-1);
        database.insert(testStockedProduct01, FALSE);
            
        UID_Stocked_Product_Summary__c testStockedSummary01 = UID_StockProductUtility_Test.createStockedSummary(testProduct00, 200, 0, testStockedProduct01.Id); 
        database.insert(testStockedSummary01, FALSE);
          
        List<UID_Stocked_Product__c> testStockList = new List<UID_Stocked_Product__c>();
        for (UID_Stocked_Product__c t : [Select ID, UID_Stock_Cover_Calculation_Flag__c From UID_Stocked_Product__c Where Id =: testStockedProduct00.id]) {
            t.UID_Stock_Cover_Calculation_Flag__c = True;
            testStockList.add(t);
        }
        
        update testStockList;
        Test.stopTest();
        
        List <UID_Stocked_Product__c> testStockList1 = [Select ID, UID_Stock_Cover_Calculation_Flag__c, UID_Start_Date__c, UID_End_Date__c From UID_Stocked_Product__c Where Id =: testStockedProduct00.id];
        System.assertEquals(System.today().AddMonths(0), testStockList1[0].UID_Start_Date__c);
        System.assertEquals(System.today().AddMonths(0), testStockList1[0].UID_End_Date__c);
        
        List <UID_Stocked_Product__c> testStockList2 = [Select ID, UID_Stock_Cover_Calculation_Flag__c, UID_Start_Date__c, UID_End_Date__c From UID_Stocked_Product__c Where Id =: testStockedProduct01.id];
        System.assertEquals(System.today().AddMonths(-1), testStockList2[0].UID_Start_Date__c);
        System.assertEquals(System.today().AddMonths(-1), testStockList2[0].UID_End_Date__c);
        
        List<UID_Stocked_Product_Summary__c> testStockSummaryList1 = [Select ID, UID_Avail_Quantity__c, UID_Net_Quantity__c, UID_Stock_Cover__c
                                                                        From UID_Stocked_Product_Summary__c Where Id =: testStockedSummary00.id];
        
        
        //Check Stock Cover
        System.assertEquals(100, testStockSummaryList1[0].UID_Net_Quantity__c);
        System.assertEquals(750, testStockSummaryList1[0].UID_Stock_Cover__c);
        List<UID_Stocked_Product_Summary__c> testStockSummaryList2 = [Select ID, UID_Avail_Quantity__c, UID_Net_Quantity__c, UID_Stock_Cover__c
                                                                        From UID_Stocked_Product_Summary__c Where Id =: testStockedSummary01.id];
        
        //Check Stock Cover
        System.assertEquals(200, testStockSummaryList2[0].UID_Net_Quantity__c);
        System.assertEquals(0, testStockSummaryList2[0].UID_Stock_Cover__c);
                
    }
    
    /******************************************************************* 
    Purpose: CalculationFlag is set to False
    Parameters: 
    Returns: void
    ********************************************************************/
    static testMethod void stockCoverIsNull(){
        prepareData(5);
        Test.startTest();
        UID_Stocked_Product__c testStockedProduct00 = prepareStockedProduct(0);
        
        database.insert(testStockedProduct00, FALSE);
        
        UID_Stocked_Product_Summary__c testStockedSummary00 = new UID_Stocked_Product_Summary__c();
            testStockedSummary00.UID_Avail_Quantity__c = 100;
            testStockedSummary00.UID_Net_Quantity__c = 100;
            testStockedSummary00.UID_Material__c = testProduct00.Id;
            testStockedSummary00.UID_Stocked_Product__c = testStockedProduct00.Id;
       
            testStockedSummary00.UID_In_Quantity__c = 60;
        
       database.insert(testStockedSummary00, FALSE);
        
        List <UID_Stocked_Product__c> testStockList = [Select ID, UID_Stock_Cover_Calculation_Flag__c From UID_Stocked_Product__c 
                                                       Where Id =: testStockedProduct00.id];
        
        for (UID_Stocked_Product__c t : testStockList) {
            t.UID_Stock_Cover_Calculation_Flag__c = False;
            
        }
        update testStockList;
        Test.stopTest();
        
        List<UID_Stocked_Product_Summary__c> testStockSummaryList1 = [Select ID, UID_Avail_Quantity__c, UID_Net_Quantity__c, UID_Stock_Cover__c
                                                                        From UID_Stocked_Product_Summary__c Where Id =: testStockedSummary00.id];
        
        //Check Stock Cover
        System.assertEquals(100, testStockSummaryList1[0].UID_Net_Quantity__c);
        System.assertEquals(0, testStockSummaryList1[0].UID_Stock_Cover__c);
        
    }
    
    /******************************************************************* 
    Purpose: CalculationFlag is set to True
    Parameters: 
    Returns: void
    ********************************************************************/
    static testMethod void stockCoverIsNotNull(){
        prepareData(15);
        Test.startTest();
        UID_Stocked_Product__c testStockedProduct00 = prepareStockedProduct(0);
        
        database.insert(testStockedProduct00, FALSE);
        
        UID_Stocked_Product_Summary__c testStockedSummary00 = new UID_Stocked_Product_Summary__c();
            testStockedSummary00.UID_Avail_Quantity__c = 100;
            testStockedSummary00.UID_Net_Quantity__c = 100;
            testStockedSummary00.UID_Material__c = testProduct00.Id;
            testStockedSummary00.UID_Stocked_Product__c = testStockedProduct00.Id;
        
            testStockedSummary00.UID_In_Quantity__c = 60;
       
       database.insert(testStockedSummary00, FALSE);
       
       UID_Stocked_Product__c testStockedProduct01 = prepareStockedProduct(-1);
        
        database.insert(testStockedProduct01, FALSE);
            
        UID_Stocked_Product_Summary__c testStockedSummary01 = new UID_Stocked_Product_Summary__c();
            testStockedSummary01.UID_Avail_Quantity__c = 200;
            testStockedSummary01.UID_Net_Quantity__c = 200;
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
        
        List<UID_Stocked_Product_Summary__c> testStockSummaryList1 = [Select ID, UID_Avail_Quantity__c, UID_Net_Quantity__c, UID_Stock_Cover__c
                                                                        From UID_Stocked_Product_Summary__c Where Id =: testStockedSummary00.id];
        
        //Check Stock Cover
        System.assertEquals(100, testStockSummaryList1[0].UID_Net_Quantity__c);
        System.assertEquals(750, testStockSummaryList1[0].UID_Stock_Cover__c);
        
        List<UID_Stocked_Product_Summary__c> testStockSummaryList2 = [Select ID, UID_Avail_Quantity__c, UID_Net_Quantity__c, UID_Stock_Cover__c
                                                                        From UID_Stocked_Product_Summary__c Where Id =: testStockedSummary01.id];
        
        //Check Stock Cover
        System.debug('Test Stock cover: ' + testStockSummaryList2[0].UID_Stock_Cover__c);
        System.assertEquals(200, testStockSummaryList2[0].UID_Net_Quantity__c);
        System.assertEquals(0, testStockSummaryList2[0].UID_Stock_Cover__c);
        
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
        
        //Barcenas 03/08/2015: updated the code from .AddMonths(0) to .AddMonths(i)
        for(Integer i=0; i< 200; i++) {
            UID_Stocked_Product__c stockedProduct = new UID_Stocked_Product__c();
            stockedProduct.UID_Start_Date__c = System.today().AddMonths(i);
            stockedProduct.UID_End_Date__c = System.today().AddMonths(i);
            stockedProduct.UID_Distributor__c = testAccount00.Id;
            stockedProduct.UID_Stock_Cover_Calculation_Flag__c = false;
            stockedProduct.UID_Report_Date__c = System.today().AddMonths(i);
            
            stockedProducts.add(stockedProduct);
        }
        
        insert(stockedProducts);

        for(UID_Stocked_Product__c sp: stockedProducts) {
            UID_Stocked_Product_Summary__c stockedProductSummary = new UID_Stocked_Product_Summary__c();
            stockedProductSummary.UID_Avail_Quantity__c = 100;
            stockedProductSummary.UID_Net_Quantity__c = 100;
            stockedProductSummary.UID_Material__c = testProduct00.Id;
            stockedProductSummary.UID_Stocked_Product__c = sp.Id;
            stockedProductSummary.UID_In_Quantity__c = 60;
            
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
        
        for(UID_Stocked_Product__c sp: stockedProducts) {
            sp.UID_Summarized_Invoice_Ranking_Flag__c = true;
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
    Purpose: Normal stock cover calculation. All required fields have values
    Parameters: 
    Returns: void
    ********************************************************************/    
    static testMethod void normalStockCoverTest(){

        prepareData(15);
        
        Test.startTest();
        List<UID_Stocked_Product__c> stockList = new List<UID_Stocked_Product__c>();
        List<UID_Stocked_Product_Summary__c> stockSummaryList = new List<UID_Stocked_Product_Summary__c>();
        
        UID_Stocked_Product__c testStockedProduct00 = prepareStockedProduct(-1);
        
        database.insert(testStockedProduct00, FALSE);
        stockList.add(testStockedProduct00);
        
        UID_Stocked_Product_Summary__c testStockedSummary00 = prepareStockedSummary(100, 60, testStockedProduct00.Id);
        stockSummaryList.add(testStockedSummary00);
        
        UID_Stocked_Product__c testStockedProduct01 = prepareStockedProduct(0);
        
        database.insert(testStockedProduct01, FALSE);
        stockList.add(testStockedProduct01);
        
        UID_Stocked_Product_Summary__c testStockedSummary01 = prepareStockedSummary(100, 60, testStockedProduct01.Id);
        stockSummaryList.add(testStockedSummary01);
        
        //Insert stockList;
        Insert stockSummaryList;
        
        for(UID_Stocked_Product__c stock : stockList) {
            stock.UID_Stock_Cover_Calculation_Flag__c = true;
        }
        Update stockList;

        Test.stopTest();
        
        List<UID_Stocked_Product_Summary__c> testStockSummaryList = [Select ID, UID_Avail_Quantity__c, UID_Net_Quantity__c, UID_In_Quantity__c, UID_Stock_Cover__c, UID_Sales_Date__c
                                                                        From UID_Stocked_Product_Summary__c Where Id =: testStockedSummary01.id];
        
        List<UID_Order_Product__c> testOrderProductList = [Select ID, UID_Order_Quantity__c
                                                                        From UID_Order_Product__c Where UID_Order__c =: orderList.get(1).id];
        
        //Check Stock Cover
        System.assertEquals(100, testStockSummaryList[0].UID_Net_Quantity__c);
        System.assertEquals(60, testStockSummaryList[0].UID_In_Quantity__c);
        System.assertEquals(450, testStockSummaryList[0].UID_Stock_Cover__c);
        System.assertEquals(10, testOrderProductList[0].UID_Order_Quantity__c);
        
    }
    
    /******************************************************************* 
    Purpose: Negative stock cover calculation.
    Parameters: 
    Returns: void
    ********************************************************************/    
    static testMethod void negativeStockCoverTest(){

        prepareData(15);
        
        Test.startTest();
        List<UID_Stocked_Product__c> stockList = new List<UID_Stocked_Product__c>();
        List<UID_Stocked_Product_Summary__c> stockSummaryList = new List<UID_Stocked_Product_Summary__c>();
        
        UID_Stocked_Product__c testStockedProduct00 = prepareStockedProduct(-1);
        
        database.insert(testStockedProduct00, FALSE);
        stockList.add(testStockedProduct00);
        
        UID_Stocked_Product_Summary__c testStockedSummary00 = prepareStockedSummary(-100, 60, testStockedProduct00.Id);
        stockSummaryList.add(testStockedSummary00);
        
        UID_Stocked_Product__c testStockedProduct01 = prepareStockedProduct(0);
        
        database.insert(testStockedProduct01, FALSE);
        stockList.add(testStockedProduct01);
        
        UID_Stocked_Product_Summary__c testStockedSummary01 = prepareStockedSummary(-100, 60, testStockedProduct01.Id);
        stockSummaryList.add(testStockedSummary01);
        
        //Insert stockList;
        Insert stockSummaryList;
        
        for(UID_Stocked_Product__c stock : stockList) {
            stock.UID_Stock_Cover_Calculation_Flag__c = true;
        }
        Update stockList;

        Test.stopTest();
        
        List<UID_Stocked_Product_Summary__c> testStockSummaryList = [Select ID, UID_Avail_Quantity__c, UID_Net_Quantity__c, UID_In_Quantity__c, UID_Stock_Cover__c, UID_Sales_Date__c
                                                                        From UID_Stocked_Product_Summary__c Where Id =: testStockedSummary01.id];
        
        List<UID_Order_Product__c> testOrderProductList = [Select ID, UID_Order_Quantity__c
                                                                        From UID_Order_Product__c Where UID_Order__c =: orderList.get(1).id];
        
        //Check Stock Cover
        System.assertEquals(-100, testStockSummaryList[0].UID_Net_Quantity__c);
        System.assertEquals(60, testStockSummaryList[0].UID_In_Quantity__c);
        System.assertEquals(-150, testStockSummaryList[0].UID_Stock_Cover__c);
        System.assertEquals(10, testOrderProductList[0].UID_Order_Quantity__c);
        
    }
    
    //StockCover is 0
    /******************************************************************* 
    Purpose: Ensures that Stock Cover calculation is correct even if all fields are 0
    Parameters: 
    Returns: void
    ********************************************************************/
    static testMethod void stockCoverIsZeroTest(){
        prepareData(15);
        
        Test.startTest();
        List<UID_Order_Product__c> orderProductList = new List<UID_Order_Product__c>();
        
        UID_Order_Product__c orderProduct = [Select UID_Order_Quantity__c 
                                                From UID_Order_Product__c 
                                                Where UID_Order__c =: orderList.get(1).Id limit 1];
        orderProduct.UID_Order_Quantity__c = 0;
        orderProductList.add(orderProduct);
        
        UID_Order_Product__c orderProductPrevMonth = [Select UID_Order_Quantity__c 
                                                From UID_Order_Product__c 
                                                Where UID_Order__c =: orderList.get(2).Id limit 1];
        orderProductprevMonth.UID_Order_Quantity__c = 0;
        orderProductList.add(orderProductprevMonth);
        
        UID_Order_Product__c orderProductPrev2Month = [Select UID_Order_Quantity__c 
                                                From UID_Order_Product__c 
                                                Where UID_Order__c =: orderList.get(3).Id limit 1];
        orderProductPrev2Month.UID_Order_Quantity__c = 0;
        orderProductList.add(orderProductPrev2Month);
        
        UID_Order_Product__c orderProductPrev3Month = [Select UID_Order_Quantity__c 
                                                From UID_Order_Product__c 
                                                Where UID_Order__c =: orderList.get(4).Id limit 1];
        orderProductPrev3Month.UID_Order_Quantity__c = 0;
        orderProductList.add(orderProductPrev3Month);
        
        Update orderProductList;
   
        List<UID_Stocked_Product__c> stockList = new List<UID_Stocked_Product__c>();
        List<UID_Stocked_Product_Summary__c> stockSummaryList = new List<UID_Stocked_Product_Summary__c>();
        
        UID_Stocked_Product__c testStockedProduct00 = prepareStockedProduct(-1);
        
        database.insert(testStockedProduct00, FALSE);
        stockList.add(testStockedProduct00);
        
        UID_Stocked_Product_Summary__c testStockedSummary00 = prepareStockedSummary(0, 0, testStockedProduct00.Id);
        stockSummaryList.add(testStockedSummary00);
        
        UID_Stocked_Product__c testStockedProduct01 = prepareStockedProduct(0);
        
        database.insert(testStockedProduct01, FALSE);
        stockList.add(testStockedProduct01);
        
        UID_Stocked_Product_Summary__c testStockedSummary01 = prepareStockedSummary(0, 0, testStockedProduct01.Id);

        stockSummaryList.add(testStockedSummary01);
        
        //Insert stockList;
        Insert stockSummaryList;
        
        for(UID_Stocked_Product__c stock : stockList) {
            stock.UID_Stock_Cover_Calculation_Flag__c = true;
        }
        Update stockList;

        Test.stopTest();
        
    
        List<UID_Stocked_Product_Summary__c> testStockSummaryList = [Select ID, UID_Avail_Quantity__c, UID_Net_Quantity__c, UID_In_Quantity__c, UID_Stock_Cover__c, UID_Sales_Date__c
                                                                        From UID_Stocked_Product_Summary__c Where Id =: testStockedSummary01.id];
        
        List<UID_Order_Product__c> testOrderProductList = [Select ID, UID_Order_Quantity__c
                                                                        From UID_Order_Product__c Where UID_Order__c =: orderList.get(1).id];
        
        //Check Stock Cover
        System.assertEquals(0, testStockSummaryList[0].UID_Net_Quantity__c);
        System.assertEquals(0, testStockSummaryList[0].UID_In_Quantity__c);
        System.assertEquals(0, testStockSummaryList[0].UID_Stock_Cover__c);
    }
    
    
    static UID_Stocked_Product__c prepareStockedProduct(Integer addMonth){
        UID_Stocked_Product__c testStockedProduct = UID_StockProductUtility_Test.createStockedProduct(testAccount00, addMonth); 
        return testStockedProduct;
    } 
    
    static UID_Stocked_Product_Summary__c prepareStockedSummary(Integer netQuantity, Integer inQuantity, Id stockedProductId) {
        UID_Stocked_Product_Summary__c testStockedSummary = UID_StockProductUtility_Test.createStockedSummary(testProduct00, netQuantity, inQuantity, stockedProductId);
        return testStockedSummary;
    }
    
    /******************************************************************* 
    Purpose: prepare account and product;create custom settings
    Parameters: 
    Returns: void
    ********************************************************************/  
    static void prepareData(Integer unitPrice){
        
        primaryAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Primary Account').getRecordTypeId();
        secondaryAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Secondary Account').getRecordTypeId();
                
        primarySalesRecordType = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Primary Sales').getRecordTypeId();
        secondarySalesRecordType = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Secondary Sales').getRecordTypeId();
        
        List<Account> newAccounts = new List<Account>();
        orderList = new List<Order>();
        List<UID_Order_Product__c> newOrderItems = new List<UID_Order_Product__c>();
        
        //create trigger switch(custom settings)
        UID_TriggerSwitch__c settingTriggerSwitch = UID_TriggerSwitch__c.getOrgDefaults();
            settingTriggerSwitch.UID_Inventory_Trigger_Switch__c = TRUE;
            settingTriggerSwitch.UID_Order_Trigger_Switch__c = TRUE;
        database.insert(settingTriggerSwitch, FALSE);
        
        //create products
        testProduct00 = UID_StockProductUtility_Test.createProduct();
        database.insert(testProduct00, FALSE);
        
        //create pricebook entry
        pricebookId = Test.getStandardPricebookId();
        productStandardPrice = UID_StockProductUtility_Test.createPricebookEntry(unitPrice, testProduct00);
        database.insert(productStandardPrice, FALSE);
       
        testAccount00 = UID_StockProductUtility_Test.createAccount(primaryAccountRecordType); 
        database.insert(testAccount00, FALSE);
        
        //create account(type Secondary account)
        secondaryAccount00 = UID_StockProductUtility_Test.createAccount(secondaryAccountRecordType); 
        secondaryAccount00.Name = 'secondaryAccount00';
        newAccounts.add(secondaryAccount00);
        
        database.insert(newAccounts, FALSE);
        
        Order primaryOrderCurrentMonth = UID_StockProductUtility_Test.createOrder(testAccount00,0,primarySalesRecordType,'920151111');   
        orderList.add(primaryOrderCurrentMonth);
        
        Order secondaryOrderCurrentMonth = UID_StockProductUtility_Test.createOrder(secondaryAccount00,0,secondarySalesRecordType,'11/18/2015/secondaryOrderCurrentMonth');
            secondaryOrderCurrentMonth.UID_Distributor__c = testAccount00.Id;
        orderList.add(secondaryOrderCurrentMonth);
        
        Order secondaryOrderPrevMonth = UID_StockProductUtility_Test.createOrder(secondaryAccount00,-1,secondarySalesRecordType,'11/18/2015/secondaryOrderPrevMonth');
            secondaryOrderPrevMonth.UID_Distributor__c = testAccount00.Id;
        orderList.add(secondaryOrderPrevMonth);
        
        Order secondaryOrderPrev2Month = UID_StockProductUtility_Test.createOrder(secondaryAccount00,-2,secondarySalesRecordType,'11/18/2015/secondaryOrderPrev2Month'); 
            secondaryOrderPrev2Month.UID_Distributor__c = testAccount00.Id;
        orderList.add(secondaryOrderPrev2Month);
        
        Order secondaryOrderPrev3Month = UID_StockProductUtility_Test.createOrder(secondaryAccount00,-3,secondarySalesRecordType,'11/18/2015/secondaryOrderPrev3Month'); 
            secondaryOrderPrev3Month.UID_Distributor__c = testAccount00.Id;
        orderList.add(secondaryOrderPrev3Month);
        
        database.insert(orderList, FALSE);
        
        //create primary sales of the month
        UID_Order_Product__c primarySaleCurrentMonth = UID_StockProductUtility_Test.createOrderProduct(primaryOrderCurrentMonth,testProduct00); 
        newOrderItems.add(primarySaleCurrentMonth);
        
        //create secondary sales of the month
        UID_Order_Product__c secondarySaleCurrentMonth = UID_StockProductUtility_Test.createOrderProduct(secondaryOrderCurrentMonth,testProduct00); 
        newOrderItems.add(secondarySaleCurrentMonth);
        
        //create secondary sales previous month
        UID_Order_Product__c secondarySalePrevMonth = UID_StockProductUtility_Test.createOrderProduct(secondaryOrderPrevMonth,testProduct00); 
        newOrderItems.add(secondarySalePrevMonth);
        
        //create secondary sales previous 2 month
        UID_Order_Product__c secondarySalePrev2Month = UID_StockProductUtility_Test.createOrderProduct(secondaryOrderPrev2Month,testProduct00);
        newOrderItems.add(secondarySalePrev2Month);
        
        //create secondary sales previous 3 month
        UID_Order_Product__c secondarySalePrev3Month = UID_StockProductUtility_Test.createOrderProduct(secondaryOrderPrev3Month,testProduct00);
        newOrderItems.add(secondarySalePrev3Month);
        
        database.insert(newOrderItems,FALSE);
        
    }


}