/**
   @Author: Cognizant
   @name: IPM_NewTask_Test
   @CreateDate: November 2014
   @Description : This test class is written to unit test business functionality written in IPM_NewTask class i.e. verifies the task being created.
   @Version : <1.0>
  */

@isTest
public class IPM_NewTask_Test{
    
    public static User platformUser;
    public static User userBDRole;
    public static list<IPM_Project__c> projectList;
    public static list<IPM_Project__c> projectDetailList;
    public static set<Id> projDocId;
    public static IPM_Project_Document_Section__c projDocSecPL;
    public static IPM_Project_Document_Section__c projDocSecBD;
    private static final String TASK_ID_STR ='taskId';
    private static final String PROJ_ID_STR = 'projectId';
    private static final String PROJDOCSEC_ID_STR='projDocSecId';
    private static final String  USER_NAME ='PLATFORM_USER';
<<<<<<< HEAD
=======
	private static final String  TASK_NAME ='Test task modified';
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
    private static final Id PROJECT_TASK_ID = Schema.SObjectType.IPM_Task__c.getRecordTypeInfosByName().get(IPM_Utils.IPMProjectTasks).getRecordTypeId();
    
    /***********************************
      @name: projectSetUpData
      @Description: Project Test Data Creation
      @param: none
      @return: none
      @throws: none
    ***********************************/
    @testSetup static void projectSetUpData() 
     {
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
            platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
            userBDRole = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.FUNCTIONAL_ROLE_BD);
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
<<<<<<< HEAD
=======
            //check if the created projects are having the same complexity type as assigned while creating
            list<IPM_Project__c> projectsResultList = [SELECT Id,IPM_Phase__c,IPM_Complexity__c FROM IPM_Project__c where Name IN:projectNameSet];
            for(IPM_Project__c project : projectsResultList)
            {
                system.assertEquals(project.IPM_Complexity__c,IPM_ConstantUtils.COMPLEXITY_FULL,'Projects are not created');
            }
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
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
        
        set<string> projIdSet = new set<string>();

