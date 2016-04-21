@isTest(seealldata=false)
public class UID_PerformanceLineItemExRateTest {

    static UL_Exchange_Rate__c exRate1;
    static UL_Exchange_Rate__c exRate2;
    
    static Account testAccount00;
    static Product2 testProduct00;
    static UID_Performance__c performance;
    
    static testMethod void normalInsertExchangeRateTest(){
        prepareData();
        Test.startTest();
        
        UID_Performance_Line_Item__c pliHasNoCategory = UID_Utility_Test.createPerformanceLineItem(performance, '', 1, System.today(), testProduct00);
        Insert pliHasNoCategory;        
        
        UID_Performance_Line_Item__c pliHasCategory = UID_Utility_Test.createPerformanceLineItem(performance, 'UID', 1, System.today(), testProduct00);
        Insert pliHasCategory;
        
        Test.stopTest();
        
        List<UID_Performance_Line_Item__c> pliList = [SELECT Id, UID_Exchange_Rate__c, UID_IOP_Value_EUR__c, UID_IOP_Value_USD__c
                                                     FROM UID_Performance_Line_Item__c];
        
        for(UID_Performance_Line_Item__c pliTest : pliList) {
            if(pliTest.Id == pliHasNoCategory.Id) {
                System.assertEquals(exRate1.Id, pliTest.UID_Exchange_Rate__c);
                System.assertEquals(exRate1.UL_EUR__c, pliTest.UID_IOP_Value_EUR__c);
                System.assertEquals(exRate1.UL_USD__c, pliTest.UID_IOP_Value_USD__c);
            } else {
                System.assertEquals(exRate2.Id, pliTest.UID_Exchange_Rate__c);
                System.assertEquals(exRate2.UL_EUR__c, pliTest.UID_IOP_Value_EUR__c);
                System.assertEquals(exRate2.UL_USD__c, pliTest.UID_IOP_Value_USD__c);
            }              
        }        
    }
    
    static testMethod void normalUpdateExchangeRateTest() {
        prepareData();
        Test.startTest();
        
        UL_Exchange_Rate__c exRate3 = UID_Utility_Test.createExchangeRate(System.today().AddMonths(3), System.today().AddMonths(4), 'UID', 1, 5);
        insert exRate3;
        
        UID_Performance_Line_Item__c pliHasNoCategory = UID_Utility_Test.createPerformanceLineItem(performance, '', 1, System.today(), testProduct00);
        Insert pliHasNoCategory;
        pliHasNoCategory.UID_Exchange_Rate_Category__c = 'UID';
        Update pliHasNoCategory;

        UID_Performance_Line_Item__c pliHasCategory = UID_Utility_Test.createPerformanceLineItem(performance, 'UID', 1, System.today(), testProduct00);
        Insert pliHasCategory;
        pliHasCategory.UID_Exchange_Rate_Category__c = '';
        Update pliHasCategory;
        
        UID_Performance_Line_Item__c pliDifferentDate = UID_Utility_Test.createPerformanceLineItem(performance, 'UID', 1, System.today(), testProduct00);
        Insert pliDifferentDate;
        pliDifferentDate.UID_IOP_Date__c = System.today().AddMonths(3);
        Update pliDifferentDate;
        
        Test.stopTest();
        
        List<UID_Performance_Line_Item__c> pliList = [SELECT Id, UID_Exchange_Rate__c, UID_IOP_Value_EUR__c, UID_IOP_Value_USD__c
                                                     FROM UID_Performance_Line_Item__c];
        
        for(UID_Performance_Line_Item__c pliTest : pliList) {
            if(pliTest.Id == pliHasNoCategory.Id) {
                System.assertEquals(exRate2.Id, pliTest.UID_Exchange_Rate__c);
                System.assertEquals(exRate2.UL_EUR__c, pliTest.UID_IOP_Value_EUR__c);
                System.assertEquals(exRate2.UL_USD__c, pliTest.UID_IOP_Value_USD__c);
            } else if(pliTest.Id == pliHasCategory.Id) {
                System.assertEquals(exRate1.Id, pliTest.UID_Exchange_Rate__c);
                System.assertEquals(exRate1.UL_EUR__c, pliTest.UID_IOP_Value_EUR__c);
                System.assertEquals(exRate1.UL_USD__c, pliTest.UID_IOP_Value_USD__c);
            } else {
                System.assertEquals(exRate3.Id, pliTest.UID_Exchange_Rate__c);
                System.assertEquals(exRate3.UL_EUR__c, pliTest.UID_IOP_Value_EUR__c);
                System.assertEquals(exRate3.UL_USD__c, pliTest.UID_IOP_Value_USD__c);
            }             
        }        
    }
    
