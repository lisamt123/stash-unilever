/**********************************************************************
Name:  CEC_ChatSurveyBatchScheduler_Test
Copyright � 2016  Unilever
======================================================================
=======================================================================
Purpose: This is the test class for the Batch/Scheduler class for CEC_ChatSurveyBatchScheduler
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0      Sathish           Feb-2016      INITIAL DEVELOPMENT   

***********************************************************************/
@isTest(SeeAllData=false)
private class CEC_ChatSurveyBatchScheduler_Test {
	
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

	// Test method for the Schedulable interface implementation
	@isTest static void test_ChatSurveySchedulerMethod() {
        // Implement test code
        Test.startTest(); 
        User u = insertUser();
        
        System.runAs(u)
        {
            String CRON_EXP = '0 0 * * * ?';
            String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new CEC_ChatSurveyBatchScheduler());
            
            CronTrigger ct = [SELECT Id, CronExpression FROM CronTrigger WHERE id = :jobId];
            // Verify the expressions are the same
            System.assertEquals(CRON_EXP, ct.CronExpression);
            Test.stopTest();
        }
	}
	
	// Test method for the Batchable interface implementation
	@isTest static void test_ChatSurveyBatchMethod() {
		
        // Implement test code
        Test.startTest(); 
        User u = insertUser();
        
        System.runAs(u)
        {
        	List<Case> caseList = new List<Case>();
            Case newcase1 = new Case(SuppliedEmail='test@abc.com',SuppliedName='Test Abc', Status='In Progress', Origin='Chat');
            Case newcase2 = new Case(SuppliedEmail='test123@abc.com',SuppliedName='Test Abc123', Status='In Progress', Origin='Phone');
            caseList.add(newcase1);
            caseList.add(newcase2);
            insert caseList;
            
            // Additional Info which should be picked up by the batch job.
            List<cec_Additional_Case_Information__c> batchableSurveyInfoList = new List<cec_Additional_Case_Information__c>();            
            for(Integer i=0; i<100; i++) {
            	String name = 'Batchable' + i;
            	String chatKey = 'xyz-123-abc-567-efg-890' + i;
            	cec_Additional_Case_Information__c surveyInfo = 
            				new cec_Additional_Case_Information__c(ChatKey__c=chatKey, Name = name);
            	batchableSurveyInfoList.add(surveyInfo);
            }
            insert batchableSurveyInfoList;

            // Additional Info which should NOT be picked up by the batch job.
            List<cec_Additional_Case_Information__c> nonBatchableSurveyInfoList = new List<cec_Additional_Case_Information__c>();
            for(Integer i=0; i<100; i++) {
            	String name = 'NonBatchable' + i;
            	cec_Additional_Case_Information__c surveyInfo = 
            					new cec_Additional_Case_Information__c(Name=name, Case__c=newcase2.Id);
            	nonBatchableSurveyInfoList.add(surveyInfo);
            }
            insert nonBatchableSurveyInfoList;

            LiveChatVisitor visitor = new LiveChatVisitor();
            insert visitor;

            List<LiveChatTranscript> transcriptList = new List<LiveChatTranscript>();
            for(Integer i=0; i<100; i++) {
            	String chatKey = 'xyz-123-abc-567-efg-890' + i;
            	LiveChatTranscript liveChatScript = new LiveChatTranscript(	CaseId=newcase1.Id,
            																ChatKey=chatKey,
        																	LiveChatVisitorId=visitor.Id);
            	transcriptList.add(liveChatScript);
            }
            insert transcriptList;
            
            // Get the survey Information which has case Id associated before the batch execution.
            List<cec_Additional_Case_Information__c> totalSurveyListBeforeBatch = 
            											[SELECT id, Case__c, ChatKey__c 
            											FROM cec_Additional_Case_Information__c 
            											WHERE Case__c != null
            											LIMIT 300];

			System.assertEquals(totalSurveyListBeforeBatch.size(),100); 

            CEC_ChatSurveyBatchScheduler scheduler = new CEC_ChatSurveyBatchScheduler();
            database.executeBatch(scheduler);
            Test.stopTest();

            // Get the survey Information which has case Id associated after the batch execution.
            List<cec_Additional_Case_Information__c> totalSurveyListAfterBatch = 
            											[SELECT id, Case__c, ChatKey__c 
            											FROM cec_Additional_Case_Information__c 
            											WHERE Case__c != null
            											LIMIT 300];
			System.assertEquals(totalSurveyListAfterBatch.size(),200); 

        }
	}
	
}