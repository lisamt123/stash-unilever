@isTest(seealldata=false)
public class UID_StockedProductSummaryExRateTest {

    static Account testAccount00;
    static Product2 testProduct00;
    static Order primaryOrder;
    static Id primarySalesRecordType;
        
    static UL_Exchange_Rate__c exRate1;
    static UL_Exchange_Rate__c exRate2;
    
    static testMethod void normalInsertExchangeRateTest(){
        prepareData();
        Test.startTest();
        UID_Stocked_Product__c testStockedProduct00 = prepareStockedProduct(0);
        database.insert(testStockedProduct00, FALSE);
        
        //sObj has no category
        UID_Stocked_Product_Summary__c spsHasNoCategory = prepareStockedSummary(10, 10, testStockedProduct00.Id);
        spsHasNoCategory.UID_Exchange_Rate_Category__c = '';
        Insert spsHasNoCategory;
        
        //sObj has category
        UID_Stocked_Product_Summary__c spsHasCategory = prepareStockedSummary(10, 10, testStockedProduct00.Id);
        spsHasCategory.UID_Exchange_Rate_Category__c = 'UID';
        Insert spsHasCategory;
        
        Test.stopTest();
        
        List<UID_Stocked_Product_Summary__c> spsList = [SELECT ID, UID_Exchange_Rate__c, UID_Exchange_Rate_Category__c FROM UID_Stocked_Product_Summary__c];
        for(UID_Stocked_Product_Summary__c sps : sPsList) {
            if(sps.Id == spsHasNoCategory.Id) {
                System.assertEquals(exRate1.Id, sps.UID_Exchange_Rate__c);
            } else {
                System.assertEquals(exRate2.Id, sps.UID_Exchange_Rate__c);
            }
        }
    }
    
    static testMethod void normalUpdateExchangeRateTest() {
        prepareData();
        Test.startTest();

        UID_Stocked_Product__c testStockedProduct00 = prepareStockedProduct(0);
        Insert testStockedProduct00;
        
        UID_Stocked_Product__c testStockedProduct01 = prepareStockedProduct(1);
        Insert testStockedProduct01;
        //database.insert(testStockedProduct01, FALSE);
        
        system.debug('testStockedProduct01: ' + testStockedProduct01);
        system.debug('testStockedProduct01 ID: ' + testStockedProduct01.Id);
        
        UL_Exchange_Rate__c exRate3 = UID_Utility_Test.createExchangeRate(System.today().AddMonths(3), System.today().AddMonths(4), 'UID', 1, 3);
        Insert exRate3;
        
        //sObj has no category
        UID_Stocked_Product_Summary__c spsHasNoCategory = prepareStockedSummary(10, 10, testStockedProduct00.Id);
        spsHasNoCategory.UID_Exchange_Rate_Category__c = '';
        Insert spsHasNoCategory;
        spsHasNoCategory.UID_Exchange_Rate_Category__c = 'UID';
        Update spsHasNoCategory;
        
        //sObj has category
        UID_Stocked_Product_Summary__c spsHasCategory = prepareStockedSummary(10, 10, testStockedProduct00.Id);
        spsHasCategory.UID_Exchange_Rate_Category__c = 'UID';
        Insert spsHasCategory;
        spsHasCategory.UID_Exchange_Rate_Category__c = '';
        Update spsHasCategory;
        
        //sOjb has different date
        UID_Stocked_Product_Summary__c spsHasDifferentDate = prepareStockedSummary(10, 10, testStockedProduct01.Id);
        spsHasDifferentDate.UID_Exchange_Rate_Category__c = 'UID';
        Insert spsHasDifferentDate;
        testStockedProduct01.UID_Start_Date__c = System.today().AddMonths(3);
        Update testStockedProduct01;        
        
        Test.stopTest();
        
        List<UID_Stocked_Product_Summary__c> spsList = [SELECT ID, UID_Exchange_Rate__c, UID_Exchange_Rate_Category__c FROM UID_Stocked_Product_Summary__c];
        for(UID_Stocked_Product_Summary__c sps : sPsList) {
            if(sps.Id == spsHasNoCategory.Id) {
                System.assertEquals(exRate2.Id, sps.UID_Exchange_Rate__c);
            } else if(sps.Id == spsHasCategory.Id) {
                System.assertEquals(exRate1.Id, sps.UID_Exchange_Rate__c);
            } else {
                System.assertEquals(exRate3.Id, sps.UID_Exchange_Rate__c);
            }
        }    
    }
    
