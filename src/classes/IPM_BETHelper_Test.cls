@istest
class IPM_BETHelper_Test {

    static IPM_Project__c project1  = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c project2  = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c project3  = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c project4  = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c project5  = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c project6  = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c project7  = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c project8  = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c project9  = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c project10 = IPM_TestFactory_Helper.createIPMProject(false);
    static IPM_Project__c project11 = IPM_TestFactory_Helper.createIPMProject(false);
    
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
    
    private static User stdUserForBET;
    
    @testSetup static void setUpData(){
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            stdUserForBET = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }   
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
            project1.BET__c = betRecord1.Id;
            project1.IPM_Phase__c = Feasibility;
            project1.IPM_Project_Type__c = Rollout;
            project1.IPM_GateKeeping_Model__c = RCLT;
            project1.IPMProject_Span__c = Local;
            project1.IPM_Phase__c = MarketReady;
            project1.IPM_CompanyCardText__c = GlobalCompanyCard;
            project1.IPM_Project_Job_Status__c = Completed;
            project1.IPM_Target_Launch_Dates__c = Date.Today();
    
    
            project2.IPM_Project_Name__c = 'TestPr';
            project2.IPM_Project_Type__c = Rollout;
            project2.IPM_GateKeeping_Model__c = RCLT;
            project2.IPMProject_Span__c = Regional;
            project2.IPM_Phase__c = MarketReady;
            project2.IPM_CompanyCardText__c = GlobalCompanyCard;
            project2.IPM_Global_ProjectId__c = ' ';
    
            insert new List < IPM_Project__c > {
                project1, project2
            };
    
            Map < string, ipm_project__c > mapProjBET = new Map < string, ipm_project__c > ();
    
            mapProjBET.put(project1.id, project1);
            mapProjBET.put(project2.id, project2);
    
