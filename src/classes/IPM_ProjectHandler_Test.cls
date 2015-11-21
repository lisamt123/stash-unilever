/******************************************** 
@Author: Cognizant
@name: IPM_ProjectHandler_Test
@CreateDate: 01/02/2015
@Description: Test class to test IPM_ProjectHandler Class.
@Version: 1.0
@reference: 
*********************************************/
@isTest
private class IPM_ProjectHandler_Test {
    
    public static IPM_Project__c project;
    public static User user2;
    public static User deputyPLUser;
    public static User technicalPLUser;
    public static User gatekeeperUser;
    private final static string STRING_BET = 'BET';
    private final static string STRING_MS_BET_FirstRelease = 'Brand Experience Toolkit(BET) First Release';
    
    
    public static List<IPM_Project__c> ipmProjectList;
    public static List<IPM_Country__c> ipmCountryList;
    public static List<IPM_Project_Resource__c> projectResList;
    public static User adminUser;
    public static User standardUser;
    public static MDO_Geography__c geography, geography1;
    public static mdm_Geography__c mdm, mdm1;
    public static IPM_Project__c ipmProject ;
    public static List<IPM_Project__c> projectlist;
    public static List<User> userList;
    public static List<MDO_Geography__c> mdo_geoList;
   

    /***********************************
      Description of the purpose of the method. 
      @name: initializeData
      @Description: Test Data Creation
      @param: none
      @return: none
      @throws: none
    ***********************************/
    
     static void initializeData(){        
        
        standardUser = IPM_TestFactory_Helper.createUser(true); 
        user2 = IPM_TestFactory_Helper.createUser(true);
        deputyPLUser = IPM_TestFactory_Helper.createUser(true);
        technicalPLUser = IPM_TestFactory_Helper.createUser(true);
        gatekeeperUser = IPM_TestFactory_Helper.createUser(true);
        adminUser = IPM_TestFactory_Helper.createUserAdmin(true);
                
        project = IPM_TestFactory_Helper.createIPMProject(false);
        project.Name = 'TestCom-ments';
        project.IPM_Project_Name__c = 'TestCommentsProjName';
        project.IPM_Fast_Track_Project__c = false;
        project.IPM_IsSaved__c = true;
        project.Is_Archieved__c = false;
        project.IPM_Complexity__c = 'Lite';
        project.IPM_GateKeeping_Model__c = 'Both'; 
        project.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
        project.IPM_Project_Leader__c = adminUser.Id;
        project.Update_BET__c = false;
        project.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
        project.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
        project.IPM_Brand_Positioning__c = IPM_ConstantUtils.TEST_STR;
        project.IPM_ProjectSubType__c = 'Innovation/Renovation';
        project.IPM_Document_Update_Comments__c = 'Start Comments';
        project.IPM_Target_Launch_Dates__c = System.today()+10;
        project.IPM_Category_Text__c = 'Laundry';
        project.IPM_Current_Document_Status__c = IPM_ConstantUtils.STATUS_NOT_STARTED;
        insert project;
        system.assert(project.Name!=null);
        
        IPM_Milestone__c milestone = new IPM_Milestone__c();
        milestone.IPM_Project__c = project.Id;
        milestone.Name = STRING_MS_BET_FirstRelease;
        milestone.IPM_Name__c = STRING_MS_BET_FirstRelease;
        milestone.IPM_Type_of_Milestone__c = STRING_BET;
        milestone.IPM_Due_Date__c = project.IPM_Target_Launch_Dates__c;
        insert milestone;
        
        project.Name = 'TestCommentsUpdated';
        project.IPM_Project_Name__c = 'UpdatedProjectName';
        project.IPM_Category_Text__c = 'Household Care';
        project.IPM_Complexity__c = IPM_ConstantUtils.COMPLEXITY_FULL;
        project.IPM_Fast_Track_Project__c = true;
        project.Is_Archieved__c = true;
        project.Update_BET__c = true;
        project.BET_Link_Requested__c = '';
        project.Exempt_from_Threshold__c = true;
        project.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_PROCESSING;
        project.IPM_Phase__c = IPM_ConstantUtils.MARKET_READY_GATE;
        project.Sustainability_Period__c = '5';
        project.IPM_Document_Update_Comments__c = 'Updated Comments';
        project.IPM_Current_Document_Status__c = IPM_ConstantUtils.STATUS_APPROVED;
        project.IPM_Document_Update_Date__c = System.today()+5;
        project.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;        
        project.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT; 
        project.IPM_Target_Launch_Dates__c = System.today()+50;
        project.IPM_Project_Leader__c = standardUser.Id;
        project.IPM_Finance_Member__c = user2.Id; 
        project.Deputy_Project_Leader__c = deputyPLUser.Id; 
        project.IPM_Technical_Project_Leader__c = technicalPLUser.Id; 
        project.IPM_Project_Gatekeeper__c = gatekeeperUser.Id; 
        update project;
    }
    
