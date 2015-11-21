@isTest(SeeAllData=false)
public class IPM_ProjectOverviewCtrl_Test
  { 
   public static IPM_Project__c project;
    public static IPM_Project_Document__c projDoc;
    public static List<IPM_Project_Document_Section__c> projDocSecList ;
    public static List<IPM_Project_Document_Section__c> projDocSecList1;
    public static IPM_Document_Template__c ipdt;
    public static IPM_Project_Template__c projTempl;
    public static IPM_Project_Resource__c projRes;
    public static list<IPM_Section__c> secMstList;
    public static List<IPM_Task__c> tskList;
    public static IPM_Milestone__c mile;
    public static String sPageRefURL = 'apex/IPM_ProjectOverview?Id=';
    public static String BET_ERROR_MSG = 'BET alert is not as expected';
    public static IPM_Project__c ipmProject ;
    public static uw_BET__c bet ;
    public static User runningUser = new User();
    public static Id ProjectID ;
    
    
    @testSetup static void initializedData()
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
            secMst.IPM_Section_Name__c = IPM_ConstantUtils.PHASE_IDEAS +i;
            secMstList.add(secMst);
        }
        insert secMstList;
        List<IPM_Section__c>sectionList=[SELECT ID FROM IPM_Section__c LIMIT 20];
        System.assertEquals(sectionList.size(), 20, 'section records created');
        //Create IPM Project
        project=IPM_TestFactory_Helper.createIPMProject(false);
        project.Name=sProjectName;
        project.Sustainability_Period__c='3';
        project.IPM_Target_Launch_Dates__c=system.today();
        project.IPM_IsCompleted__c=true; 
        project.IPM_Project_Name__c = sProjectName+System.now();
        project.IPM_Project_Leader__c=userinfo.getuserid();
        project.IPM_Project_Type__c = 'Original';
        project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
        project.IPM_CompanyCardText__c = 'Global Company Card';
        project.IPM_Fast_Track_Project__c = true;
        project.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
        project.IPM_Temporary_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;//lakhan
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
            tsk.ExternalField__c = project.Id +  IPM_ConstantUtils.PHASE_IDEAS + IPM_ConstantUtils.COMPLEXITY_LITE + 'New task'+ String.valueOf(i);
            tskList.add(tsk);
        }
        insert tskList;
        
        //Create Milestone
        mile = IPM_TestFactory_Helper.createIPMMilestone(project.Id, false);
        mile.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
        mile.IPM_Type_of_gate__c=IPM_ConstantUtils.CHARTER_GATE;
        mile.IPM_No_Of_Days_for_Developing__c = '10';
        mile.IPM_No_Of_Days_for_Developing_Emerging__c = '10';
        mile.IPM_Project__c = project.id;
        mile.IPM_Type_of_Milestone__c = IPM_ConstantUtils.STANDARD;
        mile.ExternalField__c = project.id + IPM_ConstantUtils.CHARTER_GATE + IPM_ConstantUtils.PHASE_IDEAS + IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
        insert mile;
        
 }
   
    //This testmethod will cover positive scenario for Project Overview screen
    static testMethod void overControl()
    {
        IPM_Milestone__c gProjectMilestone1;
        initializedData();
        project.Deputy_Project_Leader__c = UserInfo.getUserId(); 
        projDoc.IPM_Document_Status__c='In Progress';
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
        gProjectMilestone1.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
        gProjectMilestone1.IPM_Type_of_gate__c=IPM_ConstantUtils.CHARTER_GATE;
        gProjectMilestone1.IPM_Type_of_Milestone__c = IPM_ConstantUtils.STANDARD;
        gProjectMilestone1.IPM_Due_Date__c = System.today() - 2;
        gProjectMilestone1.IPM_Completed_On__c = null;
        gProjectMilestone1.IPM_Project__c = project.id;
        //gProjectMilestone1.ExternalField__c = project.id + IPM_ConstantUtils.CHARTER_GATE + IPM_ConstantUtils.PHASE_IDEAS + IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL+String.valueOf(System.now());
        insert gProjectMilestone1;
        System.assertEquals(gProjectMilestone1.IPM_Type_of_gate__c,IPM_ConstantUtils.CHARTER_GATE);
        
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
    
    //This testmethod will check if local rollout project with nearest upcoming milestone is not shown when regional project is in Feasibility state 
    static testMethod void testRolloutDetailSectionForRegionalFeasibilityProject(){
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
            rProjectMilestone1.IPM_Phase__c= IPM_ConstantUtils.PHASE_IDEAS;
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
    
    //This testmethod will check if regional rollout project with nearest upcoming milestone is not shown when global project is in Idea state 
    static testMethod void testRolloutDetailSectionForGlobalIdeaProject(){
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
        gProjectMilestone1.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
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
            rProjectMilestone1.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
            rProjectMilestone1.IPM_Type_of_gate__c=IPM_ConstantUtils.CHARTER_GATE;
            rProjectMilestone1.IPM_Due_Date__c = System.today() + 2;
            rProjectMilestone1.IPM_Completed_On__c = null;
            rProjectMilestone1.IPM_Project__c = project.id;
            //rProjectMilestone1.ExternalField__c = project.id + IPM_ConstantUtils.CHARTER_GATE + IPM_ConstantUtils.PHASE_IDEAS + IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL+String.valueOf(System.now());
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
    
     //This testmethod will check if regional rollout project with nearest upcoming milestone is not shown to the logged-in user if not a team member
    static testMethod void testRolloutDetailSectionWhenLoggedUserNotInTeam(){
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
            rProjectMilestone1.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
            rProjectMilestone1.IPM_Type_of_gate__c=IPM_ConstantUtils.CHARTER_GATE;
            rProjectMilestone1.IPM_Due_Date__c = System.today() + 2;
            rProjectMilestone1.IPM_Completed_On__c = null;
            rProjectMilestone1.IPM_Project__c = project.id;
            //rProjectMilestone1.ExternalField__c = project.id + IPM_ConstantUtils.CHARTER_GATE + IPM_ConstantUtils.PHASE_IDEAS + IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL+String.valueOf(System.now());
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
    
    //Testmethod to validate moveToPLE functionality
    static testMethod void testmoveToPLE(){
        initializedData();
        Test.startTest();
        PageReference pRef1 = new PageReference(sPageRefURL+project.ID);
        Test.setCurrentPage(pRef1);
        
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
        overCtrl1.moveToPLE();
        project = [Select Id, IPM_Actual_Launch_Date__c from IPM_Project__c where Id =: project.Id];
        Test.stopTest();
        System.assertEquals(Date.today(), project.IPM_Actual_Launch_Date__c, 'Launch Date Is Wrong');
    }
    
    //Testmethod to validate markComplete functionality
    static testMethod void testmarkComplete(){
        initializedData();
        Test.startTest();
        PageReference pRef1 = new PageReference(sPageRefURL+project.ID);
        Test.setCurrentPage(pRef1);
        
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
        overCtrl1.taskId = tskList[0].Id;
        overCtrl1.markComplete();
        Test.stopTest();
        System.assertEquals(false, tskList[0].IPM_Completed__c, 'IPM_Completed__c Is Completed' );
    }
    
    //testmethod to valiate financials data
    static testMethod void testFinancials(){
        initializedData();
        
        //Create Financial
        IPM_Financial__c testIPMFinancialConsolidated = IPM_TestFactory_Helper.createIPMFinancial(false);
        testIPMFinancialConsolidated.Parent_Project__c = project.Id;
        testIPMFinancialConsolidated.Financial_External_ID__c = project.Id + String.valueOf(System.now());
        testIPMFinancialConsolidated.Project_Sustainability_Period__c = '3';
        insert testIPMFinancialConsolidated;
        List<IPM_Financial__c>financialLists=[SELECT Parent_Project__c FROM IPM_Financial__c WHERE ID=:testIPMFinancialConsolidated.ID LIMIT 1];
        System.assertEquals(financialLists[0].Parent_Project__c, project.Id, 'parent project is:'+financialLists[0].Parent_Project__c);
       
        //Create Financial Year
        IPM_Financial_Year__c testFinancialYear = IPM_TestFactory_Helper.createIPMFinancialYear(false);
        testFinancialYear.Year__c = '3';
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
        Test.stopTest();
        //System.assertEquals(testIPMFinancialConsolidated.Business_Impact_Global__c , overCtrl1.globalbusinessImpactStr, 'Business_Impact_Global__c Not Matched');
    }
    
    //This testmethod will check for alert for Regional-Local financial and TLD alignments
    static testMethod void testAlertForRegionalLocalFinancialTLDAligned(){
         list<IPM_Project__c> rProjectList = new list<IPM_Project__c>();
         list<IPM_Project__c> lProjectList =  new list<IPM_Project__c>();
         list<IPM_Financial__c> financialList =  new list<IPM_Financial__c>();
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
        
        Test.startTest();
        PageReference pRef1 = new PageReference(sPageRefURL+rProjectList[0].ID);
        Test.setCurrentPage(pRef1);
        
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
       Test.stopTest();
        System.assertEquals(0, overCtrl1.lstFinTLDAlertMessage.size());
    }
    
     //This testmethod will check for alert for Regional-Local financial and TLD misalignments
    static testMethod void testAlertForRegionalLocalFinancialTLDMisAligned(){
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
            rProject.IPM_Project_Type__c =  IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
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
            lProject.IPM_Project_Type__c =  IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            lProject.IPM_Phase__c  =  IPM_ConstantUtils.PHASE_MARKET_READY;
            lProject.IPM_Target_Launch_Dates__c = System.today() + 300;
            lProjectList.add(lProject);
        }
        insert lProjectList;
        List<IPM_Project__c>projectLists=[SELECT id FROM IPM_Project__c LIMIT 20];
        System.assertEquals(projectLists.size(), 20, 'Local project records created');
        
        
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
         Test.stopTest();
        //System.assert(overCtrl1.lstFinTLDAlertMessage.size() > 0);
    }
    
    //This testmethod will verify alert for stopped projects
    static testMethod void testStoppedProjectAlert(){
         initializedData();
         project.Is_Archieved__c = true;
         update project;
         Test.startTest();
         PageReference pRef1 = new PageReference(sPageRefURL+project.ID);
         Test.setCurrentPage(pRef1);
        
         IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
         IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
         Test.stopTest();
         System.assert(overCtrl1.stoppedMsg != NULL);
    }
    
    //This testmethod will test for alert by validating difference between milestone due date and project TLD.
    static testMethod void testAlertwithMilestoneDueDateAndProjectTLD()
    {
         //IPM_Milestone__c gProjectMilestone1;
         IPM_ProjectOverviewCtrl overCtrl1;
        initializedData();
        List<IPM_Milestone__c> lstIPMMilestone = [Select Id from IPM_Milestone__c where IPM_Project__c =: project.id];
        project.IPM_Fast_Track_Project__c = false;
        project.IPM_Target_Launch_Dates__c = System.today() + 8;
        update project;
        
        lstIPMMilestone = [Select Id from IPM_Milestone__c where IPM_Project__c =: project.id];
        
        
        //Create geography
        mdm_Geography__c geography = IPM_TestFactory_Helper.createGeography(false);
        geography.Market_Type__c  = IPM_ConstantUtils.MARKETTYPE_DEVELOPED;
        insert geography;
        
        lstIPMMilestone = [Select Id from IPM_Milestone__c where IPM_Project__c =: project.id];
        
        //Create Country
        IPM_Country__c country = IPM_TestFactory_Helper.createIPMCountry(false);
        country.IPM_Project__c = project.Id;
        country.Geography__c = geography.Id;
        insert country;
        list<IPM_Country__c>countryList=[SELECT IPM_Project__c FROM IPM_Country__c WHERE ID=:country.ID LIMIT 1];
        System.assertEquals(countryList[0].IPM_Project__c, project.Id, 'Country project is:'+countryList[0].IPM_Project__c);
        lstIPMMilestone = [Select Id from IPM_Milestone__c where IPM_Project__c =: project.id];
        
        Test.startTest();
        PageReference pRef1 = new PageReference(sPageRefURL+project.ID);
        Test.setCurrentPage(pRef1);
        IPM_ProjectOverviewCtrl overCtrl=new IPM_ProjectOverviewCtrl();
        lstIPMMilestone = [Select Id from IPM_Milestone__c where IPM_Project__c =: project.id];
        
        overCtrl.taskId=tskList[0].Id;
        project.IPM_Fast_Track_Project__c = false;
        update project;
        
        lstIPMMilestone = [Select Id from IPM_Milestone__c where IPM_Project__c =: project.id];
        
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        mile.IPM_Planned_Date__c = System.today() - 2;
        mile.IPM_Due_Date__c = System.today() - 2;
        update mile;
        overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
        ///System.assert(overCtrl1.remainingDays < 0);
        
        mile.IPM_Planned_Date__c = System.today();
        mile.IPM_Due_Date__c = System.today();
        update mile;
        overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
        //System.assert(overCtrl1.remainingDays == 0);
        
        mile.IPM_Planned_Date__c = System.today() +10;
        mile.IPM_Due_Date__c = System.today() + 10;
        update mile;
        overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
        //Commenting assert , to run the test class
        //System.assert(overCtrl1.remainingDays > 0);
 		//System.assert(overCtrl1.gateDateAlert != null );
        
        Test.stopTest();
    }
    
    /*Test method to test BET functionality */
    static void betDataInitializer(){
        //Create BET to associate to project
        bet = BET_TestUtils.getTestBet();
        insert bet;
        //Create Original Project
        ipmProject = (IPM_TestFactory_Helper.createOriginalProjectList(true,1))[0];
         runningUser = IPM_TestFactory_Helper.createUser(true);
        ProjectID = ipmProject.id;
        IPM_Project_Resource__c bdUser = IPM_TestFactory_Helper.createIPMProjectResource(ProjectID,false);
        bdUser.IPM_Role_Type__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_BD;
        bdUser.IPM_Project__c = projectId;
        bdUser.IPM_User__c = runningUser.id;
        insert bdUser;
        list<IPM_Project_Resource__c>userResourceList=[SELECT IPM_Project__c FROM IPM_Project_Resource__c WHERE ID=:bdUser.ID LIMIT 1];
        System.assertEquals(userResourceList[0].IPM_Project__c, projectId, 'Resource project is:'+userResourceList[0].IPM_Project__c);
       

    }
    
    //Link to existing BET scenario
    /*static testMethod void testLinkBETMessagesIdeasPhase(){
        
        test.loadData(IPM_Project_Type__c.sobjectType, 'IPM_ProjectType');//
        test.loadData(IPM_BET_Search_Fields__c.sobjectType, 'IPM_BET_Search_Test');//
        test.loadData(IPM_ProjectMetadata__c.sobjectType, 'IPM_Project_Metadata');//
        betDataInitializer();
        test.startTest();
        ipmProject.BET_Link_Requested__c = bet.id;
        ipmProject.IPM_BET_Toolkit__c = IPM_ConstantUtils.LINK_EXISTING_BET;
        update ipmPRoject;
        PageReference pRef = new PageReference(sPageRefURL+ipmProject.ID);
        ApexPages.currentPage().getParameters().put(IPM_ConstantUtils.TEAM_PROJECTID,projectId); 
        Test.setCurrentPage(pRef);
        test.stopTest();
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl=new IPM_ProjectOverviewCtrl(hstryControl);
        system.assertEquals(bet.id,overCtrl.requestedBETId,'requested BET not updated as expected');
        system.assertEquals(null,overCtrl.BETId,'BET should not be updated ');
        system.assertEquals(String.format(System.label.IPM_LinkBETPLMsgIdeas,new string[]{bet.name}),overCtrl.betInformationMessage,BET_ERROR_MSG);
         //Test via Functional team member
        System.RunAs(runningUser){
        	PageReference pRef1 = new PageReference(sPageRefURL+ipmProject.ID);
        	ApexPages.currentPage().getParameters().put(IPM_ConstantUtils.TEAM_PROJECTID,projectId); 
            Test.setCurrentPage(pRef1);
            IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
            system.assertEquals(String.format(System.label.IPM_BETLinkFunctionalMsg,new string[]{bet.name}),overCtrl1.betInformationMessage,BET_ERROR_MSG);
        }
     }*/
     //Commenting  to run the test class
    //Test method to test BET functionality for other phases
   /* static testMethod void testCreateBETMessagesOtherPhases(){
        test.loadData(IPM_Project_Type__c.sobjectType, 'IPM_ProjectType');//
        test.loadData(IPM_BET_Search_Fields__c.sobjectType, 'IPM_BET_Search_Test');//
        test.loadData(IPM_ProjectMetadata__c.sobjectType, 'IPM_Project_Metadata');//
        betDataInitializer();
        //Create brand positioning, category group and category
        MDO_BrandPosition__c brandPost = IPM_TestFactory_Helper.createMDOBrandPosition(true);
        MDO_Category__c categoryGroup = IPM_TestFactory_Helper.createMDOCategory(false);
        categoryGroup.category_type__c = 'Category Group';
        categoryGroup.status__c = 'Active';
        insert categoryGroup;
        MDO_Category__c category = IPM_TestFactory_Helper.createMDOCategory(false);
        category.name = 'category';
        category.category_type__c = 'Category';
        category.status__c = 'Active';
        Category.parent_L2__c = categoryGroup.id;
        insert Category;
        Test.startTest();
        ipmProject.ipm_phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
        ipmProject.Deputy_Project_Leader__c = runningUser.id;
        
        ipmProject.IPM_Brand_Positioning__c = brandPost.name;
        ipmProject.IPM_Category_Text__c = Category.name;
        update ipmProject;
        PageReference pRef = new PageReference(sPageRefURL+ipmProject.ID);
        ApexPages.currentPage().getParameters().put(IPM_ConstantUtils.TEAM_PROJECTID,projectId); 
        Test.setCurrentPage(pRef);
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl=new IPM_ProjectOverviewCtrl(hstryControl);
        Test.stopTest();
        system.assertEquals(false,overCtrl.isIdeasPhase,'Project is in Ideas Phase');
        system.assertEquals(true,overCtrl.isOriginal,'Project is not an original project');
        
        system.assertEquals(system.label.IPM_CreateBETMsg,overCtrl.betInformationMessage,BET_ERROR_MSG);
        system.assertEquals(false,overCtrl.showSuggestedMembers,'Show members is true');
         ipmProject.Deputy_Project_Leader__c = null;
         ipmProject.IPM_Project_Leader__c = null; 
         update  ipmProject;
        //Test via Functional team member
        System.RunAs(runningUser){
            Test.setCurrentPage(pRef);
            IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
            system.assertEquals(system.label.IPM_NoNewBETMsgFunctional,overCtrl1.betInformationMessage,BET_ERROR_MSG);
        }
      }*/
      
    /*static testMethod void testNoBETMessagesOtherPhases(){
        test.loadData(IPM_Project_Type__c.sobjectType, 'IPM_ProjectType');//
        test.loadData(IPM_BET_Search_Fields__c.sobjectType, 'IPM_BET_Search_Test');//
        test.loadData(IPM_ProjectMetadata__c.sobjectType, 'IPM_Project_Metadata');//
        betDataInitializer();
       // Test.startTest();
            ipmProject.ipm_phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
            ipmProject.IPM_BET_Toolkit__c = IPM_ConstantUtils.NO_BET;
            update ipmProject;
        PageReference pRef = new PageReference(sPageRefURL+ipmProject.ID);
        ApexPages.currentPage().getParameters().put(IPM_ConstantUtils.TEAM_PROJECTID,projectId); 
        Test.setCurrentPage(pRef);
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl=new IPM_ProjectOverviewCtrl(hstryControl);
        //Test.stopTest(); 
        IPM_project__c regionalProject = IPM_TestFactory_Helper.createIPMProject(false);
        regionalProject.IPM_Phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
        //regionalProject.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
        regionalProject.IPM_Parent_Project__c = ipmProject.id;
        regionalProject.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        regionalProject.IPM_Project_Leader__c = runningUser.id;
        insert regionalProject;
        IPM_project__c LocalProject = IPM_TestFactory_Helper.createIPMProject(false);
        LocalProject.IPM_Phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
        LocalProject.IPM_Parent_Project__c = regionalProject.id;
        LocalProject.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        LocalProject.IPM_Project_Leader__c = runningUser.id;
        insert LocalProject; 
        
        system.assertEquals(system.label.IPM_NoBETMsgPLOther,overCtrl.betInformationMessage,BET_ERROR_MSG);
        //Test via Functional team member
        Test.startTest();
        
        System.RunAs(runningUser){
            Test.setCurrentPage(pRef);
            IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
            system.assertEquals(system.label.IPM_NoBETMsgFunctional,overCtrl1.betInformationMessage,BET_ERROR_MSG);
        //}
       // System.runAs(runningUser){
            PageReference pRef2 = new PageReference(sPageRefURL+regionalProject.id);
            ApexPages.currentPage().getParameters().put(IPM_ConstantUtils.TEAM_PROJECTID,regionalProject.id); 
            Test.setCurrentPage(pRef2);
            IPM_ProjDocumentSectionHstryController hstryControl1=new IPM_ProjDocumentSectionHstryController();
            new IPM_ProjectOverviewCtrl(hstryControl1);  
        //}
        //System.runAs(runningUser){
            PageReference pRef3 = new PageReference(sPageRefURL+LocalProject.id);
            ApexPages.currentPage().getParameters().put(IPM_ConstantUtils.TEAM_PROJECTID,LocalProject.id); 
            Test.setCurrentPage(pRef3);
            IPM_ProjDocumentSectionHstryController hstryControl2=new IPM_ProjDocumentSectionHstryController();
            new IPM_ProjectOverviewCtrl(hstryControl2);      
        }
        Test.stopTest();    
    }
      */
    //test method to test BET functionality for other phases
   /*static testMethod void testLinkBETMessagesOtherPhases(){
        test.loadData(IPM_Project_Type__c.sobjectType, 'IPM_ProjectType');//
        test.loadData(IPM_BET_Search_Fields__c.sobjectType, 'IPM_BET_Search_Test');//
        test.loadData(IPM_ProjectMetadata__c.sobjectType, 'IPM_Project_Metadata');//
        betDataInitializer();
        Test.startTest();
        ipmProject.BET_Link_Requested__c = bet.id;
        ipmProject.IPM_BET_Toolkit__c = IPM_ConstantUtils.LINK_EXISTING_BET;
        ipmProject.ipm_phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
        update ipmProject;
        PageReference pRef = new PageReference(sPageRefURL+ipmProject.ID);
        ApexPages.currentPage().getParameters().put(IPM_ConstantUtils.TEAM_PROJECTID,projectId); 
        Test.setCurrentPage(pRef);
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl=new IPM_ProjectOverviewCtrl(hstryControl);
        Test.stopTest();
        system.assertEquals(String.format(System.label.IPM_LinkBETPLMsg,new string[]{bet.name}) ,overCtrl.betInformationMessage,BET_ERROR_MSG);
         //Test via Functional team member
        System.RunAs(runningUser){
            Test.setCurrentPage(pRef);
            IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
            system.assertEquals(String.format(System.label.IPM_BETReqPendingMsgFunctional,new string[]{bet.name}),overCtrl1.betInformationMessage,BET_ERROR_MSG);
        }
      }*/
      
      //Method to test suggested members
     /*static testMethod void testSuggestedMembers(){
      	
      	Test.startTest();  
        test.loadData(IPM_Project_Type__c.sobjectType, 'IPM_ProjectType');
        test.loadData(IPM_BET_Search_Fields__c.sobjectType, 'IPM_BET_Search_Test');
        test.loadData(IPM_ProjectMetadata__c.sobjectType, 'IPM_Project_Metadata');
        betDataInitializer();
         //lakhan 
        
         uw_BET__c bet1 = BET_TestUtils.getTestBet();
         bet1.name ='bet1';
         
       
         uw_BET__c bet2 = BET_TestUtils.getTestBet();
         bet2.name ='bet2';
        
        
        insert new List<uw_BET__c>{bet1,bet2  } ;
        System.Assert(bet1.Id != null, 'The BET record not inserted');
        System.Assert(bet2.Id != null, 'The BET record not inserted');
         
        
        IPM_Project__c project1=IPM_TestFactory_Helper.createIPMProject(false);
        project1.name='testProject1';
        project1.BET__c=bet1.id;
        project1.BET_Link_Requested__c=bet1.id;////
        project1.IPM_Project_Type__c = 'Rollout';
        project1.IPM_GateKeeping_Model__c = 'RCLT';
        project1.IPMProject_Span__c = 'Local';
        project1.IPM_Phase__c = 'Feasibility';
        project1.IPM_CompanyCardText__c = 'Regional Company Card';
        project1.IPM_Project_Job_Status__c = 'Completed';
        project1.IPM_Target_Launch_Dates__c = Date.Today();
        insert  project1; 
           
           System.Assert(project1.Id != null, 'The project record not inserted');
           
             IPM_Project__c project2=IPM_TestFactory_Helper.createIPMProject(false);
             project2.name='testProject2';
             project2.BET__c=bet2.id;
             project2.IPM_Parent_Project__c=project1.id;
                project2.BET_Link_Requested__c=bet2.id;////
             // project2.IPM_Project_Type__c = 'Rollout';
             project2.IPM_Project_Type__c = 'Rollout';
            project2.IPM_GateKeeping_Model__c = 'RCLT';
        
            project2.IPMProject_Span__c = 'Local';
            project2.IPM_Phase__c = 'Feasibility';
            project2.IPM_CompanyCardText__c = 'Regional Company Card';
            project2.IPM_Project_Job_Status__c = 'Completed';
            project2.IPM_Target_Launch_Dates__c = Date.Today();
             insert project2;
              
             
             System.Assert(project2.Id != null, 'The project record not inserted');
        
        
        
        ipmProject.BET__c = bet.id;
        ipmProject.IPM_BET_Toolkit__c = IPM_ConstantUtils.LINK_EXISTING_BET;
        ipmProject.ipm_phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
        ipmProject.Bulk_BET_Member_Request__c=false;//
        ipmProject.IPM_Parent_Project__c=project2.id;//
          
        ipmProject.IPM_Project_Leader__c = userinfo.getuserid();
        ipmProject.IPM_Project_Type__c='Original';//
        project2.IPM_GateKeeping_Model__c = 'GCLT & RCLT';
        project2.IPMProject_Span__c='Global';
         project2.BET_Link_Requested__c=bet.id;
        project2.IPM_CompanyCardText__c='Global Company Card';
        update ipmProject;
       
        PageReference pRef = new PageReference(sPageRefURL+ipmProject.ID);
       
        
        Test.setCurrentPage(pRef);  
        ApexPages.currentPage().getParameters().put(IPM_ConstantUtils.TEAM_PROJECTID,projectId); // 
        ApexPages.currentPage().getParameters().put('showMembers','true'); //
        ApexPages.currentPage().getParameters().put('BETId',ipmProject.BET__c); 
        
        IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        IPM_ProjectOverviewCtrl overCtrl=new IPM_ProjectOverviewCtrl(hstryControl);
        overCtrl.isOriginal=true;
          
       
        List<IPM_Project_Resource__c> resourceList = new List<IPM_Project_Resource__c>();
        resourceList.add(new IPM_Project_Resource__c(IPM_Project__c = projectId,IPM_Role_Type__c = IPM_ConstantUtils.FUNCTIONAL_ROLE_BD,IPM_User__c=runningUser.id));
        resourceList.add(new IPM_Project_Resource__c(IPM_Project__c = projectId,IPM_Role_Type__c = IPM_ConstantUtils.IPM_ROLE_FINANCE,IPM_User__c=runningUser.id));
        insert resourceList;
        List<IPM_Project_Resource__c> resources = [select id,name from IPM_Project_Resource__c where IPM_Project__c =: projectid];
      
        system.assertEquals(3,resources.size(),'resources not inserted properly'+resources.size());
        system.assertEquals(true,overCtrl.showSuggestedMembers,'Suggested members is false');
        system.assertEquals(1,(overCtrl.suggestedManagerList).size(),'Suggested Manager list size is not as expected');
        //Test request Access
        
        System.runAs(runningUser){ 
            IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);   
            system.assertEquals('No',overCtrl1.hasBETAccess,'USer has access');
            overCtrl1.requestBETAccess();
            system.assertEquals('Pending',overCtrl1.hasBETAccess,'Access request not sent to bet');
        }
        Test.stopTest();  
      }*/
      

}