/**********************************************************************
Name:  CEC_CaseActionControllerTest()
Copyright@: 2015  Unilever
=======================================================================
=======================================================================
Purpose: This is the Test class for CEC_CaseActionController Apex class                                                                                                    

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0       Koti             Dec-2015      INITIAL DEVELOPMENT
1.1       Sathish           MAR-2016        Code Refactoring.   
***********************************************************************/

@isTest(SeeAllData=false)
public class CEC_CaseActionControllerTest{
    
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

            List<CEC_Case_Market_Mapping__c> cmmList = CEC_TestDataFactory.createMasterCaseMarketMapping();
            CEC_Case_Market_Mapping__c cmmUK = new CEC_Case_Market_Mapping__c();
            for(CEC_Case_Market_Mapping__c cmm : cmmList) {
                if (cmm.Market__c == 'United Kingdom') {
                    cmmUK = cmm;
                    break;
                }
            }

            List<cec_Alert_Rule__c> dayCodeAlertRuleList = 
                                                CEC_TestDataFactory.createAlertRule(1,'Safety','0','5','United Kingdom',
                                                                    reasonCodeList.get(0).Id,prodCategoryList.get(0).Id,
                                                                    null,false,true,false,1);
            insert dayCodeAlertRuleList;
            
            List<cec_Alert_Action__c> dayCodeQuestionAlertActionList = 
                                                CEC_TestDataFactory.createQuestionnaireAlertAction(1, 
                                                'abcdefgh','Test Survey Name', 'CaseOrigin', 'CaseOwner',
                                                'ProductCode','ProductionCode','ReasonCodeDesc',
                                                'ShortCode','Verbatim','UsedProdPreviously','CaseOpenedDate',
                                                null,'CaseOwner', dayCodeAlertRuleList[0].Id);
            insert dayCodeQuestionAlertActionList;

            List<Case> caseList = CEC_TestDataFactory.createTestCases(1, 'New', 'Email', 'L1234', '1234',
                                                        caseProductList.get(0).Id, reasonCodeList.get(0).Id, 
                                                        null, cmmUK.Id, true);
            insert caseList;

            cec_Org_Settings__c custsett = new cec_Org_Settings__c();
            custsett.Safety_Alert_Email_Id__c = 'test123@gmailxyz567.com';
            insert custsett;
        }
    }

    // Test Method for Alert Action type 'Questionnaire' in the case Action Controller
    static testMethod void testSurveyAlertAction(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest();
            PageReference pageRef = Page.CEC_CaseActions;
            
            Case caseObj = [SELECT Id, CEC_Product__c FROM Case LIMIT 1];              
            caseObj.CEC_Product__c = null;
            update caseObj;
            
            Case caseToAssert = [SELECT DayCode__c, Case_Market__c FROM Case WHERE DayCode__c ='1234'];           
            System.assertEquals('United Kingdom', caseToAssert.Case_Market__c);
            
            mdm_Case_Product__c productObj = [SELECT Id FROM mdm_Case_Product__c LIMIT 1];  
            caseObj.CEC_Product__c = productObj.id;
            update caseObj;

            String currentCaseId = caseObj.Id;
            
            cec_Alert_Rule__c alertRule = [SELECT Id FROM cec_Alert_Rule__c WHERE Group_By_Day_Code__c = true LIMIT 1];
            
            Integer alertTrackerCount = [SELECT Count() FROM cec_Alert_Tracker__c WHERE Alert_Rule_Id__c = :alertRule.Id];
            System.assertEquals(1, alertTrackerCount);
            
            // Check the Case Action result 1
            List<cec_Case_Action__c> surveyCaseActionList = [Select Id, Q12_Data__c, Q2_Data__c, Q3_Data__c, Q4_Data__c, 
                                                        Q5_Data__c, Q6_Data__c, Q7_Data__c, Q8_Data__c, Q9_Data__c,
                                                        Q10_Data__c, Q11_Data__c, Survey_Id__c, Survey_Name__c From cec_Case_Action__c WHERE Case_Id__c = :currentCaseId];

            System.assertEquals(surveyCaseActionList[0].Q8_Data__c, '&q8=This is case subject 1');
            System.assertEquals(surveyCaseActionList[0].Q2_Data__c, '&q2=Email');   
            System.assertEquals(surveyCaseActionList[0].Survey_Id__c, 'abcdefgh');
            
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id', CurrentCaseId);
            //Create a new instance of the class
            CEC_CaseActionController controller = new CEC_CaseActionController();
            System.assertEquals(controller.CaseActionList[0].Q8_Data__c, '&q8=This is case subject 1');
            System.assertEquals(controller.CaseActionList[0].Q2_Data__c, '&q2=Email'); 
            System.assertEquals(controller.CaseActionList[0].Q5_Data__c, '&q5=L1234');
            System.assertEquals(controller.CaseActionList[0].Survey_Id__c, 'abcdefgh');
            System.assertEquals(controller.CaseActionList[0].Survey_Name__c, 'Test Survey Name');

            Test.stopTest();
        }
        
    }
    
}