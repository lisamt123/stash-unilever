/****************************************************************************************************************************
@Author Cognizant
@name IPM_ProjectRolloutHandler_Test
@CreateDate 20/08/2015
@Description Test Class for apex class-IPM_RolloutTriggerHandler
@Version 1.0
@Business Logic:This class invokes various test methods to validate Rollout related flows including Insert/Update/Delete of Regional/Local Rollouts.
*/
@isTest
private class IPM_ProjectRolloutHandler_Test
{

    private static final Set<String> USER_LIST= new Set<string>{'GLOBAL_PL','REGIONAL_PL','LOCAL_PL','FINANCE_PL_SECOND','FINANCE_PL'};
    private static final string GLOBAL_LASTNAME='GLOBAL_PL';
    private static final string REGIONAL_LASTNAME='REGIONAL_PL';
    private static final string LOCAL_LASTNAME='LOCAL_PL';
    private static final string FINANCE1_LASTNAME='FINANCE_PL';
    private static final string FINANCE2_LASTNAME='FINANCE_PL_SECOND';
    private static final string WITH_MCO='With MCO';
    private Static User globalProjectLeader = null;
    private Static User regionalProjectLeader = null;
    private Static User localProjectLeader = null;
    private Static User financeLeader= null;
    private Static User financeLeaderSecond = null;
    private static final Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
    private static String IDEAS = 'Ideas';
    private static String PROJECT_MILESTONE_NOT_EQUIVALENT_STANDARD_MILESTONE = 'Project Milestones size is not equivalent to Standard milestones size';
    private static String TASK_COMPLEXITY_NOT_EQUIVALENT_PROJECT_COMPLEXITY = 'Task Complexity is not equivalent to project complexity';
    private static String NO_CONSOLIDATED_FINANCIAL_CREATED = 'No consolidated financial created for the project';

