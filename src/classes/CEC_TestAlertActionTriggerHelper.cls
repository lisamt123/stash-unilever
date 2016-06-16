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
            List<cec_Alert_Action__c> masterAlertActionList = new List<cec_Alert_Action__c>();
            List<mdm_Product_Category__c> prodCategoryList = 
                                                CEC_TestDataFactory.createProductCategory(1);
            insert prodCategoryList;

            List<mdm_Case_Product__c> caseProductList = 
                                                CEC_TestDataFactory.createCaseProduct(1, prodCategoryList.get(0).Id);
            insert caseProductList;

            List<mdm_Global_Listening_Tree__c> globalListeningTreeList = 
                                                CEC_TestDataFactory.createGlobalListeningTree(1);
            insert globalListeningTreeList;
            
<<<<<<< HEAD
            psalist.add(psa);
        
        }
        
        insert psalist;
        
        Group GR = [SELECT Id,name FROM Group WHERE Name = 'CEC - Knowledge Manager'];
        GroupMember GM = new GroupMember();
        GM.GroupId = GR.id;
        GM.UserOrGroupId = u.Id;
        insert GM;
        
        return u;
    
    }
 // Test Method for validate email template
    static testMethod void validateEmailtemplate(){
    User u = insertUser();
        
         System.runAs(u)
         {
        
        mdm_Product_Category__c pCategory = new mdm_Product_Category__c(name='ProductCategory', L0_Product_Category__c='Foods Category');
        insert pCategory;
        
        mdm_Global_Listening_Tree__c gListingTree = new mdm_Global_Listening_Tree__c(L1_Desc__c='Complaint', 
                                                                L2_Desc__c = 'Product', L3_Desc__c = 'Foreign matter',
                                                                L4_Desc__c = 'Unidentifiable Foreign Matter', 
                                                                L5_Desc__c = 'Foreign matter - unidentifiable');
        insert gListingTree;
=======
            List<mdm_Reason_Code__c> reasonCodeList = 
                                                CEC_TestDataFactory.createReasonCode(1, globalListeningTreeList.get(0).Id);
            insert reasonCodeList;
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b

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
        
<<<<<<< HEAD
        User u = insertUser();
        
         System.runAs(u)
         {
        mdm_Product_Category__c pCategory = new mdm_Product_Category__c(name='ProductCategory', L0_Product_Category__c='Foods Category');
        insert pCategory;
        
        mdm_Global_Listening_Tree__c gListingTree = new mdm_Global_Listening_Tree__c(L1_Desc__c='Complaint', 
                                                                L2_Desc__c = 'Product', L3_Desc__c = 'Foreign matter',
                                                                L4_Desc__c = 'Unidentifiable Foreign Matter', 
                                                                L5_Desc__c = 'Foreign matter - unidentifiable');
        insert gListingTree;

        mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason1', L5_Code__c='T5261',Global_Listening_Tree__c = gListingTree.Id);
        insert reasonObj;
        
        cec_Alert_Rule__c alertRule = new cec_Alert_Rule__c(Name = 'Rule 1', Active__c=true, Type__c='Safety', Reason_Code__c = reasonObj.id, Market__c='India',  All_Market__c = true, Threshold__c = 1, Product_Category__c = pCategory.Id, Product_Level__c = '0', Reason_Level__c = '5', Group_By_Day_Code__c = false);
        insert alertRule;
        
        Test.startTest();
        try{
        cec_Alert_Action__c alertAction = new cec_Alert_Action__c( 
        Type__c = 'Email', 
        Alert_Rule_Id__c = alertRule.id,
        Email_Template_Name__c='test' ,
        To__c='John.Smith@test.com');
        insert alertAction;
        System.assert(alertAction!=null); 
        }catch(Exception e){
            System.debug('Added error');
        }
        
        Test.stopTest();
=======
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            Test.startTest();
            cec_Alert_Rule__c alertRule = [SELECT Id FROM cec_Alert_Rule__c LIMIT 1];
            List<cec_Alert_Action__c> noDayCodeAlertActionList = CEC_TestDataFactory.createEmailAlertAction(1,
                                                                    'test', alertRule.Id);
            System.assert(noDayCodeAlertActionList[0] != null);
            System.debug('********* InValid = ' + noDayCodeAlertActionList);
            Test.stopTest();
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
        }
    }
}