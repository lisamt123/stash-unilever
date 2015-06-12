/*
*   Class Name : CoreNTLandingPageController 
*   Author : Mindtree
*   Date : 09 May 2014
*   Description : This class controls the home page for All Users and it displays the data based on the role of Logged In User.                    
*/

public class CoreNTLandingPageController {

    public Integer logedInUserRoleKey { get; set; }
    public String logedInUserRole { get; set; }
    public String sfdcBaseURLforSearchPage { get; set; }
    public String sfdcBaseURLforImportPage { get; set; }
    public String sfdcBaseURLforReportPage { get; set; }
    public String loggedInUser { get; set; }
    
    public List < AggregateResult > lstMilestoneTask {get;set;}
    public List < TotalProjectDataCounts > lstCategortBasedProjectData { get; set; }
    public List < GlobalAndRegionalTypeProjectData > lstGlobalAndRegionalTypeProjectData { get; set; }
    public List < PermissionSetAssignment > lstLoggedInUserRoleDetail { get; set; }
    public List < CORE_NT_Project__C > lstLoggedInUserProjectDetailsTemp { get; set; }
    public List < CORE_NT_Project__C > lstLoggedInUserProjectDetails { get; set; }
    public List < CORE_NT_Task__C > lstSelectedProjectTaskDetails { get; set; }
    public List<CORE_NT_Task__C> lstTempTaskDetails { get; set; }
    public List < CORE_NT_Project__C > lstLoggedInUserProjectsBasedOnCategoryDetails { get; set; }
    public Map<Id,List<CORE_NT_Task__C>> mapAllTaskDetailsOfProject { get; set; }

    public List<CORE_NT_Task__C> lstAllTaskDetailsOfProject { get; set; }
    public List < SelectOption > resourceNameOptions { get; set; }
    public List < SelectOption > projectNameOptions { get; set; }
    public List < SelectOption > brandOptions { get; set; }
    public List < SelectOption > subcategoryOptions { get; set; }
    public List < SelectOption > categoryOptions { get; set; }
    public Set < SelectOption > categoryOptionsSet { get; set; }
    public Set < SelectOption > subcategoryOptionsSet { get; set; }
    public Set < SelectOption > brandOptionsSet { get; set; }
    public List < SelectOption > userRoleOptions { get; set; }
    
    public String selectedLogedInUserRoleKey { get; set; }
    
  //  public CORE_NT_Project__C objCoreNTProject { get; set; }
    public String selectedCategory { get; set; }
    public String selectedSubcategory { get; set; }
    public String selectedBrand { get; set; }
    public String selectedProjectsCriteria { get; set; }
    public String selectedTasksCriteria { get; set; }
    public String selectedResourecsCriteria { get; set; }
    public String selectedProjectID { get; set; }
    public String selectedScopeCriteria { get; set; }
    public String selectedClusterCriteria { get; set; }
    public String selectedLaunchCriteria { get; set; }
    public String selectedCategoryCriteria { get; set; }
    public String selectedSubcategoryCriteria { get; set; }
    public String selectedBrandCriteria { get; set; }

    
    public Boolean displaylogedInUserCategoryBasedDetailChartPanel { get; set; }

