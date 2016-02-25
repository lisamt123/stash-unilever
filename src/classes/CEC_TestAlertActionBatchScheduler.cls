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
                          Email = 'testuser@test.com', 
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

            //Create group for Chatter Post action.
            List<CollaborationGroup> chatterGroupList = new List<CollaborationGroup>();
            CollaborationGroup publicGroup = new CollaborationGroup(name='Public Chatter Group', CollaborationType='Public');
            CollaborationGroup privateGroup = new CollaborationGroup(name='Private Chatter Group', CollaborationType='Public');

            chatterGroupList.add(publicGroup);
            chatterGroupList.add(privateGroup);
            insert chatterGroupList;            

            List<cec_Alert_Action__c> alertActionList = new List<cec_Alert_Action__c>();
            cec_Alert_Action__c emailAlertAction = new cec_Alert_Action__c(Type__c = 'Email', Alert_Rule_Id__c = alertRule.id,  Email_Template_Name__c='CEC_SubjectMerged', To__c='sathish.venkatachalam@capgemini.com');

            List<cec_Alert_Action__c> chatterActionList = new List<cec_Alert_Action__c>();
            cec_Alert_Action__c chatterAlertAction = new cec_Alert_Action__c(Type__c = 'Chatter Post', Alert_Rule_Id__c = alertRule.id,  Chatter_Template_Name__c='CEC_SubjectMerged', Country_Chatter_Group__c='Public Chatter Group', Category_Chatter_Group__c='Private Chatter Group');

            alertActionList.add(emailAlertAction);
            alertActionList.add(chatterAlertAction);
            insert alertActionList;
            
            cec_Alert_Tracker__c alertTracker = new cec_Alert_Tracker__c(Trigger_Batch__c = true, Product_No_Size__c = 'ABCD Knorr 100% soup XYZ', Alert_Rule_Id__c = alertRule.id, DayCode__c = '2121');
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
            
            cec_Alert_Tracker__c finalAlertTracker = [SELECT Trigger_Batch__c FROM cec_Alert_Tracker__c WHERE Product_No_Size__c = 'ABCD Knorr 100% soup XYZ' AND DayCode__c = '2121'];
            System.assertEquals(finalAlertTracker.Trigger_Batch__c,false);

            // Assert Chatter Alert Action : Check the Group id is populated in Alert Action record
            cec_Alert_Action__c resultChatterAlertAction = [SELECT Country_Chatter_Group_Id__c, Category_Chatter_Group_Id__c
                                                        FROM cec_Alert_Action__c 
                                                        WHERE Alert_Rule_Id__c = : alertRule.id
                                                        AND Type__c = 'Chatter Post'
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