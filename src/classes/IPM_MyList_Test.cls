/******************************************** 
*@Author:Cognizant
*@Date:01/02/2015
*@Description : Test class for IPM_MyList class functionalities
*/


@istest
private class IPM_MyList_Test{
    
    private static User platformUser;
    private static User BDUser;
    private static User adminUser = IPM_TestFactory_Helper.createUserAdmin(true);
    private static list<IPM_Project__c> projectList;
    private static list<IPM_Project_Resource__c> projResourceList;
    private static IPM_MyList taskListTest ;
    private static Set<Id> projIdSet;
    private static List<IPM_Project__c> projectDetailList;
    private static final String  GLOBAL_PL ='GLOBAL_PL';
    private static final String  GLOBAL_BD ='GLOBAL_BD';
    private static Boolean message;
    private static Boolean exceptn;
    private static final String projectToSearch = 'TestComments1';
    private static final String sAssertionMsgForTaskBeingUpdated = '8 tasks are not being updated';
    private static final String sAssertionMsgForTaskBeingCreated  = 'tasks are not inserted';
    private static final String sProjectToBeSearched  = 'abc';
    private static final String sProjectToBeSearchedIn  = 'abcd';
    /*
    @description:  This method is used for Initializing the test data
    */ 
     @testSetup static void projectSetUpData() 
     {
        System.runAs(adminUser){
            platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            platformUser.lastname = GLOBAL_PL;
            platformUser.TimeZoneSidKey = UserInfo.getTimeZone().getID();
            
            BDUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            BDUser.lastname = GLOBAL_BD;
             
            List<User> userList = new List<User>{platformUser,BDUser};
            update userList;
            System.assertEquals(2, [Select count() from User where lastname IN (:GLOBAL_PL, :GLOBAL_BD) limit 100], 'User information is not updated properly.');
        }
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        System.assertEquals(3, [Select count() from IPM_Company_Card__c limit 100], '3 Company cards are not inserted.');
         IPM_TestFactory_Helper.getProjectMasterData();
         
         // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
         IPM_TestFactory_Helper.shareMasterProject(new List<User>{platformUser}); 
         
         projectList = IPM_TestFactory_Helper.projectSetUp(8,platformUser);
         System.runAs(platformUser)
         {
           insert projectList;
         }
         List<IPM_Project__c> projectDBList = [Select id from IPM_Project__c limit 1000];
           
         system.assertEquals(9 , projectDBList.size(),'Projects are not created');
      }
      
      /*
     @description:  This method is used to get all the tasks associated with the test projects created so far.
    */ 
    /**Sonar Issue Comment:- Please note this is not a testmethod, so Test.startTest/Test.stopTest and System.runAs() is not used in this method.
    Test.startTest/Test.stopTest and System.runAs() is used in testmethods from where this method is called.
    */
      private static list<IPM_Task__c> getTaskList()
      {
      	
        list<IPM_Task__c> taskList;
        projIdSet =  new Set<Id>();
        projResourceList = new list<IPM_Project_Resource__c>();
        
        
            Set<String> projectNameSet = new Set<String>{projectToSearch,'TestComments2','TestComments3','TestComments4','TestComments5','TestComments6','TestComments7','TestComments8','TestComments9','TestComments10'};
            projectDetailList = [Select Id,IPM_Phase__c,Name,IPM_PM_Approach__c,IPM_Complexity__c,(Select Id from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r ),
                    (Select Id,Name,IPM_Assignee__c,IPM_Due_Date1__c,IPM_Completed__c,IPM_Project__r.Is_Archieved__c,IPM_Task_Complexity__c,IPM_Project__c,IPM_Project_Document_Section__c,IPM_Function__c,IPM_Section__c, IPM_Type_of_Gate__c from Tasks__r),(Select Id,Name from IPM_Milestones__r)
                    from IPM_Project__c where Name in:projectNameSet limit 100];
            for(IPM_Project__c project: projectDetailList){
                projIdSet.add(project.id);
            }
            taskList = new list<IPM_Task__c>();
            
            for(IPM_Project__c project : projectDetailList)
            {
                for(IPM_Task__c task : project.Tasks__r)
                {
                    system.assertEquals(task.IPM_Task_Complexity__c,project.IPM_Complexity__c,'task complexity does not match with project complexity'); 
                    taskList.add(task);       
                }
                
                 IPM_Project_Resource__c projRes = IPM_TestFactory_Helper.createIPMProjectResource(project.Id,false); 
                 
                projRes.IPM_Role_Type__c ='BD';
                projResourceList.add(projRes);
            }
            insert projResourceList;
            
            system.assertEquals(8, taskList.size(),sAssertionMsgForTaskBeingCreated);
        
        return taskList;
     }
     
