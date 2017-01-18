/*******************************************************
 * @Description: Test class for IPM_HomePageController
 * @Author:Cognizant
 * @Date:05/08/2015
 * *****************************************************/

@istest
private class IPM_HomePageController_Test{
     
    private static User platformUser;
    private static IPM_Project__c eachProject;
    private static final String LOCAL_PROJECTNAME = 'Test Local';
    private static final String REGIONAL_PROJECTNAME = 'Test Regional';
    private static List<IPM_Project__c> lstLocalProjects;
    private static List<IPM_Project__c> projectList;
    private static final String PROJ_CREATED='Projects are not created';
    private static Set<Id> iDs ;
    private static final String FINANCIALS_MISALIGNED = 'Financials are not misaligned';
    private static final String MILESTONE_CREATED='Milestone is not created';
    private static final String GLOBAL_PL_USER = 'GLOBAL_PL';
    private static final String REGIONAL_PL_USER = 'REGIONAL_PL';
    /***********************************
    * @Description: Test Data Creation
    * *********************************/
   
     /**
        *  Used for Setting test Data for Project Creation . 
        *  @name projectSetUp
    */
    
     @testSetup static void projectSetUp() 
     {
         // Create an instance of admin user.
         User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
         iDs = new Set<ID>();
         
         User globalProjectLeader = null;
         // Create an instances of standard Users for Allocation to Project Leaders.
         System.runAs(adminUser)
         {   
            globalProjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            User regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            
            // Update LastNames to match functionalRoles
            globalProjectLeader.lastname = GLOBAL_PL_USER;
            regionalProjectLeader.lastname = REGIONAL_PL_USER;
            
            List<User> userList = new List<User>{globalProjectLeader,regionalProjectLeader};
            update userList;
            System.assertEquals(2 , [Select count() from User where Id IN (:globalProjectLeader.Id, :regionalProjectLeader.Id) limit 100] , 'Users are not updated successfully.');
            
            // Create Company Card information(Master Data)
            IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
            IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
            
            List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard};
            insert companyCardList;
            for(IPM_Company_Card__c eachCompanyCard : companyCardList) {
              iDs.add(eachCompanyCard.Id);
            }
            System.assertEquals(2, [Select count() from IPM_Company_Card__c where id in:iDs],'Company Cards are not created');
          
            
            // Inserting Master Data whose OWD are set to readOnly/View All    
            IPM_TestFactory_Helper.getProjectMasterData();
            
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalProjectLeader}); 
        }   
        
        // Insert the project as a Global project Leader.
        System.runAs(globalProjectLeader)
        {   
            
            projectList = IPM_TestFactory_Helper.projectSetUp(3,globalProjectLeader);
            insert projectList;
            iDs.clear();
            for(IPM_Project__c eachProj : projectList) {
             iDs.add(eachProj.Id);
            }
            System.assertEquals(3, [Select count() from IPM_Project__c where id in:iDs],PROJ_CREATED);
          
        }
     }    
     
      
        
        
        
        
        
            
            
             
            
            
            
            
            
            
            
            
            
            
            
            
        
            
            
                
            
             
            
                
            
            
            
            
            
            
            
          
                
            
                
                 
            
    /**
    *  To test the TLD Misaligned and business case saved alerts
    *  @name :testTLDMisalignedBusinessCaseSavedAlerts
    *  @param : nil
    *  @return : nil 
    */   
    private static testmethod void testTLDMisalignedBusinessCaseSavedAlerts(){
        iDs = new Set<ID>();
        //Creation test user
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
        
        test.startTest();
        system.runAs(platformUser)
        {
        
        IPM_Project__c globalProj = IPM_TestFactory_Helper.createIPMProject(true);
        
        List<IPM_Project__c> regionalProjs = new List<IPM_Project__c>();
        //Create regional projects
        for(Integer i=0; i<5; i++){
            eachProject = IPM_TestFactory_Helper.createIPMProject(false);
            eachProject.IPM_Project_Name__c = REGIONAL_PROJECTNAME+i;
            eachProject.IPM_Project_Leader__c = platformUser.Id;
            eachProject.IPM_Project_Type__c =IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            eachProject.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            eachProject.IPM_Parent_Project__c = globalProj.Id;
            eachProject.IPM_Target_Launch_Dates__c = System.today() + 10;
            regionalProjs.add(eachProject);
        }
        insert regionalProjs;
        iDs.clear();
        for(IPM_Project__c eachProj : regionalProjs) {
            iDs.add(eachProj.Id);
        }
        System.assertEquals(5, [Select count() from IPM_Project__c where id in:iDs],'Regional projects are not created');
        
        lstLocalProjects = new List<IPM_Project__c>();
        //Create local projects
        for(Integer i=0; i<5; i++){
            eachProject = IPM_TestFactory_Helper.createIPMProject(false);
            eachProject.IPM_Project_Name__c = LOCAL_PROJECTNAME+i;
            eachProject.IPM_Project_Leader__c = platformUser.Id;
            eachProject.IPM_Project_Type__c =IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            eachProject.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            eachProject.IPM_Parent_Project__c = regionalProjs[i].Id;
            eachProject.IPM_Target_Launch_Dates__c = System.today() + 9;
            eachProject.Rollout_Plan_Target_Launch_Date__c = System.today() + 11;
            lstLocalProjects.add(eachProject);
        }   
        insert lstLocalProjects;
        iDs.clear();
        for(IPM_Project__c eachProj : lstLocalProjects) {
            iDs.add(eachProj.Id);
        }
        System.assertEquals(5, [Select count() from IPM_Project__c where id in:iDs],'Local projects are not created');
        
        Id recordtypeid = null;
        if(Schema.Sobjecttype.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.IPMProjectMilestones).getRecordTypeId() != null){
               recordtypeid=Schema.Sobjecttype.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.IPMProjectMilestones).getRecordTypeId();
        }
        
        IPM_Milestone__c testMilestone = IPM_TestFactory_Helper.createIPMMilestone(regionalProjs[0].Id, false);
        testMilestone.IPM_Due_Date__c =  System.today()+9;
        testMilestone.IPM_Planned_Date__c=System.today()+9 ;
        testMilestone.IPM_Type_of_Milestone__c = IPM_Utils.Standard;
        testMilestone.RecordTypeId = recordtypeid;    
        insert testMilestone;
        System.assertEquals(1, [Select count() from IPM_Milestone__c where id =: testMilestone.id],MILESTONE_CREATED);
        
        IPM_Project_Rollout__c rollout = IPM_TestFactory_Helper.createIPMProjectRollout(false);
        rollout.Local_Project__c= lstLocalProjects[0].id;
        rollout.RecordTypeId = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).getRecordTypeId();
        rollout.Regional_Project__c =  regionalProjs[0].id;
        insert rollout;
        System.assertEquals(1, [Select count() from IPM_Project_Rollout__c where id =: rollout.id],'Rollout is not created');
        
        Id  financeMasterRecordType = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId();
        IPM_Financial__c testIPMFinancialConsolidated = IPM_TestFactory_Helper.createIPMFinancial(false);
        testIPMFinancialConsolidated.Parent_Project__c = globalProj.Id;
        testIPMFinancialConsolidated.Financial_External_ID__c = regionalProjs[0].Id + String.valueOf(System.now());
        testIPMFinancialConsolidated.Project_Sustainability_Period__c = '3';
        testIPMFinancialConsolidated.Regional_Project__c =regionalProjs[0].Id;
        testIPMFinancialConsolidated.RecordTypeId = financeMasterRecordType;
        testIPMFinancialConsolidated.Local_Project__c= lstLocalProjects[0].id;
        insert testIPMFinancialConsolidated;  
        System.assertEquals(1, [Select count() from IPM_Financial__c where id =: testIPMFinancialConsolidated.id], 'Financial is not created.');
       
        //Create Financial Year
        IPM_Financial_Year__c testFinancialYear = IPM_TestFactory_Helper.createIPMFinancialYear(false);
        testFinancialYear.IPM_Financial__c = testIPMFinancialConsolidated.Id;
        testFinancialYear.Gross_Profit_Regional__c = 0;
        insert testFinancialYear;
        System.assertEquals(1, [Select count() from IPM_Financial_Year__c where id =: testFinancialYear.id],'Financial Year is not created');
        IPM_User_Profile__c userPLProfile = IPM_TestFactory_Helper.createUserProfile(false);
            userPLProfile.IPM_User__c = userinfo.getuserid();
            userPLProfile.IPM_User_Function__c= IPM_ConstantUtils.TEAM_PROJECT_LEADER;
            insert userPLProfile;        
        IPM_HomePageController iHp = new IPM_HomePageController();
        
        for(String values:iHp.LstFinTLDMisalignedMessageMap.values())
        { 
            system.assert(values.contains(IPM_ConstantUtils.FIN_TLDMISALIGNED_ALERT1),FINANCIALS_MISALIGNED);
        }
        
        for(String values:iHp.BusinessCaseMessageMap.values())
        {
             system.assert(values.contains(Label.IPM_BusinessCaseAlert),'Alert is shown when business case is saved.');
        }  
       
       } 
       test.stopTest();
        
    }
     
    /**
    *  To test the project leader profile
    *  @name :testUserProfileLeader
    *  @param : nil
    *  @return : nil
    */  
    private static testmethod void testUserProfileLeader(){
        
        //Creation test user
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
        
        test.startTest();
        system.runAs(platformUser){
        IPM_User_Profile__c userPLProfile = IPM_TestFactory_Helper.createUserProfile(false);
        userPLProfile.IPM_User__c = userinfo.getuserid();
        userPLProfile.IPM_User_Function__c= IPM_ConstantUtils.TEAM_PROJECT_LEADER;
        insert userPLProfile;
        System.assertEquals(1, [Select count() from IPM_User_Profile__c where id =: userPLProfile.id],'PL user profile has not been set.');
        
        
        }
        test.stopTest();
            
    }
    
     /* 
     *  Test Home page Alert
   */
    
    private static testmethod void testHomePageAlerts()
     {   
         Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
         List<Id> globalProjectIdList = new List<Id>();
         iDs = new Set<ID>();
        // Get the newly created Projects from Database. 
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
         User globalProjectLeader = null;
         User regionalProjectLeader = null;
        // Get the list of user's for project leaders.
        List<User> userList = [Select Id,Name,lastName from User where LastName in(:GLOBAL_PL_USER,:REGIONAL_PL_USER)];  
        // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(userList); 
        for(User lUser  :userList)
        {
            if(lUser.lastName == GLOBAL_PL_USER)
            {
                globalProjectLeader = lUser;
            }
            if(lUser.lastName == REGIONAL_PL_USER)
            {
                regionalProjectLeader = lUser;
            }
        }  
        System.RunAs(globalProjectLeader)
        {
           projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c
                                                    from IPM_Project__c where Name in:projectNameSet];
            for(IPM_Project__c project : projectList)
            {
                projectMap.put(project.Id,project);
            } 
        }
           /******************************** Create Regional Rollouts for Created Global project ****************************************/
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{regionalProjectLeader,regionalProjectLeader,regionalProjectLeader});
            insert regionalRolloutList;
            iDs.clear();
            for(IPM_Project_Rollout__c eachRollout : regionalRolloutList) {
             iDs.add(eachRollout.Id);
            }
            System.assertEquals(6, [Select count() from IPM_Project_Rollout__c where id in:iDs],'Regional Rollouts are not created'); 
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
             /******************************** Initiate Phase Change and Regional Project Creation  ****************************************/
            Test.startTest();
             // Set GateKeeping Model as RCLT and start with Regional Project Creation.
            for(IPM_Project__c project : projectList)
            {
                project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
                project.IPM_ProjectGKM__c='GKM2';
            }  
            update projectList;
            for(IPM_Project__c project : projectList)
            {
                globalProjectIdList.add(project.Id);    
            }
            // Initiate Phase Change would result in Rollout Project Creation.
            List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(globalProjectIdList,globalProjectLeader); 
            update projectListPhaseChange;
            Test.stopTest();
            IPM_HomePageController iHp = new IPM_HomePageController();
            iHP.getTaskcountValue();
      } // End of testHomePageAlert
}