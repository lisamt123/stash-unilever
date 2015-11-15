/**
   @Author: Cognizant
   @name : IPM_ProjectsHandler_Test
   @CreateDate : 
   @Description : Test class for IPM_ProjectTriggerHandler
   @Version <1.0>
   @reference 
  */
@isTest
public class IPM_ProjectsHandler_Test{

    private static User getUser(String ProfileName){
            Profile p=[Select Id from Profile where Name =: ProfileName];
            User user = IPM_TestFactory_Helper.createUser(false); 
            if(p!=Null){
            user.ProfileId = p.Id;
            insert user;//insert user
        }
        return user;
    }
    static testmethod void testIPM_ProjectsHandlerConstructor(){
     
     Map<Id,IPM_Project__c> mapNewIPMProjects = new Map<Id,IPM_Project__c>();
    
     List<IPM_Project__c> listOldProject= new List<IPM_Project__c>();
                   
     IPM_Project__c project = IPM_TestFactory_Helper.createIPMProject(False);
     project.Name='TestGate';
     project.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
     project.IPM_Complexity__c=IPM_ConstantUtils.COMPLEXITY_FULL;
     project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
     project.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
     project.Deputy_Project_Leader__c = UserInfo.getUserId();
     project.IPM_Project_Leader__c = UserInfo.getUserId();
     project.IPM_Finance_Member__c = UserInfo.getUserId();
     project.IPM_Temporary_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
     insert project;
        
     mapNewIPMProjects.put(project.Id,project);
     listOldProject.add(project); 
     
     IPM_Task__c ipmTask = IPM_TestFactory_Helper.createIPMTask(project.Id,False);
     ipmTask.IPM_Project__c=project.Id ;
     ipmTask.IPM_Task_Complexity__c =IPM_ConstantUtils.COMPLEXITY_FULL ;
     insert ipmTask;
     
     IPM_Project__c project1 = IPM_TestFactory_Helper.createIPMProject(False);   
     project1.Name='TestGate1';
     project1.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
     project1.IPM_Complexity__c=IPM_ConstantUtils.COMPLEXITY_LITE;
     project1.IPM_Temporary_Phase__c = IPM_ConstantUtils.PHASE_IDEAS; 
     project1.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
     project1.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
     project1.Deputy_Project_Leader__c = UserInfo.getUserId();
     project1.IPM_Project_Leader__c = UserInfo.getUserId();
     project1.IPM_Finance_Member__c = UserInfo.getUserId(); 
     insert project1;
        
     mapNewIPMProjects.put(project1.Id,project1);
     listOldProject.add(project);      

     IPM_Project_Task__c ipmProjectTasks= new IPM_Project_Task__c();
     ipmProjectTasks.IPM_Project__c =project.Id ;   
     ipmProjectTasks= new IPM_Project_Task__c();
     ipmProjectTasks.IPM_Project__c =project1.Id ;
     ipmTask.IPM_Task_Complexity__c =IPM_ConstantUtils.COMPLEXITY_FULL ;
     insert ipmProjectTasks;
          
     IPM_ProjectsHandler.processIPMProjects (mapNewIPMProjects ,listOldProject,'UPDATE');
     List<IPM_Project_Task__c> lstTasks = [Select Id from IPM_Project_Task__c WHERE Id=:ipmProjectTasks.Id];
     System.assert(lstTasks != null && !lstTasks.isEmpty());
     
     }
 
