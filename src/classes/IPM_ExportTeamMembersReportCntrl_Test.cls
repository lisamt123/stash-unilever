/****************************************************************************************************************************************************
* @author Cognizant
* @date  08/01/2016
* @description: This is Test class for IPM_ExportTeamMembersReportController.Using 'seeAllData=true' as Reports can not be created in test classes.
                Not using '@testSetup' as 'seeAllData=true' and '@testSetup' can not be used together.
                https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_analytics_test_reports.htm  
*****************************************************************************************************************************************************/
@isTest(seeAllData=true)
private with sharing class IPM_ExportTeamMembersReportCntrl_Test {
	
	private static User centralTeamProfileUser; 
	
	private static Pagereference  pRef = Page.IPM_ExportTeamMembersReport; 
	
	private static List<IPM_User_Profile__c> createUserProfileList;
	
	private static final String LAUNDRY = 'Laundry';  
	private static final String IPM_ALL_USERS_GROUP = 'IPM_All Users';
	
	/***********************************************************************************************************************************************************
	* @description To create test data to be used in test methods
	************************************************************************************************************************************************************/
	private static void testDataSetUP() 
	{
	 	centralTeamProfileUser = IPM_TestFactory_Helper.createIPMCentralTeamProfileUser(); 
	 	
	 	System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
	 	{
		    IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false); 
		    IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);		    
		    globalCompanyCard.IPM_Managed_category__c=regionalCompanyCard.IPM_Managed_category__c=LAUNDRY;
		    insert new List<IPM_Company_Card__c> {globalCompanyCard,regionalCompanyCard};
	    
			createUserProfileList=IPM_TestFactory_Helper.createUserProfileList(new List<Id> {centralTeamProfileUser.Id,centralTeamProfileUser.Id}, new List<IPM_Company_Card__c> {globalCompanyCard,regionalCompanyCard},false); 
			createUserProfileList[0].IPM_Company_Card__c=globalCompanyCard.ID; 
			createUserProfileList[1].IPM_Company_Card__c=regionalCompanyCard.ID;
			createUserProfileList[0].IPM_User__c=createUserProfileList[1].IPM_User__c=centralTeamProfileUser.Id;
			insert createUserProfileList; 
			
			//Adding user to the  IPM_All_Users public group,All IPM Reports are shared with this folder
			GroupMember grpMember = new GroupMember();
			List<Group> listGroup =[Select Id from Group where name=:IPM_ALL_USERS_GROUP];
			grpMember.GroupId =listGroup[0].Id;
			grpMember.UserOrGroupId=centralTeamProfileUser.Id;
			insert grpMember;
			
			system.assertEquals([Select IPM_User__c from IPM_User_Profile__c where IPM_Company_Card__c=:globalCompanyCard.Id limit 1].IPM_User__c,centralTeamProfileUser.Id,'Unable to create user profile with the specified User');    
            
        }   
	 	
	}  
	
	/***********************************************************************************************************************************************************
	* @description To test if data is availble after load of page IPM_ExportTeamMembersReport page
	************************************************************************************************************************************************************/
	private static testmethod void IPM_ExportTeamMembersReport()
	{ 
		
	    testDataSetUP();
		
		//Running as Central Team Member as they are the ones using the report export functionality through the IPM_ExportTeamMembersReport page
		system.runAs(centralTeamProfileUser) 
		{
			
		     List<IPM_Project__c> reportRecords = IPM_TestFactory_Helper.projectSetUp(5,centralTeamProfileUser);
			 
			 for(IPM_Project__c reportPrj : reportRecords)  
			 {
			 	reportPrj.IPM_Company_Card__c=createUserProfileList[0].IPM_Company_Card__c;     
			 } 
			 
			 //inserting project records to be shown  in Excel
			 IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
			 insert  reportRecords; 
			 IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = false;
             
			  Test.StartTest(); 
				Test.setCurrentPage(pRef); 
				IPM_ExportTeamMembersReportController expTeamMemRepCntrl = new  IPM_ExportTeamMembersReportController();
			  
				//checking if report data is fetched onto the page
				system.assert(expTeamMemRepCntrl.reportResults.getAllData(),'Unable to fetch the Report Records');    
			Test.StopTest(); 			 
		
		} 
	}
    
}