    /*
    Purpose:  Dceides the accessibility based on the role.                                                     
    Parameters: - controller
    Returns: 
    Throws: exception none
    */
    public CoreNTLandingPageController(ApexPages.StandardController controller) {
 
        selectedLogedInUserRoleKey =null;
        //Checking The LoggedIn User role and assigning the key Values
        lstLoggedInUserRoleDetail = [SELECT Id, PermissionSetId,Assignee.Name, PermissionSet.Name FROM PermissionSetAssignment where assigneeId = : UserInfo.getUserId()];
        logedInUserRoleKey = 3;
        Set<String> PermissionSetAssignmentMap=new Set<String>();
        if (lstLoggedInUserRoleDetail.size() > 0) {
            for(PermissionSetAssignment objPermissionSetAssignment : lstLoggedInUserRoleDetail){
                PermissionSetAssignmentMap.Add(objPermissionSetAssignment.PermissionSet.Name);
            }                           
            userRoleOptions=new List<SelectOption>();
            if (PermissionSetAssignmentMap.Contains('CoreNTProjectManager')){
                logedInUserRoleKey = 2;
                userRoleOptions.add(new SelectOption('2','Project Manager'));
            }
            else if (PermissionSetAssignmentMap.Contains('CoreNTTaskPerformer'))
                logedInUserRoleKey = 1;
            else if (PermissionSetAssignmentMap.Contains('CoreNTSeniorLeader'))
                logedInUserRoleKey = 0;
            
            if (PermissionSetAssignmentMap.Contains('CoreNTTaskPerformer'))
                userRoleOptions.add(new SelectOption('1','Task Performer'));
            if (PermissionSetAssignmentMap.Contains('CoreNTSeniorLeader'))
                userRoleOptions.add(new SelectOption('0','Senior Leader'));                                
        }
        if(logedInUserRoleKey != 3){
            updateUserRoleDetails();
        }
    }
    public void updateUserRoleDetails(){
        selectedCategory = 'All';
        selectedCategoryCriteria = 'none';
        selectedScopeCriteria='All';
        selectedLaunchCriteria='All';
        selectedProjectsCriteria='All';
        selectedTasksCriteria='All';
        selectedResourecsCriteria='All';      
        selectedProjectID =null;
        if(selectedLogedInUserRoleKey != null)
            logedInUserRoleKey=Integer.ValueOf(selectedLogedInUserRoleKey);
        //Extracting the LoggedIn User ID
        loggedInUser = UserInfo.getUserId();

        lstSelectedProjectTaskDetails = new List < CORE_NT_Task__C > ();
        lstLoggedInUserProjectDetails = new List < CORE_NT_Project__C > ();
        lstLoggedInUserProjectDetailsTemp = new List < CORE_NT_Project__C > ();
        lstLoggedInUserProjectsBasedOnCategoryDetails = new List < CORE_NT_Project__C > ();
        displaylogedInUserCategoryBasedDetailChartPanel = false;


        if(logedInUserRoleKey == 0){
            lstLoggedInUserProjectDetails = [SELECT OTIF_Status__c,Id, Name, PercentComplete__c, Deadline__c, Kickoff__c, CategoryName__c, SubcategoryName__c, Brand__c,Project_Scope__c,Cluster__c FROM CORE_NT_Project__C];
        }
        else{
            List<Report> report = [SELECT Id FROM Report WHERE DeveloperName = 'Delayed_Projects_and_Tasks_Report' limit 1];
            Id reportId = null;
            if(report.size() > 0)
                reportId = report[0].Id;
            //Id reportId=[SELECT Id FROM Report WHERE DeveloperName = 'Delayed_Projects_and_Tasks_Report'].Id;
            //Adding the Search and Import Page URL Links to the string
            sfdcBaseURLforSearchPage = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/CoreNTSearch?isdtp=vw';
            sfdcBaseURLforImportPage = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/CoreNTImport';
            if(reportId != null)
                sfdcBaseURLforReportPage = URL.getSalesforceBaseUrl().toExternalForm() + '/' +reportId+'?isdtp=mn';
            //Extracting the LoggedIn User Project Details                               
            lstLoggedInUserProjectDetails = [SELECT OTIF_Status__c,Id, Name, PercentComplete__c, Deadline__c, Kickoff__c, CategoryName__c, SubcategoryName__c, Brand__c FROM CORE_NT_Project__C WHERE OwnerId = : loggedInUser];
            List < CORE_NT_Team__C > lstLogedInUserOtherTeamProjectDetails = [SELECT Project__r.OTIF_Status__c,Project__r.Id, Project__r.Name, Project__r.PercentComplete__c, Project__r.Deadline__c, Project__r.Kickoff__c, Project__r.CategoryName__c, Project__r.SubcategoryName__c, Project__r.Brand__c FROM CORE_NT_Team__C where TeamMemberName__c = : loggedInUser and Project__r.OwnerId != : loggedInUser];
            Set <String> projectIdSet = new Set <String> ();
            for (CORE_NT_Team__C objLogedInUserOtherTeamProjectDetail: lstLogedInUserOtherTeamProjectDetails) {
                if (projectIdSet.add(objLogedInUserOtherTeamProjectDetail.Project__r.Id))
                    lstLoggedInUserProjectDetails.add(new CORE_NT_Project__C(OTIF_Status__c=objLogedInUserOtherTeamProjectDetail.Project__r.OTIF_Status__c,Id = objLogedInUserOtherTeamProjectDetail.Project__r.Id, Name = objLogedInUserOtherTeamProjectDetail.Project__r.Name, PercentComplete__c = objLogedInUserOtherTeamProjectDetail.Project__r.PercentComplete__c, Deadline__c = objLogedInUserOtherTeamProjectDetail.Project__r.Deadline__c, Kickoff__c = objLogedInUserOtherTeamProjectDetail.Project__r.Kickoff__c,
                                                        CategoryName__c = objLogedInUserOtherTeamProjectDetail.Project__r.CategoryName__c, SubcategoryName__c = objLogedInUserOtherTeamProjectDetail.Project__r.SubcategoryName__c, Brand__c = objLogedInUserOtherTeamProjectDetail.Project__r.Brand__c));
            }   
            projectIdSet = null;         
        }
        
        for (CORE_NT_Project__C objLogedInUserProjectPercentZero: lstLoggedInUserProjectDetails) {
            if (objLogedInUserProjectPercentZero.PercentComplete__c == null)
                objLogedInUserProjectPercentZero.PercentComplete__c = 0;
        }

        updateOTFStatusImage();
        lstLoggedInUserProjectDetailsTemp = lstLoggedInUserProjectDetails;
        if (logedInUserRoleKey == 1 || logedInUserRoleKey == 2)
            displayLoggedInUserProjectsBasedOnCategory();
    }
    public void updateOTFStatusImage(){
        Integer noOfDaysDelayed;
        Integer totalTasksInCurrentProject;
        Integer veryLateTasks;
        Integer LateTasks;
        Integer onTimeTasks;
        mapAllTaskDetailsOfProject= new Map<Id,List<CORE_NT_Task__C>>();
        lstAllTaskDetailsOfProject=[SELECT ProjectId__c,Id,Due_Date__c,Complete__c,Days_Late_Formula__c FROM CORE_NT_Task__C];
        //lstTempTaskDetails=new List<CORE_NT_Task__C>();
        for(CORE_NT_Task__C objTaskDetail: lstAllTaskDetailsOfProject){
            lstTempTaskDetails=new List<CORE_NT_Task__C>();
            if(mapAllTaskDetailsOfProject.containsKey(objTaskDetail.ProjectId__c)){
                lstTempTaskDetails=mapAllTaskDetailsOfProject.get(objTaskDetail.ProjectId__c);
            }
            lstTempTaskDetails.add(objTaskDetail);
            mapAllTaskDetailsOfProject.put(objTaskDetail.ProjectId__c,lstTempTaskDetails);
        }
        
        for (CORE_NT_Project__C objProject: lstLoggedInUserProjectDetails) {        
            totalTasksInCurrentProject=0;
            onTimeTasks=0;            
            if(mapAllTaskDetailsOfProject.containsKey(objProject.Id)){            
                totalTasksInCurrentProject =mapAllTaskDetailsOfProject.get(objProject.Id).Size();
                lstTempTaskDetails=mapAllTaskDetailsOfProject.get(objProject.Id);
                veryLateTasks=0;
                LateTasks=0;
                //onTimeTasks=0;
                
                for(CORE_NT_Task__C objTaskDetail: lstTempTaskDetails){
                    if(objTaskDetail.Days_Late_Formula__c > 14 && objTaskDetail.Complete__c == false)
                        veryLateTasks+=1;
                    if(objTaskDetail.Days_Late_Formula__c >0 && objTaskDetail.Days_Late_Formula__c <= 14 && objTaskDetail.Complete__c == false)
                        LateTasks+=1;
                    if(objTaskDetail.Days_Late_Formula__c <= 0 || objTaskDetail.Complete__c == true)
                        onTimeTasks+=1;
                }
            }
            
            if((totalTasksInCurrentProject-onTimeTasks)==0)
                objProject.OTIF_Status__c=3;
            if(veryLateTasks>0)
                objProject.OTIF_Status__c=1;
            if(veryLateTasks==0 && LateTasks>0)
                objProject.OTIF_Status__c=2;
        }           
    }

    /*
    Purpose:  This is used to get all the project Categories.                                                     
    Parameters: -
    Returns: List<SelectOption>
    Throws: exception none
    */
    public List < SelectOption > getCategoryItems() {
        categoryOptions = new List < SelectOption > ();
        if (logedInUserRoleKey != 3) {
            categoryOptionsSet = new Set < SelectOption > ();
            categoryOptions.add(new SelectOption('All', 'All'));
            for (CORE_NT_Project__C objProject: lstLoggedInUserProjectDetailsTemp) {
                if (objProject.CategoryName__c!=null && categoryOptionsSet.add(new SelectOption(objProject.CategoryName__c, objProject.CategoryName__c)))
                    categoryOptions.add(new SelectOption(objProject.CategoryName__c, objProject.CategoryName__c));
            }
        }     
        return categoryOptions;
    }

    /*
    Purpose:  This is used to get all the project Sub Categories.                                                     
    Parameters: -
    Returns: List<SelectOption>
    Throws: exception none
    */
    public List < SelectOption > getSubcategoryItems() {
        subcategoryOptions = new List < SelectOption > ();
        if (logedInUserRoleKey != 3) {
            subcategoryOptionsSet = new Set < SelectOption > ();
            subcategoryOptions.add(new SelectOption('All', 'All'));
            for (CORE_NT_Project__C objProject: lstLoggedInUserProjectDetailsTemp) {
                if (objProject.SubcategoryName__c!=null && objProject.CategoryName__c == selectedCategory && subcategoryOptionsSet.add(new SelectOption(objProject.SubcategoryName__c, objProject.SubcategoryName__c)))
                    subcategoryOptions.add(new SelectOption(objProject.SubcategoryName__c, objProject.SubcategoryName__c));
            }
        }
        return subcategoryOptions;
    }

