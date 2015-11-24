/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece  
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CoreNTLandingPageControllerTest{

    static testMethod void unitTestMethodForLandingPage() {
        CORE_NT_Project__C ntpObject=new CORE_NT_Project__C();
        
        Test.startTest();
        //Create the Data for Testing.   
        ApexPages.StandardController stdController = new ApexPages.StandardController(ntpObject);
        CoreNTLandingPageController coreNTObject = new CoreNTLandingPageController(stdController);
        
        PermissionSetAssignment projManager=new PermissionSetAssignment();
        projManager.AssigneeId=UserInfo.getUserId();
        projManager.PermissionSetId=[SELECT ID FROM PermissionSet WHERE Name=:'CoreNTProjectManager' Limit 1].ID;
        System.debug('projManager.PermissionSetId'+projManager.PermissionSetId);
        //insert projManager;
        
        coreNTObject.lstLoggedInUserRoleDetail.add(projManager);
        
        coreNTObject.lstAllTaskDetailsOfProject=new List<CORE_NT_Task__C>();
        
        coreNTObject.lstLoggedInUserProjectDetailsTemp=new List<CORE_NT_Project__C>();
        
        CORE_NT_Project__C newProjectForTest1=new CORE_NT_Project__C();
        newProjectForTest1.Name='Project Test1';
        newProjectForTest1.CategoryName__c='Homecare';
        newProjectForTest1.SubcategoryName__c='Household Care';
        newProjectForTest1.Brand__c='Glorix';
        newProjectForTest1.Deadline__c=date.parse('6/6/2014');
        newProjectForTest1.PercentComplete__c=100;
        newProjectForTest1.Project_Scope__c='Global';
        upsert newProjectForTest1;
        
        CORE_NT_Project__C newProjectForTest2=new CORE_NT_Project__C();
        newProjectForTest2.Name='Project Test2';
        newProjectForTest2.CategoryName__c='Foods';
        newProjectForTest2.SubcategoryName__c='Dressings';
        newProjectForTest2.Brand__c='AXE';
        newProjectForTest2.Deadline__c=date.parse('7/7/2014');
        newProjectForTest2.PercentComplete__c=66;
        newProjectForTest2.Project_Scope__c='Global';
        upsert newProjectForTest2;
        
        CORE_NT_Project__C newProjectForTest3=new CORE_NT_Project__C();
        newProjectForTest3.Name='Project Test3';
        newProjectForTest3.CategoryName__c='Homecare';
        newProjectForTest3.SubcategoryName__c='Household Care';
        newProjectForTest3.Brand__c='Glorix';
        newProjectForTest3.Deadline__c=date.parse('6/6/2014');
        newProjectForTest3.PercentComplete__c=90;
        newProjectForTest3.Project_Scope__c='Regional';
        upsert newProjectForTest3;
        
        CORE_NT_Project__C newProjectForTest4=new CORE_NT_Project__C();
        newProjectForTest4.Name='Project Test4';
        newProjectForTest4.CategoryName__c='Homecare';
        newProjectForTest4.SubcategoryName__c='Household Care';
        newProjectForTest4.Brand__c='Glorix';
        newProjectForTest4.Deadline__c=date.parse('8/8/2014');
        newProjectForTest4.PercentComplete__c=60;
        newProjectForTest4.Project_Scope__c='Global';
        upsert newProjectForTest4;
        
        CORE_NT_Project__C newProjectForTest5=new CORE_NT_Project__C();
        newProjectForTest5.Name='Project Test5';
        newProjectForTest5.CategoryName__c='Homecare';
        newProjectForTest5.SubcategoryName__c='Household Care';
        newProjectForTest5.Brand__c='Glorix';
        newProjectForTest5.Deadline__c=date.parse('6/6/2014');
        //newProjectForTest5.PercentComplete__c=100;
        newProjectForTest5.Project_Scope__c='Regional';
        upsert newProjectForTest5;
        
        coreNTObject.lstLoggedInUserProjectDetailsTemp.add(newProjectForTest1);
        coreNTObject.lstLoggedInUserProjectDetailsTemp.add(newProjectForTest2);
        coreNTObject.lstLoggedInUserProjectDetailsTemp.add(newProjectForTest3);
        coreNTObject.lstLoggedInUserProjectDetailsTemp.add(newProjectForTest4);
        coreNTObject.lstLoggedInUserProjectDetailsTemp.add(newProjectForTest5);
        upsert coreNTObject.lstLoggedInUserProjectDetailsTemp;
        
        CORE_NT_Team__C newTeamMemberForTest1=new CORE_NT_Team__C();
        newTeamMemberForTest1.TeamMemberName__c=UserInfo.getUserId();
        newTeamMemberForTest1.Project__c=newProjectForTest1.Id;
        newTeamMemberForTest1.Role__c='Senior Leader';
        upsert newTeamMemberForTest1;
        
        CORE_NT_Task__C newTaskObjectForTest1=new CORE_NT_Task__C();
        newTaskObjectForTest1.Assigned_To__c=newTeamMemberForTest1.TeamMemberName__c;
        newTaskObjectForTest1.Due_Date__c=Date.today().addDays(7);
        newTaskObjectForTest1.ProjectId__c=newProjectForTest1.Id;
        upsert newTaskObjectForTest1;
        
        CORE_NT_Team__C newTeamMemberForTest2=new CORE_NT_Team__C();
        newTeamMemberForTest2.TeamMemberName__c=UserInfo.getUserId();
        newTeamMemberForTest2.Project__c=newProjectForTest2.Id;
        newTeamMemberForTest2.Role__c='Project Manager';
        upsert newTeamMemberForTest2;
        
        CORE_NT_Task__C newTaskObjectForTest2=new CORE_NT_Task__C();
        newTaskObjectForTest2.Assigned_To__c=newTeamMemberForTest2.TeamMemberName__c;
        newTaskObjectForTest2.Due_Date__c=Date.today().addDays(7);
        newTaskObjectForTest2.ProjectId__c=newProjectForTest1.Id;
        upsert newTaskObjectForTest2;
        
        CORE_NT_Task__C newTaskObjectForTest3=new CORE_NT_Task__C();
        newTaskObjectForTest3.Assigned_To__c=newTeamMemberForTest2.TeamMemberName__c;
        newTaskObjectForTest3.Due_Date__c=Date.today().addDays(-16);
        newTaskObjectForTest3.Complete__c=false;
        newTaskObjectForTest3.ProjectId__c=newProjectForTest3.Id;
        upsert newTaskObjectForTest3;
        
        CORE_NT_Task__C newTaskObjectForTest4=new CORE_NT_Task__C();
        newTaskObjectForTest4.Assigned_To__c=newTeamMemberForTest2.TeamMemberName__c;
        newTaskObjectForTest4.Due_Date__c=Date.today().addDays(12);
        newTaskObjectForTest4.Complete__c=true;
        newTaskObjectForTest4.ProjectId__c=newProjectForTest3.Id;
        upsert newTaskObjectForTest4;
        
        CORE_NT_Task__C newTaskObjectForTest5=new CORE_NT_Task__C();
        newTaskObjectForTest5.Assigned_To__c=newTeamMemberForTest2.TeamMemberName__c;
        newTaskObjectForTest5.Due_Date__c=Date.today().addDays(-7);
        newTaskObjectForTest5.Complete__c=false;
        newTaskObjectForTest5.ProjectId__c=newProjectForTest3.Id;
        upsert newTaskObjectForTest5;
        
        coreNTObject.lstAllTaskDetailsOfProject.add(newTaskObjectForTest1);
        coreNTObject.lstAllTaskDetailsOfProject.add(newTaskObjectForTest2);
        coreNTObject.lstAllTaskDetailsOfProject.add(newTaskObjectForTest3);
        coreNTObject.lstAllTaskDetailsOfProject.add(newTaskObjectForTest4);
        coreNTObject.lstAllTaskDetailsOfProject.add(newTaskObjectForTest5);
        
        upsert coreNTObject.lstAllTaskDetailsOfProject;
        
        coreNTObject.lstTempTaskDetails=coreNTObject.lstAllTaskDetailsOfProject;
        
        coreNTObject.lstLoggedInUserProjectDetails=coreNTObject.lstLoggedInUserProjectDetailsTemp;
        //coreNTObject.lstLoggedInUserProjectDetailsCopy=coreNTObject.lstLoggedInUserProjectDetails;
        upsert coreNTObject.lstLoggedInUserProjectDetails;

        //Testing getCategoryItems()
        //System.assertEquals(3,coreNTObject.getCategoryItems().size());
             
        //Testing getSubcategoryItems()
       // System.assertEquals(1,coreNTObject.getSubcategoryItems().size());
        
        //Testing getBrandItems()
       // System.assertEquals(1,coreNTObject.getBrandItems().size());
        
        //Testing getResourceNames()
        System.assertEquals(1,coreNTObject.getResourceNames().size());
        
        //Testing getProjectScopeItems()
        System.assertEquals(3,coreNTObject.getProjectScopeItems().size());
        
        //Testing getProjectClusterItems()
        coreNTObject.getProjectClusterItems();
        
        //Testing getAllLaunchYear()
        //coreNTObject.getAllLaunchYear();
        
        //Testing getProjectLaunchYearItems()()
        coreNTObject.getProjectLaunchYearItems();
        
        //Testing displayProjects()
        coreNTObject.selectedProjectsCriteria='All';
        coreNTObject.displayProjects();
        System.assertEquals(5,coreNTObject.lstLoggedInUserProjectDetails.size());
        
        coreNTObject.selectedProjectsCriteria='Open Projects';
        coreNTObject.displayProjects();
       // System.assertEquals(1,coreNTObject.lstLoggedInUserProjectDetails.size());
        
        coreNTObject.selectedProjectsCriteria='Delayed Projects';
        coreNTObject.displayProjects();
       // System.assertEquals(3,coreNTObject.lstLoggedInUserProjectDetails.size());
        
        coreNTObject.selectedProjectsCriteria='Completed Projects';
        coreNTObject.displayProjects();
       // System.assertEquals(1,coreNTObject.lstLoggedInUserProjectDetails.size());
        
        //Testing updateOTFStatusImage()
        //coreNTObject.updateOTFStatusImage();
        
        //Testing selectedProjectTaskDetail()
        coreNTObject.selectedProjectTaskDetail();
        
        //Testing selectedProjectTaskDetailBasedOnTasksCriteria() if the logged in user is a Project Manager
        coreNTObject.logedInUserRoleKey=2;
        coreNTObject.selectedTasksCriteria='Open Tasks';
        coreNTObject.selectedResourecsCriteria='All';
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedTasksCriteria='Open Tasks';
        coreNTObject.selectedResourecsCriteria=newTeamMemberForTest1.TeamMemberName__c;
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedTasksCriteria='Critical Open Tasks';
        coreNTObject.selectedResourecsCriteria='All';
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedTasksCriteria='Critical Open Tasks';
        coreNTObject.selectedResourecsCriteria=newTeamMemberForTest1.TeamMemberName__c;
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedTasksCriteria='Non-Critical Open Tasks';
        coreNTObject.selectedResourecsCriteria='All';
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedTasksCriteria='Non-Critical Open Tasks';
        coreNTObject.selectedResourecsCriteria=newTeamMemberForTest1.TeamMemberName__c;
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedTasksCriteria='Critical Delayed Tasks';
        coreNTObject.selectedResourecsCriteria='All';
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedTasksCriteria='Critical Delayed Tasks';
        coreNTObject.selectedResourecsCriteria=newTeamMemberForTest1.TeamMemberName__c;
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedTasksCriteria='Non-Critical Delayed Tasks';
        coreNTObject.selectedResourecsCriteria='All';
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedTasksCriteria='Non-Critical Delayed Tasks';
        coreNTObject.selectedResourecsCriteria=newTeamMemberForTest1.TeamMemberName__c;
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedTasksCriteria='Milestones';
        coreNTObject.selectedResourecsCriteria='All';
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedTasksCriteria='Milestones';
        coreNTObject.selectedResourecsCriteria=newTeamMemberForTest1.TeamMemberName__c;
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedTasksCriteria='All';
        coreNTObject.selectedResourecsCriteria=newTeamMemberForTest1.TeamMemberName__c;
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        //Testing selectedProjectTaskDetailBasedOnTasksCriteria() if the logged in user is a Task Performer
        coreNTObject.logedInUserRoleKey=1;
        coreNTObject.selectedTasksCriteria='Open Tasks';
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedTasksCriteria='Critical Open Tasks';
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedTasksCriteria='Non-Critical Open Tasks';
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedTasksCriteria='Critical Delayed Tasks';
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedTasksCriteria='Non-Critical Delayed Tasks';
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedTasksCriteria='Milestones';
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedTasksCriteria='All';
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        coreNTObject.selectedProjectID=newProjectForTest1.Id;
        coreNTObject.selectedProjectTaskDetailBasedOnTasksCriteria();
        
        //Testing displayLoggedInUserProjectsBasedOnCategory()
        coreNTObject.selectedCategory='Homecare';
        coreNTObject.selectedSubcategory='All';
        coreNTObject.selectedBrand='All';
        coreNTObject.displayLoggedInUserProjectsBasedOnCategory();
        
        coreNTObject.selectedCategory='Homecare';
        coreNTObject.selectedSubcategory='Household Care';
        coreNTObject.selectedBrand='All';
        coreNTObject.displayLoggedInUserProjectsBasedOnCategory();
        
        coreNTObject.selectedCategory='Homecare';
        coreNTObject.selectedSubcategory='Household Care';
        coreNTObject.selectedBrand='Glorix';
        coreNTObject.displayLoggedInUserProjectsBasedOnCategory();
        
        System.assertEquals(4,coreNTObject.lstLoggedInUserProjectsBasedOnCategoryDetails.size());
        
        
        //Testing getLogedInUserCategoryBasedDetailChartData()
        //System.assertEquals(1,coreNTObject.addLogedInUserCategoryBasedDetailChartData(coreNTObject.lstLoggedInUserProjectDetails).size());
        
        //System.assertEquals(1,coreNTObject.getLogedInUserCategoryBasedDetailChartData(coreNTObject.lstLoggedInUserProjectDetails).size());
        //System.assertEquals(4,coreNTObject.getLogedInUserCategoryBasedDetailChartData().size());
        
        //Testing updateProjectdataBasedOnSelectedCategory()
        coreNTObject.selectedCategory='All';
        coreNTObject.selectedSubcategory='Household Care';
        coreNTObject.selectedBrand='Glorix';
        coreNTObject.updateProjectdataBasedOnSelectedCategory();
        System.assertEquals(5,coreNTObject.lstLoggedInUserProjectDetails.size());
        
        coreNTObject.selectedCategory='Homecare';
        coreNTObject.selectedSubcategory='All';
        coreNTObject.selectedBrand='All';
        coreNTObject.updateProjectdataBasedOnSelectedCategory();
        System.assertEquals(4,coreNTObject.lstLoggedInUserProjectDetails.size());
        
        coreNTObject.selectedCategory='Homecare';
        coreNTObject.selectedSubcategory='Household Care';
        coreNTObject.selectedBrand='All';
        coreNTObject.updateProjectdataBasedOnSelectedCategory();
        System.assertEquals(4,coreNTObject.lstLoggedInUserProjectDetails.size());
        
        coreNTObject.selectedCategory='Homecare';
        coreNTObject.selectedSubcategory='Household Care';
        coreNTObject.selectedBrand='Glorix';
        coreNTObject.updateProjectdataBasedOnSelectedCategory();
        System.assertEquals(4,coreNTObject.lstLoggedInUserProjectDetails.size());
        
        coreNTObject.selectedScopeCriteria='Global';
        coreNTObject.updateProjectdataBasedOnSelectedCategory();
        System.assertEquals(2,coreNTObject.lstLoggedInUserProjectDetails.size());
        
        coreNTObject.selectedScopeCriteria='Regional';
        coreNTObject.selectedClusterCriteria='All';
        coreNTObject.updateProjectdataBasedOnSelectedCategory();
        System.assertEquals(2,coreNTObject.lstLoggedInUserProjectDetails.size());
        
        coreNTObject.selectedScopeCriteria='Regional';
        coreNTObject.updateProjectdataBasedOnSelectedCategory();
        System.assertEquals(2,coreNTObject.lstLoggedInUserProjectDetails.size());
        
        coreNTObject.selectedLaunchCriteria='2014';
        coreNTObject.updateProjectdataBasedOnSelectedCategory();
        
        
        //Testing getCategortBasedProjectData()
      /*  System.assertEquals(3,coreNTObject.getCategortBasedProjectDataChart().size());
        System.assertEquals(3,coreNTObject.getCategortBasedProjectData('All','Homecare','All').size());
        System.assertEquals(3,coreNTObject.lstCategortBasedProjectData.size());
        System.assertEquals(3,coreNTObject.getCategortBasedProjectData('All','Homecare','Household Care').size());
        System.assertEquals(3,coreNTObject.lstCategortBasedProjectData.size());
        System.assertEquals(3,coreNTObject.getCategortBasedProjectData('AXE','Homecare','Household Care').size());
        System.assertEquals(3,coreNTObject.lstCategortBasedProjectData.size());
        System.assertEquals(3,coreNTObject.getCategortBasedProjectData('All','All','All').size());
        System.assertEquals(3,coreNTObject.lstCategortBasedProjectData.size());
        */
        //Testing getProjectScopeBasedDetailChartData()
        coreNTObject.getProjectScopeBasedDetailChartData();
        
        //Testing addProjectLaunchYearBasedDetailChartData()
        //CoreNTObject.addProjectLaunchYearBasedDetailChartData();
        
        //Testing getProjectLaunchYearBasedDetailChartData()
        //CoreNTObject.getProjectLaunchYearBasedDetailChartData();
        
        //Testing addProjectScopeBasedDetailChartData()
        coreNTObject.addProjectScopeBasedDetailChartData('global');
        
        //ProjectLaunchYearData projLaunchObj=new ProjectLaunchYearData();
        
        Test.stopTest();
    }

}