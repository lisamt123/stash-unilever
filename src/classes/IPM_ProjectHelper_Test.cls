/**
   @Author Cognizant Techinology Solutions
   @name IPM_ProjectHelper_Test
   @CreateDate 8/20/2015
   @Description Test Class for testing project specific helpers.
   @Version 1.0
   @reference Project Creation and Phase Change
  */
  
@isTest
public with sharing class IPM_ProjectHelper_Test 
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
            
            Id  mileMasterRecordType = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.mileMRecordType).getRecordTypeId();
            Map<Id,IPM_Milestone__c>  standardMileStoneMap = new Map<Id,IPM_Milestone__c>([Select Id,Name,IPM_Type_of_Milestone__c from IPM_Milestone__c where IPM_Type_of_Milestone__c ='Standard' AND recordTypeId =:mileMasterRecordType AND IPM_Project_Type__c='Original' ] );
        
            // Get Standard Milestones from database  
            System.assert(standardMileStoneMap.values().size() > 0);
            
            /********************************Global Project Leaders Project View and Data Access****************************************/
            for(IPM_Project__c project : projectList)
            {
                // Once project is created Charter document would be available.
                System.assertEquals(project.Project_Documents__r.size(),1);
                
                // Once project is created, Project associated tasks would be based on Selected Complexity.
                for(IPM_Task__c task : project.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,project.IPM_Complexity__c);     
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assertEquals(project.IPM_Milestones__r.size(),standardMileStoneMap.size());
                
                // Once project is created , Consolidated financials are getting generated.
                System.assertEquals(project.IPM_Financials_Consolidated__r.size(),1); // One for Global consolidated Financials
                
                // Project default phase would always be set as IDEAS.
                System.assertEquals(project.IPM_Phase__c,'Ideas'); // Phase would be always ideas for Global Project.
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
               System.assertEquals(regionalProject.Project_Documents__r.size(),1);
   
               // MileStones would Copy from Parent Project. 
               System.assertEquals(regionalProject.IPM_Milestones__r.size(),parentGlobalProject.IPM_Milestones__r.size());
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
                System.assert(regionalProject.Tasks__r.size()>0);
                
                for(IPM_Task__c task : regionalProject.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,regionalProject.IPM_Complexity__c);
                    System.assertEquals(task.IPM_Phase__c,regionalProject.IPM_Phase__c);   
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assert(regionalProject.IPM_Milestones__r.size()>0);
                
                // Once project is created , Consolidated financials are getting generated.
                System.assertEquals(regionalProject.IPM_Financials_Consolidated__r.size(),3); // One for Global consolidated Financials and 2 for individual Rollouts
                
                // Project default phase would always be set as feasibility.
                System.assertEquals(regionalProject.IPM_Phase__c,'Feasibility'); // Phase would be feasibility for Regional Projects.
                
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
            IPM_ProjectJobHelper.markProjectAsFailed(projids);
        }
     }
     
     public static testmethod void testEcodesignSyncStatus()
     {
        List<User> users = [Select Id,Email from User where LastName = 'GLOBAL_PL' limit 1];        
        User globalUser = null;
        globalUser = users[0];
               
        // Create Regional Projects.
        System.runAs(globalUser)
        {
            Test.startTest();
            IPM_Project__c proj = [Select Id,EcoDesign_Sync_Status__c,Fetch_Timestamp_Mulesoft__c,Success_TimeStamp_EcoDesign__c,
                                    BET_Update__c,BET_Link_Requested__c,BET_Link_Requested_on_Date__c,IPM_SourceProjectType__c,IPM_Project_Type__c,
                                    IPM_Answer_of_Q1__c from IPM_Project__c limit 1000][0];
            proj.EcoDesign_Sync_Status__c = 'Ready';
            update proj;
            
            proj.EcoDesign_Sync_Status__c = 'Success';
            update proj;
            
            IPM_Project__c projNew = [Select Id,EcoDesign_Sync_Status__c,Fetch_Timestamp_Mulesoft__c,Success_TimeStamp_EcoDesign__c from IPM_Project__c limit 1000][0];
            System.assertEquals('Ready',projNew.EcoDesign_Sync_Status__c);
            
            proj.EcoDesign_Sync_Status__c = 'Error';
            update proj;
            
            proj.EcoDesign_Sync_Status__c = 'In Progress';
            update proj;
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
            addnewValue.id=projNew.id;
            addnewValue.IPM_Project_Leader__c=globalUser.id;
            addnewValue.IPM_Technical_Project_Leader__c=globalUser.id;
            addnewValue.Deputy_Project_Leader__c=globalUser.id;
            addnewValue.IPM_Project_Gatekeeper__c=globalUser.id;
            addnewValue.IPM_Finance_Member__c=globalUser.id;
            projNewList.add(addnewValue);
            oldProjectMap.put(projNew.id,addnewValue);
            IPM_ProjectTriggerHandler.getProjectUsersMap(projNewList, oldProjectMap, false) ;
            proj.Created_in_error__c=true;
            update proj;
            
            Test.stopTest();
        }
         
        
     }
   
}