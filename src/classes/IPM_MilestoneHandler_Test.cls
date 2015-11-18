/**
  @author:Cognizant
  @name :IPM_MilestoneHandler_Test
  @CreateDate :09/09/2015
  @description: This test class will cover the functionality which have been covered in IPM_MilestoneHandler
  @Version :1.0
  @reference : IPM_MilestoneHandler
*/
@isTest
private class IPM_MilestoneHandler_Test {
	  
    private static User stdUserForMilestone;
    
    /*
        *  Description: Milestone Set up data
        *  @name mileStoneSetUp
    */
   @testSetup static void mileStoneSetUp() 
     {
         // Create an instance of admin user.
         User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
         
         User globalProjectLeader = null;
         // Create an instances of standard Users for Allocation to Project Leaders.
         System.runAs(adminUser)
         {   
            globalProjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            User regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            User localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            
            // Update LastNames to match functionalRoles
            globalProjectLeader.lastname = 'GLOBAL_PL';
            regionalProjectLeader.lastname = 'REGIONAL_PL';
            localProjectLeader.lastname = 'LOCAL_PL'; 
            
            List<User> userList = new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader};
            update userList;
         
            // Create Company Card information(Master Data)
	        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
	        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
	        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
	        
	        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
	        insert companyCardList;
	        
	        // Inserting Master Data whose OWD are set to readOnly    
            IPM_TestFactory_Helper.getProjectMasterData();
        }   
        
        System.runAs(globalProjectLeader)
        {   
            List<IPM_Project__c> projectList = IPM_TestFactory_Helper.projectSetUp(3,globalProjectLeader);
            insert projectList; 

        }
     }
     
   
   	/**
        *  Used for Testing Global Project's Milestone creation. 
        *  @name createMilestone
     */
	 public static testmethod void createMilestone()
     {
	   
	    Test.startTest();
    	 
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
        
        User globalUser = [Select Id from User where LastName ='GLOBAL_PL' limit 1];
        
        Id  mileMasterRecordType = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.mileMRecordType).getRecordTypeId();
        Map<Id,IPM_Milestone__c>  standardMileStoneMap = new Map<Id,IPM_Milestone__c>([Select Id,Name,IPM_Type_of_Milestone__c from IPM_Milestone__c where IPM_Type_of_Milestone__c ='Standard' AND recordTypeId =:mileMasterRecordType AND IPM_Project_Type__c='Original' ] );
            
        System.RunAs(globalUser)
        {
            List<IPM_Project__c> projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,(Select Id from Project_Documents__r),
                                                    (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
                                                    (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
            
            // Get Standard Milestones from database  
            System.assert(standardMileStoneMap.values().size() > 0);
            
            for(IPM_Project__c project : projectList)
            {
                System.assertEquals(project.Project_Documents__r.size(),1);
                
                System.assertEquals(project.IPM_Milestones__r.size(),standardMileStoneMap.size());
		        
            }               
        } 
        Test.stopTest();
     }
     
     /*@Name : copyMilestoneDetails
       @Description :  This method will cover the copy over due date logic of milestones.
     
     */
     
     public static testmethod void copyMilestoneDetails(){
		
		Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3', 'TestComments1_LR_Local', 'TestComments2_LR_Local', 'TestComments3_LR_Local', 'TestComments1_LR', 'TestComments2_LR', 'TestComments3_LR'};
		List<IPM_Milestone__c> milestoneTestList = [Select Id, IPM_Project__c, IPM_Due_Date__c, IPM_Planned_Date__c from IPM_Milestone__c WHERE IPM_Project__r.Name IN: projectNameSet for update]; 
		
		for(Integer i =0; i < milestoneTestList.size(); i++){
			milestoneTestList[i].IPM_Due_Date__c = System.today() + 1;
			milestoneTestList[i].IPM_Planned_Date__c = System.today() + 2;
			milestoneTestList[i].IPM_Phase__c = milestoneTestList[i].name;
		}
		test.startTest();
	   
		update milestoneTestList;
		test.stopTest();
	}

}