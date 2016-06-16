/******************************************** 
*@Author:Cognizant
*@Date:01/02/2015
*@Description : Test class for IPM_MyList class functionalities
*/


@istest
public class IPM_MyList_Test{
    
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
    /*
    @description For Initializing the data
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
        }
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
         IPM_TestFactory_Helper.getProjectMasterData();
         
         // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
         IPM_TestFactory_Helper.shareMasterProject(new List<User>{platformUser}); 
         
         projectList = IPM_TestFactory_Helper.projectSetUp(8,platformUser);
         System.debug('platformUser==>'+platformUser.Id);
         System.runAs(platformUser)
         {
           insert projectList;
         }  
         system.assertEquals(9 , [Select id from IPM_Project__c limit 1000].size(),'Projects are created');
      }
      
      
      private static list<IPM_Task__c> getTaskList()
     {
        list<IPM_Task__c> taskList;
        projIdSet =  new Set<Id>();
        projResourceList = new list<IPM_Project_Resource__c>();
        
        
            Set<String> projectNameSet = new Set<String>{projectToSearch,'TestComments2','TestComments3','TestComments4','TestComments5','TestComments6','TestComments7','TestComments8','TestComments9','TestComments10'};
            projectDetailList = [Select Id,IPM_Phase__c,Name,IPM_PM_Approach__c,IPM_Complexity__c,(Select Id from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r ),
                    (Select Id,Name,IPM_Assignee__c,IPM_Due_Date1__c,IPM_Completed__c,IPM_Project__r.Is_Archieved__c,IPM_Task_Complexity__c,IPM_Project__c,IPM_Project_Document_Section__c,IPM_Function__c,IPM_Section__c, IPM_Type_of_Gate__c from Tasks__r),(Select Id,Name from IPM_Milestones__r)
                    from IPM_Project__c where Name in:projectNameSet];
            System.debug('projectDetailList==>'+projectDetailList);        
            for(IPM_Project__c project: projectDetailList){
                projIdSet.add(project.id);
            }
            taskList = new list<IPM_Task__c>();
            
            for(IPM_Project__c project : projectDetailList)
            {
                for(IPM_Task__c task : project.Tasks__r)
                {
                    system.assertEquals(task.IPM_Task_Complexity__c,project.IPM_Complexity__c,'task complexity matches with project complexity'); 
                    taskList.add(task);       
                }
                
                 IPM_Project_Resource__c projRes = IPM_TestFactory_Helper.createIPMProjectResource(project.Id,false); 
                 
                projRes.IPM_Role_Type__c ='BD';
                projResourceList.add(projRes);
            }
            insert projResourceList;
            
            system.assertEquals(8, taskList.size(),'task created');
        
        return taskList;
     }
    /*
    * @description For Running Test Script
    */ 
     private static testmethod void myListTest(){
        Test.startTest();
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
            taskListTest.project();
            taskListTest.setUser(globalUser.Id);
            
            taskListTest.setprojectName('test proj');
            String prName=taskListTest.getprojectName();
            System.Assert(prName == 'test proj',IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
            
            taskListTest.setcategoryName('cat1');
            String catName=taskListTest.getcategoryName();
            System.Assert(catName == 'cat1',IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
            
            taskListTest.setbrandName('br1');
            String bName=taskListTest.getbrandName();
            System.Assert(bName == 'br1',IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
            
            taskListTest.setPhase('test');
            String pValue=taskListTest.getPhase();
            System.Assert(pValue  == 'test',IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
            
            taskListTest.setUser('Sample');
            String uName=taskListTest.getUser();
            System.Assert(uName == 'Sample',IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
            
            String taskcount = taskListTest.getTaskcountValue();
            System.Assert(taskcount != null,IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
            
            taskListTest.toggleSortSections();
            taskListTest.toggleSortTasks();
            taskListTest.toggleSortPhases();
            taskListTest.toggleDueDate();
            taskListTest.toggleSortCompletion();
            taskListTest.showAllNextSevenDays();
            taskListTest.getTaskId();
            taskListTest.filteredProjectReset();
            taskListTest.filterCompleteTasksReset();
            
            taskListTest.setTaskId('abc');
            taskListTest.deleteTask();
            
        }
        Test.stopTest();
    }
    
    /*test cases for open task*/
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
            
            
            list<IPM_Task__c> taskList = [select id,Name,IPM_Task_Complexity__c,IPM_Project__c,IPM_Due_Date1__c,IPM_Completed__c from IPM_Task__c where IPM_Due_Date1__c!= null and IPM_Project__c IN:projIdSet];
            for(IPM_Task__c task :taskList){
                system.assertEquals(task.IPM_Due_Date1__c!= null,true,'Due dates are not null');
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
            
            overdueTaskQuery = [SELECT Id,IPM_Due_Date1__c,IPM_Project__c FROM IPM_Task__c WHERE IPM_Due_Date1__c < :system.Today() AND IPM_Completed__c = false AND IPM_Project__c in:projIdSet];
            system.assertEquals(overdueTask[0].IPM_Due_Date1__c,overdueTaskQuery[0].IPM_Due_Date1__c,'overdue tasks due dates matched');
            system.assertEquals(overdueTask.size(),overdueTaskQuery.size(),'Overdue tasks count matched with actual created data');
            
            todayTaskQuery = [SELECT Id,IPM_Due_Date1__c,IPM_Project__c FROM IPM_Task__c WHERE IPM_Due_Date1__c = :system.Today() AND IPM_Completed__c = false AND  IPM_Project__c in:projIdSet];
            system.assertEquals(todayTask[0].IPM_Due_Date1__c,todayTaskQuery[0].IPM_Due_Date1__c,'todays tasks due dates matched');
            system.assertEquals(todayTask.size(),todayTaskQuery.size(),'today tasks count matched with actual created data');
            
            sevenDaysQry = [SELECT Id,IPM_Due_Date1__c,IPM_Project__c FROM IPM_Task__c WHERE IPM_Due_Date1__c > :system.Today() AND IPM_Due_Date1__c < :system.Today().addDays(7) AND IPM_Completed__c = false AND  IPM_Project__c in:projIdSet];
            system.assertEquals(sevendaysTask[0].IPM_Due_Date1__c,sevenDaysQry[0].IPM_Due_Date1__c,'seven days tasks due dates matched');
            system.assertEquals(2,sevenDaysQry.size(),'seven days tasks count matched with actual created data');
            
            system.assertEquals(2,laterTask.size(),'seven days tasks count matched with actual created data');
            system.assertEquals(0,completedTask.size(),'seven days tasks count matched with actual created data');
       }
        Test.stopTest();
        
    }
    /*test cases for completed task*/
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
                system.assertEquals(updatedTaskTest.size(),4,'tasks updated');
                
                taskListTest = new IPM_MyList();
                taskListTest.getOverduetasksSample();
                taskListTest.getprojectTaskssample();
                taskListTest.getNextSevenTasks();
                taskListTest.getLaterTasks();
                completedTask = taskListTest.getcompletedTasks();
                taskListTest.showCompletedTasks();
                system.assertEquals(completedTask.size(),4,'4 tasks are marked as completed');
             }   
        Test.stopTest();
    }
    /*logged in user can view task where he is the owner*/
    public static testmethod void taskVisibilityPositiveTest(){
        
         
            list<IPM_Task__c> insertTask = new list<IPM_Task__c> ();
            map<Id, IPM_Task__c> updatedTaskMap = new map<Id, IPM_Task__c> ();
            
            User globalUser = [Select Id,LastName from User where LastName=:GLOBAL_PL limit 1];
            
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalUser}); 
        	System.debug('globalUser==>'+globalUser.id+'==>');
            system.RunAs(globalUser)
            { 
                insertTask = getTaskList();
                
                system.assertEquals(insertTask.size()>0,true,'tasks inserted');
         		
         			
                list<IPM_Project_Document_Section__c> sectionList = [SELECT id,IPM_Gate_Document__c,IPM_FunctionalRole__c,IPM_Section__c,IPM_Project_ID__c 
                                        FROM IPM_Project_Document_Section__c where IPM_Project_Document__r.IPM_Project__c in:projIdSet];
                for(IPM_Task__c task: insertTask ){
                    for(IPM_Project_Document_Section__c section :sectionList ){
                        if(task.IPM_Project__c ==section.IPM_Project_ID__c && task.IPM_Type_of_Gate__c ==section.IPM_Gate_Document__c && task.IPM_Function__c ==section.IPM_FunctionalRole__c ){
                            task.IPM_Project_Document_Section__c =section.id;
                            task.IPM_Section__c =section.IPM_Section__c;
                             task.IPM_Due_Date1__c =System.today()+10;
                             System.debug('task.IPM_Assignee__c before ==>'+task.IPM_Assignee__c);
                             task.IPM_Assignee__c = UserInfo.getUserId() ;
                             System.debug('task.IPM_Assignee__c after ==>'+task.IPM_Assignee__c);
                             updatedTaskMap.put(task.Id, task);
                        }
                    }
        
                }
                update updatedTaskMap.values();
                IPM_MyList tskList = new IPM_MyList();
                tskList.searchedProject = projectToSearch;
                 tskList.isCompleteTasks = IPM_Utils.f;
                tskList.filterProject();
                tskList.HasPrevious=true;
                tskList.HasNext=true;
                tskList.projectsSet=new set<string>();
                tskList.projectsSet.add('abcd');
                tskList.searchedProject='abc';
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
                
                system.assertEquals(updatedTaskTest.size(),8,'8 tasks are being updated'); 
            }
        Test.stopTest();
    }   
    
