/**********************************************************************
Name:  CEC_AlertActionHelperTest
Copyright@: 2015  Unilever
=======================================================================
=======================================================================
Purpose: This is the test class for CEC_InstantAlertActionHelper 
&& CEC_BatchAlertActionHelper

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0                                          INITIAL DEVELOPMENT
1.1        Sathish           DEC-2015        Updated test for 'Questionnaire' Alert Type 
1.2        Sathish           MAR-2016        Code Refactoring.
***********************************************************************/
@isTest(seealldata = false)
public with sharing class CEC_AlertActionHelperTest {    
    
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

            List<cec_Alert_Rule__c> noDayCodeAlertRuleList = 
                                                CEC_TestDataFactory.createAlertRule(1,'Safety','0','5',CEC_Constants.UK,
                                                                    reasonCodeList.get(0).Id,prodCategoryList.get(0).Id,
                                                                    null,false,false,false,1);
            insert noDayCodeAlertRuleList;
            
            List<cec_Alert_Action__c> noDayCodeAlertActionList = 
                                                CEC_TestDataFactory.createEmailAlertAction(1, 'AlertTemplate', 
                                                                    noDayCodeAlertRuleList[0].Id);
            masterAlertActionList.addAll(noDayCodeAlertActionList);

            List<cec_Alert_Rule__c> dayCodeAlertRuleList = 
                                                CEC_TestDataFactory.createAlertRule(1,'Safety','0','5',CEC_Constants.UK,
                                                                    reasonCodeList.get(0).Id,prodCategoryList.get(0).Id,
                                                                    null,false,true,false,1);
            insert dayCodeAlertRuleList;
            
            List<cec_Alert_Action__c> dayCodeEmailAlertActionList = 
                                                CEC_TestDataFactory.createEmailAlertAction(1, 'AlertTemplate', 
                                                                    dayCodeAlertRuleList[0].Id);
            masterAlertActionList.addAll(dayCodeEmailAlertActionList);

            List<cec_Alert_Action__c> dayCodeQuestionAlertActionList1 = 
                                                CEC_TestDataFactory.createQuestionnaireAlertAction(1, 
                                                'abcdefgh','Test Survey Name', 'CaseNumber', 'CaseOrigin',
                                                'CaseOpenedDate','ProductCode','ProductCodeDesc',
                                                'ShortCode','ProductionCode','UsedProdPreviously','Verbatim',
                                                null,'CaseOwner', dayCodeAlertRuleList[0].Id);
            masterAlertActionList.addAll(dayCodeQuestionAlertActionList1);

            List<cec_Alert_Action__c> dayCodeQuestionAlertActionList2 = 
                                                CEC_TestDataFactory.createQuestionnaireAlertAction(1, 
                                                'xyz123','Test Survey Name_2', 'CaseNumber', 'CaseOrigin',
                                                'CaseOpenedDate','ProductCodeDesc','ShortCode',
                                                'CaseOwner','ProductionCode','CaseNumber','Verbatim',
                                                null,'ProductCode', dayCodeAlertRuleList[0].Id);
            masterAlertActionList.addAll(dayCodeQuestionAlertActionList2);
            insert masterAlertActionList;

            List<Case> caseList = CEC_TestDataFactory.createTestCases(1, 'New', 'Email', 'L1234', '1234',
                                                        caseProductList.get(0).Id, reasonCodeList.get(0).Id, 
                                                        null, cmmUK.Id, true);
            insert caseList;

            cec_Org_Settings__c custsett = new cec_Org_Settings__c();
            custsett.Safety_Alert_Email_Id__c = 'test123@gmailxyz567.com';
            insert custsett;
        }
    }
    
    // Test Method for createSafetyAlert
<<<<<<< HEAD
    static testMethod void createCaseSafetyAlerts1(){
        
        Test.startTest();
        User u = insertUser();
        
        System.runAs(u)
        {
            
            mdm_Product_Category__c pCategory = new mdm_Product_Category__c(name='ProductCategory', L0_Product_Category__c='Foods Category');
            insert pCategory;
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product1', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo1', brand__c= 'Dove1', Consumer_Product_Descriptor_no_size__c ='Dove',Global_CPG_Code__c = pCategory.id);
            insert productObj;          
            
            mdm_Global_Listening_Tree__c gListingTree = new mdm_Global_Listening_Tree__c(L1_Desc__c='Complaint', 
                                                                L2_Desc__c = 'Product', L3_Desc__c = 'Foreign matter',
                                                                L4_Desc__c = 'Unidentifiable Foreign Matter', 
                                                                L5_Desc__c = 'Foreign matter - unidentifiable');
            insert gListingTree;
            
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason1', L5_Code__c='T5261',Global_Listening_Tree__c = gListingTree.Id);
            insert reasonObj;
            
            CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
            cmm.Market__c = 'India';
            insert cmm;
            
            cec_Org_Settings__c custsett = new cec_Org_Settings__c();
            custsett.Safety_Alert_Email_Id__c = 'test@gmail.com';
            insert custsett;
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :custsett.Safety_Alert_Email_Id__c];
            
            Case caseObj= new Case();
            caseObj.Status='New';
            caseObj.Origin='Email'; 
            caseObj.CEC_Product__c = productObj.id;
            caseObj.Reason_Code__c = reasonObj.id;
            caseObj.Country__c = cmm.id;
            caseObj.Production_Code__c = 'L1234';
            caseObj.DayCode__c ='1234';
            insert caseObj;
