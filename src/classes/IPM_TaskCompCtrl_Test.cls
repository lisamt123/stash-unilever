/******************************************** 
*@Author:Cognizant
*@Date:01/02/2015
*@Description : Test class to test IPM_TaskCompCtrl class functionalities
*********************************************/
@isTest
private class IPM_TaskCompCtrl_Test{
	
    private static User adminUser = IPM_TestFactory_Helper.createUserAdmin(true);
    private static User platformUser;
    private static list<IPM_Project__c> projectList;
    private static list<IPM_Project__c> projectDetailList;
    private static final String  USER_NAME ='PLATFORM_USER';
    private static final String  PROJECT_ID ='Pid';
	private static final Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3','TestComments4','TestComments5','TestComments6','TestComments7','TestComments8'};
    
    /***********************************
      @name: projectSetUpData
      @Description: Project Test Data Creation
      @param: none
      @return: none
      @throws: none
    ***********************************/
    @testSetup static void projectSetUpData() 
     {
		//create user
        System.runAs(adminUser){
            platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
        }
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
		//get project's master data
         IPM_TestFactory_Helper.getProjectMasterData();
         
         projectList = IPM_TestFactory_Helper.projectSetUp(8,platformUser);
         
         System.runAs(platformUser)
         {
           insert projectList;
         }  
         system.assertEquals(projectList.size(),8,'Projects are not created');
         
  
           //check if the created projects are having the same complexity type as assigned while creating
          list<IPM_Project__c> projectsResultList = [SELECT Id,IPM_Phase__c,IPM_Complexity__c FROM IPM_Project__c where Name IN:projectNameSet];
          for(IPM_Project__c project : projectsResultList)
          {
                system.assertEquals(project.IPM_Complexity__c,IPM_ConstantUtils.COMPLEXITY_FULL,'Project is not created');
          }
         
      }

    /***********************************
      @name: initializedData
      @Description: Query project,project document
      @param: none
      @return: none
      @throws: none
    ***********************************/
    public static void initializedData(){
        
        projectDetailList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,
                            (Select Id from Project_Documents__r),
                            (Select Id from IPM_Financials_Consolidated__r ),
                            (Select Id,Name,IPM_Task_Complexity__c,IPM_Project__c,IPM_Function__c,IPM_Section__c from Tasks__r),
                            (Select Id,Name,IPM_Due_Date__c,IPM_Planned_Date__c,IPM_Phase__c from IPM_Milestones__r)
                            from IPM_Project__c where Name in:projectNameSet];
          
		//check if task is having the same complexity as that of project's complexity 
        for(IPM_Project__c project : projectDetailList)
        {
            for(IPM_Task__c task : project.Tasks__r)
            {
                system.assertEquals(task.IPM_Task_Complexity__c ,project.IPM_Complexity__c,'Task Complexity is not same as projects complexity.');
            }
       }
    }
    
    /****************************************************
     *  @name: initializedData
     *  @description: testMethod to test constructor

    ****************************************************/
   public static testMethod  void taskCompCtrlConstructorTest(){
        //get user as PL
        User globalUser = [Select Id,LastName from User where LastName=:USER_NAME limit 1];
           
        //Run as PL
        System.runAs(globalUser) {
            Test.startTest(); 
                initializedData();
                
                //Set  page with current project id
                PageReference pageRef = Page.IPM_ProjectSetUpView;
                Test.setCurrentPageReference(pageRef);
                ApexPages.CurrentPage().getparameters().put('id', projectDetailList[0].Id);
                
                ApexPages.CurrentPage().getparameters().put(PROJECT_ID, projectDetailList[0].Id);
                IPM_TaskCompCtrl controller = new IPM_TaskCompCtrl();
                //check if the page is set with expected project id
                system.assertEquals(true,controller.projectId == projectDetailList[0].Id,'Page is not set for expected project id');
            Test.stopTest();
        }
        
    }
   
  
   /******************************************************
    * @name: taskTest
    * @description: test general task functionality

   ****************************************************/
   public static testmethod void taskTest(){
       //get user
       User globalUser = [Select Id,LastName from User where LastName=:USER_NAME limit 1];
       
       //run as PL
       System.runAs(globalUser) 
       {
        Test.startTest();
        
        initializedData();
        
        //Get task list for the project 
        list<IPM_Task__c> tasklist = [Select Id,Name,IPM_Task_Complexity__c,IPM_Project__c,IPM_Function__c,IPM_Section__c,IPM_Phase__c,IPM_Completed__c,IPM_Assignee__c,IPM_Assignee__r.Name from IPM_Task__c where IPM_Project__c=:projectDetailList[1].Id];
        
		//set current page with project id
        ApexPages.currentPage().getParameters().put(PROJECT_ID,projectDetailList[1].Id);
        IPM_TaskCompCtrl ipm = new IPM_TaskCompCtrl();
        
        ipm.setTaskId(tasklist[0].id);
        ipm.setPhase(tasklist[0].id);
        ipm.getPhase();
        system.assertEquals(tasklist[0].id, ipm.getPhase(),'task phase is not same');
		ipm.setUser(userinfo.getuserid());
        ipm.getUser();
        
        system.assertEquals(userinfo.getuserid(), ipm.getUser(),'User is not same');
        
		ipm.getProjectTasks();//get project specific task
        system.assertEquals(tasklist[0].id, ipm.getTaskId(),'tasks are not same');
                
		ipm.toggleDueDate();//sort with due date
        ipm.toggleSortTasks();//sort with task name
        ipm.toggleSortSections();//sort with task section
        ipm.toggleSortPhases();//sort with phase
        ipm.toggleSortCompletion();//sort with completed or incompleted
        ipm.toggleSortAssignees();//sort with user
        ipm.getProjectTasks();//get project tasks
        ipm.filteredPhase();//filter by phase
        ipm.filteredUser();//filter by user
        ipm.filterCompleteTasks();//filter by completed or imcomplted fileld
        ipm.myTasks();//task assigned to current user
        ipm.myRole();//task belogs to current user's role
        ipm.markComplete();//mark task as completed
        ipm.deleteTask();//delete task
        ipm.markComplete();//mark task as completed
        ipm.SaveIPMApproach();//change project approch
        ipm.postProcessing(taskList);//TASK LIST FOR POST PROCESSING
                
	//used by security		
	ipm.IsTaskEditable = true;//used by security
        ipm.IsAllEditable = true;//used by security
        ipm.UFunctionRole = 'Test';//this property needs to be removed.
        ipm.pmApproachMessage = true;
        ipm.isCreateTask = true;
        ipm.isApproachEdit = true;
        ipm.isChecked = 'true';
         
		 //when project id is not valid then page message should appear
        ApexPages.currentPage().getParameters().put('pid','Invalid');
        try{
        
        ipm = new IPM_TaskCompCtrl();
		System.assertEquals(ipm, null,'error has occured while instantiating');
        }catch(Exception e){
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assertNotEquals(0, pageMessages.size());

            // Check that the error message you are expecting is in pageMessages
            Boolean messageFound = false;

            for(ApexPages.Message message : pageMessages) {
                 messageFound = true;        
            }
             System.assertEquals(true,messageFound,'page message is not displayed');
        }

        Test.stopTest();
        }
    }
}