    /* task with project approch is external */
     private static testmethod void projectWithExternalApprochTest(){ 
        Test.startTest();
            message = false; 
           	exceptn = false;   
           	Exception ex = null;
            User globalUser = [Select Id,LastName from User where LastName=:GLOBAL_PL limit 1];
            
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalUser}); 
        
            system.RunAs(globalUser)
            {   
                taskListTest = new IPM_MyList();
                list<IPM_Task__c>  taskList = getTaskList();
                
                list<IPM_Project__c> projList = [SELECT Id,IPM_PM_Approach__c,Name FROM IPM_Project__c WHERE Id =: taskList[0].IPM_Project__c];
                projList[0].IPM_PM_Approach__c = 'External' ;
                update projList[0];
                
                IPM_MyList ipm = new IPM_MyList();
                ipm.showCompletedTasks();
                List<Apexpages.Message> msgs = ApexPages.getMessages();
                
                for(Apexpages.Message msg : msgs){
                    message  = true;
                }
                system.assertEquals(message  ,true,'page messages are added');
                
                
                 try{
                    ipm.catchBlockContent('test class',ex);
                 }catch(Exception exp){
                    ipm.catchBlockContent('test class',exp);
                    exceptn =true;
                 }
<<<<<<< HEAD
                 system.assertEquals(exceptn ,true,'page messages are added');
=======
                 system.assertEquals(exceptn ,false,'page messages are added');
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
             }
        Test.stopTest();
     }
     
     /*test cases for completed task*/
     private static testmethod void taskCatchTest(){
         
            list<IPM_Task__c> insertTask = new list<IPM_Task__c> ();
            map<Id, IPM_Task__c> updatedTaskMap = new map<Id, IPM_Task__c> ();
            
            User globalUser = [Select Id,LastName from User where LastName=:GLOBAL_PL limit 1];
            
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalUser}); 
            system.RunAs(globalUser)
            { 
                insertTask = getTaskList();
                
                system.assertEquals(insertTask.size()>0,true,'tasks inserted');
         		
                list<IPM_Project_Document_Section__c> sectionList = [SELECT id,IPM_Gate_Document__c,IPM_FunctionalRole__c,IPM_Section__c,IPM_Project_ID__c 
                                        FROM IPM_Project_Document_Section__c where IPM_Project_Document__r.IPM_Project__c in:projIdSet];
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
                IPM_MyList tskList = new IPM_MyList();
                tskList.toggleTask = IPM_Utils.truevalue;
                tskList.setPhase('Idea');
                tskList.setUser(GLOBAL_PL);
                tskList.toggleRole = IPM_Utils.truevalue;
                tskList.isCompleteTasks = IPM_Utils.t;
                tskList.searchedProject = projectToSearch;
                tskList.filterProject();
                tskList.HasPrevious=true;
                tskList.HasNext=true;
                tskList.projectsSet=new set<string>();
                tskList.projectsSet.add('abcd');
                tskList.searchedProject='abc';
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
                
                system.assertEquals(updatedTaskTest.size(),8,'8 tasks are being updated'); 
            }
        Test.stopTest();
     
     }
     
     
     private static testmethod void taskTestNegative(){
         
            list<IPM_Task__c> insertTask = new list<IPM_Task__c> ();
            map<Id, IPM_Task__c> updatedTaskMap = new map<Id, IPM_Task__c> ();
            
            User globalUser = [Select Id,LastName from User where LastName=:GLOBAL_PL limit 1];
            
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalUser}); 
            system.RunAs(globalUser)
            { 
                insertTask = getTaskList();
                
                system.assertEquals(insertTask.size()>0,true,'tasks inserted');
         		
                list<IPM_Project_Document_Section__c> sectionList = [SELECT id,IPM_Gate_Document__c,IPM_FunctionalRole__c,IPM_Section__c,IPM_Project_ID__c 
                                        FROM IPM_Project_Document_Section__c where IPM_Project_Document__r.IPM_Project__c in:projIdSet];
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
                IPM_MyList tskList = new IPM_MyList();
                tskList.toggleTask = IPM_Utils.truevalue;
                tskList.setPhase('Idea');
                tskList.setUser(GLOBAL_PL);
                tskList.toggleRole = IPM_Utils.truevalue;
                tskList.isCompleteTasks = IPM_Utils.f;
                tskList.isAsc = true;
                tskList.searchedProject = projectToSearch;
                tskList.filterProject();
                tskList.HasPrevious=true;
                tskList.HasNext=true;
                tskList.projectsSet=new set<string>();
                tskList.projectsSet.add('abcd');
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
                
                system.assertEquals(updatedTaskTest.size(),8,'8 tasks are being updated'); 
            }
        Test.stopTest();
    
     	
     
     }       
}