  static testmethod void testCreateTasks(){

     Map<Id,IPM_Project__c> mapNewIPMProjects = new Map<Id,IPM_Project__c>();
     Map<Id,IPM_Project__c> mapOldIPMProjects = new Map<Id,IPM_Project__c>(); 
     List<IPM_Project__c> listOldProject= new List<IPM_Project__c>();
     
     IPM_Project__c project = IPM_TestFactory_Helper.createIPMProject(False);
     
     project.Name='TestGate2';
     project.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
     project.IPM_Complexity__c=IPM_ConstantUtils.COMPLEXITY_FULL;
     project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
     project.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
     project.Deputy_Project_Leader__c = UserInfo.getUserId();
     project.IPM_Project_Leader__c = UserInfo.getUserId();
     project.IPM_Finance_Member__c = UserInfo.getUserId();
     project.IPM_Temporary_Phase__c = IPM_ConstantUtils.PHASE_IDEAS; 
     insert project;
      
     mapNewIPMProjects.put(project.Id,project);
     project.IPM_Complexity__c=IPM_ConstantUtils.COMPLEXITY_LITE;
     update project;
     
     mapOldIPMProjects.put(project.Id,project);
     listOldProject.add(project); 
        
     IPM_Task__c ipmTask= IPM_TestFactory_Helper.createIPMTask(project.Id,False);
     ipmTask.IPM_Project__c=project.Id ;
     ipmTask.IPM_Task_Complexity__c =IPM_ConstantUtils.COMPLEXITY_FULL ;
     ipmTask.IPM_Type_of_Gate__c = IPM_ConstantUtils.CONTRACT_GATE;
     ipmTask.IPM_Function__c = 'Supply Chain';
     insert ipmTask; 
     
     IPM_Project_Task__c ipmProjectTasks= new IPM_Project_Task__c();
     ipmProjectTasks.IPM_Project__c =project.Id ;
     ipmProjectTasks.IPM_Gate_Documents__c='Charter Document'; 
     insert ipmProjectTasks;
      
     IPM_ProjectsHandler.createTasks(mapNewIPMProjects ,mapOldIPMProjects);
     
     IPM_Project__c project1 = IPM_TestFactory_Helper.createIPMProject(False);
     project1.Name='TestGate3';
     project1.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
     project1.IPM_Complexity__c=IPM_ConstantUtils.COMPLEXITY_LITE;
     project1.IPM_Temporary_Phase__c = IPM_ConstantUtils.PHASE_IDEAS; 
     project1.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
     project1.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
     project1.Deputy_Project_Leader__c = UserInfo.getUserId();
     project1.IPM_Project_Leader__c = UserInfo.getUserId();
     project1.IPM_Finance_Member__c = UserInfo.getUserId();       
     insert project1;
      
     mapNewIPMProjects.put(project1.Id,project1);    
     
     mapOldIPMProjects.put(project1.Id,project1);
     listOldProject.add(project1); 

     ipmProjectTasks= new IPM_Project_Task__c();
     ipmProjectTasks.IPM_Project__c =project1.Id ;
     Insert ipmProjectTasks;
     
     IPM_Task__c ipmTask1 = IPM_TestFactory_Helper.createIPMTask(project1.Id,False);

     ipmTask1.IPM_Project__c=project1.Id ;
     ipmTask1.IPM_Task_Complexity__c =IPM_ConstantUtils.COMPLEXITY_FULL ;
     ipmTask1.IPM_Type_of_Gate__c = IPM_ConstantUtils.CHARTER_GATE;
     insert ipmTask1;
     
     ipmProjectTasks.IPM_Gate_Documents__c = 'Charter Document';
     update ipmProjectTasks;
         
     IPM_ProjectsHandler.createTasks(mapNewIPMProjects ,mapOldIPMProjects);
     List<IPM_Project_Task__c> lstTasks = [Select Id from IPM_Project_Task__c WHERE Id=:ipmProjectTasks.Id];
     System.assert(lstTasks != null && !lstTasks.isEmpty());

     }
     
