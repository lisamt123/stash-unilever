/******************************************** 
@Author: Cognizant
@name: IPM_BETHelper_Test
@CreateDate: 01/06/2015
@Description: Test class to test IPM_BETHelper  Class.
@Version: 1.0
@reference: 
*********************************************/
@istest
class IPM_BETHelper_Test {
    private final static String Feasibility = IPM_ConstantUtils.PHASE_FEASIBILITY;
    private final static String Rollout = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
    private final static String Local = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
    private final static String GlobalCompanyCard = IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
    private final static String Completed = IPM_ConstantUtils.JOB_STATUS_COMPLETED;
    private final static String Regional = IPM_ConstantUtils.COMPANY_CARD_REGIONAL;
    private final static String FirstRelease = 'First release';
    private final static String Unreleased = IPM_ConstantUtils.BET_UNRELEASED; 
    private final static String IPM_ProjectType = 'IPM_ProjectType';
    private final static String IPM_BET_Search_Test = 'IPM_BET_Search_Test';
    private final static String FinalRelease = 'Final Release';
    private final static String MANAGER_ACCESS = IPM_ConstantUtils.BET_MANAGER_ACCESS;
    private final static String USER_LAST_NAME = 'PLATFORM_USER';
    private final static String BLANK_STRING = IPM_ConstantUtils.BLANK;
    private final static String BET_MS_FINAL_RELEASE = IPM_ConstantUtils.BET_MS_FINAL_RELEASE;
    private final static string TEST_PROJECT00 = 'TestResourcePrj1';
    private final static string TEST_PROJECT01 = 'TestResourcePrj2';
    private final static string TEST_PROJECT02 = 'TestResourcePrj3';
    private final static string TEST_PROJECT03 = 'TestResourcePrj4';
    private final static string TEST_PROJECT05 = 'TestResourcePrj5';
    private final static string TEST_PROJECT06 = 'TestPrj01';
    private final static string TEST_PROJECT07 = 'TestPrj02';
    private final static string TEST_PROJECT08 = 'TestPrj03';
    private final static string TEST_PROJECT09 = 'TestPrj04';
    private final static string TEST_BET00 = 'BET1';
    private final static string TEST_BET01 = 'BET2';
    private final static string TEST_BET02 = 'TestBet0';
    private final static string TEST_BET03 = 'TestBet1';
    private final static string TEST_BET04 = 'TestBet2';
    private final static string IPM_Role_BD= 'BD';
    private final static string IPM_Role_CD= 'CD';
    private final static string TEST_BET = 'TestBet';
    private final static string ERROR_FAILED_TO_UPDATE_BET_MILESTONE ='Failed to update  BET Milestone passed checkbox';
    private final static string ERROR_FAILED_TO_ARCHIVE = 'Failed to archieve';

    private static User stdUserForBET; // Variable has been used in Setup data method 

