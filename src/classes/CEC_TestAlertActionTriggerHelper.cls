/**********************************************************************
Name:  CEC_TestAlertActionTriggerHelper
Copyright@: 2015  Unilever
=======================================================================
=======================================================================
Purpose: This is the test class for CEC_AlertActionTriggerHelper

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0           -                 -            INITIAL DEVELOPMENT
1.1        Sathish           MAR-2016        Code Refactoring.
***********************************************************************/
@isTest(seealldata=false)
public with sharing class CEC_TestAlertActionTriggerHelper {
        
    @testSetup static void setUpTestData() {
        User u = CEC_TestDataFactory.createStandardCECTestUser();
        System.runAs(u) {
           
            List<mdm_Product_Category__c> prodCategoryList = 
                                                CEC_TestDataFactory.createProductCategory(1);
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

            List<cec_Alert_Rule__c> noDayCodeAlertRuleList = 
                                                CEC_TestDataFactory.createAlertRule(1,'Safety','0','5','United Kingdom',
                                                                    reasonCodeList.get(0).Id,prodCategoryList.get(0).Id,
                                                                    null,false,false,false,1);
            insert noDayCodeAlertRuleList;
            
        }
    }


    // Test Method for validate email template
    static testMethod void validateEmailtemplate(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            Test.startTest();
            cec_Alert_Rule__c alertRule = [SELECT Id FROM cec_Alert_Rule__c LIMIT 1];
            List<cec_Alert_Action__c> noDayCodeAlertActionList = CEC_TestDataFactory.createEmailAlertAction(1,
                                                                    'AlertTemplate', alertRule.Id);
            System.assert(noDayCodeAlertActionList[0] != null);
            System.debug('********* Valid = ' + noDayCodeAlertActionList);
            Test.stopTest();
        }
    }
    
    // Test Method for invalidate email template
    static testMethod void inValidateEmailtemplate(){
        
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            Test.startTest();
            cec_Alert_Rule__c alertRule = [SELECT Id FROM cec_Alert_Rule__c LIMIT 1];
            List<cec_Alert_Action__c> noDayCodeAlertActionList = CEC_TestDataFactory.createEmailAlertAction(1,
                                                                    'test', alertRule.Id);
            System.assert(noDayCodeAlertActionList[0] != null);
            System.debug('********* InValid = ' + noDayCodeAlertActionList);
            Test.stopTest();
        }
    }
}