/**
   @Author Cognizant Techinology Solutions
   @name IPM_ProjectHelper_Test
   @CreateDate 8/20/2015
   @Description Test Class for testing project specific helpers.
   @Version 1.0
   @reference Project Creation and Phase Change
  */
  
@isTest
public class IPM_ProjectHelper_Test 
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
	        
	        // Inserting Master Data whose OWD are set to readOnly    
            IPM_TestFactory_Helper.getProjectMasterData();
        }   
        
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
	   
	    Test.startTest();
    	 
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
        
        User globalUser = [Select Id from User where LastName ='GLOBAL_PL' limit 1];
        
        Id  mileMasterRecordType = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.mileMRecordType).getRecordTypeId();
        Map<Id,IPM_Milestone__c>  standardMileStoneMap = new Map<Id,IPM_Milestone__c>([Select Id,Name,IPM_Type_of_Milestone__c from IPM_Milestone__c where IPM_Type_of_Milestone__c ='Standard' AND recordTypeId =:mileMasterRecordType AND IPM_Project_Type__c='Original' ] );
            
        System.RunAs(globalUser)
        {
            List<IPM_Project__c> projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,(Select Id from Project_Documents__r),
                                                    (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
                                                    (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
            
            // Get Standard Milestones from database  
            System.assert(standardMileStoneMap.values().size() > 0);
            
            for(IPM_Project__c project : projectList)
            {
                System.assertEquals(project.Project_Documents__r.size(),1);
                for(IPM_Task__c task : project.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,project.IPM_Complexity__c);        
                }
                System.assertEquals(project.IPM_Milestones__r.size(),standardMileStoneMap.size());
                System.assertEquals(project.IPM_Financials_Consolidated__r.size(),1); // One for Global consolidated Financials
                System.assertEquals(project.IPM_Phase__c,'Ideas'); // Phase would be always ideas for Global Project.
                
                User regionalProjectLeader = [Select Id from User where LastName ='REGIONAL_PL' limit 1];
                
                // Create Regional Rollouts for Created Global project.
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
		            if(localRollout.IPM_Rollout_Project__c.contains('AFR'))
		            {
		                geoExternalId = 'AGO';
		            }
		            else if(localRollout.IPM_Rollout_Project__c.contains('LA'))
		            {
		                geoExternalId = 'BRA';
		            }
		            
		            IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = new mdm_Geography__c(ISO_3166_1_Code__c = geoExternalId).Id,
		            IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');    
		            
		            countryList.add(tempCountry);
		        }
		        
		        insert countryList;
            }               
        } 
        
        
        Test.stopTest();
     }
     
     /* 
     public static testmethod void testProjectWithGCLTRCLT()
     {
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
        User globalUser = [Select Id from User where  LastName ='PLATFORM_USER' limit 1];
        List<Id> globalProjectIdList = new List<Id>();
        
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>([Select Id,Name,IPM_Phase__c,(Select Id from Project_Documents__r),(Select Id,Name,recordTypeId,IPM_Project_Job_Status__c from IPM_Project_Rollout__r) from IPM_Project__c where Name in:projectNameSet]);
        // Create Regional Projects.
        System.runAs(globalUser)
        {
            List<IPM_Project_Rollout__c> projectRolloutList = new List<IPM_Project_Rollout__c>();
            Set<Id> projectDocumentSet = new Set<Id>();
            
            for(IPM_Project__c project : projectMap.values())
            {
                for(IPM_Project_Document__c projectDocument : project.Project_Documents__r)
                {
                    projectDocumentSet.add(projectDocument.Id);
                }
            }
            
            update projectRolloutList;
            
            List<IPM_Gate_CMI__c> cmiGateList = IPM_TestFactory_Helper.createCMIGateRecords(false,projectMap.values());
            insert cmiGateList;
            
            List<IPM_Project_Document_Section__c> projectSectionList =[Select Id,Name,IPM_Gate_Document_Summary__c,IPM_PDP_Document_Summary__c from IPM_Project_Document_Section__c where Id in:projectDocumentSet for update];
            
            List<IPM_Project_Document_Section_Content__c> finalSectionList = new List<IPM_Project_Document_Section_Content__c>();
            
            for(IPM_Project_Document_Section__c proSection : projectSectionList)
            {
                proSection.IPM_Gate_Document_Summary__c = proSection.IPM_PDP_Document_Summary__c = 'Test Copy Over';
                if(proSection.IPM_Master_Section_External_Id__c == 'Mix_Qualification_Plan_and_Action_Standards')
                {
                    proSection.IPM_CMI_Selected_Test_Concepts__c = 'Charter/Concept/Idea Screener - Nielsen;Charter/Concept/Innoscreen * ideas - Ipsos;Charter/Concept/Snapshot - Nielsen;Contract/Product Test/Branded Product Test - Ipsos';
               
                
                    for(IPM_Gate_CMI__c cmiGate : cmiGateList)
                    {
                          Map<String,List<Object>> CMIGateSectionMap = new Map<String,List<Object>>{
                             'IPM_CMI_Country__c' => new List<String>{cmiGate.Country__c,cmiGate.Country__c},
                             'IPM_CMI_Comments__c' => new List<String>{'Comments1','Comments2'},
                             'IPM_CMI_Input__c' => new List<String>{'Salience','Attraction'},
                             'IPM_CMI_Result__c' => new List<String>{'Risky (34% - 69%)','Failure (=< 33%)'},
                             'IPM CMI Outcome Color' => new List<String>{'CMIAmber','Red'},
                             'CMI Gate Test' => new List<String>{cmiGate.Test__c,cmiGate.Test__c},
                             'IPM_Gate_CMI__c' => new List<Id>{cmiGate.Id,cmiGate.Id},
                             'IPM_Project_Document_Section__c' => new List<Id>{proSection.Id,proSection.Id}
                          };
                     
                          List<IPM_Project_Document_Section_Content__c> tempSectionList = (List<IPM_Project_Document_Section_Content__c>)IPM_TestFactory.createSObjectList('IPM_Project_Document_Section_Content__c',CMIGateSectionMap,false);
                          finalSectionList.addAll(tempSectionList); 
                     }  
                }
            }
            
            // Update the Project Document Sections for Copy Over Logic to Run.
            update projectSectionList;
            
            // Insert CMI sections
            insert finalSectionList;
            
            Test.startTest();

            for(IPM_Project__c project : projectMap.values())
            {
                globalProjectIdList.add(project.Id);    
            }
            
            List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(globalProjectIdList,globalUser); 
            
            update projectListPhaseChange;
            
            Test.stopTest();
        }
        
        Map<Id,List<IPM_Project__c>> globalToRegionalMap = IPM_TestFactory_Helper.getRegionalProjects(globalProjectIdList);
            
        List<IPM_Project__c> regionalProjects = new List<IPM_Project__c>();
            
        for(Id gbProjectId : globalToRegionalMap.keySet())
        {
           regionalProjects.addAll(globalToRegionalMap.get(gbProjectId)); 
        }

        List<IPM_Project__c> DBRegionalProjects = [Select Id,Name,IPM_Phase__c,IPM_Parent_Project__c,(Select Id from Project_Documents__r),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r) from IPM_Project__c where ID in :regionalProjects];  
            
        for(IPM_Project__c regionalProject : DBRegionalProjects) 
        {
           Id parentGlobalProjectId = regionalProject.IPM_Parent_Project__c;
            
           IPM_Project__c parentGlobalProject = projectMap.get(parentGlobalProjectId);
            
           // Only Contract document Available at Regional Level.
           System.assertEquals(regionalProject.Project_Documents__r.size(),1);
            
           // MileStones would Copy from Parent Project. 
           System.debug('parentGlobalProject-->>>'+parentGlobalProject.IPM_Milestones__r);
           System.debug('parentGlobalProject-->>>'+regionalProject.IPM_Milestones__r);
           System.assertEquals(regionalProject.IPM_Milestones__r.size(),parentGlobalProject.IPM_Milestones__r.size());
        }            
    }

     public static testmethod void testProjectWithRCLTModel()
     {
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
        List<User> users = [Select Id,Email from User where LastName ='PLATFORM_USER'  limit 1];
        
        User globalUser = users[0];
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>([Select Id,Name,IPM_Phase__c,(Select Id from Project_Documents__r),(Select Id,Name,recordTypeId,IPM_Project_Job_Status__c from IPM_Project_Rollout__r) from IPM_Project__c where Name in:projectNameSet for update]);
        
        // Create Regional Projects.
        System.runAs(globalUser)
        {
            // Set GateKeeping Model as RCLT and start with Regional Project Creation.
            for(IPM_Project__c project : projectMap.values())
            {
                project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
            }  
            
            update projectMap.values();
            
            Test.startTest();
            
            List<Id> globalProjectIdList = new List<Id>();
            
            for(IPM_Project__c project : projectMap.values())
            {
                globalProjectIdList.add(project.Id);    
            }
            
            List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(globalProjectIdList,globalUser); 
            
            update projectListPhaseChange;
            List<IPM_Project__c>projList=[select Id,IPM_Phase__c from IPM_Project__c where Id=:projectListPhaseChange[0].Id limit 1];
            System.assertEquals(projList[0].IPM_Phase__c, IPM_ConstantUtils.PHASE_FEASIBILITY,'phase not changed');
            Test.stopTest();

            Map<Id,List<IPM_Project__c>> globalToRegionalMap = IPM_TestFactory_Helper.getRegionalProjects(globalProjectIdList);
        }
     }
     
     public static testmethod void testEcodesignSyncStatus()
     {
        List<User> users = [Select Id,Email from User where Email = 'globalUser@unilever.test.com' limit 1];        
        User globalUser = null;
       
        globalUser = users[0];
               
        // Create Regional Projects.
        System.runAs(globalUser)
        {
            Test.startTest();
            IPM_Project__c proj = [Select Id,EcoDesign_Sync_Status__c,Fetch_Timestamp_Mulesoft__c,Success_TimeStamp_EcoDesign__c from IPM_Project__c limit 1000][0];
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
            Test.stopTest();
        }
        
        
     }
     */
}