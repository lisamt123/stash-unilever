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
        
        List<UID_Stocked_Product_Summary__c> testStockSummaryList1 = [Select ID, UID_Avail_Quantity__c, UID_Net_Quantity__c, UID_Stock_Cover__c
                                                                     	From UID_Stocked_Product_Summary__c Where Id =: testStockedSummary00.id];
		
		
        //Check Stock Cover
        System.assertEquals(100, testStockSummaryList1[0].UID_Net_Quantity__c);
        System.assertEquals(750, testStockSummaryList1[0].UID_Stock_Cover__c);
        
        List<UID_Stocked_Product_Summary__c> testStockSummaryList2 = [Select ID, UID_Avail_Quantity__c, UID_Net_Quantity__c, UID_Stock_Cover__c
                                                                     	From UID_Stocked_Product_Summary__c Where Id =: testStockedSummary01.id];
		
        //Check Stock Cover
        System.assertEquals(100, testStockSummaryList1[0].UID_Net_Quantity__c);
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
        
        for(Integer i=0; i< 200; i++) {
            UID_Stocked_Product__c stockedProduct = new UID_Stocked_Product__c();
            stockedProduct.UID_Start_Date__c = System.today().AddMonths(0);
            stockedProduct.UID_End_Date__c = System.today().AddMonths(0);
            stockedProduct.UID_Distributor__c = testAccount00.Id;
            stockedProduct.UID_Stock_Cover_Calculation_Flag__c = false;
			stockedProduct.UID_Report_Date__c = System.today().AddMonths(0);
            
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
    
    
    static UID_Stocked_Product__c prepareStockedProduct(Integer addMonth) {
        
        UID_Stocked_Product__c testStockedProduct = new UID_Stocked_Product__c();
            testStockedProduct.UID_Start_Date__c = System.today().AddMonths(addMonth);
            testStockedProduct.UID_End_Date__c = System.today().AddMonths(addMonth);
            testStockedProduct.UID_Distributor__c = testAccount00.Id;
            testStockedProduct.UID_Stock_Cover_Calculation_Flag__c = False;
        	testStockedProduct.UID_Report_Date__c = System.today().AddMonths(addMonth);
        
        return testStockedProduct;
    }
    
    static UID_Stocked_Product_Summary__c prepareStockedSummary(Integer netQuantity, Integer inQuantity, Id stockedProductId) {

		UID_Stocked_Product_Summary__c testStockedSummary = new UID_Stocked_Product_Summary__c();
            testStockedSummary.UID_Avail_Quantity__c = netQuantity;
        	testStockedSummary.UID_Net_Quantity__c = netQuantity;
            testStockedSummary.UID_Material__c = testProduct00.Id;
            testStockedSummary.UID_Stocked_Product__c = stockedProductId;        	
        	testStockedSummary.UID_In_Quantity__c = inQuantity;
        
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
        
        Order primaryOrderCurrentMonth = new Order();
            primaryOrderCurrentMonth.AccountId = testAccount00.Id;
            primaryOrderCurrentMonth.UID_Distributor__c = testAccount00.Id;
            primaryOrderCurrentMonth.EffectiveDate = System.today();
            primaryOrderCurrentMonth.Status = STATUS_DRAFT;
            primaryOrderCurrentMonth.UID_Invoice_Number__c = '920151111';
            primaryOrderCurrentMonth.RecordTypeId = primarySalesRecordType;
            primaryOrderCurrentMonth.Pricebook2Id =  pricebookId;       
        orderList.add(primaryOrderCurrentMonth);
        
        Order secondaryOrderCurrentMonth = new Order();
            secondaryOrderCurrentMonth.AccountId = secondaryAccount00.Id;
            secondaryOrderCurrentMonth.UID_Distributor__c = testAccount00.Id;
            secondaryOrderCurrentMonth.EffectiveDate = System.today();
            secondaryOrderCurrentMonth.Status = STATUS_DRAFT;
            secondaryOrderCurrentMonth.UID_Invoice_Number__c = '11/18/2015/secondaryOrderCurrentMonth';
            secondaryOrderCurrentMonth.RecordTypeId = secondarySalesRecordType;
            secondaryOrderCurrentMonth.Pricebook2Id =  pricebookId;  
        orderList.add(secondaryOrderCurrentMonth);
        
        Order secondaryOrderPrevMonth = new Order();
            secondaryOrderPrevMonth.AccountId = secondaryAccount00.Id;
            secondaryOrderPrevMonth.UID_Distributor__c = testAccount00.Id;
            secondaryOrderPrevMonth.EffectiveDate = System.today().AddMonths(-1);
            secondaryOrderPrevMonth.Status = STATUS_DRAFT;
            secondaryOrderPrevMonth.UID_Invoice_Number__c = '11/18/2015/secondaryOrderPrevMonth';
            secondaryOrderPrevMonth.RecordTypeId = secondarySalesRecordType;
            secondaryOrderPrevMonth.Pricebook2Id =  pricebookId;  
        orderList.add(secondaryOrderPrevMonth);
        
        Order secondaryOrderPrev2Month = new Order();
            secondaryOrderPrev2Month.AccountId = secondaryAccount00.Id;
            secondaryOrderPrev2Month.UID_Distributor__c = testAccount00.Id;
            secondaryOrderPrev2Month.EffectiveDate = System.today().AddMonths(-2);
            secondaryOrderPrev2Month.Status = STATUS_DRAFT;
            secondaryOrderPrev2Month.UID_Invoice_Number__c = '11/18/2015/secondaryOrderPrev2Month';
            secondaryOrderPrev2Month.RecordTypeId = secondarySalesRecordType;
            secondaryOrderPrev2Month.Pricebook2Id =  pricebookId;  
        orderList.add(secondaryOrderPrev2Month);
        
        Order secondaryOrderPrev3Month = new Order();
            secondaryOrderPrev3Month.AccountId = secondaryAccount00.Id;
            secondaryOrderPrev3Month.UID_Distributor__c = testAccount00.Id;
            secondaryOrderPrev3Month.EffectiveDate = System.today().AddMonths(-3);
            secondaryOrderPrev3Month.Status = STATUS_DRAFT;
            secondaryOrderPrev3Month.UID_Invoice_Number__c = '11/18/2015/secondaryOrderPrev3Month';
            secondaryOrderPrev3Month.RecordTypeId = secondarySalesRecordType;
            secondaryOrderPrev3Month.Pricebook2Id =  pricebookId;
        orderList.add(secondaryOrderPrev3Month);
        
        database.insert(orderList, FALSE);
        
        //create primary sales of the month
        UID_Order_Product__c primarySaleCurrentMonth = new UID_Order_Product__c();
            primarySaleCurrentMonth.UID_Order_Quantity__c = 60;
            primarySaleCurrentMonth.UID_Order__c = primaryOrderCurrentMonth.Id;
            
        newOrderItems.add(primarySaleCurrentMonth);
        //create secondary sales of the month
        UID_Order_Product__c secondarySaleCurrentMonth = new UID_Order_Product__c();
            secondarySaleCurrentMonth.UID_Order_Quantity__c = 10;
            secondarySaleCurrentMonth.UID_Order__c = secondaryOrderCurrentMonth.Id;
        	secondarySaleCurrentMonth.UID_Product__c = testProduct00.Id;
            
        newOrderItems.add(secondarySaleCurrentMonth);
        //create secondary sales previous month
        UID_Order_Product__c secondarySalePrevMonth = new UID_Order_Product__c();
            secondarySalePrevMonth.UID_Order_Quantity__c = 10;
            secondarySalePrevMonth.UID_Order__c = secondaryOrderPrevMonth.Id;
        	secondarySalePrevMonth.UID_Product__c = testProduct00.Id;
        
        newOrderItems.add(secondarySalePrevMonth);
        //create secondary sales previous 2 month
        UID_Order_Product__c secondarySalePrev2Month = new UID_Order_Product__c();
            secondarySalePrev2Month.UID_Order_Quantity__c = 10;
            secondarySalePrev2Month.UID_Order__c = secondaryOrderPrev2Month.Id;
        	secondarySalePrev2Month.UID_Product__c = testProduct00.Id;
            
        newOrderItems.add(secondarySalePrev2Month);
        //create secondary sales previous 3 month
        UID_Order_Product__c secondarySalePrev3Month = new UID_Order_Product__c();
            secondarySalePrev3Month.UID_Order_Quantity__c = 10;
            secondarySalePrev3Month.UID_Order__c = secondaryOrderPrev3Month.Id;
        	secondarySalePrev3Month.UID_Product__c = testProduct00.Id;
            
        newOrderItems.add(secondarySalePrev3Month);
        database.insert(newOrderItems,FALSE);
        
    }


}