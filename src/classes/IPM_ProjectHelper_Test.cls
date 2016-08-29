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
    public static final String ASSERT_ERROR_STR = 'Projects not Created Properly.Actual size should be ';
     
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
            
            for(IPM_Project__c project : projectList)
            {
                project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
            }  
            update projectList;
            List<IPM_Project__c> dbProjectList =  [Select Id from IPM_Project__c where id in :projectList];
            System.assertEquals(dbProjectList.size(),projectList.size(),ASSERT_ERROR_STR+projectList.size());
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
        User localProjectLeader = null;
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
            if(lUser.lastName == 'LOCAL_PL')
            {
                localProjectLeader = lUser;
            }
        }
        
        System.RunAs(globalProjectLeader)
        {
            createRegionalProjects(projectNameSet, globalProjectIdList, projectMap,globalProjectLeader,regionalProjectLeader); 
        }
        Test.stopTest();
        List<IPM_Project__c> regionalProjects = new List<IPM_Project__c>();
        
        System.RunAs(globalProjectLeader)
        {
            Map<Id,List<IPM_Project__c>> globalToRegionalMap = IPM_TestFactory_Helper.getRegionalProjects(globalProjectIdList);

            for(Id gbProjectId : globalToRegionalMap.keySet())
            {
               regionalProjects.addAll(globalToRegionalMap.get(gbProjectId)); 
            }
            
            List<IPM_Project__c> DBRegionalProjects = [Select Id,Name,IPM_Phase__c,IPM_Parent_Project__c, IPMProject_Span__c, (Select Id from Project_Documents__r),(Select Id,IPM_Regional_PL__c,IPM_Project_Job_Status__c,IPM_RolloutJobType__c,IPM_Rollout_Project__c from Regional_Project_Rollout__r),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r) from IPM_Project__c where ID in :regionalProjects];  
                
            List<IPM_Project_Rollout__c> localRolloutsTobeProcessed = new List<IPM_Project_Rollout__c>();
            Set<Id> regionalProjectsTobeProcessed = new Set<Id>();
            System.assert(DBRegionalProjects.size() > 0 , 'Regional Projects Generated from Transaction Management');
            for(IPM_Project__c regionalProject : DBRegionalProjects) 
            {
               Id parentGlobalProjectId = regionalProject.IPM_Parent_Project__c;
                
               IPM_Project__c parentGlobalProject = projectMap.get(parentGlobalProjectId);
                
               // Only Contract document Available at Regional Level.
               System.assertEquals(regionalProject.Project_Documents__r.size(),1,'Contract Document either doesnt have a document or has more document');
   
               // MileStones would Copy from Parent Project. 
               System.assertEquals(regionalProject.IPM_Milestones__r.size(),parentGlobalProject.IPM_Milestones__r.size(),'Milestones didnt copy from Parent Project Properly');
                List<IPM_Project_Rollout__c> localRolloutList = regionalProject.Regional_Project_Rollout__r;
                System.assert(localRolloutList.size() > 0 ,'Local Rollouts not Associated '); // Phase would be feasibility for Regional Projects.
                for(IPM_Project_Rollout__c localRollout : localRolloutList)
                {
                    localRollout.IPM_Regional_PL__c = localProjectLeader.Id;
                    localRollout.IPM_Project_Job_Status__c = 'Eligible For Processing';
                    localRollout.IPM_RolloutJobType__c = 'Adhoc - Rollout Project Creation';
                    localRolloutsTobeProcessed.add(localRollout);  
            }
                regionalProjectsTobeProcessed.add(regionalProject.Id);
        }
        
            System.assert(localRolloutsTobeProcessed.size() > 0,'Process Local Rollouts for Local Project Creation failed');

            if(!localRolloutsTobeProcessed.isEmpty())
        {
                IPM_ProjectJob_Queue.PROJECT_QUEUE_CONTEXT_STARTED  = true; // To make sure that we dont invoke Queueable interface.
                IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
                update localRolloutsTobeProcessed;

                Set<Id> rolloutIdSet = new Set<Id>(); 
                Set<String> rolloutNameSet = new Set<String>(); 
            
                for(IPM_Project_Rollout__c rollout : localRolloutsTobeProcessed)
            {
                    rolloutIdSet.add(rollout.Id);
                    rolloutNameSet.add(rollout.IPM_Rollout_Project__c); 
                }

                updateRegionalProjectPhase(rolloutIdSet,regionalProjectsTobeProcessed,rolloutNameSet,DBRegionalProjects,projectMap);
                
                updateGlobalProjectPhase(DBRegionalProjects,projectMap); 
            }
        } 
     } 

     private static void updateRegionalProjectPhase(Set<Id> rolloutIdSet,Set<Id> regionalProjectsTobeProcessed, Set<String> rolloutNameSet,List<IPM_Project__c> DBRegionalProjects,Map<Id,IPM_Project__c> projectMap)
                {
        Map<Id,IPM_Project__c> projectDetailMap = IPM_ProjectJobHelper.populateProjectDetails(regionalProjectsTobeProcessed);

        // Get newly Created Rollout Projects and insert them into Database.
        IPM_ProjectJobHelper.processRollouts(projectDetailMap,rolloutIdSet,null); 

        List<IPM_Project__c> localProjects = [Select Id,Name,IPM_Project_Name__c from IPM_Project__c where  IPM_Project_Name__c IN :rolloutNameSet ];
        System.assert(localProjects.size() > 0,'Local Projects not created');
        projectDetailMap = IPM_ProjectJobHelper.populateProjectDetails(regionalProjectsTobeProcessed);
        IPM_ProjectJobHelper.processProjects(projectDetailMap,null); 
        Set<Id> capabilityProcessingSet = new Set<Id>();
        for(IPM_Project__c regionalProject : DBRegionalProjects) 
        {
            regionalProject.IPM_Temporary_Phase__c  = 'Capability';
            capabilityProcessingSet.add(regionalProject.Id);
                }
                
        update DBRegionalProjects; 
        // Start Processing incoming Projects now and We would be performing Phase specific updates on projects.
        projectDetailMap = IPM_ProjectJobHelper.populateProjectDetails(capabilityProcessingSet);
        IPM_Project_Type__c regionalProjectType =  IPM_Utils.retrieveProjectType(projectDetailMap.values().get(0));
        regionalProjectType.IPM_Fast_Forward_Phase_Change__c = true;
        update regionalProjectType;
        IPM_ProjectJobHelper.processProjects(projectDetailMap,null);   
        Set<Id> MarketReadyProcessingSet = new Set<Id>();
        for(IPM_Project__c localProject : localProjects)
        {
            localProject.IPM_Temporary_Phase__c  = 'Market Ready';
            MarketReadyProcessingSet.add(localProject.Id);
        }
                
        update localProjects;
        // Start Processing incoming Projects now and We would be performing Phase specific updates on projects.
        projectDetailMap = IPM_ProjectJobHelper.populateProjectDetails(MarketReadyProcessingSet);
        IPM_ProjectJobHelper.processProjects(projectDetailMap,null);  

                
        Set<Id> MarketDeployProcessingSet = new Set<Id>(); 

        for(IPM_Project__c localProject : localProjects)
        {
            localProject.IPM_Temporary_Phase__c  = 'Market Deployment';
            MarketDeployProcessingSet.add(localProject.Id);
        }
                
        update localProjects;
            }
     private static void updateGlobalProjectPhase(List<IPM_Project__c> DBRegionalProjects,Map<Id,IPM_Project__c> projectMap)
     {
        // Start Processing incoming Projects now and We would be performing Phase specific updates on projects.
        for(IPM_Project__c globalProject : projectMap.values())
        {
            globalProject.IPM_Temporary_Phase__c  = 'Capability';
        }
      
        update projectMap.values(); 
            
        Map<Id,IPM_Project__c> projectDetailMap = IPM_ProjectJobHelper.populateProjectDetails(projectMap.keySet());
        IPM_ProjectJobHelper.processProjects(projectDetailMap,null); 
        for(IPM_Project__c globalProject : projectMap.values())
        {
            globalProject.IPM_Temporary_Phase__c  = 'Market Ready';
        }
        update projectMap.values();
        projectDetailMap = IPM_ProjectJobHelper.populateProjectDetails(projectMap.keySet());
        IPM_Project_Type__c globalProjectType =  IPM_Utils.retrieveProjectType(projectDetailMap.values().get(0));
        globalProjectType.IPM_Fast_Forward_Phase_Change__c = true;
        update globalProjectType;
        IPM_ProjectJobHelper.processProjects(projectDetailMap,null);  
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
    
    public static list<IPM_Project_Rollout__c> createRegionalRollout(List<IPM_Project__c> projectList, User globalProjectLeader,User regionalProjectLeader)
    {
        List<IPM_Project_Rollout__c> regionalRolloutList = new List<IPM_Project_Rollout__c>();
        System.RunAs(globalProjectLeader)
        {
            /******************************** Create Regional Rollouts for Created Global project ****************************************/
            regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{regionalProjectLeader,regionalProjectLeader,regionalProjectLeader});
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
            System.assertEquals(dbRolloutList.size(),localRolloutList.size(),ASSERT_ERROR_STR+localRolloutList.size());
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
            System.assertEquals(dbCountryList.size(),countryList.size(),ASSERT_ERROR_STR+countryList.size());
            
        }
        return regionalRolloutList;
    }
    
     /**
        *  Used to test when global project is in phase of stopping, regional project should also be in the same phase
        *  @name : projectDataCreation
     */ 
     public static testmethod void testForArchivalProject(){
        
        List<User> userList = [Select Id,Name,lastName from User where LastName in('GLOBAL_PL','REGIONAL_PL','LOCAL_PL')];
        
        User globalProjectLeader = null; 
           
        // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(userList); 
        
        for(User lUser  :userList)
        {
            if(lUser.lastName == 'GLOBAL_PL')
            {
                globalProjectLeader = lUser;
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
     
     public static void createRegionalProjects(set<String> projectNameSet, List<Id> globalProjectIdList, Map<Id,IPM_Project__c> projectMap,User globalProjectLeader,User regionalProjectLeader){
         
         	List<IPM_Project__c> projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r),
                                                    (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
                                                    (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
            for(IPM_Project__c project : projectList)
            {
            	project.IPM_Fast_Track_Project__c= true;
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
            System.assertEquals(dbRolloutList.size(),localRolloutList.size(),ASSERT_ERROR_STR+localRolloutList.size());
            insertCountry(localRolloutList);
            /******************************** Initiate Phase Change and Regional Project Creation  ****************************************/
            List<IPM_Project_Document__c> projectDocumentList = new List<IPM_Project_Document__c>();
            // Already Added ProjectId's
            for(IPM_Project__c project : projectList)
            {
                projectDocumentList.add(project.Project_Documents__r);
            }  
            insertCMIRecords(projectList, projectDocumentList);
            for(IPM_Project__c project : projectList)
            {
                globalProjectIdList.add(project.Id);    
            }
            // Initiate Phase Change would result in Rollout Project Creation.
            List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(globalProjectIdList,globalProjectLeader); 
            update projectListPhaseChange;
     }
   	private static void insertCountry(List<IPM_Project_Rollout__c>  localRolloutList)
   	{
            // Create Country specific information.
            List<IPM_Country__c> countryList= new List<IPM_Country__c>();
            
            List<String> iscodes = new List<String>{'AG','BR'}; 
            List<MDO_Geography__c> geoList =  new List<MDO_Geography__c>();
            Map<String,MDO_Geography__c> geoMap = new Map<String,MDO_Geography__c>();
            for(String isoCode : iscodes)
            {
                geoList.add(new MDO_Geography__c(ISO_3166_1_Code__c = isoCode));
            }
            insert geoList;
            System.assert(geoList[0].Id != null,'Geo not Created');
            for(MDO_Geography__c geoObj : geoList)
            {
                geoMap.put(geoObj.ISO_3166_1_Code__c,geoObj);
            }
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
                
                IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = geoMap.get(geoExternalId).Id,IPM_Project__c = localRollout.IPM_Project__c,
                    local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO',isActive__c = true);  
                
                countryList.add(tempCountry);
            }
            
            insert countryList;
            List<IPM_Country__c> dbCountryList =  [Select Id,Country_Code__c from IPM_Country__c where id in :countryList AND MDO_Geography__r.ISO_3166_1_Code__c = 'BR'];
            System.assert(dbCountryList.size()>0);
            
            
            
            }  
   	
    private static void insertCMIRecords(List<IPM_Project__c> projectList, List<IPM_Project_Document__c> projectDocumentList)
	{
            IPM_ProjectDocumentSectionContentHandler.SKIP_TRIGGER_EXECUTION  = true;
            IPM_ProjectSectionContentHelper.SKIP_TRIGGER_EXECUTION = true;
            //Insert CMI Records. 
            Map<Id,IPM_Gate_CMI__c> projectSpecificCMIGates = new Map<Id,IPM_Gate_CMI__c>();
            List<IPM_Project_Document_Section__c> updatedDocumentSectionList = new List<IPM_Project_Document_Section__c>();
            String selectedCountry = 'AG';
            //Getting Gate CMI Test's and Corresponding KPI's
        Set<Id>  alreadyAddedProjectIds = new Set<Id>();
            
            Map<String,IPM_Gate_CMI_KPI_Inputs__c> testKPIMap=new Map<String,IPM_Gate_CMI_KPI_Inputs__c>();

            for(IPM_Gate_CMI_KPI_Inputs__c testKPI : IPM_Gate_CMI_KPI_Inputs__c.getall().values())
            {
                testKPIMap.put(testKPI.IPM_Test__c,testKPI);
            }   
            for(IPM_Project_Document__c projectDocument : [SELECT ID,IPM_Project__c,( Select Id from IPM_Project_Sections__r LIMIT 10) from IPM_Project_Document__c where Id in :projectDocumentList])
            {
                if(!alreadyAddedProjectIds.contains(projectDocument.IPM_Project__c))
                {
                    for(IPM_Project_Document_Section__c projectDocumentSection :  projectDocument.IPM_Project_Sections__r)
                    {
                        String cmiName = 'Charter/Concept/Idea Screener - Nielsen'; 
                        String[] testValues = cmiName.split(IPM_ConstantUtils.Slash);
                        IPM_Gate_CMI__c gateCMI = new IPM_Gate_CMI__c();
                        gateCMI.IPM_Project__c = projectDocument.IPM_Project__c;
                        gateCMI.gate__c = testValues[0];
                        gateCMI.Element__c = testValues[1];
                        gateCMI.Test__c = testValues[2];
                        gateCMI.IPM_CMI_Added_At__c = 'Charter';
                        gateCMI.Country__c = selectedCountry;
                        if(testKPIMap.get(gateCMI.Test__c)!=null)
                        {
                            gateCMI.KPI__c = testKPIMap.get(gateCMI.Test__c).IPM_KPI__c;
                            gateCMI.IPM_CMI_Overall_Colour_Score_Method__c= testKPIMap.get(gateCMI.Test__c).IPM_Overall_Colour_Score_Method__c;
                        }   
                        projectSpecificCMIGates.put(projectDocumentSection.Id,gateCMI);
                        projectDocumentSection.IPM_CMI_Selected_Test_Concepts__c = cmiName;
                        projectDocumentSection.IPM_Master_Section_External_Id__c = 'Mix_Qualification_Plan_and_Action_Standards';
                        projectDocumentSection.IPM_CMI_Selected_Countries__c = selectedCountry;
                        updatedDocumentSectionList.add(projectDocumentSection);
                    } 
                    alreadyAddedProjectIds.add(projectDocument.IPM_Project__c);
                }
            }
            insert projectSpecificCMIGates.values(); 
            update updatedDocumentSectionList;
            
            List<IPM_Project_Document_Section_Content__c> projDocSecConList = new List<IPM_Project_Document_Section_Content__c>();
             //Creating Gate CMI Content         
            for(Id projectDocSectionId : projectSpecificCMIGates.KeySet())
            {
                IPM_Gate_CMI_KPI_Inputs__c kpiInputs=new IPM_Gate_CMI_KPI_Inputs__c();
                IPM_Gate_CMI__c gateCMI = projectSpecificCMIGates.get(projectDocSectionId);
                 //Getting KPI Inputs
                for(IPM_Gate_CMI_KPI_Inputs__c kpi:IPM_Gate_CMI_KPI_Inputs__c.getall().values())
                {
                    if(kpi.IPM_Test__c == gateCMI.Test__c && kpi.IPM_KPI__c == gateCMI.KPI__c)
                    {
                        kpiInputs=kpi;
                    }
                }
                IPM_Project_Document_Section_Content__c projDocSecCon = new IPM_Project_Document_Section_Content__c();
                projDocSecCon.IPM_Gate_CMI__c = gateCMI.Id;
                projDocSecCon.IPM_Content_Type__c = IPM_ConstantUtils.CMIGATE_CONTENT_TYPE;
                projDocSecCon.IPM_CMI_Country__c = selectedCountry;
                projDocSecCon.IPM_Country__c = selectedCountry;
                projDocSecCon.IPM_CMI_Is_Free_Text__c = true;
                projDocSecCon.IPM_CMI_Input__c = '1';
                projDocSecCon.IPM_Project_Document_Section__c = projectDocSectionId;
                projDocSecCon.IPM_CMI_Overall_Colour_Coding_Method__c= kpiInputs.IPM_Overall_Colour_Score_Method__c;
                projDocSecCon.IPM_CMI_Overall_Score_Label__c=kpiInputs.IPM_Overall_Score_Label__c;
                projDocSecConList.add(projDocSecCon);
            }
            insert  projDocSecConList;
            IPM_ProjectDocumentSectionContentHandler.SKIP_TRIGGER_EXECUTION  = false;
            IPM_ProjectSectionContentHelper.SKIP_TRIGGER_EXECUTION = false;
            List<IPM_Gate_CMI__c>  globalProjectCMIList = [SELECT id,IPM_CMI_Added_At__c,Gate__c,Country__c,Element__c,Test__c,KPI__c,Input__c,Results__c,IPM_CMI_Overall_Colour_Score_Method__c,Approx_Results_Timing__c,IPM_Skip_Test__c,IPM_Skip_Test_Reason__c FROM IPM_Gate_CMI__c where IPM_Project__c in :projectList];
            System.assert(globalProjectCMIList.size()>0);
            }
            
            
	
}
