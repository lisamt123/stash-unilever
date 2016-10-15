/**********************************************************************
Name:  CEC_ClearAlertData_BatchScheduler_Test
Copyright � 2015  Unilever
======================================================================
=======================================================================
Purpose: This is the test class for the Batch/Scheduler class for CEC_ClearAlertData_BatchScheduler
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0        Masood & Sathish  Feb-2016      INITIAL DEVELOPMENT   

***********************************************************************/
@isTest(SeeAllData=false)
public class CEC_ClearAlertData_BatchScheduler_Test {

    @testSetup static void setUpTestData() {

        User u = CEC_TestDataFactory.createStandardCECTestUser();
        System.runAs(u) {
            cec_Org_Settings__c custsett = new cec_Org_Settings__c(Alert_Retention_Days__c = 180);
            insert custsett;

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

            List<cec_Alert_Rule__c> alertRuleList = 
                                                CEC_TestDataFactory.createAlertRule(1,'Quality','2','5',null,
                                                                    reasonCodeList.get(0).Id,prodCategoryList.get(0).Id,
                                                                    null,true,false,false,1);
            insert alertRuleList;
            
            List<cec_Alert_Action__c> alertActionList = 
                                                CEC_TestDataFactory.createEmailAlertAction(1, 'AlertTemplate', 
                                                                    alertRuleList[0].Id);
            insert alertActionList;

            List<Case> caseList = CEC_TestDataFactory.createTestCases(50, 'New', 'Phone', null, null,
                                                caseProductList.get(0).Id, null, null, null, true);
            insert caseList;
        }
    } 
   
