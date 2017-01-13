/**********************************************************************
Name:  CEC_AnonymiseConsumerBatchScheduler_Test
Copyright � 2015  Unilever
======================================================================
=======================================================================
Purpose: This is the test class for the Batch/Scheduler class for CEC_AnonymiseConsumer_BatchScheduler
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0      Masood           Dec-2015      INITIAL DEVELOPMENT   
1.1      Sathish           MAR-2016        Code Refactoring.
***********************************************************************/
@isTest(SeeAllData = false)
public with sharing class CEC_AnonymiseConsumerBatchScheduler_Test {
   
    @testSetup static void setUpTestData() {
         User u = CEC_TestDataFactory.createStandardCECTestUser();
        System.runAs(u) {
            List<mdm_Product_Category__c> prodCategoryList = CEC_TestDataFactory.createProductCategory(1);
            insert prodCategoryList;
            
            List<mdm_Case_Product__c> caseProductList = 
                CEC_TestDataFactory.createCaseProduct(1, prodCategoryList.get(0).Id);
            insert caseProductList;
            
            List<mdm_Global_Listening_Tree__c> globalListeningTreeList = 
                CEC_TestDataFactory.createGlobalListeningTree(1);
            insert globalListeningTreeList;
            
            List<mdm_Reason_Code__c> reasonCodeList = 
                CEC_TestDataFactory.createReasonCode(1, globalListeningTreeList.get(0).Id);
            insert reasonCodeList;
            
            List<CEC_Case_Market_Mapping__c> cmmList = CEC_TestDataFactory.createMasterCaseMarketMapping();
            CEC_Case_Market_Mapping__c cmmUK = new CEC_Case_Market_Mapping__c();
            for(CEC_Case_Market_Mapping__c cmm : cmmList) {
                if (cmm.Market__c == CEC_Constants.UK) {
                    cmmUK = cmm;
                    break;
                }
            }
            
            Date d1 = System.today().addDays(-3);
            List<Account> accountList = CEC_TestDataFactory.createTestAccounts(1, 'TestAccount', null, null, null, 
                                                                               'London', CEC_Constants.UK, null);
            accountList[0].Anonymise_check__c = true;
            accountList[0].Retention_Date__c = d1;

            Account accountObj1 = new Account(Salutation='Mr',FirstName='Peter',LastName='Parker',PersonEmail='abc@abc00DE0000000bbLj.com',Phone='12121212',BillingStreet='St peters',PersonMailingStreet='St peters',ShippingStreet='St peters',Retention_Date__c=d1,Anonymise_check__c=true);
            
            Account accountObj2 = new Account(Salutation='Mr',FirstName='ben',LastName='afex',PersonEmail='abc2@abc00DE0000000bbLj.com',Phone='343535353',BillingStreet='bandra',PersonMailingStreet='bandra',ShippingStreet='bandra',Retention_Date__c=d1,Anonymise_check__c=true);
            
            Account accountObj3 = new Account(Salutation='Mr',FirstName='jay',LastName='Z',PersonEmail='abc3@abc00DE0000000bbLj.com',Phone='12121464758',BillingStreet='santacruz',PersonMailingStreet='santacruz',ShippingStreet='santacruz');
            
            accountList.add(accountObj1);
            accountList.add(accountObj2);
            accountList.add(accountObj3);
            
            insert accountList;
            
            List<Case> caseList = CEC_TestDataFactory.createTestCases(1, 'New', 'Email', 'L1234', '1234',
                                                                      caseProductList.get(0).Id, reasonCodeList.get(0).Id, 
                                                                      accountList[0].Id, cmmUK.Id, false);
            for (Case caseObj : caseList) {
                caseObj.Case_product_category__c='IceCream';
                caseObj.Brand__c = 'Knorr';
            }
            insert caseList;
            
            List<cec_Fulfilment__c> fulfilmentList = CEC_TestDataFactory.createFulfilment(1, CEC_Constants.UK, null, null,
                                                                                          null, null, null, caseList[0].Id);
            
            insert fulfilmentList;            
            
            CEC_Cheque_Authorization_Limit__c chequeLimit = new CEC_Cheque_Authorization_Limit__c(Level_1__c=100,
                                                                                                  Level_2__c=200,Level_3__c=300,Level_4__c=4000,
                                                                                                  Level_5__c=500,Level_6__c=600,Level_7__c=700);
            insert chequeLimit;
            
            cec_Org_Settings__c   orgsetting = new cec_Org_Settings__c(Debit_Card_Expiry_Days__c = 15,  E_Voucher_Expiry_Days__c = 15);
            insert orgsetting;
            
            CEC_Retrieval_Request__c retreq = new CEC_Retrieval_Request__c(Retrieval_Status__c = CEC_Constants.caseStatus, Retrieval_Quantity__c = 2, Case_Country_Name__c = CEC_Constants.cmmCountry);
            retreq.Case__c = caseList[0].Id;
            insert retreq;
        }

       
    }

    // Test method for the batch interface implementation
    @isTest static void test_AnonymiseConsumerBatchMethod() {
        // Implement test code
         
        User u = CEC_TestDataFactory.getStandardCECTestUser();       
        System.runAs(u) {
            Test.startTest();
            CEC_AnonymiseConsumer_BatchScheduler scheduler = new CEC_AnonymiseConsumer_BatchScheduler();
            database.executeBatch(scheduler);
           
            Test.stopTest();
            List<account> resultAccountList = [ SELECT id,Anonymise_check__c, Date_Anonymized__c, 
                                                Salutation,FirstName,LastName,PersonEmail,Phone,
                                                BillingStreet, PersonMailingStreet, ShippingStreet, 
                                                Retention_Date__c from Account limit 10];
            
            List<case> cases =  [SELECT Id,Description,Search_Birthdate__c,Search_Email__c,Search_First_Name__c,
                                       Search_Home_Phone__c,Search_Last_Name__c,Search_Mailing_City__c,
                                       Search_Mailing_Country__c,Search_Mailing_State_Province__c,
                                       Search_Mailing_Street__c,Search_Mailing_Zip_Postal_Code__c,
                                       Search_Mobile__c,Search_Other_Phone__c,Search_Phone__c,
                                       Search_Salutation__c,SMS_Mobile_Number__c,Social_Media_External_Id__c
                                 FROM Case limit 10];
            
            List<cec_Fulfilment__c> fulfillments = [SELECT Account_Card_Number__c,Date_of_Birth__c,Fullname__c,
                                                            Local_Identifier__c,Message__c,Payable_To__c,
                                                            PersonEmail__c,Product_Notes__c 
                                                    FROM cec_Fulfilment__c Limit 10];
            
            List<CEC_Retrieval_Request__c> retReqs = [SELECT Id,Case__c FROM CEC_Retrieval_Request__c Limit 5];
            
            for (Account accountObj : resultAccountList) {
                if (accountObj.Anonymise_check__c == false && accountObj.Date_Anonymized__c == null) {
                    System.assertNotEquals(accountObj.PersonEmail, null);
                    System.assertNotEquals(accountObj.Salutation, null);
                    System.assertNotEquals(accountObj.FirstName, null);
                    System.assertNotEquals(accountObj.LastName, null);
                    System.assertNotEquals(accountObj.Phone, null);
                    System.assertNotEquals(accountObj.BillingStreet, null);
                    System.assertNotEquals(accountObj.PersonMailingStreet, null);
                    System.assertNotEquals(accountObj.ShippingStreet, null);
                    System.assertEquals(accountObj.Retention_Date__c, null);
                    System.assertEquals(accountObj.Anonymise_check__c, false);
                } else if (accountObj.Anonymise_check__c == false && accountObj.Date_Anonymized__c != null){
                    System.assertEquals(accountObj.PersonEmail, null);
                    System.assertEquals(accountObj.Salutation, null);
                    System.assertEquals(accountObj.FirstName, null);
                    System.assertEquals(accountObj.Phone, null);
                    System.assertEquals(accountObj.BillingStreet, null);
                    System.assertEquals(accountObj.PersonMailingStreet, null);
                    System.assertEquals(accountObj.ShippingStreet, null);
                    System.assertEquals(accountObj.Phone, null);                    
                    System.assertEquals(accountObj.Anonymise_check__c, false);
                    System.assertNotEquals(accountObj.Retention_Date__c, null);
                    System.assertEquals(accountObj.LastName, accountObj.Id);
                }                
            }
        }
    }
    
    
    @isTest static void test_AnonymiseConsumerBatchMethod_Exception() {
        // Implement test code
        
        User u = CEC_TestDataFactory.getStandardCECTestUser();        
        System.runAs(u) {
            Test.startTest(); 
            CEC_AnonymiseConsumer_BatchScheduler scheduler = new CEC_AnonymiseConsumer_BatchScheduler();
            database.executeBatch(scheduler);            
            Test.stopTest(); 
            
            Account accountObj = [Select Salutation,FirstName,PersonEmail,Phone,PersonOtherPhone,PersonMobilePhone,PersonHomePhone ,BillingStreet ,PersonMailingStreet ,ShippingStreet,Anonymise_check__c FROM Account WHERE Date_Anonymized__c != null Limit 1] ;
                    System.assertEquals(accountObj.PersonEmail, null);
                    System.assertEquals(accountObj.Salutation, null);
                    System.assertEquals(accountObj.Phone, null);
                    System.assertEquals(accountObj.BillingStreet, null);
                    System.assertEquals(accountObj.PersonMailingStreet, null);
                    System.assertEquals(accountObj.ShippingStreet, null);
                    System.assertEquals(accountObj.Phone, null);                    
                    System.assertEquals(accountObj.Anonymise_check__c, false);          
        }
    }
    
    
    // Test method for the Schedulable interface implementation
    @isTest static void test_AnonymiseConsumerSchedulerMethod() {
        // Implement test code
        
        User u = CEC_TestDataFactory.getStandardCECTestUser();        
        System.runAs(u) {
            Test.startTest(); 
            String CRON_EXP = '0 20 * * * ?';
            String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new CEC_AnonymiseConsumer_BatchScheduler());
            CronTrigger ct = [SELECT Id, CronExpression FROM CronTrigger WHERE id = :jobId];
            // Verify the expressions are the same
            System.assertEquals(CRON_EXP, ct.CronExpression);
            Test.stopTest();
        }
    }
    
}