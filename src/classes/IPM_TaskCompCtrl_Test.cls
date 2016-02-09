/******************************************** 
*@Author:Cognizant
*@Date:01/02/2015
*@Description : Test class to test IPM_TaskCompCtrl class functionalities
*********************************************/
@isTest
private class IPM_TaskCompCtrl_Test{
	
    public static User adminUser = IPM_TestFactory_Helper.createUserAdmin(true);
    public static User platformUser;
    public static list<IPM_Project__c> projectList;
    public static list<IPM_Project__c> projectDetailList;
    private static final String  USER_NAME ='PLATFORM_USER';
    private static final String  PROJECT_ID ='Pid';
    
    /***********************************
      @name: projectSetUpData
      @Description: Project Test Data Creation
      @param: none
      @return: none
      @throws: none
    ***********************************/
    @testSetup static void projectSetUpData() 
     {
        System.runAs(adminUser){
            platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
        }
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
         IPM_TestFactory_Helper.getProjectMasterData();
         
         projectList = IPM_TestFactory_Helper.projectSetUp(8,platformUser);
         
         System.runAs(platformUser)
         {
           insert projectList;
         }  
         system.assertEquals(projectList.size(),8,'Projects are not created');
         
      }

    /***********************************
      @name: initializedData
      @Description: Query project,project document
      @param: none
      @return: none
      @throws: none
    ***********************************/
    public static void initializedData(){
        
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3','TestComments4','TestComments5','TestComments6','TestComments7','TestComments8','TestComments9','TestComments10'};
        
        projectDetailList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,
                            (Select Id from Project_Documents__r),
                            (Select Id from IPM_Financials_Consolidated__r ),
                            (Select Id,Name,IPM_Task_Complexity__c,IPM_Project__c,IPM_Function__c,IPM_Section__c from Tasks__r),
                            (Select Id,Name,IPM_Due_Date__c,IPM_Planned_Date__c,IPM_Phase__c from IPM_Milestones__r)
                            from IPM_Project__c where Name in:projectNameSet];
          
        for(IPM_Project__c project : projectDetailList)
        {
            for(IPM_Task__c task : project.Tasks__r)
            {
                system.assertEquals(task.IPM_Task_Complexity__c ,project.IPM_Complexity__c);
            }
       }
    }
    
    /*******************************************************************************************************
    * @description: testMethod to test constructor
    */
   public static testMethod  void taskCompCtrlConstructorTest(){
        User globalUser = [Select Id,LastName from User where LastName=:USER_NAME limit 1];
           
        
        System.runAs(globalUser) {
            Test.startTest(); 
                initializedData();
                
                PageReference pageRef = Page.IPM_ProjectSetUpView;
                Test.setCurrentPageReference(pageRef);
                ApexPages.CurrentPage().getparameters().put('id', projectDetailList[0].Id);
                
                ApexPages.CurrentPage().getparameters().put(PROJECT_ID, projectDetailList[0].Id);
                IPM_TaskCompCtrl controller = new IPM_TaskCompCtrl();
                System.assert(controller.projectId == projectDetailList[0].Id);
            Test.stopTest();
        }
        
    }
   
   /*******************************************************************************************************
    * @description: Testmethod to test task
    */
   public static testmethod void taskTest(){
       User globalUser = [Select Id,LastName from User where LastName=:USER_NAME limit 1];
       System.runAs(globalUser) 
       {
        Test.startTest();
        
        initializedData();
        
        list<IPM_Task__c> tasklist = [Select Id,Name,IPM_Task_Complexity__c,IPM_Project__c,IPM_Function__c,IPM_Section__c,IPM_Phase__c,IPM_Completed__c,IPM_Assignee__c,IPM_Assignee__r.Name from IPM_Task__c where IPM_Project__c=:projectDetailList[1].Id];
        
        ApexPages.currentPage().getParameters().put(PROJECT_ID,projectDetailList[1].Id);
        IPM_TaskCompCtrl ipm = new IPM_TaskCompCtrl();
        
        ipm.setTaskId(tasklist[0].id);
        ipm.setPhase(tasklist[0].id);
        ipm.getPhase();
        system.assertEquals(tasklist[0].id, ipm.getPhase());
        ipm.setUser(userinfo.getuserid());
        ipm.getUser();
        system.assertEquals(userinfo.getuserid(), ipm.getUser());
        
        ipm.getProjectTasks();
        
        system.assertEquals(tasklist[0].id, ipm.getTaskId());
        ipm.toggleDueDate();
        ipm.toggleSortTasks();
        ipm.toggleSortSections();
        ipm.toggleSortPhases();
        ipm.toggleSortCompletion();
        ipm.toggleSortAssignees();
        ipm.getProjectTasks();
        ipm.filteredPhase();
        ipm.filteredUser();
        ipm.filterCompleteTasks();
        ipm.myTasks();
        ipm.myRole();
        ipm.markComplete();
        ipm.deleteTask();
        ipm.markComplete();
        
        ipm.SaveIPMApproach();
        
        
        Map<String,Boolean> phaseTask = new Map<String,Boolean>();
        Boolean phase = false;
        for(IPM_Task__c  currentTask : taskList){
            phaseTask.put(currentTask.IPM_Phase__c, phase );
            phase = true;
        }
        
        ipm.phaseTaskComp = phaseTask;
        ipm.postProcessing(taskList);
    
        ipm.IsTaskEditable = true;//used by security
        ipm.IsAllEditable = true;//used by security
        ipm.UFunctionRole = 'Test';//this property needs to be removed.
        ipm.pmApproachMessage = true;
        ipm.isCreateTask = true;
        ipm.isApproachEdit = true;
        ipm.isChecked = 'true';
         
        ApexPages.currentPage().getParameters().put('pid','Invalid');
        try{
        
        ipm = new IPM_TaskCompCtrl();
        }catch(Exception e){
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assertNotEquals(0, pageMessages.size());

            // Check that the error message you are expecting is in pageMessages
            Boolean messageFound = false;

            for(ApexPages.Message message : pageMessages) {
                 messageFound = true;        
            }
            System.assert(messageFound);
        }

        Test.stopTest();
        }
    }
}