    /* Test method for the batch interface implementation. 
            SCENARIO DETAILS.
                Step 1 : Update 50 cases in bulk to create alert data.\
                Step 2 : Step 1 results in new AlertTracker And AlertTrackerItems.
                Step 3 : Update all the alert trackerItems's created date to 6 months back.
                Step 4 : Execute the batch. This will remove all the alert tracker items and alert tracker.
    */
    @isTest static void test_clearAllAlertDataBatchMethod() {
        // Implement test code
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
           
            mdm_Reason_Code__c reasonObj = [SELECT Id FROM mdm_Reason_Code__c LIMIT 1];
            List<Case> caseList = [SELECT Id,Reason_Code__c,CreatedDate FROM Case limit 100];
            System.assertEquals(caseList.size(), 50);
            // Update Case to create alert data.
            for(Case caseObj : caseList){
                caseObj.Reason_Code__c = reasonObj.id;
            }
            update caseList;
            
            List<cec_Alert_Tracker__c> alertTrackerObjList= [SELECT Id,Alert_Tracker_Item_count__c 
                                                            FROM cec_Alert_Tracker__c limit 100];
            System.assertEquals(alertTrackerObjList.size(), 1);
            System.assertEquals(alertTrackerObjList[0].Alert_Tracker_Item_count__c, 50);
            Set<Id> alertTrackerSetIds = (new Map<Id,cec_Alert_Tracker__c>(alertTrackerObjList)).keySet();
            List<cec_Alert_Tracker_Item__c> alertTrackerItemList = [SELECT Id,CreatedDate 
                                                                    FROM cec_Alert_Tracker_Item__c 
                                                                    WHERE 
                                                                    Alert_Tracker_Id__c IN : alertTrackerSetIds];
            System.assertEquals(alertTrackerItemList.size(), 50);            
            for(cec_Alert_Tracker_Item__c alertTrackerItemObj : alertTrackerItemList){
                Test.setCreatedDate(alertTrackerItemObj.Id, System.today()-181);
            }
            update alertTrackerItemList;

            Test.startTest(); 
            CEC_ClearAlertTrackerItem_BatchScheduler scheduler = new CEC_ClearAlertTrackerItem_BatchScheduler();
            database.executeBatch(scheduler);
            Test.stopTest();
            // Retrieve the data to assert the Alerts.
            alertTrackerObjList= [SELECT Id,Alert_Tracker_Item_count__c FROM cec_Alert_Tracker__c limit 100];
            alertTrackerItemList = [SELECT Id,CreatedDate FROM cec_Alert_Tracker_Item__c 
                                    WHERE Alert_Tracker_Id__c IN : alertTrackerSetIds];
            System.assertEquals(alertTrackerItemList.size(), 0);
            System.assertEquals(alertTrackerObjList.size(), 0);            
        }
    }

    /* Test method for the batch interface implementation. 
            SCENARIO DETAILS.
                Step 1 : Update 50 cases in bulk to create alert data.\
                Step 2 : Step 1 results in new AlertTracker And AlertTrackerItems.
                Step 3 : Update 20 of the alert trackerItems's created date to 6 months back.
                Step 4 : Execute the batch. This will remove 20 alert tracker items. The alert tracker will not be deleted.
    */
    @isTest static void test_clearPartialAlertDataBatchMethod() {
        // Implement test code
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
           
            mdm_Reason_Code__c reasonObj = [SELECT Id FROM mdm_Reason_Code__c LIMIT 1];
            List<Case> caseList = [SELECT Id,Reason_Code__c,CreatedDate FROM Case limit 100];
            System.assertEquals(caseList.size(), 50);
            // Update Case to create alert data.
            for(Case caseObj : caseList){
                caseObj.Reason_Code__c = reasonObj.id;
            }
            update caseList;
            
            List<cec_Alert_Tracker__c> alertTrackerObjList= [SELECT Id,Alert_Tracker_Item_count__c 
                                                            FROM cec_Alert_Tracker__c limit 100];
            System.assertEquals(alertTrackerObjList.size(), 1);
            System.assertEquals(alertTrackerObjList[0].Alert_Tracker_Item_count__c, 50);
            Set<Id> alertTrackerSetIds = (new Map<Id,cec_Alert_Tracker__c>(alertTrackerObjList)).keySet();
            List<cec_Alert_Tracker_Item__c> alertTrackerItemList = [SELECT Id,CreatedDate 
                                                                    FROM cec_Alert_Tracker_Item__c 
                                                                    WHERE 
                                                                    Alert_Tracker_Id__c IN : alertTrackerSetIds];
            System.assertEquals(alertTrackerItemList.size(), 50);
            // update the created date only for 20 records.
            for (Integer i=0; i< 20; i++) {
                Test.setCreatedDate(alertTrackerItemList[i].Id, System.today()-181);
            }
            update alertTrackerItemList;

            Test.startTest(); 
            CEC_ClearAlertTrackerItem_BatchScheduler scheduler = new CEC_ClearAlertTrackerItem_BatchScheduler();
            database.executeBatch(scheduler);
            Test.stopTest();
            // Retrieve the data to assert the Alerts.
            alertTrackerObjList= [SELECT Id,Alert_Tracker_Item_count__c FROM cec_Alert_Tracker__c limit 100];
            alertTrackerItemList = [SELECT Id,CreatedDate FROM cec_Alert_Tracker_Item__c 
                                    WHERE Alert_Tracker_Id__c IN : alertTrackerSetIds];
            System.assertEquals(alertTrackerItemList.size(), 30);
            System.assertEquals(alertTrackerObjList.size(), 1);            
        }
    }
    
    // Test method for the Schedulable interface implementation
    @isTest static void test_clearAlertDataSchedulerMethod() {
        // Implement test code 
        User u = CEC_TestDataFactory.getStandardCECTestUser();        
        System.runAs(u) {
            Test.startTest();
            String CRON_EXP = '0 20 * * * ?';
            String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new CEC_ClearAlertTrackerItem_BatchScheduler());
            CronTrigger ct = [SELECT Id, CronExpression FROM CronTrigger WHERE id = :jobId];
            // Verify the expressions are the same
            System.assertEquals(CRON_EXP, ct.CronExpression);
            Test.stopTest();
        }
    }
    
}