/**
@Author  Cognizant 
@name IPM_Gate_Milestones_Test
@CreateDate 15/04/2015
@DescriptionTest Class for Gate Milestones Controller
@Version <1.0>
@reference IPM_Gate_Milestones
*/
@isTest
public class IPM_Gate_Milestones_Test {
	
	private static User stdUserForMilestone;
	
	/**
	    *  Description: Milestone Set up data
	    *  @name mileStoneSetUp
	*/
	@testSetup static void mileStoneSetUp() 
    {
       System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
    	{
    	    // user has to be created as system admin 
         	stdUserForMilestone = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }   
		// Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
        // Inserting Master Data whose OWD are set to readOnly/View All    
        IPM_TestFactory_Helper.getProjectMasterData();
        
        // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{stdUserForMilestone});
        
        List<IPM_Project__c> projectList = IPM_TestFactory_Helper.projectSetUp(1, stdUserForMilestone);
        System.runAs(stdUserForMilestone)
        {
            insert projectList;
        } 
        
    }    
	
	 /**
	    *  Description Running Test Script
	    *  @name showMilestonesTest
	*/
	public static testMethod void showMilestonesTest(){
		
		Set<String> projectNameSet = new Set<String>{'TestComments1'};
		
		List<IPM_Project__c> projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,(Select Id from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r ),
                (Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r)
                from IPM_Project__c where Name in:projectNameSet];
        // get the running user information
		User globalUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];  
        
        System.assert(projectList[0].IPM_Milestones__r.size() > 0); 
        System.runAs(globalUser)
        { 
        	Test.startTest();
			IPM_Gate_Milestones gateMilestones= new IPM_Gate_Milestones();
			gateMilestones.projectId = projectList[0].Id;
			// assert to check Component is displaying the milestones related to that particular project 
			System.assert([Select Id from IPM_Milestone__c WHERE IPM_Project__c =: gateMilestones.projectId ].size() > 0);
			Test.stopTest();	
        }
	}
}