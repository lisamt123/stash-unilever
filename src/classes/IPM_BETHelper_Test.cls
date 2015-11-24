@istest
class IPM_BETHelper_Test {

    static IPM_Project__c projectList[0]  = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c projectList[1]  = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c projectList[2]  = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c projectList[3]  = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c projectList[4]  = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c projectList[5]  = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c projectList[6]  = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c projectList[7]  = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c projectList[8]  = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c projectList[9] = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c projectList[10] = IPM_TestFactory_Helper.createIPMProject(false); 
    public static list<IPM_Project__c> projectList=IPM_TestFactory_Helper.createIPMProjectList(false,11);
    static User runningUser = IPM_TestFactory_Helper.createUser(false);
    
    static uw_BET__c betRecord  = BET_TestUtils.getTestBet();
    static uw_BET__c betRecord1 = BET_TestUtils.getTestBet();
    static uw_BET__c betRecord2 = BET_TestUtils.getTestBet();
    static uw_BET__c betRecord3 = BET_TestUtils.getTestBet();
    static uw_BET__c betRecord4 = BET_TestUtils.getTestBet();

    Static String Feasibility  = IPM_ConstantUtils.PHASE_FEASIBILITY;
    Static String Rollout =  IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
    Static String RCLT =  IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
    Static String Local =  IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
    Static String MarketReady =  IPM_ConstantUtils.PHASE_MARKET_READY;
    Static String GlobalCompanyCard =  IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
    Static String Completed =  IPM_ConstantUtils.JOB_STATUS_COMPLETED;
    Static String Regional =  IPM_ConstantUtils.COMPANY_CARD_REGIONAL;
    Static String FirstRelease =  IPM_ConstantUtils.BET_FIRST_RELEASE;
    Static String IPM_ProjectType =  'IPM_ProjectType';
    Static String IPM_BET_Search_Test =  'IPM_BET_Search_Test';
    Static String FinalRelease =  'Final Release';
    
    private static User stdUserForBET;// Variable has been used in setupdata method
    
