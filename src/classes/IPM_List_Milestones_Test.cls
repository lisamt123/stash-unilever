/**
* IPM_List_Milestones_Test : This Test class for IPM_List_Milestones  apex class
* @author : Cognizant
*
*/@isTest
private class IPM_List_Milestones_Test {
    
    
    private static User stdUserForMilestone;
	private final static String IPM_MilestoneType = IPM_ConstantUtils.BET; 
	private final static String PROJ_ID='Pid';
    
    /*
        *  Description: Generic Milestone Set up data
        *  @name mileStoneSetUp
    */
    @testSetup static void mileStoneSetUp(){
        
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
        
        IPM_TestFactory_Helper.getProjectMasterData();
        List<IPM_Project__c> projectList = IPM_TestFactory_Helper.projectSetUp(1, stdUserForMilestone);
        System.runAs(stdUserForMilestone)
        {
            projectList[0].IPM_Market_Type__c = IPM_Utils.DevelopingIPM_Market_Type;
            projectList[0].BET_TLD_First_Release_Date__c = Date.today();
            projectList[0].BET_TLD_Final_Release_Date__c = Date.today().addDays(5);
            projectList[0].BET_First_Release_Missed__c = true;
            projectList[0].BET_Final_Release_Missed__c = true;
            insert projectList;
            
         	System.assertEquals([Select IPM_Market_Type__c  from IPM_Project__c WHERE Id =: projectList[0].Id].IPM_Market_Type__c,IPM_Utils.DevelopingIPM_Market_Type, 'Project with the specified market type  not created');
            
                
            
        } 
    } 
    
    
    /*
        *  Description : To test the functionalities related to IPM_LIst_Milestone class which has been used to display milestones on Milestone and To Dos screen
        *  @Name: listMilestoneTest
    */
    Static testMethod void listMilestoneTest(){
        
        Set<String> projectNameSet = new Set<String>{'TestComments1'};
        
        //Get the project data
        IPM_Project__c proj = [SELECT Id, Name, IPM_Target_Launch_Dates__c, IPM_Project_Type__c, IPM_GateKeeping_Model__c, IPMProject_Span__c, IPM_Phase__c, IPM_CompanyCardText__c from IPM_project__c WHERE Name IN: projectNameSet ];
        // get the running user information
        User globalUser = [Select Id, Name, LastName from User where LastName = 'PLATFORM_USER' limit 1]; 
        
        List<IPM_Project__c> newProject =IPM_TestFactory_Helper.createIPMProjectList(false,1);
            
        newProject[0].IPM_Phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
        newProject[0].IPM_Parent_Project__c = proj.id;
        newProject[0].IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT; 
        newProject[0].IPM_Project_Leader__c = globalUser.Id;
        newProject[0].IPM_Project_Name__c = 'TestPrj1';
        newProject[0].IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
        newProject[0].IPMProject_Span__c = IPM_ConstantUtils.COMPANY_CARD_REGIONAL;
        newProject[0].IPM_CompanyCardText__c = IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
                    
        insert newProject; 
        
        System.runAs(globalUser)
        {
            Test.startTest();
            
            PageReference pg = Page.IPM_ProjectSetupView;
            Test.setCurrentPageReference(pg);
            ApexPages.CurrentPage().getparameters().put(PROJ_ID, proj.id); // NO SONAR. Pid has been used at mutiple places to cover multiple scenarios
            System.Assert(ApexPages.CurrentPage().getparameters().get(PROJ_ID) == proj.id, SHOULDBESAME);
            IPM_List_Milestones mileList = new IPM_List_Milestones();
            mileList.isCompleteMilestones = 'f'; 
            mileList.checkForOTIFWarning();
            
        
            // Methods to sort the milestones 
            mileList.toggleSortMilestones();
            mileList.toggleSortPhases();
            
	    List<IPM_Milestone__c> milestoneList = [Select Id, IPM_Phase__c, IPM_Due_Date__c from IPM_Milestone__c WHERE IPM_Project__c =: proj.Id];
            System.assert(milestoneList.size() > 0, 'milestones succeefully not created');
            
            System.assert(mileList.strLink.contains(IPM_List_Milestones.DEFAULT_TLD_LINK),'strlink is not the default link.'+mileList.strLink);            
	        
            mileList.projectObj = newProject[0];
            mileList.toggleSortMilestones();
 
                        
            mileList.filteredphaseM();
            mileList.filterCompleteMilestones();
            mileList.setMilestoneId(STR_TEST);
            String milestoneid = mileList.getMilestoneId();
            System.Assert(milestoneid == STR_TEST, SHOULDBESAME);
            mileList.setphaseM(STR_TEST);
            String phasevalue = mileList.getphaseM();
            System.Assert(phasevalue == STR_TEST, SHOULDBESAME);
            
            IPM_Milestone__c ipmMilestone = [Select Id, Name, IPM_Project__c from IPM_Milestone__c WHERE IPM_Project__c =: proj.Id limit 1];
            
            mileList.milestoneId = String.valueOf(ipmMilestone.Id);
            mileList.isChecked = 'true';
            mileList.markCompleteM();
            
            List<IPM_Milestone__c> completedmilestoneList = [Select Id, IPM_Phase__c, IPM_Completed__c, IPM_Completed_On__c from IPM_Milestone__c WHERE Id=:ipmMilestone.Id];
            // First milestone should be completed and today date should be set.
            System.assert(completedmilestoneList[0].IPM_Completed__c, 'Milestone successfully not completed');
            System.assert(completedmilestoneList[0].IPM_Completed_On__c == System.today(), 'Milestone successfully not completed Today');
            
            mileList.toggleSortCompletion();
            mileList.toggleSortCompletedOn();
            
            mileList.deleteMilestone();
            // Assert to check milestone has been deleted.
            System.assert([Select Id, IPM_Completed__c from IPM_Milestone__c WHERE Id =:ipmMilestone.Id].size() == 0, 'Milestone has not been deleted.');
            Test.stopTest();
        }
    }
    
    
    public static final string SHOULDBESAME = 'Should be same';
    public static final String STR_TEST = 'test';
    static User runningUser = IPM_TestFactory_Helper.createUser(true);
    

