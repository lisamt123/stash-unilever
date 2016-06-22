/******************************************** 
*@Author:Cognizant
*@Date:01/18/2016
*@Description : Test class for IPM_ProjectOwnerUpdatescheduler functionalities
*@Name : IPM_ProjectOwnerUpdatescheduler_Test 
*********************************************/

@isTest
private class IPM_ProjectOwnerUpdatescheduler_Test {
    private static IPM_Project__c project;
    private static set<id> projectidSet;
    private static set<id> projecttobeprocessSet;
    private static final string JOBCREATED='job created';
	/*initialise test data like create a project*/
    static void initializedData()
    {  
        system.runAs(IPM_TestFactory_Helper.createUserAdmin(false)){
	        projectidSet =  new set<id>();
	        projecttobeprocessSet  =  new set<id>();
	        //Insert Project
	        project = IPM_TestFactory_Helper.createIPMProject(false);
	        insert project;
	        List<IPM_Project__c>projectList=[SELECT ID FROM IPM_Project__c WHERE ID=:project.id LIMIT 1];
	        system.assertEquals(projectList.size(),1,'project got created');
	        projectidSet.add(project.id);
	        projecttobeprocessSet.add(project.id);
        }
        
    }
    /*@description:after creating a project need to schedule a jod to update project ownerid*/
    static testMethod void testBatch() {
        initializedData();
        Test.startTest(); 
        system.runAs(IPM_TestFactory_Helper.createUserAdmin(false)){
	        IPM_ProjectOwnerUpdatescheduler ownerUpdateScheduler = new IPM_ProjectOwnerUpdatescheduler(projectidSet,projecttobeprocessSet);   
	        Datetime dt = Datetime.now().addMinutes(1);
	        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
	        String jobId = System.schedule('Test', CRON_EXP, ownerUpdateScheduler); 
	        //cover else path by making more than 5 jobs
	        String jobId1 = System.schedule('Test1', CRON_EXP, ownerUpdateScheduler); 
	        String jobId2 = System.schedule('Test2', CRON_EXP, ownerUpdateScheduler); 
	        String jobId3 = System.schedule('Test3', CRON_EXP, ownerUpdateScheduler); 
	        String jobId4 = System.schedule('Test4', CRON_EXP, ownerUpdateScheduler); 
	        String jobId5 = System.schedule('Test5', CRON_EXP, ownerUpdateScheduler); 
	        String jobId6 = System.schedule('Test6', CRON_EXP, ownerUpdateScheduler);
	        
			system.Assert(string.IsNotBlank(jobId), JOBCREATED);  
			system.Assert(string.IsNotBlank(jobId1), JOBCREATED); 
			system.Assert(string.IsNotBlank(jobId2), JOBCREATED); 
			system.Assert(string.IsNotBlank(jobId3), JOBCREATED); 
			system.Assert(string.IsNotBlank(jobId4), JOBCREATED); 
			system.Assert(string.IsNotBlank(jobId5), JOBCREATED); 
			system.Assert(string.IsNotBlank(jobId6), JOBCREATED);         
	        Test.stopTest();
	        
        }
        
    }

}