    /***cut pasted to IPM_ProjectHandler_Test  static testmethod void testBetAccess(){
        
        uw_BET__c bet1 = BET_TestUtils.getTestBet();
        bet1.Status__c=IPM_ConstantUtils.BET_FINAL_RELEASE;
        insert bet1;
        
        uw_BET__c bet2 = BET_TestUtils.getTestBet();
        bet2.name='testBet';
        bet2.Status__c=IPM_ConstantUtils.BET_FIRST_RELEASE;
        insert bet2;
        
        //////
        IPM_Project__c project = IPM_TestFactory_Helper.createIPMProject(False);
        project.name='testPrj';
        project.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        project.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ;
      
         project.IPM_Project_Leader__c=UserInfo.getUserId();
          project.Deputy_Project_Leader__c=UserInfo.getUserId();
          project.BET__c=bet2.id;
        insert project;
        
        
        //parent1
         IPM_Project__c project1 = IPM_TestFactory_Helper.createIPMProject(False);
        project1.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        project1.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ;
      
         project1.IPM_Project_Leader__c=UserInfo.getUserId();
          project1.Deputy_Project_Leader__c=UserInfo.getUserId();
          project1.BET__c=bet1.id;
        insert project1;
        
        
        IPM_Project__c projectA = IPM_TestFactory_Helper.createIPMProject(False);
        projectA.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        projectA.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ;
      
         projectA.IPM_Project_Leader__c=UserInfo.getUserId();
          projectA.Deputy_Project_Leader__c=UserInfo.getUserId();
          projectA.BET__c=bet1.id;
        insert projectA; 
        
        
        //parent2
        
        IPM_Project__c project4 = IPM_TestFactory_Helper.createIPMProject(False);
         project4.name='testBetProj4';
        project4.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        project4.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ;
      
         project4.IPM_Project_Leader__c=UserInfo.getUserId();
          project4.Deputy_Project_Leader__c=UserInfo.getUserId();
       // project4.BET__c=bet1.id;//
         project4.IPM_Parent_Project__c=project1.id;
        
        insert project4;
        
         IPM_Project__c project4a = IPM_TestFactory_Helper.createIPMProject(False);
         project4a.name='testBetProj4a';
       // project4a.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        //project4a.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ;
      
         project4a.IPM_Project_Leader__c=UserInfo.getUserId();
          project4a.Deputy_Project_Leader__c=UserInfo.getUserId();
       // project4.BET__c=bet1.id;//
        project4a.IPM_Parent_Project__c=projectA.id;
         //project4a.IPM_Parent_Project__c=project.id;
        insert project4a;
        
        
         IPM_Project__c project2 = IPM_TestFactory_Helper.createIPMProject(False);
         project2.name='testBetProj2';
        project2.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        project2.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ;
       
         project2.IPM_Project_Leader__c=UserInfo.getUserId();
          project2.Deputy_Project_Leader__c=UserInfo.getUserId();
          project2.BET__c=bet1.id;
         project2.IPM_Parent_Project__c=project1.id;
          project2.IPM_Fast_Track_Project__c=false;// added after insert test succeeded
       // insert project2;
        
       
         IPM_Project__c project3 = IPM_TestFactory_Helper.createIPMProject(False);
         project3.name='testBetProj3';
         project3.IPM_Project_Name__c='testIPMname';
        project3.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        project3.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ;
        
         project3.IPM_Project_Leader__c=UserInfo.getUserId();
         // project3.Deputy_Project_Leader__c=UserInfo.getUserId();
         project3.Deputy_Project_Leader__c=null;// for update tests
          project3.BET__c=bet2.id;
          project3.IPM_Parent_Project__c=project1.id;
          project3.IPM_Finance_Member__c=UserInfo.getUserId();// for update tests
        //insert project3;
        
         //parent with parent
        
        
        
        
         IPM_Project__c project5 = IPM_TestFactory_Helper.createIPMProject(False);
         project5.name='testBetProj5';
        project5.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        project5.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL ;
      
         project5.IPM_Project_Leader__c=UserInfo.getUserId();
          project5.Deputy_Project_Leader__c=UserInfo.getUserId();
          project5.BET__c=bet2.id;
          project5.IPM_Parent_Project__c=project4.id;
          project5.IPM_BET_Toolkit__c='No BET';// for update tests
        //insert project5;
        
           IPM_Project__c project6 = IPM_TestFactory_Helper.createIPMProject(False);
         project6.name='testBetProj6';
        project6.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        project6.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
       
         project6.IPM_Project_Leader__c=UserInfo.getUserId();
          project6.Deputy_Project_Leader__c=UserInfo.getUserId();
          project6.BET__c=bet2.id;
          project6.IPM_Parent_Project__c=project4a.id;
            project6.IPM_Target_Launch_Date__c=string.valueofGmt(Date.today().addDays(25)); 
         project6.IPM_Target_Launch_Dates__c=Date.today().addDays(25);
       // insert project6;
        Test.Starttest();
        insert new List<IPM_Project__c>{project6,project5,project3,project2}; 
         Test.stoptest();
           System.debug(' Count()**'+project6.id+project5.id+project4.id+project3.id+project2.id);
            System.debug(' Count()**'+[Select Project_Id__c from BET_Member_Request__c]);
       System.assertEquals([Select Project_Id__c from BET_Member_Request__c where Project_Id__c=:projectA.id].Project_Id__c, projectA.id, 'Failed to send Regional/Local Rollout Leader Access Request to BET'); 
        // insert tests completed and update test starts//
           
           
           project2.IPM_Project_Type__c= IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
           project2.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
           project2.IPM_Fast_Track_Project__c=true;       
        
          User financeuser = IPM_TestFactory_Helper.createUser(true); 
        	
         project3.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
         project3.IPM_Finance_Member__c=financeuser.id;
         project3.IPM_Project_Name__c='testProj';
         project3.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
         project3.IPM_BET_Toolkit__c=Label.IPM_BET_NoBET;
          project3.IPM_Project_Leader__c=financeuser.id;
          project3.Deputy_Project_Leader__c=userinfo.getuserid();
         
         
         
         
         // for milestone creation 
         
         project5.IPM_BET_Toolkit__c=Label.IPM_CreateNewBET;
         project5.BET__c=null;
         project5.IPM_BET_Toolkit__c=Label.IPM_CreateNewBET;
         
         
         project6.BET__c=bet1.id;
         project6.IPM_Project_Leader__c=financeuser.id;
         project6.Deputy_Project_Leader__c=financeuser.id;
         project6.IPM_Target_Launch_Date__c=string.valueofGmt(Date.today().addDays(30)); 
         project6.IPM_Target_Launch_Dates__c=Date.today().addDays(30);
         
         update  new List<IPM_Project__c>{project6,project5,project3,project2};
         System.debug('Launchdat**'+[Select Launch_Date__c FROM  uw_BET__c where Launch_Date__c!=null]);
       System.assertEquals([Select Launch_Date__c FROM  uw_BET__c where id=:bet1.id].Launch_Date__c,  project6.IPM_Target_Launch_Dates__c,'Failed to send IPM updates to BET ');
       
       //for(IPM_Milestone__c m:[select name,IPM_Project__r.name from  IPM_Milestone__c ]){System.debug('milest**'+m.name+'**'+m.IPM_Project__r.name);}
       
       System.debug([select IPM_Project_Name__c 	 from  IPM_Milestone__c]);
       
      } *****/
      
