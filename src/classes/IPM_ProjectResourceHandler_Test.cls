/*****************************************************************************
 *@Author:Cognizant
 *@Date:01/02/2015
 *@Description : To test IPM_ProjectResourceHandler class functionalities
 */
@isTest
public class IPM_ProjectResourceHandler_Test {
    public static IPM_Project__c project;
    public static IPM_Project_Resource__c projectRes;
    public static IPM_Project_Resource__c projectRes1;
    public static IPM_Project_Resource__c projectRes2;

    /**************************************************************
     *@Description :testmethod to create project and resource
     */
	 
	/* 
    static void initializeData() {
        User globalUser = IPM_TestFactory_Helper.createUserAdmin(false);
        globalUser.email = 'globalUser@unilever.test.com';

        User testUser = IPM_TestFactory_Helper.createUserAdmin(false);
        testUser.email = 'testUser@unilever.test.com';
        insert testUser;

        project = IPM_TestFactory_Helper.createIPMProject(false);
        project.IPM_GateKeeping_Model__c = 'Both';
        insert project;

        projectRes = IPM_TestFactory_Helper.createIPMProjectResource(project.id, false);
        projectRes.IPM_Role_Type__c = 'Finance';
        //projectRes.IPM_User__c = projectRes.Id;
        insert projectRes;

        projectRes1 = IPM_TestFactory_Helper.createIPMProjectResource(project.id, false);
        projectRes1.IPM_Role_Type__c = 'BD';
        projectRes1.Id = projectRes.Id;
        projectRes.IPM_User__c = testUser.Id;
        update projectRes1;

        projectRes2 = IPM_TestFactory_Helper.createIPMProjectResource(project.id, false);
        projectRes2.IPM_Role_Type__c = 'BD';
        projectRes.IPM_User__c = testUser.Id;
        //projectRes2.id=projectRes.id;
        insert projectRes2;
        delete projectRes2;
    }
	*/
    /**************************************************************
     *@Description :testmethod to test dotest method
     */
	/* 
    static testMethod void dotest() {
        initializeData();
        test.starttest();
        User globalUser1 = IPM_TestFactory_Helper.createUserAdmin(false);
        globalUser1.email = 'globalUser@unilever.test.com';
        System.runAs(globalUser1) {
            PageReference pRef = new PageReference('/apex/IPM_ProjectResourceHandler?id=' + project.Id);
            Test.setCurrentPage(pRef);
            system.assert(pRef != null);
            IPM_ProjectResourceHandler ipmPR = new IPM_ProjectResourceHandler();
            ipmPR.afterInsert(projectRes);
            ipmPR.afterUpdate(projectRes1, projectRes);
            IPM_Project__c proj = [Select Id, EcoDesign_Sync_Status__c, existsAtLeastOneAssmntPerEICountry__c, First_Sync_To_EcoDesign__c from IPM_Project__c limit 1000][0];
            system.assertEquals(false, proj.First_Sync_To_EcoDesign__c, 'First_Sync_To_EcoDesign__c Is Checked');
        }
        test.stoptest();

    }

    static testMethod void sendRolloutMemberBETAccessRequesttest() {

        test.loadData(IPM_Project_Type__c.sobjectType, 'IPM_ProjectType');
        test.loadData(IPM_BET_Search_Fields__c.sobjectType, 'IPM_BET_Search_Test');

        IPM_Project__c project1 = IPM_TestFactory_Helper.createIPMProject(false);
        IPM_Project__c project2 = IPM_TestFactory_Helper.createIPMProject(false);
        IPM_Project__c project3 = IPM_TestFactory_Helper.createIPMProject(false);
        IPM_Project__c project4 = IPM_TestFactory_Helper.createIPMProject(false);

        User runningUser = IPM_TestFactory_Helper.createUser(false);

        uw_BET__c betRecord1 = BET_TestUtils.getTestBet();
        uw_BET__c betRecord2 = BET_TestUtils.getTestBet();
        uw_BET__c betRecord3 = BET_TestUtils.getTestBet();

        betRecord1.Status__c = 'Final Release';
        betRecord1.FinalReleaseDate__c = Date.Today() + 365;
        betRecord1.Name = 'TesttBet5';

        betRecord2.Status__c = 'Final Release';
        betRecord2.FinalReleaseDate__c = Date.Today() + 365;
        betRecord2.Name = 'TestttBet5';

        betRecord3.Status__c = 'First Release';
        betRecord3.FinalReleaseDate__c = Date.Today() + 365;
        betRecord3.Name = 'TestBet5';
        
        System.runAs(runningUser) {

        insert new List < uw_BET__c > {
            betRecord1, betRecord2, betRecord3
        };

        project1.BET__c = betRecord1.Id;
        project1.IPM_Project_Type__c = 'Rollout';
        project1.IPMProject_Span__c = 'Regional';
        project1.IPM_Project_Job_Status__c = 'Completed';
        insert project1;

        project2.BET__c = betRecord1.Id;
        project2.IPM_Project_Name__c = 'TestP5';
        project2.IPMProject_Span__c = 'Regional';
        project2.IPM_Parent_Project__c = project1.id;
        project2.IPM_Project_Leader__c = UserInfo.getuserId();
        project2.Deputy_Project_Leader__c = UserInfo.getuserId();
        project2.IPM_Project_Type__c = 'Rollout';
        insert project2;

        project3.BET__c = betRecord2.Id;
        project3.IPM_Project_Name__c = 'TestP6';
        project3.IPM_Parent_Project__c = project2.id;
        project3.IPM_Project_Type__c = 'Rollout';
        project3.IPMProject_Span__c = 'Regional';

        project4.BET__c = betRecord3.Id;
        project4.IPM_Project_Name__c = 'TestPryej';
        project4.IPM_Parent_Project__c = project1.id;
        project4.IPM_Project_Type__c = 'Rollout';
        project4.IPMProject_Span__c = 'Local';

        insert new List < IPM_Project__c > {
            project3, project4
        };

        IPM_Project_Resource__c PrjctResrc1 = IPM_TestFactory_Helper.createIPMProjectResource(project2.id, false);
        PrjctResrc1.IPM_User__c = UserInfo.getuserId();
        PrjctResrc1.IPM_Role_Type__c = 'BD';
        PrjctResrc1.IPM_Project__c = project4.id;

        IPM_Project_Resource__c PrjctResrc2 = IPM_TestFactory_Helper.createIPMProjectResource(project3.id, false);
        PrjctResrc2.IPM_User__c = UserInfo.getuserId();
        PrjctResrc2.IPM_Role_Type__c = 'BD';
        PrjctResrc2.IPM_Project__c = project3.id;

        
        Test.StartTest();
         insert new List < IPM_Project_Resource__c > { PrjctResrc1, PrjctResrc2 };
        Test.StopTest();
        
        system.assertEquals([select UserId__c from BET_Member_Request__c limit 1].UserId__c, UserInfo.getuserId(), 'BET Access Request  not sent.');
        system.assertEquals([Select Count() from BET_Member_Request__c limit 1000], 3, 'Failed to generate BET Member Request');

        
        }

    }
	*/

}