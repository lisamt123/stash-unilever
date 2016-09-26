/**********************************************************************
Name:  CEC_Test_FulfilmentQualityCheckHelper
Copyright © 2014  Unilever
======================================================================
=======================================================================
Purpose: This is the test class for the Helper class for CEC_FulfilmentQualityCheckHelper                                                                                                                     
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE            DETAIL               Description
1.0 - Rajesh            19/11/2015      INITIAL DEVELOPMENT  CSR
1.0 - Masood            20/11/2015      Modification  CSR
1.1 - Sathish           Mar 2016        Code Refactoring.
***********************************************************************/

/**
Test class for the Helper class for Trigger for CEC_FulfilmentTrigger
**/

@isTest(SeeAllData=false)
public class CEC_Test_FulfilmentQualityCheckHelper  {
    /**
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
    
        }
    } 
    
    
Test method for beforeInsert() method

    public static testMethod void test_beforeInsert(){
        
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {            
            List<cec_Fulfilment__c> fulfilmentList = [SELECT Id, Case__c from cec_Fulfilment__c];
            
            CEC_FulfilmentQualityCheckHelper qualityCheckHelper = new CEC_FulfilmentQualityCheckHelper();
            qualityCheckHelper.qualityCheck(fulfilmentList);
            
            
        }
        
    }**/
    
}