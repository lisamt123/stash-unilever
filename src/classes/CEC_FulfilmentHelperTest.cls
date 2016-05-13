/**********************************************************************
Name:  CEC_Test_FulfilmentHelper
Copyright © 2014  Unilever
======================================================================
=======================================================================
Purpose: This is the test class for the CEC_FulfilmentHelper                                                                                                                  
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE            DETAIL               Description
1.0 -    Rajesh            19/11/2015      INITIAL DEVELOPMENT  CSR
1.0 -    Masood            20/11/2015      INITIAL DEVELOPMENT  CSR
2.0      Samrin Shaikh     17/12/2015       CSC-2765            CSC-2765 US-009 Letter/Enclosure auto population
2.1      Masood            09/02/2016      Max Refund value added for user
2.2      Sathish           Mar - 2016      Code Refactoring     Updated Code to use CEC_TestDataFactory 
***********************************************************************/

/*
Test class for the Helper class CEC_FulfilmentHelper
*/

@isTest(SeeAllData=false)
public class CEC_FulfilmentHelperTest {
    
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
            CEC_Case_Market_Mapping__c cmmUK;
            for(CEC_Case_Market_Mapping__c cmm : cmmList) {
                if (cmm.Market__c == 'United Kingdom') {
                    cmmUK = cmm;
                    break;
                }
            }
            
            List<Account> accountList = CEC_TestDataFactory.createTestAccounts(1, 'TestAccount', null, null, null, 
                                                                               'London', 'United Kingdom', null);
            
            insert accountList;
            
            List<Case> caseList = CEC_TestDataFactory.createTestCases(1, 'New', 'Email', 'L1234', '1234',
                                                                      caseProductList.get(0).Id, reasonCodeList.get(0).Id, 
                                                                      accountList[0].Id, cmmUK.Id, false);
            for (Case caseObj : caseList) {
                caseObj.Case_product_category__c='IceCream';
                caseObj.Brand__c = 'Knorr';
            }
            insert caseList;
            
            List<cec_Fulfilment__c> fulfilmentList = CEC_TestDataFactory.createFulfilment(1, 'United Kingdom', null, null,
                                                                                          null, null, null, caseList[0].Id);
            
            insert fulfilmentList;            
            
            CEC_Cheque_Authorization_Limit__c chequeLimit = new CEC_Cheque_Authorization_Limit__c(Level_1__c=100,
                                                                                                  Level_2__c=200,Level_3__c=300,Level_4__c=4000,
                                                                                                  Level_5__c=500,Level_6__c=600,Level_7__c=700);
            insert chequeLimit;
            
