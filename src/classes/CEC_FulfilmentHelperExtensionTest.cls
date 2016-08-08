/**********************************************************************
Name:  CEC_FulfilmentHelperExtensionTest
Copyright © 2014  Unilever
======================================================================
=======================================================================
Purpose: This is the test class extension for the CEC_FulfilmentHelperTest                                                                                                              
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE            DETAIL               Description
1.0 -    Masood            20/7/2016      Sonar issue           Used for code refactoring
***********************************************************************/

/*
Test class for the Helper class CEC_FulfilmentHelper
*/

@isTest
public class CEC_FulfilmentHelperExtensionTest {
    private static final string dollarConst = 'Dollars';
    private static final string centConst = 'Cents';
    
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
            
            List<Account> accountList = CEC_TestDataFactory.createTestAccounts(1, 'TestAccount', null, null, null, 
                                                                               'London', CEC_Constants.UK, null);
            
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
        }
    } 
    
    public static testMethod void test_getChequeNumber(){
        
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            
            CEC_Case_Market_Mapping__c cmmUK = [SELECT Id FROM CEC_Case_Market_Mapping__c WHERE 
                                                Market__c = 'United Kingdom' LIMIT 1];
            
            mdm_Product_Category__c prodCategory = [SELECT Id FROM mdm_Product_Category__c LIMIT 1];
            
            List<CEC_ChequeBook_Detail__c> chequeBookDetailList = CEC_TestDataFactory.createChequeBookDetail(
                1, CEC_Constants.chequebookName, CEC_Constants.USD, dollarConst, centConst,
                1, 11, 1000, cmmUK.Id, prodCategory.Id);
            insert chequeBookDetailList;
            
            List<cec_Fulfilment__c>  fulfilmentList = [ SELECT Id, Case__c FROM cec_Fulfilment__c LIMIT 1];
            Test.startTest();
            CEC_ChequeProcess.generateChequeNumber(fulfilmentList[0].Id);
            cec_Fulfilment__c fulfilmentObj = [SELECT Id, Case__c, Cheque_Number__c, Refund_Currency__c 
                                               FROM cec_Fulfilment__c WHERE id = :fulfilmentList[0].Id LIMIT 1];
            System.assertEquals(fulfilmentObj.Cheque_Number__c, '12');
            System.assertEquals(fulfilmentObj.Refund_Currency__c, CEC_Constants.USD);
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
                1, CEC_Constants.chequebookName, CEC_Constants.USD, dollarConst, centConst,
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
                1, CEC_Constants.chequebookName, CEC_Constants.USD, dollarConst, centConst,
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
    
    public static testMethod void test_AssignNewDebitCardToAccount(){
        
        User u = CEC_TestDataFactory.createDebitCardProcessTestUser();
        System.runAs(u) {
            mdm_Geography__c  geographyUK = [SELECT Id FROM mdm_Geography__c WHERE name='United Kingdom' LIMIT 1];
            Account accountBeforeNewDebitCard = [SELECT Id FROM Account LIMIT 1];
            List<CEC_Debit_Card_Detail__c> issuedDebitCardDetailList = CEC_TestDataFactory.createDebitCardDetail(
                1, CEC_Constants.issuedDebitCardNumber, CEC_Constants.ISSUED, 
                accountBeforeNewDebitCard.Id, geographyUK.Id);
            insert issuedDebitCardDetailList;
            
            List<CEC_Debit_Card_Detail__c> newDebitCardDetailList = CEC_TestDataFactory.createDebitCardDetail(
                1, CEC_Constants.newDebitCardNumber, CEC_Constants.STATUS_NEW, null, geographyUK.Id);
            insert newDebitCardDetailList; 
            
            List<cec_Fulfilment__c>  fulfilmentList = [SELECT Id, Account_Card_Number__c, Issue_Card__c FROM cec_Fulfilment__c LIMIT 1];
            fulfilmentList[0].Account_Card_Number__c = CEC_Constants.issuedDebitCardNumber;
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
            System.assertEquals(fulfilmentObj.Debit_Card_Number__r.name, CEC_Constants.newDebitCardNumber);
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
                1, CEC_Constants.issuedDebitCardNumber, CEC_Constants.ISSUED, 
                accountBeforeReIssue.Id, geographyUK.Id);
            insert issuedDebitCardDetailList;
            
            List<CEC_Debit_Card_Detail__c> newDebitCardDetailList = CEC_TestDataFactory.createDebitCardDetail(
                1, CEC_Constants.newDebitCardNumber, CEC_Constants.STATUS_NEW, null, geographyUK.Id);
            insert newDebitCardDetailList;
            
            
            accountBeforeReIssue.Debit_Card_Number__c = issuedDebitCardDetailList[0].Id;
            update accountBeforeReIssue;
            
            List<cec_Fulfilment__c>  fulfilmentList = [SELECT Id, Account_Card_Number__c, Issue_Card__c 
                                                       FROM cec_Fulfilment__c LIMIT 1];
            fulfilmentList[0].Account_Card_Number__c = CEC_Constants.issuedDebitCardNumber;
            fulfilmentList[0].Issue_Card__c = false;
            update fulfilmentList;
            
            CEC_DebitCardProcess.getDebitCardNumber(fulfilmentList[0].Id);
            cec_Fulfilment__c fulfilmentObj = [SELECT Id, Case__c, Debit_Card_Number__r.name,Debit_Card_Number__r.Status__c
                                               FROM cec_Fulfilment__c WHERE id = :fulfilmentList[0].Id LIMIT 1];
            Account accountObj = [SELECT Id, Debit_Card_Number__c FROM Account LIMIT 1];
            System.assertEquals(fulfilmentObj.Debit_Card_Number__r.name, CEC_Constants.issuedDebitCardNumber);
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
                1, CEC_Constants.issuedDebitCardNumber, CEC_Constants.ISSUED, 
                accountBeforeNewDebitCard.Id, geographyUK.Id);
            insert issuedDebitCardDetailList;
            
            List<CEC_Debit_Card_Detail__c> newDebitCardDetailList = CEC_TestDataFactory.createDebitCardDetail(
                1, CEC_Constants.newDebitCardNumber, CEC_Constants.STATUS_NEW, null, geographyUK.Id);
            insert newDebitCardDetailList; 
            
            List<cec_Fulfilment__c>  fulfilmentList = [SELECT Id, Account_Card_Number__c, Issue_Card__c FROM cec_Fulfilment__c LIMIT 1];
            fulfilmentList[0].Account_Card_Number__c = CEC_Constants.issuedDebitCardNumber;
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
            System.assertEquals(fulfilmentObj.Debit_Card_Number__r.name, CEC_Constants.newDebitCardNumber);
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
            //Account accountBeforeNewDebitCard = [SELECT Id FROM Account LIMIT 1];
            List<CEC_E_Voucher_Details__c> issuedEvoucherDetailList = CEC_TestDataFactory.createEvoucherDetail(
                1, '11111111', CEC_Constants.ISSUED, 
                accountBeforeNewEvoucher.Id, geographyUK.Id);
            insert issuedEvoucherDetailList;
            
            List<CEC_E_Voucher_Details__c> newEvoucherDetailList = CEC_TestDataFactory.createEvoucherDetail(
                1, '22222222', CEC_Constants.STATUS_NEW, null, geographyUK.Id);
            insert newEvoucherDetailList;
            //CEC_E_Voucher_Details__c issuedEvoucherDetail = [SELECT Id, Status__c, Voucher_Value__c FROM CEC_E_Voucher_Details__c 
            //                                                 WHERE Name = '11111111' LIMIT 1];
            
            List<cec_Fulfilment__c>  fulfilmentList = [SELECT Id, E_Voucher_Number__r.name FROM cec_Fulfilment__c LIMIT 1];
            
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