     /*
     @description:  This testmethod is used to test overall positive functionality of IPM_MyList
    */ 
     private static testmethod void myListTest(){
        Test.startTest();
        final String sTestProjName = 'test proj';
        final String sCategory = 'cat1';
        final String sBrand = 'br1';
        final String sSampleUser = 'Sample';
        User globalUser = [Select Id,LastName from User where LastName=:GLOBAL_PL limit 1];
        
        // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalUser}); 
        
        system.RunAs(globalUser)
        {
            list<IPM_Task__c> taskList = getTaskList();
            IPM_Task__c ipmTask = taskList[0];
            taskListTest = new IPM_MyList();
            taskListTest.size =1;
            taskListTest.overduesize1=2;
            taskListTest.projectId = null;
            taskListTest.IsTaskEditable = true;
            taskListTest.isBosscard =  false;
            
            taskListTest.toggleSortAssignees();
            taskListTest.deleteTask();
            taskListTest.setTaskId(string.valueof(ipmTask.id));
            taskListTest.markComplete();
            taskListTest.setUser(globalUser.Id);
            
            taskListTest.setprojectName(sTestProjName);
            String prName=taskListTest.getprojectName();
            System.Assert(prName == sTestProjName,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
            
            taskListTest.setcategoryName(sCategory);
            String catName=taskListTest.getcategoryName();
            System.Assert(catName == sCategory,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
            
            taskListTest.setbrandName(sBrand);
            String bName=taskListTest.getbrandName();
            System.Assert(bName == sBrand,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
            
            taskListTest.setPhase(IPM_ConstantUtils.PHASE_IDEAS);
            String pValue=taskListTest.getPhase();
            System.Assert(pValue  == IPM_ConstantUtils.PHASE_IDEAS,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
            
            taskListTest.setUser(sSampleUser);
            String uName=taskListTest.getUser();
            System.Assert(uName == sSampleUser,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
            
            String taskcount = taskListTest.getTaskcountValue();
            System.Assert(Integer.valueOf(taskcount) > 0 ,'Task count should not be 0.');
            
            taskListTest.toggleSortSections();
            taskListTest.toggleSortTasks();
            taskListTest.toggleSortPhases();
            taskListTest.toggleDueDate();
            taskListTest.toggleSortCompletion();
            taskListTest.showAllNextSevenDays();
            taskListTest.getTaskId();
            taskListTest.filteredProjectReset();
            taskListTest.filterCompleteTasksReset();
            
            taskListTest.setTaskId(sProjectToBeSearched);
            taskListTest.deleteTask();
            
        }
        Test.stopTest();
    }
    
     /*
     @description:  This testmethod is used to test overdue,todays and next 7 days tasks assigned to logged-in user.
    */ 
     private static testmethod void myTaskOpenTest(){
        Test.startTest();
            list<IPM_Task__c> overdueTask;
            list<IPM_Task__c> todayTask;
            list<IPM_Task__c> sevendaysTask;
            list<IPM_Task__c> laterTask;
            list<IPM_Task__c> overdueTaskQuery;
            list<IPM_Task__c> todayTaskQuery;
            list<IPM_Task__c> sevenDaysQry;
            list<IPM_Task__c> completedTask;
            list<Date> setDate;
            list<IPM_Task__c> insertTask = new list<IPM_Task__c> ();
            list<IPM_Task__c> updatedTaskTest = new list<IPM_Task__c> ();
        
        User globalUser = [Select Id,LastName from User where LastName=:GLOBAL_PL limit 1];
        
        // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalUser}); 
        
        system.RunAs(globalUser)
        {   
            Date todayDate = system.now().date();
            setDate =  new list<Date>{todayDate.addDays(-14),todayDate,todayDate.addDays(5),todayDate.addDays(14)};
            insertTask = getTaskList();
            integer countTask = 0;
            for(integer i=0 ;i<4 ;i++){
                for(integer j=countTask ;j<countTask+2 ;j++){
                    IPM_Task__c ipmTask= insertTask[j];
                    ipmTask.IPM_Due_Date1__c = setDate[i];
                    ipmTask.IPM_Completed__c = false;
                    updatedTaskTest.add(ipmTask);
                }
                countTask = countTask+2;
            }
            update updatedTaskTest;
            
            
            list<IPM_Task__c> taskList = [select id,Name,IPM_Task_Complexity__c,IPM_Project__c,IPM_Due_Date1__c,IPM_Completed__c from IPM_Task__c where IPM_Due_Date1__c!= null and IPM_Project__c IN:projIdSet limit 100];
            for(IPM_Task__c task :taskList){
                system.assertEquals(task.IPM_Due_Date1__c!= null,true,'Due dates should not be null');
            }
            taskListTest = new IPM_MyList();
            overdueTask = taskListTest.getOverduetasksSample();
            todayTask = taskListTest.getprojectTaskssample();
            sevendaysTask = taskListTest.getNextSevenTasks();
            laterTask = taskListTest.getLaterTasks();
            completedTask = taskListTest.getcompletedTasks();
            taskListTest.showAllOverDue();
            taskListTest.todayTasksize();
            taskListTest.showAllNextSevenDays();
            taskListTest.showAllLaterTasks();
            
            overdueTaskQuery = [SELECT Id,IPM_Due_Date1__c,IPM_Project__c FROM IPM_Task__c WHERE IPM_Due_Date1__c < :system.Today() AND IPM_Completed__c = false AND IPM_Project__c in:projIdSet limit 1000];
            system.assertEquals(overdueTask[0].IPM_Due_Date1__c,overdueTaskQuery[0].IPM_Due_Date1__c,'overdue tasks due dates are not matched');
            system.assertEquals(overdueTask.size(),overdueTaskQuery.size(),'Overdue tasks count is not matched with actual created data');
            
            todayTaskQuery = [SELECT Id,IPM_Due_Date1__c,IPM_Project__c FROM IPM_Task__c WHERE IPM_Due_Date1__c = :system.Today() AND IPM_Completed__c = false AND  IPM_Project__c in:projIdSet limit 1000];
            system.assertEquals(todayTask[0].IPM_Due_Date1__c,todayTaskQuery[0].IPM_Due_Date1__c,'todays tasks due dates are not matched');
            system.assertEquals(todayTask.size(),todayTaskQuery.size(),'today tasks count is not matched with actual created data');
            String sAssertMsg = 'seven days tasks count is not matched with actual created data';
            sevenDaysQry = [SELECT Id,IPM_Due_Date1__c,IPM_Project__c FROM IPM_Task__c WHERE IPM_Due_Date1__c > :system.Today() AND IPM_Due_Date1__c < :system.Today().addDays(7) AND IPM_Completed__c = false AND  IPM_Project__c in:projIdSet limit 1000];
            system.assertEquals(sevendaysTask[0].IPM_Due_Date1__c,sevenDaysQry[0].IPM_Due_Date1__c,'seven days tasks due dates are not matched');
            system.assertEquals(2,sevenDaysQry.size(),sAssertMsg);
            
            system.assertEquals(2,laterTask.size(),sAssertMsg);
            system.assertEquals(0,completedTask.size(),sAssertMsg);
       }
        Test.stopTest();
        
    }
    
	 /*
     @description:  This testmethod is used to test completed tasks count which are assigned to logged-in user.
    */ 
     private static testmethod void myTaskCompletedTest(){
        Test.startTest();
            list<IPM_Task__c> completedTask;
            list<Date> setDate;
            list<IPM_Task__c> insertTask = new list<IPM_Task__c> ();
            list<IPM_Task__c> updatedTaskTest = new list<IPM_Task__c> ();
            
            User globalUser = [Select Id,LastName from User where LastName=:GLOBAL_PL limit 1];
            
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalUser}); 
        
            system.RunAs(globalUser)
            {   
                setDate =  new list<Date>{system.Today().addDays(-14),system.Today(),system.Today().addDays(5),system.Today().addDays(14)};
                insertTask = getTaskList();
                for(integer i=0 ;i<4 ;i++){
                    IPM_Task__c ipmTask= insertTask[i];
                    ipmTask.IPM_Due_Date1__c = setDate[i];
                    ipmTask.IPM_Completed__c = true;
                    updatedTaskTest.add(ipmTask);
                }
                update updatedTaskTest;
                system.assertEquals(4, [Select count() from IPM_Task__c where IPM_Completed__c = true and IPM_Project__c in:projIdSet limit 1000] , 'tasks are not updated');
                
                taskListTest = new IPM_MyList();
                taskListTest.getOverduetasksSample();
                taskListTest.getprojectTaskssample();
                taskListTest.getNextSevenTasks();
                taskListTest.getLaterTasks();
                completedTask = taskListTest.getcompletedTasks();
                taskListTest.showCompletedTasks();
                system.assertEquals(completedTask.size(),4,'4 tasks are not marked as completed');
             }   
        Test.stopTest();
    }
    
    /*
     @description:  This testmethod is used to test whether logged in user can view task where he is the owner.
    */ 
    private static testmethod void taskVisibilityPositiveTest(){
        
         
            list<IPM_Task__c> insertTask = new list<IPM_Task__c> ();
            map<Id, IPM_Task__c> updatedTaskMap = new map<Id, IPM_Task__c> ();
            
            User globalUser = [Select Id,LastName from User where LastName=:GLOBAL_PL limit 1];
            
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalUser}); 
            system.RunAs(globalUser)
            { 
                insertTask = getTaskList();
                
                system.assertEquals(!insertTask.isEmpty(),true,sAssertionMsgForTaskBeingCreated);
         		
         			
                list<IPM_Project_Document_Section__c> sectionList = [SELECT id,IPM_Gate_Document__c,IPM_FunctionalRole__c,IPM_Section__c,IPM_Project_ID__c 
                                        FROM IPM_Project_Document_Section__c where IPM_Project_Document__r.IPM_Project__c in:projIdSet limit 1000];
                for(IPM_Task__c task: insertTask ){
                    for(IPM_Project_Document_Section__c section :sectionList ){
                        if(task.IPM_Project__c ==section.IPM_Project_ID__c && task.IPM_Type_of_Gate__c ==section.IPM_Gate_Document__c && task.IPM_Function__c ==section.IPM_FunctionalRole__c ){
                            task.IPM_Project_Document_Section__c =section.id;
                            task.IPM_Section__c =section.IPM_Section__c;
                             task.IPM_Due_Date1__c =System.today()+10;
                             task.IPM_Assignee__c = UserInfo.getUserId() ;
                             updatedTaskMap.put(task.Id, task);
                        }
                    }
        
                }
                update updatedTaskMap.values();
                //Please note assertion is not required here after DML, as it is test data updation to test another business functionality in next part of testmethod.
                IPM_MyList tskList = new IPM_MyList();
                tskList.searchedProject = projectToSearch;
                 tskList.isCompleteTasks = IPM_Utils.f;
                tskList.filterProject();
                tskList.HasPrevious=true;
                tskList.HasNext=true;
                tskList.projectsSet=new set<string>();
                tskList.projectsSet.add(sProjectToBeSearchedIn);
                tskList.searchedProject=sProjectToBeSearched;
                tskList.filterProject();
            
             }
             
        Test.startTest();  
        
            User globalBDUser = [Select Id,LastName from User where LastName=:GLOBAL_BD limit 1];   
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalBDUser}); 
        
