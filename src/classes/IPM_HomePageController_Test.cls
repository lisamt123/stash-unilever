/*******************************************************
 * @Description: Test class for IPM_HomePageController
 * @Author:Cognizant
 * @Date:05/08/2015
 * *****************************************************/

@istest
public class IPM_HomePageController_Test{
     
    private static User platformUser;
    private static IPM_Project__c eachProject;
    private static final String LOCAL_PROJECTNAME = 'Test Local';
    private static final String REGIONAL_PROJECTNAME = 'Test Regional';
    private static List<IPM_Project__c> lstLocalProjects;
    private static List<IPM_Project_Document__c> updatedDocument;
    private static final String PROJ_CREATED='Projects are not created';
    private static final String PLANNED_STR='The planned';
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
            
            List<IPM_Project__c> projectList = IPM_TestFactory_Helper.projectSetUp(3,globalProjectLeader);
            insert projectList;
            iDs.clear();
            for(IPM_Project__c eachProj : projectList) {
             iDs.add(eachProj.Id);
            }
            System.assertEquals(3, [Select count() from IPM_Project__c where id in:iDs],PROJ_CREATED);
          
        }
     }    
     
      
     /**
        *  Used for Testing home page alerts
        *  @name projectSetUp
     */
     private static testmethod void testHomePageAlerts()
     {
        iDs = new Set<ID>();
        // Get the newly created Projects from Database. 
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
        List<Id> globalProjectIdList = new List<Id>();
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        
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
            
            List<IPM_Project__c> projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c
                                                    from IPM_Project__c where Name in:projectNameSet];
            for(IPM_Project__c project : projectList)
            {
                projectMap.put(project.Id,project);
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
            }  
            
            update projectList;
            
            for(IPM_Project__c project : projectList)
            {
                globalProjectIdList.add(project.Id);    
            }
            
            for(IPM_Project__c project : [Select Id, IPM_GateKeeping_Model__c from IPM_Project__c where Id IN : globalProjectIdList limit 100])
            {
                System.assertEquals(IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT , project.IPM_GateKeeping_Model__c, 'Gatekeeping model is not updated properly.');
            }
            
            // Initiate Phase Change would result in Rollout Project Creation.
            List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(globalProjectIdList,globalProjectLeader); 
            
            update projectListPhaseChange;
            Test.stopTest();
            iDs.clear();
            
            for(IPM_Project__c project : projectListPhaseChange){
                iDs.add(project.Id);
            }
            for(IPM_Project__c project : [Select Id, IPM_Phase__c from IPM_Project__c where Id In : iDs limit 100])
                System.assertEquals( IPM_ConstantUtils.PHASE_FEASIBILITY,  project.IPM_Phase__c , 'Project phase has not been updated.');
            
            
            updatedDocument = new List<IPM_Project_Document__c>();
        
            for(IPM_Project_Document__c currDoc:[Select IPM_GateDocuments__c,IPM_Document_Status__c from IPM_Project_Document__c limit 1000])
            {
                if(currDoc.IPM_GateDocuments__c == IPM_ConstantUtils.CHARTER_GATE){
                currDoc.IPM_Document_Status__c =IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS;
            }
            updatedDocument.add(currDoc);
            }
            update updatedDocument;
            System.assertEquals(IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS , [Select Id, IPM_Document_Status__c from IPM_Project_Document__c limit 1000][0].IPM_Document_Status__c, 'Project Document Status has not been changed' );
            
            List<IPM_Project__c> dBRegionalProjects = [Select Id,Name,IPM_Phase__c,IPM_Parent_Project__c from IPM_Project__c where IPMProject_Span__c = 'Regional'];  
            
                
            Map<Id,IPM_Milestone__c>  mileStoneMap = new Map<Id,IPM_Milestone__c>([Select IPM_Project__r.BET_MS_First_Release_Date__c,RecordTypeId,Id,Name,IPM_Type_of_Milestone__c from IPM_Milestone__c limit 1000] );
            
            Id recordtypeid = null;
            if(Schema.Sobjecttype.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.IPMProjectMilestones).getRecordTypeId() != null){
                recordtypeid=Schema.Sobjecttype.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.IPMProjectMilestones).getRecordTypeId();
            }
             
            List<IPM_Milestone__c> updateMilestoneList = new List<IPM_Milestone__c>();
            List<IPM_Milestone__c> ipmMileStoneList = new List<IPM_Milestone__c>();
            
            for(IPM_Milestone__c eachMilestone: mileStoneMap.values())
            {
                if(eachMilestone.IPM_Type_of_Milestone__c == IPM_Utils.Standard && eachMilestone.RecordTypeId == recordtypeid)
                {
                    eachMilestone.IPM_Planned_Date__c=System.today()+5;
                    eachMilestone.IPM_Due_Date__c =  System.today()+5;
                    updateMilestoneList.add(eachMilestone);
                }
             }  
                
            update updateMilestoneList;
            iDs.clear();
            for(IPM_Milestone__c milestone : updateMilestoneList)
            {
                iDs.add(milestone.Id);
            }
            for(IPM_Milestone__c milestone : [Select Id, IPM_Due_Date__c from IPM_Milestone__c where Id IN : iDs limit 100])
                System.assertEquals(System.today()+5 , milestone.IPM_Due_Date__c , 'Milestone due dates are not updated properly.');
            
            
            IPM_Milestone__c dueDateTodayMilestone = IPM_TestFactory_Helper.createIPMMilestone(dBRegionalProjects[0].Id, false);
            dueDateTodayMilestone.RecordTypeId = recordtypeid;    
            dueDateTodayMilestone.IPM_Due_Date__c =  System.today();
            dueDateTodayMilestone.IPM_Planned_Date__c=System.today() ;
            dueDateTodayMilestone.IPM_Type_of_Milestone__c = IPM_Utils.Standard;
            dueDateTodayMilestone.IPM_Phase__c = IPM_ConstantUtils.FEASIBILITY_PHASE;
            ipmMileStoneList.add(dueDateTodayMilestone);
            
            IPM_Milestone__c pastMilestone = IPM_TestFactory_Helper.createIPMMilestone(dBRegionalProjects[0].Id, false);
            pastMilestone.RecordTypeId = recordtypeid;
            pastMilestone.IPM_Type_of_Milestone__c = IPM_Utils.Standard;
            pastMilestone.IPM_Planned_Date__c=System.today() - 4 ;
            pastMilestone.IPM_Due_Date__c = System.today() - 4 ;
            pastMilestone.IPM_Phase__c = IPM_ConstantUtils.FEASIBILITY_PHASE;
            ipmMileStoneList.add(pastMilestone);
            
            IPM_Milestone__c betMilestoneFirstRelease = IPM_TestFactory_Helper.createIPMMilestone(dBRegionalProjects[0].Id, false);
            betMilestoneFirstRelease.IPM_Name__c = 'BETFirstRelease';    
            betMilestoneFirstRelease.IPM_Due_Date__c =  System.today()+5;
            betMilestoneFirstRelease.IPM_Planned_Date__c=System.today()+5 ;
            betMilestoneFirstRelease.IPM_Type_of_Milestone__c = IPM_ConstantUtils.BET;
            ipmMileStoneList.add(betMilestoneFirstRelease);
            
            IPM_Milestone__c betMilestoneFinalRelease = IPM_TestFactory_Helper.createIPMMilestone(dBRegionalProjects[0].Id, false);
            betMilestoneFinalRelease.IPM_Name__c = 'BETFinalRelease';    
            betMilestoneFinalRelease.IPM_Due_Date__c =  System.today()+5;
            betMilestoneFinalRelease.IPM_Planned_Date__c=System.today()+5 ;
            betMilestoneFinalRelease.IPM_Type_of_Milestone__c = IPM_ConstantUtils.BET;
            ipmMileStoneList.add(betMilestoneFinalRelease);
            
            insert ipmMileStoneList;
            iDs.clear();
            for(IPM_Milestone__c eachMilestone : ipmMileStoneList) {
                iDs.add(eachMilestone.id);
            }
            System.assertEquals(4, [Select count() from IPM_Milestone__c where id IN: iDs],MILESTONE_CREATED);
            
            IPM_HomePageController iHp = new IPM_HomePageController();
          
            for(String values:iHp.betMsgFirstReleaseDueDate)
            {
                system.assert(values.contains(IPM_ConstantUtils.BET_FIRST_RELEASE_MESSAGE_STR1),'Alert is not shown as BET First release date is due in 15 days. ');
            }
                
            for(String values:iHp.betMsgFinalReleaseDueDate)
            {
               system.assert(values.contains(IPM_ConstantUtils.BET_FINAL_RELEASE_MESSAGE_STR1),'Alert is not shown as BET Final release date is due in 15 days. ');
            }
            
            for(String values:iHp.alertMessageDueDatePast.values())
            {
               system.assert(values.contains(System.Label.IPM_DUE_DATE_FOR),'Alert is not shown for milestone due date in the past.');
            }   
                
            for(String values:iHp.alertMessageDueDateApproaching.values())
            {
               system.assert(values.contains(IPM_Utils.dueIN),'Alert is not shown for milestone due date is approaching in 21 days.');
            }   
                 
            for(String values:iHp.alertMessageDueDateToday.values())
            {
                system.assert(values.contains(PLANNED_STR),'Alert is not shown for milestone due date is today.');
            }
            
            System.assert(Integer.valueOf(iHp.getTaskcountValue()) > 0, 'Tasks are not assigned to logged-in user.');
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
    
    
}