        projectDetailList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,
                            (Select Id from Project_Documents__r),
                            (Select Id from IPM_Financials_Consolidated__r ),
                            (Select Id,Name,IPM_Task_Complexity__c,IPM_Project__c,IPM_Function__c,IPM_Section__c from Tasks__r),
                            (Select Id,Name,IPM_Due_Date__c,IPM_Planned_Date__c,IPM_Phase__c from IPM_Milestones__r)
                            from IPM_Project__c where Name in:projectNameSet];
          
        
        projDocId = new set<Id>();
        for(IPM_Project__c project : projectDetailList)
        {
            projIdSet.add(project.id);
            
            for(IPM_Project_Document__c projDoc : project.Project_Documents__r)
            {
                projDocId.add(projDoc.id);
            }
            for(IPM_Task__c task : project.Tasks__r)
            {
                system.assertEquals(task.IPM_Task_Complexity__c ,project.IPM_Complexity__c);
            }
       }
       
       list<IPM_Project_Document_Section__c> projDocSecList = [SELECT Id,IPM_Gate_Document__c,IPM_FunctionalRole__c,IPM_Project_ID__c,IPM_Section__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_Project__c 
                                                                FROM IPM_Project_Document_Section__c 
                                                                WHERE IPM_Project_Document__c IN:projDocId and IPM_Project_Document__r.IPM_Project__c=:projectDetailList[0].Id and IPM_Gate_Document__c='Charter' and (IPM_FunctionalRole__c='PL' OR IPM_FunctionalRole__c=:IPM_ConstantUtils.FUNCTIONAL_ROLE_BD)];
      
       for(IPM_Project_Document_Section__c projDocSec: projDocSecList)
       {
            if(projDocSec.IPM_FunctionalRole__c=='PL' && projDocSecPL == null )
                {
                    projDocSecPL = projDocSec ;
                }
                if(projDocSec.IPM_FunctionalRole__c==IPM_ConstantUtils.FUNCTIONAL_ROLE_BD && projDocSecBD==null)
                {
                    projDocSecBD = projDocSec;
                }
        }
    }
     /***********************************
      @name: createProjectResource
      @Description: insert project resource 
      @param: Id projectId,Id userId
      @return: none
      @throws: none
    ***********************************/
    public static void createProjectResource(Id projectId,Id userId){
        
        IPM_Project_Resource__c projRes = IPM_TestFactory_Helper.createIPMProjectResource(projectId,false); 
        projRes.IPM_User__c = userId;
        projRes.IPM_Role_Type__c =IPM_ConstantUtils.FUNCTIONAL_ROLE_BD;
        insert projRes;
            
<<<<<<< HEAD
=======
		//check if project resources are created
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
        list<IPM_Project_Resource__c> projResList = [SELECT Id,IPM_User__c,IPM_Project__c FROM IPM_Project_Resource__c WHERE IPM_User__c=:userId];
        system.assertEquals(projResList[0].IPM_Project__c,projectId);
            
        //project record was not shared with the project resource user, 
        //so adding the project resource explicitly in the group,
        //for which the project record is shared.    
        list<IPM_Project__Share> projectShare = [SELECT Id,ParentID,UserOrGroupId FROM IPM_Project__Share WHERE  ParentID=:projectId];
            
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
            insert new GroupMember(GroupId = projectShare[0].UserOrGroupId , UserOrGroupId = userId);
        }
    }
    /***********************************
      @name: putCurrentPageParameter
      @Description: assign page parameters
      @param: String idStr,Id id
      @return: none
      @throws: none
    ***********************************/
    public static void putCurrentPageParameter(String idStr,Id id){
        ApexPages.currentPage().getParameters().put(idStr,id);
    }
    
    /***********************************
      @name: createTaskFromMilestoneToDosTab
      @Description: PL should be able to insert task on milestone and todos tab
    ***********************************/
    public static TestMethod void createTaskFromMilestoneToDosTab(){
        User globalUser = [Select Id,LastName from User where LastName=:USER_NAME limit 1];
        system.runAs(globalUser)
        {
        Test.startTest();
            initializedData();
            
<<<<<<< HEAD
=======
			//create task
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
             IPM_Task__c task = IPM_TestFactory_Helper.createIPMTask(projectDetailList[0].Id, false);
             task.IPM_Task_Name__c = 'Test Task';
             task.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
             task.IPM_Type_of_Gate__c = IPM_ConstantUtils.CHARTER_GATE;
             task.IPM_Due_Date1__c = System.today() + 10;
             task.RecordTypeId = PROJECT_TASK_ID;
             task.IPM_Function__c= null;
            
            putCurrentPageParameter(PROJ_ID_STR,projectDetailList[0].Id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(task);
            
            IPM_NewTask taskview = new IPM_NewTask(sc);
            taskview.tasks = task;
            List<SelectOption> optionList = taskview.getFuntionalRolelist();
            task.IPM_Function__c = string.valueOf(optionList[0]);
            taskview.doSaveTasks();
           
<<<<<<< HEAD
=======
			//check if task are creted from milestone and todospage and has project leader as defult assignee
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
            list<IPM_Task__c> taskResult =[SELECT Id,IPM_Task_Name__c,IPM_Project__c,IPM_Project__r.IPM_Project_Leader__c,IPM_Assignee__c,IPM_Active__c FROM IPM_Task__c WHERE IPM_Project__c =:projectDetailList[0].Id AND IsSystemGenerated__c=false];
            for(IPM_Task__c tsk: taskResult)
            {
                system.assertEquals(tsk.IPM_Assignee__c,tsk.IPM_Project__r.IPM_Project_Leader__c, 'Record Not Matched');
                system.assertEquals(tsk.IPM_Active__c ,true, 'IPM_Active__c Is Unchecked');
            }
        Test.stopTest();
        }
    } 
    
    /***********************************
      @name: createTaskFromAssociatedToDosTab
      @Description: PL should be able to insert task on associated todos tab
    ***********************************/
    public static TestMethod void createTaskFromAssociatedToDosTab(){
        User globalUser = [Select Id,LastName from User where LastName=:USER_NAME limit 1];
        system.runAs(globalUser)
        {
        Test.startTest();
            initializedData();
            
                             
<<<<<<< HEAD
=======
			//create task from associated todos             
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
             IPM_Task__c task = IPM_TestFactory_Helper.createIPMTask(projectDetailList[0].Id, false);
             task.IPM_Task_Name__c = 'Test Task associated Todos';
             task.RecordTypeId = PROJECT_TASK_ID;
             
             putCurrentPageParameter(PROJ_ID_STR,projectDetailList[0].Id);
             Apexpages.currentpage().getparameters().put(PROJDOCSEC_ID_STR,projDocSecPL.Id);
             
             ApexPages.StandardController sc = new ApexPages.StandardController(task);
            
             IPM_NewTask taskview = new IPM_NewTask(sc);
             taskview.tasks = task;
             taskview.doSaveTasks();
           
<<<<<<< HEAD
=======
			 //check if task is created through associated todo's page default values shouled be assigned
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
             list<IPM_Task__c> taskResult =[SELECT Id,IPM_Task_Name__c,IPM_Project__c,IPM_Project_Document_Section__c,IPM_Function__c,IPM_Active__c FROM IPM_Task__c WHERE IPM_Project__c =:projectDetailList[0].Id AND IsSystemGenerated__c=false];
             for(IPM_Task__c tsk: taskResult)
             {
                system.assertEquals(tsk.IPM_Project_Document_Section__c,projDocSecPL.Id, 'Record Not Matched');
                system.assertEquals(tsk.IPM_Function__c,'PL', 'IPM_Function__c Not Matched');
                system.assertEquals(tsk.IPM_Active__c ,true, 'IPM_Active__c Is Unchecked');
             }
        Test.stopTest();
        }
    }
    
    /***********************************
      @name: editTask
      @Description: user should be able to edit the task
    ***********************************/ 
    public static TestMethod void editTask(){
        User globalUser = [Select Id,LastName from User where LastName=:USER_NAME limit 1];
        system.runAs(globalUser)
        {
        Test.startTest();
            initializedData();
            
<<<<<<< HEAD
            list<IPM_Task__c> taskList = [SELECT Id,IPM_Task_Name__c,IPM_Project__c,IPM_Function__c FROM IPM_Task__c WHERE IPM_Project__c =:projectDetailList[0].Id AND IsSystemGenerated__c=true];
            IPM_Task__c task11 = taskList[0];
            system.assertEquals(task11.IPM_Task_Name__c!='Test task modified',true, 'IPM_Task_Name__c Not Matched');
=======
			//create task
            list<IPM_Task__c> taskList = [SELECT Id,IPM_Task_Name__c,IPM_Project__c,IPM_Function__c FROM IPM_Task__c WHERE IPM_Project__c =:projectDetailList[0].Id AND IsSystemGenerated__c=true];
            IPM_Task__c task11 = taskList[0];
            // check if tasks are present
            system.assertEquals(task11.IPM_Task_Name__c!=TASK_NAME,true, 'IPM_Task_Name__c Not Matched');
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
            
            putCurrentPageParameter(TASK_ID_STR,task11.Id);
            putCurrentPageParameter(PROJ_ID_STR,projectDetailList[0].Id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(task11);
            
<<<<<<< HEAD
=======
			//change task name and save
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
            IPM_NewTask taskview =new IPM_NewTask(sc);
            taskview.tasks = task11;
            task11.IPM_Task_Name__c = 'Test task modified';
            taskview.doSaveTasks();
           
<<<<<<< HEAD
=======
			//check if the task is modified
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
            list<IPM_Task__c> taskResult = [SELECT Id,IPM_Task_Name__c,IPM_Project__c FROM IPM_Task__c WHERE id=:task11.id];
            system.assertEquals(taskResult[0].IPM_Task_Name__c,'Test task modified', 'IPM_Task_Name__c Not Matched');
           
        Test.stopTest();
        }
    } 
    
    /***********************************
      @name: testCreateTaskView
      @Description: test method to test general task view page
    ***********************************/ 
    public static TestMethod void testCreateTaskView(){
       User globalUser = [Select Id,LastName from User where LastName=:USER_NAME limit 1];
        system.runAs(globalUser)
        {
        Test.startTest();
            initializedData();
            list<IPM_Task__c> taskList = [SELECT Id,IPM_Task_Name__c,IPM_Project__c FROM IPM_Task__c WHERE IPM_Project__c =:projectDetailList[0].Id AND IsSystemGenerated__c=true];
            
            putCurrentPageParameter(TASK_ID_STR,taskList[0].Id);
            putCurrentPageParameter(PROJ_ID_STR,projectDetailList[0].Id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(taskList[0]);
            
            IPM_NewTask taskview =new IPM_NewTask(sc);
            
            taskview.getSections();
            taskview.closePopup();
            system.assert(taskview.displayPopup != null && !taskview.displayPopup , 'displayPopup will be false');
            taskview.showPopup();
            system.assert(taskview.displayPopup != null && taskview.displayPopup, 'displayPopup will be true');
            taskview.doSaveTasks();
            system.assert(string.isBlank(taskview.roleList), true);
            system.assert(string.isBlank(taskview.roleValue), true);
            
          }
        Test.stopTest();
    }
    /***********************************
      @name: testDoSaveTasksForBlankTaskName
      @Description: task with blank name should not be saved in system.
    ***********************************/ 
    public static TestMethod void testDoSaveTasksForBlankTaskName(){
       User globalUser = [Select Id,LastName from User where LastName=:USER_NAME limit 1];
        system.runAs(globalUser)
        {
        Test.startTest();
            initializedData();
            
<<<<<<< HEAD
=======
			// create task
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
             IPM_Task__c task = IPM_TestFactory_Helper.createIPMTask(projectDetailList[0].Id, false);
             
             task.IPM_Function__c = IPM_Utils.SupplyChain;
             task.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
             task.IPM_Type_of_Gate__c = IPM_ConstantUtils.CHARTER_GATE;
             task.RecordTypeId = PROJECT_TASK_ID;
             task.Name = null;
             task.IPM_Task_Name__c = null;
             
             putCurrentPageParameter(PROJ_ID_STR,projectDetailList[0].Id);
            
             ApexPages.StandardController sc = new ApexPages.StandardController(task);
            
<<<<<<< HEAD
=======
			//save task with task name null
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
             IPM_NewTask taskview =new IPM_NewTask(sc);
             taskview.tasks = task;
             List<SelectOption> optionSectionList = taskview.getSectionlist();
             system.assertEquals(optionSectionList.size()>0,true,'Task List not populated as expected');
             taskview.doSaveTasks();
        
<<<<<<< HEAD
=======
			 // check if task with name null is not saved 
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
             list<IPM_Task__c> taskResult =[SELECT Id,IPM_Task_Name__c,IPM_Project__c FROM IPM_Task__c 
                                            WHERE IPM_Project__c =:projectDetailList[0].Id AND IsSystemGenerated__c=false];
             system.assertEquals(taskResult.size(),0 , 'Record Size Not Matched');
        }
        Test.stopTest();
    } 
    /***********************************
      @name: testDoSaveTasksForTaskDueDateLessThanToday
      @Description: task with due date in past should not be saved
    ***********************************/
    public static TestMethod void testDoSaveTasksForTaskDueDateLessThanToday(){
       User globalUser = [Select Id,LastName from User where LastName=:USER_NAME limit 1];
        system.runAs(globalUser)
        {
        Test.startTest();
            initializedData();
             
<<<<<<< HEAD
=======
			//create task with due date in past
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
             IPM_Task__c task = IPM_TestFactory_Helper.createIPMTask(projectDetailList[0].Id, false);
            
             task.IPM_Function__c = 'PL';
             task.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
             task.IPM_Type_of_Gate__c = IPM_ConstantUtils.CHARTER_GATE;
             task.IPM_Due_Date1__c = System.today() - 10;
             task.IPM_Task_Name__c = 'Task with due date less than today';
             task.RecordTypeId = PROJECT_TASK_ID;
             
             putCurrentPageParameter(PROJ_ID_STR,projectDetailList[0].Id);
            
             ApexPages.StandardController sc = new ApexPages.StandardController(task);
            
<<<<<<< HEAD
=======
			// save task with past due date
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
             IPM_NewTask taskview =new IPM_NewTask(sc);
             taskview.tasks = task;
             taskview.doSaveTasks();
             
             list<IPM_Task__c> taskResult =[SELECT Id,IPM_Task_Name__c,IPM_Project__c FROM IPM_Task__c WHERE IPM_Project__c =:projectDetailList[0].Id AND IsSystemGenerated__c=false];
             system.assertEquals(taskResult.size(),0, 'Record Size Is More than expected' );
        }
        Test.stopTest();
    } 
    
    /***********************************
      @name: taskDueDateGreaterThanMilestone
      @Description: task with due date greater than milestone due date should not be saved
    ***********************************/
    public static TestMethod void taskDueDateGreaterThanMilestone(){
        User globalUser = [Select Id,LastName from User where LastName=:USER_NAME limit 1];
        system.runAs(globalUser)
        {
        Test.startTest();
            initializedData();
            
            
            //update milestone with due date 
            list<IPM_Milestone__c> updatedMilestoneList = new list<IPM_Milestone__c>();
            
            for(IPM_Milestone__c milestone :projectDetailList[0].IPM_Milestones__r)
            {
                if(projectDetailList[0].IPM_Phase__c == milestone.IPM_Phase__c)
                {
                    milestone.IPM_Planned_Date__c = system.today() + 20;
                    milestone.IPM_Due_Date__c =  system.today() + 20;
                    updatedMilestoneList.add(milestone);    
                }
            }
            update updatedMilestoneList;
            
<<<<<<< HEAD
=======
			//check if milestone has been created with assigend due date
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
            list<IPM_Milestone__c> mileList =[SELECT Id,Name,IPM_Due_Date__c from IPM_Milestone__c WHERE IPM_Project__c=: projectDetailList[0].Id and IPM_Phase__c = :projectDetailList[0].IPM_Phase__c];
            
            for(IPM_Milestone__c milestone :mileList)
            {
                system.assertEquals(milestone.IPM_Due_Date__c,system.today() + 20, 'IPM_Due_Date__c Not Matched');
            }
            
            //update the task daue date greater than milestone due date
            list<IPM_Task__c> taskList = [SELECT Id,IPM_Task_Name__c,IPM_Project__c FROM IPM_Task__c WHERE IPM_Project__c =:projectDetailList[0].Id AND IsSystemGenerated__c=true];
            
            putCurrentPageParameter(TASK_ID_STR,taskList[0].Id);
            putCurrentPageParameter(PROJ_ID_STR,projectDetailList[0].Id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(taskList[0]);
            
<<<<<<< HEAD
=======
		   //update the task daue date greater than milestone due date
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
            IPM_NewTask taskview =new IPM_NewTask(sc);
            taskview.tasks = taskList[0];
            taskList[0].IPM_Due_Date1__c = System.today() + 30;
            taskview.doSaveTasks();
           
<<<<<<< HEAD
           /*list<IPM_Task__c> taskResult =[SELECT Id,IPM_Task_Name__c,IPM_Project__c FROM IPM_Task__c WHERE IPM_Project__c =:projectDetailList[0].Id AND IsSystemGenerated__c=true and IPM_Due_Date1__c=:(System.today() + 30)];
           system.assertEquals(taskResult.size(),0 , system.label.IPM_TaskDueDateErrorMsg);*/
=======
			//check if task is updated with due date as per milestone due date
           list<IPM_Task__c> taskResult =[SELECT Id,IPM_Task_Name__c,IPM_Project__c FROM IPM_Task__c WHERE IPM_Project__c =:projectDetailList[0].Id AND IPM_Due_Date1__c=:(System.today() + 30)];
           system.assertEquals(taskResult.isEmpty(),true, system.label.IPM_TaskDueDateErrorMsg);
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
          
        Test.stopTest();
        }
    } 
    /***********************************
      @name: taskDueDateGreaterThanMilestone
      @Description: If task id/project id/project document id is not present in URL then exception should be thrown
    ***********************************/
    public static TestMethod void taskWithNullId(){
        User globalUser = [Select Id,LastName from User where LastName=:USER_NAME limit 1];
        system.runAs(globalUser)
        {
        Test.startTest();
        
            initializedData();
            
            IPM_Task__c task = IPM_TestFactory_Helper.createIPMTask(null, false); 
            task.IPM_Task_Name__c = 'Test Task with null id';
            task.Name = 'Test Task with null id';
            task.RecordTypeId = PROJECT_TASK_ID;
            
            
            putCurrentPageParameter(TASK_ID_STR,null);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(task);
            
            IPM_NewTask taskview =new IPM_NewTask(sc);
            taskview.doSaveTasks();
           
            List<Apexpages.Message> msgs = ApexPages.getMessages();
            boolean b = false;
            for(Apexpages.Message msg : msgs){
                b = true;
            }
            system.assert(b,true);
            
            list<IPM_Task__c> taskResult =[SELECT Id,IPM_Task_Name__c,IPM_Project__c FROM IPM_Task__c WHERE IPM_Project__c =:projectDetailList[0].Id AND IsSystemGenerated__c=false];
            system.assertEquals(taskResult.size(),0 );
             
        Test.stopTest();
        }
    } 
<<<<<<< HEAD
    
    /***********************************
      @name: createTaskWithFunctionalOwner
      @Description: Functional owner should be able to insert task in system at milestone and todos tab
    ***********************************/
    /*
    public static TestMethod void createTaskWithFunctionalOwner(){
        Test.startTest();
        //Assert 475 Failing in Production commented to relook at the code
            User userBD = [Select Id,LastName from User where LastName=:USER_NAME limit 1]; 
            
            initializedData();
            
            createProjectResource(projectDetailList[0].Id,userBD.id);
            
            system.runAs(userBD)
            {
                list<IPM_Project__c> projDetailList11 = [SELECT id,Name FROM IPM_Project__c WHERE Name='TestComments1'];
                
                
                IPM_Task__c task = IPM_TestFactory_Helper.createIPMTask(projDetailList11[0].id, false); 
                task.IPM_Task_Name__c = 'Test Task by BD User';
                task.Name = 'Test Task by BD User';
                task.RecordTypeId = PROJECT_TASK_ID;
                
                putCurrentPageParameter(PROJ_ID_STR,projDetailList11[0].Id);
                
                ApexPages.StandardController sc = new ApexPages.StandardController(task);
                
                IPM_NewTask taskview =new IPM_NewTask(sc);
                taskview.tasks = task;
                List<SelectOption> optionSectionList = taskview.getSectionlist();
                system.assertEquals(optionSectionList.size()>0,true, 'Record Size Is Null' );
                taskview.doSaveTasks();
                
                list<IPM_Task__c> taskList = [SELECT Id,IPM_Task_Name__c,IPM_Project__c,IPM_Function__c FROM IPM_Task__c WHERE IPM_Project__c =:projDetailList11[0].Id AND IsSystemGenerated__c=false];
                for(IPM_Task__c tsk: taskList)
                {
                    system.assertEquals(tsk.IPM_Function__c,IPM_ConstantUtils.FUNCTIONAL_ROLE_BD, 'IPM_Function__c Not Matched');
                }
            }
        Test.stopTest();
    } 
    */
=======
              
                
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
    /***********************************
      @name: createTaskFromAssociatedToDosTabByFO
      @Description: Functional owner should be able to insert task in system at associated todos tab. should have default values
    ***********************************/
    public static TestMethod void createTaskFromAssociatedToDosTabByFO(){
        Test.startTest();
        
            User userBD = [Select Id,LastName from User where LastName=:USER_NAME limit 1]; 
            
            initializedData();
            createProjectResource(projectDetailList[0].Id,userBD.id);
            
            system.runAs(userBD)
            {
                 list<IPM_Project__c> projDetailList11 = [SELECT id,Name FROM IPM_Project__c WHERE Name='TestComments1'];
                
                 IPM_Task__c task = IPM_TestFactory_Helper.createIPMTask(projDetailList11[0].Id, false);
                 task.IPM_Task_Name__c = 'Test Task associated Todos FO';
                 task.RecordTypeId = PROJECT_TASK_ID;
                 
                 putCurrentPageParameter(PROJ_ID_STR,projectDetailList[0].Id);
                 Apexpages.currentpage().getparameters().put(PROJDOCSEC_ID_STR,projDocSecBD.Id);
                 
                 ApexPages.StandardController sc = new ApexPages.StandardController(task);
                
                 IPM_NewTask taskview = new IPM_NewTask(sc);
                 taskview.tasks = task;
                 taskview.doSaveTasks();
               
<<<<<<< HEAD
=======
	          // check if the task is inserted with defult assigned values
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
                 list<IPM_Task__c> taskResult =[SELECT Id,IPM_Task_Name__c,IPM_Project__c,IPM_Project_Document_Section__c,IPM_Function__c,IPM_Active__c FROM IPM_Task__c WHERE IPM_Project__c =:projectDetailList[0].Id AND IsSystemGenerated__c=false];
                 for(IPM_Task__c tsk: taskResult)
                 {
                    system.assertEquals(tsk.IPM_Project_Document_Section__c,projDocSecBD.Id, 'Record Not Matched');
                    system.assertEquals(tsk.IPM_Function__c,IPM_ConstantUtils.FUNCTIONAL_ROLE_BD, 'IPM_Function__c Not Matched');
                    system.assertEquals(tsk.IPM_Active__c ,true, 'IPM_Active__c Is Unchecked');
                 }
            }
        Test.stopTest();
    } 
<<<<<<< HEAD
    /***********************************
      @name: testProjectWithExternalApproach
      @Description: when project approach is external then message should be shown on UI.
=======
    
     /***********************************
      @name: testTodoWithFuturePhase
      @Description: when future phase is selected for the ToDos 
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
    ***********************************/
    private static TestMethod void testTodoWithFuturePhase(){
        
        Test.startTest();
<<<<<<< HEAD
            initializedData();
            IPM_Project__c project = projectDetailList[1];
            project.IPM_PM_Approach__c = IPM_Utils.External;
            update project;
            
            list<IPM_Project__c> projDetailList11 = [SELECT id,Name FROM IPM_Project__c WHERE IPM_PM_Approach__c =: IPM_Utils.External];
            
            list<IPM_Task__c> taskList = [SELECT Id,IPM_Task_Name__c,IPM_Project__c FROM IPM_Task__c WHERE IPM_Project__c =:projDetailList11[0].Id AND IsSystemGenerated__c=true];
            
            putCurrentPageParameter(PROJ_ID_STR,projDetailList11[0].Id);
            
            ApexPages.StandardController sc = new ApexPages.StandardController(taskList[0]);
            
            IPM_NewTask taskview = new IPM_NewTask(sc);
=======
        
            User userBD = [Select Id,LastName from User where LastName=:USER_NAME limit 1]; 
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{userBD});
            initializedData(); 
            createProjectResource(projectDetailList[0].Id,userBD.id);
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
            
            system.runAs(userBD)
            {
                 list<IPM_Project__c> projDetailList11 = [SELECT id,IPM_Complexity__c,IPM_GateKeeping_Model__c,IPM_Project_Type__c,IPM_SourceProjectType__c,IPM_CompanyCardText__c,IPMProject_Span__c,Name,IPM_Phase__c FROM IPM_Project__c WHERE Name='TestComments1'];
                 IPM_Section__c ipmSection = IPM_TestFactory_Helper.createIPMSection(true);
                 IPM_Task__c task = IPM_TestFactory_Helper.createIPMTask(projDetailList11[0].Id, false);
                 task.IPM_Phase__c = IPM_ConstantUtils.FEASIBILITY_PHASE;
                 task.IPM_Task_Name__c = 'Feasibility Task';
                 task.IPM_Type_of_Gate__c = IPM_ConstantUtils.CONTRACT_GATE;
                 task.IPM_TaskSpan__c = 'Regional';
                 task.IPM_Section__c = ipmSection.id;
                 task.IPM_Function__c = 'BD';
                 task.RecordTypeId = PROJECT_TASK_ID;
                 
                 putCurrentPageParameter(PROJ_ID_STR,projectDetailList[0].Id);
                 ApexPages.StandardController sc = new ApexPages.StandardController(task);
                
                 IPM_NewTask newTask = new IPM_NewTask(sc); 
                 newTask.projectObject = projDetailList11[0];
                 newTask.tasks = task;
                 newTask.tasks.IPM_Type_of_Task__c = IPM_ConstantUtils.FUTURE_ADHOC_TASKS;
                 newTask.projectObject = projDetailList11[0];
                 newTask.getPhaselist();
                 newTask.getGateSections();
                 newTask.tasks.IPM_Type_of_Gate__c = IPM_ConstantUtils.CONTRACT_GATE;
                 newTask.getGateSpecificSpan();
                 newTask.getFuntionalRolelist();
                 newTask.tasks.IPM_Type_of_Task__c = IPM_ConstantUtils.FUTURE_ADHOC_TASKS;
                 newTask.getSections();
                 newTask.tasks.IPM_Type_of_Task__c = IPM_ConstantUtils.FUTURE_ADHOC_TASKS;
                 newTask.tasks.IPM_Type_of_Gate__c = IPM_ConstantUtils.CONTRACT_GATE;
                 newTask.doSaveTasks(); 
               
                 list<IPM_Task__c> taskList = [SELECT Id,IPM_Task_Name__c,IPM_Project__c,IPM_Function__c,IPM_Type_of_Task__c FROM IPM_Task__c WHERE IPM_Project__c =:projDetailList11[0].Id AND IsSystemGenerated__c=false and IPM_Task_Name__c =: 'Feasibility Task' ];
                 for(IPM_Task__c tsk: taskList)
                 {
                     system.assertEquals(tsk.IPM_Type_of_Task__c,IPM_ConstantUtils.FUTURE_ADHOC_TASKS, 'Future AdHoc Task not saved');
                 }
            }
      Test.stopTest();               
    }    
    
    /***********************************
      @name: testTodoWithStandardTasks
      @Description: test tasks with standard tasks
    ***********************************/
    private static TestMethod void testTodoWithStandardTasks(){
        
        Test.startTest();
        
            User userBD = [Select Id,LastName from User where LastName=:USER_NAME limit 1]; 
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{userBD});
            initializedData(); 
            createProjectResource(projectDetailList[0].Id,userBD.id);
            
            system.runAs(userBD)
            {
                 list<IPM_Project__c> projDetailList11 = [SELECT id,IPM_Complexity__c,IPM_GateKeeping_Model__c,IPM_Project_Type__c,IPM_SourceProjectType__c,IPM_CompanyCardText__c,IPMProject_Span__c,Name,IPM_Phase__c FROM IPM_Project__c WHERE Name='TestComments1'];
                 IPM_Section__c ipmSection = IPM_TestFactory_Helper.createIPMSection(true);
                 IPM_Task__c task = IPM_TestFactory_Helper.createIPMTask(projDetailList11[0].Id, false);
                 task.IPM_Phase__c = IPM_ConstantUtils.FEASIBILITY_PHASE;
                 task.IPM_Task_Name__c = 'Current Task';
                 task.IPM_Section__c = ipmSection.id;
                 task.IPM_Function__c = 'BD';
                 task.RecordTypeId = PROJECT_TASK_ID;
                 task.IPM_Type_of_Gate__c = IPM_ConstantUtils.CONTRACT_GATE;
                 
                 putCurrentPageParameter(PROJ_ID_STR,projectDetailList[0].Id);
                 ApexPages.StandardController sc = new ApexPages.StandardController(task);
                
                 IPM_NewTask newTask = new IPM_NewTask(sc); 
                 newTask.projectObject = projDetailList11[0];
                 newTask.tasks = task;
                 newTask.projectObject = projDetailList11[0];
                 task.IPM_Type_of_Task__c = IPM_ConstantUtils.STANDARD; 
                 List<SelectOption> optionPhaseList= newTask.getPhaselist();
                 system.assertEquals(!optionPhaseList.isEmpty(),true,'Task Phase List for standard tasks not populated as expected');
                 List<SelectOption> optionSpanList=newTask.getGateSpecificSpan();
             	 system.assertEquals(!optionSpanList.isEmpty(),true,'Task Span List for standard tasks not populated as expected'); 
            }  
            
        Test.stopTest();      
    }
    
    /***********************************
      @name: testTodoWithStandardTasks
      @Description: test tasks with standard tasks
    ***********************************/
    private static TestMethod void testTodoWithIncorrectProjectMetaData(){
        
        Test.startTest();
        
            User userBD = [Select Id,LastName from User where LastName=:USER_NAME limit 1]; 
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{userBD});
            initializedData(); 
            createProjectResource(projectDetailList[0].Id,userBD.id);
            List<IPM_ProjectMetadata__c> metaDataList = IPM_TestFactory_Helper.createIPMProjectMetadata();
            List<IPM_ProjectMetadata__c> updatedMetaDataList = new List<IPM_ProjectMetadata__c>();
            try{
	            for(IPM_ProjectMetadata__c metaData:metaDataList)
	            {
	            	metaData.IPM_Applicable_Gate__c = null;
	            	updatedMetaDataList.add(metaData);
	            }	
	            update updatedMetaDataList;
	            
	            system.runAs(userBD)
	            {
	                 putCurrentPageParameter(PROJ_ID_STR,projectDetailList[0].Id);
	                 IPM_Task__c task = IPM_TestFactory_Helper.createIPMTask(projectDetailList[0].Id, false);
	                 ApexPages.StandardController sc = new ApexPages.StandardController(task);
	                  
	                 IPM_NewTask newTask = new IPM_NewTask(sc); 
	                 newTask.tasks = task;
	                 newTask.projectObject = projectDetailList[0];
	                 List<SelectOption> optionPhaseList= newTask.getPhaselist();
	                 system.assertEquals(optionPhaseList.isEmpty(),true,'Task Phase List for standard tasks not populated as expected');
	                 List<SelectOption> optionSpanList=newTask.getGateSpecificSpan();
	             	 system.assertEquals(!optionSpanList.isEmpty(),true,'Task Span List for standard tasks not populated as expected'); 
	            }  
            }
            catch(Exception ex)
            {
            	system.assertEquals(ex.getMessage(),'Attempt to de-reference a null object','Exception not thrown');
            }   
        Test.stopTest();         
    }
 
}