=======
    static testMethod void testSafetyAlertsDayCodeDisabled(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            Test.startTest();

            Case caseObj = [SELECT Id, Reason_Code__c FROM Case LIMIT 1];
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
            caseObj.Reason_Code__c = null;
            update caseObj;
            
            Case caseToAssert = [SELECT DayCode__c, Case_Market__c FROM Case WHERE DayCode__c ='1234' LIMIT 1];
            System.assertEquals(CEC_Constants.UK, caseToAssert.Case_Market__c);

            mdm_Reason_Code__c reasonObj = [SELECT Id FROM mdm_Reason_Code__c LIMIT 1];            
            caseObj.Reason_Code__c = reasonObj.Id;
            caseObj.Production_Code__c = null;
            caseObj.DayCode__c = null;
            update caseObj;

            cec_Alert_Rule__c alertRule = [SELECT Id FROM cec_Alert_Rule__c WHERE Group_By_Day_Code__c = false LIMIT 1];
            
            Integer alertTrackerCount = [SELECT COUNT() FROM cec_Alert_Tracker__c WHERE Alert_Rule_Id__c = :alertRule.Id];
            System.assertEquals(1, alertTrackerCount);

            Test.stopTest();
        }        
    }
    
    // Test Method for createSafetyAlert
    static testMethod void testSafetyAlertsDayCodeEnabled(){
        
<<<<<<< HEAD
        System.runAs(u)
        {
            
            CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
            cmm.Market__c = 'India';
            insert cmm;
            
            mdm_Product_Category__c pCategory = new mdm_Product_Category__c(name='ProductCategory', L0_Product_Category__c='Foods Category');
            insert pCategory;
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product1', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo1', brand__c= 'Dove1', Consumer_Product_Descriptor_no_size__c ='Dove',Global_CPG_Code__c = pCategory.id);
            insert productObj;          
            
            mdm_Global_Listening_Tree__c gListingTree = new mdm_Global_Listening_Tree__c(L1_Desc__c='Complaint', L2_Desc__c = 'Product',
                                                                L3_Desc__c = 'Foreign matter',L4_Desc__c = 'Unidentifiable Foreign Matter', L5_Desc__c = 'Foreign matter - unidentifiable');
            insert gListingTree;
            
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason1', L5_Code__c='T5261',Global_Listening_Tree__c = gListingTree.Id);
            insert reasonObj;
            
            
            cec_Org_Settings__c custsett = new cec_Org_Settings__c();
            custsett.Safety_Alert_Email_Id__c = 'test@gmail.com';
            insert custsett;
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :custsett.Safety_Alert_Email_Id__c];
            
            Case caseObj= new Case();
            caseObj.Status='New';
            caseObj.Origin='Email'; 
            caseObj.CEC_Product__c = productObj.id;
            caseObj.Reason_Code__c = reasonObj.id;
            caseObj.Country__c = cmm.id;
            caseObj.Production_Code__c = 'L1234';
            caseObj.DayCode__c ='1234';
            insert caseObj;
            