    @testSetup static void setUpData(){
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            stdUserForBET = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
        } 
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCards = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCards = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCards = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCards,regionalCompanyCards,localCompanyCards};
        insert companyCardList;
        
         IPM_TestFactory_Helper.getProjectMasterData();
         
         //projectList = IPM_TestFactory_Helper.projectSetUp(11,stdUserForBET );
         
         System.runAs(platformUser)
         { 
            insert projectList;
         }  
         system.assertEquals(projectList.size(),11,'Projects are not created'); 
        
    }
    
    
    
    // Test method for method to Update BET Milestones DueDate after BET is associated/updated to IPM Project  
    private static testmethod void testupdateBETmilestones() {
        
        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        
        betRecord1.Status__c = FinalRelease;
        betRecord1.Final_Release_Due_Date__c = Date.Today();
        betRecord1.First_Release_Due_Date__c = Date.Today();
        betRecord1.Launch_Date__c = Date.Today();
        insert betRecord1;
        
        System.runAs(testRunningUser){
            projectList[0].BET__c = betRecord1.Id;
            projectList[0].IPM_Phase__c = Feasibility;
            projectList[0].IPM_Project_Type__c = Rollout;
            projectList[0].IPM_GateKeeping_Model__c = RCLT;
            projectList[0].IPMProject_Span__c = Local;
            projectList[0].IPM_Phase__c = MarketReady;
            projectList[0].IPM_CompanyCardText__c = GlobalCompanyCard;
            projectList[0].IPM_Project_Job_Status__c = Completed;
            projectList[0].IPM_Target_Launch_Dates__c = Date.Today();
            
            
            projectList[1].IPM_Project_Name__c = 'TestPr';
            projectList[1].IPM_Project_Type__c = Rollout;
            projectList[1].IPM_GateKeeping_Model__c = RCLT;
            projectList[1].IPMProject_Span__c = Regional;
            projectList[1].IPM_Phase__c = MarketReady;
            projectList[1].IPM_CompanyCardText__c = GlobalCompanyCard;
            projectList[1].IPM_Global_ProjectId__c = ' ';
            
            insert new List < IPM_Project__c > {
                projectList[0], projectList[1]
            };
            
            Map < string, ipm_project__c > mapProjBET = new Map < string, ipm_project__c > ();
            
            mapProjBET.put(projectList[0].id, projectList[0]);
            mapProjBET.put(projectList[1].id, projectList[1]);
            
            Test.StartTest();
            IPM_BETHelper.updateBETmilestones(mapProjBET);
            Test.StopTest();
        }
        system.assertEquals([Select First_Release_Due_Date__c from uw_BET__c where id = : betRecord1.id].First_Release_Due_Date__c, [Select IPM_Due_Date__c from IPM_Milestone__c where IPM_Project__c = : projectList[0].id limit 1].IPM_Due_Date__c, 'BET Milestones DueDate updation failed ');
    }

    private static testmethod void testupdateBETMilestoneMissOnProject() {
        
        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        
        Map < id, list < IPM_Milestone__c >> mapProjectBETMS = new map < id, list < IPM_Milestone__c >> ();
        List < IPM_Milestone__c > IPMsam1 = IPM_TestFactory_Helper.createIPMMilestoneList(false, 2);
        List < IPM_Milestone__c > IPMsam2 = IPM_TestFactory_Helper.createIPMMilestoneList(false, 2);

        betRecord1.Status__c = 'Unreleased';
        betRecord1.FinalReleaseDate__c = Date.Today() + 365;
        betRecord1.Name = 'TestBet1';


        betRecord2.Status__c = FirstRelease;
        betRecord2.FinalReleaseDate__c = Date.Today() + 365;
        betRecord2.Name = 'TestBet2';
        
        insert new List < uw_BET__c > {
            betRecord1, betRecord2
        };


        System.runAs(testRunningUser){
            projectList[0].BET__c = betRecord1.Id;
            projectList[0].IPM_Project_Name__c = 'TestP1';
            projectList[0].IPM_Phase__c = Feasibility;
            projectList[0].IPM_Project_Type__c = Rollout;
            projectList[0].IPM_GateKeeping_Model__c = RCLT;
            projectList[0].IPMProject_Span__c = Local;
            projectList[0].IPM_Phase__c = MarketReady;
            projectList[0].IPM_CompanyCardText__c = GlobalCompanyCard;
            projectList[0].IPM_Project_Job_Status__c = Completed;
            
            projectList[1].BET__c = betRecord2.Id;
            projectList[1].IPM_Project_Name__c = 'TestP2';
            projectList[1].IPM_Project_Type__c = Rollout;
            projectList[1].IPM_GateKeeping_Model__c = RCLT;
            projectList[1].IPMProject_Span__c = Regional;
            projectList[1].IPM_Phase__c = MarketReady;
            projectList[1].IPM_CompanyCardText__c = GlobalCompanyCard;
            
            insert new List < IPM_Project__c > {
                projectList[0], projectList[1]
            };
            
            for (IPM_Milestone__c ipmMilestone: IPMsam1) {
                ipmMilestone.IPM_Due_Date__c = Date.today() - 365;
                ipmMilestone.IPM_Name__c = Math.random() + 'BETFirstRelease';
                ipmMilestone.IPM_Project__c = projectList[0].id;
                ipmMilestone.IPM_Type_of_Milestone__c = 'BET';
                ipmMilestone.IPM_Name__c = '1stBETFinalRelease11orBETFirstRelease';
                
            }
            insert  IPMsam1;
            
            for (IPM_Milestone__c ipmMilestone: IPMsam2) {
                ipmMilestone.IPM_Due_Date__c = Date.today() - 365;
                ipmMilestone.IPM_Name__c = Math.random() + 'BETFinalRelease';
                ipmMilestone.IPM_Project__c = projectList[1].id;
                
            } 
            
            insert IPMsam2;
            
            mapProjectBETMS.put(projectList[0].id, IPMsam1);
            mapProjectBETMS.put(projectList[1].id, IPMsam2);
            
            Test.startTest();
            IPM_BETHelper.updateBETMilestoneMissOnProject(mapProjectBETMS);
            Test.stopTest();
        }
        
        System.assertEquals([Select BET_First_Release_Missed__c, BET_Final_Release_Missed__c from IPM_project__c where id = : projectList[0].Id].BET_First_Release_Missed__c, true, 'Failed to update  BET Milestone passed checkbox');
        System.assertEquals([Select BET_First_Release_Missed__c, BET_Final_Release_Missed__c from IPM_project__c where id = : projectList[1].Id].BET_Final_Release_Missed__c, true, 'Failed to update  BET Milestone passed checkbox');

    }


    //test method for method to reset BET Milestone date missed alert 
    private static testmethod void testresetMilestoneMissedFlag() {
        
        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        
        test.loadData(IPM_Project_Type__c.sobjectType, IPM_ProjectType);
        test.loadData(IPM_BET_Search_Fields__c.sobjectType, IPM_BET_Search_Test);


        betRecord1.Status__c = FinalRelease;
        betRecord1.FinalReleaseDate__c = Date.Today() + 365;
        betRecord1.Name = 'TestBet3';



        betRecord2.Status__c = FirstRelease;
        betRecord2.FinalReleaseDate__c = Date.Today() + 365;
        betRecord2.Name = 'TestBet4';
        insert new List < uw_BET__c > {
            betRecord1, betRecord2
        };
        system.runAs(testRunningUser){
            projectList[0].BET__c = betRecord1.Id;
            projectList[0].IPM_Project_Name__c = 'Original-Global-RCLT-Market Read';
            projectList[0].IPM_Project_Type__c = Rollout;
            projectList[0].IPM_GateKeeping_Model__c = RCLT;
            projectList[0].IPMProject_Span__c = Regional;
            projectList[0].IPM_Phase__c = MarketReady;
            projectList[0].IPM_CompanyCardText__c = GlobalCompanyCard;
            
            
            projectList[1].BET__c = betRecord2.Id;
            projectList[1].IPM_Project_Name__c = 'TestP4';
            projectList[1].IPM_Project_Type__c = Rollout;
            projectList[1].IPM_GateKeeping_Model__c = RCLT;
            projectList[1].IPMProject_Span__c = Regional;
            projectList[1].IPM_Phase__c = MarketReady;
            projectList[1].IPM_CompanyCardText__c = GlobalCompanyCard;
            
            insert new List < IPM_Project__c > {
                projectList[0], projectList[1]
            };
            
            BET_BETWrapper betWrap1 = new BET_BETWrapper(betRecord1);
            BET_BETWrapper betWrap2 = new BET_BETWrapper(betRecord2);
            
            Test.startTest();
            IPM_BETHelper.resetMilestoneMissedFlag(betRecord1.id, betWrap1);
            IPM_BETHelper.resetMilestoneMissedFlag(betRecord2.id, betWrap2);
            Test.stopTest();
        }

        System.assertEquals([Select BET_First_Release_Missed__c from IPM_project__c where id = : projectList[0].Id].BET_First_Release_Missed__c, false, 'Failed to reset BET_First_Release_Missed__c');
        System.assertEquals([Select BET_Final_Release_Missed__c from IPM_project__c where id = : projectList[1].Id].BET_Final_Release_Missed__c, false, 'Failed to reset BET_Final_Release_Missed__c');

    }


    //Test method for setArchiveBET_IPM method

    private static testmethod void testsetArchiveBET_IPM() {
        
        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        
        betRecord1.Status__c = FinalRelease;
        betRecord1.FinalReleaseDate__c = Date.Today() + 365;
        betRecord1.Name = 'TestBet3';
        insert betRecord1;
        
        system.runAs(testRunningUser){
            projectList[0].BET__c = betRecord1.Id;
            projectList[0].IPM_Project_Name__c = 'TestP3';
            projectList[0].IPM_Phase__c = Feasibility;
            projectList[0].IPM_Project_Type__c = Rollout;
            projectList[0].IPM_GateKeeping_Model__c = RCLT;
            projectList[0].IPMProject_Span__c = Local;
            projectList[0].IPM_Phase__c = MarketReady;
            projectList[0].IPM_CompanyCardText__c = GlobalCompanyCard;
            projectList[0].IPM_Project_Job_Status__c = Completed;
            
            insert projectList[0];
            
            BET_BETWrapper betWrap1 = new BET_BETWrapper(betRecord1);
            
            Test.StartTest();
            IPM_BETHelper.setArchiveBET_IPM(betWrap1);
            Test.StopTest();
        }
        IPM_Project__c testRetrieveProj = [select id, BET_Archived_BET_Text__c, BET_Archive_Status__c, BET_Archived_BET__c from IPM_Project__c where bet__c = : betRecord1.id];

        system.assertEquals(testRetrieveProj.BET_Archived_BET__c, betRecord1.id, 'Failed to archieve');
        system.assertEquals(testRetrieveProj.BET_Archived_BET_Text__c, betRecord1.Name, 'Failed to archieve');
        system.assertEquals(testRetrieveProj.BET_Archive_Status__c, betRecord1.Status__c, 'Failed to archieve');

    }

    
    //test method for method to send Regional/Local Rollout Leaders' Access Request to BET after BET First Release    
    private static testmethod void testsendBETAccessRequestonFirstRelease() {
        
        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        test.loadData(IPM_Project_Type__c.sobjectType, IPM_ProjectType);
        test.loadData(IPM_BET_Search_Fields__c.sobjectType, IPM_BET_Search_Test);

        betRecord1.Status__c = FinalRelease;
        betRecord1.FinalReleaseDate__c = Date.Today() + 365;


        betRecord2.Status__c = FirstRelease;
        betRecord2.FinalReleaseDate__c = Date.Today() + 365;
        betRecord2.Name = 'TestBet5';

        insert new List < uw_BET__c > {
            betRecord1, betRecord2
        };
        
        IPM_Project_Resource__c PrjctResrc3 = IPM_TestFactory_Helper.createIPMProjectResource(projectList[2].id, false);
        IPM_Project_Resource__c PrjctResrc2 = IPM_TestFactory_Helper.createIPMProjectResource(projectList[1].id, false);  
        IPM_Project_Resource__c PrjctResrc1 = IPM_TestFactory_Helper.createIPMProjectResource(projectList[1].id, false);
        
        
        system.runAs(testRunningUser){
            projectList[0].BET__c = betRecord1.Id;
            projectList[0].IPM_Phase__c = Feasibility;
            projectList[0].IPM_Project_Type__c = Rollout;
            projectList[0].IPM_GateKeeping_Model__c = RCLT;
            projectList[0].IPMProject_Span__c = Local;
            projectList[0].IPM_Phase__c = MarketReady;
            projectList[0].IPM_CompanyCardText__c = GlobalCompanyCard;
            projectList[0].IPM_Project_Job_Status__c = Completed;
            
            insert projectList[0];
            
            projectList[1].BET__c = betRecord2.Id;
            projectList[1].IPM_Project_Name__c = 'TestP5';
            projectList[1].IPMProject_Span__c = Regional;
            projectList[1].IPM_Parent_Project__c = projectList[0].id;
            projectList[1].IPM_Project_Leader__c = UserInfo.getuserId();
            projectList[1].Deputy_Project_Leader__c = UserInfo.getuserId();
            
            insert projectList[1];
            
            projectList[2].BET__c = betRecord2.Id;
            projectList[2].IPM_Project_Name__c = 'TestP6';
            projectList[2].IPM_Parent_Project__c = projectList[1].id;
            projectList[2].IPM_Project_Type__c = Rollout;
            projectList[2].IPMProject_Span__c = Regional;
            projectList[2].IPM_Project_Leader__c = UserInfo.getuserId();
            projectList[2].Deputy_Project_Leader__c = UserInfo.getuserId();
            
            insert projectList[2];
            
            PrjctResrc1.IPM_User__c = UserInfo.getuserId();
            PrjctResrc1.IPM_Role_Type__c = 'BD';
            PrjctResrc1.IPM_Project__c = projectList[1].id;
            
            PrjctResrc2.IPM_User__c = UserInfo.getuserId();
            PrjctResrc2.IPM_Role_Type__c = 'CD';
            PrjctResrc2.IPM_Project__c = projectList[1].id;
            
            PrjctResrc3.IPM_User__c = UserInfo.getuserId();
            PrjctResrc3.IPM_Role_Type__c = 'CD';
            PrjctResrc3.IPM_Project__c = projectList[2].id;
            
            
            insert new List < IPM_Project_Resource__c > {
                PrjctResrc1, PrjctResrc2, PrjctResrc3};
            
            Test.StartTest();
            IPM_BETHelper.sendBETAccessRequestonFirstRelease(betRecord2.Id);
            Test.StopTest();
        }
        System.assertEquals([Select UserId__c from BET_Member_Request__c where Brand_Experience_Toolkit__c = : betRecord2.Id limit 1].UserId__c, PrjctResrc1.IPM_User__c, 'Failed to send Regional/Local Rollout Leader Access Request to BET');



    }

    //test method for method to send Regional/Local Rollout Leaders' Access Request to BET after BET First Release    
    private static testmethod void testsendBETAccessRequest() {
        
        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        test.loadData(IPM_Project_Type__c.sobjectType, IPM_ProjectType);
        test.loadData(IPM_BET_Search_Fields__c.sobjectType, IPM_BET_Search_Test);


        betRecord1 = BET_TestUtils.getTestBet();
        betRecord1.Status__c = FinalRelease;
        betRecord1.FinalReleaseDate__c = Date.Today() + 365;
        insert betRecord1;
        
        system.runAs(testRunningUser){
            projectList[0].BET__c = betRecord1.Id;
            projectList[0].IPM_Phase__c = Feasibility;
            projectList[0].IPM_Project_Type__c = Rollout;
            projectList[0].IPM_GateKeeping_Model__c = RCLT;
            projectList[0].IPMProject_Span__c = Local;
            projectList[0].IPM_Phase__c = MarketReady;
            projectList[0].IPM_CompanyCardText__c = GlobalCompanyCard;
            projectList[0].IPM_Project_Job_Status__c = Completed;
            
            insert projectList[0];
            
            Test.StartTest();
            IPM_BETHelper.sendBETAccessRequest(new list < id > {
                UserInfo.getUserId()
            }, betRecord1.id, projectList[0].id);
            Test.StopTest();
        }
        BET_Member_Request__c betMember = [Select Project_Id__c, Bet_owner__c from BET_Member_Request__c limit 1];
        system.assertEquals([Select Count() from BET_Member_Request__c limit 1000], 1, 'Failed to generate BET Member Request');
        system.assertEquals(betMember.Project_Id__c, projectList[0].ID, 'Failed to update project Id on BET Member');
        system.assertEquals(betMember.Bet_owner__c, [Select ownerId from uw_BET__c where id = : betRecord1.Id].ownerId, 'Failed to update BET owner');

    }


    //test method for sendRolloutMemberBETAccessRequest method  
    private static testmethod void testsendRolloutMemberBETAccessRequest() {

        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        test.loadData(IPM_Project_Type__c.sobjectType, IPM_ProjectType);
        test.loadData(IPM_BET_Search_Fields__c.sobjectType, IPM_BET_Search_Test);

        Map < id, set < IPM_Project_Resource__c >> mapProjResources = new Map < id, set < IPM_Project_Resource__c >> ();

        betRecord.Status__c = FinalRelease;
        betRecord.FinalReleaseDate__c = Date.Today() + 365;
        betRecord.Name = 'TestBet0';

        betRecord1.Status__c = FinalRelease;
        betRecord1.FinalReleaseDate__c = Date.Today() + 365;
        betRecord1.Name = 'TesttBet5';

        betRecord2.Status__c = FinalRelease;
        betRecord2.FinalReleaseDate__c = Date.Today() + 365;
        betRecord2.Name = 'TestttBet5';

        betRecord3.Status__c = FirstRelease;
        betRecord3.FinalReleaseDate__c = Date.Today() + 365;
        betRecord3.Name = 'TestBet5B';

        betRecord4.Status__c = FirstRelease;
        betRecord4.FinalReleaseDate__c = Date.Today() + 365;
        betRecord4.Name = 'TestBet5a';

        insert new List < uw_BET__c > {
            betRecord, betRecord1, betRecord2, betRecord3, betRecord4
        };
        
        
        
        system.runAs(testRunningUser){
            projectList[0].BET__c = betRecord1.Id;
            projectList[0].IPM_Project_Type__c = Rollout;
            projectList[0].IPMProject_Span__c = Regional;
            projectList[0].IPM_Project_Job_Status__c = Completed;
            projectList[0].IPM_Project_Name__c = 'TestPrj01';
            
            projectList[9].BET__c = betRecord4.Id;
            projectList[9].IPM_Project_Type__c = Rollout;
            projectList[9].IPMProject_Span__c = Regional;
            projectList[9].IPM_Project_Job_Status__c = Completed;
            projectList[9].IPM_Project_Name__c = 'TestPrj02';
            
            projectList[10].BET__c = betRecord.Id;
            projectList[10].IPM_Project_Type__c = Rollout;
            projectList[10].IPMProject_Span__c = Regional;
            projectList[10].IPM_Project_Job_Status__c = Completed;
            projectList[10].IPM_Project_Name__c = 'TestPrj0';
            
            insert new List < IPM_Project__c > {
                projectList[0], projectList[9], projectList[10]
            };
            
            projectList[1].BET__c = betRecord1.Id;
            projectList[1].IPM_Project_Name__c = 'TestP5';
            projectList[1].IPMProject_Span__c = Regional;
            projectList[1].IPM_Parent_Project__c = projectList[0].id;
            projectList[1].IPM_Project_Leader__c = UserInfo.getuserId();
            projectList[1].Deputy_Project_Leader__c = UserInfo.getuserId();
            projectList[1].IPM_Project_Type__c = Rollout;
            
            projectList[8].BET__c = betRecord.Id;
            projectList[8].IPM_Project_Type__c = Rollout;
            projectList[8].IPM_Parent_Project__c = projectList[9].id;
            projectList[8].IPMProject_Span__c = Regional;
            projectList[8].IPM_Project_Job_Status__c = Completed;
            projectList[8].IPM_Project_Name__c = 'TestPrj03';
            
            insert new List < IPM_Project__c > {
                projectList[1], projectList[8]
            };
            
            projectList[2].BET__c = betRecord2.Id;
            projectList[2].IPM_Project_Name__c = 'TestP6';
            projectList[2].IPM_Parent_Project__c = projectList[1].id;
            projectList[2].IPM_Project_Type__c = Rollout;
            projectList[2].IPMProject_Span__c = Regional;
            
            projectList[3].BET__c = betRecord1.Id;
            projectList[3].IPM_Project_Name__c = 'TestPrjD';
            projectList[3].IPM_Parent_Project__c = projectList[1].id;
            projectList[3].IPM_Project_Type__c = Rollout;
            projectList[3].IPMProject_Span__c = Regional;
            
            projectList[4].BET__c = betRecord1.Id;
            projectList[4].IPM_Project_Name__c = 'TestPrejE';
            projectList[4].IPM_Parent_Project__c = projectList[0].id;
            projectList[4].IPM_Project_Type__c = Rollout;
            projectList[4].IPMProject_Span__c = 'RegionalLocal';
            
            projectList[5].BET__c = betRecord3.Id;
            projectList[5].IPM_Project_Name__c = 'TestPryejP';
            projectList[5].IPM_Parent_Project__c = projectList[10].id;
            projectList[5].IPM_Project_Type__c = Rollout;
            projectList[5].IPMProject_Span__c = Local;
            projectList[5].IPM_Project_Leader__c=Userinfo.getUserId();
            
            projectList[6].BET__c = betRecord3.Id;
            projectList[6].IPM_Project_Name__c = 'TestPryej';
            projectList[6].IPM_Parent_Project__c = projectList[8].id;
            projectList[6].IPM_Project_Type__c = Rollout;
            projectList[6].IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            
            projectList[7].BET__c = betRecord3.Id;
            projectList[7].IPM_Parent_Project__c = projectList[8].id;
            projectList[7].IPM_Project_Type__c = Rollout;
            projectList[7].IPMProject_Span__c = Local;
            projectList[7].IPM_Project_Name__c = 'TestPryejJ';
            
            Test.starttest();
            
            insert new List < IPM_Project__c > {
                projectList[2], projectList[3], projectList[4], projectList[5], projectList[6], projectList[7]
            };
            
            IPM_Project_Resource__c PrjctResrc1 = new IPM_Project_Resource__c();
            PrjctResrc1.IPM_User__c = UserInfo.getuserId();
            PrjctResrc1.IPM_Role_Type__c = 'BD';
            PrjctResrc1.IPM_Project__c = projectList[5].id;

            IPM_Project_Resource__c PrjctResrc2 = new IPM_Project_Resource__c();
            PrjctResrc2.IPM_User__c = UserInfo.getuserId();
            PrjctResrc2.IPM_Role_Type__c = 'BD';
            PrjctResrc2.IPM_Project__c = projectList[2].id;


            IPM_Project_Resource__c PrjctResrc3 = new IPM_Project_Resource__c();
            PrjctResrc3.IPM_User__c = UserInfo.getuserId();
            PrjctResrc3.IPM_Role_Type__c = 'BD';
            PrjctResrc3.IPM_Project__c = projectList[1].id;


            IPM_Project_Resource__c PrjctResrc4 = new IPM_Project_Resource__c();
            PrjctResrc4.IPM_User__c = UserInfo.getuserId();
            PrjctResrc4.IPM_Role_Type__c = 'BD';
            PrjctResrc4.IPM_Project__c = projectList[0].id;

            IPM_Project_Resource__c PrjctResrc5 = new IPM_Project_Resource__c();
            PrjctResrc5.IPM_User__c = UserInfo.getuserId();
            PrjctResrc5.IPM_Role_Type__c = 'BD';
            PrjctResrc5.IPM_Project__c = projectList[3].id;
            
            
            insert new List < IPM_Project_Resource__c > {
                PrjctResrc1, PrjctResrc2, PrjctResrc3, PrjctResrc4, PrjctResrc5
            };
            
            test.stoptest();
            
            mapProjResources.put(projectList[1].id, new Set < IPM_Project_Resource__c > {
                PrjctResrc1, PrjctResrc4, PrjctResrc4
            });
            
            mapProjResources.put(projectList[2].id, new Set < IPM_Project_Resource__c > {
                PrjctResrc2, PrjctResrc3, PrjctResrc4
            });
            mapProjResources.put(projectList[3].id, new Set < IPM_Project_Resource__c > {
                PrjctResrc2, PrjctResrc3, PrjctResrc4, PrjctResrc5
            });
            mapProjResources.put(projectList[4].id, new Set < IPM_Project_Resource__c > {
                PrjctResrc2, PrjctResrc3, PrjctResrc4, PrjctResrc5
            });
            
            
            mapProjResources.put(projectList[5].id, new Set < IPM_Project_Resource__c > {
                PrjctResrc2, PrjctResrc3, PrjctResrc4, PrjctResrc5
            });
            mapProjResources.put(projectList[6].id, new Set < IPM_Project_Resource__c > {
                PrjctResrc2, PrjctResrc3, PrjctResrc4, PrjctResrc5
            });
            mapProjResources.put(projectList[7].id, new Set < IPM_Project_Resource__c > {
                PrjctResrc2, PrjctResrc3, PrjctResrc4, PrjctResrc5
            });
            
            
            
            
            IPM_BETHelper.sendRolloutMemberBETAccessRequest(mapProjResources);
            
            system.assertEquals([select UserId__c from BET_Member_Request__c where UserId__c =:projectList[5].IPM_Project_Leader__c  limit 1].UserId__c, PrjctResrc1.IPM_User__c, 'BET Access Request  not sent.');
            
        }             
        

    }

    //test method for method to update Phase of BET Final Release Milestone
    private static testmethod void testupdatePhaseBETMSFinalRelease() {
        
        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        test.loadData(IPM_Project_Type__c.sobjectType, IPM_ProjectType);
        test.loadData(IPM_BET_Search_Fields__c.sobjectType, IPM_BET_Search_Test);

        List < IPM_Milestone__c > IPMsam1 = IPM_TestFactory_Helper.createIPMMilestoneList(false, 2);


        betRecord1.Status__c = 'Unreleased';
        betRecord1.FinalReleaseDate__c = Date.Today() + 365;
        betRecord1.Name = 'TestBet1';
        insert betRecord1;

        system.runAs(testRunningUser){
            projectList[0].BET__c = betRecord1.Id;
            projectList[0].IPM_Project_Name__c = 'Operational-Global-Capability';
            projectList[0].IPM_Project_Type__c = 'Original';
            projectList[0].IPM_GateKeeping_Model__c = 'RCLT';
            projectList[0].IPMProject_Span__c = 'Regional';
            projectList[0].IPM_Phase__c = 'Ideas';
            projectList[0].IPM_CompanyCardText__c = 'Regional Company Card';
            projectList[0].IPM_Project_Job_Status__c = Completed;
            insert projectList[0];
            
            
            for (IPM_Milestone__c ipmMilestone: IPMsam1) {
                ipmMilestone.IPM_Due_Date__c = Date.today() - 365;
                ipmMilestone.IPM_Name__c = Math.random() + 'BETFirstRelease';
                ipmMilestone.IPM_Project__c = projectList[0].id;
                ipmMilestone.IPM_Type_of_Milestone__c = IPM_ConstantUtils.STRING_BET;
                ipmMilestone.IPM_Name__c = '1stBETFinalRelease11orBETFirstRelease' + IPM_ConstantUtils.BET_MS_FINAL_RELEASE;
                ipmMilestone.IPM_Phase__c = null;
            }
            insert IPMsam1;
            
            Test.StartTest();
            
            IPM_BETHelper.updatePhaseBETMSFinalRelease(betRecord1.Id);
            Test.StopTest();
        }
        System.assertEquals([Select IPM_Phase__c from IPM_Milestone__c where Id = : IPMsam1[0].id OR Id = : IPMsam1[1].id limit 1].IPM_Phase__c, null, 'Failed to update milestone phase');
    }



    //testmethod for method to send updates to BET on Project update in IPM
    private static testmethod void testsendIPMupdatetoBET() {
        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        
        betRecord1.Status__c = FinalRelease;
        betRecord1.FinalReleaseDate__c = Date.Today() + 365;
        betRecord1.Launch_Date__c = Date.Today() + 30;
        
        System.runAs(testRunningUser){
            insert betRecord1;
            
            projectList[0].BET__c = betRecord1.Id;
            projectList[0].IPM_Target_Launch_Dates__c = Date.Today();
            projectList[0].IPM_Phase__c = Feasibility;
            projectList[0].IPM_Project_Type__c = Rollout;
            projectList[0].IPM_GateKeeping_Model__c = RCLT;
            projectList[0].IPMProject_Span__c = Local;
            projectList[0].IPM_Phase__c = MarketReady;
            projectList[0].IPM_CompanyCardText__c = GlobalCompanyCard;
            projectList[0].IPM_Project_Job_Status__c = Completed;
            
            
            projectList[1].BET__c = betRecord1.Id;
            projectList[1].IPM_Target_Launch_Dates__c = Date.Today() + 20;
            projectList[1].IPM_Project_Name__c = 'TestPi';
            projectList[1].IPM_Phase__c = Feasibility;
            projectList[1].IPM_Project_Type__c = Rollout;
            projectList[1].IPM_GateKeeping_Model__c = RCLT;
            projectList[1].IPMProject_Span__c = Local;
            projectList[1].IPM_Phase__c = MarketReady;
            projectList[1].IPM_CompanyCardText__c = GlobalCompanyCard;
            projectList[1].IPM_Project_Job_Status__c = Completed;
            projectList[1].IPM_Global_ProjectId__c = ' ';
            
            insert new List < IPM_Project__c > {
                projectList[0], projectList[1]
            };

            
            betRecord1.IPM_Project__c = projectList[0].id;
            update betRecord1;
            
            Test.StartTest();
            IPM_BETHelper.sendIPMupdatetoBET(new List < IPM_Project__c > {
                projectList[0]
            }, new List < IPM_Project__c > {
                projectList[1]
            });
            Test.StopTest();
            
            System.assertEquals([Select Launch_Date__c from uw_BET__c where id = : projectList[0].BET__c].Launch_Date__c, projectList[0].IPM_Target_Launch_Dates__c, 'Failed to send updates to BET on Project update in IPM');
        } 
    }
}