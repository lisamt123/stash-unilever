/**
   @Author Cognizant Techinology Solutions
   @name IPM_ProjectHelper_Test
   @CreateDate 8/20/2015
   @Description Test Class for testing project specific helpers.
   @Version 1.0
   @reference Project Creation and Phase Change
  */
  
@isTest
private with sharing class IPM_ProjectHelper_Test 
{
     
     /**
        *  Used for Setting test Data for Project Creation . 
        *  @name projectSetUp
    */
    
     @testSetup static void projectSetUp() 
     {
         // Create an instance of admin user.
         User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
         
         User globalProjectLeader = null;
         // Create an instances of standard Users for Allocation to Project Leaders.
         System.runAs(adminUser)
         {   
            globalProjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            User regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            User localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            
            // Update LastNames to match functionalRoles
            globalProjectLeader.lastname = 'GLOBAL_PL';
            regionalProjectLeader.lastname = 'REGIONAL_PL';
            localProjectLeader.lastname = 'LOCAL_PL'; 
            
            List<User> userList = new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader};
            update userList;
         
            List<User> dbUserList =  [Select Id from User where id in :userList];
            System.assertEquals(dbUserList.size(),userList.size(),'Users not Created Properly.Actual no of Users should be'+userList.size());
            // Create Company Card information(Master Data)
            IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
            IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
            IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
            
            List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
            insert companyCardList;
            
            // Inserting Master Data whose OWD are set to readOnly/View All    
            IPM_TestFactory_Helper.getProjectMasterData();
            
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalProjectLeader}); 
        } 
        
        // Insert the project as a Global project Leader.
        System.runAs(globalProjectLeader)
        {   
            
            List<IPM_Project__c> projectList = IPM_TestFactory_Helper.projectSetUp(3,globalProjectLeader);
            insert projectList;
            
            List<IPM_Project__c> dbProjectList =  [Select Id from IPM_Project__c where id in :projectList];
            System.assertEquals(dbProjectList.size(),projectList.size(),'Projects not Created Properly.Actual size should be '+projectList.size());
        }
        
        
     }
     
     /**
        *  Used for Testing Global Project Creation. 
        *  @name projectSetUp
     */
     public static testmethod void createProject()
     {
        // Get the newly created Projects from Database. 
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
        List<Id> globalProjectIdList = new List<Id>();
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        
        User globalProjectLeader = null;
        User regionalProjectLeader = null;
        
        Test.startTest();
        // Get the list of user's for project leaders.
        List<User> userList = [Select Id,Name,lastName from User where LastName in('GLOBAL_PL','REGIONAL_PL','LOCAL_PL')];
        
        // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(userList); 
        
        for(User lUser  :userList)
        {
            if(lUser.lastName == 'GLOBAL_PL')
            {
                globalProjectLeader = lUser;
            }
            if(lUser.lastName == 'REGIONAL_PL')
            {
                regionalProjectLeader = lUser;
            }
        }
        List<IPM_Project__c> projectList=new List<IPM_Project__c>();
        System.RunAs(globalProjectLeader)
        {
            projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r),
                                                    (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
                                                    (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
            for(IPM_Project__c project : projectList)
            {
                projectMap.put(project.Id,project);
            }
            
	    IPM_ProjectHelper.copyOverMPAValue(projectMap);
            Id  mileMasterRecordType = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.mileMRecordType).getRecordTypeId();
            Map<Id,IPM_Milestone__c>  standardMileStoneMap = new Map<Id,IPM_Milestone__c>([Select Id,Name,IPM_Type_of_Milestone__c from IPM_Milestone__c where IPM_Type_of_Milestone__c ='Standard' AND recordTypeId =:mileMasterRecordType AND IPM_Project_Type__c='Original' ] );
        
            // Get Standard Milestones from database  
            System.assert(standardMileStoneMap.values().size() > 0,'Project Milestones not generated');
            
            /********************************Global Project Leaders Project View and Data Access****************************************/
            for(IPM_Project__c project : projectList)
            {
                // Once project is created Charter document would be available.
                System.assertEquals(project.Project_Documents__r.size(),1,'Project Documents dont match the actual Documents');
                
                // Once project is created, Project associated tasks would be based on Selected Complexity.
                for(IPM_Task__c task : project.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,project.IPM_Complexity__c,'Complexity doesnt match the Original Complexity');     
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assertEquals(project.IPM_Milestones__r.size(),standardMileStoneMap.size(),'Project Milestones not equal to Master Milestones');
                
                // Once project is created , Consolidated financials are getting generated.
                System.assertEquals(project.IPM_Financials_Consolidated__r.size(),1,'Project Documents dont match the actual Documents'); // One for Global consolidated Financials
                
                // Project default phase would always be set as IDEAS.
                System.assertEquals(project.IPM_Phase__c,'Ideas','Project not equal to Ideas'); // Phase would be always ideas for Global Project.
            }
                
            /******************************** Create Regional Rollouts for Created Global project ****************************************/
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{regionalProjectLeader,regionalProjectLeader,regionalProjectLeader});
            insert regionalRolloutList;
            
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
            
            // Create local Rollouts for Created regional Rollouts.
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>());  
             
            insert localRolloutList; 
           
            List<IPM_Project_Rollout__c> dbRolloutList =  [Select Id from IPM_Project_Rollout__c where id in :localRolloutList];
            System.assertEquals(dbRolloutList.size(),localRolloutList.size(),'Projects not Created Properly.Actual size should be '+localRolloutList.size());
            // Create Country specific information.
            List<IPM_Country__c> countryList= new List<IPM_Country__c>();
            
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                String geoExternalId = '';
                if(localRollout.IPM_Rollout_Project__c.contains('AF'))
                {
                    geoExternalId = 'AG';
                }
                else if(localRollout.IPM_Rollout_Project__c.contains('LA'))
                {
                    geoExternalId = 'BR';
                }
                
                IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = new MDO_Geography__c(ISO_3166_1_Code__c = geoExternalId).Id,
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO',isActive__c = true);    
                
                countryList.add(tempCountry);
            }
            
            insert countryList;
            List<IPM_Country__c> dbCountryList =  [Select Id from IPM_Country__c where id in :countryList];
            System.assertEquals(dbCountryList.size(),countryList.size(),'Projects not Created Properly.Actual size should be '+countryList.size());
            
            /******************************** Initiate Phase Change and Regional Project Creation  ****************************************/
            
            
             // Set GateKeeping Model as RCLT and start with Regional Project Creation.
            for(IPM_Project__c project : projectList)
            {
                project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
            }  
            
            update projectList;
            
            for(IPM_Project__c project : projectList)
            {
                globalProjectIdList.add(project.Id);    
            }
            
            // Initiate Phase Change would result in Rollout Project Creation.
            List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(globalProjectIdList,globalProjectLeader); 
            
            update projectListPhaseChange;
            
            Test.stopTest();
        }
        
        List<IPM_Project__c> regionalProjects = new List<IPM_Project__c>();
        
        System.RunAs(globalProjectLeader)
        {
            Map<Id,List<IPM_Project__c>> globalToRegionalMap = IPM_TestFactory_Helper.getRegionalProjects(globalProjectIdList);

            for(Id gbProjectId : globalToRegionalMap.keySet())
            {
               regionalProjects.addAll(globalToRegionalMap.get(gbProjectId)); 
            }
            
            List<IPM_Project__c> DBRegionalProjects = [Select Id,Name,IPM_Phase__c,IPM_Parent_Project__c, IPMProject_Span__c, (Select Id from Project_Documents__r),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r) from IPM_Project__c where ID in :regionalProjects];  
                
            for(IPM_Project__c regionalProject : DBRegionalProjects) 
            {
               Id parentGlobalProjectId = regionalProject.IPM_Parent_Project__c;
                
               IPM_Project__c parentGlobalProject = projectMap.get(parentGlobalProjectId);
                
               // Only Contract document Available at Regional Level.
               System.assertEquals(regionalProject.Project_Documents__r.size(),1,'Contract Document either doesnt have a document or has more document');
   
               // MileStones would Copy from Parent Project. 
               System.assertEquals(regionalProject.IPM_Milestones__r.size(),parentGlobalProject.IPM_Milestones__r.size(),'Milestones didnt copy from Parent Project Properly');
            }
        }
        
        /******************************** Regional Project Leader View for Regional Projects  ****************************************/
        System.RunAs(regionalProjectLeader)
        {
            // Update phase for Local Rollouts. 
            List<IPM_Project__c> regionalProjectsFR = [Select Id,Name,IPM_Phase__c,IPM_Parent_Project__c, IPMProject_Span__c, (Select Id from Project_Documents__r),(Select Id from Regional_Project_Rollout__r),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r) from IPM_Project__c where ID in :regionalProjects];
            
            for(IPM_Project__c regionalProject : regionalProjectsFR)
            {
                // Validate there is atleast one Task associated with Regional Project
                System.assert(regionalProject.Tasks__r.size()>0,'Tasks not generated by transaction management');
                
                for(IPM_Task__c task : regionalProject.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,regionalProject.IPM_Complexity__c,'Task complexity doesnt match Project complexity.');
                    System.assertEquals(task.IPM_Phase__c,regionalProject.IPM_Phase__c,'Task Phase is not equal to Project Phase');   
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assert(regionalProject.IPM_Milestones__r.size()>0,'Milestones not present or not visible to Regional Project Leader');
                
                // Once project is created , Consolidated financials are getting generated.
                System.assertEquals(regionalProject.IPM_Financials_Consolidated__r.size(),3,'Regional has more financials than expected'); // One for Global consolidated Financials and 2 for individual Rollouts
                
                // Project default phase would always be set as feasibility.
                System.assertEquals(regionalProject.IPM_Phase__c,'Feasibility','Regional Project Phase not equal to feasiblity.'); // Phase would be feasibility for Regional Projects.
                
            }
        }
      
        System.RunAs(globalProjectLeader)
        {
            // Set fasttact project
            set<id>projids=new set<id>();
            for(IPM_Project__c project : projectList)
            {
                project.IPM_Fast_Track_Project__c= true;
                projids.add(project.id);
            }  
            
            update projectList;  
        }
     } 
      
     public static testmethod void testEcodesignSyncStatus()
     {
        List<User> users = [Select Id,Email from User where LastName = 'GLOBAL_PL' limit 1];        
        
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
        
        User globalUser = null;
        globalUser = users[0];
        
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalUser}); 
        // Create Regional Projects.
        System.runAs(globalUser)
        {
            Test.startTest();
            IPM_Project__c proj = [Select Id,EcoDesign_Sync_Status__c,IPM_GateKeeping_Model__c,Fetch_Timestamp_Mulesoft__c,Success_TimeStamp_EcoDesign__c,
                                    BET_Update__c,BET_Link_Requested__c,BET_Link_Requested_on_Date__c,IPM_SourceProjectType__c,IPM_Project_Type__c,
                                    IPM_Answer_of_Q1__c from IPM_Project__c where Name in:projectNameSet  limit 1000][0];
            proj.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
            proj.EcoDesign_Sync_Status__c = 'Ready';
            update proj;
			
            List<IPM_Project__c> readyprojList = [Select id from IPM_Project__c where EcoDesign_Sync_Status__c = 'Ready' limit 100];
            System.assert(readyprojList.size() > 0, 'Project status changed to Ready');
			
            //The status is changes to Success by Mulesoft. When Mulesoft changes the sync status from ready to success then , the status should again be revereted back to Ready
            //This ensures that the project is still ready for sync, even after the previous sync was successful.
            proj.EcoDesign_Sync_Status__c = 'Success';
            update proj;
            IPM_Project__c projSyncSuccess = [Select Id,EcoDesign_Sync_Status__c,Fetch_Timestamp_Mulesoft__c,Success_TimeStamp_EcoDesign__c from IPM_Project__c Where Id =:proj.id limit 100][0];
            System.assertEquals('Ready',projSyncSuccess.EcoDesign_Sync_Status__c,'Project status not changed to Ready');
            proj.EcoDesign_Sync_Status__c = 'Error';
            update proj;
			
            //The status is changes to Error by Mulesoft. When mulesoft changes the sync status from ready to Error then , the status should again be revereted back to Ready
            //This ensures that the project is still ready for sync, even after the previous sync failed.
            IPM_Project__c projSyncError = [Select Id,EcoDesign_Sync_Status__c,Fetch_Timestamp_Mulesoft__c,Success_TimeStamp_EcoDesign__c from IPM_Project__c Where Id =:proj.id limit 1000][0];
            System.assertEquals('Ready',projSyncError.EcoDesign_Sync_Status__c,'Project status not changed to Ready');
            proj.EcoDesign_Sync_Status__c = 'In Progress';
            update proj;
			
            //The status is changes to In Prohress by Mulesoft. When Mulesoft changes the status from Ready to In-Progress , this means that the project was fetched for syncing to Eco-design,
            //So project status should change to In Progress successfully
            IPM_Project__c projSyncInProgress = [Select Id,EcoDesign_Sync_Status__c,Fetch_Timestamp_Mulesoft__c,Success_TimeStamp_EcoDesign__c from IPM_Project__c Where Id =:proj.id limit 1000][0];
            System.assertEquals('In Progress',projSyncInProgress.EcoDesign_Sync_Status__c,'Project status not changed to In Progress');
            string projectAPI='IPM_Project__c';
            List<String>apiList=new List<String>();
            apiList.add(projectAPI);
            Map<String,Object>projectObjMap=new Map<String,Object>();
            Map<String,List<Object>>noObjectMap=new Map<String,List<Object>>();
            IPM_TestFactory.retrieveFieldDescibeBulk(apiList);
            IPM_TestFactory.retrieveObjectDescibeBulk(apiList);
            IPM_TestFactory.createSObject(projectAPI,projectObjMap,true);
            IPM_TestFactory.createSObjectList(projectAPI,noObjectMap,true);
            List<IPM_Project__c>projNewList=New List<IPM_Project__c>();
            Map<id,IPM_Project__c>oldProjectMap=new Map<id,IPM_Project__c>();
            IPM_Project__c addnewValue=new IPM_Project__C();
            addnewValue.id=proj.id;
            addnewValue.IPM_Project_Leader__c=globalUser.id;
            addnewValue.IPM_Technical_Project_Leader__c=globalUser.id;
            addnewValue.Deputy_Project_Leader__c=globalUser.id;
            addnewValue.IPM_Project_Gatekeeper__c=globalUser.id;
            addnewValue.IPM_Finance_Lead__c=globalUser.id;
            projNewList.add(addnewValue);
            oldProjectMap.put(proj.id,addnewValue);
            IPM_ProjectTriggerHandler.getProjectUsersMap(projNewList, oldProjectMap, false) ;
            proj.Created_in_error__c=true;
            update proj;
            Test.stopTest();
        }
     }
     /**
        *  Used for creatying global, regional project and local rollout creation
        *  @name : projectDataCreation
     */ 
     public static list<IPM_Project__c> projectDataCreation(){
     	// Get the newly created Projects from Database. 
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
        List<Id> globalProjectIdList = new List<Id>();
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        List<IPM_Project__c> projectList=new List<IPM_Project__c>();
        User globalProjectLeader = null;
        User regionalProjectLeader = null;
        Test.startTest();
		    // Get the list of user's for project leaders.
		    List<User> userList = [Select Id,Name,lastName from User where LastName in('GLOBAL_PL','REGIONAL_PL','LOCAL_PL')];
		    // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
		    IPM_TestFactory_Helper.shareMasterProject(userList); 
		    for(User lUser  :userList)
		    {
		        if(lUser.lastName == 'GLOBAL_PL')
		        {
		            globalProjectLeader = lUser;
		        }
		        if(lUser.lastName == 'REGIONAL_PL')
		        {
		            regionalProjectLeader = lUser;
		        }
		    }
		    System.RunAs(globalProjectLeader)
		    {
		        projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c,IPM_PrepareForArchival__c,Is_Archieved__c,IPM_Stopped_By__c,IPM_Stopped_Phase__c,IPM_Stopped_At_Span__c,
							   IPM_Document_Update_Comments__c,IPMProject_Span__c,IPM_Stopped_Comments__c,
								(Select Id from Project_Documents__r),
                                (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
                                (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
		        for(IPM_Project__c project : projectList)
		        {
		            projectMap.put(project.Id,project);
		        }
				IPM_ProjectHelper.copyOverMPAValue(projectMap);
		        Id  mileMasterRecordType = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.mileMRecordType).getRecordTypeId();
		        Map<Id,IPM_Milestone__c>  standardMileStoneMap = new Map<Id,IPM_Milestone__c>([Select Id,Name,IPM_Type_of_Milestone__c from IPM_Milestone__c where IPM_Type_of_Milestone__c ='Standard' AND recordTypeId =:mileMasterRecordType AND IPM_Project_Type__c='Original' ] );
		        // Get Standard Milestones from database  
		        System.assert(standardMileStoneMap.values().size() > 0,'Project Milestones not generated');
		 		 /******************************** Create Regional Rollouts for Created Global project ****************************************/
		        List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{regionalProjectLeader,regionalProjectLeader,regionalProjectLeader});
		        insert regionalRolloutList;
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
		        // Create local Rollouts for Created regional Rollouts.
		        List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>());  
		        insert localRolloutList; 
		        List<IPM_Project_Rollout__c> dbRolloutList =  [Select Id from IPM_Project_Rollout__c where id in :localRolloutList];
		        System.assertEquals(dbRolloutList.size(),localRolloutList.size(),'Projects not Created Properly.Actual size should be '+localRolloutList.size());
		        // Create Country specific information.
		        List<IPM_Country__c> countryList= new List<IPM_Country__c>();
		        for(IPM_Project_Rollout__c localRollout : localRolloutList)
		        {
		            String geoExternalId = '';
		            if(localRollout.IPM_Rollout_Project__c.contains('AF'))
		            {
		                geoExternalId = 'AG';
		            }
		            else if(localRollout.IPM_Rollout_Project__c.contains('LA'))
		            {
		                geoExternalId = 'BR';
		            }
		            IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = new MDO_Geography__c(ISO_3166_1_Code__c = geoExternalId).Id,
		            IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO',isActive__c = true);    
		            countryList.add(tempCountry);
		        }
		        insert countryList;
		        List<IPM_Country__c> dbCountryList =  [Select Id from IPM_Country__c where id in :countryList];
		        System.assertEquals(dbCountryList.size(),countryList.size(),'Projects not Created Properly.Actual size should be '+countryList.size());
		        /******************************** Initiate Phase Change and Regional Project Creation  ****************************************/
		         // Set GateKeeping Model as RCLT and start with Regional Project Creation.
		        for(IPM_Project__c project : projectList)
		        {
		            project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
		        }  
		        update projectList;
		        for(IPM_Project__c project : projectList)
		        {
		            globalProjectIdList.add(project.Id);    
		        }
		       	// Initiate Phase Change would result in Rollout Project Creation.
		        List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(globalProjectIdList,globalProjectLeader); 
		        update projectListPhaseChange;
		     Test.stopTest();
			List<IPM_Project__c> regionalProjects = new List<IPM_Project__c>();
        	Map<Id,List<IPM_Project__c>> globalToRegionalMap = IPM_TestFactory_Helper.getRegionalProjects(globalProjectIdList);
            for(Id gbProjectId : globalToRegionalMap.keySet())
            {
               regionalProjects.addAll(globalToRegionalMap.get(gbProjectId)); 
            }
            List<IPM_Project__c> DBRegionalProjects = [Select Id,Name,IPM_Phase__c,IPM_Parent_Project__c, IPMProject_Span__c, (Select Id from Project_Documents__r),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r) from IPM_Project__c where ID in :regionalProjects];  
            for(IPM_Project__c regionalProject : DBRegionalProjects) 
            {
               Id parentGlobalProjectId = regionalProject.IPM_Parent_Project__c;
               IPM_Project__c parentGlobalProject = projectMap.get(parentGlobalProjectId);
               // Only Contract document Available at Regional Level.
               System.assertEquals(regionalProject.Project_Documents__r.size(),1,'Contract Document either doesnt have a document or has more document');
               // MileStones would Copy from Parent Project. 
               System.assertEquals(regionalProject.IPM_Milestones__r.size(),parentGlobalProject.IPM_Milestones__r.size(),'Milestones didnt copy from Parent Project Properly');
            }
		}
		return projectList;
    }
     /**
        *  Used to test when global project is in phase of stopping, regional project should also be in the same phase
        *  @name : projectDataCreation
     */ 
     public static testmethod void testForArchivalProject(){
     	List<User> userList = [Select Id,Name,lastName from User where LastName in('GLOBAL_PL','REGIONAL_PL','LOCAL_PL')];
		User globalProjectLeader = null; 
		User regionalProjectLeader = null; 
	    // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
	    IPM_TestFactory_Helper.shareMasterProject(userList); 
	    for(User lUser  :userList)
	    {
	        if(lUser.lastName == 'GLOBAL_PL')
	        {
	            globalProjectLeader = lUser;
	        }
	        if(lUser.lastName == 'REGIONAL_PL')
	        {
	            regionalProjectLeader = lUser;
	        }
	    }
	    list<IPM_Project__c> projectList = projectDataCreation();
	    set<id> projids = new set<id>();
	    system.runAs(globalProjectLeader){
	    	/************Project is in stopping phase**************************/
	    	for(IPM_Project__c project : projectList)
	        {
	            project.IPM_PrepareForArchival__c= true;
	            projids.add(project.id);
	        }  
	        update projectList;
	        List<IPM_Project__c> prepareForArchivalProjects = [Select Id,IPM_PrepareForArchival__c,IPM_Stopped_By__c,IPM_Stopped_Phase__c,IPM_Stopped_At_Span__c,
        													IPM_Document_Update_Comments__c,IPM_Phase__c,IPMProject_Span__c,IPM_Stopped_Comments__c
         												   from IPM_Project__c where Id in:projids and IPM_Parent_Project__c in:projids ];  
	        system.debug('prepareForArchivalProjects ====>'+prepareForArchivalProjects);
	        //check that regional projects are also in prepare for archival state
	        for(IPM_Project__c project : prepareForArchivalProjects)
	        {
	        	System.assertEquals(project.IPM_PrepareForArchival__c,true,'projects are not in archival state');
	        	System.assertEquals(project.IPM_Stopped_By__c,UserInfo.getUserId(),'projects Archieved by user is not updated');
	        	System.assertEquals(project.IPM_Stopped_At_Span__c,'Global','projects Archieved span is not updated');
	        	System.assertEquals(project.IPM_Document_Update_Comments__c,project.IPM_Stopped_Comments__c,'projects Archieved comment updated');
	       }
	       /************Project is stopped**************************/
	       for(IPM_Project__c project : projectList)
	        {
	            project.Is_Archieved__c= true;
	            projids.add(project.id);
	        }  
	        update projectList;
	        List<IPM_Project__c> archivalProjects = [Select Id,IPM_PrepareForArchival__c,IPM_Stopped_By__c,IPM_Stopped_Phase__c,IPM_Stopped_At_Span__c,Is_Archieved__c,
        													IPM_Document_Update_Comments__c,IPM_Phase__c,IPMProject_Span__c,IPM_Stopped_Comments__c,
        													(SELECT id,IPM_Stopped_Date__c,IPM_Updated_User_By__c,IPM_Stopped_Comments__c,IPM_Document_Status__c,IPM_GateDocuments__c From Project_Documents__r limit 10000),
													        (SELECT id from Tasks__r where IPM_StoppedByProject__c in:projids limit 10000), 
													        (SELECT id from IPM_Countries__r where IPM_StoppedByProject__c in:projids limit 10000), 
													        (SELECT id from IPM_Countries1__r where IPM_StoppedByProject__c in:projids limit 10000),
													        (SELECT id from IPM_Countries2__r where IPM_StoppedByProject__c in:projids limit 10000),
													        (SELECT id from IPM_Project_Resources__r  limit 10000), 
													        (SELECT id from IPM_Project_Rollout__r  where IPM_StoppedByProject__c in:projids limit 10000),
													        (SELECT id from Regional_Project_Rollout__r  where IPM_StoppedByProject__c in:projids limit 10000),
													        (SELECT id from Local_Project_Rollout__r  where IPM_StoppedByProject__c in:projids limit 10000),
													        (SELECT id from IPM_Financials_Consolidated__r where IPM_StoppedByProject__c in:projids limit 10000),
													        (SELECT id from IPM_Financials_Regional__r where IPM_StoppedByProject__c in:projids limit 10000),
													        (SELECT id from IPM_Financials_Local__r where IPM_StoppedByProject__c in:projids limit 10000)
         												   from IPM_Project__c where Id in:projids and IPM_Parent_Project__c in:projids ];  
	        system.debug('archivalProjects ====>'+archivalProjects);
	        //check that regional projects are also in prepare for archival state
	        for(IPM_Project__c project : archivalProjects)
	        {
	        	System.assertEquals(project.IPM_PrepareForArchival__c,false,'projects are not in archival state');
	        	System.assertEquals(project.IPM_Stopped_By__c,UserInfo.getUserId(),'projects Archieved by user is not updated');
	        	System.assertEquals(project.IPM_Stopped_At_Span__c,'Global','projects Archieved span is not updated');
	        	System.assertEquals(project.IPM_Document_Update_Comments__c,project.IPM_Stopped_Comments__c,'projects Archieved comment updated');
	       }
	       /************Project is reactivated**************************/
	       for(IPM_Project__c project : projectList)
	        {
	            project.Is_Archieved__c= false;
	            projids.add(project.id);
	        }  
	        update projectList;
	        List<IPM_Project__c> unArchivalProjects = [Select Id,IPM_PrepareForArchival__c,IPM_Stopped_By__c,IPM_Stopped_Phase__c,IPM_Stopped_At_Span__c,Is_Archieved__c,
        													IPM_Document_Update_Comments__c,IPM_Phase__c,IPMProject_Span__c,IPM_Stopped_Comments__c,
        													(SELECT id,IPM_Stopped_Date__c,IPM_Updated_User_By__c,IPM_Stopped_Comments__c,IPM_Document_Status__c,IPM_GateDocuments__c From Project_Documents__r limit 10000),
													        (SELECT id from Tasks__r where IPM_StoppedByProject__c in:projids limit 10000), 
													        (SELECT id from IPM_Countries__r where IPM_StoppedByProject__c in:projids limit 10000), 
													        (SELECT id from IPM_Countries1__r where IPM_StoppedByProject__c in:projids limit 10000),
													        (SELECT id from IPM_Countries2__r where IPM_StoppedByProject__c in:projids limit 10000),
													        (SELECT id from IPM_Project_Resources__r  limit 10000), 
													        (SELECT id from IPM_Project_Rollout__r  where IPM_StoppedByProject__c in:projids limit 10000),
													        (SELECT id from Regional_Project_Rollout__r  where IPM_StoppedByProject__c in:projids limit 10000),
													        (SELECT id from Local_Project_Rollout__r  where IPM_StoppedByProject__c in:projids limit 10000),
													        (SELECT id from IPM_Financials_Consolidated__r where IPM_StoppedByProject__c in:projids limit 10000),
													        (SELECT id from IPM_Financials_Regional__r where IPM_StoppedByProject__c in:projids limit 10000),
													        (SELECT id from IPM_Financials_Local__r where IPM_StoppedByProject__c in:projids limit 10000)
         												   from IPM_Project__c where Id in:projids and IPM_Parent_Project__c in:projids ];  
	        system.debug('unArchivalProjects ====>'+unArchivalProjects);
	        //check that regional projects are also in prepare for archival state
	        for(IPM_Project__c project : unArchivalProjects)
	        {
	        	System.assertEquals(project.Is_Archieved__c,false,'projects are not in archival state');
	        	System.assertEquals(project.IPM_PrepareForArchival__c,false,'projects are not in archival state');
	        	System.assertEquals(project.IPM_Stopped_By__c,null,'projects Archieved by user is not updated');
	        	System.assertEquals(project.IPM_Stopped_At_Span__c,null,'projects Archieved span is not updated');
	        	System.assertEquals(project.IPM_Document_Update_Comments__c,null,'projects Archieved comment updated');
	       }
	    }
	 }
}