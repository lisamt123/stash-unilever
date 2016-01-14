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

 ***********************************************************************/
@isTest(SeeAllData=false)
private class CEC_TestAlertActionBatchScheduler {

public static User insertUser()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Unilever - Salesforce MultiApp Standard'];
       //Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        //UserRole r = [SELECT Id,name FROM UserRole WHERE Name = 'CEC Global Head'];
        //System.debug('Role' + r.name);
        User u = new User(LastName = 'Testing', 
                             Username = 'cectestuser@test00DE0000000bbLj.org', 
                             Email = 'cectestuser@test00DE0000000bbLj.org', 
                             Alias = 'utest', 
                             TimeZoneSidKey = 'Europe/London', 
                             LocaleSidKey = 'en_GB', 
                             EmailEncodingKey = 'UTF-8', 
                             ProfileId = p.Id, 
                             LanguageLocaleKey = 'en_US',
                             UserPermissionsKnowledgeUser = true);  
                             
        insert u;
        List<PermissionSet> pslist = [SELECT Id FROM PermissionSet WHERE Name IN ('CEC_User','CEC_Manager','CEC_CRUD','CEC_Business_Admin','CEC_Knowledge_Manager','CEC_Automated_User')];
        List<PermissionSetAssignment> psalist = new List<PermissionSetAssignment>();
        for(PermissionSet ps:pslist)
        {
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = u.Id;
            psa.PermissionSetId = ps.Id;
            
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

   
    // Test method for the batch interface implementation
    @isTest static void test_AlertActionBatchMethod() {
        // Implement test code
        Test.startTest(); 
        User u = insertUser();
        
         System.runAs(u)
         {
        mdm_Product_Category__c pCategory = new mdm_Product_Category__c(name='ProductCategory', L0_Product_Category__c='Foods Category');
        insert pCategory;
        
        mdm_Global_Listening_Tree__c gListingTree = new mdm_Global_Listening_Tree__c(L5_Desc__c = 'L4 Desc');
        insert gListingTree;

        mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason1', L5_Code__c='T5261',Global_Listening_Tree__c = gListingTree.Id);
        insert reasonObj;
        
        cec_Alert_Rule__c alertRule = new cec_Alert_Rule__c(Name = 'Rule 1', Active__c=true, Type__c='Safety', Reason_Code__c = reasonObj.id, All_Market__c = true, Threshold__c = 1, Product_Category__c = pCategory.Id, Product_Level__c = '0', Reason_Level__c = '5', Group_By_Day_Code__c = false);
        insert alertRule;

        cec_Alert_Action__c alertAction = new cec_Alert_Action__c(Type__c = 'Email', Alert_Rule_Id__c = alertRule.id,  Email_Template_Name__c='CEC_SubjectMerged', To__c='sathish.venkatachalam@capgemini.com');
        insert alertAction;

        cec_Alert_Tracker__c alertTracker = new cec_Alert_Tracker__c(Trigger_Email__c = true, Product_No_Size__c = 'ABCD Knorr 100% soup XYZ', Alert_Rule_Id__c = alertRule.id, DayCode__c = '2121');
        insert alertTracker;
        
        Case newcase = new Case(SuppliedEmail='test@abc.com',SuppliedName='Test Abc', Status='New', Origin='Phone');
        insert newcase;

        cec_Alert_Tracker_Item__c alertTrackerItem = new cec_Alert_Tracker_Item__c(Alert_Tracker_Id__c  = alertTracker.Id, Case_Id__c = newcase.Id);
        insert alertTrackerItem;

        cec_Org_Settings__c custsett = new cec_Org_Settings__c(Safety_Alert_Email_Id__c = 'test@gmail.com');
        insert custsett;
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :custsett.Safety_Alert_Email_Id__c];

        CEC_AlertActionBatchScheduler scheduler = new CEC_AlertActionBatchScheduler();
        database.executeBatch(scheduler);
        Test.stopTest();
        
        cec_Alert_Tracker__c finalAlertTracker = [SELECT Trigger_Email__c FROM cec_Alert_Tracker__c WHERE Product_No_Size__c = 'ABCD Knorr 100% soup XYZ' AND DayCode__c = '2121'];

        System.assertEquals(finalAlertTracker.Trigger_Email__c,true);
    }
    }

    // Test method for the Schedulable interface implementation
    @isTest static void test_AlertActionSchedulerMethod() {
        // Implement test code
        Test.startTest(); 
        User u = insertUser();
        
         System.runAs(u)
         {
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

        Test.startTest(); 
        User u = insertUser();
        System.runAs(u)
         {
        cec_Org_Settings__c custsett = new cec_Org_Settings__c(AlertAction_Time_Scheduler__c = '12;');
        insert custsett;
        CEC_AlertActionBatchScheduler.startScheduler();
        // Assert whether the scheduler job is created
        CEC_AlertActionBatchScheduler.stopAllScheduler();
        Test.stopTest();

    }
}
}