/******************************************** 
*@Author:Cognizant
*@Date:01/02/2015
*@Description : Test class for IPM_ProjectOverviewCtrl class functionalities

Sonar issue : (Sonar issue : (The type has an NCSS line count of 800 and Avoid really long classes.)
Comment :This class is testing the IPM_ProjectOverviewCtrl class. Some logic is alredy moved to IPM_ProjectOverviewCtrol_Test class 
to avoid the "The type has an NCSS line count of 800" and "Avoid really long classes." sonar issues. 
But as the most of the test data is created in this test class , we cant reduce the class size more than this.
*/

@isTest(SeeAllData=false)
public class IPM_ProjectOverviewCtrl_Test
  { 
   private static IPM_Project__c project;
    private static IPM_Project_Document__c projDoc;
    private static List<IPM_Project_Document_Section__c> projDocSecList ;
    private static List<IPM_Project_Document_Section__c> projDocSecList1;
    private static IPM_Document_Template__c ipdt;
    private static IPM_Project_Template__c projTempl;
    private static list<IPM_Section__c> secMstList;
    private static List<IPM_Task__c> tskList;
    private static IPM_Milestone__c mile;
    private static String sPageRefURL = 'apex/IPM_ProjectOverview?Id=';
    private static String BET_ERROR_MSG = 'BET alert is not as expected';
    private static User platformUser;
    private static User stdUserForBET;// Variable has been used in betdatainitializer  method
    
    final Static String Feasibility  = IPM_ConstantUtils.PHASE_FEASIBILITY;
    final Static String ROLLOUT_PROJECT_TYPE =IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
    final Static String RCLT =  IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
    final Static String Local =  IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
    final Static String MarketReady =  IPM_ConstantUtils.PHASE_MARKET_READY;
    final Static String GlobalCompanyCard =  IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
    final Static String Completed =  IPM_ConstantUtils.JOB_STATUS_COMPLETED;
    final Static String Regional =  IPM_ConstantUtils.COMPANY_CARD_REGIONAL;
    final Static String MANAGER_ACCESS = IPM_ConstantUtils.BET_MANAGER_ACCESS;
    final Static String IDEAS_PHASE= IPM_ConstantUtils.PHASE_IDEAS;
    final Static String ORIGINAL_PROJECT_TYPE= IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL ;
    
    static void initializedData()
    { 
        String sProjectName = 'TestGate'; 
        //Create Project Template
        projTempl = IPM_TestFactory_Helper.createIPMProjectTemplate(true);
        
        //Create Document Template
        ipdt = IPM_TestFactory_Helper.creteIPMDocumentTemplate(false);
        ipdt.IPM_Project_Template__c=projTempl.ID;
        ipdt.IPM_Document_Template_Name__c='Charter Full 1';
        ipdt.IPM_Document_Order__c=10;
        
        insert ipdt;
        
        //Create IPM Section
        secMstList =  new list<IPM_Section__c>();
        for(Integer i=0 ; i<20 ; i++ ){
            IPM_Section__c secMst =  new IPM_Section__c ();
            secMst = IPM_TestFactory_Helper.createIPMSection(false);
            secMst.IPM_Document_Template__c = ipdt.ID;
            secMst.IPM_Section_Name__c = IDEAS_PHASE +i;
            secMstList.add(secMst);
        }
        insert secMstList;
        List<IPM_Section__c>sectionList=[SELECT ID FROM IPM_Section__c LIMIT 20];
        System.assertEquals(sectionList.size(), 20, 'section records created');
        
        //Create IPM Project
        project=IPM_TestFactory_Helper.createIPMProject(false);
        project.Name=sProjectName;
        project.Sustainability_Period__c=IPM_ConstantUtils.YEAR_3;
        project.IPM_Target_Launch_Dates__c=system.today();
        project.IPM_IsCompleted__c=true; 
        project.IPM_Project_Name__c = sProjectName+System.now();
        project.IPM_Project_Leader__c=userinfo.getuserid();
        project.IPM_Project_Type__c = 'Original';
        project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
        project.IPM_CompanyCardText__c = 'Global Company Card';
        project.IPM_Fast_Track_Project__c = true;
        project.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
        project.IPM_Temporary_Phase__c=IDEAS_PHASE;
        project.IPM_Phase__c='Ideas';
        project.IPM_Brand_Positioning__c='Dirt Is Good';
        project.IPM_ProjectSubType__c='Innovation/Rennovation';
        project.IPM_Category_Text__c='Household Care';
        insert project;
        List<IPM_Project__c>projectLists=[SELECT IPM_Project_Leader__c FROM IPM_Project__c WHERE ID=:project.ID LIMIT 1];
        System.assertEquals(projectLists[0].IPM_Project_Leader__c, userinfo.getuserid(), 'project leader is:'+projectLists[0].IPM_Project_Leader__c);
        //Create Project Document
        projDoc = IPM_TestFactory_Helper.createIPMProjectDocument(false);
        projDoc.IPM_Project__c=project.ID;
        projDoc.IPM_Document_Status__c=IPM_ConstantUtils.STATUS_NOT_STARTED;
        projDoc.External_Id__c = project.ID + IPM_ConstantUtils.CHARTER_GATE;
        projDoc.IPM_Project_Document_External_Id__c = project.ID + IPM_ConstantUtils.CHARTER_GATE;
        projDoc.IPM_Document_Order__c = 10;
        insert projDoc;     
        
        projDocSecList =  new List<IPM_Project_Document_Section__c>();
        //Create Project Document Section
        for(Integer i=0 ; i<20 ; i++ ){
            IPM_Project_Document_Section__c projDocSec = new IPM_Project_Document_Section__c();
            projDocSec = IPM_TestFactory_Helper.createIPMProjectDocumentSection(false);
            projDocSec.IPM_Project_Document__c=projDoc.ID;
            projDocSec.IPM_Section__c=secMstList[i].Id;
            projDocSec.IPM_Gate_Document_Summary__c='dgadsg&sdfgfdhsfgasdfasdfasdafasdfasdff';
            projDocSec.IPM_Section_Name__c='Section Name'+i;
            projDocSec.IPM_FunctionalRole__c='PL';
            projDocSec.IPM_Negotiable__c=false;
            projDocSec.IPM_Section_Status__c=IPM_ConstantUtils.STATUS_NOT_FILLED;
            projDocSec.Project_Doc_Section_Ext_Id__c = String.valueOf(project.ID) + String.valueOf(projDoc.Id) + IPM_ConstantUtils.CHARTER_GATE + String.valueOf(i);
            projDocSecList.add(projDocSec);
            
        }
        insert projDocSecList;  
        
        IPM_ProjectOverviewCtrl overCtrl=new IPM_ProjectOverviewCtrl();
        overCtrl.lstalertMessage=IPM_ConstantUtils.BLANK;
        overCtrl.gateDateAlert=IPM_ConstantUtils.BLANK;
        overCtrl.dueDateMsg=false;
        overCtrl.dueDateMsgToday=false;
        overCtrl.dueDateMsgPast=false;
        overCtrl.ProName=IPM_ConstantUtils.BLANK;
        overCtrl.gateName=IPM_ConstantUtils.BLANK;
        overCtrl.gateDueDateMessage=IPM_ConstantUtils.BLANK;
        overCtrl.remainingDays=3;
        overCtrl.Taskeditable=false;
        overCtrl.regionalORlocalBusinessImpactStr=IPM_ConstantUtils.BLANK;
        overCtrl.projectDocStatusStyleClass=IPM_ConstantUtils.BLANK;
        overCtrl.childProjectsIncompleteAlert=IPM_ConstantUtils.BLANK;
        overCtrl.ecoDesignAlert=IPM_ConstantUtils.BLANK;
        overCtrl.ecoDesignSecId=IPM_ConstantUtils.BLANK;
        overCtrl.hasNext=false;
        overCtrl.hasPrevious=false;
        
        projDocSecList1 =  new List<IPM_Project_Document_Section__c>();
        for(Integer i=0 ; i<20 ; i++ ){
            IPM_Project_Document_Section__c projDocSec1 = new IPM_Project_Document_Section__c();
            projDocSec1 = IPM_TestFactory_Helper.createIPMProjectDocumentSection(false);
            projDocSec1.IPM_Project_Document__c=projDoc.ID;
            projDocSec1.IPM_Section__c=secMstList[i].Id;
            projDocSec1.IPM_Gate_Document_Summary__c='dgadsg&sdfgfdhsfgasdfasdfasdafasdfasdff';
            projDocSec1.IPM_Section_Name__c='Section Name'+i;
            projDocSec1.IPM_FunctionalRole__c='PL';
            projDocSec1.IPM_Negotiable__c=false;
            projDocSec1.IPM_Section_Status__c=IPM_ConstantUtils.STATUS_NOT_STARTED;
            projDocSec1.Project_Doc_Section_Ext_Id__c = String.valueOf(project.ID) + String.valueOf(projDoc.Id) + IPM_ConstantUtils.CHARTER_GATE + String.valueOf(i+20);
            projDocSecList1.add(projDocSec1);
        }
        insert projDocSecList1;  
        
        //Create Task
        tskList =  new List<IPM_Task__c> ();
        for(Integer i=0 ; i<20 ; i++ ){
            IPM_Task__c tsk = new IPM_Task__c();
            tsk = IPM_TestFactory_Helper.createIPMTask(project.Id, false);
            tsk.IPM_Project_Document_Section__c=projDocSecList[i].Id;
            tsk.IPM_Completed__c=false;
            tsk.IPM_Task_Name__c='New task'+i;
            tsk.IPM_Project__c = project.id;
            tsk.IPM_Assignee__c = UserInfo.getUserId();
            tsk.IPM_Active__c=TRUE;
            //tsk.IPM_Phase__c = project.IPM_Phase__c;
            tsk.ExternalField__c = project.Id +  IDEAS_PHASE + IPM_ConstantUtils.COMPLEXITY_LITE + 'New task'+ String.valueOf(i);
            tskList.add(tsk);
        }
        insert tskList;
        
        //Create Milestone
        mile = IPM_TestFactory_Helper.createIPMMilestone(project.Id, false);
        mile.IPM_Phase__c=IDEAS_PHASE;
        mile.IPM_Type_of_gate__c=IPM_ConstantUtils.CHARTER_GATE;
        mile.IPM_No_Of_Days_for_Developing__c = '10';
        mile.IPM_No_Of_Days_for_Developing_Emerging__c = '10';
        mile.IPM_Project__c = project.id;
        mile.IPM_Type_of_Milestone__c = IPM_ConstantUtils.STANDARD;
        mile.ExternalField__c = project.id + IPM_ConstantUtils.CHARTER_GATE + IDEAS_PHASE + ORIGINAL_PROJECT_TYPE;
        insert mile;
 }
 
 @testSetup static void betDataInitializer(){

        Test.StartTest();
        
        test.loadData(IPM_Project_Type__c.sobjectType, 'IPM_ProjectType');//
        test.loadData(IPM_BET_Search_Fields__c.sobjectType, 'IPM_BET_Search_Test');//
        test.loadData(IPM_ProjectMetadata__c.sobjectType, 'IPM_Project_Metadata');//

        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // User has to be created as a  system admin 
            stdUserForBET= IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
        } 
        
        // creating BET's for  projects
        uw_BET__c bet1 = BET_TestUtils.getTestBet();
        bet1.name ='bet1';
        
        
        uw_BET__c bet2 = BET_TestUtils.getTestBet();
        bet2.name ='bet2';
        
        
        insert new List<uw_BET__c>{bet1,bet2  } ;
        
        System.Assert(bet1.Id != null, 'The BET record not inserted');
        System.Assert(bet2.Id != null, 'The BET record not inserted');
        
        List<IPM_Project__c>  orgProjList = (IPM_TestFactory_Helper.createOriginalProjectList(false,2));
        
        System.runAs(stdUserForBET)
        {
            orgProjList[1].IPM_Project_Name__c = 'TestPrjOrg';
            orgProjList[1].IPM_Phase__c = IDEAS_PHASE;
            orgProjList[1].IPM_Project_Type__c= ORIGINAL_PROJECT_TYPE;
            insert  orgProjList;
            
        }
        
        list < BET_BETWrapper.MemberRequest > lstMemberRequests = new list < BET_BETWrapper.MemberRequest > ();
        
        BET_BETWrapper.MemberRequest member = new BET_BETWrapper.MemberRequest();
        member.UserId = stdUserForBET.Id;
        member.AccessLevel = MANAGER_ACCESS;
        lstMemberRequests.add(member);
        BET_AccessService.RequestAccess(lstMemberRequests, bet1.Id, orgProjList[0].id);
        BET_AccessService.RequestAccess(lstMemberRequests, bet2.Id, orgProjList[0].id);
        
        
        System.runAs(stdUserForBET)
        {
            list<IPM_Project__c> projectList=IPM_TestFactory_Helper.createIPMProjectList(false,2);
            
            projectList[0].IPM_Phase__c = IDEAS_PHASE;
            projectList[0].IPM_Parent_Project__c = orgProjList[1].id;
            projectList[0].IPM_Project_Type__c = ROLLOUT_PROJECT_TYPE; 
            projectList[0].IPM_Project_Leader__c = UserInfo.getUserId();
            projectList[0].IPM_Project_Name__c = 'TestPrj1';
            projectList[0].IPM_GateKeeping_Model__c = RCLT;
            projectList[0].IPMProject_Span__c = Regional;
            projectList[0].IPM_CompanyCardText__c = GlobalCompanyCard;
            projectList[0].IPM_Project_Leader__c = UserInfo.getuserId();
            
            projectList[1].IPM_Phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
            projectList[1].IPM_Parent_Project__c = orgProjList[1].id;
            projectList[1].IPM_Project_Type__c = ROLLOUT_PROJECT_TYPE;
            projectList[1].IPM_Project_Leader__c = UserInfo.getUserId();
            projectList[1].IPM_Project_Name__c = 'TestPrj2';
            projectList[1].IPM_GateKeeping_Model__c = RCLT;
            projectList[1].IPMProject_Span__c = Local;
            projectList[1].IPM_CompanyCardText__c = GlobalCompanyCard;
            projectList[1].IPM_Project_Job_Status__c = Completed;
            projectList[1].IPM_Target_Launch_Dates__c = Date.Today();
            
            insert projectList;
            
            IPM_Project_Resource__c bdUser = IPM_TestFactory_Helper.createIPMProjectResource(orgProjList[1].id,false);
            bdUser.IPM_Role_Type__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_BD;
            bdUser.IPM_Project__c = orgProjList[1].id;
            bdUser.IPM_User__c = UserInfo.getUserId();
            insert bdUser;
            
            Test.stopTest(); 
                   
          }
    }

 
   
    //This testmethod will cover positive scenario for Project Overview screen
    static testMethod void overControl()
    {
        IPM_Milestone__c gProjectMilestone1;
        //Creation test user
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
        
        system.runAs(platformUser)
        {
        initializedData();
        project.Deputy_Project_Leader__c = UserInfo.getUserId(); 
        projDoc.IPM_Document_Status__c='In Progress';
        update projDoc;
        
        projDoc.IPM_Document_Status__c=IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS;
        update projDoc;
        
        for(Integer i=0 ; i<20 ; i++ ){
            projDocSecList[i].IPM_Gate_Document_Summary__c='dgasdfdaddsg&sdfgfdhsfgasdfasdfasdafasdfasdff';
            projDocSecList[i].IPM_FunctionalRole__c='CMI';
            projDocSecList[i].IPM_Section_Name__c='Nameeeeee'+i;
        }
        update projDocSecList;
        
        for(Integer i=0 ; i<20 ; i++ ){
            tskList[i].IPM_Task_Name__c='Task Name'+i;
        }
        update tskList;
        
        
        //Create milestone for Global project
        gProjectMilestone1 = IPM_TestFactory_Helper.createIPMMilestone(project.Id, false);
        gProjectMilestone1.IPM_Phase__c=IDEAS_PHASE;
        gProjectMilestone1.IPM_Type_of_gate__c=IPM_ConstantUtils.CHARTER_GATE;
        gProjectMilestone1.IPM_Type_of_Milestone__c = IPM_ConstantUtils.STANDARD;
        gProjectMilestone1.IPM_Due_Date__c = System.today() - 2;
        gProjectMilestone1.IPM_Completed_On__c = null;
        gProjectMilestone1.IPM_Project__c = project.id;
        insert gProjectMilestone1;
        System.assertEquals(gProjectMilestone1.IPM_Type_of_gate__c,IPM_ConstantUtils.CHARTER_GATE);
        
        List<IPM_Milestone__c> ipmMileStoneList = new List<IPM_Milestone__c>();
        
        IPM_Milestone__c betMilestoneFirstRelease = IPM_TestFactory_Helper.createIPMMilestone(project.Id, false);
        betMilestoneFirstRelease.IPM_Name__c = 'BETFirstRelease';    
        betMilestoneFirstRelease.IPM_Due_Date__c =  System.today()+5;
        betMilestoneFirstRelease.IPM_Planned_Date__c=System.today()+5 ;
        betMilestoneFirstRelease.IPM_Type_of_Milestone__c = IPM_ConstantUtils.BET;
        ipmMileStoneList.add(betMilestoneFirstRelease);
        
        IPM_Milestone__c betMilestoneFinalRelease = IPM_TestFactory_Helper.createIPMMilestone(project.Id, false);
        betMilestoneFinalRelease.IPM_Name__c = 'BETFinalRelease';    
        betMilestoneFinalRelease.IPM_Due_Date__c =  System.today()+5;
        betMilestoneFinalRelease.IPM_Planned_Date__c=System.today()+5 ;
        betMilestoneFinalRelease.IPM_Type_of_Milestone__c = IPM_ConstantUtils.BET;
        ipmMileStoneList.add(betMilestoneFinalRelease);
        
        insert ipmMileStoneList;
        
        Test.startTest();
        PageReference pRef1 = new PageReference(sPageRefURL+project.ID);
        Test.setCurrentPage(pRef1);
        IPM_ProjectOverviewCtrl overCtrl=new IPM_ProjectOverviewCtrl();
        overCtrl.taskId=tskList[0].Id;
        project.IPM_Fast_Track_Project__c = false;
        update project;
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
        overCtrl1.getTasks();
        System.assert(overCtrl1.project != NULL);
        Test.stopTest();
        }
    }
    
    //This testmethod will check if local rollout project with nearest upcoming milestone is not shown when regional project is in Feasibility state 
    static testMethod void testRolloutDetailSectionForRegionalFeasibilityProject(){
        //Creation test user
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
        
        system.runAs(platformUser)
        {
        Test.startTest();
         List<IPM_Project__c> rProjectList = new List<IPM_Project__c>();
         List<IPM_Project__c> lProjectList = new List<IPM_Project__c>();
         List<IPM_Milestone__c> rProjectMilestoneList1  = new List<IPM_Milestone__c>();
         initializedData();
         
         //Create regional project
         
        for(Integer i=0 ; i<20 ; i++ ){
            IPM_Project__c rProject = IPM_TestFactory_Helper.createIPMProject(false);
            rProject.Name='Regional Project'+i;
            rProject.IPM_Project_Leader__c=userinfo.getuserid();
            rProject.IPM_Fast_Track_Project__c = true;
            rProject.IPM_Parent_Project__c = project.id;
            rProject.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            rProject.IPM_Phase__c  =  IPM_ConstantUtils.PHASE_FEASIBILITY;
            rProject.IPM_Target_Launch_Dates__c = System.today() + 2;
            rProjectList.add(rProject);
        } 
        insert rProjectList;
        List<IPM_Project__c>projectLists=[SELECT id FROM IPM_Project__c LIMIT 20];
        System.assertEquals(projectLists.size(), 20, 'project records created');
       
       
        
        //Create local project
        for(Integer i=0 ; i<20 ; i++ ){
            IPM_Project__c lProject = IPM_TestFactory_Helper.createIPMProject(false);
            lProject.Name='Local Project'+i;
            lProject.IPM_Project_Leader__c=userinfo.getuserid();
            lProject.IPM_Fast_Track_Project__c = true;
            lProject.IPM_Parent_Project__c = rProjectList[i].id;
            lProject.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            lProject.IPM_Phase__c  =  IPM_ConstantUtils.PHASE_MARKET_READY;
            lProjectList.add(lProject);
        }
        insert lProjectList;
        
         
        //Create milestone for local project
        for(Integer i=0 ; i<20 ; i++ ){
            IPM_Milestone__c rProjectMilestone1 = IPM_TestFactory_Helper.createIPMMilestone(lProjectList[i].Id, false);
            rProjectMilestone1.IPM_Phase__c= IDEAS_PHASE;
            rProjectMilestone1.IPM_Type_of_gate__c=IPM_ConstantUtils.CHARTER_GATE;
            rProjectMilestone1.IPM_Due_Date__c = System.today() + 2;
            rProjectMilestone1.IPM_Completed_On__c = null;
            rProjectMilestone1.IPM_Project__c = project.id;
            rProjectMilestoneList1.add(rProjectMilestone1);
        }
        insert rProjectMilestoneList1;
        
        
        PageReference pRef1 = new PageReference(sPageRefURL+rProjectList[0].ID);
        Test.setCurrentPage(pRef1);
        
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
        //Assert if local rollout project with nearest upcoming milestone is not shown when regional project is in Feasibility state
        System.assertEquals(0, overCtrl1.rolloutProjectRecentMilestone.size(), 'local rollout project with nearest upcoming milestone is not shown');
        Test.stopTest();
        }
    } 
    
    //This testmethod will check if regional rollout project with nearest upcoming milestone is not shown when global project is in Idea state 
    static testMethod void testRolloutDetailSectionForGlobalIdeaProject(){
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
        
        system.runAs(platformUser)
        {
         List<IPM_Project__c> rProjectList = new List<IPM_Project__c>();
         List<IPM_Milestone__c> rProjectMilestoneList1 = new List<IPM_Milestone__c>();
         IPM_Milestone__c gProjectMilestone1;
         initializedData();
         
         //Create regional project
         for(Integer i=0 ; i<20 ; i++ ){
            IPM_Project__c rProject = IPM_TestFactory_Helper.createIPMProject(false);
            rProject.Name='RegionalProject1'+i;
            rProject.IPM_Project_Leader__c=userinfo.getuserid();
            rProject.IPM_Fast_Track_Project__c = true;
            rProject.IPM_Parent_Project__c = project.id;
            rProject.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            rProject.IPM_Phase__c  =  IPM_ConstantUtils.PHASE_FEASIBILITY;
            rProjectList.add(rProject);
        }
        insert rProjectList;
        
        //Create milestone for Global project
        gProjectMilestone1 = IPM_TestFactory_Helper.createIPMMilestone(project.Id, false);
        gProjectMilestone1.IPM_Phase__c=IDEAS_PHASE;
        gProjectMilestone1.IPM_Type_of_gate__c=IPM_ConstantUtils.CHARTER_GATE;
        gProjectMilestone1.IPM_Type_of_Milestone__c = IPM_ConstantUtils.STANDARD;
        gProjectMilestone1.IPM_Due_Date__c = System.today() + 2;
        gProjectMilestone1.IPM_Completed_On__c = null;
        gProjectMilestone1.IPM_Project__c = project.id;
        insert gProjectMilestone1;
        System.assertEquals(gProjectMilestone1.IPM_Type_of_gate__c,IPM_ConstantUtils.CHARTER_GATE, 'IPM_Type_of_gate__c Not Matched');
        
        //Create milestone for regional project
        for(Integer i=0 ; i<20 ; i++ ){
           IPM_Milestone__c  rProjectMilestone1 = IPM_TestFactory_Helper.createIPMMilestone(rProjectList[i].Id, false);
            rProjectMilestone1.IPM_Phase__c=IDEAS_PHASE;
            rProjectMilestone1.IPM_Type_of_gate__c=IPM_ConstantUtils.CHARTER_GATE;
            rProjectMilestone1.IPM_Due_Date__c = System.today() + 2;
            rProjectMilestone1.IPM_Completed_On__c = null;
            rProjectMilestone1.IPM_Project__c = project.id;
            rProjectMilestoneList1.add(rProjectMilestone1);
        }
        insert rProjectMilestoneList1;
        
        Test.startTest();
        PageReference pRef1 = new PageReference(sPageRefURL+project.ID);
        Test.setCurrentPage(pRef1);
        
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
        //Assert if regional rollout project with nearest upcoming milestone is not shown when global project is in Idea state 
        System.assertEquals(0, overCtrl1.rolloutProjectRecentMilestone.size(), 'regional rollout project with nearest upcoming milestone is not shown');
        Test.stopTest();
        }
    }
    
     //This testmethod will check if regional rollout project with nearest upcoming milestone is not shown to the logged-in user if not a team member
    static testMethod void testRolloutDetailSectionWhenLoggedUserNotInTeam(){
    platformUser =IPM_TestFactory_Helper.returnPlatformUser();
         
        system.runAs(platformUser)
        {
         List<IPM_Project__c> rProjectList =  new List<IPM_Project__c> ();
         List<IPM_Milestone__c> rProjectMilestoneList1 = new List<IPM_Milestone__c>();
         
         initializedData();
         
         User testUser = IPM_TestFactory_Helper.createUser(true);
         project.IPM_Project_Leader__c=testUser.Id;
         update project;
         
         //Create regional project
         for(Integer i=0 ; i<20 ; i++ ){
            IPM_Project__c rProject = IPM_TestFactory_Helper.createIPMProject(false);
            rProject.Name='RegionalProject2'+i;
            rProject.IPM_Project_Leader__c=userinfo.getuserid();
            rProject.IPM_Fast_Track_Project__c = true;
            rProject.IPM_Parent_Project__c = project.id;
            rProject.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            rProject.IPM_Phase__c  =  IPM_ConstantUtils.PHASE_FEASIBILITY;
            rProjectList.add(rProject);
         }
        insert rProjectList;
        
        Test.startTest();
        //Create milestone for regional project
        for(Integer i=0 ; i<20 ; i++ ){
            IPM_Milestone__c rProjectMilestone1 = IPM_TestFactory_Helper.createIPMMilestone(rProjectList[i].Id, false);
            rProjectMilestone1.IPM_Phase__c=IDEAS_PHASE;
            rProjectMilestone1.IPM_Type_of_gate__c=IPM_ConstantUtils.CHARTER_GATE;
            rProjectMilestone1.IPM_Due_Date__c = System.today() + 2;
            rProjectMilestone1.IPM_Completed_On__c = null;
            rProjectMilestone1.IPM_Project__c = project.id;
            rProjectMilestoneList1.add(rProjectMilestone1);
        }
        insert rProjectMilestoneList1;
        
        PageReference pRef1 = new PageReference(sPageRefURL+project.ID);
        Test.setCurrentPage(pRef1);
        
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
        System.assertEquals(null, overCtrl1.rolloutProjectRecentMilestone, 'rolloutProjectRecentMilestone Is Not Matched');
        Test.stopTest();
        }
    }
    
    //Testmethod to validate moveToPLE functionality
    static testMethod void testmoveToPLE(){
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
         
        system.runAs(platformUser)
        {
        initializedData();
        Test.startTest();
        PageReference pRef1 = new PageReference(sPageRefURL+project.ID);
        Test.setCurrentPage(pRef1);
        
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
        overCtrl1.moveToPLE();
        project = [Select Id, IPM_Actual_Launch_Date__c from IPM_Project__c where Id =: project.Id];
        System.assertEquals(Date.today(), project.IPM_Actual_Launch_Date__c, 'Launch Date Is Wrong');
        Test.stopTest();
        }
    }
    
    //Testmethod to validate markComplete functionality
    static testMethod void testmarkComplete(){
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
         
        system.runAs(platformUser)
        {
        initializedData();
        Test.startTest();
        PageReference pRef1 = new PageReference(sPageRefURL+project.ID);
        Test.setCurrentPage(pRef1);
        
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
        overCtrl1.taskId = tskList[0].Id;
        overCtrl1.markComplete();
        System.assertEquals(false, tskList[0].IPM_Completed__c, 'IPM_Completed__c Is Completed' );
        Test.stopTest();
        }
    }
    
    //testmethod to valiate financials data
    static testMethod void testFinancials(){
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
         
        system.runAs(platformUser)
        {
        initializedData();
        
        //Create Financial
        IPM_Financial__c testIPMFinancialConsolidated = IPM_TestFactory_Helper.createIPMFinancial(false);
        testIPMFinancialConsolidated.Parent_Project__c = project.Id;
        testIPMFinancialConsolidated.Financial_External_ID__c = project.Id + String.valueOf(System.now());
        testIPMFinancialConsolidated.Project_Sustainability_Period__c = IPM_ConstantUtils.YEAR_3;
        insert testIPMFinancialConsolidated;
        List<IPM_Financial__c>financialLists=[SELECT Parent_Project__c FROM IPM_Financial__c WHERE ID=:testIPMFinancialConsolidated.ID LIMIT 1];
        System.assertEquals(financialLists[0].Parent_Project__c, project.Id, 'parent project is:'+financialLists[0].Parent_Project__c);
       
        //Create Financial Year
        IPM_Financial_Year__c testFinancialYear = IPM_TestFactory_Helper.createIPMFinancialYear(false);
        testFinancialYear.Year__c = IPM_ConstantUtils.YEAR_3;
        testFinancialYear.Year_Type__c = 'Calendar';
        testFinancialYear.PL_Type__c = 'Incremental';
        testFinancialYear.Turnover_Global__c = 200.00;
        testFinancialYear.IPM_Financial__c = testIPMFinancialConsolidated.Id;
        insert testFinancialYear;
        Test.startTest();
        PageReference pRef1 = new PageReference(sPageRefURL+project.ID);
        Test.setCurrentPage(pRef1);
        
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
        testIPMFinancialConsolidated = [Select Id, Business_Impact_Global__c from IPM_Financial__c where Id =: testIPMFinancialConsolidated.Id];
        System.assertEquals(testIPMFinancialConsolidated.Business_Impact_Global__c, overCtrl1.globalbusinessImpactStr);
        Test.stopTest();
        }
    }
     
    //This testmethod will check for alert for Regional-Local financial and TLD alignments
   static testMethod void testAlertForRegionalLocalFinancialTLDAligned(){
        
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
         
        system.runAs(platformUser)
        {
         list<IPM_Project__c> rProjectList = new list<IPM_Project__c>();
         list<IPM_Project__c> lProjectList =  new list<IPM_Project__c>();
         initializedData();
         
         //Create regional project
         for(Integer i=0 ; i<20 ; i++ ){
            IPM_Project__c rProject = IPM_TestFactory_Helper.createIPMProject(false);
            rProject.Name='Regional Project3'+i;
            rProject.IPM_Project_Leader__c=userinfo.getuserid();
            rProject.IPM_Fast_Track_Project__c = true;
            rProject.IPM_Parent_Project__c = project.id;
            rProject.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            rProject.IPM_Phase__c  =  IPM_ConstantUtils.PHASE_FEASIBILITY;
            rProject.IPM_Target_Launch_Dates__c = System.today() + 360;
            rProjectList.add(rProject);
         }
        insert rProjectList;
        List<IPM_Project__c>projectLists=[SELECT id FROM IPM_Project__c LIMIT 20];
        System.assertEquals(projectLists.size(), 20, 'Regional project records created');
        //Create local project
        for(Integer i=0 ; i<20 ; i++ ){
            IPM_Project__c lProject = IPM_TestFactory_Helper.createIPMProject(false);
            lProject.Name='LocalProject1'+i;
            lProject.IPM_Project_Leader__c=userinfo.getuserid();
            lProject.IPM_Fast_Track_Project__c = true;
            lProject.IPM_Parent_Project__c = rProjectList[i].id;
            lProject.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            lProject.IPM_Phase__c  =  IPM_ConstantUtils.PHASE_MARKET_READY;
            lProject.IPM_Target_Launch_Dates__c = System.today() + 360;
            lProjectList.add(lProject);
        }
        insert lProjectList;
        
        Id  financeMasterRecordType = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId();
        IPM_Financial__c testIPMFinancialConsolidated = IPM_TestFactory_Helper.createIPMFinancial(false);
        testIPMFinancialConsolidated.Parent_Project__c = project.Id;
        testIPMFinancialConsolidated.Financial_External_ID__c = rProjectList[0].Id + String.valueOf(System.now());
        testIPMFinancialConsolidated.Project_Sustainability_Period__c = '3';
        testIPMFinancialConsolidated.Regional_Project__c =rProjectList[0].Id;
        testIPMFinancialConsolidated.RecordTypeId = financeMasterRecordType;
        testIPMFinancialConsolidated.Local_Project__c= lProjectList[0].id;
        insert testIPMFinancialConsolidated;  
        System.assertEquals(1, [Select count() from IPM_Financial__c where id =: testIPMFinancialConsolidated.id]);
       
        //Create Financial Year
        IPM_Financial_Year__c testFinancialYear = IPM_TestFactory_Helper.createIPMFinancialYear(false);
        testFinancialYear.IPM_Financial__c = testIPMFinancialConsolidated.Id;
        testFinancialYear.Gross_Profit_Regional__c = 0;
        insert testFinancialYear;
        System.assertEquals(1, [Select count() from IPM_Financial_Year__c where id =: testFinancialYear.id],'Financial Year is created');
        
        
        Test.startTest();
        PageReference pRef1 = new PageReference(sPageRefURL+rProjectList[0].ID);
        Test.setCurrentPage(pRef1);
        
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
        System.assertEquals(0, overCtrl1.lstFinTLDAlertMessage.size());
        Test.stopTest();
       }
    }
    
     //This testmethod will check for alert for Regional-Local financial and TLD misalignments
   static testMethod void testAlertForRegionalLocalFinancialTLDMisAligned(){
    platformUser =IPM_TestFactory_Helper.returnPlatformUser();
         
        system.runAs(platformUser)
        {
        Test.startTest();
        
         list<IPM_Project__c> rProjectList =  new list<IPM_Project__c>();
         list<IPM_Project__c> lProjectList = new list<IPM_Project__c>() ;
         list<IPM_Financial__c> financialList =  new list<IPM_Financial__c>();
         initializedData();
         
         //Create regional project
         for(Integer i=0 ; i<20 ; i++ ){
            IPM_Project__c rProject = IPM_TestFactory_Helper.createIPMProject(false);
            rProject.Name='RegionalProject6'+i;
            rProject.IPM_Project_Leader__c=userinfo.getuserid();
            rProject.IPM_Fast_Track_Project__c = true;
            rProject.IPM_Parent_Project__c = project.id;
            rProject.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            rProject.IPM_Project_Type__c =  ROLLOUT_PROJECT_TYPE;
            rProject.IPM_Phase__c  =  IPM_ConstantUtils.PHASE_FEASIBILITY;
            rProject.IPM_Target_Launch_Dates__c = System.today() + 360;
            rProjectList.add(rProject);
         }
        insert rProjectList;
        
        
        
        //Create local project
        for(Integer i=0 ; i<20 ; i++ ){
            IPM_Project__c lProject = IPM_TestFactory_Helper.createIPMProject(false);
            lProject.Name='LocalProject2'+i;
            lProject.IPM_Project_Leader__c=userinfo.getuserid();
            lProject.IPM_Fast_Track_Project__c = true;
            lProject.IPM_Parent_Project__c = rProjectList[i].id;
            lProject.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            lProject.IPM_Project_Type__c =  ROLLOUT_PROJECT_TYPE;
            lProject.IPM_Phase__c  =  IPM_ConstantUtils.PHASE_MARKET_READY;
            lProject.IPM_Target_Launch_Dates__c = System.today() + 300;
            lProject.Rollout_Plan_Target_Launch_Date__c = System.today() + 305;
            lProjectList.add(lProject);
        }
        insert lProjectList;
        List<IPM_Project__c>projectLists=[SELECT id FROM IPM_Project__c LIMIT 20];
        System.assertEquals(projectLists.size(), 20, 'Local project records created');
        
        IPM_Project_Rollout__c rollout = IPM_TestFactory_Helper.createIPMProjectRollout(false);
        rollout.Local_Project__c= lProjectList[0].id;
        rollout.RecordTypeId = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId();
        rollout.Regional_Project__c =  rProjectList[0].id;
        rollout.IPM_Regional_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_FOLLOWER ;
        rollout.IPM_Status__c = IPM_ConstantUtils.ROLLOUT_FOLLOWER ;
        rollout.Target_Launch_Date__c = system.today() + 40;
        insert rollout;
        System.assertEquals(1, [Select count() from IPM_Project_Rollout__c where id =: rollout.id],'Rollout is created');
        
        
        //Create Local Financial
        for(Integer i=0 ; i<20 ; i++ ){
            IPM_Financial__c testIPMFinancialLocal = IPM_TestFactory_Helper.createIPMFinancial(false);
            testIPMFinancialLocal.Parent_Project__c = project.Id;
            testIPMFinancialLocal.Regional_Project__c = rProjectList[i].Id;
            testIPMFinancialLocal.Local_Project__c = lProjectList[i].Id;
            testIPMFinancialLocal.Volume_Unit_Regional__c = 'Test123'+i;
            testIPMFinancialLocal.Volume_Unit_Local__c = 'Test456'+i;
            testIPMFinancialLocal.Misaligned_Date__c = System.today() - 3;
            testIPMFinancialLocal.Financial_External_ID__c = project.Id + String.valueOf(i);
            testIPMFinancialLocal.Project_Sustainability_Period__c = '3';
            financialList.add(testIPMFinancialLocal);
        }
        insert financialList;
        
        
        PageReference pRef1 = new PageReference(sPageRefURL+rProjectList[0].ID);
        Test.setCurrentPage(pRef1);
        
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
        System.assert(overCtrl1.lstFinTLDAlertMessage.size() > 0);
        Test.stopTest();
        }
    }
    
    //This testmethod will verify alert for stopped projects
    static testMethod void testStoppedProjectAlert(){
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
         
        system.runAs(platformUser)
        {
         initializedData();
         project.Is_Archieved__c = true;
         update project;
         Test.startTest();
         PageReference pRef1 = new PageReference(sPageRefURL+project.ID);
         Test.setCurrentPage(pRef1);
        
         IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
         IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
         System.assert(overCtrl1.stoppedMsg != NULL);
         Test.stopTest();
        }
    }
    
         // Test method for BET messages  in Ideas phase
    static testMethod void testLinkBETMessagesIdeasPhase(){
        
        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        
        IPM_Project__c ipmProj=[Select id,BET_Link_Requested__c ,IPM_BET_Toolkit__c  from  IPM_Project__c  where IPM_Project_Name__c = 'TestPrjOrg'];
        
        uw_BET__c bet1=[select id , Launch_Date__c, name from uw_BET__c where name='bet1'];
        
        System.runAs(testRunningUser ){
            
            Test.StartTest();
            
            ipmProj.ipm_phase__c = IDEAS_PHASE;
            ipmProj.BET_Link_Requested__c = bet1.id;
            ipmProj.IPM_BET_Toolkit__c = IPM_ConstantUtils.LINK_EXISTING_BET;
            ipmProj.IPM_Project_Leader__c=UserInfo.getUserId();
            update ipmProj;
            
            PageReference pRef = new PageReference(sPageRefURL+ipmProj.ID);
            Test.setCurrentPage(pRef);
            IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
            IPM_ProjectOverviewCtrl overCtrl=new IPM_ProjectOverviewCtrl(hstryControl);
            
            system.assertEquals(bet1.id,overCtrl.requestedBETId,'Requested BET not updated as expected');
            
            ipmProj.BET_Link_Requested__c = null;
            ipmProj.IPM_BET_Toolkit__c = IPM_ConstantUtils.NO_BET ;
            update ipmProj;
            
            PageReference pRef1 = new PageReference(sPageRefURL+ipmProj.ID);
            Test.setCurrentPage(pRef1);
            IPM_ProjDocumentSectionHstryController hstryControl1=new IPM_ProjDocumentSectionHstryController();
            IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl1);
            
            system.assertEquals(System.label.IPM_NoBETMsgPL,overCtrl1.betInformationMessage,BET_ERROR_MSG);

            ipmProj.IPM_BET_Toolkit__c = IPM_ConstantUtils.CREATE_NEW_BET ;
            update ipmProj;
            
            PageReference pRef2 = new PageReference(sPageRefURL+ipmProj.ID);
            Test.setCurrentPage(pRef2);
            IPM_ProjDocumentSectionHstryController hstryControl2=new IPM_ProjDocumentSectionHstryController();
            IPM_ProjectOverviewCtrl overCtrl2=new IPM_ProjectOverviewCtrl(hstryControl2);
            
            system.assertEquals(System.label.IPM_NewBETMessage,overCtrl2.betInformationMessage,BET_ERROR_MSG);
            
            Test.StopTest();
        
        }
        
    }