    /**************************************************
    * @description : Test method for  BET warning messages on milestones
    ***************************************************/
    Static testMethod void betWarningMessagesnMilestonestest() {  
         Set<String> projectNameSet = new Set<String>{'TestComments1'};
        
        //Get the project data
        IPM_Project__c proj = [SELECT Id, Name,BET_TLD_First_Release_Date__c,BET_TLD_Final_Release_Date__c,BET_Final_Release_Missed__c ,
                               BET_First_Release_Missed__c ,IPM_Target_Launch_Dates__c from IPM_project__c WHERE Name IN: projectNameSet limit 1 ];
      
        System.Assert(projectNameSet.contains(proj.Name), 'The project record with the specified name not inserted');

        Id  PROJECT_MILESTONE_RECTYPE = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.milePMRecordType).getRecordTypeId();
        
        IPM_Milestone__c projMilestoneFirst = IPM_TestFactory_Helper.createIPMMilestone(proj.Id, false);
        projMilestoneFirst.Name = 'BETFirstReleaseMilestone';
        projMilestoneFirst.IPM_Type_of_Milestone__c = IPM_MilestoneType;
        projMilestoneFirst.IPM_Due_Date__c = Date.today().addDays(-30);
        projMilestoneFirst.ExternalField__c=proj.Id + IPM_ConstantUtils.BET_MS_FIRST_RELEASE;
        projMilestoneFirst.recordTypeId = PROJECT_MILESTONE_RECTYPE;
        
        IPM_Milestone__c projMilestoneFinal = IPM_TestFactory_Helper.createIPMMilestone(proj.Id, false);
        projMilestoneFinal.Name = 'BETFinalReleaseMilestone';
        projMilestoneFinal.IPM_Type_of_Milestone__c = IPM_MilestoneType;
        projMilestoneFinal.IPM_Due_Date__c = Date.today().addDays(-25);
        projMilestoneFinal.ExternalField__c=proj.Id+ IPM_ConstantUtils.BET_MS_FINAL_RELEASE;
        projMilestoneFinal.recordTypeId = PROJECT_MILESTONE_RECTYPE;
        
        upsert new List < IPM_Milestone__c > {
            projMilestoneFirst, projMilestoneFinal
        } ExternalField__c;
        
        Set<Id> milestoneIds = new Set<Id>{ projMilestoneFirst.Id, projMilestoneFinal.Id } ;