    /*
    Purpose:  This is used to get all the Brand Items.                                                    
    Parameters: -
    Returns: List<SelectOption>
    Throws: exception none
    */
    public List < SelectOption > getBrandItems() {
        brandOptions = new List < SelectOption > ();
        if (logedInUserRoleKey != 3) {
            brandOptionsSet = new Set < SelectOption > ();
            brandOptions.add(new SelectOption('All', 'All'));
            for (CORE_NT_Project__C objProject: lstLoggedInUserProjectDetailsTemp) {
                if (objProject.Brand__c!=null && objProject.CategoryName__c == selectedCategory && objProject.SubcategoryName__c == selectedSubcategory && brandOptionsSet.add(new SelectOption(objProject.Brand__c, objProject.Brand__c)))
                    brandOptions.add(new SelectOption(objProject.Brand__c, objProject.Brand__c));
            }
        }
        return brandOptions;
    }
    

    /*
   Purpose:  Used to Display Projects based on Project Criteria                                                     
   Parameters: -
   Returns: -
   Throws: exception none
  */
    public void displayProjects() {
        lstLoggedInUserProjectDetails = new List < CORE_NT_Project__C > ();
        lstSelectedProjectTaskDetails = null;
        selectedProjectID =null;
        if (selectedProjectsCriteria == 'All') {
            lstLoggedInUserProjectDetails = lstLoggedInUserProjectDetailsTemp;
        } else if (selectedProjectsCriteria == 'Open Projects') {
            for (CORE_NT_Project__C objProject: lstLoggedInUserProjectDetailsTemp) {
                if (objProject.Deadline__c >= Date.today() && objProject.PercentComplete__c != 100)
                    lstLoggedInUserProjectDetails.add(objProject);
            }
        } else if (selectedProjectsCriteria == 'Delayed Projects') {
            for (CORE_NT_Project__C objProject: lstLoggedInUserProjectDetailsTemp) {
                if (objProject.Deadline__c < Date.today() && objProject.PercentComplete__c != 100)
                    lstLoggedInUserProjectDetails.add(objProject);
            }
        } else if (selectedProjectsCriteria == 'Completed Projects') {
            for (CORE_NT_Project__C objProject: lstLoggedInUserProjectDetailsTemp) {
                if (objProject.PercentComplete__c == 100)
                    lstLoggedInUserProjectDetails.add(objProject);
            }
        }
    }

    public void selectedProjectTaskDetail() {
        selectedProjectID = System.currentPagereference().getParameters().get('projectID');
        selectedProjectTaskDetailBasedOnTasksCriteria();
    }
    