// Test method for BET messages  in different scenarios
    static testMethod void testCreateBETMessagesOtherPhases(){

        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];

        IPM_Project__c ipmProj=[Select id,BET_Link_Requested__c ,IPM_BET_Toolkit__c  from  IPM_Project__c  where IPM_Project_Name__c = 'TestPrjOrg'];
        
        IPM_Project__c ipmRoutProj=[Select id,BET_Link_Requested__c ,IPM_BET_Toolkit__c  from  IPM_Project__c  where IPM_Project_Name__c = 'TestPrj2'];
        
        System.runAs(testRunningUser ){
            
            Test.startTest();
            
            ipmProj.IPM_BET_Toolkit__c = IPM_ConstantUtils.CREATE_NEW_BET ;
            ipmProj.ipm_phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
            ipmProj.Deputy_Project_Leader__c = UserInfo.getUserid();
            update ipmProj;
            
            PageReference pRef = new PageReference(sPageRefURL+ipmProj.ID);
            Test.setCurrentPage(pRef);
            IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
            IPM_ProjectOverviewCtrl overCtrl=new IPM_ProjectOverviewCtrl(hstryControl);
            
            system.assertEquals(false,overCtrl.isIdeasPhase,'Project is in Ideas Phase');
            system.assertEquals(true,overCtrl.isOriginal,'Project is not an original project');
            
            system.assertEquals(system.label.IPM_CreateBETMsg,overCtrl.betInformationMessage,BET_ERROR_MSG);
            system.assert(new Set<String>((List<String>) overCtrl.additionalAlertMessages).contains(System.label.IPM_LeaderBETAlert),BET_ERROR_MSG);
            system.assertEquals(false,overCtrl.showSuggestedMembers,'Show members is true');
            
            ipmProj.IPM_BET_Toolkit__c = IPM_ConstantUtils.LINK_EXISTING_BET ;
            ipmProj.Deputy_Project_Leader__c = UserInfo.getUserid();
            ipmProj.BET_Link_Requested__c=null;
            ipmProj.BET_Denied_BET_Link__c = 'xxxxxxxxxxxxxxxx';
            update  ipmProj;
            
            PageReference pRef1 = new PageReference(sPageRefURL+ipmProj.ID);
            Test.setCurrentPage(pRef1);
            IPM_ProjDocumentSectionHstryController hstryControl1=new IPM_ProjDocumentSectionHstryController();
            IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl1);
            
            system.assertEquals(System.Label.IPM_BETLinkRejectMsgPL,overCtrl1.betInformationMessage,BET_ERROR_MSG);
            system.assert(new Set<String>((List<String>) overCtrl1.additionalAlertMessages).contains(String.format(System.label.IPM_BETChangeSelectionAlert,new string[]{ipmProj.id})),BET_ERROR_MSG);
        
            ipmProj.IPM_BET_Toolkit__c = IPM_ConstantUtils.NO_BET ;
            update  ipmProj;

            PageReference pRef2 = new PageReference(sPageRefURL+ipmProj.ID);
            Test.setCurrentPage(pRef2);
            IPM_ProjDocumentSectionHstryController hstryControl2=new IPM_ProjDocumentSectionHstryController();
            IPM_ProjectOverviewCtrl overCtrl2=new IPM_ProjectOverviewCtrl(hstryControl2);
            
            system.assertEquals(System.label.IPM_NoBETMsgPLOther,overCtrl2.betInformationMessage,BET_ERROR_MSG);
            
            Test.StopTest();
            
            PageReference pRef3 = new PageReference(sPageRefURL+ipmRoutProj.ID);
            Test.setCurrentPage(pRef3);
            IPM_ProjDocumentSectionHstryController hstryControl3=new IPM_ProjDocumentSectionHstryController();
            IPM_ProjectOverviewCtrl overCtrl3=new IPM_ProjectOverviewCtrl(hstryControl3);

            system.assertEquals(System.label.IPM_NoBETRegionalLocal,overCtrl3.betInformationMessage,BET_ERROR_MSG);
        }
    }
    
    // Test method for testRequestBETAccess method
    static testMethod void testRequestBETAccess(){
        
        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];

        IPM_Project__c ipmProj=[Select id,BET_Link_Requested__c ,IPM_BET_Toolkit__c  from  IPM_Project__c  where IPM_Project_Name__c = 'TestPrjOrg'];
        
        uw_BET__c bet1=[select id ,name from uw_BET__c where name='bet2'];  
        
        ipmProj.bet__c=bet1.id;
        update ipmProj ;
        
        System.runAs(testRunningUser ){
            
            Test.StartTest();
            
            PageReference pRef = new PageReference(sPageRefURL+ipmProj.ID);
            Test.setCurrentPage(pRef);          
            IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
            IPM_ProjectOverviewCtrl overCtrl=new IPM_ProjectOverviewCtrl(hstryControl);
            overCtrl.betFirstReleaseDueDate= 180; 
            overCtrl.betFinalReleaseDueDate= 300; 
            overCtrl.betMsgFirstReleaseDueDate= IPM_ConstantUtils.BET_FIRST_RELEASE_MESSAGE_STR1; 
            overCtrl.betMsgFinalReleaseDueDate= IPM_ConstantUtils.BET_FINAL_RELEASE_MESSAGE_STR1; 
            overCtrl.requestBETAccess();
            
            Test.StopTest();
        
            system.assertEquals('Manager',overCtrl.hasBETAccess,'No Access ');
        }
        }
    
    
    // Test method  for checking member call fron the URL and some of the controller properties
    static testMethod void testMemberCallBET() {
        
        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];

        IPM_Project__c parentProj = (IPM_TestFactory_Helper.createOriginalProjectList(false,1))[0];
        parentProj.IPM_Project_Name__c ='testParentProject';
        parentProj.BET_Denied_BET_Link__c='xxxxxxxxxxxxxxxx';
        parentProj.IPM_BET_Toolkit__c=IPM_ConstantUtils.NO_BET ;
        parentProj.BET__c=null;
        parentProj.IPM_Project_Leader__c = testRunningUser.Id;
        parentProj.Deputy_Project_Leader__c = testRunningUser.Id;
        insert  parentProj;
            
        IPM_Project__c ipmProj=[Select id,BET_Link_Requested__c ,IPM_Parent_Project__c,IPM_BET_Toolkit__c  from  IPM_Project__c  where IPM_Project_Name__c = 'TestPrjOrg'];
        
        ipmProj.IPM_Parent_Project__c=parentProj.id;
        update  ipmProj;
            
        system.runAs(testRunningUser ){
            
            Test.StartTest();
            
            IPM_Project__c ipmRoutProj=[Select id,BET_Link_Requested__c ,IPM_BET_Toolkit__c  from  IPM_Project__c  where IPM_Project_Name__c = 'TestPrj2'];

            uw_BET__c bet1=[select id ,name from uw_BET__c where name='bet2'];
            
            PageReference pRef = new PageReference(sPageRefURL+ipmRoutProj.ID);
            Test.setCurrentPage(pRef);
            IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
            IPM_ProjectOverviewCtrl overCtrl=new IPM_ProjectOverviewCtrl(hstryControl);
            
            system.assertEquals(parentProj.Id,overCtrl.projectWithBET,'Unable to set projectWithBET.');
            
            ipmProj.IPM_BET_Toolkit__c = IPM_ConstantUtils.LINK_EXISTING_BET ;
            ipmProj.ipm_phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
            ipmProj.Deputy_Project_Leader__c = UserInfo.getUserid();
            ipmProj.BET_Link_Requested__c=bet1.id;
            ipmProj.BET_Denied_BET_Link__c = null;
            ipmProj.bet__c=null;
            update  ipmProj;
            
            PageReference pRef1 = new PageReference(sPageRefURL+ipmRoutProj.ID+'&showMembers=true');
            Test.setCurrentPage(pRef1 );
            IPM_ProjDocumentSectionHstryController hstryControl1=new IPM_ProjDocumentSectionHstryController();
            IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl1);
            
            Test.StopTest();
            
            system.assertEquals(true,overCtrl1.memberCallFromURL,'Unable to set memberCallFromURL.');
            
            
        }
    }
 
     //Testmethod to validate pagination controls
    static testMethod void testPaginationControls(){
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
         
        system.runAs(platformUser)
        {
        initializedData();
        Test.startTest();
        PageReference pRef1 = new PageReference(sPageRefURL+project.ID);
        Test.setCurrentPage(pRef1);
        
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl=new IPM_ProjectOverviewCtrl(hstryControl);
        overCtrl.taskId = tskList[0].Id;
        overCtrl.getTasks();
        overCtrl.next();
        overCtrl.previous();
        overCtrl.last();
        overCtrl.first();
        overCtrl.getPageNumber();
        System.assertEquals(true, overCtrl.bPaginated, 'Pagination Controls tested.' );
        Test.stopTest();
        }
    }
    
    //Testmethod to validate pagination controls
    static testMethod void testChangeStatusButtonVisibility(){
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
         
        system.runAs(platformUser)
        {
        initializedData();
        Test.startTest();
        PageReference pRef1 = new PageReference(sPageRefURL+project.ID);
        Test.setCurrentPage(pRef1);
        
        projDoc.IPM_Document_Status__c='Proposed';
        update projDoc;
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl=new IPM_ProjectOverviewCtrl(hstryControl);
        System.assertEquals(true, overCtrl.bShowChangeStatusButton, 'Pagination Controls tested.' );
        Test.stopTest();
        }
    }
    
    //Testmethod to validate pagination controls
    static testMethod void testLocalTLDMisalignment(){
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
         
        system.runAs(platformUser)
        {
                 //Create IPM Project
            project=IPM_TestFactory_Helper.createIPMProject(false);
            project.Name='Test Local Project';
            project.Sustainability_Period__c=IPM_ConstantUtils.YEAR_3;
            project.IPM_Target_Launch_Dates__c=system.today();
            project.Rollout_Plan_Target_Launch_Date__c=system.today() + 10;
            project.IPM_IsCompleted__c=true; 
            project.IPM_Project_Name__c = 'Test Local Project'+System.now();
            project.IPM_Project_Leader__c=userinfo.getuserid();
            project.IPM_Project_Type__c = 'Rollout';
            project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            project.IPM_CompanyCardText__c = 'Global Company Card';
            project.IPM_Fast_Track_Project__c = true;
            project.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            project.IPM_Brand_Positioning__c='Dirt Is Good';
            project.IPM_ProjectSubType__c='Innovation/Rennovation';
            project.IPM_Category_Text__c='Household Care';
            insert project;

            Test.startTest();
            PageReference pRef1 = new PageReference(sPageRefURL+project.ID);
            Test.setCurrentPage(pRef1);
            
            IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
            IPM_ProjectOverviewCtrl overCtrl=new IPM_ProjectOverviewCtrl(hstryControl);
            System.assert(overCtrl.LstLocalFinTLDMisalignedMessage[0].contains(IPM_ConstantUtils.FIN_TLDMISALIGNED_ALERT1), 'Financials misaligned.');
            Test.stopTest();
        }
    }
    
    static testMethod void testForRegionalPLBlankForRollout(){
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
        
        system.runAs(platformUser)
        {
         initializedData();
         
          //Create regional project
            IPM_Project__c rProject = IPM_TestFactory_Helper.createIPMProject(false);
            rProject.Name='RegionalProject6';
            rProject.IPM_Project_Leader__c=userinfo.getuserid();
            rProject.IPM_Fast_Track_Project__c = true;
            rProject.IPM_Parent_Project__c = project.id;
            rProject.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            rProject.IPM_Project_Type__c =  IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            rProject.IPM_Phase__c  =  IPM_ConstantUtils.PHASE_FEASIBILITY;
            rProject.IPM_Target_Launch_Dates__c = System.today() + 360;
         
            insert rProject;
            
         IPM_Project_Rollout__c rollout = IPM_TestFactory_Helper.createIPMProjectRollout(false);
         rollout.Regional_Project__c= rProject.id;
         rollout.IPM_Regional_PL__c = null;
         insert rollout;
        
        Test.startTest();
        PageReference pRef1 = new PageReference(sPageRefURL+rProject.ID);
        Test.setCurrentPage(pRef1);
        
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl=new IPM_ProjectOverviewCtrl(hstryControl);
        System.assert(overCtrl.lstRolloutProjectAlertMessage[0].contains(Label.IPM_Local_Project_Leader_BlankMsg), 'Local Project leader is blank.');
        Test.stopTest();
        }
    }  
    
     static testMethod void testBusinessCase(){
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
        
        system.runAs(platformUser)
        {
            //Create global project
            IPM_Project__c globalProject = IPM_TestFactory_Helper.createIPMProject(false);
            globalProject.Name='GlobalProject';
            globalProject.IPM_Project_Leader__c=userinfo.getuserid();
            globalProject.IPM_Fast_Track_Project__c = true;
            globalProject.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
            globalProject.IPM_GateKeeping_Model__c=IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            globalProject.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            globalProject.IPM_Target_Launch_Dates__c = System.today() + 360;
            insert globalProject;
            
            //Create regional project
            IPM_Project__c regionalProject = IPM_TestFactory_Helper.createIPMProject(false);
            regionalProject.Name='RegionalProject';
            regionalProject.IPM_Project_Leader__c=userinfo.getuserid();
            regionalProject.IPM_Fast_Track_Project__c = true;
            regionalProject.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
            regionalProject.IPM_GateKeeping_Model__c=IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            regionalProject.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            regionalProject.IPM_Phase__c  =  IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            insert regionalProject;
            
             //Create Milestone
            mile = IPM_TestFactory_Helper.createIPMMilestone(globalProject.Id, false);
            mile.IPM_Phase__c=IDEAS_PHASE;
            mile.IPM_Due_Date__c=System.Today()+10;
            mile.IPM_No_Of_Days_for_Developing__c = '10';
            mile.IPM_No_Of_Days_for_Developing_Emerging__c = '10';
            mile.IPM_Project__c = globalProject.id;
            mile.IPM_Type_of_Milestone__c = IPM_ConstantUtils.STANDARD;
            mile.ExternalField__c = globalProject.id + IPM_ConstantUtils.CHARTER_GATE + IDEAS_PHASE + ORIGINAL_PROJECT_TYPE;
            insert mile;
            
            Id  financeMasterRecordType = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId();
            IPM_Financial__c testIPMFinancialConsolidated = IPM_TestFactory_Helper.createIPMFinancial(false);
            testIPMFinancialConsolidated.Financial_External_ID__c = globalProject.Id + String.valueOf(System.now());
            testIPMFinancialConsolidated.Project_Sustainability_Period__c = '3';
            testIPMFinancialConsolidated.Regional_Project__c =regionalProject.Id;
            testIPMFinancialConsolidated.RecordTypeId = financeMasterRecordType;
            testIPMFinancialConsolidated.Parent_Project__c= globalProject.id;
            insert testIPMFinancialConsolidated;  
            System.assertEquals(1, [Select count() from IPM_Financial__c where id =: testIPMFinancialConsolidated.id]);
           
            //Create Financial Year
            IPM_Financial_Year__c testFinancialYear = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            testFinancialYear.IPM_Financial__c = testIPMFinancialConsolidated.Id;
            testFinancialYear.Gross_Profit_Regional__c = 0;
            testFinancialYear.Year__c = '1';
            testFinancialYear.Year_Type__c = 'Calendar';
            testFinancialYear.Gross_Profit_Local__c = 0;
            insert testFinancialYear;
            System.assertEquals(1, [Select count() from IPM_Financial_Year__c where id =: testFinancialYear.id],'Financial Year is created');
               
            Test.startTest();
            PageReference pRef1 = new PageReference(sPageRefURL+globalProject.ID);
            Test.setCurrentPage(pRef1);
            
            IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
            IPM_ProjectOverviewCtrl overCtrl=new IPM_ProjectOverviewCtrl(hstryControl);
            System.assertEquals(overCtrl!=null, true);
            Test.stopTest();
        
        }
     }
}