    /**************************************************************
    * @description: Used for Creating IPM Project data for Rollout flow test
    * NPATHComplexity: This function is used for creating/setting up IPM Company Card, IPM Project data, IPM Project Master data along with Sharing 
    * for validating Rollout flows.            
    */
    @testSetup static void testRolloutSetup() 
    {
        // Create an instance of admin user.
        User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
        
       
        
        // Create an instances of standard Users for Allocation to Project Leaders.
        System.runAs(adminUser)
        {   
            globalProjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            financeLeader  =IPM_TestFactory_Helper.createIPMPlatformProfileUser(''); 
            financeLeaderSecond =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');  
            // Update LastNames to match functionalRoles
            globalProjectLeader.lastname = GLOBAL_LASTNAME;
            regionalProjectLeader.lastname = REGIONAL_LASTNAME;
            localProjectLeader.lastname = LOCAL_LASTNAME; 
            financeLeader.lastname = FINANCE1_LASTNAME;
            financeLeaderSecond.lastname = FINANCE2_LASTNAME;
            
            List<User> userList = new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader,financeLeader,financeLeaderSecond};
            update userList;
            
              
            
            
            // Create Company Card information(Master Data)
            IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
            IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
            IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
            
            List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
            insert companyCardList;
            
            set<Id> companyId = new set<Id>();
            for(IPM_Company_Card__c company: companyCardList)
            {
                companyId.add(company.id);
            }
            
            List<IPM_Company_Card__c> companyCardAssertList = [select id from IPM_Company_Card__c where id in : companyId];
            system.assertEquals(3,companyCardAssertList.size(),'Number of company card inserted is not 3 ');
            
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
            
            set<Id> projId = new set<Id>();
            for(IPM_Project__c proj : projectList)
            {
               projId.add(proj.id); 
            }
            
            List<IPM_Project__c> projectAssertList = [select Name from IPM_Project__c where id in : projId];
            system.assertEquals(3,projectAssertList.size(),'Number of Project is not 3');
            
        }
        
        
    }
    
    /**************************************************************
    * @description: Used for Creating IPM Project data
    * NPATHComplexity: This function is used for creating/updating IPM Project, Milestone, IPM Country, Rollout data for checking Rollout flows. As the method validates flows for multi-layered
    * flows/processes for Global/Regional/Local Projects/Rollouts, NPATH complexity is high.                
    */
    public static testmethod void createProject()
    {
        // Get the newly created Projects from Database.        
        List<Id> globalProjectIdList = new List<Id>();
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        
      
        Test.startTest();
        // Get the list of user's for project leaders.
        List<User> userList = [Select Id,Name,lastName from User where LastName in:USER_LIST];
        system.assertEquals(5,userList.size(),'Users not created');
        
        // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(userList); 
        
        for(User lUser  :userList)
        {
            if(lUser.lastName == GLOBAL_LASTNAME)
            {
                globalProjectLeader = lUser;
            }
            if(lUser.lastName == REGIONAL_LASTNAME)
            {
                regionalProjectLeader = lUser;
            }
            if(lUser.lastName == FINANCE1_LASTNAME)
            {
                financeLeader = lUser;
            }
           
        }
        
        System.RunAs(globalProjectLeader)
        {
            List<IPM_Project__c> projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r),
            (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
            (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
            for(IPM_Project__c project : projectList)
            {
                projectMap.put(project.Id,project);
            }
            
            Id  mileMasterRecordType = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.mileMRecordType).getRecordTypeId();
            Map<Id,IPM_Milestone__c>  standardMileStoneMap = new Map<Id,IPM_Milestone__c>([Select Id,Name,IPM_Type_of_Milestone__c from IPM_Milestone__c where IPM_Type_of_Milestone__c ='Standard' AND recordTypeId =:mileMasterRecordType AND IPM_Project_Type__c='Original' ] );
            
            // Get Standard Milestones from database  
            System.assert(standardMileStoneMap.values().size() > 0,' No Milestones is created');
            
            /********************************Global Project Leaders Project View and Data Access****************************************/
            for(IPM_Project__c project : projectList)
            {
                // Once project is created Charter document would be available.
                System.assertEquals(project.Project_Documents__r.size(),1,'No Project Document is created');
                
                // Once project is created, Project associated tasks would be based on Selected Complexity.
                for(IPM_Task__c task : project.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,project.IPM_Complexity__c,'Task Complexity is different from project complexity');     
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assertEquals(project.IPM_Milestones__r.size(),standardMileStoneMap.size(),'Project Milestones size is different from  Standard milestones size');
                
                // Once project is created , Consolidated financials are getting generated.
                System.assertEquals(project.IPM_Financials_Consolidated__r.size(),1,'There will be 1 consolidated financial with respect to each project'); // One for Global consolidated Financials
                
                // Project default phase would always be set as IDEAS.
                System.assertEquals(project.IPM_Phase__c,IDEAS,'Global Project phase is not Ideas'); // Phase would be always ideas for Global Project.
            }
            
            /******************************** Create Regional Rollouts for Created Global project ****************************************/
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{regionalProjectLeader,regionalProjectLeader,regionalProjectLeader});
            for(IPM_Project_Rollout__c regionalRollout : regionalRolloutList )
            {
                regionalRollout.Target_Launch_Date__c = Date.today();
                regionalRollout.Finance_Member__c = financeLeader.id;
                regionalRollout.IPM_RolloutJobType__c= IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
                regionalRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                
            }
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
            for(IPM_Project_Rollout__c localRollout : localRolloutList )
            { 
                localRollout.Target_Launch_Date__c = Date.today();
                localRollout.Finance_Member__c = financeLeader.id;
                localRollout.IPM_RolloutJobType__c= IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
                localRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
            }
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
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = WITH_MCO,isActive__c = true);    
                
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
        
       
        //
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
                System.assertEquals(regionalProject.Project_Documents__r.size(),1,' No Document is created for Regional Project');

                // MileStones would Copy from Parent Project. 
                System.assertEquals(regionalProject.IPM_Milestones__r.size(),parentGlobalProject.IPM_Milestones__r.size(),'No of Regional project milestones created is different global project');
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
                System.assert(regionalProject.Tasks__r.size()>0,'No task created for regional project');
                
                for(IPM_Task__c task : regionalProject.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,regionalProject.IPM_Complexity__c,'Regional Project Complexity & Task complexity is different');
                    System.assertEquals(task.IPM_Phase__c,regionalProject.IPM_Phase__c,'Regional Project & task phase is different');   
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assert(regionalProject.IPM_Milestones__r.size()>0,'No milestones are created for regional project');
                
                // Once project is created , Consolidated financials are getting generated.
                System.assertEquals(regionalProject.IPM_Financials_Consolidated__r.size(),3,'No Consolidated financials is created for Regional Project'); // One for Global consolidated Financials and 2 for individual Rollouts
                
                // Project default phase would always be set as feasibility.
                System.assertEquals(regionalProject.IPM_Phase__c,'Feasibility','Global Project phase is not feasibility'); // Phase would be feasibility for Regional Projects.
                
            }
        }
    }
    
    /**************************************************************
    * @description: Used for testing flow for updating Regional Rollout TLD
    * NPATHComplexity: This function is used for checking the flow for Regional Rollout data update including multiple Rollouts. This method also checks for
    * data validation for IPM Project Milestones, IPM Tasks, IPM Country etc. 
    */
    public static testmethod void updateRegionalRolloutTLD()
    {
        
        // Get the newly created Projects from Database. 
        
       
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
      
        
        Test.startTest();
        // Get the list of user's for project leaders.
        List<User> userList = [Select Id,Name,lastName from User where LastName in:USER_LIST];
        
        // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(userList); 
        
        for(User lUser  :userList)
        {
            if(lUser.lastName == GLOBAL_LASTNAME)
            {
                globalProjectLeader = lUser;
            }
            if(lUser.lastName == REGIONAL_LASTNAME)
            {
                regionalProjectLeader = lUser;
            }
            if(lUser.lastName == FINANCE1_LASTNAME)
            {
                financeLeader = lUser;
            }
            if(lUser.lastName == FINANCE2_LASTNAME)
            {
                financeLeaderSecond = lUser;
            }
        }
        
        System.RunAs(globalProjectLeader)
        {
            List<IPM_Project__c> projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r),
            (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
            (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
            for(IPM_Project__c project : projectList)
            {
                projectMap.put(project.Id,project);
            }
            
            Id  mileMasterRecordType = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.mileMRecordType).getRecordTypeId();
            Map<Id,IPM_Milestone__c>  standardMileStoneMap = new Map<Id,IPM_Milestone__c>([Select Id,Name,IPM_Type_of_Milestone__c from IPM_Milestone__c where IPM_Type_of_Milestone__c ='Standard' AND recordTypeId =:mileMasterRecordType AND IPM_Project_Type__c='Original' ] );
            
            // Get Standard Milestones from database  
           
            System.assert(standardMileStoneMap.values().size() > 0,' No Milestones is created');
            
            /********************************Global Project Leaders Project View and Data Access****************************************/
            for(IPM_Project__c project : projectList)
            {
                // Once project is created Charter document would be available.
                System.assertEquals(project.Project_Documents__r.size(),1,'No  document created for the project');
                
                // Once project is created, Project associated tasks would be based on Selected Complexity.
                for(IPM_Task__c task : project.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,project.IPM_Complexity__c,'Task Complexity is different to project complexity');   
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assertEquals(project.IPM_Milestones__r.size(),standardMileStoneMap.size(),PROJECT_MILESTONE_NOT_EQUIVALENT_STANDARD_MILESTONE);
                
                // Once project is created , Consolidated financials are getting generated.
                // One for Global consolidated Financials
                 System.assertEquals(project.IPM_Financials_Consolidated__r.size(),1,'No consolidated financial created for the  project');
                // Project default phase would always be set as IDEAS.
                // Phase would be always ideas for Global Project.
                System.assertEquals(project.IPM_Phase__c,IDEAS,'Global Project phase is not idea');
            }
            
            /******************************** Create Regional Rollouts for Created Global project ****************************************/
            set<ID> regionalRolloutId = new set<Id>();
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{regionalProjectLeader,regionalProjectLeader,regionalProjectLeader});
            for(IPM_Project_Rollout__c regionalRollout : regionalRolloutList )
            {
                regionalRollout.IPM_RolloutJobType__c= IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
                regionalRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                regionalRollout.Finance_Member__c = financeLeader.id;
                regionalRollout.Target_Launch_Date__c = Date.today();
                regionalRolloutId.add(regionalRollout.Id);
            }
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
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = WITH_MCO,isActive__c = true);    
                
                countryList.add(tempCountry);
            }
            
            insert countryList;
            
            // update Regional Rollout 
            
            list<IPM_Project_Rollout__c> regionalOldRollout =  [Select id,Name, IPM_Rollout_Project__c ,RecordTypeId,Market_cluster__c,Target_Launch_Date__c,IPM_Rollout_Span__c,
            Market_Cluster_Name__c,IPM_Regional_PL_Text__c,IPM_Regional_PL__c,IPM_Project__c  FROM IPM_Project_Rollout__c where id in :regionalRolloutId];
            
            for(IPM_Project_Rollout__c updateRollout : regionalOldRollout)
            {
                updateRollout.IPM_RolloutJobType__c= IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
                updateRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                updateRollout.Finance_Member__c = financeLeaderSecond.id;
                updateRollout.Target_Launch_Date__c = Date.today().addDays(10);
            }
            update regionalOldRollout;
            Test.stopTest();
        }
        
    }
    
    /**************************************************************
    * @description: Used for testing flow for updating Local Rollout TLD
    * NPATHComplexity: This function is used for checking the flow for Regional Rollout data update including multiple Rollouts. This method also checks for
    * data validation for IPM Project Milestones, IPM Tasks, IPM Country etc. 
    */
    public static testmethod void updateLocalRolloutTLD()
    {
        
        // Get the newly created Projects from Database. 
        
      
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        
        
        Test.startTest();
        // Get the list of user's for project leaders.
        List<User> userList = [Select Id,Name,lastName from User where LastName in:USER_LIST];
        
        // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(userList); 
        
        for(User lUser  :userList)
        {
            if(lUser.lastName == GLOBAL_LASTNAME)
            {
                globalProjectLeader = lUser;
            }
            if(lUser.lastName == REGIONAL_LASTNAME)
            {
                regionalProjectLeader = lUser;
            }
            if(lUser.lastName == FINANCE1_LASTNAME)
            {
                financeLeader = lUser;
            }
            if(lUser.lastName == FINANCE2_LASTNAME)
            {
                financeLeaderSecond = lUser;
            }
        }
        
        System.RunAs(globalProjectLeader)
        {
            List<IPM_Project__c> projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r),
            (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
            (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
            for(IPM_Project__c project : projectList)
            {
                projectMap.put(project.Id,project);
            }
            
            Id  mileMasterRecordType = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.mileMRecordType).getRecordTypeId();
            Map<Id,IPM_Milestone__c>  standardMileStoneMap = new Map<Id,IPM_Milestone__c>([Select Id,Name,IPM_Type_of_Milestone__c from IPM_Milestone__c where IPM_Type_of_Milestone__c ='Standard' AND recordTypeId =:mileMasterRecordType AND IPM_Project_Type__c='Original' ] );
            
            // Get Standard Milestones from database  
            
            System.assert(standardMileStoneMap.values().size() > 0,'No standard Milestones created');
            
            /********************************Global Project Leaders Project View and Data Access****************************************/
            for(IPM_Project__c project : projectList)
            {
                // Once project is created Charter document would be available.
                System.assertEquals(project.Project_Documents__r.size(),1,'No document created for the project');
                
                // Once project is created, Project associated tasks would be based on Selected Complexity.
                for(IPM_Task__c task : project.Tasks__r)
                {
                   System.assertEquals(task.IPM_Task_Complexity__c,project.IPM_Complexity__c,TASK_COMPLEXITY_NOT_EQUIVALENT_PROJECT_COMPLEXITY);  
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assertEquals(project.IPM_Milestones__r.size(),standardMileStoneMap.size(),PROJECT_MILESTONE_NOT_EQUIVALENT_STANDARD_MILESTONE);     
                // Once project is created , Consolidated financials are getting generated.
                // One for Global consolidated Financials
                System.assertEquals(project.IPM_Financials_Consolidated__r.size(),1,NO_CONSOLIDATED_FINANCIAL_CREATED);
                // Project default phase would always be set as IDEAS.
               // Phase would be always ideas for Global Project.
                System.assertEquals(project.IPM_Phase__c,IDEAS,'Global Project phase is not Idea');
            }
            
            /******************************** Create Regional Rollouts for Created Global project ****************************************/
            
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{regionalProjectLeader,regionalProjectLeader,regionalProjectLeader});
            for(IPM_Project_Rollout__c regionalRollout : regionalRolloutList )
            {
                regionalRollout.Finance_Member__c = financeLeader.id;
                regionalRollout.Target_Launch_Date__c = Date.today();
                regionalRollout.IPM_RolloutJobType__c= IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
                regionalRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
            }
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
            
            set<ID> localRolloutId = new set<Id>();
            for(IPM_Project_Rollout__c localRollout : localRolloutList )
            {
                localRollout.IPM_RolloutJobType__c= IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
                localRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                localRollout.Finance_Member__c = financeLeader.id;
                localRollout.Target_Launch_Date__c = Date.today();
                localRolloutId.add(localRollout.Id);
            }
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
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = WITH_MCO,isActive__c = true);    
                
                countryList.add(tempCountry);
                
            }
            
            insert countryList;
            
            
            // update Regional Rollout 
            
            list<IPM_Project_Rollout__c> localOldRollout =  [Select id,Name, IPM_Rollout_Project__c ,RecordTypeId,Market_cluster__c,Target_Launch_Date__c,IPM_Rollout_Span__c,
            Market_Cluster_Name__c,IPM_Regional_PL_Text__c,IPM_Regional_PL__c,IPM_Project__c  FROM IPM_Project_Rollout__c where id in :localRolloutId];
            
            for(IPM_Project_Rollout__c updateRollout : localOldRollout)
            {
                updateRollout.Target_Launch_Date__c = Date.today().addDays(11);
                updateRollout.Finance_Member__c = financeLeaderSecond.id;
                updateRollout.IPM_RolloutJobType__c= IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
                updateRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
            }
            
            update localOldRollout;
            Test.stopTest();
        }
        
    }
    /**************************************************************
    * @description: Used for testing flow for deleting Rollouts
    * NPATHComplexity: This function is used for checking the flow for deleting Rollouts data for Regional as well as Local levels. This includes validating flows for deleting tasks, Milestones as well. 
    * This method creates data for Regional/Local Rollouts, IPM Country for the Rollouts.
    */ 
    public static testmethod void deleteRollout()
    {
        
        // Get the newly created Projects from Database. 

      
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        
       
        Test.startTest();
        // Get the list of user's for project leaders.
        List<User> userList = [Select Id,Name,lastName from User where LastName in:USER_LIST];
        
        // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(userList); 
        
        for(User lUser  :userList)
        {
            if(lUser.lastName == GLOBAL_LASTNAME)
            {
                globalProjectLeader = lUser;
            }
            if(lUser.lastName == REGIONAL_LASTNAME)
            {
                regionalProjectLeader = lUser;
            }
            if(lUser.lastName == FINANCE1_LASTNAME)
            {
                financeLeader = lUser;
            }
        }
        
        System.RunAs(globalProjectLeader)
        {
            List<IPM_Project__c> projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r),
            (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
            (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
            for(IPM_Project__c project : projectList)
            {
                projectMap.put(project.Id,project);
            }
            
            Id  mileMasterRecordType = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.mileMRecordType).getRecordTypeId();
            Map<Id,IPM_Milestone__c>  standardMileStoneMap = new Map<Id,IPM_Milestone__c>([Select Id,Name,IPM_Type_of_Milestone__c from IPM_Milestone__c where IPM_Type_of_Milestone__c ='Standard' AND recordTypeId =:mileMasterRecordType AND IPM_Project_Type__c='Original' ] );
            
            // Get Standard Milestones from database  
           
            System.assert(standardMileStoneMap.values().size() > 0,'No Standard Milestones created');
            
            /********************************Global Project Leaders Project View and Data Access****************************************/
            for(IPM_Project__c project : projectList)
            {
                // Once project is created Charter document would be available.
                System.assertEquals(project.Project_Documents__r.size(),1,'No Project Document generated');
                
                // Once project is created, Project associated tasks would be based on Selected Complexity.
                for(IPM_Task__c task : project.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,project.IPM_Complexity__c,TASK_COMPLEXITY_NOT_EQUIVALENT_PROJECT_COMPLEXITY);  
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                 System.assertEquals(project.IPM_Milestones__r.size(),standardMileStoneMap.size(),PROJECT_MILESTONE_NOT_EQUIVALENT_STANDARD_MILESTONE);  
                // Once project is created , Consolidated financials are getting generated.
                // One for Global consolidated Financials
                System.assertEquals(project.IPM_Financials_Consolidated__r.size(),1,NO_CONSOLIDATED_FINANCIAL_CREATED);
                // Project default phase would always be set as IDEAS.
               // Phase would be always ideas for Global Project.
                System.assertEquals(project.IPM_Phase__c,IDEAS,'Global Project phase is not Ideas');
            }
            
            /******************************** Create Regional Rollouts for Created Global project ****************************************/
            
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{regionalProjectLeader,regionalProjectLeader,regionalProjectLeader});
            for(IPM_Project_Rollout__c regionalRollout : regionalRolloutList )
            {
                regionalRollout.Finance_Member__c = financeLeader.id;
                regionalRollout.Target_Launch_Date__c = Date.today();
                regionalRollout.IPM_RolloutJobType__c= IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
                regionalRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                
            }
            insert regionalRolloutList;
            
            set<id> regionalRolloutId  = new set<id>();            
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
                regionalRolloutId.add(projectRollout.id);
            }
            
            // Create local Rollouts for Created regional Rollouts.
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>());  
            
            set<ID> localRolloutId = new set<Id>();
            for(IPM_Project_Rollout__c localRollout : localRolloutList )
            {
                localRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                localRollout.IPM_RolloutJobType__c= IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
                localRollout.Target_Launch_Date__c = Date.today();
                localRollout.Finance_Member__c = financeLeader.id;
                localRolloutId.add(localRollout.Id);
            }
            insert localRolloutList;
            
            
            // Create Country specific information.
            List<IPM_Country__c> countryList= new List<IPM_Country__c>();
            set<id> countryId = new set<Id>(); 
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
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = WITH_MCO,isActive__c = true);    
                
                countryList.add(tempCountry);
                
            }
            
            insert countryList;
            // deleting country
            for(IPM_Country__c country : countryList)
            {
                countryId.add(country.id);
            }
            integer size=0;
            // delete local rollout      
            try {  
                
                list<IPM_Project_Rollout__c> deleteLocalRolloutList =  [Select id,Name, IPM_Rollout_Project__c ,RecordTypeId,Market_cluster__c,Target_Launch_Date__c,IPM_Rollout_Span__c,
                Market_Cluster_Name__c,IPM_Regional_PL_Text__c,IPM_Regional_PL__c,IPM_Project__c  FROM IPM_Project_Rollout__c where id in :localRolloutId];
                delete deleteLocalRolloutList;
                
                size = deleteLocalRolloutList.size();
                list<IPM_Project_Rollout__c> deleteRegionalRolloutList =  [Select id,Name, IPM_Rollout_Project__c ,RecordTypeId,Market_cluster__c,Target_Launch_Date__c,IPM_Rollout_Span__c,
                Market_Cluster_Name__c,IPM_Regional_PL_Text__c,IPM_Regional_PL__c,IPM_Project__c  FROM IPM_Project_Rollout__c where id in :regionalRolloutId];
                delete deleteRegionalRolloutList;
            }
            catch(DMLException e)
            {  
                System.assertEquals(0,size,'DML is not excuted successfully');
            }
            Test.stopTest();
            
            
        }
    }
    
    /**************************************************************
    * @description: Used for testing flow for deleting Rollouts
    * NPATHComplexity: This function is used for checking the flow for deleting Rollouts data for Regional as well as Local levels for Key Rollouts. This includes validating flows for deleting tasks, Milestones as well. 
    * This method creates data for Regional/Local Rollouts, IPM Country for the Rollouts.
    */ 
    public static testmethod void deleteRollout_KeyRollout()
    {
        
        // Get the newly created Projects from Database. 

        
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        
       
        Test.startTest();
        // Get the list of user's for project leaders.
        List<User> userList = [Select Id,Name,lastName from User where LastName in:USER_LIST];
        
        // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(userList); 
        
        for(User lUser  :userList)
        {
            if(lUser.lastName == GLOBAL_LASTNAME)
            {
                globalProjectLeader = lUser;
            }
            if(lUser.lastName == REGIONAL_LASTNAME)
            {
                regionalProjectLeader = lUser;
            }
            if(lUser.lastName == FINANCE1_LASTNAME)
            {
                financeLeader = lUser;
            }
        }
        
        System.RunAs(globalProjectLeader)
        {
            List<IPM_Project__c> projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r),
            (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
            (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
            for(IPM_Project__c project : projectList)
            {
                projectMap.put(project.Id,project);
            }
            
            Id  mileMasterRecordType = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.mileMRecordType).getRecordTypeId();
            Map<Id,IPM_Milestone__c>  standardMileStoneMap = new Map<Id,IPM_Milestone__c>([Select Id,Name,IPM_Type_of_Milestone__c from IPM_Milestone__c where IPM_Type_of_Milestone__c ='Standard' AND recordTypeId =:mileMasterRecordType AND IPM_Project_Type__c='Original' ] );
            
            // Get Standard Milestones from database  
           
            System.assert(standardMileStoneMap.values().size() > 0,' No Milestones created');
            
            /********************************Global Project Leaders Project View and Data Access****************************************/
            for(IPM_Project__c project : projectList)
            {
                // Once project is created Charter document would be available.
              
                System.assertEquals(project.Project_Documents__r.size(),1,'No  document created for the project ');
                
                // Once project is created, Project associated tasks would be based on Selected Complexity.
                for(IPM_Task__c task : project.Tasks__r)
                {
                   System.assertEquals(task.IPM_Task_Complexity__c,project.IPM_Complexity__c,TASK_COMPLEXITY_NOT_EQUIVALENT_PROJECT_COMPLEXITY);  
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                 System.assertEquals(project.IPM_Milestones__r.size(),standardMileStoneMap.size(),PROJECT_MILESTONE_NOT_EQUIVALENT_STANDARD_MILESTONE);  
                // Once project is created , Consolidated financials are getting generated.
                // One for Global consolidated Financials
                 System.assertEquals(project.IPM_Financials_Consolidated__r.size(),1,NO_CONSOLIDATED_FINANCIAL_CREATED);
                // Project default phase would always be set as IDEAS.
               // Phase would be always ideas for Global Project.
                System.assertEquals(project.IPM_Phase__c,IDEAS,'Global Project phase is not idea');
            }
            
            /******************************** Create Regional Rollouts for Created Global project ****************************************/
            
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{regionalProjectLeader,regionalProjectLeader,regionalProjectLeader});
            for(IPM_Project_Rollout__c regionalRollout : regionalRolloutList )
            {
                regionalRollout.Finance_Member__c = financeLeader.id;
                regionalRollout.Target_Launch_Date__c = Date.today();
                regionalRollout.IPM_RolloutJobType__c= IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
                regionalRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                
            }
            insert regionalRolloutList;
            
            set<id> regionalRolloutId  = new set<id>();            
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
                regionalRolloutId.add(projectRollout.id);
            }
            
            // Create local Rollouts for Created regional Rollouts.
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>());  
            
            set<ID> localRolloutId = new set<Id>();
            for(IPM_Project_Rollout__c localRollout : localRolloutList )
            {
                localRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                localRollout.IPM_RolloutJobType__c= IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
                localRollout.Target_Launch_Date__c = Date.today();
                localRollout.Finance_Member__c = financeLeader.id;
                localRollout.KeyMCO__c = true;
                localRollout.isActive__c = true;
                localRollout.IPM_Project__c = projectList[0].id;
                localRollout.Regional_Project__c = projectList[0].id;
                localRolloutId.add(localRollout.Id);
            }
            insert localRolloutList;
            
            
            // Create Country specific information.
            List<IPM_Country__c> countryList= new List<IPM_Country__c>();
            set<id> countryId = new set<Id>(); 
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
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = WITH_MCO,isActive__c = true);    
                
                countryList.add(tempCountry);
                
            }
            
            insert countryList;
            // deleting country
            for(IPM_Country__c country : countryList)
            {
                countryId.add(country.id);
            }
            integer size=0;
            List<IPM_Project_Rollout__c> localRolloutUpList = new List<IPM_Project_Rollout__c>();
            List<IPM_Project__c> regProj = [Select id From IPM_Project__c Where IPMProject_Span__c = 'Global'];
            System.assert(regProj.size() > 0,'No Regional project created for global Span');
            // delete local rollout      
            try {  
                
                list<IPM_Project_Rollout__c> deleteLocalRolloutList =  [Select id,Name, IPM_Rollout_Project__c ,RecordTypeId,Market_cluster__c,Target_Launch_Date__c,IPM_Rollout_Span__c,
                Market_Cluster_Name__c,IPM_Regional_PL_Text__c,IPM_Regional_PL__c,IPM_Project__c  FROM IPM_Project_Rollout__c where id in :localRolloutId];
                
                for(IPM_Project_Rollout__c locRollout : deleteLocalRolloutList){
                    locRollout.KeyMCO__c = false;
                    locRollout.Target_Launch_Date__c = Date.today().addMonths(6);
                    ////locRollout.Regional_Project__c = projectList[0].id;
                    locRollout.isActive__c = false;
                    localRolloutUpList.add(locRollout);  
                }
                update localRolloutUpList;
                
                delete deleteLocalRolloutList;
                
                size = deleteLocalRolloutList.size();
                list<IPM_Project_Rollout__c> deleteRegionalRolloutList =  [Select id,Name, IPM_Rollout_Project__c ,RecordTypeId,Market_cluster__c,Target_Launch_Date__c,IPM_Rollout_Span__c,
                Market_Cluster_Name__c,IPM_Regional_PL_Text__c,IPM_Regional_PL__c,IPM_Project__c  FROM IPM_Project_Rollout__c where id in :regionalRolloutId];
                delete deleteRegionalRolloutList;
            }
            catch(DMLException e)
            {  
                 System.assertEquals(0,size,'DML not excuted successfully');
            }
            Test.stopTest();
        }
    }
    /**************************************************************
    * @description: Used for testing flow for deleting Key Rollouts
    * NPATHComplexity: This function is used for checking the flow for deleting Key (individual) Rollouts. 
    * This methods creates data for Local/Regional Rollouts along with IPM Country data.
    */
    public static testmethod void deleteRollout_KeyRolloutWithParentProj()
    {
        
        // Get the newly created Projects from Database. 
        
       
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        
       
        Test.startTest();
        // Get the list of user's for project leaders.
        List<User> userList = [Select Id,Name,lastName from User where LastName in:USER_LIST];
        
        // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(userList); 
        
        for(User lUser  :userList)
        {
            if(lUser.lastName == GLOBAL_LASTNAME)
            {
                globalProjectLeader = lUser;
            }
            if(lUser.lastName == REGIONAL_LASTNAME)
            {
                regionalProjectLeader = lUser;
            }
            if(lUser.lastName == FINANCE1_LASTNAME)
            {
                financeLeader = lUser;
            }
        }
        
        System.RunAs(globalProjectLeader)
        {
            List<IPM_Project__c> projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r),
            (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
            (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
            for(IPM_Project__c project : projectList)
            {
                projectMap.put(project.Id,project);
            }
            
            Id  mileMasterRecordType = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.mileMRecordType).getRecordTypeId();
            Map<Id,IPM_Milestone__c>  standardMileStoneMap = new Map<Id,IPM_Milestone__c>([Select Id,Name,IPM_Type_of_Milestone__c from IPM_Milestone__c where IPM_Type_of_Milestone__c ='Standard' AND recordTypeId =:mileMasterRecordType AND IPM_Project_Type__c='Original' ] );
            
            // Get Standard Milestones from database  
            
            System.assert(standardMileStoneMap.values().size() > 0,'No Milestones created for the project');
            
            /********************************Global Project Leaders Project View and Data Access****************************************/
            for(IPM_Project__c project : projectList)
            {
                // Once project is created Charter document would be available.
                System.assertEquals(project.Project_Documents__r.size(),1,'No  document generated for the project ');
                
                // Once project is created, Project associated tasks would be based on Selected Complexity.
                for(IPM_Task__c task : project.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,project.IPM_Complexity__c,TASK_COMPLEXITY_NOT_EQUIVALENT_PROJECT_COMPLEXITY);  
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assertEquals(project.IPM_Milestones__r.size(),standardMileStoneMap.size(),PROJECT_MILESTONE_NOT_EQUIVALENT_STANDARD_MILESTONE);  
                // Once project is created , Consolidated financials are getting generated.
                // One for Global consolidated Financials
                System.assertEquals(project.IPM_Financials_Consolidated__r.size(),1,NO_CONSOLIDATED_FINANCIAL_CREATED);
                // Project default phase would always be set as IDEAS.
                // Phase would be always ideas for Global Project.
                System.assertEquals(project.IPM_Phase__c,IDEAS,'Global Project phase is not ideas');
            }
            
            /******************************** Create Regional Rollouts for Created Global project ****************************************/
            
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{regionalProjectLeader,regionalProjectLeader,regionalProjectLeader});
            for(IPM_Project_Rollout__c regionalRollout : regionalRolloutList )
            {
                regionalRollout.Finance_Member__c = financeLeader.id;
                regionalRollout.Target_Launch_Date__c = Date.today();
                regionalRollout.IPM_RolloutJobType__c= IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
                regionalRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                regionalRollout.IPM_Project__c = projectList[0].id;
                regionalRollout.KeyMCO__c = false;
                regionalRollout.isActive__c = false;
                
            }
            insert regionalRolloutList;
            
            for(IPM_Project_Rollout__c regRollout : regionalRolloutList){
                regRollout.Target_Launch_Date__c = Date.today().addMonths(9);
                regRollout.KeyMCO__c = true;
                regRollout.isActive__c = true;
            }
            update regionalRolloutList;
            
            set<id> regionalRolloutId  = new set<id>();            
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
                regionalRolloutId.add(projectRollout.id);
            }
            
            // Create local Rollouts for Created regional Rollouts.
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>());  
            
            set<ID> localRolloutId = new set<Id>();
            for(IPM_Project_Rollout__c localRollout : localRolloutList )
            {
                localRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                localRollout.IPM_RolloutJobType__c= IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
                localRollout.Target_Launch_Date__c = Date.today();
                localRollout.Finance_Member__c = financeLeader.id;
                localRollout.KeyMCO__c = false;
                localRollout.isActive__c = false;
                localRollout.IPM_Project__c = null;
                localRollout.Regional_Project__c = projectList[0].id;
                localRolloutId.add(localRollout.Id);
            }
            insert localRolloutList;
            
            
            // Create Country specific information.
            List<IPM_Country__c> countryList= new List<IPM_Country__c>();
            set<id> countryId = new set<Id>(); 
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
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = WITH_MCO,isActive__c = true);    
                
                countryList.add(tempCountry);
                
            }
            
            insert countryList;
            // deleting country
            for(IPM_Country__c country : countryList)
            {
                countryId.add(country.id);
            }
            integer size=0;
            List<IPM_Project_Rollout__c> localRolloutUpList = new List<IPM_Project_Rollout__c>();
            List<IPM_Project__c> regProj = [Select id From IPM_Project__c Where IPMProject_Span__c = 'Global'];
            System.assert(regProj.size() > 0,'No Regional project created for global Span');
            // delete local rollout      
            try {  
                
                list<IPM_Project_Rollout__c> deleteLocalRolloutList =  [Select id,Name, IPM_Rollout_Project__c ,RecordTypeId,Market_cluster__c,Target_Launch_Date__c,IPM_Rollout_Span__c,
                Market_Cluster_Name__c,IPM_Regional_PL_Text__c,IPM_Regional_PL__c,IPM_Project__c  FROM IPM_Project_Rollout__c where id in :localRolloutId];
                
                for(IPM_Project_Rollout__c locRollout : deleteLocalRolloutList){
                    locRollout.KeyMCO__c = true;
                    locRollout.Target_Launch_Date__c = Date.today().addMonths(6);
                    ////locRollout.Regional_Project__c = projectList[0].id;
                    locRollout.isActive__c = true;
                    localRolloutUpList.add(locRollout);  
                }
                update localRolloutUpList;
                
                delete deleteLocalRolloutList;
                
                size = deleteLocalRolloutList.size();
                list<IPM_Project_Rollout__c> deleteRegionalRolloutList =  [Select id,Name, IPM_Rollout_Project__c ,RecordTypeId,Market_cluster__c,Target_Launch_Date__c,IPM_Rollout_Span__c,
                Market_Cluster_Name__c,IPM_Regional_PL_Text__c,IPM_Regional_PL__c,IPM_Project__c  FROM IPM_Project_Rollout__c where id in :regionalRolloutId];
                delete deleteRegionalRolloutList;
            }
            catch(DMLException e)
            {  
               System.assertEquals(0,size,'DML not executed successfully');
            }
            Test.stopTest();
        }
    }
    
    /**************************************************************
    * @description: Used for testing flow for deleting Non-key Rollouts
    * NPATHComplexity: This function is used for checking the flow for deleting Non-Key (grouped) Rollouts. 
    * This methods creates data for Local/Regional Rollouts along with IPM Country data.
    */
    public static testmethod void deleteRollout_NonKeyRollout()
    {
        
        // Get the newly created Projects from Database. 
        
       
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        
        
        Test.startTest();
        // Get the list of user's for project leaders.
        List<User> userList = [Select Id,Name,lastName from User where LastName in:USER_LIST];
        
        // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(userList); 
        
        for(User lUser  :userList)
        {
            if(lUser.lastName == GLOBAL_LASTNAME)
            {
                globalProjectLeader = lUser;
            }
            if(lUser.lastName == REGIONAL_LASTNAME)
            {
                regionalProjectLeader = lUser;
            }
            if(lUser.lastName == FINANCE1_LASTNAME)
            {
                financeLeader = lUser;
            }
        }
        
        System.RunAs(globalProjectLeader)
        {
            List<IPM_Project__c> projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r),
            (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
            (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
            for(IPM_Project__c project : projectList)
            {
                projectMap.put(project.Id,project);
            }
            
            Id  mileMasterRecordType = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.mileMRecordType).getRecordTypeId();
            Map<Id,IPM_Milestone__c>  standardMileStoneMap = new Map<Id,IPM_Milestone__c>([Select Id,Name,IPM_Type_of_Milestone__c from IPM_Milestone__c where IPM_Type_of_Milestone__c ='Standard' AND recordTypeId =:mileMasterRecordType AND IPM_Project_Type__c='Original' ] );
            
            // Get Standard Milestones from database  
           
            System.assert(standardMileStoneMap.values().size() > 0,'No Milestones created');
            
            /********************************Global Project Leaders Project View and Data Access****************************************/
            for(IPM_Project__c project : projectList)
            {
                // Once project is created Charter document would be available.
                System.assertEquals(project.Project_Documents__r.size(),1,'No document generated for the  project ');
                
                // Once project is created, Project associated tasks would be based on Selected Complexity.
                for(IPM_Task__c task : project.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,project.IPM_Complexity__c,TASK_COMPLEXITY_NOT_EQUIVALENT_PROJECT_COMPLEXITY);  
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                 System.assertEquals(project.IPM_Milestones__r.size(),standardMileStoneMap.size(),PROJECT_MILESTONE_NOT_EQUIVALENT_STANDARD_MILESTONE);
                
                // Once project is created , Consolidated financials are getting generated.
                // One for Global consolidated Financials
                System.assertEquals(project.IPM_Financials_Consolidated__r.size(),1,NO_CONSOLIDATED_FINANCIAL_CREATED);
                // Project default phase would always be set as IDEAS.
                // Phase would be always ideas for Global Project.
                System.assertEquals(project.IPM_Phase__c,IDEAS,'Global Project phase is not Ideas');
                
            }
            
            /******************************** Create Regional Rollouts for Created Global project ****************************************/
            
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{regionalProjectLeader,regionalProjectLeader,regionalProjectLeader});
            for(IPM_Project_Rollout__c regionalRollout : regionalRolloutList )
            {
                regionalRollout.Finance_Member__c = financeLeader.id;
                regionalRollout.Target_Launch_Date__c = Date.today();
                regionalRollout.IPM_RolloutJobType__c= IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
                regionalRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                regionalRollout.IPM_Project__c = projectList[0].id;
                //regionalRollout.KeyMCO__c = false;
                //regionalRollout.isActive__c = false;
                
            }
            insert regionalRolloutList;
            
            for(IPM_Project_Rollout__c regRollout : regionalRolloutList){
                regRollout.Target_Launch_Date__c = Date.today().addMonths(9);
                //regRollout.KeyMCO__c = true;
                //regRollout.isActive__c = true;
            }
            update regionalRolloutList;
            
            set<id> regionalRolloutId  = new set<id>();            
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
                regionalRolloutId.add(projectRollout.id);
            }
            
            // Create local Rollouts for Created regional Rollouts.
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>());  
            
            set<ID> localRolloutId = new set<Id>();
            for(IPM_Project_Rollout__c localRollout : localRolloutList )
            {
                localRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                localRollout.IPM_RolloutJobType__c= IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
                localRollout.Target_Launch_Date__c = Date.today();
                localRollout.Finance_Member__c = financeLeader.id;
                localRollout.KeyMCO__c = true;
                localRollout.isActive__c = true;
                localRollout.IPM_Project__c = null;
                localRollout.Regional_Project__c = projectList[0].id;
                localRolloutId.add(localRollout.Id);
            }
            insert localRolloutList;
            
            
            // Create Country specific information.
            List<IPM_Country__c> countryList= new List<IPM_Country__c>();
            set<id> countryId = new set<Id>(); 
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
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = WITH_MCO,isActive__c = true);    
                
                countryList.add(tempCountry);
                
            }
            
            insert countryList;
            // deleting country
            for(IPM_Country__c country : countryList)
            {
                countryId.add(country.id);
            }
            integer size=0;
            List<IPM_Project_Rollout__c> localRolloutUpList = new List<IPM_Project_Rollout__c>();
            List<IPM_Project__c> regProj = [Select id From IPM_Project__c Where IPMProject_Span__c = 'Global'];
            System.assert(regProj.size() > 0,'No Regional project created for global Span');
            // delete local rollout      
            try {  
                
                list<IPM_Project_Rollout__c> deleteLocalRolloutList =  [Select id,Name, IPM_Rollout_Project__c ,RecordTypeId,Market_cluster__c,Target_Launch_Date__c,IPM_Rollout_Span__c,
                Market_Cluster_Name__c,IPM_Regional_PL_Text__c,IPM_Regional_PL__c,IPM_Project__c  FROM IPM_Project_Rollout__c where id in :localRolloutId];
                
                for(IPM_Project_Rollout__c locRollout : deleteLocalRolloutList){
                    locRollout.Target_Launch_Date__c = Date.today().addMonths(6);
                    locRollout.Regional_Project__c = projectList[0].id;
                    locRollout.isActive__c = false;
                    localRolloutUpList.add(locRollout);  
                }
                update localRolloutUpList;
                
                for(IPM_Project_Rollout__c locRollout : deleteLocalRolloutList){
                    locRollout.KeyMCO__c = false;
                    locRollout.Target_Launch_Date__c = Date.today().addMonths(6);
                    locRollout.Regional_Project__c = projectList[0].id;
                    locRollout.isActive__c = true;
                    localRolloutUpList.add(locRollout);  
                }
                update localRolloutUpList;
                
                
                delete deleteLocalRolloutList;
                
                size = deleteLocalRolloutList.size();
                list<IPM_Project_Rollout__c> deleteRegionalRolloutList =  [Select id,Name, IPM_Rollout_Project__c ,RecordTypeId,Market_cluster__c,Target_Launch_Date__c,IPM_Rollout_Span__c,
                Market_Cluster_Name__c,IPM_Regional_PL_Text__c,IPM_Regional_PL__c,IPM_Project__c  FROM IPM_Project_Rollout__c where id in :regionalRolloutId];
                delete deleteRegionalRolloutList;
            }
            catch(DMLException e)
            {  
               System.assertEquals(0,size,'DML not executed successfully');
            }
            Test.stopTest();
        }
    }  
}
