@isTest(seealldata=false)
public class UID_OrderProductExchangeRateTest {

    static Account testAccount00;
    static Product2 testProduct00;
    static Order primaryOrder;
    static Id primarySalesRecordType;
        
    static UL_Exchange_Rate__c exRate1;
    static UL_Exchange_Rate__c exRate2;
    //static UL_Exchange_Rate__c exRate;
    
    /*
        Unit Testing (Start-End Date)
        
        Test Methods
        
        1 - sObj's date can be found in Exchange Rate and has Category        
        2 - sObj's date can be found in Exchange Rate but no Category
        3 - sObj's date cannot be found in Exchange Rate but has Category
        4 - sObj's date cannot be found in Exchange Rate but no Category
        5 - sObj is not found in Custom Metadata ???
        6 - Bulk Method (200) records
     */
    
    //sObj's date can be found in Exchange Rate
    //sObj1 - date within range, has no Category
    //sObj2 - date within range, has Category
    static testMethod void normalInsertExchangeRateTest(){
        
		prepareData();
		Test.startTest();
        
        //sObj has no category
        UID_Order_Product__c ordProdNoCategory = UID_StockProductUtility_Test.createOrderProduct(primaryOrder,testProduct00); 
        ordProdNoCategory.UID_Exchange_Rate_Category__c = '';
        Insert ordProdNoCategory;
        
        System.debug('ordProdNoCategory: ' + ordProdNoCategory);
        
        //sObj has category
        UID_Order_Product__c ordProdHasCategory = UID_StockProductUtility_Test.createOrderProduct(primaryOrder,testProduct00); 
        ordProdHasCategory.UID_Exchange_Rate_Category__c = 'UID';
        Insert ordProdHasCategory;
        
        System.debug('ordProdHasCategory: ' + ordProdHasCategory);
        
        Test.stopTest();
        
        List<UID_Order_Product__c> ordList = [SELECT Id, UID_Exchange_Rate__c, UID_Exchange_Rate_Category__c from UID_Order_Product__c];
        
        System.debug('ordList: ' + ordList);
        
        for(UID_Order_Product__c ordProd : ordList) {
            if(ordProd.Id == ordProdNoCategory.Id) {
                System.assertEquals(exRate1.Id, ordProd.UID_Exchange_Rate__c);
            } else {
                System.assertEquals(exRate2.Id, ordProd.UID_Exchange_Rate__c);
            }
        }        
    }
    
    //sObj's date can be found in Exchange Rate
    //sObj1 - date within range, has no Category and updated to has Category
    //sObj2 - date within range, has Category and updated to has no Category
    static testMethod void normalUpdateExchangeRateTest() {
        prepareData();
		Test.startTest();        
        
        UL_Exchange_Rate__c exRate3 = UID_Utility_Test.createExchangeRate(System.today().AddMonths(3), System.today().AddMonths(4), 'UID', 1, 3);
        Insert exRate3;
        
        //sObj has no category
        UID_Order_Product__c ordProdNoCategory = UID_StockProductUtility_Test.createOrderProduct(primaryOrder,testProduct00); 
        ordProdNoCategory.UID_Exchange_Rate_Category__c = '';
        Insert ordProdNoCategory;        
        ordProdNoCategory.UID_Exchange_Rate_Category__c = 'UID';
        Update ordProdNoCategory;
        
        System.debug('ordProdNoCategory2: ' + ordProdNoCategory);
        
        //sObj has category
        UID_Order_Product__c ordProdHasCategory = UID_StockProductUtility_Test.createOrderProduct(primaryOrder,testProduct00); 
        ordProdHasCategory.UID_Exchange_Rate_Category__c = 'UID';
        Insert ordProdHasCategory;        
        ordProdHasCategory.UID_Exchange_Rate_Category__c = '';
        Update ordProdHasCategory;
        
        
        Order orderTest = UID_StockProductUtility_Test.createOrder(testAccount00,0,primarySalesRecordType,'880151111');
        Insert orderTest;
        UID_Order_Product__c ordProdDifferentDate = UID_StockProductUtility_Test.createOrderProduct(orderTest,testProduct00); 
        ordProdDifferentDate.UID_Exchange_Rate_Category__c = 'UID';
        Insert ordProdDifferentDate;
        orderTest.EffectiveDate = System.today().AddMonths(3);
        Update orderTest;
        
        System.debug('ordProdHasCategory: ' + ordProdHasCategory);
        
        Test.stopTest();
        
        List<UID_Order_Product__c> ordList = [SELECT Id, UID_Exchange_Rate__c, UID_Exchange_Rate_Category__c from UID_Order_Product__c];
        
        System.debug('ordList: ' + ordList);
        
        for(UID_Order_Product__c ordProd : ordList) {
            if(ordProd.Id == ordProdNoCategory.Id) {
                System.assertEquals(exRate2.Id, ordProd.UID_Exchange_Rate__c);
            } else if(ordProd.Id == ordProdHasCategory.Id) {
                System.assertEquals(exRate1.Id, ordProd.UID_Exchange_Rate__c);
            } else {
                System.assertEquals(exRate3.Id, ordProd.UID_Exchange_Rate__c);
            }
        }        
    }
    
    //sObj's date can be found in Exchange Rate
    //sObj1 - date out of range, has no Category
    //sObj2 - date within range, has Category but Category not found on Exchange Rate
    static testMethod void noRelatedExRateFoundOnInsertTest() {
        prepareData();
		Test.startTest();
                
        //sObj date is out of range
        Order orderTest = UID_StockProductUtility_Test.createOrder(testAccount00,3,primarySalesRecordType,'880151111');
        Insert orderTest;
        
        UID_Order_Product__c ordProdOutOfRange = UID_StockProductUtility_Test.createOrderProduct(orderTest,testProduct00); 
        ordProdOutOfRange.UID_Exchange_Rate_Category__c = '';        
        Insert ordProdOutOfRange;
        
        //sObj category is not found
        UID_Order_Product__c ordProdCategoryNotFound = UID_StockProductUtility_Test.createOrderProduct(primaryOrder,testProduct00); 
        ordProdCategoryNotFound.UID_Exchange_Rate_Category__c = 'UL';
        Insert ordProdCategoryNotFound;
        
        Test.stopTest();
        
        List<UID_Order_Product__c> ordList = [SELECT Id, UID_Exchange_Rate__c, UID_Exchange_Rate_Category__c from UID_Order_Product__c];
        for(UID_Order_Product__c ordProd : ordList) {
        	System.assertEquals(null, ordProd.UID_Exchange_Rate__c);
        }        
    }
    
    //Test if Exchange Rate class can handle bulk process
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