    @testSetup static void setUpDataResource() {

        //Load Project Type only if it has not been loaded already
        list < IPM_Project_Type__c > lstProjType = IPM_Project_Type__c.getAll().values();
        if (lstProjType == null || (lstProjType != null && !lstProjType.isEmpty())) {
            test.loadData(IPM_Project_Type__c.sobjectType, IPM_ProjectType);
        }
        list < IPM_BET_Search_Fields__c > lstSearchFields = IPM_BET_Search_Fields__c.getAll().values();
        //Load search fields only if it has not been already loaded.
        if (lstSearchFields == null || (lstSearchFields != null && !lstSearchFields.isEmpty())) {
            test.loadData(IPM_BET_Search_Fields__c.sobjectType, IPM_BET_Search_Test);
        }

        List < IPM_Project__c > projectList = IPM_TestFactory_Helper.createIPMProjectList(false, 8);

        Test.starttest();

        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)) {
            // User has to be created as a  system Admin 
            if ([Select count() from User where LastName = : USER_LAST_NAME] >= 1) {
                stdUserForBET = [Select Id from User where LastName = : USER_LAST_NAME
                limit 1];
            } else {

                stdUserForBET = IPM_TestFactory_Helper.createIPMPlatformProfileUser(BLANK_STRING);

            }

        }

        uw_BET__c betRecord1 = BET_TestUtils.getTestBet();
        betRecord1.name = TEST_BET00;
        betRecord1.Status__c = Unreleased;
        uw_BET__c betRecord2 = BET_TestUtils.getTestBet();
        betRecord2.name = TEST_BET01;
        betRecord2.Status__c = FirstRelease ;
        insert new List < uw_BET__c > {
            betRecord1, betRecord2
        };
        
        System.assertEquals(2,[Select count() from uw_BET__c where Id =:betRecord1.Id OR  Id =:betRecord2.Id ],'Failed to insert BET records!') ;


        IPM_Project__c parentProj = projectList[0];
        parentProj.ownerId = stdUserForBET.id;
        parentProj.Deputy_Project_Leader__c = stdUserForBET.id;
        parentProj.IPM_Project_Name__c = 'testParentProj1';
        parentProj.BET__c = betRecord1.Id;
        insert parentProj;
        
        System.assertEquals(1,[Select count() from IPM_Project__c where Id =:parentProj.Id ],'Failed to insert project  record!') ;
        

        list < BET_BETWrapper.MemberRequest > lstMemberRequests = new list < BET_BETWrapper.MemberRequest > ();

        //Giving access to BET
        BET_BETWrapper.MemberRequest member = new BET_BETWrapper.MemberRequest();
        member.UserId = stdUserForBET.Id;
        member.AccessLevel = MANAGER_ACCESS;
        lstMemberRequests.add(member);
        BET_AccessService.RequestAccess(lstMemberRequests, betRecord1.Id, parentProj.id);
        BET_AccessService.RequestAccess(lstMemberRequests, betRecord2.Id, parentProj.id);

        System.runAs(stdUserForBET) {
            projectList[1].BET__c = betRecord1.Id;
            projectList[1].IPM_Project_Name__c = TEST_PROJECT00;
            projectList[1].IPM_Phase__c = Feasibility;
            projectList[1].IPM_CompanyCardText__c = GlobalCompanyCard;
            projectList[1].IPM_Project_Job_Status__c = Completed;
            projectList[1].IPM_Project_Leader__c = UserInfo.getuserId();
            projectList[1].Deputy_Project_Leader__c = UserInfo.getuserId();


            projectList[2].BET__c = betRecord2.Id;
            projectList[2].IPM_Project_Name__c = TEST_PROJECT01;
            projectList[2].IPM_Project_Leader__c = UserInfo.getuserId();
            projectList[2].Deputy_Project_Leader__c = UserInfo.getuserId();

            projectList[3].BET__c = betRecord2.Id;
            projectList[3].IPM_Project_Name__c = 'TestResourceProj3';
            projectList[3].IPM_Project_Leader__c = UserInfo.getuserId();
            projectList[3].Deputy_Project_Leader__c = UserInfo.getuserId();

            projectList[4].IPM_Project_Name__c = 'TestResourceProj4';
            projectList[4].IPM_Parent_Project__c = parentProj.id;
            projectList[4].IPM_Project_Leader__c = UserInfo.getuserId();
            projectList[4].Deputy_Project_Leader__c = UserInfo.getuserId();

            insert new List < IPM_Project__c > {
                projectList[1], projectList[2], projectList[3], projectList[4]
            };
            
            set < Id > projectIds = new set < Id > {
                projectList[1].Id, projectList[2].Id , projectList[3].Id , projectList[4].Id
             };
       
            
            System.assertEquals(4 ,[Select count() from IPM_Project__c where Id IN : projectIds ],'Failed to insert project  records!') ;

            IPM_Project_Resource__c PrjctResrc1 = IPM_TestFactory_Helper.createIPMProjectResource(projectList[2].id, false);
            IPM_Project_Resource__c PrjctResrc2 = IPM_TestFactory_Helper.createIPMProjectResource(projectList[2].id, false);
            IPM_Project_Resource__c PrjctResrc3 = IPM_TestFactory_Helper.createIPMProjectResource(projectList[3].id, false);

            PrjctResrc1.IPM_User__c = UserInfo.getuserId();
            PrjctResrc1.IPM_Role_Type__c = IPM_Role_BD;

            PrjctResrc2.IPM_User__c = UserInfo.getuserId();
            PrjctResrc2.IPM_Role_Type__c = IPM_Role_CD;

            PrjctResrc3.IPM_User__c = UserInfo.getuserId();
            PrjctResrc3.IPM_Role_Type__c = IPM_Role_CD;


            insert new List < IPM_Project_Resource__c > {
                PrjctResrc1, PrjctResrc2, PrjctResrc3
            };
            
            set < Id > resourceIds = new set < Id > {
                PrjctResrc1.Id, PrjctResrc2.Id , PrjctResrc3.Id 
             };
            
            System.assertEquals(3 ,[Select count() from IPM_Project_Resource__c where Id IN : resourceIds ],'Failed to insert Projectresource  records!') ;
            

            projectList[5].IPM_Project_Name__c = TEST_PROJECT02;
            projectList[5].IPM_Parent_Project__c = projectList[2].id;
            projectList[5].IPM_Project_Type__c = Rollout;
            projectList[5].IPMProject_Span__c = Local;
            projectList[5].IPM_Project_Leader__c = UserInfo.getuserId();
            projectList[5].Deputy_Project_Leader__c = UserInfo.getuserId();

            projectList[6].IPM_Project_Name__c = TEST_PROJECT03;
            projectList[6].IPM_Parent_Project__c = projectList[2].id;
            projectList[6].IPM_Project_Type__c = Rollout;
            projectList[6].IPMProject_Span__c = Local;
            projectList[6].IPM_Project_Leader__c = UserInfo.getuserId();
            projectList[6].Deputy_Project_Leader__c = UserInfo.getuserId();

            projectList[7].IPM_Project_Name__c = TEST_PROJECT05;
            projectList[7].IPM_Parent_Project__c = projectList[4].id;
            projectList[7].IPM_Project_Type__c = Rollout;
            projectList[7].IPMProject_Span__c = Local;
            projectList[7].IPM_Project_Leader__c = UserInfo.getuserId();
            projectList[7].Deputy_Project_Leader__c = UserInfo.getuserId();

            insert new List < IPM_Project__c > {
                projectList[5], projectList[6], projectList[7]
            };
            
            set < Id > projectIdsSet = new set < Id > {
                projectList[5].Id, projectList[6].Id , projectList[7].Id 
             };
            
            System.assertEquals(3 ,[Select count() from IPM_Project__c  where Id IN : projectIdsSet ],'Failed to insert Project   records!') ;

        }
        Test.stoptest();
    }

    @testSetup static void setUpData() {

        List < IPM_Project__c > projectList = IPM_TestFactory_Helper.createIPMProjectList(false, 5);
        list < IPM_BET_Search_Fields__c > lstSearchFields = IPM_BET_Search_Fields__c.getAll().values();
        //Load search fields only if it has not been already loaded.
        if (lstSearchFields == null || (lstSearchFields != null && !lstSearchFields.isEmpty())) {
            test.loadData(IPM_BET_Search_Fields__c.sobjectType, IPM_BET_Search_Test);
        }
        Test.starttest();

        // User has to be created as a system admin
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)) {
            if ([Select count() from User where LastName = : USER_LAST_NAME] >= 1) {
                stdUserForBET = [Select Id from User where LastName = : USER_LAST_NAME
                limit 1];
            } else {

                stdUserForBET = IPM_TestFactory_Helper.createIPMPlatformProfileUser(BLANK_STRING);

            }

        }
        List < uw_BET__c > betRecordList = new List < uw_BET__c > ();

        for (Integer i = 0; i < 3; i++) {
            uw_BET__c betRecord = BET_TestUtils.getTestBet();

            betRecord.FinalReleaseDate__c = Date.Today() + 365;
            betRecord.First_Release_Due_Date__c = Date.Today();
            betRecord.Name = TEST_BET + i;

            if (betRecord.Name == TEST_BET04) {
                betRecord.Status__c = FirstRelease;
            } else {
                betRecord.Status__c = FinalRelease;
            }
            betRecordList.add(betRecord);
        }

        insert betRecordList;
        
        
        set < Id > betRecordListIds = new set < Id > {
                betRecordList[0].Id, betRecordList[1].Id , betRecordList[2].Id
             };
            
            System.assertEquals(3 ,[Select count() from uw_BET__c where Id IN : betRecordListIds ],'Failed to insert BET  records!') ;
        
        set < String > betNames = new set < String > {
               TEST_BET02, TEST_BET03, TEST_BET04 
             };
             
        List<uw_BET__c> betRecords =[Select id from uw_BET__c where name IN : betNames order by Name ASC];
       
        List < BET_BETWrapper.MemberRequest > lstMemberRequests = new list < BET_BETWrapper.MemberRequest > ();

        IPM_Project__c parentProj = projectList[0];
        parentProj.ownerId = stdUserForBET.id;
        parentProj.Deputy_Project_Leader__c = stdUserForBET.id;
        parentProj.IPM_Project_Name__c = 'testParentProj2';
        insert parentProj;

        System.assertEquals(parentProj.IPM_Project_Name__c , [Select IPM_Project_Name__c from IPM_Project__c where Id=:parentProj.id ].IPM_Project_Name__c, 'Failed to insert Parent Project with correct name .');

        BET_BETWrapper.MemberRequest member = new BET_BETWrapper.MemberRequest(); 
        member.UserId = stdUserForBET.Id;
        member.AccessLevel = MANAGER_ACCESS;
        lstMemberRequests.add(member);

        BET_AccessService.RequestAccess(lstMemberRequests, betRecords[0].Id, parentProj.Id);
        BET_AccessService.RequestAccess(lstMemberRequests, betRecords[1].Id, parentProj.Id);
        BET_AccessService.RequestAccess(lstMemberRequests, betRecords[2].Id, parentProj.Id);

        System.assertEquals(3,[select count() FROM BET_Member_Request__c where   Project_Id__c = : parentProj.Id  AND ( Brand_Experience_Toolkit__c = : betRecords[0].Id OR  Brand_Experience_Toolkit__c =: betRecords[1].Id  OR Brand_Experience_Toolkit__c =: betRecords[2].Id) ] );
        
        System.runAs(stdUserForBET) {
            projectList[1].BET__c = betRecords[1].Id;
            projectList[1].IPM_Project_Type__c = Rollout;
            projectList[1].IPMProject_Span__c = Regional;
            projectList[1].IPM_Project_Job_Status__c = Completed;
            projectList[1].IPM_Project_Name__c = TEST_PROJECT06;
            projectList[1].IPM_Parent_Project__c = parentProj.id;

            projectList[2].BET__c = betRecords[2].Id;
            projectList[2].IPM_Project_Type__c = Rollout;
            projectList[2].IPMProject_Span__c = Regional;
            projectList[2].IPM_Project_Job_Status__c = Completed;
            projectList[2].IPM_Project_Name__c = TEST_PROJECT07;
            projectList[2].IPM_Parent_Project__c = parentProj.id;

            projectList[3].BET__c = betRecords[0].Id;
            projectList[3].IPM_Project_Type__c = Rollout;
            projectList[3].IPMProject_Span__c = Regional;
            projectList[3].IPM_Project_Job_Status__c = Completed;
            projectList[3].IPM_Project_Name__c = TEST_PROJECT08;
            projectList[3].IPM_Parent_Project__c = parentProj.id;

            insert new List < IPM_Project__c > {
                projectList[1], projectList[2], projectList[3]
            };
			
			set < Id > projIdSet = new set < Id > {
                projectList[1].Id, projectList[2].Id , projectList[3].Id
             };
            
            
            System.assertEquals(3 ,[Select count() from IPM_Project__c where Id IN : projIdSet ],'Failed to insert project  records.') ;

            projectList[4].BET__c = betRecords[1].Id;
            projectList[4].IPM_Project_Name__c = TEST_PROJECT09;
            projectList[4].IPMProject_Span__c = Regional;
            projectList[4].IPM_Parent_Project__c = projectList[1].id;
            projectList[4].IPM_Project_Leader__c = UserInfo.getuserId();
            projectList[4].Deputy_Project_Leader__c = UserInfo.getuserId();
            projectList[4].IPM_Project_Type__c = Rollout;


            insert projectList[4];

            Test.stoptest();

        }

    }

    // Test method for method to Update BET Milestones DueDate after BET is associated/updated to IPM Project  
    private static testmethod void testupdateBETmilestones() {

        User testRunningUser = [Select Id, LastName from User where LastName = : USER_LAST_NAME
        limit 1];

        IPM_Project__c proj0 = [Select Id, BET__c, IPM_Project_Type__c, IPM_GateKeeping_Model__c, IPMProject_Span__c, IPM_Phase__c, IPM_CompanyCardText__c, IPM_Project_Job_Status__c, IPM_Target_Launch_Dates__c from IPM_Project__c where IPM_Project_Name__c = : TEST_PROJECT06
        limit 1];
        IPM_Project__c proj1 = [Select Id, BET__c, IPM_Project_Type__c, IPM_GateKeeping_Model__c, IPMProject_Span__c, IPM_Phase__c, IPM_CompanyCardText__c, IPM_Project_Job_Status__c, IPM_Target_Launch_Dates__c from IPM_Project__c where IPM_Project_Name__c = : TEST_PROJECT09
        limit 1];

        uw_BET__c betRecord = [Select id from uw_BET__c where name = : TEST_BET02
        limit 1];
        System.runAs(testRunningUser) {

            Test.StartTest();

            proj1.BET__c = null;
            update proj1;
            
            System.assertEquals(null, [Select BET__c from  IPM_Project__c where Id =:proj1.Id].BET__c , 'Failed to clear BET on project record');

            Map < string, ipm_project__c > mapProjBET = new Map < string, ipm_project__c > ();

            mapProjBET.put(proj0.id, proj0);
            mapProjBET.put(proj1.id, proj1);

            IPM_BETHelper.updateBETmilestones(mapProjBET);

            Test.StopTest();
        }

        system.assertEquals(BET_BETService.getBet(betRecord.id).FirstReleaseDueDate, [Select IPM_Due_Date__c from IPM_Milestone__c where IPM_Project__c = : proj0.id limit 1].IPM_Due_Date__c, 'BET Milestones DueDate updation failed ');
    }

    // Test method for method updateBETMilestoneMissOnProject 
    private static testmethod void testupdateBETMilestoneMissOnProject() {

        User testRunningUser = [Select Id, LastName from User where LastName = : USER_LAST_NAME
        limit 1];

        Map < id, list < IPM_Milestone__c >> mapProjectBETMS = new map < id, list < IPM_Milestone__c >> ();
        List < IPM_Milestone__c > IPMsam1 = IPM_TestFactory_Helper.createIPMMilestoneList(false, 2);
        List < IPM_Milestone__c > IPMsam2 = IPM_TestFactory_Helper.createIPMMilestoneList(false, 2);

        uw_BET__c betRecord1 = [Select id from uw_BET__c where name = : TEST_BET00  
        limit 1];
        uw_BET__c betRecord2 = [Select id from uw_BET__c where name = : TEST_BET01
        limit 1];


        IPM_Project__c proj0 = [Select Id, BET__c, IPM_Project_Type__c, IPM_GateKeeping_Model__c, IPMProject_Span__c, IPM_Phase__c, IPM_CompanyCardText__c, IPM_Project_Job_Status__c, IPM_Target_Launch_Dates__c from IPM_Project__c where IPM_Project_Name__c = : TEST_PROJECT00
        limit 1];
        IPM_Project__c proj1 = [Select Id, BET__c, IPM_Project_Type__c, IPM_GateKeeping_Model__c, IPMProject_Span__c, IPM_Phase__c, IPM_CompanyCardText__c, IPM_Project_Job_Status__c, IPM_Target_Launch_Dates__c from IPM_Project__c where IPM_Project_Name__c = : TEST_PROJECT01
        limit 1];

        proj0.BET__c = betRecord1.Id;
        proj1.BET__c = betRecord2.Id;
        update new List < IPM_Project__c > {
            proj0, proj1
        };
		
		System.assertEquals(2,[Select count() from IPM_Project__c  where ( ( Id =:proj0.Id AND BET__c =:betRecord1.Id ) OR ( Id =:proj1.Id AND BET__c =:betRecord2.Id)) ],'Failed to update project records.') ;


        System.runAs(testRunningUser) {

            for (IPM_Milestone__c ipmMilestone: IPMsam1) {
                ipmMilestone.IPM_Due_Date__c = Date.today() - 365;
                ipmMilestone.IPM_Name__c = Math.random() + IPM_ConstantUtils.BET_MS_FIRST_RELEASE ;
                ipmMilestone.IPM_Project__c = proj0.id;
                ipmMilestone.IPM_Type_of_Milestone__c = 'BET';
            }

            for (IPM_Milestone__c ipmMilestone: IPMsam2) {
                ipmMilestone.IPM_Due_Date__c = Date.today() - 365;
                ipmMilestone.IPM_Name__c = Math.random() + BET_MS_FINAL_RELEASE;
                ipmMilestone.IPM_Project__c = proj1.id;
            }

            List < IPM_Milestone__c > milestoneList = new List < IPM_Milestone__c > ();
            milestoneList.addAll(IPMsam1);
            milestoneList.addAll(IPMsam2); 

            insert milestoneList;

            mapProjectBETMS.put(proj0.id, IPMsam1);
            mapProjectBETMS.put(proj1.id, IPMsam2);

            Test.starttest();
            IPM_BETHelper.updateBETMilestoneMissOnProject(mapProjectBETMS);
            Test.stopTest();
            
            System.assertEquals([Select BET_First_Release_Missed__c, BET_Final_Release_Missed__c from IPM_project__c where id = : proj0.Id].BET_First_Release_Missed__c, true, ERROR_FAILED_TO_UPDATE_BET_MILESTONE);
            System.assertEquals([Select BET_First_Release_Missed__c, BET_Final_Release_Missed__c from IPM_project__c where id = : proj1.Id].BET_Final_Release_Missed__c, true, ERROR_FAILED_TO_UPDATE_BET_MILESTONE);

        }


    }


    //test method for method to reset BET Milestone date missed alert 
    private static testmethod void testresetMilestoneMissedFlag() {

        User testRunningUser = [Select Id, LastName from User where LastName = : USER_LAST_NAME
        limit 1];

        uw_BET__c betRecord1 = [Select id, name, Status__c, FinalReleaseDate__c, Final_Release_Due_Date__c, FirstReleaseDate__c, First_Release_Due_Date__c, Is_Archived__c, OwnerId, Category_Group__c, Product_Category__c, Brand_Position__c, Product_Brand__c from uw_BET__c where name = : TEST_BET02
        limit 1];

        uw_BET__c betRecord2 = [Select id, name, Status__c, FinalReleaseDate__c, Final_Release_Due_Date__c, FirstReleaseDate__c, First_Release_Due_Date__c, Is_Archived__c, OwnerId, Category_Group__c, Product_Category__c, Brand_Position__c, Product_Brand__c from uw_BET__c where name = : TEST_BET03
        limit 1];
        betRecord2.Status__c = FirstRelease;
        update betRecord2;
        
        System.assertEquals(FirstRelease , [Select Status__c from  uw_BET__c where  Id=: betRecord2.Id ].Status__c, 'Failed to update BET status') ;

        system.runAs(testRunningUser) {

            Test.startTest();

            IPM_Project__c proj0 = [Select Id, BET__c, IPM_Project_Type__c, IPM_GateKeeping_Model__c, IPMProject_Span__c, IPM_Phase__c, IPM_CompanyCardText__c, IPM_Project_Job_Status__c, IPM_Target_Launch_Dates__c from IPM_Project__c where IPM_Project_Name__c = : TEST_PROJECT06
            limit 1];
            IPM_Project__c proj1 = [Select Id, BET__c, IPM_Project_Type__c, IPM_GateKeeping_Model__c, IPMProject_Span__c, IPM_Phase__c, IPM_CompanyCardText__c, IPM_Project_Job_Status__c, IPM_Target_Launch_Dates__c from IPM_Project__c where IPM_Project_Name__c = : TEST_PROJECT09
            limit 1];

            BET_BETWrapper betWrap1 = (BET_BETwrapper) BET_BETService.getBet(betRecord1.id);
            BET_BETWrapper betWrap2 = (BET_BETwrapper) BET_BETService.getBet(betRecord2.id);

            IPM_BETHelper.resetMilestoneMissedFlag(betRecord1.id, betWrap1);
            IPM_BETHelper.resetMilestoneMissedFlag(betRecord2.id, betWrap2);

            Test.stopTest();

            System.assertEquals([Select BET_First_Release_Missed__c from IPM_project__c where id = : proj0.Id].BET_First_Release_Missed__c, false, 'Failed to reset BET_First_Release_Missed.');
            System.assertEquals([Select BET_Final_Release_Missed__c from IPM_project__c where id = : proj1.Id].BET_Final_Release_Missed__c, false, 'Failed to reset BET_Final_Release_Missed.');

        }


    }


    //Test method for setArchiveBET_IPM method

    private static testmethod void testsetArchiveBET_IPM() {

        User testRunningUser = [Select Id, LastName from User where LastName = : USER_LAST_NAME
        limit 1];

        uw_BET__c betRecord1 = [Select id, name, Status__c, FinalReleaseDate__c, Final_Release_Due_Date__c, FirstReleaseDate__c, First_Release_Due_Date__c, Is_Archived__c, OwnerId, Category_Group__c, Product_Category__c, Brand_Position__c, Product_Brand__c from uw_BET__c where name = : TEST_BET02
        limit 1];

        system.runAs(testRunningUser) {

            BET_BETWrapper betWrap1 = (BET_BETwrapper) BET_BETService.getBet(betRecord1.id);

            Test.StartTest();

            IPM_BETHelper.setArchiveBET_IPM(betWrap1);

            Test.StopTest();
        }
        IPM_Project__c testRetrieveProj = [select id, BET_Archived_BET_Text__c, BET_Archive_Status__c, BET_Archived_BET__c from IPM_Project__c where bet__c = : betRecord1.Id limit 1];

        system.assertEquals(testRetrieveProj.BET_Archived_BET__c, betRecord1.Id, ERROR_FAILED_TO_ARCHIVE);
        system.assertEquals(testRetrieveProj.BET_Archived_BET_Text__c, betRecord1.Name, ERROR_FAILED_TO_ARCHIVE);
        system.assertEquals(testRetrieveProj.BET_Archive_Status__c, betRecord1.Status__c, ERROR_FAILED_TO_ARCHIVE);

    }


    //test method for method to send Regional/Local Rollout Leaders' Access Request to BET after BET First Release    
    private static testmethod void testsendBETAccessRequestonFirstRelease() {

        User testRunningUser = [Select Id, LastName from User where LastName = : USER_LAST_NAME
        limit 1];

        uw_BET__c betRecord1 = [Select id, name, Status__c, FinalReleaseDate__c, Final_Release_Due_Date__c, FirstReleaseDate__c, First_Release_Due_Date__c, Is_Archived__c, OwnerId, Category_Group__c, Product_Category__c, Brand_Position__c, Product_Brand__c from uw_BET__c where name = : TEST_BET01
        limit 1];
        
        IPM_Project_Resource__c PrjctResrc1 = [select IPM_User__c from IPM_Project_Resource__c where IPM_Role_Type__c = :IPM_Role_BD
        LIMIT 1];
        
        System.runAs(testRunningUser) { 

            Test.StartTest();
            IPM_BETHelper.sendBETAccessRequestonFirstRelease(betRecord1.Id);  
            Test.StopTest();

            System.assertEquals([Select UserId__c from BET_Member_Request__c where Brand_Experience_Toolkit__c = : betRecord1.Id limit 1].UserId__c, PrjctResrc1.IPM_User__c, 'Failed to send Regional/Local Rollout Leader Access Request to BET');
        }
    }

    //test method for method to send Regional/Local Rollout Leaders' Access Request to BET after BET First Release    
    private static testmethod void testsendBETAccessRequest() {

        User testRunningUser = [Select Id, LastName from User where LastName = : USER_LAST_NAME
        limit 1];

        uw_BET__c betRecord1 = [Select id, name, Status__c, FinalReleaseDate__c, Final_Release_Due_Date__c, FirstReleaseDate__c, First_Release_Due_Date__c, Is_Archived__c, OwnerId, Category_Group__c, Product_Category__c, Brand_Position__c, Product_Brand__c from uw_BET__c where name = : TEST_BET02
        limit 1];

        IPM_Project__c proj0 = [Select Id, BET__c, IPM_Project_Type__c, IPM_GateKeeping_Model__c, IPMProject_Span__c, IPM_Phase__c, IPM_CompanyCardText__c, IPM_Project_Job_Status__c, IPM_Target_Launch_Dates__c from IPM_Project__c where IPM_Project_Name__c = : TEST_PROJECT06
        limit 1];

        system.runAs(testRunningUser) {

            Test.StartTest();

            IPM_BETHelper.sendBETAccessRequest(new list < id > {
                UserInfo.getUserId()
            }, betRecord1.id, proj0.id);

            Test.StopTest();
        }
        BET_Member_Request__c betMember = [Select Project_Id__c, Bet_owner__c from BET_Member_Request__c where Project_Id__c = : proj0.Id limit 1];
        
        system.assertEquals(betMember.Project_Id__c, proj0.Id, 'Failed to update project Id on BET Member');

        system.assertEquals(betMember.Bet_owner__c, BET_BETService.getBet(betRecord1.Id).BetOwner, 'Failed to update BET owner');

    }

    private static testmethod void testsendRolloutMemberBETAccessRequest() {

        User testRunningUser = [Select Id, LastName from User where LastName = : USER_LAST_NAME
        limit 1];
        Map < id, set < IPM_Project_Resource__c >> mapProjResources = new Map < id, set < IPM_Project_Resource__c >> ();
        map < string, id > mapProjId = new map < string, id > ();
        set < string > setNames = new set < string > {
            TEST_PROJECT09, TEST_PROJECT06, TEST_PROJECT07, TEST_PROJECT02, TEST_PROJECT03, TEST_PROJECT05, 'TestPrj07', 'TestPrj08'
        };
        for (IPM_Project__c proj: [Select id, IPM_Project_Name__c from IPM_Project__c where IPM_Project_Name__c in : setNames]) {
            mapProjId.put(proj.IPM_Project_Name__c, proj.id);
        }

        system.runAs(testRunningUser) {

            Test.starttest();

            IPM_Project_Resource__c PrjctResrc1 = new IPM_Project_Resource__c();
            PrjctResrc1.IPM_User__c = UserInfo.getuserId();
            PrjctResrc1.IPM_Role_Type__c = IPM_Role_CD;

            PrjctResrc1.IPM_Project__c = mapProjId.get(TEST_PROJECT02);

            IPM_Project_Resource__c PrjctResrc2 = new IPM_Project_Resource__c();
            PrjctResrc2.IPM_User__c = UserInfo.getuserId();
            PrjctResrc2.IPM_Role_Type__c = IPM_Role_CD;

            PrjctResrc2.IPM_Project__c = mapProjId.get(TEST_PROJECT03);

            IPM_Project_Resource__c PrjctResrc3 = new IPM_Project_Resource__c();
            PrjctResrc3.IPM_User__c = UserInfo.getuserId();
            PrjctResrc3.IPM_Role_Type__c = IPM_Role_BD;

            PrjctResrc3.IPM_Project__c = mapProjId.get(TEST_PROJECT09);


            IPM_Project_Resource__c PrjctResrc4 = new IPM_Project_Resource__c();
            PrjctResrc4.IPM_User__c = UserInfo.getuserId();
            PrjctResrc4.IPM_Role_Type__c = IPM_Role_BD;

            PrjctResrc4.IPM_Project__c = mapProjId.get(TEST_PROJECT06);

            IPM_Project_Resource__c PrjctResrc5 = new IPM_Project_Resource__c();
            PrjctResrc5.IPM_User__c = UserInfo.getuserId();
            PrjctResrc5.IPM_Role_Type__c = IPM_Role_BD;

            PrjctResrc5.IPM_Project__c = mapProjId.get(TEST_PROJECT07);


            IPM_Project_Resource__c PrjctResrc6 = new IPM_Project_Resource__c();
            PrjctResrc6.IPM_User__c = UserInfo.getuserId();
            PrjctResrc6.IPM_Role_Type__c = IPM_Role_CD;

            PrjctResrc6.IPM_Project__c = mapProjId.get(TEST_PROJECT05);



            insert new List < IPM_Project_Resource__c > {
                PrjctResrc1, PrjctResrc2, PrjctResrc3, PrjctResrc4, PrjctResrc5, PrjctResrc6
            };
			
			set < Id > resourceId = new set < Id > {
             PrjctResrc1.Id , PrjctResrc2.Id , PrjctResrc3.Id , PrjctResrc4.Id , PrjctResrc5.Id , PrjctResrc6.Id 
            };
			
			System.assertEquals(6,[Select count() from IPM_Project_Resource__c  where Id IN : resourceId] ,'Failed to insert project resources.');


            mapProjResources.put(mapProjId.get(TEST_PROJECT09), new Set < IPM_Project_Resource__c > {
                PrjctResrc4
            });

            mapProjResources.put(mapProjId.get(TEST_PROJECT07), new Set < IPM_Project_Resource__c > {
                PrjctResrc5, PrjctResrc3, PrjctResrc4
            });


            mapProjResources.put(mapProjId.get(TEST_PROJECT06), new Set < IPM_Project_Resource__c > {
                PrjctResrc3, PrjctResrc4, PrjctResrc5
            });

            mapProjResources.put(mapProjId.get(TEST_PROJECT05), new Set < IPM_Project_Resource__c > {
                PrjctResrc6
            });
            mapProjResources.put(mapProjId.get(TEST_PROJECT02), new Set < IPM_Project_Resource__c > {
                PrjctResrc1
            });
            mapProjResources.put(mapProjId.get(TEST_PROJECT03), new Set < IPM_Project_Resource__c > {
                PrjctResrc2
            });


            IPM_BETHelper.sendRolloutMemberBETAccessRequest(mapProjResources);

            Test.StopTest();

            system.assertEquals([select UserId__c from BET_Member_Request__c where UserId__c = : UserInfo.getUserId() limit 1].UserId__c, PrjctResrc3.IPM_User__c, 'BET Access Request  not sent.');

        }

    }

    //test method for method to update Phase of BET Final Release Milestone
    private static testmethod void testupdatePhaseBETMSFinalRelease() {

        
        User testRunningUser = [Select Id, LastName from User where LastName = : USER_LAST_NAME
        limit 1];
        Test.StartTest(); 
        List < IPM_Milestone__c > IPMsam1 = IPM_TestFactory_Helper.createIPMMilestoneList(false, 2);
        
        uw_BET__c betRecord1 = [Select id, name, Status__c, FinalReleaseDate__c, Final_Release_Due_Date__c, FirstReleaseDate__c, First_Release_Due_Date__c, Is_Archived__c, OwnerId, Category_Group__c, Product_Category__c, Brand_Position__c, Product_Brand__c from uw_BET__c where name = : TEST_BET03
        limit 1];
        betRecord1.Status__c = 'Unreleased';
        update betRecord1;
		
		System.assertEquals( betRecord1.Status__c ,[Select Status__c from uw_BET__c where Id =: betRecord1.Id ].Status__c,'Failed to update BET record');

        system.runAs(testRunningUser) {

            IPM_Project__c proj0 = [Select Id, BET__c, IPM_Project_Type__c, IPM_GateKeeping_Model__c, IPMProject_Span__c, IPM_Phase__c, IPM_CompanyCardText__c, IPM_Project_Job_Status__c, IPM_Target_Launch_Dates__c from IPM_Project__c where IPM_Project_Name__c = : TEST_PROJECT06
            limit 1];

            for (IPM_Milestone__c ipmMilestone: IPMsam1) {
                ipmMilestone.IPM_Due_Date__c = Date.today() - 365;
                ipmMilestone.IPM_Project__c = proj0.id;
                ipmMilestone.IPM_Type_of_Milestone__c = IPM_ConstantUtils.STRING_BET;
                ipmMilestone.IPM_Name__c = Math.random()+BET_MS_FINAL_RELEASE;
                ipmMilestone.IPM_Phase__c = null;
            }
               
            insert IPMsam1;

            IPM_BETHelper.updatePhaseBETMSFinalRelease(betRecord1.Id);

            System.assertEquals([Select IPM_Phase__c from IPM_Milestone__c where Id = : IPMsam1[0].id OR Id = : IPMsam1[1].id limit 1].IPM_Phase__c, proj0.IPM_Phase__c, 'Failed to update milestone phase');
            
            Test.StopTest();
        }
    }


    //testmethod for method to send updates to BET on Project update in IPM
    private static testmethod void testsendIPMupdatetoBET() {

        User testRunningUser = [Select Id, LastName from User where LastName = : USER_LAST_NAME
        limit 1];

        uw_BET__c betRecord1 = [Select id, name, Status__c, FinalReleaseDate__c, Final_Release_Due_Date__c, FirstReleaseDate__c, First_Release_Due_Date__c, Is_Archived__c, OwnerId, Category_Group__c, Product_Category__c, Brand_Position__c, Product_Brand__c from uw_BET__c where name = : TEST_BET03
        limit 1];

        IPM_Project__c proj0 = new IPM_Project__c();
        IPM_Project__C proj1 = new IPM_Project__c();
        set<string> setProjnames = new set<string>();
        setProjnames.add(TEST_PROJECT06);
        setProjnames.add(TEST_PROJECT09);
        for (IPM_Project__C proj: [Select Id, IPM_Project_Name__c, BET__c, IPM_Project_Type__c, IPM_GateKeeping_Model__c, IPMProject_Span__c, IPM_Phase__c, IPM_CompanyCardText__c, IPM_Project_Job_Status__c, IPM_Target_Launch_Dates__c from IPM_Project__c where IPM_Project_Name__c IN :setProjnames]) {
            if (proj.IPM_Project_Name__c == TEST_PROJECT06) {
                proj0 = proj;
            } else if (proj.IPM_Project_Name__c == TEST_PROJECT09) {
                proj1 = proj;
            }
        }

        betRecord1.IPM_Project__c = proj0.id;
        update betRecord1;
		
		System.assertEquals(proj0.id ,[Select  IPM_Project__c from uw_BET__c where  Id =:betRecord1.Id].IPM_Project__c ,'Failed to update BET ');

        System.runAs(testRunningUser) {

            proj0.BET__c = betRecord1.Id;
            proj0.IPM_Target_Launch_Dates__c = Date.Today();

            proj1.BET__c = betRecord1.Id;
            proj1.IPM_Target_Launch_Dates__c = Date.Today() + 20;

            Test.StartTest();

            update new List < IPM_Project__c > {
                proj0, proj1
            };

            IPM_BETHelper.sendIPMupdatetoBET(new List < IPM_Project__c > {
                proj0
            }, new List < IPM_Project__c > {
                proj1
            });

            Test.StopTest();
            
			System.assertEquals(2,[Select  count()  from IPM_Project__c where  BET__c =:betRecord1.Id AND (Id=:proj0.Id OR Id=:proj1.Id)] , 'Failed to update project records . ');
            
            System.assertEquals(BET_BETService.getBet(proj0.BET__c).targetLaunchDate, proj0.IPM_Target_Launch_Dates__c, 'Failed to send updates to BET on Project update in IPM');
        }
    }
    
    //test Method to  test updation of  bet on project after phase change 
    static testMethod void testupdateBETlinktoProject() {
    	
        User testRunningUser = [Select Id, LastName from User where LastName = : USER_LAST_NAME  limit 1];

        uw_BET__c betRecord1 = [Select Id from uw_BET__c where name = : TEST_BET02  limit 1];
        
        IPM_Project__c proj1 = [Select Id, BET__c from IPM_Project__c where IPM_Project_Name__c = : TEST_PROJECT06  limit 1];   
            
             System.runAs(testRunningUser) {
             Test.StartTest();
             IPM_BETHelper.updateBETlinktoProject(betRecord1.Id,proj1.Id);  
             Test.StopTest();
             }
             
        System.assertEquals([Select BET__c from IPM_Project__c where Id =:proj1.Id ].BET__c,betRecord1.id,'Failed to update BET on project' ); 
      
    }
    
    
}