/**********************************************************************
Name:  CEC_TestAlertActionBatchScheduler
Copyright � 2015  Unilever
======================================================================
=======================================================================
Purpose: This is the test class for the Batch/Scheduler class for CEC_AlertActionBatchScheduler
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0      Sathish           Aug-2015      INITIAL DEVELOPMENT   
1.1      Sathish           Mar-2016      Code Refacotring.
***********************************************************************/
@isTest(SeeAllData=false)
private class CEC_TestAlertActionBatchScheduler {

    @testSetup static void setUpTestData() {

        User u = CEC_TestDataFactory.createStandardCECTestUser();
        System.runAs(u) {
            
            //Create group for Chatter Post action.
            List<CollaborationGroup> chatterGroupList = new List<CollaborationGroup>();
            CollaborationGroup publicGroup = new CollaborationGroup(Name = 'Public XYZ123 Test Group', 
                                                        CollaborationType = 'Public');
            CollaborationGroup privateGroup = new CollaborationGroup(name='Private XYZ123 Test Group', 
                                                        CollaborationType = 'Private');
            chatterGroupList.add(publicGroup);
            chatterGroupList.add(privateGroup);
            insert chatterGroupList;

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
                                                CEC_TestDataFactory.createAlertRule(1,'Safety','0','5',null,
                                                                    reasonCodeList.get(0).Id,prodCategoryList.get(0).Id,
                                                                    null,true,false,false,1);
            insert alertRuleList;
            
            List<cec_Alert_Action__c> emailAlertActionList = 
                                                CEC_TestDataFactory.createEmailAlertAction(1, 'CEC_SubjectMerged', 
                                                                    alertRuleList[0].Id);
            insert emailAlertActionList;

            List<cec_Alert_Action__c> chatterAlertActionList = CEC_TestDataFactory.createChatterAlertAction(
                                                                    1, 'CEC_SubjectMerged', 'Public XYZ123 Test Group',
                                                                    'Private XYZ123 Test Group', alertRuleList[0].Id);
            insert chatterAlertActionList;

            List<Case> caseList = CEC_TestDataFactory.createTestCases(1, 'New', 'Phone', null, null,
                                                caseProductList.get(0).Id, null, null, null, true);
            insert caseList;
        }
    }
    
    // Test method for the batch interface implementation
    @isTest static void test_AlertActionBatchMethod() {
        // Implement test code
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest(); 
            
            Case caseObj = [SELECT Id, Reason_Code__c FROM Case LIMIT 1];
            caseObj.Reason_Code__c = null;
            update caseObj;

            mdm_Reason_Code__c reasonObj = [SELECT Id FROM mdm_Reason_Code__c LIMIT 1];            
            caseObj.Reason_Code__c = reasonObj.Id;
            update caseObj;

            cec_Org_Settings__c custsett = new cec_Org_Settings__c(Safety_Alert_Email_Id__c = 'test@gmail.com');
            insert custsett;

            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :custsett.Safety_Alert_Email_Id__c];
            
            CEC_AlertActionBatchScheduler scheduler = new CEC_AlertActionBatchScheduler();
            database.executeBatch(scheduler);
            Test.stopTest();
            
            cec_Alert_Tracker__c finalAlertTracker = [SELECT Trigger_Batch__c FROM cec_Alert_Tracker__c];
            System.assertEquals(finalAlertTracker.Trigger_Batch__c,false);

            // Assert Chatter Alert Action : Check the Group id is populated in Alert Action record
            cec_Alert_Action__c resultChatterAlertAction = [SELECT Country_Chatter_Group_Id__c, Category_Chatter_Group_Id__c
                                                        FROM cec_Alert_Action__c 
                                                        WHERE Type__c = 'Chatter Post'
                                                        LIMIT 1];
            String countryGroupId = resultChatterAlertAction.Country_Chatter_Group_Id__c;
            String categoryGroupId = resultChatterAlertAction.Category_Chatter_Group_Id__c;

            System.assertEquals(String.isNotEmpty(countryGroupId), true);
            System.assertEquals(String.isNotEmpty(categoryGroupId), true);

            // Check two feeds are created for the chatter groups.
            List<FeedItem> feedItemList = [SELECT ParentId, Id FROM FeedItem 
                                    WHERE ParentId IN (:countryGroupId, :categoryGroupId)];
            System.assertEquals(feedItemList.size(), 2);
        }
    }
    
    // Test method for the Schedulable interface implementation
    @isTest static void test_AlertActionSchedulerMethod() {
        // Implement test code
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest(); 
            String CRON_EXP = '0 20 * * * ?';
            String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new CEC_AlertActionBatchScheduler());
            
            CronTrigger ct = [SELECT Id, CronExpression FROM CronTrigger WHERE id = :jobId];
            // Verify the expressions are the same
            System.assertEquals(CRON_EXP, ct.CronExpression);
            Test.stopTest();
        }
    }
    // Test method for startScheduler() and stopAllScheduler() method in the CEC_AlertActionBatchScheduler class 
    @isTest static void test_StartStopSchedulerMethod() {
         
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
            Test.startTest();
            cec_Org_Settings__c custsett = new cec_Org_Settings__c(AlertAction_Time_Scheduler__c = '12;');
            insert custsett;
            CEC_AlertActionBatchScheduler.startScheduler();
            
            String cecNameFilter = Label.CEC_AlertActionSchedulerName + '%';
             List<CronTrigger> cecAsyncJobList = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger WHERE CronJobDetail.Name LIKE :cecNameFilter AND CronJobDetail.JobType = '7' AND (STATE = 'WAITING' OR STATE = 'RUNNING')];
             System.assert(cecAsyncJobList[0].CronJobDetail.Name.contains('CEC AlertAction Scheduler'));
             
            // Assert whether the scheduler job is created
            CEC_AlertActionBatchScheduler.stopAllScheduler();
            Test.stopTest();
            
        }
    }
}