      //Test if the ecodesign sync status is set to Ready when the project is updated 
      static testmethod void testProjectUpdate(){
        // Current running in Sharing mode with old sharing logic. Using System admin profile for time being.
        User globalUser = IPM_TestFactory_Helper.createUserAdmin(false);
        globalUser.email = 'globalUser@unilever.test.com';
         
        User regionalUser = IPM_TestFactory_Helper.createUserAdmin(false);
        regionalUser.email = 'regionalUser@unilever.test.com';
        
        User localUser = IPM_TestFactory_Helper.createUserAdmin(false);
        localUser.email = 'localUser@unilever.test.com';
        
        List<User> userList = new List<User>{globalUser,regionalUser,localUser};
                    
        List<IPM_Assessment__c> finalAssessmentList = new List<IPM_Assessment__c>();
        Test.startTest();
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
         
        List<String> projectNames = new List<String>();

        System.runAs(userList[0])
        {
            
            IPM_Project_Type__c projectType = new IPM_Project_Type__c();
            projectType.Name = 'Original-Global-GCLTRCLT-Capability1';
            projectType.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            projectType.IPM_Project_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
            projectType.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            projectType.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
            projectType.IPM_Source_Company_Card__c = 'Global Company Card';
            projectType.IPM_Copy_Over_Assessments__c = true; 
            insert projectType;
        
            // Get master data for the project including Templates,Documents,Section,Tasks and Milestones.
            IPM_TestFactory_Helper.getProjectMasterData();
            
            // Create project for assignment.
            List<IPM_Project__c> projectList = IPM_TestFactory_Helper.createOriginalProjectList(false, 10);
            for(IPM_Project__c project : projectList)
            {
                project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
                project.IPM_Company_Card__c = companyCardList[0].Id;
                project.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
                project.IPM_Project_Leader__c = userList[0].Id;
                project.IPM_Strategic_Intent__c = 'test';
                project.Synced_From_EcoDesign_TimeStamp__c = System.now().addMinutes(15);
                project.First_Sync_To_EcoDesign__c = true;
                
            }
        
            insert projectList;
            
            IPM_Project__c proj = [Select Id, IPM_Strategic_Intent__c, EcoDesign_Sync_Status__c, Fetch_Timestamp_Mulesoft__c,First_Sync_To_EcoDesign__c from IPM_Project__c][0];
            proj.IPM_Strategic_Intent__c = 'testnew';
            
            update proj;
            
            IPM_Project__c proj1 = [Select Id, IPM_Strategic_Intent__c, EcoDesign_Sync_Status__c, Fetch_Timestamp_Mulesoft__c,First_Sync_To_EcoDesign__c from IPM_Project__c Where Id =: proj.Id][0];
            System.debug('***isProjectReadyToSyncToEcoDesign*****'+IPM_ProjectCountryDetails.isProjectReadyToSyncToEcoDesign(proj));
            System.debug('***First_Sync_To_EcoDesign__c*****'+proj1.First_Sync_To_EcoDesign__c);
			System.assertEquals(null,proj1.EcoDesign_Sync_Status__c);
			
        }
        Test.stopTest();
      }
     
}