            Test.StartTest();
            IPM_BETHelper.updateBETmilestones(mapProjBET);
            Test.StopTest();
        }
        system.assertEquals([Select First_Release_Due_Date__c from uw_BET__c where id = : betRecord1.id].First_Release_Due_Date__c, [Select IPM_Due_Date__c from IPM_Milestone__c where IPM_Project__c = : project1.id limit 1].IPM_Due_Date__c, 'BET Milestones DueDate updation failed ');
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
            project1.BET__c = betRecord1.Id;
            project1.IPM_Project_Name__c = 'TestP1';
            project1.IPM_Phase__c = Feasibility;
            project1.IPM_Project_Type__c = Rollout;
            project1.IPM_GateKeeping_Model__c = RCLT;
            project1.IPMProject_Span__c = Local;
            project1.IPM_Phase__c = MarketReady;
            project1.IPM_CompanyCardText__c = GlobalCompanyCard;
            project1.IPM_Project_Job_Status__c = Completed;
    
            project2.BET__c = betRecord2.Id;
            project2.IPM_Project_Name__c = 'TestP2';
            project2.IPM_Project_Type__c = Rollout;
            project2.IPM_GateKeeping_Model__c = RCLT;
            project2.IPMProject_Span__c = Regional;
            project2.IPM_Phase__c = MarketReady;
            project2.IPM_CompanyCardText__c = GlobalCompanyCard;
    
            insert new List < IPM_Project__c > {
                project1, project2
            };
    
            for (IPM_Milestone__c ipmMilestone: IPMsam1) {
                ipmMilestone.IPM_Due_Date__c = Date.today() - 365;
                ipmMilestone.IPM_Name__c = Math.random() + 'BETFirstRelease';
                ipmMilestone.IPM_Project__c = project1.id;
                ipmMilestone.IPM_Type_of_Milestone__c = 'BET';
                ipmMilestone.IPM_Name__c = '1stBETFinalRelease11orBETFirstRelease';
    
            }
            insert  IPMsam1;
    
            for (IPM_Milestone__c ipmMilestone: IPMsam2) {
                ipmMilestone.IPM_Due_Date__c = Date.today() - 365;
                ipmMilestone.IPM_Name__c = Math.random() + 'BETFinalRelease';
                ipmMilestone.IPM_Project__c = project2.id;
    
            } 
    
            insert IPMsam2;
            
            mapProjectBETMS.put(project1.id, IPMsam1);
            mapProjectBETMS.put(project2.id, IPMsam2);
    
            Test.startTest();
            IPM_BETHelper.updateBETMilestoneMissOnProject(mapProjectBETMS);
            Test.stopTest();
        }
        
        System.assertEquals([Select BET_First_Release_Missed__c, BET_Final_Release_Missed__c from IPM_project__c where id = : project1.Id].BET_First_Release_Missed__c, true, 'Failed to update  BET Milestone passed checkbox');
        System.assertEquals([Select BET_First_Release_Missed__c, BET_Final_Release_Missed__c from IPM_project__c where id = : project2.Id].BET_Final_Release_Missed__c, true, 'Failed to update  BET Milestone passed checkbox');

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
            project1.BET__c = betRecord1.Id;
            project1.IPM_Project_Name__c = 'Original-Global-RCLT-Market Read';
            project1.IPM_Project_Type__c = Rollout;
            project1.IPM_GateKeeping_Model__c = RCLT;
            project1.IPMProject_Span__c = Regional;
            project1.IPM_Phase__c = MarketReady;
            project1.IPM_CompanyCardText__c = GlobalCompanyCard;
    
    
            project2.BET__c = betRecord2.Id;
            project2.IPM_Project_Name__c = 'TestP4';
            project2.IPM_Project_Type__c = Rollout;
            project2.IPM_GateKeeping_Model__c = RCLT;
            project2.IPMProject_Span__c = Regional;
            project2.IPM_Phase__c = MarketReady;
            project2.IPM_CompanyCardText__c = GlobalCompanyCard;
    
            insert new List < IPM_Project__c > {
                project1, project2
            };
    
            BET_BETWrapper betWrap1 = new BET_BETWrapper(betRecord1);
            BET_BETWrapper betWrap2 = new BET_BETWrapper(betRecord2);
    
            Test.startTest();
            IPM_BETHelper.resetMilestoneMissedFlag(betRecord1.id, betWrap1);
            IPM_BETHelper.resetMilestoneMissedFlag(betRecord2.id, betWrap2);
            Test.stopTest();
        }

        System.assertEquals([Select BET_First_Release_Missed__c from IPM_project__c where id = : project1.Id].BET_First_Release_Missed__c, false, 'Failed to reset BET_First_Release_Missed__c');
        System.assertEquals([Select BET_Final_Release_Missed__c from IPM_project__c where id = : project2.Id].BET_Final_Release_Missed__c, false, 'Failed to reset BET_Final_Release_Missed__c');

    }


    //Test method for setArchiveBET_IPM method

    private static testmethod void testsetArchiveBET_IPM() {
        
        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        
        betRecord1.Status__c = FinalRelease;
        betRecord1.FinalReleaseDate__c = Date.Today() + 365;
        betRecord1.Name = 'TestBet3';
        insert betRecord1;
        
        system.runAs(testRunningUser){
            project1.BET__c = betRecord1.Id;
            project1.IPM_Project_Name__c = 'TestP3';
            project1.IPM_Phase__c = Feasibility;
            project1.IPM_Project_Type__c = Rollout;
            project1.IPM_GateKeeping_Model__c = RCLT;
            project1.IPMProject_Span__c = Local;
            project1.IPM_Phase__c = MarketReady;
            project1.IPM_CompanyCardText__c = GlobalCompanyCard;
            project1.IPM_Project_Job_Status__c = Completed;
    
            insert project1;
    
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
        
        IPM_Project_Resource__c PrjctResrc3 = IPM_TestFactory_Helper.createIPMProjectResource(project3.id, false);
        IPM_Project_Resource__c PrjctResrc2 = IPM_TestFactory_Helper.createIPMProjectResource(project2.id, false);  
        IPM_Project_Resource__c PrjctResrc1 = IPM_TestFactory_Helper.createIPMProjectResource(project2.id, false);
        
        
        system.runAs(testRunningUser){
            project1.BET__c = betRecord1.Id;
            project1.IPM_Phase__c = Feasibility;
            project1.IPM_Project_Type__c = Rollout;
            project1.IPM_GateKeeping_Model__c = RCLT;
            project1.IPMProject_Span__c = Local;
            project1.IPM_Phase__c = MarketReady;
            project1.IPM_CompanyCardText__c = GlobalCompanyCard;
            project1.IPM_Project_Job_Status__c = Completed;
    
            insert project1;
    
            project2.BET__c = betRecord2.Id;
            project2.IPM_Project_Name__c = 'TestP5';
            project2.IPMProject_Span__c = Regional;
            project2.IPM_Parent_Project__c = project1.id;
            project2.IPM_Project_Leader__c = UserInfo.getuserId();
            project2.Deputy_Project_Leader__c = UserInfo.getuserId();
    
            insert project2;
    
            project3.BET__c = betRecord2.Id;
            project3.IPM_Project_Name__c = 'TestP6';
            project3.IPM_Parent_Project__c = project2.id;
            project3.IPM_Project_Type__c = Rollout;
            project3.IPMProject_Span__c = Regional;
            project3.IPM_Project_Leader__c = UserInfo.getuserId();
            project3.Deputy_Project_Leader__c = UserInfo.getuserId();
    
            insert project3;
            
            PrjctResrc1.IPM_User__c = UserInfo.getuserId();
            PrjctResrc1.IPM_Role_Type__c = 'BD';
            PrjctResrc1.IPM_Project__c = project2.id;
            
            PrjctResrc2.IPM_User__c = UserInfo.getuserId();
            PrjctResrc2.IPM_Role_Type__c = 'CD';
            PrjctResrc2.IPM_Project__c = project2.id;
    
            PrjctResrc3.IPM_User__c = UserInfo.getuserId();
            PrjctResrc3.IPM_Role_Type__c = 'CD';
            PrjctResrc3.IPM_Project__c = project3.id;
    
    
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
                project1.BET__c = betRecord1.Id;
                project1.IPM_Phase__c = Feasibility;
                project1.IPM_Project_Type__c = Rollout;
                project1.IPM_GateKeeping_Model__c = RCLT;
                project1.IPMProject_Span__c = Local;
                project1.IPM_Phase__c = MarketReady;
                project1.IPM_CompanyCardText__c = GlobalCompanyCard;
                project1.IPM_Project_Job_Status__c = Completed;
    
                insert project1;
    
                Test.StartTest();
                IPM_BETHelper.sendBETAccessRequest(new list < id > {
                    UserInfo.getUserId()
                }, betRecord1.id, project1.id);
                Test.StopTest();
            }
            BET_Member_Request__c betMember = [Select Project_Id__c, Bet_owner__c from BET_Member_Request__c limit 1];
            system.assertEquals([Select Count() from BET_Member_Request__c limit 1000], 1, 'Failed to generate BET Member Request');
            system.assertEquals(betMember.Project_Id__c, project1.ID, 'Failed to update project Id on BET Member');
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
            
            
           /** IPM_Project_Resource__c PrjctResrc1 = new IPM_Project_Resource__c();
            PrjctResrc1.IPM_User__c = UserInfo.getuserId();
            PrjctResrc1.IPM_Role_Type__c = 'BD';
            PrjctResrc1.IPM_Project__c = project6.id;

            IPM_Project_Resource__c PrjctResrc2 = new IPM_Project_Resource__c();
            PrjctResrc2.IPM_User__c = UserInfo.getuserId();
            PrjctResrc2.IPM_Role_Type__c = 'BD';
            PrjctResrc2.IPM_Project__c = project3.id;


            IPM_Project_Resource__c PrjctResrc3 = new IPM_Project_Resource__c();
            PrjctResrc3.IPM_User__c = UserInfo.getuserId();
            PrjctResrc3.IPM_Role_Type__c = 'BD';
            PrjctResrc3.IPM_Project__c = project2.id;


            IPM_Project_Resource__c PrjctResrc4 = new IPM_Project_Resource__c();
            PrjctResrc4.IPM_User__c = UserInfo.getuserId();
            PrjctResrc4.IPM_Role_Type__c = 'BD';
            PrjctResrc4.IPM_Project__c = project1.id;

            IPM_Project_Resource__c PrjctResrc5 = new IPM_Project_Resource__c();
            PrjctResrc5.IPM_User__c = UserInfo.getuserId();
            PrjctResrc5.IPM_Role_Type__c = 'BD';
            PrjctResrc5.IPM_Project__c = project4.id; **/
            
            system.runAs(testRunningUser){
                project1.BET__c = betRecord1.Id;
                project1.IPM_Project_Type__c = Rollout;
                project1.IPMProject_Span__c = Regional;
                project1.IPM_Project_Job_Status__c = Completed;
                project1.IPM_Project_Name__c = 'TestPrj01';
    
                project10.BET__c = betRecord4.Id;
                project10.IPM_Project_Type__c = Rollout;
                project10.IPMProject_Span__c = Regional;
                project10.IPM_Project_Job_Status__c = Completed;
                project10.IPM_Project_Name__c = 'TestPrj02';
    
                project11.BET__c = betRecord.Id;
                project11.IPM_Project_Type__c = Rollout;
                project11.IPMProject_Span__c = Regional;
                project11.IPM_Project_Job_Status__c = Completed;
                project11.IPM_Project_Name__c = 'TestPrj0';
    
                insert new List < IPM_Project__c > {
                    project1, project10, project11
                };
    
                project2.BET__c = betRecord1.Id;
                project2.IPM_Project_Name__c = 'TestP5';
                project2.IPMProject_Span__c = Regional;
                project2.IPM_Parent_Project__c = project1.id;
                project2.IPM_Project_Leader__c = UserInfo.getuserId();
                project2.Deputy_Project_Leader__c = UserInfo.getuserId();
                project2.IPM_Project_Type__c = Rollout;
    
                project9.BET__c = betRecord.Id;
                project9.IPM_Project_Type__c = Rollout;
                project9.IPM_Parent_Project__c = project10.id;
                project9.IPMProject_Span__c = Regional;
                project9.IPM_Project_Job_Status__c = Completed;
                project9.IPM_Project_Name__c = 'TestPrj03';
    
                insert new List < IPM_Project__c > {
                    project2, project9
                };
    
                project3.BET__c = betRecord2.Id;
                project3.IPM_Project_Name__c = 'TestP6';
                project3.IPM_Parent_Project__c = project2.id;
                project3.IPM_Project_Type__c = Rollout;
                project3.IPMProject_Span__c = Regional;
    
                project4.BET__c = betRecord1.Id;
                project4.IPM_Project_Name__c = 'TestPrjD';
                project4.IPM_Parent_Project__c = project2.id;
                project4.IPM_Project_Type__c = Rollout;
                project4.IPMProject_Span__c = Regional;
    
                project5.BET__c = betRecord1.Id;
                project5.IPM_Project_Name__c = 'TestPrejE';
                project5.IPM_Parent_Project__c = project1.id;
                project5.IPM_Project_Type__c = Rollout;
                project5.IPMProject_Span__c = 'RegionalLocal';
    
                project6.BET__c = betRecord3.Id;
                project6.IPM_Project_Name__c = 'TestPryejP';
                project6.IPM_Parent_Project__c = project11.id;
                project6.IPM_Project_Type__c = Rollout;
                project6.IPMProject_Span__c = Local;
    
                project7.BET__c = betRecord3.Id;
                project7.IPM_Project_Name__c = 'TestPryej';
                project7.IPM_Parent_Project__c = project9.id;
                project7.IPM_Project_Type__c = Rollout;
                project7.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
    
                project8.BET__c = betRecord3.Id;
                project8.IPM_Parent_Project__c = project9.id;
                project8.IPM_Project_Type__c = Rollout;
                project8.IPMProject_Span__c = Local;
                project8.IPM_Project_Name__c = 'TestPryejJ';
    
                Test.starttest();
                
                insert new List < IPM_Project__c > {
                    project3, project4, project5, project6, project7, project8
                };
    
    IPM_Project_Resource__c PrjctResrc1 = new IPM_Project_Resource__c();
            PrjctResrc1.IPM_User__c = UserInfo.getuserId();
            PrjctResrc1.IPM_Role_Type__c = 'BD';
            PrjctResrc1.IPM_Project__c = project6.id;

            IPM_Project_Resource__c PrjctResrc2 = new IPM_Project_Resource__c();
            PrjctResrc2.IPM_User__c = UserInfo.getuserId();
            PrjctResrc2.IPM_Role_Type__c = 'BD';
            PrjctResrc2.IPM_Project__c = project3.id;


            IPM_Project_Resource__c PrjctResrc3 = new IPM_Project_Resource__c();
            PrjctResrc3.IPM_User__c = UserInfo.getuserId();
            PrjctResrc3.IPM_Role_Type__c = 'BD';
            PrjctResrc3.IPM_Project__c = project2.id;


            IPM_Project_Resource__c PrjctResrc4 = new IPM_Project_Resource__c();
            PrjctResrc4.IPM_User__c = UserInfo.getuserId();
            PrjctResrc4.IPM_Role_Type__c = 'BD';
            PrjctResrc4.IPM_Project__c = project1.id;

            IPM_Project_Resource__c PrjctResrc5 = new IPM_Project_Resource__c();
            PrjctResrc5.IPM_User__c = UserInfo.getuserId();
            PrjctResrc5.IPM_Role_Type__c = 'BD';
            PrjctResrc5.IPM_Project__c = project4.id;
    
    
                insert new List < IPM_Project_Resource__c > {
                    PrjctResrc1, PrjctResrc2, PrjctResrc3, PrjctResrc4, PrjctResrc5
                };
    
                test.stoptest();
    
                mapProjResources.put(project2.id, new Set < IPM_Project_Resource__c > {
                    PrjctResrc1, PrjctResrc4, PrjctResrc4
                });
    
                mapProjResources.put(project3.id, new Set < IPM_Project_Resource__c > {
                    PrjctResrc2, PrjctResrc3, PrjctResrc4
                });
                mapProjResources.put(project4.id, new Set < IPM_Project_Resource__c > {
                    PrjctResrc2, PrjctResrc3, PrjctResrc4, PrjctResrc5
                });
                mapProjResources.put(project5.id, new Set < IPM_Project_Resource__c > {
                    PrjctResrc2, PrjctResrc3, PrjctResrc4, PrjctResrc5
                });
    
    
                mapProjResources.put(project6.id, new Set < IPM_Project_Resource__c > {
                    PrjctResrc2, PrjctResrc3, PrjctResrc4, PrjctResrc5
                });
                mapProjResources.put(project7.id, new Set < IPM_Project_Resource__c > {
                    PrjctResrc2, PrjctResrc3, PrjctResrc4, PrjctResrc5
                });
                mapProjResources.put(project8.id, new Set < IPM_Project_Resource__c > {
                    PrjctResrc2, PrjctResrc3, PrjctResrc4, PrjctResrc5
                });
    
    
    
                
                IPM_BETHelper.sendRolloutMemberBETAccessRequest(mapProjResources);
                 system.assertEquals([select UserId__c from BET_Member_Request__c limit 1].UserId__c, PrjctResrc4.IPM_User__c, 'BET Access Request  not sent.');
            }             
            //system.assertEquals([select UserId__c from BET_Member_Request__c limit 1].UserId__c, PrjctResrc4.IPM_User__c, 'BET Access Request  not sent.');

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
                project1.BET__c = betRecord1.Id;
                project1.IPM_Project_Name__c = 'Operational-Global-Capability';
                project1.IPM_Project_Type__c = 'Original';
                project1.IPM_GateKeeping_Model__c = 'RCLT';
                project1.IPMProject_Span__c = 'Regional';
                project1.IPM_Phase__c = 'Ideas';
                project1.IPM_CompanyCardText__c = 'Regional Company Card';
                project1.IPM_Project_Job_Status__c = Completed;
                insert project1;
    
    
                for (IPM_Milestone__c ipmMilestone: IPMsam1) {
                    ipmMilestone.IPM_Due_Date__c = Date.today() - 365;
                    ipmMilestone.IPM_Name__c = Math.random() + 'BETFirstRelease';
                    ipmMilestone.IPM_Project__c = project1.id;
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
            insert betRecord1;
            
            System.runAs(testRunningUser){
                project1.BET__c = betRecord1.Id;
                project1.IPM_Target_Launch_Dates__c = Date.Today();
                project1.IPM_Phase__c = Feasibility;
                project1.IPM_Project_Type__c = Rollout;
                project1.IPM_GateKeeping_Model__c = RCLT;
                project1.IPMProject_Span__c = Local;
                project1.IPM_Phase__c = MarketReady;
                project1.IPM_CompanyCardText__c = GlobalCompanyCard;
                project1.IPM_Project_Job_Status__c = Completed;
    
    
                project2.BET__c = betRecord1.Id;
                project2.IPM_Target_Launch_Dates__c = Date.Today() + 20;
                project2.IPM_Project_Name__c = 'TestPi';
                project2.IPM_Phase__c = Feasibility;
                project2.IPM_Project_Type__c = Rollout;
                project2.IPM_GateKeeping_Model__c = RCLT;
                project2.IPMProject_Span__c = Local;
                project2.IPM_Phase__c = MarketReady;
                project2.IPM_CompanyCardText__c = GlobalCompanyCard;
                project2.IPM_Project_Job_Status__c = Completed;
                project2.IPM_Global_ProjectId__c = ' ';
    
                insert new List < IPM_Project__c > {
                    project1, project2
                };
            }
            
                betRecord1.IPM_Project__c = project1.id;
                update betRecord1;
    
                Test.StartTest();
                IPM_BETHelper.sendIPMupdatetoBET(new List < IPM_Project__c > {
                    project1
                }, new List < IPM_Project__c > {
                    project2
                });
                Test.StopTest();
            
            System.assertEquals([Select Launch_Date__c from uw_BET__c where id = : project1.BET__c].Launch_Date__c, project1.IPM_Target_Launch_Dates__c, 'Failed to send updates to BET on Project update in IPM');

        }

    }