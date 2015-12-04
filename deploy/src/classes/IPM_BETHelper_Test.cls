@istest
class IPM_BETHelper_Test {
    Static String Feasibility  = IPM_ConstantUtils.PHASE_FEASIBILITY;
    Static String Rollout =  IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
    Static String RCLT =  IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
    Static String Local =  IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
    Static String MarketReady =  IPM_ConstantUtils.PHASE_MARKET_READY;
    Static String GlobalCompanyCard =  IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
    Static String Completed =  IPM_ConstantUtils.JOB_STATUS_COMPLETED;
    Static String Regional =  IPM_ConstantUtils.COMPANY_CARD_REGIONAL;
    Static String FirstRelease =  IPM_ConstantUtils.BET_FIRST_RELEASE;
    Static String Unreleased =  IPM_ConstantUtils.BET_UNRELEASED;
    Static String IPM_ProjectType =  'IPM_ProjectType';
    Static String IPM_BET_Search_Test =  'IPM_BET_Search_Test';
    Static String FinalRelease =  'Final Release';
    
    private static User stdUserForBET;// Variable has been used in Setup data method 
    
    @testSetup static void setUpDataResource(){
        
        //Load Project Type only if it has not been loaded already
        list<IPM_Project_Type__c> lstProjType = IPM_Project_Type__c.getAll().values();
        if(lstProjType==null || (lstProjType!=null && !lstProjType.isEmpty())){
            test.loadData(IPM_Project_Type__c.sobjectType, IPM_ProjectType);
        }
        list<IPM_BET_Search_Fields__c> lstSearchFields = IPM_BET_Search_Fields__c.getAll().values();
        //Load search fields only if it has not been already loaded.
        if(lstSearchFields==null || (lstSearchFields!=null && !lstSearchFields.isEmpty())){
            test.loadData(IPM_BET_Search_Fields__c.sobjectType, IPM_BET_Search_Test);
        }
        
        List<IPM_Project__c> projectList=IPM_TestFactory_Helper.createIPMProjectList(false,4);

        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // User has to be created as a  system admin 
            stdUserForBET = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
            stdUserForBET.email='testUser@unilever.com';
            update  stdUserForBET;
        } 
        System.runAs(stdUserForBET)
        {
            
            Test.starttest();
            
            uw_BET__c betRecord1=BET_TestUtils.getTestBet();
            betRecord1.name='BET1';
            betRecord1.Status__c =Unreleased;
            uw_BET__c betRecord2 =BET_TestUtils.getTestBet();
            betRecord2.name='BET2';
            betRecord2.Status__c = FirstRelease;
            insert new List<uw_BET__c>{betRecord1,betRecord2};
            
            IPM_Project__c parentProj  = projectList[3];
            insert parentProj ;
            System.assert(parentProj.id!=null,'Failed to insert Parent Project');
            
            projectList[0].BET__c = betRecord1.Id;
            projectList[0].IPM_Project_Name__c = 'TestResourceProj0';
            projectList[0].IPM_Phase__c = Feasibility;
            projectList[0].IPM_Project_Type__c = Rollout;
            projectList[0].IPM_GateKeeping_Model__c = RCLT;
            projectList[0].IPMProject_Span__c = Local;
            projectList[0].IPM_Phase__c = MarketReady;
            projectList[0].IPM_CompanyCardText__c = GlobalCompanyCard;
            projectList[0].IPM_Project_Job_Status__c = Completed;
            projectList[0].IPM_Parent_Project__c = parentProj.id;
            
            insert projectList[0];
            
            projectList[1].BET__c = betRecord2.Id;
            projectList[1].IPM_Project_Name__c = 'TestResourceProj1';
            projectList[1].IPMProject_Span__c = Regional;
            projectList[1].IPM_Parent_Project__c = projectList[0].id;
            projectList[1].IPM_Project_Leader__c = UserInfo.getuserId();
            projectList[1].Deputy_Project_Leader__c = UserInfo.getuserId();

            insert projectList[1];
            
            projectList[2].BET__c = betRecord2.Id;
            projectList[2].IPM_Project_Name__c = 'TestResourceProj2';
            projectList[2].IPM_Parent_Project__c = projectList[1].id;
            projectList[2].IPM_Project_Type__c = Rollout;
            projectList[2].IPMProject_Span__c = Regional;
            projectList[2].IPM_Project_Leader__c = UserInfo.getuserId();
            projectList[2].Deputy_Project_Leader__c = UserInfo.getuserId();
            
            insert projectList[2];
            
            IPM_Project_Resource__c PrjctResrc3 = IPM_TestFactory_Helper.createIPMProjectResource(projectList[2].id, false);
            IPM_Project_Resource__c PrjctResrc2 = IPM_TestFactory_Helper.createIPMProjectResource(projectList[1].id, false);  
            IPM_Project_Resource__c PrjctResrc1 = IPM_TestFactory_Helper.createIPMProjectResource(projectList[1].id, false);
            
            PrjctResrc1.IPM_User__c = UserInfo.getuserId();
            PrjctResrc1.IPM_Role_Type__c = 'BD';
            
            PrjctResrc2.IPM_User__c = UserInfo.getuserId();
            PrjctResrc2.IPM_Role_Type__c = 'CD';
            
            PrjctResrc3.IPM_User__c = UserInfo.getuserId();
            PrjctResrc3.IPM_Role_Type__c = 'CD';
            

            insert new List < IPM_Project_Resource__c > {
                PrjctResrc1, PrjctResrc2, PrjctResrc3};
            
            Test.stoptest();
            
        }
        
    }
    
    @testSetup static void setUpData(){
    
        List<IPM_Project__c> projectList=IPM_TestFactory_Helper.createIPMProjectList(false,12); 
        list<IPM_BET_Search_Fields__c> lstSearchFields = IPM_BET_Search_Fields__c.getAll().values();
        //Load search fields only if it has not been already loaded.
        if(lstSearchFields==null || (lstSearchFields!=null && !lstSearchFields.isEmpty())){
            test.loadData(IPM_BET_Search_Fields__c.sobjectType, IPM_BET_Search_Test);
        }
        
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // User has to be created as a system admin 
            stdUserForBET = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
        } 
        
        System.runAs(stdUserForBET)
        { 
            List<uw_BET__c> betRecordList =new List<uw_BET__c>(); 
            
            for(Integer i=0;i<5;i++){
                uw_BET__c betRecord  = BET_TestUtils.getTestBet();
                betRecord.Status__c = FinalRelease;
                betRecord.FinalReleaseDate__c = Date.Today() + 365;
                betRecord.First_Release_Due_Date__c = Date.Today();
                betRecord.Name = 'TestBet'+i;
                betRecordList.add(betRecord);
                
            }
            
            insert betRecordList;
            
            system.assertEquals(betRecordList.size(),5,'BETs are not created');
            
            uw_BET__c betRecord0 =[Select id,name,Status__c,FinalReleaseDate__c,Final_Release_Due_Date__c,FirstReleaseDate__c,First_Release_Due_Date__c,Is_Archived__c,OwnerId,Category_Group__c,Product_Category__c,Brand_Position__c,Product_Brand__c from uw_BET__c where name='TestBet0' limit 1];
            
            uw_BET__c betRecord1 =[Select id,name,Status__c,FinalReleaseDate__c,Final_Release_Due_Date__c,FirstReleaseDate__c,First_Release_Due_Date__c,Is_Archived__c,OwnerId,Category_Group__c,Product_Category__c,Brand_Position__c,Product_Brand__c from uw_BET__c where name='TestBet1' limit 1];
            
            uw_BET__c betRecord2 =[Select id,name,Status__c,FinalReleaseDate__c,Final_Release_Due_Date__c,FirstReleaseDate__c,First_Release_Due_Date__c,Is_Archived__c,OwnerId,Category_Group__c,Product_Category__c,Brand_Position__c,Product_Brand__c from uw_BET__c where name='TestBet2' limit 1];
            
            uw_BET__c betRecord3 =[Select id,name,Status__c,FinalReleaseDate__c,Final_Release_Due_Date__c,FirstReleaseDate__c,First_Release_Due_Date__c,Is_Archived__c,OwnerId,Category_Group__c,Product_Category__c,Brand_Position__c,Product_Brand__c from uw_BET__c where name='TestBet3' limit 1];
            betRecord3.Status__c = FirstRelease;
            
            uw_BET__c betRecord4 =[Select id,name,Status__c,FinalReleaseDate__c,Final_Release_Due_Date__c,FirstReleaseDate__c,First_Release_Due_Date__c,Is_Archived__c,OwnerId,Category_Group__c,Product_Category__c,Brand_Position__c,Product_Brand__c from uw_BET__c where name='TestBet4' limit 1];
            betRecord4.Status__c = FirstRelease;
            
            update new List<uw_BET__c> {betRecord3,betRecord4};
            
            IPM_Project__c parentProj  = projectList[11];
            parentProj.IPM_Project_Name__c = 'TestParentProj';
            insert parentProj ;
            system.assert(parentProj.id!=null,'Failed to insert Parent Project');
            
            projectList[0].BET__c = betRecord1.Id;
            projectList[0].IPM_Project_Type__c = Rollout;
            projectList[0].IPMProject_Span__c = Regional;
            projectList[0].IPM_Project_Job_Status__c = Completed;
            projectList[0].IPM_Project_Name__c = 'TestPrj01';
            projectList[0].IPM_Parent_Project__c = parentProj.id;
            
            projectList[9].BET__c = betRecord4.Id;
            projectList[9].IPM_Project_Type__c = Rollout;
            projectList[9].IPMProject_Span__c = Regional;
            projectList[9].IPM_Project_Job_Status__c = Completed;
            projectList[9].IPM_Project_Name__c = 'TestPrj02';
            projectList[9].IPM_Parent_Project__c = parentProj.id;
            
            projectList[10].BET__c = betRecord0.Id;
            projectList[10].IPM_Project_Type__c = Rollout;
            projectList[10].IPMProject_Span__c = Regional;
            projectList[10].IPM_Project_Job_Status__c = Completed;
            projectList[10].IPM_Project_Name__c = 'TestPrj0';
            projectList[10].IPM_Parent_Project__c = parentProj.id;
            
            insert new List < IPM_Project__c > {
                projectList[0], projectList[9], projectList[10]
            };
            
            projectList[1].BET__c = betRecord1.Id;
            projectList[1].IPM_Project_Name__c = 'TestPrj05';
            projectList[1].IPMProject_Span__c = Regional;
            projectList[1].IPM_Parent_Project__c = projectList[0].id;
            projectList[1].IPM_Project_Leader__c = UserInfo.getuserId();
            projectList[1].Deputy_Project_Leader__c = UserInfo.getuserId();
            projectList[1].IPM_Project_Type__c = Rollout;
            
            projectList[8].BET__c = betRecord0.Id;
            projectList[8].IPM_Project_Type__c = Rollout;
            projectList[8].IPM_Parent_Project__c = projectList[9].id;
            projectList[8].IPMProject_Span__c = Regional;
            projectList[8].IPM_Project_Job_Status__c = Completed;
            projectList[8].IPM_Project_Name__c = 'TestPrj03';
            
            insert new List < IPM_Project__c > {
                projectList[1], projectList[8]
            };
            
            projectList[2].BET__c = betRecord2.Id;
            projectList[2].IPM_Project_Name__c = 'TestPrj06';
            projectList[2].IPM_Parent_Project__c = projectList[1].id;
            projectList[2].IPM_Project_Type__c = Rollout;
            projectList[2].IPMProject_Span__c = Regional;
            
            projectList[3].BET__c = betRecord1.Id;
            projectList[3].IPM_Project_Name__c = 'TestPrj07';
            projectList[3].IPM_Parent_Project__c = projectList[1].id;
            projectList[3].IPM_Project_Type__c = Rollout;
            projectList[3].IPMProject_Span__c = Regional;
            
            projectList[4].BET__c = betRecord1.Id;
            projectList[4].IPM_Project_Name__c = 'TestPrj08';
            projectList[4].IPM_Parent_Project__c = projectList[0].id;
            projectList[4].IPM_Project_Type__c = Rollout;
            projectList[4].IPMProject_Span__c = 'RegionalLocal';
            
            projectList[5].BET__c = betRecord3.Id;
            projectList[5].IPM_Project_Name__c = 'TestPrj09';
            projectList[5].IPM_Parent_Project__c = projectList[10].id;
            projectList[5].IPM_Project_Type__c = Rollout;
            projectList[5].IPMProject_Span__c = Local;
            projectList[5].IPM_Project_Leader__c=Userinfo.getUserId();
            
            projectList[6].BET__c = betRecord3.Id;
            projectList[6].IPM_Project_Name__c = 'TestPrj10';
            projectList[6].IPM_Parent_Project__c = projectList[8].id;
            projectList[6].IPM_Project_Type__c = Rollout;
            projectList[6].IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            
            projectList[7].BET__c = betRecord3.Id;
            projectList[7].IPM_Parent_Project__c = projectList[8].id;
            projectList[7].IPM_Project_Type__c = Rollout;
            projectList[7].IPMProject_Span__c = Local;
            projectList[7].IPM_Project_Name__c = 'TestPrj11';
            
            Test.starttest();
            
            insert new List < IPM_Project__c > {
                projectList[2], projectList[3], projectList[4], projectList[5], projectList[6], projectList[7]
            };
            
            Test.stoptest();
            
        }  
        
    }
    
    // Test method for method to Update BET Milestones DueDate after BET is associated/updated to IPM Project  
    private static testmethod void testupdateBETmilestones() {
        
        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        
        IPM_Project__c proj0=[Select Id,BET__c ,IPM_Project_Type__c,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_Phase__c,IPM_CompanyCardText__c,IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c from IPM_Project__c where IPM_Project_Name__c = 'TestPrj01' limit 1];
        IPM_Project__c proj1=[Select Id,BET__c ,IPM_Project_Type__c,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_Phase__c,IPM_CompanyCardText__c,IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c from IPM_Project__c where IPM_Project_Name__c = 'TestPrj05' limit 1];
        
        uw_BET__c betRecord =[Select id from uw_BET__c where name='TestBet0' limit 1];
        System.runAs(testRunningUser){
            
            Test.StartTest();
            
            proj1.BET__c =null;
            update proj1;
            
            Map < string, ipm_project__c > mapProjBET = new Map < string, ipm_project__c > ();
            
            mapProjBET.put(proj0.id, proj0);
            mapProjBET.put(proj1.id, proj1);
            
            IPM_BETHelper.updateBETmilestones(mapProjBET);
            
            Test.StopTest();
        }
        system.assertEquals([Select First_Release_Due_Date__c from uw_BET__c where id = : betRecord.id].First_Release_Due_Date__c, [Select IPM_Due_Date__c from IPM_Milestone__c where IPM_Project__c = : proj0.id limit 1].IPM_Due_Date__c, 'BET Milestones DueDate updation failed ');
    }

    // Test method for method updateBETMilestoneMissOnProject 
    private static testmethod void testupdateBETMilestoneMissOnProject() {
        
        User testRunningUser = [Select Id, LastName from User where email = 'testUser@unilever.com' limit 1];
        
        Map < id, list < IPM_Milestone__c >> mapProjectBETMS = new map < id, list < IPM_Milestone__c >> ();
        List < IPM_Milestone__c > IPMsam1 = IPM_TestFactory_Helper.createIPMMilestoneList(false, 2);
        List < IPM_Milestone__c > IPMsam2 = IPM_TestFactory_Helper.createIPMMilestoneList(false, 2);
        
        System.runAs(testRunningUser){
            
            
            uw_BET__c betRecord1 =[Select id from uw_BET__c where name='BET1' limit 1];
            uw_BET__c betRecord2 =[Select id from uw_BET__c where name='BET2' limit 1];
            
            IPM_Project__c proj0=[Select Id,BET__c ,IPM_Project_Type__c,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_Phase__c,IPM_CompanyCardText__c,IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c from IPM_Project__c where IPM_Project_Name__c = 'TestResourceProj0' limit 1];
            IPM_Project__c proj1=[Select Id,BET__c ,IPM_Project_Type__c,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_Phase__c,IPM_CompanyCardText__c,IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c from IPM_Project__c where IPM_Project_Name__c = 'TestResourceProj1' limit 1];
            
            proj0.BET__c =betRecord1.Id;
            proj1.BET__c =betRecord2.Id;
            update new List<IPM_Project__c >{proj0,proj1};
            
            for (IPM_Milestone__c ipmMilestone: IPMsam1) {
                ipmMilestone.IPM_Due_Date__c = Date.today() - 365;
                ipmMilestone.IPM_Name__c = Math.random() + 'BETFirstRelease';
                ipmMilestone.IPM_Project__c = proj0.id;
                ipmMilestone.IPM_Type_of_Milestone__c = 'BET';
                ipmMilestone.IPM_Name__c = '1stBETFinalRelease11orBETFirstRelease';
            }
            
            for (IPM_Milestone__c ipmMilestone: IPMsam2) {
                ipmMilestone.IPM_Due_Date__c = Date.today() - 365;
                ipmMilestone.IPM_Name__c = Math.random() + 'BETFinalRelease';
                ipmMilestone.IPM_Project__c = proj1.id;
            } 
            
            List<IPM_Milestone__c > milestoneList=new List<IPM_Milestone__c >();
            milestoneList.addAll(IPMsam1);
            milestoneList.addAll(IPMsam2);
            
            insert milestoneList ;
            
            mapProjectBETMS.put(proj0.id, IPMsam1);
            mapProjectBETMS.put(proj1.id, IPMsam2);
            
            Test.starttest();
            IPM_BETHelper.updateBETMilestoneMissOnProject(mapProjectBETMS);
            Test.stopTest();
            
            System.assertEquals([Select BET_First_Release_Missed__c, BET_Final_Release_Missed__c from IPM_project__c where id = : proj0.Id].BET_First_Release_Missed__c, true, 'Failed to update  BET Milestone passed checkbox');
            System.assertEquals([Select BET_First_Release_Missed__c, BET_Final_Release_Missed__c from IPM_project__c where id = : proj1.Id].BET_Final_Release_Missed__c, true, 'Failed to update  BET Milestone passed checkbox');

        }
        
        
    }


    //test method for method to reset BET Milestone date missed alert 
    private static testmethod void testresetMilestoneMissedFlag() {
        
        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        
        uw_BET__c betRecord1 =[Select id,name,Status__c,FinalReleaseDate__c,Final_Release_Due_Date__c,FirstReleaseDate__c,First_Release_Due_Date__c,Is_Archived__c,OwnerId,Category_Group__c,Product_Category__c,Brand_Position__c,Product_Brand__c from uw_BET__c where name='TestBet0' limit 1];
        
        uw_BET__c betRecord2 =[Select id,name,Status__c,FinalReleaseDate__c,Final_Release_Due_Date__c,FirstReleaseDate__c,First_Release_Due_Date__c,Is_Archived__c,OwnerId,Category_Group__c,Product_Category__c,Brand_Position__c,Product_Brand__c from uw_BET__c where name='TestBet1' limit 1];
        betRecord2.Status__c = FirstRelease;
        
        system.runAs(testRunningUser){
            
            Test.startTest();
            
            update betRecord2;
            
            IPM_Project__c proj0=[Select Id,BET__c ,IPM_Project_Type__c,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_Phase__c,IPM_CompanyCardText__c,IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c from IPM_Project__c where IPM_Project_Name__c = 'TestPrj01' limit 1];
            IPM_Project__c proj1=[Select Id,BET__c ,IPM_Project_Type__c,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_Phase__c,IPM_CompanyCardText__c,IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c from IPM_Project__c where IPM_Project_Name__c = 'TestPrj05' limit 1];
            
            BET_BETWrapper betWrap1 = new BET_BETWrapper(betRecord1);
            BET_BETWrapper betWrap2 = new BET_BETWrapper(betRecord2);
            
            IPM_BETHelper.resetMilestoneMissedFlag(betRecord1.id, betWrap1);
            IPM_BETHelper.resetMilestoneMissedFlag(betRecord2.id, betWrap2);
            
            Test.stopTest();
            
            System.assertEquals([Select BET_First_Release_Missed__c from IPM_project__c where id = : proj0.Id].BET_First_Release_Missed__c, false, 'Failed to reset BET_First_Release_Missed__c');
            System.assertEquals([Select BET_Final_Release_Missed__c from IPM_project__c where id = : proj1.Id].BET_Final_Release_Missed__c, false, 'Failed to reset BET_Final_Release_Missed__c');

        }

        
    }


    //Test method for setArchiveBET_IPM method

    private static testmethod void testsetArchiveBET_IPM() {
        
        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        
        uw_BET__c betRecord1 =[Select id,name,Status__c,FinalReleaseDate__c,Final_Release_Due_Date__c,FirstReleaseDate__c,First_Release_Due_Date__c,Is_Archived__c,OwnerId,Category_Group__c,Product_Category__c,Brand_Position__c,Product_Brand__c from uw_BET__c where name='TestBet0' limit 1];
        
        system.runAs(testRunningUser){

            BET_BETWrapper betWrap1 = new BET_BETWrapper(betRecord1);
            
            Test.StartTest();
            
            IPM_BETHelper.setArchiveBET_IPM(betWrap1);
            
            Test.StopTest();
        }
        IPM_Project__c testRetrieveProj = [select id, BET_Archived_BET_Text__c, BET_Archive_Status__c, BET_Archived_BET__c from IPM_Project__c where bet__c = :  betRecord1.Id limit 1];

        system.assertEquals(testRetrieveProj.BET_Archived_BET__c,  betRecord1.Id, 'Failed to archieve');
        system.assertEquals(testRetrieveProj.BET_Archived_BET_Text__c,  betRecord1.Name, 'Failed to archieve');
        system.assertEquals(testRetrieveProj.BET_Archive_Status__c,  betRecord1.Status__c, 'Failed to archieve');

    }

    
    //test method for method to send Regional/Local Rollout Leaders' Access Request to BET after BET First Release    
    private static testmethod void testsendBETAccessRequestonFirstRelease() {
        
        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        
        uw_BET__c betRecord1 =[Select id,name,Status__c,FinalReleaseDate__c,Final_Release_Due_Date__c,FirstReleaseDate__c,First_Release_Due_Date__c,Is_Archived__c,OwnerId,Category_Group__c,Product_Category__c,Brand_Position__c,Product_Brand__c from uw_BET__c where name='BET1' limit 1];
        uw_BET__c betRecord2 =[Select id,name,Status__c,FinalReleaseDate__c,Final_Release_Due_Date__c,FirstReleaseDate__c,First_Release_Due_Date__c,Is_Archived__c,OwnerId,Category_Group__c,Product_Category__c,Brand_Position__c,Product_Brand__c from uw_BET__c where name='BET2' limit 1];
        IPM_Project_Resource__c PrjctResrc1= [select IPM_User__c from  IPM_Project_Resource__c where IPM_Role_Type__c='BD' LIMIT 1];
        System.runAs(testRunningUser){
            
            Test.StartTest();
            IPM_BETHelper.sendBETAccessRequestonFirstRelease(betRecord2.Id);
            Test.StopTest();
    
            System.assertEquals([Select UserId__c from BET_Member_Request__c where Brand_Experience_Toolkit__c = : betRecord2.Id limit 1].UserId__c, PrjctResrc1.IPM_User__c, 'Failed to send Regional/Local Rollout Leader Access Request to BET');
        }
    }

    //test method for method to send Regional/Local Rollout Leaders' Access Request to BET after BET First Release    
    private static testmethod void testsendBETAccessRequest() {
        
        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        
        uw_BET__c betRecord1 =[Select id,name,Status__c,FinalReleaseDate__c,Final_Release_Due_Date__c,FirstReleaseDate__c,First_Release_Due_Date__c,Is_Archived__c,OwnerId,Category_Group__c,Product_Category__c,Brand_Position__c,Product_Brand__c from uw_BET__c where name='TestBet0' limit 1];
        
        IPM_Project__c proj0=[Select Id,BET__c ,IPM_Project_Type__c,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_Phase__c,IPM_CompanyCardText__c,IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c from IPM_Project__c where IPM_Project_Name__c = 'TestPrj01' limit 1];
        
        system.runAs(testRunningUser){
            
            Test.StartTest();
            
            IPM_BETHelper.sendBETAccessRequest(new list <id> {
                UserInfo.getUserId()
            }, betRecord1.id, proj0.id);
            
            Test.StopTest();
        }
        BET_Member_Request__c betMember = [Select Project_Id__c, Bet_owner__c from BET_Member_Request__c where Project_Id__c=: proj0.Id  limit 1];
        system.assertEquals(betMember.Project_Id__c, proj0.Id, 'Failed to update project Id on BET Member');
        system.assertEquals(betMember.Bet_owner__c, [Select ownerId from uw_BET__c where id = : betRecord1.Id].ownerId, 'Failed to update BET owner');
    }


    //test method for sendRolloutMemberBETAccessRequest method  
    private static testmethod void testsendRolloutMemberBETAccessRequest() {

    User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        Map < id, set < IPM_Project_Resource__c >> mapProjResources = new Map < id, set < IPM_Project_Resource__c >> ();
        map<string, id> mapProjId= new map<string, id>();
        set<string> setNames = new set<string>{'TestPrj10', 'TestPrj11', 'TestPrj09', 'TestPrj06', 'TestPrj05', 'TestPrj01', 'TestPrj07', 'TestPrj08'};
        for(IPM_Project__c proj :[Select id,IPM_Project_Name__c from IPM_Project__c where  IPM_Project_Name__c in :setNames]){
            mapProjId.put(proj.IPM_Project_Name__c, proj.id);   
        }
        
        
        system.runAs(testRunningUser){
            
            Test.starttest();
            
            IPM_Project_Resource__c PrjctResrc1 = new IPM_Project_Resource__c();
            PrjctResrc1.IPM_User__c = UserInfo.getuserId();
            PrjctResrc1.IPM_Role_Type__c = 'BD';
            
            PrjctResrc1.IPM_Project__c = mapProjId.get('TestPrj09');

            IPM_Project_Resource__c PrjctResrc2 = new IPM_Project_Resource__c();
            PrjctResrc2.IPM_User__c = UserInfo.getuserId();
            PrjctResrc2.IPM_Role_Type__c = 'BD';
            
            PrjctResrc2.IPM_Project__c = mapProjId.get('TestPrj06');


            IPM_Project_Resource__c PrjctResrc3 = new IPM_Project_Resource__c();
            PrjctResrc3.IPM_User__c = UserInfo.getuserId();
            PrjctResrc3.IPM_Role_Type__c = 'BD';
            
            PrjctResrc3.IPM_Project__c =  mapProjId.get('TestPrj05');


            IPM_Project_Resource__c PrjctResrc4 = new IPM_Project_Resource__c();
            PrjctResrc4.IPM_User__c = UserInfo.getuserId();
            PrjctResrc4.IPM_Role_Type__c = 'BD';
            
            PrjctResrc4.IPM_Project__c =  mapProjId.get('TestPrj01');

            IPM_Project_Resource__c PrjctResrc5 = new IPM_Project_Resource__c();
            PrjctResrc5.IPM_User__c = UserInfo.getuserId();
            PrjctResrc5.IPM_Role_Type__c = 'BD';
            
            PrjctResrc5.IPM_Project__c =  mapProjId.get('TestPrj07');
            
            
            insert new List < IPM_Project_Resource__c > {
                PrjctResrc1, PrjctResrc2, PrjctResrc3, PrjctResrc4, PrjctResrc5
            };
            
            
            mapProjResources.put(mapProjId.get('TestPrj05'), new Set < IPM_Project_Resource__c > {
                PrjctResrc1, PrjctResrc4, PrjctResrc4
            });
            
            mapProjResources.put(mapProjId.get('TestPrj06'), new Set < IPM_Project_Resource__c > {
                PrjctResrc2, PrjctResrc3, PrjctResrc4
            });
            mapProjResources.put(mapProjId.get('TestPrj07'), new Set < IPM_Project_Resource__c > {
                PrjctResrc2, PrjctResrc3, PrjctResrc4, PrjctResrc5
            });
            mapProjResources.put(mapProjId.get('TestPrj08'), new Set < IPM_Project_Resource__c > {
                PrjctResrc2, PrjctResrc3, PrjctResrc4, PrjctResrc5
            });
            
            
            mapProjResources.put(mapProjId.get('TestPrj09'), new Set < IPM_Project_Resource__c > {
                PrjctResrc2, PrjctResrc3, PrjctResrc4, PrjctResrc5
            });
            mapProjResources.put(mapProjId.get('TestPrj10'), new Set < IPM_Project_Resource__c > {
                PrjctResrc2, PrjctResrc3, PrjctResrc4, PrjctResrc5
            });
            mapProjResources.put(mapProjId.get('TestPrj11'), new Set < IPM_Project_Resource__c > {
                PrjctResrc2, PrjctResrc3, PrjctResrc4, PrjctResrc5
            });
            
            
            IPM_BETHelper.sendRolloutMemberBETAccessRequest(mapProjResources);
            
            Test.StopTest();
            
            system.assertEquals([select UserId__c from BET_Member_Request__c where UserId__c =:[Select id ,IPM_Project_Leader__c from IPM_Project__c where  IPM_Project_Name__c = 'TestPrj09' limit 1].IPM_Project_Leader__c  limit 1].UserId__c, PrjctResrc1.IPM_User__c, 'BET Access Request  not sent.');
            
        }             
        
    }

    //test method for method to update Phase of BET Final Release Milestone
    private static testmethod void testupdatePhaseBETMSFinalRelease() {
        
        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        
        List < IPM_Milestone__c > IPMsam1 = IPM_TestFactory_Helper.createIPMMilestoneList(false, 2);
        
        
        system.runAs(testRunningUser){
            
            uw_BET__c betRecord1 =[Select id,name,Status__c,FinalReleaseDate__c,Final_Release_Due_Date__c,FirstReleaseDate__c,First_Release_Due_Date__c,Is_Archived__c,OwnerId,Category_Group__c,Product_Category__c,Brand_Position__c,Product_Brand__c from uw_BET__c where name='TestBet1' limit 1];
            betRecord1.Status__c = 'Unreleased';
            update  betRecord1;
            
            IPM_Project__c proj0=[Select Id,BET__c ,IPM_Project_Type__c,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_Phase__c,IPM_CompanyCardText__c,IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c from IPM_Project__c where IPM_Project_Name__c = 'TestPrj01' limit 1];

            
            for (IPM_Milestone__c ipmMilestone: IPMsam1) {
                ipmMilestone.IPM_Due_Date__c = Date.today() - 365;
                ipmMilestone.IPM_Project__c = proj0.id;
                ipmMilestone.IPM_Type_of_Milestone__c = IPM_ConstantUtils.STRING_BET;
                ipmMilestone.IPM_Name__c = '1stBETFinalRelease11orBETFirstRelease' + IPM_ConstantUtils.BET_MS_FINAL_RELEASE;
                ipmMilestone.IPM_Phase__c = null;
            }
            
            Test.StartTest();
            
            insert IPMsam1 ;
            
            IPM_BETHelper.updatePhaseBETMSFinalRelease(betRecord1.Id);
            
            System.assertEquals([Select IPM_Phase__c from IPM_Milestone__c where Id = : IPMsam1[0].id OR Id = : IPMsam1[1].id limit 1].IPM_Phase__c, proj0.IPM_Phase__c, 'Failed to update milestone phase');
            
            Test.StopTest();
        }
    }


    //testmethod for method to send updates to BET on Project update in IPM
    private static testmethod void testsendIPMupdatetoBET() {
        User testRunningUser = [Select Id, LastName from User where LastName = 'PLATFORM_USER' limit 1];
        
        uw_BET__c betRecord1 =[Select id,name,Status__c,FinalReleaseDate__c,Final_Release_Due_Date__c,FirstReleaseDate__c,First_Release_Due_Date__c,Is_Archived__c,OwnerId,Category_Group__c,Product_Category__c,Brand_Position__c,Product_Brand__c from uw_BET__c where name='TestBet1' limit 1];
        IPM_Project__c proj0;
        IPM_Project__C proj1;
        System.runAs(testRunningUser){
            
            for(IPM_Project__C proj :[Select Id,IPM_Project_Name__c,BET__c ,IPM_Project_Type__c,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_Phase__c,IPM_CompanyCardText__c,IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c from IPM_Project__c where IPM_Project_Name__c in ('TestPrj01','TestPrj05')]){
                if(proj.IPM_Project_Name__c == 'TestPrj01'){
                    proj0 = proj;
                }
                else if(proj.IPM_Project_Name__c == 'TestPrj05'){
                    proj1 = proj;
                }
            }
            
            proj0.BET__c =betRecord1.Id;
            proj0.IPM_Target_Launch_Dates__c = Date.Today();
            
            proj1.BET__c =betRecord1.Id;
            proj1.IPM_Target_Launch_Dates__c = Date.Today() + 20;
            Test.StartTest();
            
            update new List< IPM_Project__c>{proj0,proj1};
            
            betRecord1.IPM_Project__c = proj0.id;
            update betRecord1;
            
            IPM_BETHelper.sendIPMupdatetoBET(new List < IPM_Project__c > {
                proj0
            }, new List < IPM_Project__c > {
                proj1
            });
            
            Test.StopTest();
            
            System.assertEquals([Select Launch_Date__c from uw_BET__c where id = : proj0.BET__c].Launch_Date__c, proj0.IPM_Target_Launch_Dates__c, 'Failed to send updates to BET on Project update in IPM');
        } 
    }
}