=======
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            Test.startTest();

            Case caseObj = [SELECT Id, CEC_Product__c FROM Case LIMIT 1];              
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
            caseObj.CEC_Product__c = null;
            update caseObj;
            
            Case caseToAssert = [SELECT DayCode__c, Case_Market__c FROM Case WHERE DayCode__c ='1234'];           
            System.assertEquals(CEC_Constants.UK, caseToAssert.Case_Market__c);
            
            mdm_Case_Product__c productObj = [SELECT Id FROM mdm_Case_Product__c LIMIT 1];  
            caseObj.CEC_Product__c = productObj.id;
            update caseObj;

            cec_Alert_Rule__c alertRule = [SELECT Id FROM cec_Alert_Rule__c WHERE Group_By_Day_Code__c = true LIMIT 1];
            
            Integer alertTrackerCount = [SELECT Count() FROM cec_Alert_Tracker__c WHERE Alert_Rule_Id__c = :alertRule.Id];
            System.assertEquals(1, alertTrackerCount);

            Test.stopTest();
        }
        
    }

    // Test Method for Alert Action type 'Questionnaire'
    static testMethod void testQuestionnaireAlertAction(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
<<<<<<< HEAD
        System.runAs(u)
        {
            CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
            cmm.Market__c = 'India';
            insert cmm;
            
            mdm_Product_Category__c pCategory = new mdm_Product_Category__c(name='ProductCategory', L0_Product_Category__c='Foods Category');
            insert pCategory;
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product1', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo1', brand__c= 'Dove1', Consumer_Product_Descriptor_no_size__c ='Dove',Global_CPG_Code__c = pCategory.id);
            insert productObj;          
            
            mdm_Global_Listening_Tree__c gListingTree = new mdm_Global_Listening_Tree__c(L1_Desc__c='Complaint', L2_Desc__c = 'Product',
                                                                L3_Desc__c = 'Foreign matter',L4_Desc__c = 'Unidentifiable Foreign Matter', L5_Desc__c = 'Foreign matter - unidentifiable');
            insert gListingTree;
            
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason1', L5_Code__c='T5261',Global_Listening_Tree__c = gListingTree.Id);
            insert reasonObj;
            
            cec_Org_Settings__c custsett = new cec_Org_Settings__c();
            custsett.Safety_Alert_Email_Id__c = 'test@gmail.com';
            insert custsett;
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :custsett.Safety_Alert_Email_Id__c];
            
            Case caseObj= new Case();
            caseObj.Status='New';
            caseObj.Origin='Email'; 
            caseObj.CEC_Product__c = productObj.id;
            caseObj.Reason_Code__c = reasonObj.id;
            caseObj.Country__c = cmm.id;
            caseObj.Production_Code__c = 'L1234';
            caseObj.DayCode__c ='1234';
            insert caseObj;