    static testMethod void noRelatedExRateFoundOnInsertTest() {
        prepareData();
        Test.startTest();
        
        UID_Stocked_Product__c testStockedProduct00 = prepareStockedProduct(6);
        Insert testStockedProduct00;
        
        UID_Stocked_Product__c testStockedProduct01 = prepareStockedProduct(0);
        Insert testStockedProduct01;
        
        UID_Stocked_Product_Summary__c spsOutOfRangeDate = prepareStockedSummary(10, 10, testStockedProduct00.Id);
        spsOutOfRangeDate.UID_Exchange_Rate_Category__c = '';
        Insert spsOutOfRangeDate;
        
        UID_Stocked_Product_Summary__c spsCategoryNotFound = prepareStockedSummary(10, 10, testStockedProduct01.Id);
        spsCategoryNotFound.UID_Exchange_Rate_Category__c = 'UL';
        Insert spsCategoryNotFound;
        
        Test.stopTest();
        
        List<UID_Stocked_Product_Summary__c> spsList = [SELECT ID, UID_Exchange_Rate__c, UID_Exchange_Rate_Category__c FROM UID_Stocked_Product_Summary__c];
        for(UID_Stocked_Product_Summary__c sps : sPsList) {
            System.assertEquals(null, sps.UID_Exchange_Rate__c);            
        }
    }
    
    static testMethod void bulkRecordTest() {
        prepareData();
        Test.startTest();
        UID_Stocked_Product__c testStockedProduct00 = prepareStockedProduct(0);
        Insert testStockedProduct00;
        
        List<UID_Stocked_Product_Summary__c> spsList = new List<UID_Stocked_Product_Summary__c>();
        for(Integer i = 0; i < 200; i++) {
            UID_Stocked_Product_Summary__c sps = prepareStockedSummary(10, 10, testStockedProduct00.Id);
            sps.UID_Exchange_Rate_Category__c = 'UID';
            spsList.add(sps);
        }
        Insert spsList;        
        Test.stopTest();
        
        List<UID_Stocked_Product_Summary__c> spsListTest = [SELECT ID, UID_Exchange_Rate__c, UID_Exchange_Rate_Category__c FROM UID_Stocked_Product_Summary__c];
        for(UID_Stocked_Product_Summary__c sps : spsListTest) {
            System.assertEquals(exRate2.Id, sps.UID_Exchange_Rate__c);            
        }        
    }
    
    /*
static testMethod void bulkRecordTest() {
        prepareData();
        Test.startTest();
                
        List<UID_Order_Product__c> insertedOrdProdList = new List<UID_Order_Product__c>();
        for(Integer i = 0; i < 200; i++) {
            UID_Order_Product__c ordProd = UID_StockProductUtility_Test.createOrderProduct(primaryOrder,testProduct00); 
            ordProd.UID_Exchange_Rate_Category__c = 'UID';
            insertedOrdProdList.add(ordProd);
        }
        Insert insertedOrdProdList;
        Test.stopTest();
        
        List<UID_Order_Product__c> ordList = [SELECT Id, UID_Exchange_Rate__c, UID_Exchange_Rate_Category__c from UID_Order_Product__c];
        System.assertEquals(200, ordList.size());
        for(UID_Order_Product__c ordProd : ordList) {
            System.assertEquals(exRate2.Id, ordProd.UID_Exchange_Rate__c);
        }
    }
    */
    
    
    static UID_Stocked_Product__c prepareStockedProduct(Integer addMonth){
        UID_Stocked_Product__c testStockedProduct = UID_StockProductUtility_Test.createStockedProduct(testAccount00, addMonth); 
        return testStockedProduct;
    }
    
    static UID_Stocked_Product_Summary__c prepareStockedSummary(Integer netQuantity, Integer inQuantity, Id stockedProductId) {
        UID_Stocked_Product_Summary__c testStockedSummary = UID_StockProductUtility_Test.createStockedSummary(testProduct00, netQuantity, inQuantity, stockedProductId);
        return testStockedSummary;
    }

    static void prepareData(){   
        
        Id primaryAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Primary Account').getRecordTypeId();
                        
        primarySalesRecordType = Schema.SObjectType.Order.getRecordTypeInfosByName().get('Primary Sales').getRecordTypeId();
        
        //Create Account
        List<Account> newAccounts = new List<Account>();
        
        //create Primary Account
        testAccount00 = UID_StockProductUtility_Test.createAccount(primaryAccountRecordType); 
        database.insert(testAccount00, FALSE);
        
        //create products
        testProduct00 = UID_StockProductUtility_Test.createProduct();
        database.insert(testProduct00, FALSE);
        
        primaryOrder = UID_StockProductUtility_Test.createOrder(testAccount00,0,primarySalesRecordType,'920151111');   
        insert primaryOrder;
        
        //create Exchange Rate
        List<UL_Exchange_Rate__c> exRateList = new List<UL_Exchange_Rate__c>();
        exRate1 = UID_Utility_Test.createExchangeRate(System.today(), System.today().AddMonths(1), '', 1, 2);
        exRate2 = UID_Utility_Test.createExchangeRate(System.today(), System.today().AddMonths(1), 'UID', 1, 3);
        exRateList.add(exRate1);
        exRateList.add(exRate2);
        Insert exRateList;
    }
}