    /*
    Purpose:  This method is used to get the resources from selected project.                                                     
    Parameters: -
    Returns: List<SelectOption>
    Throws: exception none
    */
    public List < SelectOption > getResourceNames() {
        resourceNameOptions = new List < SelectOption > ();
        resourceNameOptions.add(new SelectOption('All', 'All'));
        try{
            List < CORE_NT_Team__C > resources = [SELECT TeamMemberName__c, TeamMemberName__r.Name FROM CORE_NT_Team__C WHERE Project__c = : selectedProjectID];
            for (CORE_NT_Team__C projTeamObj: resources) {
                if(projTeamObj.TeamMemberName__c!=null)
                    resourceNameOptions.add(new SelectOption(projTeamObj.TeamMemberName__c, projTeamObj.TeamMemberName__r.Name));
            }
        } catch (Exception ex) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(errorMessage);
        }
        return resourceNameOptions;
    }
   
    /*
    Purpose:  This method is used to get the task details from selected project.                                                        
    Parameters: -
    Returns: -
    Throws: exception none
    */
    public void selectedProjectTaskDetailBasedOnTasksCriteria() {
        try{          
            if (logedInUserRoleKey == 2  && selectedProjectID != null) {
                if (selectedTasksCriteria == 'Open Tasks' && selectedResourecsCriteria == 'All') {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Due_Date__c, Project_Milestone__c, Critical__c, projectId__C, Complete__c, Milestone__c, Task_Completed__c FROM CORE_NT_Task__C WHERE ProjectId__c = : selectedProjectID AND Complete__c = : false AND Due_Date__c >= Today];
                } else if (selectedTasksCriteria == 'Open Tasks' && selectedResourecsCriteria != 'All') {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Due_Date__c, Project_Milestone__c, Critical__c, projectId__C, Complete__c, Milestone__c, Task_Completed__c FROM CORE_NT_Task__C WHERE ProjectId__c = : selectedProjectID AND Complete__c = : false AND Due_Date__c >= Today AND Assigned_To__c = : selectedResourecsCriteria];
                } else if (selectedTasksCriteria == 'Critical Open Tasks' && selectedResourecsCriteria == 'All') {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Due_Date__c, Project_Milestone__c, Critical__c, projectId__C, Complete__c, Milestone__c, Task_Completed__c FROM CORE_NT_Task__C WHERE ProjectId__c = : selectedProjectID AND Complete__c = : false AND Critical__c = : true AND Due_Date__c >= Today];
                } else if (selectedTasksCriteria == 'Critical Open Tasks' && selectedResourecsCriteria != 'All') {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Due_Date__c, Project_Milestone__c, Critical__c, projectId__C, Complete__c, Milestone__c, Task_Completed__c FROM CORE_NT_Task__C WHERE ProjectId__c = : selectedProjectID AND Complete__c = : false AND Critical__c = : true AND Due_Date__c >= Today AND Assigned_To__c = : selectedResourecsCriteria];
                } else if (selectedTasksCriteria == 'Non-Critical Open Tasks' && selectedResourecsCriteria == 'All') {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Due_Date__c, Project_Milestone__c, Critical__c, projectId__C, Complete__c, Milestone__c, Task_Completed__c FROM CORE_NT_Task__C WHERE ProjectId__c = : selectedProjectID AND Complete__c = : false AND Critical__c = : false AND Due_Date__c >= Today];
                } else if (selectedTasksCriteria == 'Non-Critical Open Tasks' && selectedResourecsCriteria != 'All') {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Due_Date__c, Project_Milestone__c, Critical__c, projectId__C, Complete__c, Milestone__c, Task_Completed__c FROM CORE_NT_Task__C WHERE ProjectId__c = : selectedProjectID AND Complete__c = : false AND Critical__c = : false AND Due_Date__c >= Today AND Assigned_To__c = : selectedResourecsCriteria];
                } else if (selectedTasksCriteria == 'Critical Delayed Tasks' && selectedResourecsCriteria == 'All') {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Due_Date__c, Project_Milestone__c, Critical__c, projectId__C, Complete__c, Milestone__c, Task_Completed__c FROM CORE_NT_Task__C WHERE ProjectId__c = : selectedProjectID AND Complete__c = : false AND Critical__c = : true AND Due_Date__c < Today];
                } else if (selectedTasksCriteria == 'Critical Delayed Tasks' && selectedResourecsCriteria != 'All') {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Due_Date__c, Project_Milestone__c, Critical__c, projectId__C, Complete__c, Milestone__c, Task_Completed__c FROM CORE_NT_Task__C WHERE ProjectId__c = : selectedProjectID AND Complete__c = : false AND Critical__c = : true AND Due_Date__c < Today AND Assigned_To__c = : selectedResourecsCriteria];
                } else if (selectedTasksCriteria == 'Non-Critical Delayed Tasks' && selectedResourecsCriteria == 'All') {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Due_Date__c, Project_Milestone__c, Critical__c, projectId__C, Complete__c, Milestone__c, Task_Completed__c FROM CORE_NT_Task__C WHERE ProjectId__c = : selectedProjectID AND Complete__c = : false AND Critical__c = : false AND Due_Date__c < Today];
                } else if (selectedTasksCriteria == 'Non-Critical Delayed Tasks' && selectedResourecsCriteria != 'All') {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Due_Date__c, Project_Milestone__c, Critical__c, projectId__C, Complete__c, Milestone__c, Task_Completed__c FROM CORE_NT_Task__C WHERE ProjectId__c = : selectedProjectID AND Complete__c = : false AND Critical__c = : false AND Due_Date__c < Today AND Assigned_To__c = : selectedResourecsCriteria];
                } else if (selectedTasksCriteria == 'Milestones' && selectedResourecsCriteria == 'All') {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Due_Date__c, Project_Milestone__c, Critical__c, projectId__C, Complete__c, Milestone__c, Task_Completed__c FROM CORE_NT_Task__C WHERE ProjectId__c = : selectedProjectID AND Milestone__c = : true];
                } else if (selectedTasksCriteria == 'Milestones' && selectedResourecsCriteria != 'All') {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Due_Date__c, Project_Milestone__c, Critical__c, projectId__C, Complete__c, Milestone__c, Task_Completed__c FROM CORE_NT_Task__C WHERE ProjectId__c = : selectedProjectID AND Milestone__c = : true AND Assigned_To__c = : selectedResourecsCriteria];
                } else if (selectedTasksCriteria == 'All' && selectedResourecsCriteria != 'All') {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Project_Milestone__c, Critical__c, Due_Date__c, Complete__c, Milestone__c, Task_Completed__c FROM CORE_NT_Task__C WHERE ProjectId__c = : selectedProjectID AND Assigned_To__c = : selectedResourecsCriteria];
                } else{
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Project_Milestone__c, Critical__c, Due_Date__c, Complete__c, Milestone__c, Task_Completed__c FROM CORE_NT_Task__C WHERE ProjectId__c = : selectedProjectID];
                } 
            } else if (logedInUserRoleKey == 1 && selectedProjectID != null) {
                if (selectedTasksCriteria == 'Open Tasks') {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Due_Date__c, Project_Milestone__c, Critical__c, Complete__c, Milestone__c,Task_Completed__c  FROM CORE_NT_Task__C WHERE Assigned_To__c = : loggedInUser and ProjectId__c = : selectedProjectID AND Complete__c = : false AND Due_Date__c >= Today];
                } else if (selectedTasksCriteria == 'Critical Open Tasks' ) {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Due_Date__c, Project_Milestone__c, Critical__c, Complete__c, Milestone__c,Task_Completed__c  FROM CORE_NT_Task__C WHERE Assigned_To__c = : loggedInUser and ProjectId__c = : selectedProjectID AND Complete__c = : false AND Critical__c = : true AND Due_Date__c >= Today];
                } else if (selectedTasksCriteria == 'Non-Critical Open Tasks') {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Due_Date__c, Project_Milestone__c, Critical__c, Complete__c, Milestone__c,Task_Completed__c FROM CORE_NT_Task__C WHERE Assigned_To__c = : loggedInUser and ProjectId__c = : selectedProjectID AND Complete__c = : false AND Critical__c = : false AND Due_Date__c >= Today];
                } else if (selectedTasksCriteria == 'Critical Delayed Tasks') {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Due_Date__c, Project_Milestone__c, Critical__c, Complete__c, Milestone__c,Task_Completed__c FROM CORE_NT_Task__C WHERE Assigned_To__c = : loggedInUser and ProjectId__c = : selectedProjectID AND Complete__c = : false AND Critical__c = : true AND Due_Date__c < Today];
                } else if (selectedTasksCriteria == 'Non-Critical Delayed Tasks') {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Due_Date__c, Project_Milestone__c, Critical__c, Complete__c, Milestone__c,Task_Completed__c FROM CORE_NT_Task__C WHERE Assigned_To__c = : loggedInUser and ProjectId__c = : selectedProjectID AND Complete__c = : false AND Critical__c = : false AND Due_Date__c < Today];
                } else if (selectedTasksCriteria == 'Milestones') {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Due_Date__c, Project_Milestone__c, Critical__c, Complete__c, Milestone__c,Task_Completed__c FROM CORE_NT_Task__C WHERE Assigned_To__c = : loggedInUser and ProjectId__c = : selectedProjectID AND Milestone__c = : true];
                } else {
                    lstSelectedProjectTaskDetails = [SELECT name, Assigned_To__c, Project_Milestone__c, Critical__c, Due_Date__c, Complete__c, Milestone__c,Task_Completed__c FROM CORE_NT_Task__C WHERE Assigned_To__c = : loggedInUser and ProjectId__c = : selectedProjectID];
                }  
            } else {
                lstSelectedProjectTaskDetails = null;
            }          
        } catch (Exception ex) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(errorMessage);
        }
    }

    public void updateCategoryBasedSelectionValues(){
        selectedSubcategory= 'All';
        updateSubcategoryBasedSelectionValues();
    }
    public void updateSubcategoryBasedSelectionValues(){
        selectedBrand = 'All';
        if(logedInUserRoleKey==0)
            updateProjectdataBasedOnSelectedCategory();
        else if(logedInUserRoleKey==1 || logedInUserRoleKey==2)
            displayLoggedInUserProjectsBasedOnCategory();
    }
    public void updateProjectdataBasedOnSelectedCategory() {
        System.debug(' CoreNTLandingPageController || updateProjectdataBasedOnSelectedCategory || Started');
        
        Boolean LoggedInUserLaunchYearBasedProjectDetailsFlag=false; 
        Boolean LoggedInUserStatusBasedProjectDetailsFlag=false;
        Boolean LoggedInUserCategoryBasedProjectDetailsFlag=false;
        Boolean LoggedInUserScopeBasedProjectDetailsFlag=false;
        
        List<CORE_NT_Project__C> lstLoggedInUserProjectDetailsCopy=new List<CORE_NT_Project__C>();
        lstLoggedInUserProjectDetails=new List<CORE_NT_Project__C>();
        if(selectedLaunchCriteria!='All' && selectedLaunchCriteria!=null){
            for(CORE_NT_Project__C objCoreNTProject : lstLoggedInUserProjectDetailsTemp){
               if(objCoreNTProject.Deadline__c!=null && objCoreNTProject.Deadline__c.YEAR()==Integer.ValueOf(selectedLaunchCriteria))
                    lstLoggedInUserProjectDetails.add(objCoreNTProject );
            }
            LoggedInUserLaunchYearBasedProjectDetailsFlag=true;
        }
        
        if(LoggedInUserLaunchYearBasedProjectDetailsFlag==true){
            lstLoggedInUserProjectDetailsCopy=lstLoggedInUserProjectDetails;
            lstLoggedInUserProjectDetails=new List<CORE_NT_Project__C>();
        }
        else
            lstLoggedInUserProjectDetailsCopy=lstLoggedInUserProjectDetailsTemp;
            
        if (selectedCategory!= 'All' && selectedSubcategory== 'All' && selectedBrand == 'All'){
            for(CORE_NT_Project__C objCoreNTProject : lstLoggedInUserProjectDetailsCopy){
                if(objCoreNTProject.CategoryName__c == selectedCategory)
                    lstLoggedInUserProjectDetails.add(objCoreNTProject);
            }
            LoggedInUserCategoryBasedProjectDetailsFlag=true;
        } else if (selectedCategory!= 'All' && selectedSubcategory!= 'All' && selectedBrand == 'All'){
            for(CORE_NT_Project__C objCoreNTProject : lstLoggedInUserProjectDetailsCopy){
                if(objCoreNTProject.CategoryName__c == selectedCategory && objCoreNTProject.SubcategoryName__c == selectedSubcategory)
                    lstLoggedInUserProjectDetails.add(objCoreNTProject);
            }
            LoggedInUserCategoryBasedProjectDetailsFlag=true;
        } else if (selectedCategory!= 'All' && selectedSubcategory!= 'All' && selectedBrand != 'All'){
            for(CORE_NT_Project__C objCoreNTProject : lstLoggedInUserProjectDetailsCopy){
                if(objCoreNTProject.CategoryName__c == selectedCategory && objCoreNTProject.SubcategoryName__c == selectedSubcategory && objCoreNTProject.Brand__c == selectedBrand)
                    lstLoggedInUserProjectDetails.add(objCoreNTProject);
            }
            LoggedInUserCategoryBasedProjectDetailsFlag=true;
        }      
           
                    
        if(LoggedInUserCategoryBasedProjectDetailsFlag==true){
            lstLoggedInUserProjectDetailsCopy=lstLoggedInUserProjectDetails;
            lstLoggedInUserProjectDetails=new List<CORE_NT_Project__C>();
        }
        
        if(selectedScopeCriteria=='Global'){
            for(CORE_NT_Project__C objCoreNTProject : lstLoggedInUserProjectDetailsCopy){
                if(objCoreNTProject.Project_Scope__c==selectedScopeCriteria)
                    lstLoggedInUserProjectDetails.add(objCoreNTProject);
            }
            LoggedInUserScopeBasedProjectDetailsFlag=true;
        }else if(selectedScopeCriteria=='Regional'){
            if(selectedClusterCriteria!='All' && selectedClusterCriteria!=null){
                for(CORE_NT_Project__C objCoreNTProject : lstLoggedInUserProjectDetailsCopy ){
                    if(objCoreNTProject.Project_Scope__c==selectedScopeCriteria && objCoreNTProject.Cluster__c==selectedClusterCriteria)
                        lstLoggedInUserProjectDetails.add(objCoreNTProject);
                }
            }
            else{
                for(CORE_NT_Project__C objCoreNTProject : lstLoggedInUserProjectDetailsCopy ){
                    if(objCoreNTProject.Project_Scope__c==selectedScopeCriteria)
                        lstLoggedInUserProjectDetails.add(objCoreNTProject);
                }
            }
            LoggedInUserScopeBasedProjectDetailsFlag=true;
        }
        
        if(LoggedInUserScopeBasedProjectDetailsFlag!=true)
            lstLoggedInUserProjectDetails=lstLoggedInUserProjectDetailsCopy;            
        
        System.debug(' CoreNTLandingPageController || updateProjectdataBasedOnSelectedCategory || Completed');
    }
        
  /*
   Purpose:  create the ProjectDataCount class list based on the selected category,brand,subcategory 
   Parameters: -
   Returns: category based project detail list 
   Throws: exception none
  */
    public List < TotalProjectDataCounts > getCategortBasedProjectDataChart() {
        System.debug(' CoreNTLandingPageController || getCategortBasedProjectDataChart || Started');
        CORE_NT_Project__C objProject = new CORE_NT_Project__C();
        ApexPages.StandardController stdController = new ApexPages.StandardController(objProject);
        CoreNTLandingPageController objProjMgr = new CoreNTLandingPageController(stdController);
        System.debug(' CoreNTLandingPageController || getCategortBasedProjectDataChart || Completed');
        return objProjMgr.getCategortBasedProjectData(selectedBrand, selectedCategory, selectedSubcategory);
    }
        
  /*
   Purpose:  create the ProjectDataCount class list based on the selected category,brand,subcategory 
   Parameters: category,brand,subcategory
   Returns: category based project detail list 
   Throws: exception-Exception
  */
    public List < TotalProjectDataCounts > getCategortBasedProjectData(String brandNames, String categorys, String subcategorys) {
        System.debug(' CoreNTLandingPageController || getCategortBasedProjectData || Started');
        
        lstCategortBasedProjectData = new List < TotalProjectDataCounts > ();
        try {
            AggregateResult delayedProjects=null;
            AggregateResult ontrackProjects=null;
            AggregateResult completedProjects=null;
            //if(categorys != null && subcategorys != null && brandNames != null){
              /*  if (categorys != 'All' && subcategorys == 'All' && brandNames == 'All') {
                    delayedProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c < 100.00 AND Deadline__c < TODAY AND CategoryName__c = : categorys];
                    ontrackProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c < 100.00 AND Deadline__c > TODAY AND CategoryName__c = : categorys];
                    completedProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c = 100 AND CategoryName__c = : categorys];
    
                } else if (categorys != 'All' && subcategorys != 'All' && brandNames == 'All') {
                    delayedProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c < 100.00 AND Deadline__c < TODAY AND CategoryName__c = : categorys AND SubcategoryName__c = : subcategorys];
                    ontrackProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c < 100.00 AND Deadline__c > TODAY AND CategoryName__c = : categorys AND SubcategoryName__c = : subcategorys];
                    completedProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c = 100 AND CategoryName__c = : categorys AND SubcategoryName__c = : subcategorys];
    
                } else if (categorys != 'All' && subcategorys != 'All' && brandNames != 'All') {
                    delayedProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c < 100.00 AND Deadline__c < TODAY AND Brand__c = : brandNames AND CategoryName__c = : categorys AND SubcategoryName__c = : subcategorys];
                    ontrackProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c < 100.00 AND Deadline__c > TODAY AND Brand__c = : brandNames AND CategoryName__c = : categorys AND SubcategoryName__c = : subcategorys];
                    completedProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c = 100 AND Brand__c = : brandNames AND CategoryName__c = : categorys AND SubcategoryName__c = : subcategorys];
    
                } else if(categorys == 'All') {*/
                    delayedProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE (PercentComplete__c =null OR PercentComplete__c < 100.00) AND Deadline__c < TODAY];
                    ontrackProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE (PercentComplete__c =null OR PercentComplete__c < 100.00) AND Deadline__c >= TODAY];
                    completedProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c = 100];    
            //    }
                
                if ((Integer) delayedProjects.get('expr0') > 0) 
                    lstCategortBasedProjectData.add(new TotalProjectDataCounts((Integer) delayedProjects.get('expr0'), 'Delayed'));
                if ((Integer) ontrackProjects.get('expr0') > 0)
                    lstCategortBasedProjectData.add(new TotalProjectDataCounts((Integer) ontrackProjects.get('expr0'), 'On-Track'));
                if ((Integer) completedProjects.get('expr0') > 0)
                    lstCategortBasedProjectData.add(new TotalProjectDataCounts((Integer) completedProjects.get('expr0'), 'Completed'));
          //  }
        } catch (Exception ex) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(errorMessage);
        }
        System.debug(' CoreNTLandingPageController || getCategortBasedProjectData || Completed');
        return lstCategortBasedProjectData;
    }
   
   /*
    Purpose:  Creates the List of Projects of Logged In user based on the Selected Category,Subcategory and brands.  
    Parameters: -
    Returns: -
    Throws: -
   */
    public void displayLoggedInUserProjectsBasedOnCategory() {
        loggedInUser = UserInfo.getUserId();        
        lstLoggedInUserProjectsBasedOnCategoryDetails = new List < CORE_NT_Project__C > ();
        List<CORE_NT_Task__C> lstTaskDetails=new List<CORE_NT_Task__C>();
        Integer TotalOpenTaskCount;
        Integer TotalLateTaskCount;
        Integer TotalCompleteTaskCount;
        try{
            if (selectedCategory!= 'All' && selectedSubcategory== 'All' && selectedBrand== 'All') {
                for (CORE_NT_Project__C objLoggedInUserProject: lstLoggedInUserProjectDetailsTemp) {
                    IF(objLoggedInUserProject.CategoryName__c == selectedCategory)
                        lstLoggedInUserProjectsBasedOnCategoryDetails.add(objLoggedInUserProject);
                }
            } else if (selectedCategory!= 'All' && selectedSubcategory!= 'All' && selectedBrand== 'All') {
                for (CORE_NT_Project__C objLoggedInUserProject: lstLoggedInUserProjectDetailsTemp) {
                    IF(objLoggedInUserProject.CategoryName__c == selectedCategory && objLoggedInUserProject.SubcategoryName__c == selectedSubcategory)
                        lstLoggedInUserProjectsBasedOnCategoryDetails.add(objLoggedInUserProject);
                }
            } else if (selectedCategory!= 'All' && selectedSubcategory!= 'All' && selectedBrand!= 'All') {
                for (CORE_NT_Project__C objLoggedInUserProject: lstLoggedInUserProjectDetailsTemp) {
                    IF(objLoggedInUserProject.CategoryName__c == selectedCategory && objLoggedInUserProject.SubcategoryName__c == selectedSubcategory && objLoggedInUserProject.Brand__c == selectedBrand)
                        lstLoggedInUserProjectsBasedOnCategoryDetails.add(objLoggedInUserProject);
                }
            } else
                lstLoggedInUserProjectsBasedOnCategoryDetails = lstLoggedInUserProjectDetailsTemp;
            
            for (CORE_NT_Project__C objProject: lstLoggedInUserProjectsBasedOnCategoryDetails) {
                if(mapAllTaskDetailsOfProject.containsKey(objProject.Id)){
                    objProject.Total_Number_Of_tasks__c =mapAllTaskDetailsOfProject.get(objProject.Id).Size();
                    lstTaskDetails=mapAllTaskDetailsOfProject.get(objProject.Id);
                    TotalOpenTaskCount=0;
                    TotalLateTaskCount=0;
                    TotalCompleteTaskCount=0;
                    for(CORE_NT_Task__C objTaskDetail: lstTaskDetails){
                        if(objTaskDetail.Due_Date__c >= Date.Today() && objTaskDetail.Complete__c == false)
                            TotalOpenTaskCount+=1;
                        if(objTaskDetail.Due_Date__c < Date.Today() && objTaskDetail.Complete__c == false)
                            TotalLateTaskCount+=1;
                        if(objTaskDetail.Complete__c == true)
                            TotalCompleteTaskCount+=1;
                    }
                    objProject.Total_Open_Task_Count__c =TotalOpenTaskCount;
                    objProject.Total_Late_Task_Count__c =TotalLateTaskCount;
                    objProject.Total_Complete_Task_Count__c =TotalCompleteTaskCount;
                    //upsert objProject;
                }
            }
            if (lstLoggedInUserProjectsBasedOnCategoryDetails.size() > 0) {
                displaylogedInUserCategoryBasedDetailChartPanel = true;
                for (CORE_NT_Project__C objProject: lstLoggedInUserProjectsBasedOnCategoryDetails) {
                    if (objProject.PercentComplete__c == null)
                        objProject.PercentComplete__c = 0;
                }
            } else {
                displaylogedInUserCategoryBasedDetailChartPanel = false;
            }
        } catch (Exception ex) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(errorMessage);
        }
    }
    
    /*
     Purpose:  Creates the Category based Task Details Data to be displayed in Charts
     Parameters: -
     Returns: - List < LogedInUserCategoryBasedTasksDetailData >
     Throws: -
    */
    public List < LogedInUserCategoryBasedTasksDetailData > getLogedInUserCategoryBasedDetailChartData() {
        List < LogedInUserCategoryBasedTasksDetailData > lstLogedInUserCategoryBasedTaskDetailChartData = new List < LogedInUserCategoryBasedTasksDetailData > ();
        for (CORE_NT_Project__C objProject: lstLoggedInUserProjectsBasedOnCategoryDetails) {
            if (objProject.Total_Open_Task_Count__c == null)
                objProject.Total_Open_Task_Count__c = 0;
            if (objProject.Total_Late_Task_Count__c == null)
                objProject.Total_Late_Task_Count__c = 0;
            if (objProject.Total_Complete_Task_Count__c == null)
                objProject.Total_Complete_Task_Count__c = 0;
            lstLogedInUserCategoryBasedTaskDetailChartData.add(new LogedInUserCategoryBasedTasksDetailData(objProject.Name, objProject.Total_Open_Task_Count__c, objProject.Total_Late_Task_Count__c, objProject.Total_Complete_Task_Count__c));
        }
        return lstLogedInUserCategoryBasedTaskDetailChartData;
    }
    
    public List < SelectOption > projectScopeOptions {get;set;}
    public List < SelectOption > projectClusterOptions {get;set;}
    public List < SelectOption > projectLaunchYearOptions {get;set;}
    
    public List < SelectOption > getProjectScopeItems() {
        projectScopeOptions= new List < SelectOption > ();
        projectScopeOptions.add(new SelectOption('All', 'All'));
        projectScopeOptions.add(new SelectOption('Global', 'Global'));
        projectScopeOptions.add(new SelectOption('Regional', 'Regional'));
        return projectScopeOptions;
    }
    public List< SelectOption > getProjectClusterItems(){
        projectClusterOptions = new List < SelectOption > ();
        Set<String> projectClusterOptionsSet= new Set<String>();
        projectClusterOptions.add(new SelectOption('All', 'All'));
        if(selectedScopeCriteria=='Regional'){
            List<CORE_NT_Project__C> lstCoreNTProject=[SELECT Project_Scope__c,Cluster__c FROM CORE_NT_Project__C where Project_Scope__c=:selectedScopeCriteria];
            for(CORE_NT_Project__C objCoreNTProject: lstCoreNTProject){
                if (objCoreNTProject.Cluster__c !=null && projectClusterOptionsSet.add(objCoreNTProject.Cluster__c))
                    projectClusterOptions.add(new SelectOption(objCoreNTProject.Cluster__c, objCoreNTProject.Cluster__c));
            }
        }
        return projectClusterOptions;
    }
    public List<SelectOption> getProjectLaunchYearItems(){
        projectLaunchYearOptions = new List < SelectOption > ();
        projectLaunchYearOptions.add(new SelectOption('All', 'All'));
        for(Integer launchYear : getAllLaunchYear()){
            projectLaunchYearOptions.add(new SelectOption(String.valueOf(launchYear), String.valueOf(launchYear)));
        }        
        return projectLaunchYearOptions;
    }
    public List<Integer> getAllLaunchYear(){
        List<AggregateResult> allYear=[SELECT CALENDAR_YEAR(Deadline__c) FROM CORE_NT_Project__C Group By CALENDAR_YEAR(Deadline__c)];
        List<Integer> lstYear=new List<Integer>();
        for(AggregateResult ys:allYear){
            IF(ys.get('expr0')!=null)
                lstYear.add((Integer) ys.get('expr0'));
        }
        lstYear.Sort();
        return lstYear;
    }
    public List<GlobalAndRegionalTypeProjectData> getProjectScopeBasedDetailChartData(){
        System.debug(' CoreNTLandingPageController || getProjectScopeBasedDetailChartData || Started');
        CORE_NT_Project__C objProject = new CORE_NT_Project__C();
        ApexPages.StandardController stdController = new ApexPages.StandardController(objProject);
        CoreNTLandingPageController objProjMgr = new CoreNTLandingPageController(stdController);
        System.debug(' CoreNTLandingPageController || getProjectScopeBasedDetailChartData || Completed');
        //System.Debug('--------------------------------------- anki 1-----------------------------------------------'+selectedScopeCriteria);
        return objProjMgr.addProjectScopeBasedDetailChartData(selectedScopeCriteria);
    }

    public List < GlobalAndRegionalTypeProjectData > addProjectScopeBasedDetailChartData(String selectedScopeCriteriaValue) {
        System.debug(' CoreNTLandingPageController || addProjectScopeBasedDetailChartData || Started');
        lstGlobalAndRegionalTypeProjectData  = new List < GlobalAndRegionalTypeProjectData > ();
       // System.Debug('-------------------------------------- anki 2------------------------------------------------'+selectedScopeCriteriaValue);
        try {
          /*  if(selectedScopeCriteriaValue!=null){
                AggregateResult delayedProjects=null;
                AggregateResult ontrackProjects=null;
                AggregateResult completedProjects=null;
                if(selectedScopeCriteriaValue=='Global' || selectedScopeCriteriaValue=='All'){
                    delayedProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c < 100.00 AND Deadline__c < TODAY AND Project_Scope__c=:selectedScopeCriteriaValue];
                    ontrackProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c < 100.00 AND Deadline__c < TODAY AND Project_Scope__c=:selectedScopeCriteriaValue];
                    completedProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c = 100 AND Project_Scope__c=:selectedScopeCriteriaValue];
                    lstGlobalAndRegionalTypeProjectData.add(new GlobalAndRegionalTypeProjectData(selectedScopeCriteriaValue,(Integer) completedProjects.get('expr0'),(Integer) ontrackProjects.get('expr0'),(Integer) delayedProjects.get('expr0')));                    
                System.Debug('-------------------------------------- anki 3------------------------------------------------'+lstGlobalAndRegionalTypeProjectData.size());
                }
                if(selectedScopeCriteriaValue=='Regional' || selectedScopeCriteriaValue=='All'){
                    delayedProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c < 100.00 AND Deadline__c < TODAY AND Project_Scope__c=:selectedScopeCriteriaValue];
                    ontrackProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c < 100.00 AND Deadline__c < TODAY AND Project_Scope__c=:selectedScopeCriteriaValue];
                    completedProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c = 100 AND Project_Scope__c=:selectedScopeCriteriaValue];            
                    lstGlobalAndRegionalTypeProjectData.add(new GlobalAndRegionalTypeProjectData(selectedScopeCriteriaValue,(Integer) completedProjects.get('expr0'),(Integer) ontrackProjects.get('expr0'),(Integer) delayedProjects.get('expr0')));                                      
                System.Debug('-------------------------------------- anki 4------------------------------------------------'+lstGlobalAndRegionalTypeProjectData.size());
                }
            }*/
                AggregateResult delayedProjects=null;
                AggregateResult ontrackProjects=null;
                AggregateResult completedProjects=null;
                    delayedProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE (PercentComplete__c =null OR PercentComplete__c < 100.00) AND Deadline__c < TODAY AND Project_Scope__c='Global'];
                    ontrackProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE (PercentComplete__c =null OR PercentComplete__c < 100.00) AND Deadline__c >= TODAY AND Project_Scope__c='Global'];
                    completedProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c = 100 AND Project_Scope__c='Global'];
                    lstGlobalAndRegionalTypeProjectData.add(new GlobalAndRegionalTypeProjectData('Global',(Integer) completedProjects.get('expr0'),(Integer) ontrackProjects.get('expr0'),(Integer) delayedProjects.get('expr0')));                    

                    delayedProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE (PercentComplete__c =null OR PercentComplete__c < 100.00) AND Deadline__c < TODAY AND Project_Scope__c='Regional'];
                    ontrackProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE (PercentComplete__c =null OR PercentComplete__c < 100.00) AND Deadline__c >= TODAY AND Project_Scope__c='Regional'];
                    completedProjects = [SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c = 100 AND Project_Scope__c='Regional'];            
                    lstGlobalAndRegionalTypeProjectData.add(new GlobalAndRegionalTypeProjectData('Regional',(Integer) completedProjects.get('expr0'),(Integer) ontrackProjects.get('expr0'),(Integer) delayedProjects.get('expr0')));                                      
        } catch (Exception ex) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(errorMessage);
        }
        System.debug(' CoreNTLandingPageController || addProjectScopeBasedDetailChartData || Completed');
        return lstGlobalAndRegionalTypeProjectData;
    }
    
    List<ProjectLaunchYearData> lstProjectLaunchYearBasedDetailData { get; set; }
    
    public List<ProjectLaunchYearData> getProjectLaunchYearBasedDetailChartData(){
        System.debug(' CoreNTLandingPageController || getProjectLaunchDateBasedDetailChartData || Started');
        lstProjectLaunchYearBasedDetailData= new List < ProjectLaunchYearData> ();
        try {
            List<Integer> lstAllLaunchYear = getAllLaunchYear();
            Integer yearCount=0;
            Integer yearLimit=0;
            If(lstAllLaunchYear.size()<4)
                yearLimit=lstAllLaunchYear.size();
            else
                yearLimit=4;
            while(yearCount<yearLimit){                
                AggregateResult completedProjects=[SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c = 100 AND CALENDAR_YEAR(Deadline__c) =:lstAllLaunchYear[yearCount]];
                AggregateResult ontrackProjects=[SELECT count(Id) FROM CORE_NT_Project__C WHERE (PercentComplete__c =null OR PercentComplete__c < 100.00) AND Deadline__c >= TODAY AND CALENDAR_YEAR(Deadline__c) =:lstAllLaunchYear[yearCount]];
                AggregateResult delayedProjects=[SELECT count(Id) FROM CORE_NT_Project__C WHERE (PercentComplete__c =null OR PercentComplete__c < 100.00) AND Deadline__c < TODAY AND CALENDAR_YEAR(Deadline__c) =:lstAllLaunchYear[yearCount]];
                lstProjectLaunchYearBasedDetailData.add(new ProjectLaunchYearData(String.ValueOf(lstAllLaunchYear[yearCount]),(Integer) completedProjects.get('expr0'),(Integer) ontrackProjects.get('expr0'),(Integer) delayedProjects.get('expr0')));                    
                yearCount++;
            }           
        } catch (Exception ex) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(errorMessage);
        }        
        System.debug(' CoreNTLandingPageController || getProjectLaunchDateBasedDetailChartData || Completed');
        return lstProjectLaunchYearBasedDetailData;
    }
    
    /*
        List<ProjectLaunchYearData> lstProjectLaunchYearBasedDetailData { get; set; }
    public List<ProjectLaunchYearData> getProjectLaunchYearBasedDetailChartData(){
        System.debug(' CoreNTLandingPageController1 || getProjectLaunchDateBasedDetailChartData || Started');
        CORE_NT_Project__C objProject = new CORE_NT_Project__C();
        ApexPages.StandardController stdController = new ApexPages.StandardController(objProject);
        CoreNTLandingPageController1 objProjMgr = new CoreNTLandingPageController1(stdController);
        System.debug(' CoreNTLandingPageController1 || getProjectLaunchDateBasedDetailChartData || Completed');
        return objProjMgr.addProjectLaunchYearBasedDetailChartData();
    }
    
    public List < ProjectLaunchYearData> addProjectLaunchYearBasedDetailChartData() {
        System.debug(' CoreNTLandingPageController1 || addProjectLaunchDateBasedDetailChartData || Started');
        lstProjectLaunchYearBasedDetailData= new List < ProjectLaunchYearData> ();
        try {
            AggregateResult completedProjects=[SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c = 100 AND CALENDAR_YEAR(Deadline__c) = 2014];
            AggregateResult ontrackProjects=[SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c < 100.00 AND Deadline__c > TODAY AND CALENDAR_YEAR(Deadline__c) = 2014];
            AggregateResult delayedProjects=[SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c < 100.00 AND Deadline__c < TODAY AND CALENDAR_YEAR(Deadline__c) = 2014];
            lstProjectLaunchYearBasedDetailData.add(new ProjectLaunchYearData('2014',(Integer) completedProjects.get('expr0'),(Integer) ontrackProjects.get('expr0'),(Integer) delayedProjects.get('expr0')));                    
            
            completedProjects=[SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c = 100 AND CALENDAR_YEAR(Deadline__c) = 2013];
            ontrackProjects=[SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c < 100.00 AND Deadline__c > TODAY AND CALENDAR_YEAR(Deadline__c) = 2013];
            delayedProjects=[SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c < 100.00 AND Deadline__c < TODAY AND CALENDAR_YEAR(Deadline__c) = 2013];
            lstProjectLaunchYearBasedDetailData.add(new ProjectLaunchYearData('2013',(Integer) completedProjects.get('expr0'),(Integer) ontrackProjects.get('expr0'),(Integer) delayedProjects.get('expr0')));                    

            completedProjects=[SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c = 100 AND CALENDAR_YEAR(Deadline__c) = 2012];
            ontrackProjects=[SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c < 100.00 AND Deadline__c > TODAY AND CALENDAR_YEAR(Deadline__c) = 2012];
            delayedProjects=[SELECT count(Id) FROM CORE_NT_Project__C WHERE PercentComplete__c < 100.00 AND Deadline__c < TODAY AND CALENDAR_YEAR(Deadline__c) = 2012];
            lstProjectLaunchYearBasedDetailData.add(new ProjectLaunchYearData('2012',(Integer) completedProjects.get('expr0'),(Integer) ontrackProjects.get('expr0'),(Integer) delayedProjects.get('expr0')));                    

        } catch (Exception ex) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(errorMessage);
        }
        System.debug(' CoreNTLandingPageController1 || addProjectLaunchDateBasedDetailChartData || Completed');
        return lstProjectLaunchYearBasedDetailData;
    }
    */

    // Wrapper class
    public class GlobalAndRegionalTypeProjectData{
        public Integer totalCompletedProjects { get; set; }
        public Integer totalOnTrackProjects { get; set; }
        public Integer totalDelayedProjects { get; set; }
        public String projectType { get; set; }
        public GlobalAndRegionalTypeProjectData(String projectType , Integer totalCompletedProjects, Integer totalOnTrackProjects , Integer totalDelayedProjects ) {
            this.projectType = projectType ;
            this.totalCompletedProjects= totalCompletedProjects;
            this.totalOnTrackProjects = totalOnTrackProjects ;
            this.totalDelayedProjects = totalDelayedProjects ;
        }
    }
    
    // Wrapper class
    public class ProjectLaunchYearData{
        public Integer totalCompletedProjects { get; set; }
        public Integer totalOnTrackProjects { get; set; }
        public Integer totalDelayedProjects { get; set; }
        public String monthName { get; set; }
        public ProjectLaunchYearData(String monthNames , Integer totalCompletedProject, Integer totalOnTrackProject , Integer totalDelayedProject ) {
            monthName = monthNames ;
            totalCompletedProjects= totalCompletedProject;
            totalOnTrackProjects = totalOnTrackProject ;
            totalDelayedProjects = totalDelayedProject ;
        }
    }
    // Wrapper class
    public class TotalProjectDataCounts {
        Integer totalProjectsCounts;
        public String description;
        public TotalProjectDataCounts(Integer totalProjectsCount, String descr) {
            totalProjectsCounts = totalProjectsCount;
            description = descr + ' : ' + totalProjectsCount;
        }
    }

    //Wrapper class
    public class LogedInUserCategoryBasedTasksDetailData {
        public Decimal totalLateTasks { get; set; }
        public Decimal totalOpenTasks { get; set; }
        public Decimal totalClosedTasks { get; set; }
        public String projectName { get; set; }
        public LogedInUserCategoryBasedTasksDetailData(String projectnme, Decimal openTasks, Decimal lateTasks, Decimal closedTasks) {
            projectName = projectnme;
            totalLateTasks = lateTasks;
            totalOpenTasks = openTasks;
            totalClosedTasks = closedTasks;
        }
    }
}