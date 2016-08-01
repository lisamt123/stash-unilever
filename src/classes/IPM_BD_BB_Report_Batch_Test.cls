/**
  @author : Cognizant
  @name : IPM_BD_BB_Report_Batch_Test
  @CreateDate : 25/07/2016
  @description : This test class will cover the functionality which have been covered in IPM_BD_BB_Report_Batch 
  @Version : 1.0
  @reference : IPM_BD_BB_Report_Batch
*/

@isTest
private class IPM_BD_BB_Report_Batch_Test {
	 
	 public static final String ASSERT_ERROR_STR = 'Projects not Created Properly.Actual size should be '; 
	 public static final String BD_BB_REPORT = 'BD BB Report';
	 
	 
	 @testSetup static void projectDataSetUp(){
	 	
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
            System.assertEquals(dbProjectList.size(),projectList.size(),ASSERT_ERROR_STR+projectList.size());
        }
        
      }   
      
      public static testMethod void createProject(){
      	
      	// prepare custom setting data
	 	Decimal startYear = System.today().year();
        //Insert data for Custom setting
        List<IPM_Reporting__c> reportCSList = new List<IPM_Reporting__c>();
        
        IPM_Reporting__c reportParameter = IPM_TestFactory_Helper.createIPMReportingCustomSetting(BD_BB_REPORT, false);
        reportParameter.IPM_Start_Year__c = startYear;
        insert reportParameter;
        
        String strCSName = '';
        
        for(Integer i = 1; i < 4; i++){
        	for(String strPhase : IPM_ConstantUtils.DEFAULT_PHASE_SEQ){
        		strCSName = 'GKM' + String.valueOf(i) + IPM_ConstantUtils.HYPHEN_DELIMITER + strPhase;
        		IPM_Reporting__c reportCS  = IPM_TestFactory_Helper.createIPMReportingCustomSetting(strCSName, false);
        		reportCS.IPM_Start_Year__c = startYear;
        		reportCSList.add(reportCS);
        	}	
        }
        insert reportCSList;
      	
      	
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
        
        System.RunAs(globalProjectLeader)
        {
            createProjectGlobal(projectNameSet, globalProjectIdList, projectMap,globalProjectLeader,regionalProjectLeader); 
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
     	
     	     	 
		System.RunAs(globalProjectLeader){
			string  query = 'SELECT Id,IPM_Global_ProjectId__c, IPM_Project_Name__c, IPM_Parent_Project__r.IPM_project_name__c, IPM_Platform_Formula__c, BET__r.Name, BET__r.Owner.Name, BETCurrentStatus__c, Project_External_ID__c,Name,IPM_Parent_Project__r.Name,IPM_Parent_Project__r.Id,IPM_Project_Leader__r.Name,Deputy_Project_Leader__r.Name,IPM_Technical_Project_Leader__r.Name,IPM_Finance_Lead__r.Name,IPM_Rollout_Status__c,IPM_Category_Group__c,IPM_Category_Text__c,IPM_Phase__c,IPM_Brand_Positioning__c,IPMProject_Span__c, IPMProject_Type__c,Project_Countries__c,IPM_No_of_Country_Rollouts__c,IPM_Threshold_Value__c,IPM_Company_Card__r.Name,IPM_Project_Rollout__r.name,IPM_Project_Rollout__r.Id,IPM_Cluster__c,Market_Cluster__c,Market_Cluster_Name__c,IPM_Clustering__c,IPM_Clusters__c,IPM_Answer_of_Q1__c, IPM_Answer_of_Q2__c, Exempt_from_Threshold__c, IPM_Answer_of_Q3__c,IPM_Strategic_Intent__c,IPM_Target_Launch_Year__c,IPM_Target_Launch_Month__c,IPM_Actual_Launch_Date__c, IPM_Actual_Launch_Month__c,IPM_Actual_Launch_Year__c,IPMPlatform__c,IPM_Project_Type__c,IPM_Project_Description__c,IPM_Target_Launch_Dates__c,IPM_Project_Rollout__c,IPM_Misalligned__c,CreatedDate,IPM_Project_Start_Date__c,IPM_Parent_Project__r.IPM_Project_Rollout__r.Target_Launch_Date__c,IPM_CPP__c,IPM_Fast_Track_Project__c,IPM_White_Space_Project__c,Is_Archieved__c,IPM_ProjectGKM__c,IPM_Complexity__c,IPM_Market__c,IPM_Sub_sector__c,IPM_Global_OR_Regional__c,IPM_Project_Rollout__r.Target_Launch_Date__c, IPM_Project_Rollout__r.KeyMCO__c FROM IPM_Project__c WHERE IPM_Project_Name__c != null' ;
			IPM_BD_BB_Report_Batch  batchs = new IPM_BD_BB_Report_Batch(query); 
			database.executebatch(batchs,100);
			
		}
     	
      }
 	
 	public static void createProjectGlobal(set<String> projectNameSet, List<Id> globalProjectIdList, Map<Id,IPM_Project__c> projectMap,User globalProjectLeader,User regionalProjectLeader){
         
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
     }
 	     
}