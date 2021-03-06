/*****************************************************************************
 *@Author:Cognizant
 *@Date:01/02/2015
 *@Description : To test IPM_ProjectResourceHandler class functionalities
 */
@isTest
private class IPM_ProjectResourceHandler_Test {
    private static IPM_Project_Resource__c projectRes;
    private static IPM_Project_Resource__c projectRes1;
    private static IPM_Project_Resource__c projectRes2;
    private static List<IPM_Project__c> projectList;
    private Static final String MANAGER_ACCESS = IPM_ConstantUtils.BET_MANAGER_ACCESS;
    private Static final String BD_ROLE_TYPE = 'BD';
    private static User platformUser;
    private static List<IPM_Company_Card__c> companyCardList;
    
    /***********************************
      Description of the purpose of the method. 
      @name: projectSetUpData
      @Description: To create test data 
    ***********************************/
    
    @testSetup static void projectSetUpData() 
     {
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(false)){
            platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            
        }
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comnyList=[SELECT ID FROM IPM_Company_Card__c LIMIT 3];
        system.assertEquals(comnyList.size(),3,comnyList.size()+ 'company cards got created');
        
        IPM_TestFactory_Helper.getProjectMasterData();
         
         projectList = IPM_TestFactory_Helper.projectSetUp(20,platformUser);
         Integer i=0;
         System.runAs(platformUser)
         {
           for(IPM_Project__c proj : projectList){
            proj.First_Sync_To_EcoDesign__c = true;
            proj.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            proj.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
            proj.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            proj.IPM_CompanyCardText__c = 'Global Company Card';
            proj.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
            proj.Name = 'test'+i;
            proj.IPM_Project_Name__c = 'test'+i++;
          }
           insert projectList;
         }
         List<IPM_Project__c> dbProjectlist = [SELECT ID FROM IPM_Project__c WHERE First_Sync_To_EcoDesign__c=true];
           