=======
        System.runAs(u) {
            Test.startTest();
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
            
            Case caseObj = [SELECT Id, CEC_Product__c FROM Case LIMIT 1];              
            caseObj.CEC_Product__c = null;
            update caseObj;
            
            Case caseToAssert = [SELECT DayCode__c, Case_Market__c FROM Case WHERE DayCode__c ='1234'];           
            System.assertEquals(CEC_Constants.UK, caseToAssert.Case_Market__c);
            
            mdm_Case_Product__c productObj = [SELECT Id FROM mdm_Case_Product__c LIMIT 1];  
            caseObj.CEC_Product__c = productObj.id;
            update caseObj;
            
            cec_Alert_Rule__c alertRule = [SELECT Id FROM cec_Alert_Rule__c WHERE Group_By_Day_Code__c = true LIMIT 1];
            
            Integer alertTrackerCount = [SELECT Count() FROM cec_Alert_Tracker__c WHERE Alert_Rule_Id__c = :alertRule.Id];
            System.assertEquals(1, alertTrackerCount);
            
            // Check the Case Action result 1
            cec_Case_Action__c caseActionResult1 = [SELECT Q12__c, Q2__c, Q3__c, Q4__c, Q5__c,Q6__c,
                                                    Q7__c, Q8__c, Q9__c, Q10__c, Q11__c, Survey_Id__c
                                                    FROM cec_Case_Action__c 
                                                    WHERE Case_Id__c = :caseObj.Id AND 
                                                    Survey_Name__c = 'Test Survey Name'];
            System.assertEquals(caseActionResult1.Q12__c, 'CaseOwner');
            System.assertEquals(caseActionResult1.Q3__c, 'CaseOrigin');
            System.assertEquals(caseActionResult1.Q11__c, null);
            System.assertEquals(caseActionResult1.Survey_Id__c, 'abcdefgh');

            // Check the Case Action result 2
            cec_Case_Action__c caseActionResult2 = [SELECT Q12__c, Q2__c, Q3__c, Q4__c, Q5__c,Q6__c, 
                                                    Q7__c, Q8__c, Q9__c, Q10__c, Q11__c, Survey_Id__c 
                                                    FROM cec_Case_Action__c  
                                                    WHERE Case_Id__c = :caseObj.Id AND 
                                                    Survey_Name__c = 'Test Survey Name_2'];
            System.assertEquals(caseActionResult2.Q12__c, 'ProductCode');
            System.assertEquals(caseActionResult2.Q4__c, 'CaseOpenedDate');
            System.assertEquals(caseActionResult2.Q11__c,  null);
            System.assertEquals(caseActionResult2.Survey_Id__c, 'xyz123');

            Test.stopTest();
        }
        
    }
    
    // Test Method for Safety Alert to set Case Product instead of Product Category.
    static testMethod void createAlertsForCaseProduct(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {

            Test.startTest();  

            mdm_Case_Product__c productObj = [SELECT Id FROM mdm_Case_Product__c LIMIT 1]; 
            mdm_Reason_Code__c reasonObj = [SELECT Id FROM mdm_Reason_Code__c LIMIT 1];

            Case caseObj = [SELECT Id, Reason_Code__c FROM Case LIMIT 1];
            caseObj.Reason_Code__c = null;
            update caseObj;
            
            Case caseToAssert = [SELECT DayCode__c, Case_Market__c FROM Case WHERE DayCode__c ='1234'];           
            System.assertEquals(CEC_Constants.UK, caseToAssert.Case_Market__c);

            List<cec_Alert_Rule__c> noDayCodeAlertRuleList = 
                                                CEC_TestDataFactory.createAlertRule(1,'Safety','0','5',CEC_Constants.UK,
                                                                    reasonObj.Id,null, productObj.Id,
                                                                    false,false,false,1);
            insert noDayCodeAlertRuleList;
            
            List<cec_Alert_Action__c> noDayCodeAlertActionList = 
                                                CEC_TestDataFactory.createEmailAlertAction(1, 'AlertTemplate', 
                                                                    noDayCodeAlertRuleList[0].Id);
            insert noDayCodeAlertActionList;
            
            caseObj.Reason_Code__c = reasonObj.id;
            caseObj.Production_Code__c = null;
            caseObj.DayCode__c = null;
            update caseObj;
            
            Integer alertTrackerCount = [ SELECT Count() FROM cec_Alert_Tracker__c WHERE
                                Alert_Rule_Id__c = :noDayCodeAlertRuleList.get(0).Id];
            System.assertEquals(1, alertTrackerCount);
        }
        Test.stopTest();
<<<<<<< HEAD
    }*/

    // Test Method for createSafetyAlert
    static testMethod void createAlertsForCaseProduct(){
        
        Test.startTest();
        User u = insertUser();
        
        System.runAs(u)
        {
            
            mdm_Product_Category__c pCategory = new mdm_Product_Category__c(name='ProductCategory', L0_Product_Category__c='Foods Category');
            insert pCategory;
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product1', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo1', brand__c= 'Dove1', Consumer_Product_Descriptor_no_size__c ='Dove',Global_CPG_Code__c = pCategory.id);
            insert productObj;          
            
            mdm_Global_Listening_Tree__c gListingTree = new mdm_Global_Listening_Tree__c(L1_Desc__c='Complaint', L2_Desc__c = 'Product',
                                                                L3_Desc__c = 'Foreign matter',L4_Desc__c = 'Unidentifiable Foreign Matter', L5_Desc__c = 'Foreign matter - unidentifiable');
            insert gListingTree;
            
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason1', L5_Code__c='T5261',Global_Listening_Tree__c = gListingTree.Id);
            insert reasonObj;
            
            CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
            cmm.Market__c = 'India';
            insert cmm;
            
            cec_Org_Settings__c custsett = new cec_Org_Settings__c();
            custsett.Safety_Alert_Email_Id__c = 'test@gmail.com';
            insert custsett;
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :custsett.Safety_Alert_Email_Id__c];
            
            Case caseObj= new Case();
            caseObj.Status='New';
            caseObj.Origin='Email'; 
            caseObj.CEC_Product__c = productObj.id;
            caseObj.Reason_Code__c = reasonObj.id;
            caseObj.Country__c = cmm.id;
            caseObj.Production_Code__c = 'L1234';
            caseObj.DayCode__c ='1234';
            insert caseObj;
            caseObj.Reason_Code__c = null;
            update caseObj;
            
            case caseTest = [Select DayCode__c, Case_Market__c from case Where DayCode__c ='1234'];
            
            System.assertEquals(cmm.Market__c, caseTest.Case_Market__c);
            
            cec_Alert_Rule__c alertRule = new cec_Alert_Rule__c(Name = 'Rule 1', Active__c=true, Type__c='Safety', Reason_Code__c = reasonObj.id, Market__c='India',  All_Market__c = true, Threshold__c = 1, Case_Product__c = productObj.id, Reason_Level__c = '5', Group_By_Day_Code__c = false);
            insert alertRule;
            
            cec_Alert_Action__c alertAction = new cec_Alert_Action__c( Type__c = 'Email', Alert_Rule_Id__c = alertRule.id, Email_Template_Name__c='AlertTemplate' , To__c='John.Smith@test.com');
            insert alertAction;
            
            caseObj.Reason_Code__c = reasonObj.id;
            caseObj.Production_Code__c = null;
            caseObj.DayCode__c = null;
            update caseObj;
            
            Integer atCount = [SELECT COUNT() FROM cec_Alert_Tracker__c WHERE Alert_Rule_Id__c = :alertRule.Id];
            System.assertEquals(1,atCount);
        }
        Test.stopTest();
    }
}
=======
    }
}
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
