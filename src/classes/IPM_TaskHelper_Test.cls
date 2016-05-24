@isTest
private class IPM_TaskHelper_Test{
/*created to test IPM_TaskHelper class*/
    private static User adminUser = IPM_TestFactory_Helper.createUserAdmin(true);
    private static User platformUserPL1;
    private static User platformUserPL2;
    private static User userBDRole;

    private static list<IPM_Project__c> projectList;
    private static list<IPM_Project__c> projectDetailList;
    private static list<IPM_Task__c> taskDetailList;
    private static final String  GLOBAL_PL1 ='GLOBAL_PL1';
    private static final String  GLOBAL_PL2 ='GLOBAL_PL2';
    private static final String  GLOBAL_BD_OWNER ='GLOBAL_BD_OWNER';
    private static final Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3','TestComments4','TestComments5','TestComments6','TestComments7','TestComments8','TestComments9','TestComments10'};
    
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
        	
        	platformUserPL1 = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
            platformUserPL1.lastname = GLOBAL_PL1;
            platformUserPL2  = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.TEAM_DEPUTY_PROJECT_LEADER);
            platformUserPL2.lastname = GLOBAL_PL2;
            userBDRole = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.FUNCTIONAL_ROLE_BD);
            userBDRole.lastname = GLOBAL_BD_OWNER;
            
            List<User> userList = new List<User>{platformUserPL1,platformUserPL2,userBDRole};
            update userList;
            
			list<User> userUpdatedList = [SELECT lastname FROM User WHERE lastname=:GLOBAL_PL1];
            system.assertEquals(userUpdatedList.size(),1,'Global PL is not created');
            list<User> userUpdatedList2 = [SELECT lastname FROM User WHERE lastname=:GLOBAL_PL1];
            system.assertEquals(userUpdatedList2.size(),1,'Global DPL is not created');
            list<User> userUpdatedList3 = [SELECT lastname FROM User WHERE lastname=:GLOBAL_PL1];
            system.assertEquals(userUpdatedList3.size(),1,'Global BD is not created');
            
        }
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
        IPM_TestFactory_Helper.getProjectMasterData();
         
        System.runAs(adminUser){ 
        List<IPM_Section__c> sectionList =  new List<IPM_Section__c>();
             

        for(IPM_Section__c secVal:[Select id,IPM_IS_Default_Section__c from IPM_Section__c where IPM_Document_Template__r.IPM_Document_Type__c = 'Contract' and 
        IPM_Document_Template__r.IPM_Project_Template__r.IPM_Template_Complexity__c = :IPM_ConstantUtils.IPM_COMPLEXITY_FULL and 
        IPM_Document_Template__r.IPM_Project_Template__r.IPM_Project_Type__c = :IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL and 
        ProjectSpan__c includes (:IPM_ConstantUtils.PROJECT_SPAN_REGIONAL) limit 20])
        {
      	  secVal.IPM_IS_Default_Section__c = true;
      	  sectionList.add(secVal);
        }
        update sectionList;
        }
         // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{platformUserPL1,platformUserPL2,userBDRole}); 
            
        list<IPM_Project__c> projectList1 = IPM_TestFactory_Helper.projectSetUp(10,platformUserPL1);
        projectList = new list<IPM_Project__c> ();
        System.runAs(platformUserPL1)
        {  
          for(IPM_Project__c  project: projectList1)
          {
              project.Deputy_Project_Leader__c = platformUserPL2.id;
              projectList.add(project);
          }
          insert projectList;
         //check if the created projects are having the same complexity type as assigned while creating
          list<IPM_Project__c> projectsResultList = [SELECT Id,IPM_Phase__c,IPM_Complexity__c FROM IPM_Project__c where Name IN:projectNameSet];
          for(IPM_Project__c project : projectsResultList)
          {
                system.assertEquals(project.IPM_Complexity__c,IPM_ConstantUtils.COMPLEXITY_FULL,'Project is not created');
        }  
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
        
        set<Id> projectIdSet = new set<Id>();
        set<Id> projectDocumentIdSet = new set<Id>();
        list<IPM_Task__c> taskList= new list<IPM_Task__c> ();
        list<IPM_Task__c> futureTaskList= new list<IPM_Task__c> ();
        map<id,IPM_Task__c> updateTaskMap = new map<id,IPM_Task__c> ();
       
	    projectDetailList = [Select Id,IPM_Phase__c,IPMProject_Span__c,Name,IPM_Complexity__c,IPM_Project_Leader__c,Deputy_Project_Leader__c,IPM_GateKeeping_Model__c,
                            (Select Id from Project_Documents__r),
                            (Select Id from IPM_Financials_Consolidated__r ),
                            (Select Id,Name,IPM_Task_Complexity__c,IPM_Project__c,IPM_Function__c,IPM_Section__c,IPM_Type_of_Gate__c,IPM_Project_Document_Section__c,IPM_Assignee__c,ExternalField__c,IPM_Active__c from Tasks__r),
                            (Select Id,Name,IPM_Due_Date__c,IPM_Planned_Date__c,IPM_Phase__c from IPM_Milestones__r)
                            from IPM_Project__c where Name in:projectNameSet];
          
       for(IPM_Project__c project : projectDetailList)
       {
            projectIdSet.add(project.id);
            for(IPM_Task__c task : project.Tasks__r)
            {
				//check if task complexity is same as project complexity
                system.assertEquals(task.IPM_Task_Complexity__c ,project.IPM_Complexity__c,'Task complexity is not same project complexity');
                //check if task is assigned by default to PL
                system.assertEquals(task.IPM_Assignee__c ,project.IPM_Project_Leader__c,'Task is not assigned to PL');
                taskList.add(task);
            }
			//get alldocument section of project
            for(IPM_Project_Document__c projDoc : project.Project_Documents__r)
            {
                projectDocumentIdSet.add(projDoc.id);
            }
       }
       
		 // query project document section
       list<IPM_Project_Document_Section__c> projDocSecList = [SELECT Id,IPM_Default_Section__c ,IPM_Gate_Document__c,IPM_FunctionalRole__c,IPM_Project_ID__c,IPM_Section__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_Project__c 
                                                                FROM IPM_Project_Document_Section__c 
                                                                WHERE IPM_Project_Document__c IN:projectDocumentIdSet and IPM_Project_Document__r.IPM_Project__c=:projectIdSet];
      
      List<IPM_Section__c> sectionList=[Select id,IPM_IS_Default_Section__c from IPM_Section__c where IPM_Document_Template__r.IPM_Document_Type__c = 'Contract' and 
	        IPM_Document_Template__r.IPM_Project_Template__r.IPM_Template_Complexity__c = :IPM_ConstantUtils.IPM_COMPLEXITY_FULL and 
	        IPM_Document_Template__r.IPM_Project_Template__r.IPM_Project_Type__c = :IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL and 
	        ProjectSpan__c includes (:IPM_ConstantUtils.PROJECT_SPAN_REGIONAL) and IPM_IS_Default_Section__c = true limit 10];
      for(IPM_Section__c secVal:sectionList)
      {
      	//Insert future adhoc task list
      		IPM_Task__c futureAdhocTask = IPM_TestFactory_Helper.createIPMTask(projectDetailList[0].id,false);
       		futureAdhocTask.IPM_Type_of_Task__c = IPM_ConstantUtils.FUTURE_ADHOC_TASKS;
       		futureAdhocTask.IPM_Task_Name__c = 'Future Feasibility Task';
       		futureAdhocTask.IPM_Phase__c = IPM_ConstantUtils.FEASIBILITY_PHASE;
       		futureAdhocTask.IPM_Type_of_Gate__c =IPM_ConstantUtils.CONTRACT_GATE;
       		futureAdhocTask.IPM_Task_Complexity__c = IPM_ConstantUtils.COMPLEXITY_LITE;
       		futureAdhocTask.IPM_TaskSpan__c=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
       		futureAdhocTask.IPM_Function__c =IPM_ConstantUtils.FUNCTIONAL_ROLE_BD;
       		futureAdhocTask.IPM_Section__c=secVal.id;
       		futureTaskList.add(futureAdhocTask); 
        }
        insert futureTaskList;
    	List<IPM_Task__c> testFutureList = [Select IPM_Type_of_Task__c from IPM_Task__c where id in:futureTaskList];
      
        system.assertEquals(testFutureList[0].IPM_Type_of_Task__c,IPM_ConstantUtils.FUTURE_ADHOC_TASKS,'Task not inserted');
      
      	
      	//Insert a future full adhoc task
      		IPM_Task__c futureAdhocFullTask = IPM_TestFactory_Helper.createIPMTask(projectDetailList[0].id,false);
       		futureAdhocFullTask.IPM_Type_of_Task__c = IPM_ConstantUtils.FUTURE_ADHOC_TASKS;
       		futureAdhocFullTask.IPM_Task_Name__c = 'Future Feasibility Full Task';
       		futureAdhocFullTask.IPM_Phase__c = IPM_ConstantUtils.FEASIBILITY_PHASE;
       		futureAdhocFullTask.IPM_Type_of_Gate__c =IPM_ConstantUtils.CONTRACT_GATE;
       		futureAdhocFullTask.IPM_Task_Complexity__c = IPM_ConstantUtils.COMPLEXITY_FULL;
       		futureAdhocFullTask.IPM_TaskSpan__c=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
       		futureAdhocFullTask.IPM_Function__c =IPM_ConstantUtils.FUNCTIONAL_ROLE_BD;
       		futureAdhocFullTask.IPM_Section__c=sectionList[0].id;
      
      insert futureAdhocFullTask;
      
      IPM_Task__c futurFullTask = [Select IPM_Type_of_Task__c from IPM_Task__c where id =:futureAdhocFullTask.id];
      
      system.assertEquals(futurFullTask.IPM_Type_of_Task__c,IPM_ConstantUtils.FUTURE_ADHOC_TASKS,'Task not inserted');
      
		//associate task with project document section
      for(IPM_Task__c task : taskList)
       {
        if( !updateTaskMap.containsKey(task.id) && task.IPM_Section__c == null)
        {
            for(IPM_Project_Document_Section__c projDocSec: projDocSecList)
            {
                if(task.IPM_Project__c == projDocSec.IPM_Project_Document__r.IPM_Project__c && task.IPM_Type_of_Gate__c == projDocSec.IPM_Gate_Document__c && task.IPM_Function__c == projDocSec.IPM_FunctionalRole__c )
                {
                    task.IPM_Section__c = projDocSec.IPM_Section__c;
                    task.IPM_Project_Document_Section__c = projDocSec.Id;
                    updateTaskMap.put(task.id,task);
                }
            }
        }
       }
       update updateTaskMap.values();
       
       //check if the tasks are associated with project document section
       taskDetailList = [SELECT Id,Name,IPM_Task_Complexity__c,IPM_Project__c,IPM_Function__c,IPM_Section__c,IPM_Type_of_Gate__c,IPM_Project_Document_Section__c,IPM_Master_Section_Name__c,IPM_Master_Section_Sequence__c 
                         FROM IPM_Task__c WHERE IPM_Project__c IN:projectIdSet and IPM_Section__c != NULL];
      for(IPM_Task__c task : taskDetailList)
       {
               system.assertEquals(task.IPM_Master_Section_Name__c != NULL ,true,'Task is not associated with section');
       }
    }

  /***********************************
      @name: createTaskFromMilestoneToDosTab
      @Description: PL should be able to insert task on milestone and todos tab
    ***********************************/
    public static TestMethod void reAssignFunctionalWiseTasksTest(){
		//get user list
        User globalUser = [Select Id,LastName from User where LastName=:GLOBAL_PL1 limit 1];
        User bdUser = [Select Id,LastName,IsActive from User where LastName=:GLOBAL_BD_OWNER  limit 1];
        set<Id> projIdSet =  new set<Id>();
        
		//share project's master data with user
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalUser,bdUser}); 
        
	Test.startTest();
        system.runAs(globalUser)
        {
            initializedData();
            
            User bdFunOwner = [Select Id,LastName,IsActive from User where LastName=:GLOBAL_BD_OWNER  limit 1];
            list<IPM_Project_Resource__c> projResList = new list<IPM_Project_Resource__c>();
            
             //create project resource. BD Leader
            for(IPM_Project__c project : projectDetailList)
            {
              IPM_Project_Resource__c projRes = IPM_TestFactory_Helper.createIPMProjectResource(project.id,false); 
              projRes.IPM_User__c = bdFunOwner.id;
              projRes.IPM_Role_Type__c =IPM_ConstantUtils.FUNCTIONAL_ROLE_BD;
              projResList.add(projRes);
              projIdSet.add(project.id);
          }
            insert projResList;
            
            //check if BD leader is inserted successfully
            list<IPM_Project_Resource__c> projResResult = [SELECT Id,IPM_User__c,IPM_Project__c,IPM_Role_Type__c FROM IPM_Project_Resource__c WHERE IPM_User__c=:bdFunOwner.id];

            for(IPM_Project_Resource__c projRes: projResResult)
            {
                system.assertEquals(projRes.IPM_Role_Type__c,IPM_ConstantUtils.FUNCTIONAL_ROLE_BD,'Project resource for BD role is not inserted');
            }
        }   
        
            System.runAs(adminUser){
              //project record was not shared with the project resource user, so adding the project resource expecitly in the goup for which the project record is shared.    
              list<IPM_Project__Share> projectShare = [SELECT Id,ParentID,UserOrGroupId FROM IPM_Project__Share WHERE  ParentID IN :projIdSet];
              User bdOwnerUser = [Select Id,LastName,IsActive from User where LastName=:GLOBAL_BD_OWNER  limit 1];
              
              List<GroupMember>listGroupMember = new List<GroupMember>();  
			  set<Id> projectShareIdSet =  new set<Id>();
              for(IPM_Project__Share projShare : projectShare)
              {
                  listGroupMember.add(new GroupMember(GroupId = projShare.UserOrGroupId , UserOrGroupId = bdOwnerUser.id));
				  projectShareIdSet.add(projShare.UserOrGroupId);
              }
                insert listGroupMember;
              //check if the project is shared with project resource
              List<GroupMember> groupMemberList = [SELECT UserOrGroupId,GroupId FROM GroupMember where GroupId IN:projectShareIdSet];
              system.assertEquals(false,groupMemberList.isEmpty(),'Project resource for BD role is not inserted');
            }
            
        //check if Project resource added can access the project     
        system.runAs(bdUser)
        {
            //get all task where BD user is assignee
            list<IPM_Task__c> taskList = [SELECT Id,Name,IPM_Task_Complexity__c,IPM_Project__c,IPM_Function__c,IPM_Section__c,IPM_Type_of_Gate__c,IPM_Assignee__c,IPM_Project__r.Name
                                          FROM IPM_Task__c WHERE IPM_Function__c =:IPM_ConstantUtils.FUNCTIONAL_ROLE_BD and IPM_Project__r.Name IN:projectNameSet];
            
            //check if the Task of functional role BD are assigned to BD user
            for(IPM_Task__c task :taskList)
            {
                system.assertEquals(task.IPM_Assignee__c,userinfo.getuserid(), 'User Is Different');
            }
        }
       Test.stopTest(); 
        
    }
     /***********************************
      @name: reassignProjectLeaderTaskTest
      @Description: When PL changes, task assigned to old PL should be ressigned to new PL.
    ***********************************/
    public static TestMethod void reassignProjectLeaderTest(){
		 // get users
        User projectLeader1 = [Select Id,LastName from User where LastName=:GLOBAL_PL1 limit 1];
        User projectLeader2 = [Select Id,LastName,IsActive from User where LastName=:GLOBAL_PL2 limit 1];
        
		//share project's master data with users
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{projectLeader1,projectLeader2}); 
        
      
        system.runAs(projectLeader1)
        {
          Test.startTest();  
          
              initializedData();
              
              list<IPM_Project__c> updateProjectList = new list<IPM_Project__c>();
			  set<Id> projectIdSet = new set<Id>();
            
			 //change PL 
            User globalPL = [Select Id,LastName,IsActive from User where LastName=:GLOBAL_PL2 limit 1];  
            for(IPM_Project__c project :projectDetailList)
            {
              project.IPM_Project_Leader__c = globalPL.id;
			  projectIdSet.add(project.id);
                updateProjectList.add(project);
            }
            
            update updateProjectList;  
            //Check if PL is changed successfully
            list<IPM_Project__c> projDetailResult = [select Id,Name,IPM_Project_Leader__c,Deputy_Project_Leader__c FROM IPM_Project__c where Id IN:projectIdSet];
            for(IPM_Project__c proj :  projDetailResult)
            {
                system.assertEquals(proj.IPM_Project_Leader__c,globalPL.id,'PL is not changed');
            }
         Test.stopTest();
         
    }
		 //login as chnaged PL
        system.runAs(projectLeader2)
        {
			//Get the project list where new user is assigned as PL
            set<Id> projIdSet =  new set<Id>();
            list<IPM_Project__c> projDetail = [select Id,Name,IPM_Project_Leader__c,Deputy_Project_Leader__c FROM IPM_Project__c where Name in:projectNameSet];
            
			 //Check if the PL is changed 
            for(IPM_Project__c project : projDetail)
            {   
                projIdSet.add(project.id);
                system.assertEquals(project.IPM_Project_Leader__c,userinfo.getuserid(),'PL is not updated ');
            
            }
			// get task list where PL is assignee
            list<IPM_Task__c> updatetaskList = [SELECT Id,Name,IPM_Project__c,IPM_Project__r.IPM_Project_Leader__c,IPM_Function__c,IPM_Assignee__c 
                                          FROM IPM_Task__c where IPM_Project__c IN :projIdSet];
            
			//check if the task as also assigned to new PL
            for(IPM_Task__c task :updatetaskList)
            {
              system.assertEquals(task.IPM_Assignee__c,userinfo.getuserid(),'Task assignee is not changed.');
                 
            }
        }
     }
     
    /***********************************
      @name: projectComplexityWiseTaskTest
      @Description: When project complexity changes, task will generate for new complexity type.
    ***********************************/
    public static TestMethod void projectComplexityWiseTaskTest(){
		 //get users
        User projectLeader1 = [Select Id,LastName from User where LastName=:GLOBAL_PL1  limit 1];
        User projectLeader2 = [Select Id,LastName,IsActive from User where LastName=:GLOBAL_PL2  limit 1];
        
		//shre project's master data is shared with users
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{projectLeader1,projectLeader2}); 
        
       Test.startTest(); 
		//login as PL
        system.runAs(projectLeader1)
        {
            initializedData();
            list<IPM_Project__c> updateProjectList = new list<IPM_Project__c>();
            
            set<Id> projIdSet =  new set<Id>();
			//Update project's complexity to lite
            for(IPM_Project__c project :projectDetailList)
            {
                projIdSet.add(project.id);
                project.IPM_Complexity__c = IPM_ConstantUtils.COMPLEXITY_LITE;
                updateProjectList.add(project);
            }
            update updateProjectList;
        
		   //Get the project list where complexity is changed
            list<IPM_Project__c> projDetailResult = [select Id,IPM_Phase__c,Name,IPM_Complexity__c FROM IPM_Project__c where Id in:projIdSet];
            //Check if the complexity of project is chnaged 
            for(IPM_Project__c project : projDetailResult)
            {   
                system.assertEquals(project.IPM_Complexity__c,IPM_ConstantUtils.COMPLEXITY_LITE,'Complexity of project is not chnaged');
            }
            //get task of the projects, where the project's complexity is changed
            list<IPM_Task__c> taskList = [SELECT Id,Name,IPM_Type_of_Task__c,IsSystemGenerated__c,IPM_Task_Name__c,IPM_Phase__c,IPM_Task_Complexity__c,IPM_Project__c,IPM_Project__r.IPM_Project_Leader__c,IPM_Function__c,IPM_Section__c,IPM_Type_of_Gate__c,IPM_Assignee__c,IPM_Active__c 
                                          FROM IPM_Task__c WHERE IPM_Project__c IN:projIdSet ];
            
            for(IPM_Project__c project :projectDetailList)
            {
	            for(IPM_Task__c task :taskList)
	            {
	                //check if the tasks with different complexity as that of project's complxity are inactive 
	                if(task.IsSystemGenerated__c && task.IPM_Task_Complexity__c == IPM_ConstantUtils.COMPLEXITY_FULL)
	                {
	                	system.assertEquals(task.IPM_Active__c,false, 'IPM_Active__c Is Checked');
	                }
	                //check if the tasks with same complexity as that of project's complxity are active 
	                if(task.IPM_Task_Complexity__c == IPM_ConstantUtils.COMPLEXITY_LITE && task.IPM_Phase__c == project.IPM_Phase__c)
	                {
	                   system.assertEquals(task.IPM_Active__c,true, 'IPM_Active__c Is UnChecked');
	                }
	                
	            }
            }         
            
        }
        Test.stopTest();
    }

