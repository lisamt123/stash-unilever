/*******************************************************
 * @Description: Test class for IPM_Milestone
   @Author Cognizant
   @Date:10/09/2015 
   @Modified Date:10/09/2015 
   @name IPM_Milestone_Test
  */

@isTest(SeeAllData=false)
public class IPM_Milestone_Test
{
    
    private static User stdUserForMilestone;
    private static IPM_Milestone__c ipm2,ipm3,milestone1;
    private static final Id mileStoneRecordType=Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.IPMProjectMilestones).getRecordTypeId();
    private static final String PROJECTID_STRING = 'projectId'; 
    private static final String MINIMSID_STRING = 'minMsId'; 
    private static final String TEST_COMMENTS_STR = 'TestComments1'; 
    private static final String MINIMS_ERRORMSG = 'Mini Milestones successfully not created';
    private static final String RETURN_NULL = 'Return null';
    
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
        
        List<IPM_Project__c> masterProjectList =  [Select Id from IPM_Project__c where IPM_Project_Name__c ='IPM_MasterProject'];
        
        List<IPM_Milestone__c> masterMilestones = [Select Id, IPM_Phase__c from IPM_Milestone__c WHERE IPM_Project__c =: masterProjectList[0].Id];
        
        System.assert(masterMilestones.size() > 0, 'Milestone successfully not created');
        
        // Insert Master MINI Milestone Data 
        List<IPM_Milestone__c> miniMilestoneList = new List<IPM_Milestone__c>();
            
        for(Integer i = 0; i < 5; i++){
            IPM_Milestone__c miniMilestone= new IPM_Milestone__c();
            miniMilestone.RecordTypeId = mileStoneRecordType;
            miniMilestone.name = 'Mini Milestone' + i;
            if(i == 4){
            	miniMilestone.IPM_Due_Date__c = null;
            }
            else{
            	 miniMilestone.IPM_Due_Date__c = system.today().adddays(-2);
            }
        	
        	 miniMilestone.IPM_Type_of_Milestone__c = IPM_ConstantUtils.MINI;
             miniMilestone.IPM_Milestone__c = masterMilestones[i].id;
             miniMilestone.IPM_Phase__c = masterMilestones[i].IPM_Phase__c;
            
             miniMilestone.IPM_Name__c = 'Mini Milestone' + i;
            
             miniMilestone.IPM_Project_Type__c = 'Original';
             miniMilestone.ExternalField__c = 'gfgfg'+ i;
             miniMilestone.IPM_Project__c = masterProjectList[0].Id;
             miniMilestoneList.add(miniMilestone);
        }
        insert miniMilestoneList;
                
        List<IPM_Milestone__c> miniMSList = [Select Id, Name, IPM_Name__c, IPM_Phase__c, IPM_Project__c from IPM_Milestone__c WHERE IPM_Type_of_Milestone__c =: IPM_ConstantUtils.MINI];
        
        System.assertEquals(!miniMSList.isEmpty(),true, MINIMS_ERRORMSG);
        
        System.runAs(stdUserForMilestone)
        {
            System.assertEquals(!miniMSList.isEmpty(),true, 'Mini Milestones not visible to End User');
            insert projectList;
            
        } 
        
    }
    
    /********************************************************************************
    *@Description : Method Covering Explicit calls and Wrapper of IPM_MIlestone Class which has been used for EDIT MIlestone and Add Mini/Adhoc Milestone pages
    *********************************************************************************/           
    public static testmethod void IPM_MilestoneTest(){
        Test.startTest();
        Set<String> projectNameSet = new Set<String>{TEST_COMMENTS_STR};
        //Get the project data
        IPM_Project__c proj = [SELECT Id, Name from IPM_project__c WHERE Name IN: projectNameSet ];
        
        // get the running user information
        User globalUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];  
       
        List<IPM_Milestone__c> miniMSList = [Select Id, Name, IPM_Name__c, IPM_Phase__c, IPM_Milestone__c, IPM_Project__c, IPM_Due_Date__c, IPM_phase_order__c from IPM_Milestone__c WHERE IPM_Type_of_Milestone__c =: IPM_ConstantUtils.MINI];
        System.assertEquals(!miniMSList.isEmpty(),true, MINIMS_ERRORMSG);
        
        List<IPM_Milestone__c> miniMSList1 = [Select Id, Name, IPM_Name__c, IPM_Phase__c, IPM_Milestone__c, IPM_Project__c, IPM_Due_Date__c from IPM_Milestone__c WHERE IPM_Type_of_Milestone__c =: IPM_ConstantUtils.MINI AND IPM_Due_Date__c =: null];
        System.assert(miniMSList1.size() > 0, MINIMS_ERRORMSG);
        
        System.runAs(globalUser){
            
            proj.IPM_PM_Approach__c = IPM_ConstantUtils.IPM_APPROACH_INTERNAL;
            update proj;
            
            IPM_Milestone__c milestoneobj1 = IPM_TestFactory_Helper.createIPMMilestone(proj.id, false);
            milestoneobj1.RecordTypeId = mileStoneRecordType;
            milestoneobj1.name= 'Test-New2';
            milestoneobj1.IPM_Due_Date__c = system.today() - 2;
            milestoneobj1.IPM_Planned_Date__c = system.today() - 2;
            milestoneobj1.IPM_Type_of_Milestone__c = IPM_ConstantUtils.STANDARD;
            milestoneobj1.ExternalField__c = '-New2';
            milestoneobj1.IPM_Name__c = IPM_Utils.MarketDeploymentGateApproval;
            milestoneobj1.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
            milestoneobj1.IPM_Project__c = proj.Id;
            insert milestoneobj1;        
            
            Test.setCurrentPageReference(Page.IPM_EditMilestone);
            apexpages.currentpage().getparameters().put(PROJECTID_STRING,proj.id); // NO SONAR on 'projectId'. It has been used to cover multiple scenarios on the page.
            apexpages.currentpage().getparameters().put(IPM_Utils.taskId,milestoneobj1.id);
            
            IPM_Milestone milesCtrl = new IPM_Milestone(new ApexPages.StandardController(milestoneobj1));
            // Validation check for standard milestone  
            System.assertEquals(milesCtrl.validateMilestone(), false,'Milestone Validation Failed');
            
            
            milestoneobj1.IPM_Planned_Date__c = system.today() + 2;
            milestoneobj1.IPM_Due_Date__c = system.today() + 2;
            update milestoneobj1;
            
            Test.setCurrentPageReference(Page.IPM_EditMilestone);
            apexpages.currentpage().getparameters().put(PROJECTID_STRING,proj.id);
            apexpages.currentpage().getparameters().put(IPM_Utils.taskId,milestoneobj1.id);
            IPM_Milestone milesCtrl1 = new IPM_Milestone(new ApexPages.StandardController(milestoneobj1));
            milesCtrl1.validateMilestone();
            
            
            List<IPM_Milestone__c> msStdList = [Select Id, Name, IPM_Name__c, IPM_Phase__c, IPM_Project__c from IPM_Milestone__c WHERE IPM_Project__c =: proj.Id AND IPM_Type_of_Milestone__c =: IPM_ConstantUtils.STANDARD];
            
            list<IPM_Milestone__c> listmilestone =new list<IPM_Milestone__c>();
            listmilestone.add(milestone1);
            
            Test.setCurrentPageReference(Page.IPM_AddMileStone);
            apexpages.currentpage().getparameters().put(PROJECTID_STRING,proj.id);
            
            IPM_Milestone ipmMSCtrl = new IPM_Milestone(new ApexPages.StandardController(new IPM_Milestone__c()));
            
            List<IPM_Milestone.MilestoneWrapper> msWrapList = new List<IPM_Milestone.MilestoneWrapper>();
            
            for(Integer i = 0; i < 5; i++){
                IPM_Milestone.MilestoneWrapper ipmMSWrap = new IPM_Milestone.MilestoneWrapper();
                if(ipmMSWrap.mile.IPM_Due_Date__c != null){
                	ipmMSWrap.checked = true;
                }
                
                ipmMSWrap.mile = miniMSList[i];
                ipmMSWrap.mile.IPM_Milestone__c = milestoneobj1.Id;                
                msWrapList.add(ipmMSWrap);
            } 
            ipmMSCtrl.milestones = msWrapList; 
            system.assertEquals(ipmMSCtrl.milestones[0].mile.IPM_phase_order__c, 1.00, 'Mini milestone not created properly.');
            
            Apexpages.currentpage().getparameters().put(MINIMSID_STRING, miniMSList[0].Id);
	        ipmMSCtrl.selectMiniMs();
	        system.assertNotEquals(miniMSList[0].IPM_Due_Date__c, null, 'Due Date field is filled');
	        system.assertEquals(ipmMSCtrl.milestones[0].checked, true, 'Milestone is checked');
	        
           	Apexpages.currentpage().getparameters().put(MINIMSID_STRING, miniMSList1[0].Id);
	       	ipmMSCtrl.selectMiniMs();
            system.assertEquals(miniMSList1[0].IPM_Due_Date__c, null, 'Due Date field is filled');
            system.assertEquals(ipmMSCtrl.milestones[4].checked, false, 'Milestone is checked');          
            
            ipmMSCtrl.createMileStones();
            
            // Checking for the Test Method
            ipm2 = (IPM_Milestone__c)IPM_TestFactory.createSObject('IPM_Milestone__c', new Map<string,object> {'IPM_Project__c'=>proj.id,'name'=>IPM_Utils.MarketReadyGateApproval,'IPM_BET__c'=>true,'IPM_Type_of_Milestone__c'=>IPM_ConstantUtils.STANDARD,'IPM_Name__c'=>IPM_Utils.BETFirstRelease, 'IPM_Phase__c' => IPM_ConstantUtils.PHASE_IDEAS} , true);
            IPM_Milestone milestoneCtrl = new IPM_Milestone(new ApexPages.StandardController(ipm2));
            
            for (IPM_Milestone.MilestoneWrapper msWrap : milestoneCtrl.milestones) {
                    msWrap.checked=true;
            }
            milestoneCtrl.createMileStones(); 
            System.Assert(milestoneCtrl.createMileStones() == null , RETURN_NULL); // NO SONAR. 'Retuen null' is expected as part of assert statement in multiple senarios
            
            ipm3 = (IPM_Milestone__c)IPM_TestFactory.createSObject('IPM_Milestone__c', new Map<string,object> {'IPM_Project__c'=>proj.id,'name'=>IPM_Utils.MarketReadyGateApproval,'IPM_BET__c'=>true,'IPM_Type_of_Milestone__c'=>IPM_ConstantUtils.STANDARD,'IPM_Name__c'=>IPM_Utils.BETFinalReleasecompletewithApprovedCommunication} , true);
            
            IPM_Milestone.MilestoneWrapper ic2 = new IPM_Milestone.MilestoneWrapper();
            System.assertEquals(False, ic2.checked, 'Milestone is checked');
            
            IPM_Milestone.MilestoneWrapper ic1 = new IPM_Milestone.MilestoneWrapper(ipm3,System.today());
            System.AssertEquals(True, ic1.checked ,'Milestone Not Checked');
            
            //Explicit calls to Method
            milestoneCtrl.createMileStones();
            System.Assert(milestoneCtrl.createMileStones() == null ,RETURN_NULL);
            
            milestoneCtrl.promptForTaskUpdate();
            System.Assert(milestoneCtrl.promptForTaskUpdate() == null ,RETURN_NULL);
            
            milestoneCtrl.saveMilestoneAndTasks();
            System.Assert(milestoneCtrl.saveMilestoneAndTasks() == null ,RETURN_NULL);
            
            milestoneCtrl.milestoneObj = milestoneobj1; // Get the due date of Current project's phase milestone
            
            milestoneCtrl.getduedate();
            // To test the exception  
            milestoneCtrl.upsertMilestones(listmilestone);
            
            
            milestoneobj1.IPM_Planned_Date__c = system.today() + 2;
            milestoneobj1.IPM_Due_Date__c = system.today() + 2;
            update milestoneobj1;
            
            
            Test.setCurrentPageReference(Page.IPM_EditMilestone);
            apexpages.currentpage().getparameters().put(PROJECTID_STRING,proj.id);
            apexpages.currentpage().getparameters().put(IPM_Utils.taskId,msStdList[2].id);
            IPM_Milestone milestoneController = new IPM_Milestone(new ApexPages.StandardController(msStdList[2]));
            milestoneController.validateMilestone();
            milestoneController.saveMilestoneAndTasks();
       }  
        
        Test.stopTest();
    }    
    
    
    /********************************************************************************
    *@Description : To pass different conditional value of Milestones and validate them
    *********************************************************************************/    

    public static testmethod void IPM_Validationchecks(){
        Test.startTest();
        
        IPM_Milestone__c milestone,mile;
        
        Set<String> projectNameSet = new Set<String>{TEST_COMMENTS_STR};
        //Get the project data
        IPM_Project__c project = [SELECT Id, Name, IPM_PM_Approach__c, IPM_Phase__c from IPM_project__c WHERE Name IN: projectNameSet ];
        
        // get the running user information
        User globalUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];  
        
        System.runAs(globalUser){
            
            Map<String, IPM_Milestone__c> ipmMilestoneMap = new Map<String, IPM_Milestone__c>();
            
            List<IPM_Milestone__c> msList = [Select Id, Name, IPM_Name__c, IPM_Phase__c, IPM_Project__c from IPM_Milestone__c WHERE IPM_Project__c =: project.Id AND IPM_Type_of_Milestone__c =: IPM_ConstantUtils.STANDARD];
            
            System.assertEquals(!msList.isEmpty(),true, 'Milstone records not visible to global leader user');
            
            for(IPM_Milestone__c msObj : msList){
                ipmMilestoneMap.put(msObj.Name, msObj);
            }
            
            milestone = new IPM_Milestone__c();
            milestone.IPM_Name__c ='';
            milestone.IPM_Project__c = project.Id;
            insert milestone;
            list<IPM_Milestone__c> listmilestone =new list<IPM_Milestone__c>();
            listmilestone.add(milestone);
            
            IPM_Milestone milestoneCtrlnew = new IPM_Milestone(new ApexPages.StandardController(milestone));
            milestoneCtrlnew.validateMilestone();
            milestoneCtrlnew.upsertMilestones(listmilestone);
            
            
            IPM_Milestone__c miniMilestone= new IPM_Milestone__c();
            miniMilestone.RecordTypeId = mileStoneRecordType;
            miniMilestone.name = 'Test-Milestone-6';
            miniMilestone.IPM_Due_Date__c = system.today().adddays(-2);
            miniMilestone.IPM_Type_of_Milestone__c = IPM_ConstantUtils.MINI;
            miniMilestone.IPM_Milestone__c = msList[1].id;
            miniMilestone.IPM_Name__c = IPM_Utils.ContractGateApproval;
            miniMilestone.IPM_Phase__c = IPM_ConstantUtils.PHASE_CAPABILITY;
            miniMilestone.IPM_Project_Type__c = 'Original';
            miniMilestone.ExternalField__c = 'gfgfg';
            miniMilestone.IPM_Project__c = project.Id;
            insert miniMilestone;
            
            
            mile = new IPM_Milestone__c();
            mile.IPM_Phase__c =IPM_ConstantUtils.PHASE_IDEAS;
            mile.IPM_Name__c =IPM_Utils.MarketReadyGateApproval; 
            mile.IPM_Due_Date__c =null;
            mile.IPM_Project__c = project.Id;
            insert mile;
            IPM_Milestone milestoneCtrlnew1 = new IPM_Milestone(new ApexPages.StandardController(mile));
            milestoneCtrlnew1.validateMilestone();
                        
            IPM_Milestone__c mile1 = new IPM_Milestone__c();
            mile1.IPM_Phase__c = null;
            mile1.IPM_Name__c = IPM_Utils.MarketReadyGateApproval; 
            mile1.IPM_Due_Date__c = system.today();
            mile1.IPM_Project__c = project.Id;
            insert mile1;
            IPM_Milestone milestoneCtrlnew2 = new IPM_Milestone(new ApexPages.StandardController(mile1));
            milestoneCtrlnew2.validateMilestone();
            
            apexpages.currentpage().getparameters().put(PROJECTID_STRING,project.id);
            
            Test.setCurrentPageReference(Page.IPM_AddMileStone);
            apexpages.currentpage().getparameters().put(PROJECTID_STRING,project.id);
    
            IPM_Milestone__c miles = new IPM_Milestone__c();
            miles.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
            miles.IPM_Name__c = IPM_Utils.MarketReadyGateApproval;
            miles.IPM_Due_Date__c = system.today();
            miles.IPM_Type_of_Milestone__c = null;
            //miles.IPM_Project__c = project.Id;
            //insert miles;
            
            IPM_Milestone milestoneCtrl1new = new IPM_Milestone(new ApexPages.StandardController(miles));
            milestoneCtrl1new.saveMilestones();
            
            apexpages.currentpage().getparameters().put(PROJECTID_STRING,project.id);
            apexpages.currentpage().getparameters().put('taskId',miniMilestone.id);
            IPM_Milestone milestoneCtrlvalidate = new IPM_Milestone(new ApexPages.StandardController(miniMilestone));
            System.Assertequals(milestoneCtrlvalidate.validateMilestone() ,true,'Milestone Validation Failed');
            milestoneCtrlvalidate.saveMilestoneAndTasks();
            
            apexpages.currentpage().getparameters().put('taskId',msList[2].id);
            IPM_Milestone milestoneCtrlvalidate1 = new IPM_Milestone(new ApexPages.StandardController(msList[2]));
            milestoneCtrlvalidate1.validateMilestone();
            System.Assertequals(milestoneCtrlvalidate1.validateMilestone(), false, 'Milestone Validation Error');
            
            
            IPM_Milestone__c adhocMilestone = new IPM_Milestone__c();
            adhocMilestone.RecordTypeId = mileStoneRecordType;
            adhocMilestone.name = 'Test-Adhoc-Milestone-6';
            adhocMilestone.IPM_Due_Date__c = system.today().adddays(-2);
            adhocMilestone.IPM_Type_of_Milestone__c = IPM_ConstantUtils.Adhoc;
            adhocMilestone.IPM_Milestone__c = msList[1].id;
            adhocMilestone.IPM_Name__c = IPM_Utils.ContractGateApproval;
            adhocMilestone.IPM_Phase__c = IPM_ConstantUtils.PHASE_CAPABILITY;
            adhocMilestone.IPM_Project_Type__c = 'Original';
            adhocMilestone.ExternalField__c = 'gfgfgas';
            adhocMilestone.IPM_Project__c = project.Id;
            insert adhocMilestone;
            apexpages.currentpage().getparameters().put(PROJECTID_STRING,project.id);
            apexpages.currentpage().getparameters().put('taskId',adhocMilestone.id);
            IPM_Milestone adhocMilestoneCtrlvalidate = new IPM_Milestone(new ApexPages.StandardController(adhocMilestone));
            System.Assertequals(adhocMilestoneCtrlvalidate.validateMilestone() ,true,'Milestone Validation Failed');
            
        }  
        
        Test.stopTest();
    }
}