    /***********************************
      Description of the purpose of the method. 
      @name: testProjectHandlerInstantiation
      @Description: 
      @param: none
      @return: none
      @throws: none
    ***********************************/
    static testMethod void testProjectHandlerInstantiation(){ 

        initializeData();
            List<IPM_Project__c> projList = [SELECT Id, Name, IPM_Project_Name__c FROM IPM_Project__c Limit 10];
            system.assertEquals(1, projList.size(), 'IPM_Project__c Record Size Not Matched');
            List<User> userLst = [Select Id from User Limit 10];
            system.runAs(userLst[0]){             
                    Test.startTest();
                        IPM_ProjectHandler projectHandler = new IPM_ProjectHandler();
                        System.assert(projectHandler != null);
                    Test.stopTest();              
            }
         
    }
    
    static testMethod void testTrackHistoryChanges(){  
        
        initializeData();
        
        User globalUser = IPM_TestFactory_Helper.createUserAdmin(false);
        globalUser.email = 'globalUser@unilever.test.com';
        
        system.runAs(globalUser){ 
             
            project.IPM_Finance_Member__c = UserInfo.getUserId(); 
            Test.StartTest();
            update project;
            Test.StopTest();
            List<IPM_Project_Resource_History__c> lstPrjResourceHistory = [Select Id from IPM_Project_Resource_History__c where IPM_Project__c =: project.Id];
            System.assert(lstPrjResourceHistory.size() >= 1, 'Project resource history inserted');
            
        }   
        
    }
    
static testmethod void testBetAccessOnInsert(){

        test.loadData(IPM_Project_Type__c.sobjectType, 'IPM_ProjectType'); 
        test.loadData(IPM_BET_Search_Fields__c.sobjectType, 'IPM_BET_Search_Test'); 
        Test.loadData(IPM_ProjectMetadata__c.sObjectType, 'IPM_Project_Metadata');    
        User runningUser = IPM_TestFactory_Helper.createUser(false);
             
        system.runAs(runningUser) {
      
        uw_BET__c bet1 = BET_TestUtils.getTestBet();
        bet1.Status__c=IPM_ConstantUtils.BET_FINAL_RELEASE;
        bet1.FinalReleaseDate__c = Date.Today() + 365;
        bet1.Launch_Date__c=Date.today().addDays(10);
        
        uw_BET__c bet2 = BET_TestUtils.getTestBet();
        bet2.name='testBet';
        bet2.Status__c=IPM_ConstantUtils.BET_FIRST_RELEASE;
        bet2.FinalReleaseDate__c = Date.Today() + 365;
        bet2.Launch_Date__c = Date.Today() + 10;
          
        insert new  List<uw_BET__c>{bet1,bet2};
        
        IPM_Project__c projectI = IPM_TestFactory_Helper.createIPMProject(False);
        projectI.name='testPrj';
        projectI.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        projectI.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ;
        projectI.IPM_Project_Leader__c=UserInfo.getUserId();
        projectI.Deputy_Project_Leader__c=UserInfo.getUserId();
        projectI.BET__c=bet2.id;
   
        IPM_Project__c project1 = IPM_TestFactory_Helper.createIPMProject(False);
        project1.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        project1.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ;
        project1.IPM_Project_Leader__c=UserInfo.getUserId();
        project1.Deputy_Project_Leader__c=UserInfo.getUserId();
        project1.BET__c=bet1.id;
       
        IPM_Project__c projectII = IPM_TestFactory_Helper.createIPMProject(False);
        projectII.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        projectII.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ;
        projectII.IPM_Project_Leader__c=UserInfo.getUserId();
        projectII.Deputy_Project_Leader__c=UserInfo.getUserId();
        projectII.BET__c=bet1.id;
      
        insert new List<IPM_Project__c>{projectI ,project1,projectII};
        
        IPM_Project__c project4 = IPM_TestFactory_Helper.createIPMProject(False);
        project4.name='testBetProj4';
        project4.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        project4.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ;
        project4.IPM_Project_Leader__c=UserInfo.getUserId();
        project4.Deputy_Project_Leader__c=UserInfo.getUserId();
        project4.IPM_Parent_Project__c=project1.id;
        
        IPM_Project__c projectIII = IPM_TestFactory_Helper.createIPMProject(False);
        projectIII.name='testBetProj4a';
        projectIII.IPM_Project_Leader__c=UserInfo.getUserId();
        projectIII.Deputy_Project_Leader__c=UserInfo.getUserId();
        projectIII.IPM_Parent_Project__c=projectII.id;
        
        insert new List<IPM_Project__c>{project4,projectIII};
                
        IPM_Project__c project2 = IPM_TestFactory_Helper.createIPMProject(False);
        project2.name='testBetProj2';
        project2.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        project2.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ;
        project2.IPM_Project_Leader__c=UserInfo.getUserId();
        project2.Deputy_Project_Leader__c=UserInfo.getUserId();
        project2.BET__c=bet1.id;
        project2.IPM_Parent_Project__c=project1.id;
        project2.IPM_Fast_Track_Project__c=false;
       
        IPM_Project__c project3 = IPM_TestFactory_Helper.createIPMProject(False);
        project3.name='testBetProj3';
        project3.IPM_Project_Name__c='testIPMname';
        project3.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        project3.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ;
        project3.IPM_Project_Leader__c=UserInfo.getUserId();
        project3.Deputy_Project_Leader__c=null;
        project3.BET__c=bet2.id;
        project3.IPM_Parent_Project__c=project1.id;
        project3.IPM_Finance_Member__c=UserInfo.getUserId();
        
        IPM_Project__c project5 = IPM_TestFactory_Helper.createIPMProject(False);
        project5.name='testBetProj5';
        project5.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        project5.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL ;
        project5.IPM_Project_Leader__c=UserInfo.getUserId();
        project5.Deputy_Project_Leader__c=UserInfo.getUserId();
        project5.BET__c=bet2.id;
        project5.IPM_Parent_Project__c=project4.id;
        project5.IPM_BET_Toolkit__c='No BET';
        
        IPM_Project__c project6 = IPM_TestFactory_Helper.createIPMProject(False);
        project6.name='testBetProj6';
        project6.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        project6.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
        project6.IPM_Project_Leader__c=UserInfo.getUserId();
        project6.Deputy_Project_Leader__c=UserInfo.getUserId();
        project6.BET__c=bet2.id;
        project6.IPM_Parent_Project__c=projectIII.id;
        project6.IPM_Phase__c = IPM_ConstantUtils.PHASE_MARKET_READY;
        project6.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
        project6.IPM_Target_Launch_Date__c=string.valueofGmt(Date.today().addDays(25)); 
        project6.IPM_Target_Launch_Dates__c=Date.today().addDays(25);
        project6.IPM_CompanyCardText__c = IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
        project6.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_COMPLETED; 
 
        
        Test.Starttest();
        insert new List<IPM_Project__c>{project6,project5,project3,project2}; 
        Test.stoptest();
           
       System.assertEquals([Select Project_Id__c from BET_Member_Request__c where Project_Id__c=:projectII.id].Project_Id__c, projectII.id, 'Failed to send Regional/Local Rollout Leader Access Request to BET'); 
        
                }
      } 
      