         system.assertEquals(dbProjectlist.size(),20,'Projects are created');

      }
    
   

    
    /****************************************************************
     *@Description :testmethod to test the dml operation performed on IPM_ProjectResourceHandler object (Insert update) and the consequent change invocation of trigger contexts.
     * Ecodesign_Sync_status is set to true for the project for which project resource is inserted
     ****************************************************************/
    static testMethod void testProjResourceHandlerDML() {

        test.starttest();
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        System.runAs(globalUser) {
            
            List<IPM_Project__c> projList = [Select id from IPM_Project__c Limit 1000];
            
            projectRes = IPM_TestFactory_Helper.createIPMProjectResource(projList[0].id, false);
            projectRes.IPM_Role_Type__c = 'Finance';
            insert projectRes;
            
            List<IPM_Project_Resource__c>finList=[SELECT ID,IPM_Role_Type__c FROM IPM_Project_Resource__c WHERE id=:projectRes.id LIMIT 1];
            system.assertEquals(finList[0].IPM_Role_Type__c,projectRes.IPM_Role_Type__c,'User role type is'+finList[0].IPM_Role_Type__c);//positive test
            
            
            projectRes1 = IPM_TestFactory_Helper.createIPMProjectResource(projList[0].id, false);
            projectRes1.IPM_Role_Type__c = BD_ROLE_TYPE;
            projectRes1.Id = projectRes.Id;
            projectRes.IPM_User__c = userInfo.getUserId();
            update projectRes1;
            
            List<IPM_Project_Resource__c>bdList=[SELECT ID,IPM_Role_Type__c FROM IPM_Project_Resource__c WHERE id=:projectRes1.id LIMIT 1];
            system.assertEquals(bdList[0].IPM_Role_Type__c,BD_ROLE_TYPE,'User role type is'+bdList[0].IPM_Role_Type__c);//positive test
            
            
            projectRes2 = IPM_TestFactory_Helper.createIPMProjectResource(projList[0].id, false);
            projectRes2.IPM_Role_Type__c = BD_ROLE_TYPE;
            projectRes.IPM_User__c = userInfo.getUserId();
            insert projectRes2;
            
            List<IPM_Project_Resource__c>bdUList=[SELECT ID,IPM_Role_Type__c FROM IPM_Project_Resource__c WHERE id=:projectRes2.id LIMIT 1];
            system.assertEquals(bdUList[0].IPM_Role_Type__c,BD_ROLE_TYPE,'User role type is'+bdUList[0].IPM_Role_Type__c);//positive test
            
            delete projectRes2;
            List<IPM_Project_Resource__c>bdDeleteList=[SELECT ID,IPM_Role_Type__c FROM IPM_Project_Resource__c WHERE id=:projectRes2.id LIMIT 1];
            system.assertEquals(bdDeleteList.isEmpty(),true,'project resource record got deleted');//positive test
            
            IPM_ProjectResourceHandler ipmPR = new IPM_ProjectResourceHandler();
            ipmPR.afterInsert(projectRes);
            ipmPR.afterUpdate(projectRes1, projectRes);
            IPM_Project__c proj = [Select Id, EcoDesign_Sync_Status__c, IPM_Exists_AtLeast_OneAssmntPerEICountry__c, First_Sync_To_EcoDesign__c from IPM_Project__c limit 1000][0];
            system.assertEquals(true, proj.First_Sync_To_EcoDesign__c, 'First_Sync_To_EcoDesign__c Is Checked');
        }
        test.stoptest();

    }
    
    /*********************************************************************************************************************************
     *@Description : Method  to test sendRolloutMemberBETAccessRequest method, this checks if member requests are successfully created
     *********************************************************************************************************************************/
   static testMethod void sendRolloutMemberBETAccessRequesttest() {

        test.loadData(IPM_BET_Search_Fields__c.sobjectType, 'IPM_BET_Search_Test');  
        
        projectList = IPM_TestFactory_Helper.createIPMProjectList(false, 5);
        User runningUser =IPM_TestFactory_Helper.returnPlatformUser();
        
        uw_BET__c betRecord1 = BET_TestUtils.getTestBet();
        betRecord1.Status__c = 'Final Release';
        betRecord1.FinalReleaseDate__c = Date.Today() + 365;
        betRecord1.Name = 'Bet1';
        insert betRecord1 ;
        List<uw_BET__c>betList=[SELECT ID,Name FROM uw_BET__c WHERE id=:betRecord1.id LIMIT 1];
        system.assertEquals(betList[0].Name,betRecord1.Name,'Bet name is:'+betList[0].Name);
        
        IPM_Project__c parentProj = projectList[4];
        parentProj.ownerId = runningUser.id;
        parentProj.Deputy_Project_Leader__c = runningUser.id;
        parentProj.IPM_Project_Name__c = 'testParentProj';
        parentProj.IPM_Project_Leader__c = runningUser.id; 
        insert parentProj;
        Test.StartTest();
        List<IPM_Project__c>parentPList=[SELECT IPM_Project_Name__c FROM IPM_Project__c WHERE id=:parentProj.id  LIMIT 1];
        system.assertEquals(parentPList[0].IPM_Project_Name__c,parentProj.IPM_Project_Name__c,'Project name is:'+parentPList[0].IPM_Project_Name__c);
        
        list < BET_BETWrapper.MemberRequest > lstMemberRequests = new list < BET_BETWrapper.MemberRequest > ();
        
        //Giving access to BET
        BET_BETWrapper.MemberRequest member = new BET_BETWrapper.MemberRequest();
        member.UserId = runningUser.Id;
        member.AccessLevel = MANAGER_ACCESS;
        lstMemberRequests.add(member);
        BET_AccessService.RequestAccess(lstMemberRequests, betRecord1.Id, parentProj.id);
        
        System.runAs(runningUser) {
                        
            projectList[0].BET__c = betRecord1.Id;
            projectList[0].IPM_Project_Job_Status__c = 'Completed';
            
            projectList[1].BET__c = betRecord1.Id;
            projectList[1].IPM_Project_Name__c = 'testPrjct1';
            projectList[1].IPM_Project_Leader__c = UserInfo.getuserId();
            projectList[1].Deputy_Project_Leader__c = UserInfo.getuserId();
            
            insert  new List<IPM_Project__c> {projectList[0],projectList[1]};
            
            List<IPM_Project__c>betPList=[SELECT IPM_Project_Name__c FROM IPM_Project__c WHERE BET__c=: betRecord1.Id  LIMIT 2];
            system.assertEquals(betPList.size(),2,'BET Projects got created');
        
            
            projectList[2].IPM_Project_Name__c = 'testPrjct2';
            projectList[2].IPM_Parent_Project__c = projectList[1].id;
            projectList[2].IPM_Project_Type__c = 'Rollout';
            projectList[2].IPMProject_Span__c = 'Regional';
        
            projectList[3].IPM_Project_Name__c = 'testPrjct3';
            projectList[3].IPM_Parent_Project__c = projectList[0].id;
            projectList[3].IPM_Project_Type__c = 'Rollout';
            projectList[3].IPMProject_Span__c = 'Local';
        
            insert new List < IPM_Project__c > {
                            projectList[2], projectList[3]
            };
            
            List<IPM_Project__c>regionalPList=[SELECT IPM_Project_Name__c FROM IPM_Project__c WHERE id=: projectList[2].id  LIMIT 1];
            system.assertEquals(regionalPList[0].IPM_Project_Name__c,projectList[2].IPM_Project_Name__c,'project name is:'+regionalPList[0].IPM_Project_Name__c);
        
            
            List<IPM_Project_Resource__c> prjResrcList= IPM_TestFactory_Helper.createIPMProjectResourceList(false,2);
            Test.StopTest();
            prjResrcList[0].IPM_User__c = UserInfo.getuserId();
            prjResrcList[0].IPM_Role_Type__c = BD_ROLE_TYPE;
            prjResrcList[0].IPM_Project__c = projectList[3].id;
        
            prjResrcList[1].IPM_User__c = UserInfo.getuserId();
            prjResrcList[1].IPM_Role_Type__c = BD_ROLE_TYPE;
            prjResrcList[1].IPM_Project__c = projectList[2].id;
            
            
            insert prjResrcList ;
            
            
            system.assertEquals([select UserId__c from BET_Member_Request__c limit 1].UserId__c, UserInfo.getuserId(), 'BET Access Request  not sent.');
            system.assertEquals([Select Count() from BET_Member_Request__c limit 1000], 3, 'Failed to generate BET Member Request');
        }


    }

}