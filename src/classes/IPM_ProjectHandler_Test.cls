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
    
    private static IPM_Project__c project;
    private static User user2;
    private static User deputyPLUser;
    private static User technicalPLUser;
    private static User gatekeeperUser;
    private static List < IPM_Project__c > projectlist;
    private static List < IPM_Project__c > betProjectList = IPM_TestFactory_Helper.createIPMProjectList(false, 10);
    private static User stdUserForBET;
    private static User adminUser;
    private static User standardUser;
    private static List < IPM_Company_Card__c > companyCardList;
    private static User platformUser;
    private static uw_BET__c bet1;
    private static uw_BET__c bet2;
    private final static string STRING_BET = 'BET';
    private final static string STRING_MS_BET_FirstRelease = 'Brand Experience Toolkit(BET) First Release';
    private final static String USER_LAST_NAME = 'PLATFORM_USER';  
    private final static String BLANK_STRING = IPM_ConstantUtils.BLANK;
    private final static String MANAGER_ACCESS = IPM_ConstantUtils.BET_MANAGER_ACCESS;
    private final static String Rollout = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
    private final static String REGIONAL = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
    private final static String LOCAL = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
   
     
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
        project.Sustainability_Period__c = '3';
        insert project;
        
        system.assertEquals(project.IPM_Project_Name__c ,[Select IPM_Project_Name__c from IPM_Project__c where Id=: project.Id ].IPM_Project_Name__c ,'Failed to insert project with the specified name.');
        
        IPM_Milestone__c milestone = new IPM_Milestone__c();
        milestone.IPM_Project__c = project.Id;
        milestone.Name = STRING_MS_BET_FirstRelease;
        milestone.IPM_Name__c = STRING_MS_BET_FirstRelease;
        milestone.IPM_Type_of_Milestone__c = STRING_BET;
        milestone.IPM_Due_Date__c = project.IPM_Target_Launch_Dates__c;
        milestone.ExternalField__c = project.Name+ STRING_MS_BET_FirstRelease;
        insert milestone;
        
        system.assertEquals(milestone.ExternalField__c ,[Select ExternalField__c from IPM_Milestone__c where Id=: milestone.Id ].ExternalField__c ,'Failed to create milestone with the specified external Id.');
        
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
        
        system.assertEquals(project.IPM_Project_Name__c ,[Select IPM_Project_Name__c from IPM_Project__c where Id=: project.Id ].IPM_Project_Name__c ,'Failed to update  project record .');
        
    }
    
    /***********************************************************
     This method creates test data to be used in test methods.
    ************************************************************/
    
    @testSetup static void setUpData() {
        Test.startTest();
        Test.loadData(IPM_BET_Search_Fields__c.sobjectType, 'IPM_BET_Search_Test');
        User financeuser = IPM_TestFactory_Helper.createUser(false);
        financeuser.lastname = 'financeUser';
        insert financeuser;
        system.assertEquals(financeuser.lastname ,[Select lastname from User where Id =:financeuser.Id].lastname, 'Failed to insert finance user.');
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)) {
            // user has to be created as system admin 
            stdUserForBET = IPM_TestFactory_Helper.createIPMPlatformProfileUser(BLANK_STRING);
        }
        uw_BET__c betRecord1 = BET_TestUtils.getTestBet();
        betRecord1.Status__c = IPM_ConstantUtils.BET_FINAL_RELEASE;
        betRecord1.FinalReleaseDate__c = Date.Today() + 365;
        betRecord1.Launch_Date__c = Date.today().addDays(10);
        betRecord1.name = 'testBet0';
        uw_BET__c betRecord2 = BET_TestUtils.getTestBet();
        betRecord2.name = 'testBet';
        betRecord2.Status__c = IPM_ConstantUtils.BET_FIRST_RELEASE;
        betRecord2.FinalReleaseDate__c = Date.Today() + 365;
        betRecord2.Launch_Date__c = Date.Today() + 10;
        insert new List < uw_BET__c > {
            betRecord1,
                betRecord2
                };
        
        system.assertEquals( betRecord1.name ,[Select name from uw_BET__c where Id=:betRecord1.Id].name, 'betRecord1 not inserted');
        
        system.assertEquals( betRecord2.name ,[Select name from uw_BET__c where Id=:betRecord2.Id].name, 'betRecord2 not inserted');
        
        IPM_Project__c parentProj = betProjectList[9];
        parentProj.ownerId = stdUserForBET.id;
        parentProj.Deputy_Project_Leader__c = stdUserForBET.id;
        parentProj.IPM_Project_Name__c = 'testParentProj1';
        parentProj.IPM_Project_Leader__c = stdUserForBET.id;
        insert parentProj;
        
        system.assertEquals(parentProj.IPM_Project_Name__c ,[Select IPM_Project_Name__c from  IPM_Project__c where Id=:parentProj.Id].IPM_Project_Name__c , 'parentProj not inserted');
        
        list < BET_BETWrapper.MemberRequest > lstMemberRequests = new list < BET_BETWrapper.MemberRequest > ();
        
        //Giving access to BET
        BET_BETWrapper.MemberRequest member = new BET_BETWrapper.MemberRequest();
        member.UserId = stdUserForBET.Id;
        member.AccessLevel = MANAGER_ACCESS;
        lstMemberRequests.add(member);
        BET_AccessService.RequestAccess(lstMemberRequests, betRecord1.Id, parentProj.id);
        BET_AccessService.RequestAccess(lstMemberRequests, betRecord2.Id, parentProj.id);
        
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)) {
            platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        companyCardList = new List < IPM_Company_Card__c > {
            globalCompanyCard,
                regionalCompanyCard,
                localCompanyCard
                };
        insert companyCardList;
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(8, platformUser);
        IPM_TestFactory_Helper.shareMasterProject(new List < User > {
            platformUser
                });
                
        System.runAs(platformUser) {
            integer count = 0; {
                for (IPM_Project__c proj: projectList) {
                    proj.First_Sync_To_EcoDesign__c = true;
                    proj.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
                    proj.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
                    proj.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
                    proj.IPM_CompanyCardText__c = 'Global Company Card';
                    proj.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
                    proj.IPM_Strategic_Intent__c = 'test';
                    proj.Name = 'test' + count;
                    proj.IPM_Project_Name__c = 'test' + count++;
                }
                insert projectList;
            }
            system.assertEquals([Select count() from IPM_Project__c where name like '%test%' AND First_Sync_To_EcoDesign__c=true], 8, 'Failed to create expected number of projects ');
            Test.stopTest();
        }
    }
    
   
    /**************************************************************************
     This method creates BET specific test data to be used in bet test methods.
    ***************************************************************************/
    static void betInitializeData() {
        bet1 = [Select Id, name, Status__c, FinalReleaseDate__c, Launch_Date__c from uw_BET__c where name = 'testBet0' limit 1000];
        bet2 = [Select Id, name, Status__c, FinalReleaseDate__c, Launch_Date__c from uw_BET__c where name = : 'testBet' limit 1000];
        betProjectList[0].name = 'testPrj1';
        betProjectList[0].IPM_Project_Type__c = Rollout;
        betProjectList[0].IPMProject_Span__c = REGIONAL;
        betProjectList[0].IPM_Project_Leader__c = UserInfo.getUserId();
        betProjectList[0].Deputy_Project_Leader__c = UserInfo.getUserId();
        betProjectList[0].BET__c = bet2.id;
        betProjectList[1].IPM_Project_Leader__c = UserInfo.getUserId();
        betProjectList[1].Deputy_Project_Leader__c = UserInfo.getUserId();
        betProjectList[1].BET__c = bet1.id;
        betProjectList[2].IPM_Project_Leader__c = UserInfo.getUserId();
        betProjectList[2].Deputy_Project_Leader__c = UserInfo.getUserId();
        betProjectList[2].BET__c = bet1.id;
        
        insert new List < IPM_Project__c > {
            betProjectList[0],
                betProjectList[1],
                betProjectList[2]
                };
                
         Set<ID> projIdSet1 = new  Set<ID> { betProjectList[0].Id,
                betProjectList[1].Id,
                betProjectList[2].Id }  ;    
                
        system.assertEquals(3 ,[Select count() from  IPM_Project__c where Id IN : projIdSet1] , 'Project list not inserted.');
        
                
        betProjectList[3].name = 'testPrj2';
        betProjectList[3].IPM_Project_Type__c = Rollout;
        betProjectList[3].IPMProject_Span__c = REGIONAL;
        betProjectList[3].IPM_Project_Leader__c = UserInfo.getUserId();
        betProjectList[3].Deputy_Project_Leader__c = UserInfo.getUserId();
        betProjectList[3].IPM_Parent_Project__c = betProjectList[1].id;
        betProjectList[4].name = 'testPrj3';
        betProjectList[4].IPM_Project_Leader__c = UserInfo.getUserId();
        betProjectList[4].Deputy_Project_Leader__c = UserInfo.getUserId();
        
        insert new List < IPM_Project__c > {
            betProjectList[3],
                betProjectList[4]
                };
                
        Set<ID> projIdSet2 = new  Set<ID> {  betProjectList[3].Id,
                betProjectList[4].Id
                }  ;        
                
        system.assertEquals(2 ,[Select count() from  IPM_Project__c where Id IN : projIdSet2] , 'Project list not inserted.');
                
                
        betProjectList[5].name = 'testPrj4';
        betProjectList[5].IPM_Project_Type__c = Rollout;
        betProjectList[5].IPMProject_Span__c = REGIONAL;
        betProjectList[5].IPM_Project_Leader__c = UserInfo.getUserId();
        betProjectList[5].Deputy_Project_Leader__c = UserInfo.getUserId();
        betProjectList[5].IPM_Parent_Project__c = betProjectList[1].id;
        betProjectList[5].IPM_Fast_Track_Project__c = false;
        betProjectList[6].name = 'testPrj5';
        betProjectList[6].IPM_Project_Name__c = 'testIPMPrj5';
        betProjectList[6].IPM_Project_Type__c = Rollout;
        betProjectList[6].IPMProject_Span__c = REGIONAL;
        betProjectList[6].IPM_Project_Leader__c = UserInfo.getUserId();
        betProjectList[6].Deputy_Project_Leader__c = null;
        betProjectList[6].IPM_Parent_Project__c = betProjectList[1].id;
        betProjectList[6].IPM_Finance_Member__c = UserInfo.getUserId();
        betProjectList[7].name = 'testPrj6';
        betProjectList[7].IPM_Project_Type__c = Rollout;
        betProjectList[7].IPMProject_Span__c = LOCAL;
        betProjectList[7].IPM_Project_Leader__c = UserInfo.getUserId();
        betProjectList[7].Deputy_Project_Leader__c = UserInfo.getUserId();
        betProjectList[7].IPM_Parent_Project__c = betProjectList[3].id;
        betProjectList[7].IPM_BET_Toolkit__c = 'No BET';
        betProjectList[8].name = 'testPrj7';
        betProjectList[8].IPM_Project_Type__c = Rollout;
        betProjectList[8].IPMProject_Span__c = LOCAL;
        betProjectList[8].IPM_Project_Leader__c = UserInfo.getUserId();
        betProjectList[8].Deputy_Project_Leader__c = UserInfo.getUserId();
        betProjectList[8].IPM_Parent_Project__c = betProjectList[4].id;
        betProjectList[8].IPM_Phase__c = IPM_ConstantUtils.PHASE_MARKET_READY;
        betProjectList[8].IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
        betProjectList[8].IPM_Target_Launch_Date__c = string.valueofGmt(Date.today().addDays(25));
        betProjectList[8].IPM_Target_Launch_Dates__c = Date.today().addDays(25);
        betProjectList[8].IPM_CompanyCardText__c = IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
        betProjectList[8].IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_COMPLETED;
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
        List < IPM_Project__c > projList = [SELECT Id, Name, IPM_Project_Name__c FROM IPM_Project__c Limit 1];
        //Validating that the project has beeen successfully inserted
        system.assertEquals(1, projList.size(), 'IPM_Project__c Record Size Not Matched');
        
        system.runAs(adminUser){             
            Test.startTest();
            IPM_ProjectHandler projectHandler = new IPM_ProjectHandler();
            Test.stopTest();              
        }
    }
    /***********************************
      Description of the purpose of the method. 
      @name: testProjectUpdation
      @Description: test updation of project
      @param: none
      @return: none
      @throws: none
    ***********************************/
    static testMethod void testProjectUpdation(){ 
        
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        System.runAs(globalUser){
            projectList = [SELECT Id, Name, IPM_Project_Name__c FROM IPM_Project__c Limit 1000];
            Test.startTest();
                for(IPM_Project__c proj : projectList){
                    proj.IPM_Strategic_Intent__c = 'testNew';
                }
                update projectList;
            IPM_Project__c updatedProj= [Select id,EcoDesign_Sync_Status__c,IPM_Strategic_Intent__c from IPM_Project__c Limit 1][0];
            System.assertEquals('testNew',updatedProj.IPM_Strategic_Intent__c ,'Failed to update strategic intent on project.' );  
            Test.stopTest();              
        }
    }
    
    /*Description of the purpose of the method. 
    @name: testTrackHistoryChanges
    @Description: Test creation of project history record on update of a project
    @param: none
    @return: none
    @throws: none
    ***********************************/
    static testMethod void testTrackHistoryChanges(){  
        
        initializeData();
        
        User globalUser = IPM_TestFactory_Helper.createUserAdmin(false);
        globalUser.email = 'globalUser@unilever.test.com';
        
        system.runAs(globalUser){ 
            
            project.IPM_Finance_Member__c = UserInfo.getUserId(); 
            Test.StartTest();
            update project;
            Test.StopTest();
            List<IPM_Project_Resource_History__c> lstPrjResourceHistory = [Select Id from IPM_Project_Resource_History__c where IPM_Project__c =: project.Id limit 100];
            System.assert(lstPrjResourceHistory.size() >= 1, 'Project resource history inserted');
            
        }   
        
    }
    
     /***************************************************************************************************
     This is to test  BetAccessOnInsert method , this checks if member requests  were created for the BET . 
    *****************************************************************************************************/
    static testmethod void testBetAccessOnInsert(){
        
        User testRunningUser = [Select Id, LastName from User where LastName = : USER_LAST_NAME limit 1];
        
        system.runAs(testRunningUser) {
            
            betInitializeData();
            
            Test.Starttest();
            insert new List < IPM_Project__c > {
                betProjectList[8],
                    betProjectList[7],
                    betProjectList[6],
                    betProjectList[5]
                    };
                        Test.stoptest();
            
            System.assertEquals([Select Project_Id__c from BET_Member_Request__c where Project_Id__c = : betProjectList[1].id limit 1].Project_Id__c, betProjectList[1].id, 'Failed to send Regional/Local Rollout Leader Access Request to BET');
            
        }
    } 
    
    /**************************************************************************************
     This checks if member requests  were created for the BET on project update . 
    ****************************************************************************************/
    
    static testmethod void testBetUpdates(){
        
        User testRunningUser = [Select Id, LastName from User where LastName = : USER_LAST_NAME limit 1];
        User financeuser = [Select Id, LastName from User where LastName = 'financeUser' limit 100];
        
        system.runAs(testRunningUser) {
           
            betInitializeData();
            
            insert new List < IPM_Project__c >{
                betProjectList[8],
                    betProjectList[7],
                    betProjectList[6],
                    betProjectList[5]
                    };
                    
            Set<Id> projIds =new Set<Id> { betProjectList[8].Id,
                    betProjectList[7].Id,                 
                    betProjectList[6].Id ,
                    betProjectList[5].Id 
                    };
                    
                    
            system.assertEquals(4,[Select count() from IPM_Project__c where Id IN : projIds],'Failed to create project records');      
                        
            betProjectList[5].IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            betProjectList[5].IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
            betProjectList[5].IPM_Fast_Track_Project__c = true;
            
            betProjectList[6].IPMProject_Span__c = LOCAL;
            betProjectList[6].IPM_Finance_Member__c = financeuser.id;
            betProjectList[6].IPM_Project_Name__c = 'testProj';
            betProjectList[6].IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
            betProjectList[6].IPM_BET_Toolkit__c = Label.IPM_BET_NoBET;
            betProjectList[6].IPM_Project_Leader__c = financeuser.id;
            betProjectList[6].Deputy_Project_Leader__c = userinfo.getuserid();
            
            
            betProjectList[7].BET__c = null;
            betProjectList[7].IPM_BET_Toolkit__c = Label.IPM_CreateNewBET;
            
            betProjectList[8].BET__c = bet1.id;
            betProjectList[8].IPM_Project_Leader__c = financeuser.id;
            betProjectList[8].Deputy_Project_Leader__c = financeuser.id;
            betProjectList[8].IPM_Target_Launch_Date__c = string.valueofGmt(Date.today().addDays(30));
            betProjectList[8].IPM_Target_Launch_Dates__c = Date.today().addDays(30);
            betProjectList[8].IPM_Global_ProjectId__c = ' ';
            
            Test.startTest(); 
            update new List < IPM_Project__c > {
                betProjectList[8],
                    betProjectList[7],
                    betProjectList[6],
                    betProjectList[5]
                    };
            Test.stopTest();
            
            system.assertEquals([select UserId__c from BET_Member_Request__c where Project_Id__c = : [Select Id from IPM_Project__c where name = 'testParentProj1'
                                                                                                      limit 1
                                                                                                     ].Id limit 1].UserId__c, [Select IPM_Project_Leader__c from IPM_Project__c where name = 'testPrj4'
                                                                                                                               limit 1
                                                                                                                              ].IPM_Project_Leader__c, 'Failed to create acess request');
        }  
    }
    
}