/***********************************
      @name: phaseWiseTaskTest
      @Description: When project changed new phase task should be inserted.
    ***********************************/
    private static TestMethod void testCopyOverFutureTask(){
     	
        User globalUser = [Select Id,Name,LastName from User where LastName=:GLOBAL_PL1 limit 1];
        Set<ID> iDs = new Set<ID>();
        // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalUser}); 
        
        system.runAs(globalUser)
        {
          	  initializedData();
              
              set<Id> projIdSet =  new set<Id>();
              list<Id> projIdList =  new  list<Id> ();
              
              for(IPM_Project__c project :projectDetailList)
              {
              	  project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
                  project.IPM_Project_Name__c = project.Name;
                  project.IPM_Complexity__c = IPM_ConstantUtils.COMPLEXITY_FULL;
                  projIdSet.add(project.id);
              }
              projIdList.addAll(projIdSet);
              update projectDetailList; 
              
            
              /******************************** Create Regional Rollouts for Created Global project ****************************************/
             List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,new List<IPM_Project__c>{projectDetailList[0],projectDetailList[1],projectDetailList[2]},new List<User>{globalUser,globalUser,globalUser});
             insert regionalRolloutList;
             iDs.clear();
             for(IPM_Project_Rollout__c eachRollout : regionalRolloutList) {
              iDs.add(eachRollout.Id);
             }
             System.assertEquals(6, [Select count() from IPM_Project_Rollout__c where id in:iDs],'Regional Rollouts created');
            
            
             Map<Id,List<IPM_Project_Rollout__c>> projectToRolloutMap = new Map<Id,List<IPM_Project_Rollout__c>>();
             for(IPM_Project_Rollout__c projectRollout : regionalRolloutList)
             {
                List<IPM_Project_Rollout__c> projectRolloutList = new List<IPM_Project_Rollout__c>();
                if(projectToRolloutMap.containsKey(projectRollout.IPM_Project__c))
                {
                    projectRolloutList = projectToRolloutMap.get(projectRollout.IPM_Project__c);
                }
                projectRolloutList.add(projectRollout);
                projectToRolloutMap.put(projectRollout.IPM_Project__c,projectRolloutList);
             }
            
          
            Test.startTest(); 
          
            // Initiate Phase Change 
            List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(projIdList,globalUser); 
              
            update projectListPhaseChange;
            Test.stopTest();
            
            List<IPM_Project__c> projectListUpdated = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Leader__c,Deputy_Project_Leader__c,IPM_Current_Document_Status__c,IPM_Current_Gate_Name__c,IPM_PM_Approach__c
                                           from IPM_Project__c where IPM_Phase__c =:IPM_ConstantUtils.FEASIBILITY_PHASE AND Name IN :projectNameSet];
            system.assert(projectListUpdated.size() == 10,'Project List are not updated');
            
            list<IPM_Task__c> taskList = [SELECT Id,IPM_Task_Name__c,IPM_TaskSpan__c,IPM_Type_of_Task__c,IPM_Task_Complexity__c,IPM_Project_Document_Section__c,IPM_Project__c,IPM_Project__r.IPM_Project_Leader__c,IPM_Function__c,IPM_Section__c,IPM_Type_of_Gate__c,
            							  IPM_Assignee__c,IPM_Active__c,IPM_Phase__c,IPM_Project__r.Name,IPM_Completed__c
                                          FROM IPM_Task__c WHERE IPM_Project__r.Name IN :projectNameSet and IPM_Task_Name__c = 'Future Feasibility Task'];
            
            for(IPM_Task__c futureTask:taskList)
            {
            		system.assert(futureTask != null,'Future task not delegated to regional project');
            }	
            
      		
        }  
     
     }
     
}