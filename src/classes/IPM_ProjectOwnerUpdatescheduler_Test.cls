/******************************************** 
*@Author:Cognizant
*@Date:01/18/2016
*@Description : Test class for IPM_ProjectOwnerUpdatescheduler functionalities
*@Name : IPM_ProjectOwnerUpdatescheduler_Test 
*********************************************/

@isTest
private class IPM_ProjectOwnerUpdatescheduler_Test {
    public static IPM_Project__c project;
    public static set<id> projectidSet;
    public static set<id> projecttobeprocessSet;

    static void initializedData()
    {  
        projectidSet =  new set<id>();
        projecttobeprocessSet  =  new set<id>();
        //Insert Project
        project = IPM_TestFactory_Helper.createIPMProject(false);
        insert project;
        
        projectidSet.add(project.id);
        projecttobeprocessSet.add(project.id);
        
    }
    static testMethod void testBatch() {
        initializedData();
        Test.startTest(); 
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
        
		system.Assert(string.IsNotBlank(jobId), 'job created');         
        Test.stopTest();
        
        
        
    }

}