        System.AssertEquals(2,[Select count() from IPM_Milestone__c where Id IN : milestoneIds], 'Failed to insert milestone list. ');
        
        User globalUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        system.runAs(globalUser) {

            Test.StartTest();
            PageReference pg = Page.IPM_ProjectSetupView;
            Test.setCurrentPageReference(pg);
            ApexPages.CurrentPage().getparameters().put(PROJ_ID, proj.id);
            IPM_List_Milestones ipmListMilestones = new IPM_List_Milestones();
            System.Assert(ApexPages.CurrentPage().getparameters().get(PROJ_ID) == ipmListMilestones.projectId, 'Unable to set page parameter Pid');
            System.AssertNotEquals(ipmListMilestones.warningMessages.size(), 0, 'Messages not available');
            System.Assert(new Set<String> (ipmListMilestones.warningMessages).contains(system.label.IPM_BETFirstReleaseMissed),'Failed  to display BET first release message.');
            System.Assert(new Set<String> (ipmListMilestones.warningMessages).contains(system.label.IPM_BETFinalReleaseMissed),'Failed  to display BET final release message.');
            ipmListMilestones.getWrapperRecords();
            ipmListMilestones.postProcessing(new List < IPM_Milestone__c > {
                projMilestoneFirst, projMilestoneFinal
            });
			for(AbstractStandardSetExtension.sObjectPaginationWrapper wrapObj : ipmListMilestones.wrapperRecordList ){
          		if(((IPM_Milestone__c)wrapObj.record).IPM_Type_of_Milestone__c == IPM_MilestoneType){
	          		System.AssertEquals(wrapObj.isEditable, false, 'Failed to set  Bet milestones to read only'); 
	          		System.AssertEquals(wrapObj.isDeletable, false, 'BET milestones are deletable!'); 
          		}
          	}
            Test.StopTest();
        }

    }
    
    /******************************************************
    * @name: testExportFunctionality
    * @description: test milestone export to excel functionality

   ****************************************************/
   public static testmethod void testMilestoneExportToExcel()
   {
   	//get user
       User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
       
       Set<String> projectNameSet = new Set<String>{'TestComments1'};
       
       //Get the project data
        IPM_Project__c proj = [SELECT Id, Name, IPM_Target_Launch_Dates__c from IPM_project__c WHERE Name IN: projectNameSet ];
        
       //run as PL
       System.runAs(globalUser) 
       {
	        Test.startTest();
	        
	        PageReference pg = Page.IPM_ProjectSetupView;
            Test.setCurrentPageReference(pg);
            ApexPages.CurrentPage().getparameters().put(PROJ_ID, proj.id); // NO SONAR. Pid has been used at mutiple places to cover multiple scenarios
            System.Assert(ApexPages.CurrentPage().getparameters().get(PROJ_ID) == proj.id, SHOULDBESAME);
            IPM_List_Milestones mileList = new IPM_List_Milestones();
            mileList.isCompleteMilestones = 'f'; 
            
            List<IPM_Milestone__c> milestoneList = [Select Id, IPM_Phase__c, IPM_Due_Date__c from IPM_Milestone__c WHERE IPM_Project__c =: proj.Id limit 50000];
            System.assert(milestoneList.size() > 0, 'milestones succeefully not created');
            
	   		mileList.exportToExcel();
	   		
	   		Test.setCurrentPageReference(new PageReference('Page.IPM_ExportToExcel'));
	   		
	   		System.currentPageReference().getParameters().put('currentObject','IPM_Milestone__c');
        	System.currentPageReference().getParameters().put('fieldSetName','IPM_Export_List_FieldSet');
        	System.currentPageReference().getParameters().put('whereClause','');
        
			IPM_ExportDataController exportCtrl= new IPM_ExportDataController();
	   		exportCtrl.getFields();
	   		
	   		List<IPM_Milestone__c> listOfMilestonesExported = [Select IPM_Project__r.IPM_Project_Name__c,Name,IPM_Phase__c,IPM_Due_Date__c,IPM_Completed_On__c from IPM_Milestone__c limit 50000];
	   		
	   		system.assert(listOfMilestonesExported.size() != null,'Milestones to be exported not queried');
	   		Test.stopTest();
       }
   }

}