            cec_Org_Settings__c   orgsetting = new cec_Org_Settings__c(Debit_Card_Expiry_Days__c = 15,  E_Voucher_Expiry_Days__c = 15);
            insert orgsetting;
        }
    } 
    
    /**
Test method for beforeInsert() method
*/
    
    public static testMethod void test_qualityCheckMethod(){
        
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            
            List<cec_Fulfilment__c>  fulfilmentList = [SELECT Id, Case__c FROM cec_Fulfilment__c LIMIT 1];
            User loggedinuser = [select Quality_Check_Percentage__c,Max_Refund_Amount__c, FirstName from User where id = :UserInfo.getUserId()];
            loggedinuser.Refund_Authorization_Limit__c ='Level 4';
            update loggedinuser;
            System.debug('@@@@@Refund amount' + loggedinuser.Max_Refund_Amount__c);
            
            System.debug(''+loggedinuser.Quality_Check_Percentage__c+' '+loggedinuser.FirstName);
            
            Test.startTest();
            CEC_FulfilmentHelper fulfilmentHelper = new CEC_FulfilmentHelper();
            fulfilmentHelper.qualityCheck(fulfilmentList);
            Test.stopTest();
            
            system.assertEquals(true, fulfilmentList.get(0).QA_flag__c);
        }
        
    }
    
    public static testMethod void test_getChequeNumber(){
        
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            
            CEC_Case_Market_Mapping__c cmmUK = [SELECT Id FROM CEC_Case_Market_Mapping__c WHERE 
                                                Market__c = 'United Kingdom' LIMIT 1];
            
            mdm_Product_Category__c prodCategory = [SELECT Id FROM mdm_Product_Category__c LIMIT 1];
            
            List<CEC_ChequeBook_Detail__c> chequeBookDetailList = CEC_TestDataFactory.createChequeBookDetail(
                1, 'CB1', 'USD', 'Dollars', 'Cents',
                1, 11, 1000, cmmUK.Id, prodCategory.Id);
            insert chequeBookDetailList;
            
            List<cec_Fulfilment__c>  fulfilmentList = [ SELECT Id, Case__c FROM cec_Fulfilment__c LIMIT 1];
            Test.startTest();
            CEC_ChequeProcess.generateChequeNumber(fulfilmentList[0].Id);
            cec_Fulfilment__c fulfilmentObj = [SELECT Id, Case__c, Cheque_Number__c, Refund_Currency__c 
                                               FROM cec_Fulfilment__c WHERE id = :fulfilmentList[0].Id LIMIT 1];
            System.assertEquals(fulfilmentObj.Cheque_Number__c, '12');
            System.assertEquals(fulfilmentObj.Refund_Currency__c, 'USD');
            Test.stopTest();
        }
    }
    
    
    public static testMethod void test_getChequeNumber_maxChequeNumberExceeded(){
        
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            
            CEC_Case_Market_Mapping__c cmmUK = [SELECT Id FROM CEC_Case_Market_Mapping__c WHERE 
                                                Market__c = 'United Kingdom' LIMIT 1];
            
            mdm_Product_Category__c prodCategory = [SELECT Id FROM mdm_Product_Category__c LIMIT 1];
            
            List<CEC_ChequeBook_Detail__c> chequeBookDetailList = CEC_TestDataFactory.createChequeBookDetail(
                1, 'CB1', 'USD', 'Dollars', 'Cents',
                1, 1000, 1000, cmmUK.Id, prodCategory.Id);
            insert chequeBookDetailList;
            
            List<cec_Fulfilment__c>  fulfilmentList = [ SELECT Id, Case__c FROM cec_Fulfilment__c LIMIT 1];
            Test.startTest();
            CEC_ChequeProcess.chequeProcessWrapperResponse resp = CEC_ChequeProcess.generateChequeNumber(fulfilmentList[0].Id);
            cec_Fulfilment__c fulfilmentObj = [SELECT Id, Case__c, Cheque_Number__c, Refund_Currency__c 
                                               FROM cec_Fulfilment__c WHERE id = :fulfilmentList[0].Id LIMIT 1];
            Test.stopTest();                                   
            System.assertEquals(fulfilmentObj.Cheque_Number__c, null);
            System.assertEquals(fulfilmentObj.Refund_Currency__c, null);
            System.assertEquals(resp.status, 'E'); 
            System.assertEquals(resp.message, Label.CEC_ChequeBook_MaxLimt_reached);  
        }
    }
    
    public static testMethod void test_getChequeNumber_emptylist(){
        
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            
            CEC_Case_Market_Mapping__c cmmIndia = [SELECT Id FROM CEC_Case_Market_Mapping__c WHERE 
                                                   Market__c = 'India' LIMIT 1];
            
            mdm_Product_Category__c prodCategory = [SELECT Id FROM mdm_Product_Category__c LIMIT 1];
            
            List<CEC_ChequeBook_Detail__c> chequeBookDetailList = CEC_TestDataFactory.createChequeBookDetail(
                1, 'CB1', 'USD', 'Dollars', 'Cents',
                1, 1000, 1000, cmmIndia.Id, prodCategory.Id);
            insert chequeBookDetailList;
            
            List<cec_Fulfilment__c>  fulfilmentList = [ SELECT Id, Case__c FROM cec_Fulfilment__c LIMIT 1];
            Test.startTest();
            CEC_ChequeProcess.chequeProcessWrapperResponse resp = CEC_ChequeProcess.generateChequeNumber(fulfilmentList[0].Id);
            cec_Fulfilment__c fulfilmentObj = [SELECT Id, Case__c, Cheque_Number__c, Refund_Currency__c 
                                               FROM cec_Fulfilment__c WHERE id = :fulfilmentList[0].Id LIMIT 1];
            Test.stopTest();
            System.assertEquals(fulfilmentObj.Cheque_Number__c, null);
            System.assertEquals(fulfilmentObj.Refund_Currency__c, null);
            System.assertEquals(resp.status, 'E'); 
            System.assertEquals(resp.message, Label.CEC_ChequeBook_DetailsMissing);  
        }
    }
    
    public static testMethod void test_getChequeNumber_nullCheck(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            Test.startTest();
            CEC_ChequeProcess.chequeProcessWrapperResponse chequeProcessWrp = new CEC_ChequeProcess.chequeProcessWrapperResponse();
            
            CEC_ChequeProcess.generateChequeNumber(null);
            Test.stopTest();
            
            system.assertEquals(null, chequeProcessWrp.status); 
        }
    }
    
    public static testMethod void test_beforeUpdate(){
        
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            
            CEC_FulfilmentHelper fulfilmentHelper = new CEC_FulfilmentHelper();
            
            List<cec_Enclosure__c> enclousreList = CEC_TestDataFactory.createEnclosure(5, 'UK-Enclosure:', null, 'United Kingdom', null, null, 0, 0);
            insert enclousreList;
            
            Integer enCount = [select count() from cec_Enclosure__c where name like 'UK%' ];
            System.assertEquals(enCount,5);
            
            List<cec_Fulfilment__c>  oldFulfilmentList = [ SELECT ID,Enclosure1_Quantity__c,Enclosure2_Quantity__c,
                                                          Enclosure3_Quantity__c,Enclosure4_Quantity__c,
                                                          Enclosure5_Quantity__c FROM cec_Fulfilment__c LIMIT 1];
            
            cec_Fulfilment__c oldFulfilmentObj = oldFulfilmentList[0];
            oldFulfilmentObj.Enclosure1__c = enclousreList[0].Id;
            oldFulfilmentObj.Enclosure2__c = enclousreList[1].Id;
            oldFulfilmentObj.Enclosure3__c = enclousreList[2].Id;
            oldFulfilmentObj.Enclosure4__c = enclousreList[3].Id;
            oldFulfilmentObj.Enclosure5__c = enclousreList[4].Id;
            
            oldFulfilmentObj.Enclosure1_Quantity__c = '1';
            oldFulfilmentObj.Enclosure2_Quantity__c = '2';
            oldFulfilmentObj.Enclosure3_Quantity__c = '3';
            oldFulfilmentObj.Enclosure4_Quantity__c = '4';
            oldFulfilmentObj.Enclosure5_Quantity__c = '5';
            
            update oldFulfilmentObj;
            
            
            Integer fulfilmentEnclosureCount = [SELECT count() FROM CEC_Fulfilment_Enclosure__c];
            System.assertEquals(fulfilmentEnclosureCount,5);
            
            List<cec_Fulfilment__c>  newFulfilmentList1 = [SELECT ID,Enclosure1_Quantity__c,Enclosure2_Quantity__c,
                                                           Enclosure3_Quantity__c,Enclosure4_Quantity__c,Enclosure5_Quantity__c
                                                           FROM cec_Fulfilment__c where Id = :oldFulfilmentObj.Id];
            newFulfilmentList1[0].Enclosure1_Quantity__c = '1';
            newFulfilmentList1[0].Enclosure2_Quantity__c = '1';
            newFulfilmentList1[0].Enclosure3_Quantity__c = '1';
            newFulfilmentList1[0].Enclosure4_Quantity__c = '1';
            newFulfilmentList1[0].Enclosure5_Quantity__c = '1';
            
            update newFulfilmentList1;
            Map<Id, cec_Fulfilment__c> oldFulfilmentMap = new Map<Id, cec_Fulfilment__c>();
            oldFulfilmentMap.put(oldFulfilmentObj.Id, oldFulfilmentObj);
            fulfilmentHelper.upsertFulfilmentEnclosure(newFulfilmentList1,oldFulfilmentMap);
            
            Integer fulfilmentEnclosureCount1 = [select count() from CEC_Fulfilment_Enclosure__c];
            System.assertEquals(fulfilmentEnclosureCount1,5);          
            
            
            List<cec_Fulfilment__c>  newFulfilmentList2 = [select ID,Enclosure1__c,Enclosure2__c,Enclosure3__c,
                                                           Enclosure4__c,Enclosure5__c,Enclosure1_Quantity__c,
                                                           Enclosure2_Quantity__c,Enclosure3_Quantity__c,
                                                           Enclosure4_Quantity__c,Enclosure5_Quantity__c from
                                                           cec_Fulfilment__c where id = :oldFulfilmentObj.Id];
            
            
            newFulfilmentList2[0].Enclosure3__c = null;
            newFulfilmentList2[0].Enclosure4__c = null;
            newFulfilmentList2[0].Enclosure5__c = null;
            
            newFulfilmentList2[0].Enclosure3_Quantity__c = null;
            newFulfilmentList2[0].Enclosure4_Quantity__c = null;
            newFulfilmentList2[0].Enclosure5_Quantity__c = null;          
            
            update newFulfilmentList2;
            Map<Id, cec_Fulfilment__c> oldFulfilmentMap2 = new Map<Id, cec_Fulfilment__c>();
            oldFulfilmentMap2.put(newFulfilmentList1[0].Id, newFulfilmentList1[0]);
            Test.startTest();
            fulfilmentHelper.deleteFulfilmentEnclosure(newFulfilmentList2,oldFulfilmentMap2);
            Test.stopTest();
            Integer fulfilmentEnclosureCount2 = [select count() from CEC_Fulfilment_Enclosure__c];
            System.assertEquals(fulfilmentEnclosureCount2, 2);   
        }
        
    }
    
    
    /* -- Samrin Changes For US - AutoEnclousure */  
    public static testMethod void test_EnclousurePopulatedCheck(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            List<mdm_Product_Category__c> prodCategoryList = [SELECT Id FROM mdm_Product_Category__c LIMIT 1];
            List<mdm_Reason_Code__c> reasonCodeList = [SELECT Id FROM mdm_Reason_Code__c LIMIT 1];
            
            // Add Encolsures 
            List<cec_Enclosure__c> enclosureListUK = CEC_TestDataFactory.createEnclosure(6, 'UK-Enclosure:', null, 
                                                                                         'United Kingdom', null, null, 0, 0);
            insert enclosureListUK;
            
            List<cec_Alert_Rule__c> noDayCodeAlertRuleList = 
                CEC_TestDataFactory.createAlertRule(4,'Safety','0','5','United Kingdom',
                                                    reasonCodeList.get(0).Id,prodCategoryList.get(0).Id,
                                                    null,false,false,false,1);
            insert noDayCodeAlertRuleList;
            
            List<cec_Alert_Action__c> masterAlertActionList = new List<cec_Alert_Action__c>();
            masterAlertActionList.addAll(CEC_TestDataFactory.createFulfilmentAlertAction(1, 'United Kingdom',
                                                                                         enclosureListUK[0].Id, null, null, null, enclosureListUK[4].Id,
                                                                                         noDayCodeAlertRuleList[0].Id));
            
            masterAlertActionList.addAll(CEC_TestDataFactory.createFulfilmentAlertAction(1, 'United Kingdom',
                                                                                         enclosureListUK[0].Id, enclosureListUK[1].Id, null, null, 
                                                                                         enclosureListUK[4].Id, noDayCodeAlertRuleList[1].Id));
            
            masterAlertActionList.addAll(CEC_TestDataFactory.createFulfilmentAlertAction(1, 'United Kingdom',
                                                                                         enclosureListUK[0].Id, null, enclosureListUK[2].Id, enclosureListUK[3].Id, 
                                                                                         null, noDayCodeAlertRuleList[2].Id));
            
            masterAlertActionList.addAll(CEC_TestDataFactory.createFulfilmentAlertAction(1, 'United Kingdom',
                                                                                         null, enclosureListUK[1].Id, null, null, 
                                                                                         null, noDayCodeAlertRuleList[3].Id));
            insert masterAlertActionList;       
            
            Case caseObj = [SELECT Id, Reason_Code__c, Account.PersonMailingCountry FROM Case LIMIT 1];
            caseObj.Reason_Code__c = null;
            update caseObj;
            
            caseObj.Reason_Code__c = reasonCodeList.get(0).Id;
            caseObj.Production_Code__c = null;
            caseObj.DayCode__c = null;
            update caseObj;
            // Call to the Functionality of  CSC : 2765  :  US-009 Letter/Enclosure auto population
            
            CEC_AlertFulfilmentEnclosureHelper.AlertFulfilmentEnclosureHelperWrapperResponse result = new   CEC_AlertFulfilmentEnclosureHelper.AlertFulfilmentEnclosureHelperWrapperResponse ();
            result = CEC_AlertFulfilmentEnclosureHelper.populateEnclosureDetails(caseObj.ID,
                                                                                 caseObj.Account.PersonMailingCountry);
            System.assertEquals('Success', result.message);
            System.assertEquals(5, result.enclosuresList.size());
            System.debug('********** RESULT = ' + result);
            //Fulfilment  
            cec_Fulfilment__c newFulfilment = new cec_Fulfilment__c();
            newFulfilment.Case__c = caseObj.id;
            newFulfilment.Country__c = caseObj.Account.PersonMailingCountry; 
            if (result.status == 'S'){
                
                if(result.enclosuresList.size()>0 )
                {
                    if(result.enclosuresList.get(0) !=null)
                    {
                        newFulfilment.Enclosure1__c = result.enclosuresList.get(0);
                        newFulfilment.Enclosure1_Quantity__c='1';
                    }
                    if(result.enclosuresList.get(1) !=null)
                    {
                        newFulfilment.Enclosure2__c = result.enclosuresList.get(1);
                        newFulfilment.Enclosure2_Quantity__c='1';
                    }
                    if(result.enclosuresList.get(2) !=null)
                    {
                        newFulfilment.Enclosure3__c = result.enclosuresList.get(2);
                        newFulfilment.Enclosure3_Quantity__c='1';
                    }
                    if(result.enclosuresList.get(3) !=null)
                    {
                        newFulfilment.Enclosure4__c = result.enclosuresList.get(3);
                        newFulfilment.Enclosure4_Quantity__c='1';
                    }
                    if(result.enclosuresList.get(4)!= null)
                    {
                        newFulfilment.Enclosure5__c = result.enclosuresList.get(4);
                        newFulfilment.Enclosure5_Quantity__c='1';
                    }
                }
            }
            
            Insert  newFulfilment;
            
            
            cec_Fulfilment__c  fulfilmenttemp  = [SELECT  Id, Name , Enclosure1__c,Enclosure2__c,Enclosure3__c,
                                                  Enclosure4__c,Enclosure5__c,Enclosure1_Quantity__c,Enclosure2_Quantity__c,
                                                  Enclosure3_Quantity__c,Enclosure4_Quantity__c,Enclosure5_Quantity__c 
                                                  FROM cec_Fulfilment__c 
                                                  WHERE id =:newFulfilment.Id ];
            
            
            // Rajesh Code start
            System.assertNotEquals(fulfilmenttemp.Enclosure1__c,null);
            System.assertNotEquals(fulfilmenttemp.Enclosure2__c,null);
            System.assertNotEquals(fulfilmenttemp.Enclosure3__c,null);
            System.assertNotEquals(fulfilmenttemp.Enclosure4__c,null);
            System.assertNotEquals(fulfilmenttemp.Enclosure5__c,null);
            System.assertEquals(fulfilmenttemp.Enclosure1_Quantity__c,'1');
            System.assertEquals(fulfilmenttemp.Enclosure2_Quantity__c,'1');
            System.assertEquals(fulfilmenttemp.Enclosure3_Quantity__c,'1');
            System.assertEquals(fulfilmenttemp.Enclosure4_Quantity__c,'1');
            System.assertEquals(fulfilmenttemp.Enclosure5_Quantity__c,'1');
            
            integer ffENCount = [select count() from CEC_Fulfilment_Enclosure__c ];
            System.assertEquals(5,ffENCount);
            
        }
    }
    
    public static testMethod void test_convertRefundValueToWords(){
        
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            User loggedinuser = [select Quality_Check_Percentage__c,Max_Refund_Amount__c, FirstName from User where id = :UserInfo.getUserId()];
            loggedinuser.Refund_Authorization_Limit__c ='Level 4';
            update loggedinuser;
            
            CEC_Case_Market_Mapping__c cmmUK = [SELECT Id FROM CEC_Case_Market_Mapping__c WHERE 
                                                Market__c = 'United Kingdom' LIMIT 1];
            
            mdm_Product_Category__c prodCategory = [SELECT Id FROM mdm_Product_Category__c LIMIT 1];
            
            List<CEC_ChequeBook_Detail__c> chequeBookDetailList = CEC_TestDataFactory.createChequeBookDetail(
                1, 'CB1', 'USD', 'Dollars', 'Cents',
                1, 11, 1000, cmmUK.Id, prodCategory.Id);
            insert chequeBookDetailList;
            
            List<cec_Fulfilment__c>  fulfilmentList = [ SELECT Id, Case__c FROM cec_Fulfilment__c LIMIT 1];
            cec_Fulfilment__c fulfilmentObj = fulfilmentList.get(0);
            Map<Id, cec_Fulfilment__c> oldFulfilmentMap = new Map<Id, cec_Fulfilment__c>();
            oldFulfilmentMap.put(fulfilmentObj.Id, fulfilmentObj);
            
            CEC_ChequeProcess.generateChequeNumber(fulfilmentList[0].Id);
            
            fulfilmentObj.Refund_Value__c = 10.11;
            update fulfilmentObj;
            
            CEC_FulfilmentHelper fulfilmentHelper = new CEC_FulfilmentHelper();
            fulfilmentHelper.ConvertRefundValueToWords(fulfilmentList, oldFulfilmentMap);
            
            cec_Fulfilment__c assertFulfilmentResult = [SELECT ID,Cheque_Number__c,ChequeBook__c,Refund_Value__c,
                                                        Refund_Value_in_Words__c FROM 
                                                        cec_Fulfilment__c WHERE id = :fulfilmentObj.Id];
            
            System.assertEquals(assertFulfilmentResult.Refund_Value__c, 10.11);
            System.assertEquals(assertFulfilmentResult.Cheque_Number__c, '12');
            System.assertEquals(assertFulfilmentResult.Refund_Value_in_Words__c, 'Ten Dollars and Eleven Cents');
            
            fulfilmentObj.Refund_Value__c = 112.33;
            update fulfilmentObj;            
            fulfilmentHelper.ConvertRefundValueToWords(fulfilmentList, oldFulfilmentMap);            
            assertFulfilmentResult = [SELECT ID,Cheque_Number__c,ChequeBook__c,Refund_Value__c, Refund_Value_in_Words__c 
                                      FROM cec_Fulfilment__c WHERE id = :fulfilmentObj.Id];
            
            System.assertEquals(assertFulfilmentResult.Refund_Value__c, 112.33);
            System.assertEquals(assertFulfilmentResult.Cheque_Number__c, '12');
            System.assertEquals(assertFulfilmentResult.Refund_Value_in_Words__c, 'One Hundred and Twelve Dollars and Thirty Three Cents');               
            
            
            fulfilmentObj.Refund_Value__c = 112;
            update fulfilmentObj;            
            fulfilmentHelper.ConvertRefundValueToWords(fulfilmentList, oldFulfilmentMap);            
            assertFulfilmentResult = [SELECT ID,Cheque_Number__c,ChequeBook__c,Refund_Value__c, Refund_Value_in_Words__c 
                                      FROM cec_Fulfilment__c WHERE id = :fulfilmentObj.Id];
            
            System.assertEquals(assertFulfilmentResult.Refund_Value__c, 112);
            System.assertEquals(assertFulfilmentResult.Cheque_Number__c, '12');
            System.assertEquals(assertFulfilmentResult.Refund_Value_in_Words__c, 'One Hundred and Twelve Dollars');    
            
            fulfilmentObj.Refund_Value__c = 3000;
            update fulfilmentObj;            
            fulfilmentHelper.ConvertRefundValueToWords(fulfilmentList, oldFulfilmentMap);            
            assertFulfilmentResult = [SELECT ID,Cheque_Number__c,ChequeBook__c,Refund_Value__c, Refund_Value_in_Words__c 
                                      FROM cec_Fulfilment__c WHERE id = :fulfilmentObj.Id];
            
            System.assertEquals(assertFulfilmentResult.Refund_Value__c, 3000);
            System.assertEquals(assertFulfilmentResult.Cheque_Number__c, '12');
            System.assertEquals(assertFulfilmentResult.Refund_Value_in_Words__c, 'Three Thousand Dollars');             
            
            
            fulfilmentObj.Refund_Value__c = 3000.10;
            update fulfilmentObj;            
            fulfilmentHelper.ConvertRefundValueToWords(fulfilmentList, oldFulfilmentMap);            
            assertFulfilmentResult = [SELECT ID,Cheque_Number__c,ChequeBook__c,Refund_Value__c, Refund_Value_in_Words__c 
                                      FROM cec_Fulfilment__c WHERE id = :fulfilmentObj.Id];
            
            System.assertEquals(assertFulfilmentResult.Refund_Value__c, 3000.10);
            System.assertEquals(assertFulfilmentResult.Cheque_Number__c, '12');
            System.assertEquals(assertFulfilmentResult.Refund_Value_in_Words__c, 'Three Thousand Dollars and Ten Cents');                   
            
            fulfilmentObj.Refund_Value__c = 3;
            update fulfilmentObj;            
            fulfilmentHelper.ConvertRefundValueToWords(fulfilmentList, oldFulfilmentMap);            
            assertFulfilmentResult = [SELECT ID,Cheque_Number__c,ChequeBook__c,Refund_Value__c, Refund_Value_in_Words__c 
                                      FROM cec_Fulfilment__c WHERE id = :fulfilmentObj.Id];
            
            System.assertEquals(assertFulfilmentResult.Refund_Value__c, 3);
            System.assertEquals(assertFulfilmentResult.Cheque_Number__c, '12');
            System.assertEquals(assertFulfilmentResult.Refund_Value_in_Words__c, 'Three Dollars');  
            
        }
    }
    
    public static testMethod void test_AssignNewDebitCardToAccount(){
        
        User u = CEC_TestDataFactory.createDebitCardProcessTestUser();
        System.runAs(u) {
            mdm_Geography__c  geographyUK = [SELECT Id FROM mdm_Geography__c WHERE name='United Kingdom' LIMIT 1];
            Account accountBeforeNewDebitCard = [SELECT Id FROM Account LIMIT 1];
            List<CEC_Debit_Card_Detail__c> issuedDebitCardDetailList = CEC_TestDataFactory.createDebitCardDetail(
                                                        1, '82472182382234', CEC_Constants.ISSUED, 
                                                        accountBeforeNewDebitCard.Id, geographyUK.Id);
            insert issuedDebitCardDetailList;
            
            List<CEC_Debit_Card_Detail__c> newDebitCardDetailList = CEC_TestDataFactory.createDebitCardDetail(
                                                        1, '23847238497238', CEC_Constants.STATUS_NEW, null, geographyUK.Id);
            insert newDebitCardDetailList; 
            
            List<cec_Fulfilment__c>  fulfilmentList = [SELECT Id, Account_Card_Number__c, Issue_Card__c FROM cec_Fulfilment__c LIMIT 1];
            fulfilmentList[0].Account_Card_Number__c = '82472182382234';
            fulfilmentList[0].Issue_Card__c = true;
            update fulfilmentList;
            
            CEC_DebitCardProcess.getDebitCardNumber(fulfilmentList[0].Id);
            cec_Fulfilment__c fulfilmentObj = [SELECT Id, Case__c, Debit_Card_Number__r.name
                                               FROM cec_Fulfilment__c WHERE id = :fulfilmentList[0].Id LIMIT 1];
            
            Account accountObj = [SELECT Id, Debit_Card_Number__c FROM Account LIMIT 1];
            CEC_Debit_Card_Detail__c issuedDebitCardDetail = [SELECT Id, Status__c FROM CEC_Debit_Card_Detail__c 
                                                              WHERE Name = '23847238497238' LIMIT 1];
            CEC_Debit_Card_Detail__c cancelledDebitCardDetail = [SELECT Id, Status__c, Active__c FROM 
                                                                 CEC_Debit_Card_Detail__c WHERE Name = '82472182382234' LIMIT 1];                                            
            System.assertEquals(fulfilmentObj.Debit_Card_Number__r.name, '23847238497238');
            System.assertEquals(accountObj.Debit_Card_Number__c, issuedDebitCardDetail.Id);
            System.assertEquals(issuedDebitCardDetail.Status__c, CEC_Constants.ISSUED);
            System.assertEquals(cancelledDebitCardDetail.Status__c, CEC_Constants.CANCELLED);
            System.assertEquals(cancelledDebitCardDetail.Active__c, false);
        }
    }    
    
    public static testMethod void test_ReissueDebitCardToAccount(){
        system.debug('in reissueDebitToAccount @#@#@@' );
        User u = CEC_TestDataFactory.createDebitCardProcessTestUser();
        System.runAs(u) {
            
            mdm_Geography__c  geographyUK = [SELECT Id FROM mdm_Geography__c WHERE name='United Kingdom' LIMIT 1];
            Account accountBeforeReIssue = [SELECT Id,Debit_Card_Number__c FROM Account LIMIT 1];
            
            List<CEC_Debit_Card_Detail__c> issuedDebitCardDetailList = CEC_TestDataFactory.createDebitCardDetail(
                                                        1, '82472182382234', CEC_Constants.ISSUED, 
                                                        accountBeforeReIssue.Id, geographyUK.Id);
            insert issuedDebitCardDetailList;
            
            List<CEC_Debit_Card_Detail__c> newDebitCardDetailList = CEC_TestDataFactory.createDebitCardDetail(
                                                        1, '23847238497238', CEC_Constants.STATUS_NEW, null, geographyUK.Id);
            insert newDebitCardDetailList;
            
            
            accountBeforeReIssue.Debit_Card_Number__c = issuedDebitCardDetailList[0].Id;
            update accountBeforeReIssue;
            
            List<cec_Fulfilment__c>  fulfilmentList = [SELECT Id, Account_Card_Number__c, Issue_Card__c 
                                                        FROM cec_Fulfilment__c LIMIT 1];
            fulfilmentList[0].Account_Card_Number__c = '82472182382234';
            fulfilmentList[0].Issue_Card__c = false;
            update fulfilmentList;
            
            CEC_DebitCardProcess.getDebitCardNumber(fulfilmentList[0].Id);
            cec_Fulfilment__c fulfilmentObj = [SELECT Id, Case__c, Debit_Card_Number__r.name,Debit_Card_Number__r.Status__c
                                               FROM cec_Fulfilment__c WHERE id = :fulfilmentList[0].Id LIMIT 1];
            Account accountObj = [SELECT Id, Debit_Card_Number__c FROM Account LIMIT 1];
            System.assertEquals(fulfilmentObj.Debit_Card_Number__r.name, '82472182382234');
            System.assertEquals(fulfilmentObj.Debit_Card_Number__r.Status__c, CEC_Constants.REACTIVATED);
            System.assertEquals(accountObj.Debit_Card_Number__c, issuedDebitCardDetailList[0].Id);
        }
    } 
    
    public static testMethod void test_updateAccountAndDebitCardDetails(){
        User u = CEC_TestDataFactory.createDebitCardProcessTestUser();
        System.runAs(u) {
            
            mdm_Geography__c  geographyUK = [SELECT Id FROM mdm_Geography__c WHERE name='United Kingdom' LIMIT 1];
            Account accountBeforeNewDebitCard = [SELECT Id FROM Account LIMIT 1];
            List<CEC_Debit_Card_Detail__c> issuedDebitCardDetailList = CEC_TestDataFactory.createDebitCardDetail(
                                                        1, '82472182382234', CEC_Constants.ISSUED, 
                                                        accountBeforeNewDebitCard.Id, geographyUK.Id);
            insert issuedDebitCardDetailList;
            
            List<CEC_Debit_Card_Detail__c> newDebitCardDetailList = CEC_TestDataFactory.createDebitCardDetail(
                                                        1, '23847238497238', CEC_Constants.STATUS_NEW, null, geographyUK.Id);
            insert newDebitCardDetailList; 
            
            List<cec_Fulfilment__c>  fulfilmentList = [SELECT Id, Account_Card_Number__c, Issue_Card__c FROM cec_Fulfilment__c LIMIT 1];
            fulfilmentList[0].Account_Card_Number__c = '82472182382234';
            fulfilmentList[0].Issue_Card__c = true;
            fulfilmentList[0].Local_Identifier__c='2112145';            
            fulfilmentList[0].Date_of_Birth__c=System.today();
            fulfilmentList[0].Debit_Card_Value__c=93;
            
            update fulfilmentList;
            // issue the new card
            CEC_DebitCardProcess.getDebitCardNumber(fulfilmentList[0].Id);
            // update the card value
            fulfilmentList[0].isApproved__c=true;
            update fulfilmentList;

            cec_Fulfilment__c fulfilmentObj = [SELECT Id, Case__c, Debit_Card_Number__r.name
                                               FROM cec_Fulfilment__c WHERE id = :fulfilmentList[0].Id LIMIT 1];
            
            Account accountObj = [SELECT Id, Debit_Card_Number__c, Local_Identifier__c FROM Account LIMIT 1];
            CEC_Debit_Card_Detail__c issuedDebitCardDetail = [SELECT Id, Status__c, Card_Value__c FROM CEC_Debit_Card_Detail__c 
                                                              WHERE Name = '23847238497238' LIMIT 1];
            CEC_Debit_Card_Detail__c cancelledDebitCardDetail = [SELECT Id, Status__c, Active__c FROM 
                                                                 CEC_Debit_Card_Detail__c WHERE Name = '82472182382234' LIMIT 1];                                            
            System.assertEquals(fulfilmentObj.Debit_Card_Number__r.name, '23847238497238');
            System.assertEquals(accountObj.Debit_Card_Number__c, issuedDebitCardDetail.Id);
            System.assertEquals(issuedDebitCardDetail.Status__c, CEC_Constants.ISSUED);
            System.assertEquals(issuedDebitCardDetail.Card_Value__c, 218);
            System.assertEquals(cancelledDebitCardDetail.Status__c, CEC_Constants.CANCELLED);
            System.assertEquals(cancelledDebitCardDetail.Active__c, false);
            
        }
    }
    
    public static testMethod void test_AssignNewEVoucherToAccount(){
        
        User u = CEC_TestDataFactory.createEvoucherProcessTestUser();
        System.runAs(u) {
            mdm_Geography__c  geographyUK = [SELECT Id FROM mdm_Geography__c WHERE name='United Kingdom' LIMIT 1];
            Account accountBeforeNewEVoucher = [SELECT Id FROM Account LIMIT 1];
            List<CEC_E_Voucher_Details__c> issuedEvoucherDetailList = CEC_TestDataFactory.createEvoucherDetail(
                                                        1, '11111111', CEC_Constants.ISSUED, 
                                                        accountBeforeNewEvoucher.Id, geographyUK.Id);
            insert issuedEvoucherDetailList;
            
            List<CEC_E_Voucher_Details__c> newEvoucherDetailList = CEC_TestDataFactory.createEvoucherDetail(
                                                        1, '22222222', CEC_Constants.STATUS_NEW, null, geographyUK.Id);
            insert newEvoucherDetailList; 
            
            List<cec_Fulfilment__c>  fulfilmentList = [SELECT Id FROM cec_Fulfilment__c LIMIT 1];

            
            CEC_EvoucherProcess.getEvoucherNumber(fulfilmentList[0].Id);
            cec_Fulfilment__c fulfilmentObj = [SELECT Id, Case__c, E_Voucher_Number__r.name 
                                               FROM cec_Fulfilment__c WHERE id = :fulfilmentList[0].Id LIMIT 1];
            
            
            CEC_E_Voucher_Details__c issuedEvoucherDetail = [SELECT Id, Status__c FROM CEC_E_Voucher_Details__c 
                                                              WHERE Name = '22222222' LIMIT 1];
                                           
            System.assertEquals(fulfilmentObj.E_Voucher_Number__r.name, '22222222');
            
            System.assertEquals(issuedEvoucherDetail.Status__c, CEC_Constants.ISSUED);
            

        }
    }  
    
    public static testMethod void test_updateAccountAndEvoucherDetails(){
        User u = CEC_TestDataFactory.createEvoucherProcessTestUser();
        System.runAs(u) {
            Account accountBeforeNewEVoucher = [SELECT Id FROM Account LIMIT 1];
            mdm_Geography__c  geographyUK = [SELECT Id FROM mdm_Geography__c WHERE name='United Kingdom' LIMIT 1];
            Account accountBeforeNewDebitCard = [SELECT Id FROM Account LIMIT 1];
             List<CEC_E_Voucher_Details__c> issuedEvoucherDetailList = CEC_TestDataFactory.createEvoucherDetail(
                                                        1, '11111111', CEC_Constants.ISSUED, 
                                                        accountBeforeNewEvoucher.Id, geographyUK.Id);
            insert issuedEvoucherDetailList;
            
            List<CEC_E_Voucher_Details__c> newEvoucherDetailList = CEC_TestDataFactory.createEvoucherDetail(
                                                        1, '22222222', CEC_Constants.STATUS_NEW, null, geographyUK.Id);
            insert newEvoucherDetailList;
            CEC_E_Voucher_Details__c issuedEvoucherDetail = [SELECT Id, Status__c, Voucher_Value__c FROM CEC_E_Voucher_Details__c 
                                                              WHERE Name = '11111111' LIMIT 1];
            
            List<cec_Fulfilment__c>  fulfilmentList = [SELECT Id, E_Voucher_Number__r.name FROM cec_Fulfilment__c LIMIT 1];
            //fulfilmentList[0].E_Voucher_Number__c = issuedEvoucherDetail.id;
            
            fulfilmentList[0].Local_Identifier__c='2112145';            
            fulfilmentList[0].Date_of_Birth__c=System.today();
            fulfilmentList[0].E_Voucher_Value__c=10;
                        
            update fulfilmentList;
            CEC_EvoucherProcess.getEvoucherNumber(fulfilmentList[0].Id);
             fulfilmentList[0].isApproved__c=true;    
             update fulfilmentList;
             
            CEC_E_Voucher_Details__c issuedEvoucherDetail1 = [SELECT Id, Status__c, Voucher_Value__c FROM CEC_E_Voucher_Details__c 
                                                              WHERE Name = '22222222' LIMIT 1];
                                                              
            System.assertEquals(issuedEvoucherDetail1.Voucher_Value__c, 10);
            
        }
    }     
}