    static testMethod void noRelatedExRateFoundOnInsertTest() {
        
        prepareData();
        Test.startTest();
                
        UID_Performance_Line_Item__c pliOutofRange = UID_Utility_Test.createPerformanceLineItem(performance, '', 1, System.today().addMonths(6), testProduct00);
        Insert pliOutofRange;
        
        UID_Performance_Line_Item__c pliCategoryNotFound = UID_Utility_Test.createPerformanceLineItem(performance, 'UL', 1, System.today().addMonths(6), testProduct00);
        Insert pliCategoryNotFound;
        
        Test.stopTest();
        
        List<UID_Performance_Line_Item__c> pliList = [SELECT Id, UID_Exchange_Rate__c, UID_IOP_Value_EUR__c, UID_IOP_Value_USD__c
                                                     FROM UID_Performance_Line_Item__c];
        for(UID_Performance_Line_Item__c pliTest : pliList) {
            System.assertEquals(null, pliTest.UID_Exchange_Rate__c);
        }
    }
    
    static testMethod void bulkRecordTest() {
        prepareData();
        Test.startTest();
        
        List<UID_Performance_Line_Item__c> insertedPliList = new List<UID_Performance_Line_Item__c>();
        for(Integer i = 0; i < 200; i++) {
            UID_Performance_Line_Item__c pliHasCategory = UID_Utility_Test.createPerformanceLineItem(performance, 'UID', 1, System.today(), testProduct00);
            insertedPliList.add(pliHasCategory);
        }        
        Insert insertedPliList;            
        Test.stopTest();
        
        List<UID_Performance_Line_Item__c> pliList = [SELECT Id, UID_Exchange_Rate__c, UID_IOP_Value_EUR__c, UID_IOP_Value_USD__c
                                                     FROM UID_Performance_Line_Item__c];
        for(UID_Performance_Line_Item__c pliTest : pliList) {
            System.assertEquals(exRate2.Id, pliTest.UID_Exchange_Rate__c);
        }
    }
    
    static void prepareData() {
        
        Id primaryAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Primary Account').getRecordTypeId();
        
        //create Primary Account
        testAccount00 = UID_StockProductUtility_Test.createAccount(primaryAccountRecordType); 
        database.insert(testAccount00, FALSE);
        
        //create products
        testProduct00 = UID_StockProductUtility_Test.createProduct();
        Insert testProduct00;
        //database.insert(testProduct00, FALSE);
        
        system.debug('testProduct00: ' + testProduct00);
        
        performance = UID_Utility_Test.createPerformance(testAccount00);
        Insert performance;

        //create Exchange Rate
        List<UL_Exchange_Rate__c> exRateList = new List<UL_Exchange_Rate__c>();
        exRate1 = UID_Utility_Test.createExchangeRate(System.today(), System.today().AddMonths(1), '', 1, 2);
        exRate2 = UID_Utility_Test.createExchangeRate(System.today(), System.today().AddMonths(1), 'UID', 1, 3);
        exRateList.add(exRate1);
        exRateList.add(exRate2);
        Insert exRateList;        
        
    }
}