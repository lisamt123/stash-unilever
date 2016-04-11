/**
@Author  Cognizant 
@name IPM_Gate_Milestones_Test
@CreateDate 15/04/2015
@DescriptionTest Class for Gate Milestones Controller
@Version <1.0>
@reference IPM_Gate_Milestones
*/
@isTest
private class IPM_Gate_Milestones_Test {
    
    private static User stdUserForMilestone;
    private static final string TEST_COMMENTS_STR='TestComments1';
    private static final string PROJECT_MILESTONE_MASG = 'Project Has not milestone';
    private static final string MILESTONE_CURRENT_DUE_DATE = 'Milestone Current due date is activated'; 
    private static final string MILESTONE_IDEA = 'Milestone is not for Idea Phase';
    private static final string MILESTONE_FEASIBILITY = 'Milestone is not for Feasibility Phase';
    private static final string MILESTONE_CAPABILITY = 'Milestone is not for Capabitity Phase';
    private static final string MILESTONE_MARKETREADY = 'Milestone is not for Market Ready phase';
    
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
        
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card insertion fails');// Positive Test;
        
        // Inserting Master Data whose OWD are set to readOnly/View All    
        IPM_TestFactory_Helper.getProjectMasterData();
        
        // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{stdUserForMilestone});
        
        List<IPM_Project__c> projectList = IPM_TestFactory_Helper.projectSetUp(1, stdUserForMilestone);
        System.runAs(stdUserForMilestone)
        {
            insert projectList;
            
             List<IPM_Project__c> projlList1=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectList[0].ID LIMIT 1];
            System.assertEquals(projlList1[0].Name,TEST_COMMENTS_STR,'project set up fails');//positive test
        } 
        
    }    
	
	 /**
	    *  Description Running Test Script
	    *  @name showMilestonesTest
	*/
	public static testmethod void showMilestonesTest(){
		
		Set<String> projectNameSet = new Set<String>{'TestComments1'};
		
		List<IPM_Project__c> projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,(Select Id from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r ),
                (Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r)
                from IPM_Project__c where Name in:projectNameSet];
        // get the running user information
		User globalUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];  
        
        System.assert(projectList[0].IPM_Milestones__r.size() > 0, PROJECT_MILESTONE_MASG); // Positive Test
        System.runAs(globalUser)
        { 
            Test.startTest();
            IPM_Gate_Milestones gateMilestones= new IPM_Gate_Milestones();
            gateMilestones.projectId = projectList[0].Id;
            gateMilestones.gateType=IPM_ConstantUtils.CHARTER_GATE;
            gateMilestones.gateDocumentStatus=IPM_ConstantUtils.STATUS_APPROVED;
            gateMilestones.projectId = projectList[0].Id;
           
            System.assertEquals(true, gateMilestones.isIdeaSnapShot, MILESTONE_IDEA);//Positive Test
            System.assertEquals(false, gateMilestones.isCurrentDueDate, MILESTONE_CURRENT_DUE_DATE); // Positive Test
            
            gateMilestones.gateType=IPM_ConstantUtils.CONTRACT_GATE;
            gateMilestones.projectId = projectList[0].Id;
            
            System.assertEquals(true, gateMilestones.isFeasibilitySnapShot, MILESTONE_FEASIBILITY);// Positive Test
            System.assertEquals(false, gateMilestones.isCurrentDueDate, MILESTONE_CURRENT_DUE_DATE);// Positive Test
            
            gateMilestones.gateType=IPM_ConstantUtils.MARKET_READY_GATE;
            gateMilestones.projectId = projectList[0].Id;
            
            System.assertEquals(true, gateMilestones.isCapabilitySnapShot, MILESTONE_CAPABILITY);// Positive Test
            System.assertEquals(false, gateMilestones.isCurrentDueDate, MILESTONE_CURRENT_DUE_DATE);// Positive Test
            
            gateMilestones.gateType=IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE;
            gateMilestones.projectId = projectList[0].Id;
            
            System.assertEquals(true, gateMilestones.isMarketReadySnapShot, MILESTONE_MARKETREADY);// Positive Test
            System.assertEquals(false, gateMilestones.isCurrentDueDate, MILESTONE_CURRENT_DUE_DATE);// Positive Test
            
            // assert to check Component is displaying the milestones related to that particular project 
            List<IPM_Milestone__c>milestoneList=[Select Id from IPM_Milestone__c WHERE IPM_Project__c =: gateMilestones.projectId];
                                               
            System.assertNotEquals(milestoneList.size(),0,'retreiving project has not specific milestones');

            
            Test.stopTest();    
        }
	}
}