      static testmethod void testBetUpdates(){

        test.loadData(IPM_Project_Type__c.sobjectType, 'IPM_ProjectType'); 
        test.loadData(IPM_BET_Search_Fields__c.sobjectType, 'IPM_BET_Search_Test'); 
        Test.loadData(IPM_ProjectMetadata__c.sObjectType, 'IPM_Project_Metadata');    
        User runningUser = IPM_TestFactory_Helper.createUser(false);
        User financeuser = IPM_TestFactory_Helper.createUser(true); 
        
        system.runAs(runningUser) {
        
        uw_BET__c bet1 = BET_TestUtils.getTestBet();
        bet1.Status__c=IPM_ConstantUtils.BET_FINAL_RELEASE;
        bet1.FinalReleaseDate__c = Date.Today() + 365;
        bet1.Launch_Date__c=Date.today().addDays(10);
        
        uw_BET__c bet2 = BET_TestUtils.getTestBet();
        bet2.name='testBet';
        bet2.Status__c=IPM_ConstantUtils.BET_FIRST_RELEASE;
        bet2.FinalReleaseDate__c = Date.Today() + 365;
        bet2.Launch_Date__c = Date.Today() + 10;
          
        insert new  List<uw_BET__c>{bet1,bet2};
        
        IPM_Project__c projectI = IPM_TestFactory_Helper.createIPMProject(False);
        projectI.name='testPrjI';
        projectI.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        projectI.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ;
        projectI.IPM_Project_Leader__c=UserInfo.getUserId();
        projectI.Deputy_Project_Leader__c=UserInfo.getUserId();
        projectI.BET__c=bet2.id;
   
        IPM_Project__c project1 = IPM_TestFactory_Helper.createIPMProject(False);
        project1.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        project1.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ;
        project1.IPM_Project_Leader__c=UserInfo.getUserId();
        project1.Deputy_Project_Leader__c=UserInfo.getUserId();
        project1.BET__c=bet1.id;
       
        IPM_Project__c projectII = IPM_TestFactory_Helper.createIPMProject(False);
        projectII.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        projectII.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ;
        projectII.IPM_Project_Leader__c=UserInfo.getUserId();
        projectII.Deputy_Project_Leader__c=UserInfo.getUserId();
        projectII.BET__c=bet1.id;
      
        insert new List<IPM_Project__c>{projectI ,project1,projectII};
        
        IPM_Project__c project4 = IPM_TestFactory_Helper.createIPMProject(False);
        project4.name='testBetProj4';
        project4.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        project4.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ;
        project4.IPM_Project_Leader__c=UserInfo.getUserId();
        project4.Deputy_Project_Leader__c=UserInfo.getUserId();
        project4.IPM_Parent_Project__c=project1.id;
        
        IPM_Project__c projectIII = IPM_TestFactory_Helper.createIPMProject(False);
        projectIII.name='testBetProjIII';
        projectIII.IPM_Project_Leader__c=UserInfo.getUserId();
        projectIII.Deputy_Project_Leader__c=UserInfo.getUserId();
        projectIII.IPM_Parent_Project__c=projectII.id;
        
        insert new List<IPM_Project__c>{project4,projectIII};
                
        IPM_Project__c project2 = IPM_TestFactory_Helper.createIPMProject(False);
        project2.name='testBetProj2';
        project2.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        project2.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ;
        project2.IPM_Project_Leader__c=UserInfo.getUserId();
        project2.Deputy_Project_Leader__c=UserInfo.getUserId();
        project2.BET__c=bet1.id;
        project2.IPM_Parent_Project__c=project1.id;
        project2.IPM_Fast_Track_Project__c=false;
       
        IPM_Project__c project3 = IPM_TestFactory_Helper.createIPMProject(False);
        project3.name='testBetProj3';
        project3.IPM_Project_Name__c='testIPMname';
        project3.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        project3.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ;
        project3.IPM_Project_Leader__c=UserInfo.getUserId();
        project3.Deputy_Project_Leader__c=null;
        project3.BET__c=bet2.id;
        project3.IPM_Parent_Project__c=project1.id;
        project3.IPM_Finance_Member__c=UserInfo.getUserId();
        
        IPM_Project__c project5 = IPM_TestFactory_Helper.createIPMProject(False);
        project5.name='testBetProj5';
        project5.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        project5.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL ;
        project5.IPM_Project_Leader__c=UserInfo.getUserId();
        project5.Deputy_Project_Leader__c=UserInfo.getUserId();
        project5.BET__c=bet2.id;
        project5.IPM_Parent_Project__c=project4.id;
        project5.IPM_BET_Toolkit__c='No BET';
        
        IPM_Project__c project6 = IPM_TestFactory_Helper.createIPMProject(False);
        project6.name='testBetProj6';
        project6.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        project6.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
        project6.IPM_Project_Leader__c=UserInfo.getUserId();
        project6.Deputy_Project_Leader__c=UserInfo.getUserId();
        project6.BET__c=bet2.id;
        project6.IPM_Parent_Project__c=projectIII.id;
        project6.IPM_Phase__c = IPM_ConstantUtils.PHASE_MARKET_READY;
        project6.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
        project6.IPM_Target_Launch_Date__c=string.valueofGmt(Date.today().addDays(25)); 
        project6.IPM_Target_Launch_Dates__c=Date.today().addDays(25);
        project6.IPM_CompanyCardText__c = IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
        project6.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_COMPLETED; 

        insert new List<IPM_Project__c>{project6,project5,project3,project2};

        project2.IPM_Project_Type__c= IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
        project2.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
        project2.IPM_Fast_Track_Project__c=true;       

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
        project6.IPM_Global_ProjectId__c = ' '; 
         
        Test.startTest(); 
         update  new List<IPM_Project__c>{project6,project5,project3,project2};
        Test.stopTest();

        System.assertEquals([select UserId__c from BET_Member_Request__c where Project_Id__c=: project3.id limit 1].UserId__c,project3.IPM_Project_Leader__c,'Failed to create acess request');
           }  
      }
     
     
}