            system.RunAs(globalBDUser)
            {
                PageReference pgRef = Page.IPM_MyToDoList;   
                Test.setCurrentPage(pgRef);
                
                ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(insertTask);
                list<IPM_Task__c>updatedTaskTest = ssc.getRecords();
                
                system.assertEquals(updatedTaskTest.size(),8,sAssertionMsgForTaskBeingUpdated); 
            }
        Test.stopTest();
    }   
    
     /*
     @description:  This testmethod is used to test tasks having project approch as external
    */ 
     private static testmethod void projectWithExternalApprochTest(){ 
        Test.startTest();
            message = false; 
           	exceptn = false;   
           	Exception ex = null;
           	final String sAssertionMsgForPageMessage = 'page messages are not added properly.';
            final String sTestclassString = 'test class';
            User globalUser = [Select Id,LastName from User where LastName=:GLOBAL_PL limit 1];
            
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalUser}); 
        
            system.RunAs(globalUser)
            {   
                taskListTest = new IPM_MyList();
                list<IPM_Task__c>  taskList = getTaskList();
                
                list<IPM_Project__c> projList = [SELECT Id,IPM_PM_Approach__c,Name FROM IPM_Project__c WHERE Id =: taskList[0].IPM_Project__c limit 1000];
                projList[0].IPM_PM_Approach__c = IPM_ConstantUtils.IPM_APPROACH_EXTERNAL ;
                update projList[0];
                
                System.assertEquals(IPM_ConstantUtils.IPM_APPROACH_EXTERNAL, [Select Id, IPM_PM_Approach__c from IPM_Project__c WHERE Id =: taskList[0].IPM_Project__c limit 1000][0].IPM_PM_Approach__c, 'Project approach is not updated to External');
                IPM_MyList ipm = new IPM_MyList();
                ipm.showCompletedTasks();
                List<Apexpages.Message> msgs = ApexPages.getMessages();
                
                for(Apexpages.Message msg : msgs){
                    message  = true;
                }
                
                system.assertEquals(message  ,true, sAssertionMsgForPageMessage);
                
                
                 try{
                    ipm.catchBlockContent(sTestclassString ,ex);
                 }catch(Exception exp){
                    ipm.catchBlockContent(sTestclassString ,exp);
                    exceptn =true;
                 }
                 system.assertEquals(exceptn ,true,sAssertionMsgForPageMessage);
             }
        Test.stopTest();
     }
     
     /*
     @description:  This testmethod is used to test filtering of the tasks which are in next 7 days and completed.
    */ 
     private static testmethod void taskCatchTest(){
         
            list<IPM_Task__c> insertTask = new list<IPM_Task__c> ();
            map<Id, IPM_Task__c> updatedTaskMap = new map<Id, IPM_Task__c> ();
            
            User globalUser = [Select Id,LastName from User where LastName=:GLOBAL_PL limit 1];
            
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalUser}); 
            system.RunAs(globalUser)
            { 
                insertTask = getTaskList();
                
                system.assertEquals(!insertTask.isEmpty(),true,sAssertionMsgForTaskBeingCreated);
         		
                list<IPM_Project_Document_Section__c> sectionList = [SELECT id,IPM_Gate_Document__c,IPM_FunctionalRole__c,IPM_Section__c,IPM_Project_ID__c 
                                        FROM IPM_Project_Document_Section__c where IPM_Project_Document__r.IPM_Project__c in:projIdSet limit 1000];
                for(IPM_Task__c task: insertTask ){
                    for(IPM_Project_Document_Section__c section :sectionList ){
                        if(task.IPM_Project__c ==section.IPM_Project_ID__c && task.IPM_Type_of_Gate__c ==section.IPM_Gate_Document__c && task.IPM_Function__c ==section.IPM_FunctionalRole__c ){
                            task.IPM_Project_Document_Section__c =section.id;
                            task.IPM_Section__c =section.IPM_Section__c;
                             task.IPM_Due_Date1__c =System.today()+10;
                             task.IPM_Assignee__c = UserInfo.getUserId() ;
                             updatedTaskMap.put(task.Id, task);
                        }
                    }
        
                }
                update updatedTaskMap.values();
                //Please note assertion is not required here after DML, as it is test data updation to test business functionality in next part of testmethod.
                IPM_MyList tskList = new IPM_MyList();
                tskList.toggleTask = IPM_Utils.truevalue;
                tskList.setPhase(IPM_ConstantUtils.PHASE_IDEAS);
                tskList.setUser(GLOBAL_PL);
                tskList.toggleRole = IPM_Utils.truevalue;
                tskList.isCompleteTasks = IPM_Utils.t;
                tskList.searchedProject = projectToSearch;
                tskList.filterProject();
                tskList.HasPrevious=true;
                tskList.HasNext=true;
                tskList.projectsSet=new set<string>();
                tskList.projectsSet.add(sProjectToBeSearchedIn);
                tskList.searchedProject=sProjectToBeSearched;
                tskList.filterProject();
             	tskList.loadTasks();
             }
             
        Test.startTest();  
        
            User globalBDUser = [Select Id,LastName from User where LastName=:GLOBAL_BD limit 1];   
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalBDUser}); 
        
            system.RunAs(globalBDUser)
            {
                PageReference pgRef = Page.IPM_MyToDoList;   
                Test.setCurrentPage(pgRef);
                
                ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(insertTask);
                list<IPM_Task__c>updatedTaskTest = ssc.getRecords();
                
                system.assertEquals(updatedTaskTest.size(),8,sAssertionMsgForTaskBeingUpdated); 
            }
        Test.stopTest();
     
     }
     
     /*
     @description:  This testmethod is used to test filtering of the tasks which are in next 7 days and are not completed
    */
     private static testmethod void taskTestNegative(){
         
            list<IPM_Task__c> insertTask = new list<IPM_Task__c> ();
            map<Id, IPM_Task__c> updatedTaskMap = new map<Id, IPM_Task__c> ();
            
            User globalUser = [Select Id,LastName from User where LastName=:GLOBAL_PL limit 1];
            
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalUser}); 
            system.RunAs(globalUser)
            { 
                insertTask = getTaskList();
                
                system.assertEquals(!insertTask.isEmpty(),true,sAssertionMsgForTaskBeingCreated);
         		
                list<IPM_Project_Document_Section__c> sectionList = [SELECT id,IPM_Gate_Document__c,IPM_FunctionalRole__c,IPM_Section__c,IPM_Project_ID__c 
                                        FROM IPM_Project_Document_Section__c where IPM_Project_Document__r.IPM_Project__c in:projIdSet limit 1000];
                for(IPM_Task__c task: insertTask ){
                    for(IPM_Project_Document_Section__c section :sectionList ){
                        if(task.IPM_Project__c ==section.IPM_Project_ID__c && task.IPM_Type_of_Gate__c ==section.IPM_Gate_Document__c && task.IPM_Function__c ==section.IPM_FunctionalRole__c ){
                            task.IPM_Project_Document_Section__c =section.id;
                            task.IPM_Section__c =section.IPM_Section__c;
                             task.IPM_Due_Date1__c =System.today()+10;
                             task.IPM_Assignee__c = UserInfo.getUserId() ;
                             updatedTaskMap.put(task.Id, task);
                        }
                    }
        
                }
                update updatedTaskMap.values();
                //Please note assertion is not required here after DML, as it is test data updation to test another business functionality in next part of testmethod.
                IPM_MyList tskList = new IPM_MyList();
                tskList.toggleTask = IPM_Utils.truevalue;
                tskList.setPhase(IPM_ConstantUtils.PHASE_IDEAS);
                tskList.setUser(GLOBAL_PL);
                tskList.toggleRole = IPM_Utils.truevalue;
                tskList.isCompleteTasks = IPM_Utils.f;
                tskList.isAsc = true;
                tskList.searchedProject = projectToSearch;
                tskList.filterProject();
                tskList.HasPrevious=true;
                tskList.HasNext=true;
                tskList.projectsSet=new set<string>();
                tskList.projectsSet.add(sProjectToBeSearchedIn);
                tskList.filterProject();
             	tskList.loadTasks();
             }
             
        	Test.startTest();  
        
            User globalBDUser = [Select Id,LastName from User where LastName=:GLOBAL_BD limit 1];   
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalBDUser}); 
        
            system.RunAs(globalBDUser)
            {
                PageReference pgRef = Page.IPM_MyToDoList;   
                Test.setCurrentPage(pgRef);
                
                ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(insertTask);
                list<IPM_Task__c>updatedTaskTest = ssc.getRecords();
                
                system.assertEquals(updatedTaskTest.size(),8,sAssertionMsgForTaskBeingUpdated); 
            }
        	Test.stopTest();
    
     	
     
     }       
}