/*************************************************************************************************************
* @author:Cognizant
* @date: 19/01/2016
* @description: The Test class to test functionality in IPM_SyncFinanceTableTLD. 
    IPM_SyncFinanceTableTLD has Methods to update relative financial records when enver there is updates in Rollouts and Projects TLDs
*/
@isTest(SeeAllData=false)
private class IPM_SyncFinanceTableTLD_Test 
{
    private static final String TESTPROJECT001_REG ='TestProject001_REG';   
    private static final String TESTPROJECT001_REG_LOC1 ='TestProject001_REG_LOC1'; 
    private static final String TESTPROJECT001_REG_LOC2 ='TestProject001_REG_LOC2';
    private static final String TESTPROJECT001_REG_LOC_K='TestProject001_REG_LOC_K';
    private static final String PROJECT_CREATION='Project Creation';
    private static final String MARKET_CLUSTER='GEO0060';
    private static final String GLOBAL_USER='globalUser@unilever.test.com';
    private static final String REGIONAL_USER='regionalUser@unilever.test.com';
    private static final String LOCAL_USER='localUser@unilever.test.com';
    private static final String TESTPROJECT001='TestProject001';
    private static final String PROJ_SIZE_MSG='Project(s) size should be 1';
    private static final String PROJ_PHASE_IDEAS_MSG='Project phase should be IDEAS';
    private static final String TLD_MATCH_MSG='Target launch date should be set correctly';
    private static final String PROJ_ROLLOUT_SIZE_MSG='Project rollout(s) size should be 1';
    private static final String PROJ_PHASE_FEASIBILITY_MSG='Project phase should be FEASIBILITY';
    private static final String FIN_YEAR_MSG='Financial Year Mismatch';
    private static final String FIN_YEAR_EXT_ID_MSG='Financial Year External Id Mismatch';
    private static final String NOT_STARTED='Not Started';
    private static final String TESTPROJ_OPRL_GBL = 'TESTPROJ_OPRL_GBL';
    private static final String TESTPROJ_OPRL_REG = 'TESTPROJ_OPRL_REG';
    private static final String TESTPROJ_OPRL_LCL = 'TESTPROJ_OPRL_LCL';
    private static final String GLOBAL_PL = 'GLOBAL_PL';
    private static final String REGIONAL_PL = 'REGIONAL_PL';
    private static final String LOCAL_PL = 'LOCAL_PL';
    private static final String BLANK = '';
    
   
    
    private static final String DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId();
    
    /*
    1.  All the individual tests need unique data setup. 
        Use of single setup method to set all the data will raise too many SOQL exception. 
        In order to avoid the exception the data setup has been split into several methods so that each data setup method get its own governor limits.
    
    2.  The data setup varies for test scenarios, looks like duplicate code block but not. 
        Pulling these code blocks into private methods will introduce n-path complexity and reduces code readability.
    */
    static void setupOperationalProjects() {
        Test.startTest();
        Date targetLaunchDate = System.today().addYears(3);
        //Creation test user
        User globalUser = IPM_TestFactory_Helper.createUserAdmin(false);
        globalUser.email = GLOBAL_USER;
        
         
        User regionalUser = IPM_TestFactory_Helper.createUserAdmin(false);
        regionalUser.email = REGIONAL_USER;
        

        User localUser = IPM_TestFactory_Helper.createUserAdmin(false);
        localUser.email = LOCAL_USER;
        
        localUser.ManagerId = UserInfo.getUserId();
        
        List<User> userList = new List<User>{globalUser,regionalUser,localUser};
        
        
        insert userList;
        System.runAs(globalUser) {
            // create project
            List<IPM_Project__c> projList = new List<IPM_Project__c>();
            IPM_Project__c projOpeGbl = IPM_TestFactory_Helper.createIPMProject(false);
            projOpeGbl.Name=TESTPROJ_OPRL_GBL;
            projOpeGbl.IPM_Project_Leader__c=globalUser.id;
            projOpeGbl.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL;
            projOpeGbl.IPM_GateKeeping_Model__c=IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT; 
            projOpeGbl.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
            projOpeGbl.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
            projOpeGbl.IPM_CompanyCardText__c=IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
            projOpeGbl.IPM_Temporary_Phase__c=IPM_ConstantUtils.EMPTY_STRING_INITIAL;
            projOpeGbl.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
            projOpeGbl.IPM_Target_Launch_Dates__c = targetLaunchDate;
            projList.add(projOpeGbl);
            
            IPM_Project__c projOpeReg = IPM_TestFactory_Helper.createIPMProject(false);
            projOpeReg.Name=TESTPROJ_OPRL_REG;
            projOpeReg.IPM_Project_Leader__c=globalUser.id;
            projOpeReg.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL;
            projOpeReg.IPM_GateKeeping_Model__c=IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT; 
            projOpeReg.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            projOpeReg.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
            projOpeReg.IPM_CompanyCardText__c=IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
            projOpeReg.IPM_Temporary_Phase__c=IPM_ConstantUtils.EMPTY_STRING_INITIAL;
            projOpeReg.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
            projOpeReg.IPM_Target_Launch_Dates__c = targetLaunchDate;
            projList.add(projOpeReg);
            
            IPM_Project__c projOpeLcl = IPM_TestFactory_Helper.createIPMProject(false);
            projOpeLcl.Name=TESTPROJ_OPRL_LCL;
            projOpeLcl.IPM_Project_Leader__c=globalUser.id;
            projOpeLcl.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL;
            projOpeLcl.IPM_GateKeeping_Model__c=IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT; 
            projOpeLcl.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            projOpeLcl.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
            projOpeLcl.IPM_CompanyCardText__c=IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
            projOpeLcl.IPM_Temporary_Phase__c=IPM_ConstantUtils.EMPTY_STRING_INITIAL;
            projOpeLcl.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
            projOpeLcl.IPM_Target_Launch_Dates__c = targetLaunchDate;
            projList.add(projOpeLcl);
            
            insert projList; 

            List<IPM_Financial__c> fins = new List<IPM_Financial__c>();
            
            IPM_Financial__c fin1=new IPM_Financial__c();
            String defaultRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Default'].Id;
            fin1.RecordTypeId=defaultRecordTypeId;
            fin1.Financial_External_ID__c=TESTPROJ_OPRL_GBL;
            fin1.Parent_Project__c=projList[0].id;
            fin1.Project_Sustainability_Period__c=IPM_ConstantUtils.YEAR_5;
            fin1.Target_Launch_Date__c = targetLaunchDate;
            fin1.isActive__c=true;
            fins.add(fin1);
            
            IPM_Financial__c fin2=new IPM_Financial__c();
            fin2.RecordTypeId=defaultRecordTypeId;
            fin2.Financial_External_ID__c=TESTPROJ_OPRL_REG;
            fin2.Regional_Project__c=projList[1].id;
            fin2.Project_Sustainability_Period__c=IPM_ConstantUtils.YEAR_5;
            fin2.Target_Launch_Date__c = targetLaunchDate;
            fin2.isActive__c=true;
            fins.add(fin2);
            
            IPM_Financial__c fin3=new IPM_Financial__c();
            fin3.RecordTypeId=defaultRecordTypeId;
            fin3.Financial_External_ID__c=TESTPROJ_OPRL_LCL;
            fin3.Local_Project__c=projList[2].id;
            fin3.Project_Sustainability_Period__c=IPM_ConstantUtils.YEAR_5;
            fin3.Target_Launch_Date__c = targetLaunchDate;
            fin3.isActive__c=true;
            fins.add(fin3);
            
            insert fins;
 
 
            Test.stopTest();
            List<IPM_Project__c> projlList=[SELECT Name,IPM_Phase__c, IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c FROM IPM_Project__c WHERE name like 'TESTPROJ_OPRL_%' limit 5];
            System.assertEquals(projlList.size(), 3,'The project size must be 3');
            
            Set<String> projNames = new Set<String>();
            for(IPM_Project__c proj:  projlList) {
                projNames.add(proj.name);
            }
            
            System.assert(projNames.contains(TESTPROJ_OPRL_GBL),'The project list should contain TESTPROJ_OPRL_GBL');
            System.assert(projNames.contains(TESTPROJ_OPRL_REG),'The project list should contain TESTPROJ_OPRL_REG');
            System.assert(projNames.contains(TESTPROJ_OPRL_LCL),'The project list should contain TESTPROJ_OPRL_LCL');
            
            List<IPM_Financial__c> finList=[SELECT Name,Financial_External_ID__c FROM IPM_Financial__c WHERE Financial_External_ID__c like 'TESTPROJ_OPRL_%' limit 5];
            System.assertEquals(finList.size(), 3,'The financials size must be 3');
            
            Set<String> finExtIds = new Set<String>();
            for(IPM_Financial__c financial:  finList) {
                finExtIds.add(financial.Financial_External_ID__c);
            }
            
            System.assert(finExtIds.contains(TESTPROJ_OPRL_GBL),'The Financials list should contain TESTPROJ_OPRL_GBL');
            System.assert(finExtIds.contains(TESTPROJ_OPRL_REG),'The Financials list should contain TESTPROJ_OPRL_REG');
            System.assert(finExtIds.contains(TESTPROJ_OPRL_LCL),'The Financials list should contain TESTPROJ_OPRL_LCL');
            
        }       
    }
    /*
    1.  All the individual tests need unique data setup. 
        Use of single setup method to set all the data will raise too many SOQL exception. 
        In order to avoid the exception the data setup has been into several methods so that the data setup methods get its own governor limits.
    
    2.  The data setup varies for test scenarios, looks like duplicate code block but not. 
        Pulling these code blocks into private methods will introduce n-path complexity and reduces code readability.
    */
    static void setupRegionalOriginalIdeasPhaseData(){
        // Create an instance of admin user.
         User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
         
         User globalProjectLeader = null;
         User regionalProjectLeader = null;
         // Create an instances of standard Users for Allocation to Project Leaders.
         System.runAs(adminUser)
         {   
            globalProjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser(BLANK);
            regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(BLANK);
            User localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(BLANK);
            
            // Update LastNames to match functionalRoles
            globalProjectLeader.lastname = GLOBAL_PL;
            regionalProjectLeader.lastname = REGIONAL_PL;
            localProjectLeader.lastname = LOCAL_PL; 
            
            List<User> userList = new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader};
            update userList;
            
            List<User> dbUserList =  [Select Id from User where id in :userList];
            
            System.assertEquals(dbUserList.size(),userList.size(),'Users not Created Properly.Actual no of Users should be'+userList.size());
            
            // Create Company Card information(Master Data)
            IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
            IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
            IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
            
            List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
            insert companyCardList;
            
            // Inserting Master Data whose OWD are set to readOnly/View All    
            IPM_TestFactory_Helper.getProjectMasterData();
            
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            //IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalProjectLeader}); 
        } 
        List<IPM_Project__c> projectList = new List<IPM_Project__c>();
        Date targetLaunchDate = System.today().addYears(3);
        // Insert the project as a Global project Leader.
        System.runAs(regionalProjectLeader)
        {   
            test.startTest();
            projectList = IPM_TestFactory_Helper.projectSetUp(3,globalProjectLeader);
            projectList[0].IPM_Target_Launch_Dates__c = targetLaunchDate;
            insert projectList;
            
            List<IPM_Project__c> dbProjectList =  [Select Id, name from IPM_Project__c where id in :projectList];
            
            projectList[0].Name=TESTPROJECT001_REG;
            update projectList;
            
            System.assertEquals(dbProjectList.size(),projectList.size(),'Projects not Created Properly.Actual size should be '+projectList.size());
            
            List<IPM_Project_Rollout__c> rollouts = new List<IPM_Project_Rollout__c>();
            String rolloutLocalRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name=:IPM_ConstantUtils.LOCAL_ROLLOUT_RT].Id;
            IPM_Project_Rollout__c localNonkeyProjectRollout1 =IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
            localNonkeyProjectRollout1.Name=TESTPROJECT001_REG_LOC1;
            localNonkeyProjectRollout1.IPM_Rollout_Project__c = TESTPROJECT001_REG_LOC1;
            localNonkeyProjectRollout1.Regional_Project__c=projectList[0].ID;
            localNonkeyProjectRollout1.Market_Cluster__c=MARKET_CLUSTER;
            localNonkeyProjectRollout1.IPM_Rollout_Span__c=IPM_ConstantUtils.EMPTY_STRING_INITIAL;
            localNonkeyProjectRollout1.Target_Launch_Date__c = targetLaunchDate;
            localNonkeyProjectRollout1.RecordTypeId = rolloutLocalRecordTypeId;
            localNonkeyProjectRollout1.KeyMCO__c = false;
            localNonkeyProjectRollout1.External_Id__c=TESTPROJECT001_REG_LOC1;
            localNonkeyProjectRollout1.isActive__c=true;
            rollouts.add(localNonkeyProjectRollout1);
            
            rolloutLocalRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name=:IPM_ConstantUtils.LOCAL_ROLLOUT_RT].Id;
            IPM_Project_Rollout__c localNonkeyProjectRollout2 =IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
            localNonkeyProjectRollout2.Name=TESTPROJECT001_REG_LOC2;
            localNonkeyProjectRollout2.IPM_Rollout_Project__c = TESTPROJECT001_REG_LOC2;
            localNonkeyProjectRollout2.Regional_Project__c=projectList[0].ID;
            localNonkeyProjectRollout2.Market_Cluster__c=MARKET_CLUSTER;
            localNonkeyProjectRollout2.IPM_Rollout_Span__c=IPM_ConstantUtils.EMPTY_STRING_INITIAL;
            localNonkeyProjectRollout2.Target_Launch_Date__c = targetLaunchDate;
            localNonkeyProjectRollout2.RecordTypeId = rolloutLocalRecordTypeId;
            localNonkeyProjectRollout2.KeyMCO__c = false;
            localNonkeyProjectRollout2.External_Id__c=TESTPROJECT001_REG_LOC2;
            localNonkeyProjectRollout2.isActive__c=true;
            rollouts.add(localNonkeyProjectRollout2);
            
            IPM_Project_Rollout__c localKeyProjectRollout1 =IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
            localKeyProjectRollout1.Name=TESTPROJECT001_REG_LOC_K;
            localKeyProjectRollout1.IPM_Rollout_Project__c = TESTPROJECT001_REG_LOC_K;
            localKeyProjectRollout1.Regional_Project__c=projectList[0].ID;
            localKeyProjectRollout1.Market_Cluster__c=MARKET_CLUSTER;
            localKeyProjectRollout1.IPM_Rollout_Span__c=IPM_ConstantUtils.EMPTY_STRING_INITIAL;
            localKeyProjectRollout1.Target_Launch_Date__c = targetLaunchDate;
            localKeyProjectRollout1.RecordTypeId = rolloutLocalRecordTypeId;
            localKeyProjectRollout1.KeyMCO__c = true;
            localKeyProjectRollout1.External_Id__c=TESTPROJECT001_REG_LOC_K;
            localKeyProjectRollout1.isActive__c=true;
            rollouts.add(localKeyProjectRollout1);
            insert rollouts;
            
            List<IPM_Financial__c> fins=new List<IPM_Financial__c>();
            
            IPM_Financial__c fin1=new IPM_Financial__c();
            String consolidatedRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Consolidated'].Id;
            fin1.RecordTypeId=consolidatedRecordTypeId;
            fin1.Financial_External_ID__c=TESTPROJECT001_REG+'_CONSOLIDATED';
            fin1.Regional_Project__c=projectList[0].id;
            fin1.Volume_Unit__c=IPM_ConstantUtils.VOLUME_UNIT_TONS;
            fin1.Status__c=NOT_STARTED;
            fin1.Project_Sustainability_Period__c=IPM_ConstantUtils.YEAR_3;//YEAR_5
            fin1.Target_Launch_Date__c = targetLaunchDate;
            fin1.isActive__c=true;
            fins.add(fin1);
            
            IPM_Financial__c fin2=new IPM_Financial__c();
            String defaultRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Default'].Id;
            fin2.RecordTypeId=defaultRecordTypeId;
            fin2.Financial_External_ID__c=TESTPROJECT001_REG+'_NONKEY';
            fin2.Regional_Project__c=projectList[0].id;
            fin2.Volume_Unit__c=IPM_ConstantUtils.VOLUME_UNIT_TONS;
            fin2.Status__c=NOT_STARTED;
            fin2.Project_Sustainability_Period__c=IPM_ConstantUtils.YEAR_3;//YEAR_5
            fin2.Target_Launch_Date__c = targetLaunchDate;
            fin2.isActive__c = true;
            fins.add(fin2);
            insert fins;
            
            test.stopTest();
        }
        
        List<IPM_Financial__c> finList=[SELECT Name,Financial_External_ID__c FROM IPM_Financial__c WHERE Financial_External_ID__c like 'TestProject001_REG%' limit 5];
            
        Set<String> finExtIds = new Set<String>();
        for(IPM_Financial__c financial:  finList) {
            finExtIds.add(financial.Financial_External_ID__c);
        }
        
        System.assert(finExtIds.contains('TestProject001_REG_CONSOLIDATED'),'The Financials list should contain TestProject001_REG_CONSOLIDATED');
        System.assert(finExtIds.contains('TestProject001_REG_NONKEY'),'The Financials list should contain TestProject001_REG_NONKEY');
        
        
        List<IPM_Project__c> projlList=[SELECT Name,IPM_Phase__c, IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c FROM IPM_Project__c WHERE name=: TESTPROJECT001_REG limit 1];
        System.assertEquals(projlList.size(), 1,PROJ_SIZE_MSG);
        
        System.assertEquals(IPM_ConstantUtils.PHASE_IDEAS, projlList[0].IPM_Phase__c,PROJ_PHASE_IDEAS_MSG);
        System.assertEquals(targetLaunchDate, projlList[0].IPM_Target_Launch_Dates__c,TLD_MATCH_MSG);
       
        List<IPM_Project_Rollout__c>  projRollOutList=[SELECT Name, Target_Launch_Date__c FROM IPM_Project_Rollout__c WHERE name like 'TestProject001_REG_LOC%' limit 4];
        
        System.assertEquals(3,projRollOutList.size(),'Project rollout(s) size should be 3');
        
        for(IPM_Project_Rollout__c rollout : projRollOutList) {
            
            System.assertEquals(targetLaunchDate, rollout.Target_Launch_Date__c,TLD_MATCH_MSG);
        }
    }
    
    
    /*
    1.  All the individual tests need unique data setup. 
        Use of single setup method to set all the data will raise too many SOQL exception. 
        In order to avoid the exception the data setup has been into several methods so that the data setup methods get its own governor limits.
    
    2.  The data setup varies for test scenarios, looks like duplicate code block but not. 
        Pulling these code blocks into private methods will introduce n-path complexity and reduces code readability.
    */
    static void setupFeasibilityPhaseDataForLocalProject(){
        User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
         
         User globalProjectLeader = null;
         User regionalProjectLeader = null;
         User localProjectLeader = null;
         // Create an instances of standard Users for Allocation to Project Leaders.
         System.runAs(adminUser)
         {   
            globalProjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser(BLANK);
            regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(BLANK);
            localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(BLANK);
            
            // Update LastNames to match functionalRoles
            globalProjectLeader.lastname = GLOBAL_PL;
            regionalProjectLeader.lastname = REGIONAL_PL;
            localProjectLeader.lastname = LOCAL_PL; 
            
            List<User> userList = new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader};
            update userList;
            
            List<User> dbUserList =  [Select Id from User where id in :userList];
            
            System.assertEquals(dbUserList.size(),userList.size(),'Users not Created Properly.Actual no of Users should be'+userList.size());
            
            // Create Company Card information(Master Data)
            IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
            IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
            IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
            
            List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
            insert companyCardList;
            
            // Inserting Master Data whose OWD are set to readOnly/View All    
            IPM_TestFactory_Helper.getProjectMasterData();
            
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalProjectLeader}); 
        } 
        List<IPM_Project__c> projectList = new List<IPM_Project__c>();
        Date targetLaunchDate = System.today().addYears(3);
        // Insert the project as a Global project Leader.
        System.runAs(globalProjectLeader)
        {   
            test.startTest();
            projectList = IPM_TestFactory_Helper.projectSetUp(3,globalProjectLeader);
            //projectList[0].IPM_Target_Launch_Dates__c=targetLaunchDate;
            insert projectList;
            
            projectList[0].Name=TESTPROJECT001;
            projectList[0].IPM_Target_Launch_Dates__c = targetLaunchDate;
            update projectList;
            
            List<IPM_Project__c> dbProjectList =  [Select Id, name from IPM_Project__c where id in :projectList];
            
            System.assertEquals(dbProjectList.size(),projectList.size(),'Projects not Created Properly.Actual size should be '+projectList.size());
                    
            String rolloutRegionlaRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name=:IPM_ConstantUtils.REGIONAL_ROLLOUT_RT].Id;
            IPM_Project_Rollout__c regionalProjectRollout=IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
            regionalProjectRollout.Name=TESTPROJECT001_REG;
            regionalProjectRollout.IPM_Rollout_Project__c = TESTPROJECT001_REG;
            regionalProjectRollout.IPM_Project__c=projectList[0].ID;
            regionalProjectRollout.Market_Cluster__c=MARKET_CLUSTER;
            regionalProjectRollout.IPM_Rollout_Span__c=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            regionalProjectRollout.Target_Launch_Date__c = targetLaunchDate;
            regionalProjectRollout.External_Id__c=TESTPROJECT001_REG;
            regionalProjectRollout.RecordTypeId = rolloutRegionlaRecordTypeId;
            regionalProjectRollout.IPM_Project_Job_Status__c=IPM_ConstantUtils.JOB_STATUS_COMPLETED;
            regionalProjectRollout.IPM_RolloutJobType__c=IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_PHASECHANGE;
            regionalProjectRollout.IPM_Rollout_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            regionalProjectRollout.IPM_Regional_PL__c=regionalProjectLeader.id;
            regionalProjectRollout.isActive__c=true;
            insert regionalProjectRollout;
    
            IPM_Project__c rolloutProject = IPM_TestFactory_Helper.createIPMProject(false);
            rolloutProject.Name=TESTPROJECT001_REG;
            rolloutProject.Sustainability_Period__c=IPM_ConstantUtils.YEAR_3;
            rolloutProject.IPM_Project_Leader__c=regionalProjectLeader.id;
            rolloutProject.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            rolloutProject.IPM_GateKeeping_Model__c=IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT; 
            rolloutProject.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            rolloutProject.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
            rolloutProject.IPM_CompanyCardText__c=IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
            rolloutProject.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
            rolloutProject.IPM_Target_Launch_Dates__c = targetLaunchDate;
            rolloutProject.IPM_Project_Name__c=TESTPROJECT001_REG;
            rolloutProject.IPM_Parent_Project__c=projectList[0].ID;
            rolloutProject.IPM_ProjectJobType__c=PROJECT_CREATION;
            insert rolloutProject; 
            
            List<IPM_Project_Rollout__c> rollouts = new List<IPM_Project_Rollout__c>();
            String rolloutLocalRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name=:IPM_ConstantUtils.LOCAL_ROLLOUT_RT].Id;
            IPM_Project_Rollout__c localNonkeyProjectRollout1 =IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
            localNonkeyProjectRollout1.Name=TESTPROJECT001_REG_LOC1;
            localNonkeyProjectRollout1.IPM_Rollout_Project__c = TESTPROJECT001_REG_LOC1;
            localNonkeyProjectRollout1.IPM_Project__c=projectList[0].ID;
            localNonkeyProjectRollout1.Regional_Rollout__c=regionalProjectRollout.id;
            localNonkeyProjectRollout1.Market_Cluster__c=MARKET_CLUSTER;
            localNonkeyProjectRollout1.IPM_Rollout_Span__c=IPM_ConstantUtils.ROLLOUT_SPAN_LOCAL;
            localNonkeyProjectRollout1.Target_Launch_Date__c = targetLaunchDate;
            localNonkeyProjectRollout1.RecordTypeId = rolloutLocalRecordTypeId;
            localNonkeyProjectRollout1.KeyMCO__c = false;
            localNonkeyProjectRollout1.External_Id__c=TESTPROJECT001_REG_LOC1;
            localNonkeyProjectRollout1.Regional_Project__c=rolloutProject.id;
            localNonkeyProjectRollout1.IPM_RolloutJobType__c=IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
            localNonkeyProjectRollout1.IPM_Rollout_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            localNonkeyProjectRollout1.IPM_Project_Job_Status__c=IPM_ConstantUtils.JOB_STATUS_COMPLETED;
            localNonkeyProjectRollout1.isActive__c=true;
            rollouts.add(localNonkeyProjectRollout1);
    
            IPM_Project_Rollout__c localNonkeyProjectRollout2 =IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
            localNonkeyProjectRollout2.Name=TESTPROJECT001_REG_LOC2;
            localNonkeyProjectRollout2.IPM_Rollout_Project__c = TESTPROJECT001_REG_LOC2;
            localNonkeyProjectRollout2.IPM_Project__c=projectList[0].ID;
            localNonkeyProjectRollout2.Regional_Rollout__c=regionalProjectRollout.id;
            localNonkeyProjectRollout2.Market_Cluster__c=MARKET_CLUSTER;
            localNonkeyProjectRollout2.IPM_Rollout_Span__c=IPM_ConstantUtils.ROLLOUT_SPAN_LOCAL;
            localNonkeyProjectRollout2.Target_Launch_Date__c = targetLaunchDate;
            localNonkeyProjectRollout2.RecordTypeId = rolloutLocalRecordTypeId;
            localNonkeyProjectRollout2.KeyMCO__c = false;
            localNonkeyProjectRollout2.External_Id__c=TESTPROJECT001_REG_LOC2;
            localNonkeyProjectRollout2.Regional_Project__c=rolloutProject.id;
            localNonkeyProjectRollout2.IPM_RolloutJobType__c=IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
            localNonkeyProjectRollout2.IPM_Rollout_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            localNonkeyProjectRollout2.IPM_Project_Job_Status__c=IPM_ConstantUtils.JOB_STATUS_COMPLETED;
            localNonkeyProjectRollout2.isActive__c=true;
            rollouts.add(localNonkeyProjectRollout2);
    
            insert rollouts;
    
            IPM_Project__c localProject = IPM_TestFactory_Helper.createIPMProject(false);
            localProject.Name=TESTPROJECT001_REG_LOC1;
            localProject.Sustainability_Period__c=IPM_ConstantUtils.YEAR_3;
            localProject.IPM_Project_Leader__c=localProjectLeader.id;
            localProject.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            localProject.IPM_GateKeeping_Model__c=IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT; 
            localProject.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            localProject.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
            localProject.IPM_CompanyCardText__c=IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
            localProject.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
            localProject.IPM_Target_Launch_Dates__c = targetLaunchDate;
            localProject.IPM_Project_Name__c=TESTPROJECT001_REG_LOC1;
            localProject.IPM_Parent_Project__c=rolloutProject.ID;
            localProject.IPM_Project_Rollout__c = regionalProjectRollout.id;
            localProject.IPM_ProjectJobType__c=PROJECT_CREATION;
            localProject.IPM_Project_Job_Status__c=IPM_ConstantUtils.JOB_STATUS_COMPLETED;
            insert localProject; 
    		
    		Test.stopTest(); 
    		
            List<IPM_Financial__c> financials = new List<IPM_Financial__c>();
            
            financials = new List<IPM_Financial__c>();
            IPM_Financial__c ipmFinancials1 = [select id from IPM_Financial__c where Financial_External_ID__c='TestProject001_REG_CONSOLIDATED' limit 1];
            ipmFinancials1.Regional_Project__c = rolloutProject.id;
            ipmFinancials1.isActive__c=true;
            financials.add(ipmFinancials1);
            
            update financials;
            
            List<IPM_Project__c> globalProjList=[SELECT Name,IPM_Phase__c, IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c,IPM_ProjectJobType__c FROM IPM_Project__c WHERE name=:TESTPROJECT001 limit 1];
            System.assertEquals(globalProjList.size(), 1,PROJ_SIZE_MSG);
            
            globalProjList[0].IPM_Phase__c=IPM_ConstantUtils.PHASE_FEASIBILITY;
            update globalProjList[0];
            System.assertEquals(IPM_ConstantUtils.PHASE_FEASIBILITY, globalProjList[0].IPM_Phase__c,PROJ_PHASE_FEASIBILITY_MSG);
            System.assertEquals(targetLaunchDate, globalProjList[0].IPM_Target_Launch_Dates__c,TLD_MATCH_MSG);
            
            List<IPM_Project__c> regionalProjList=[SELECT Name,IPM_Phase__c, IPM_Project_Job_Status__c, IPM_Target_Launch_Dates__c, IPM_ProjectJobType__c, IPMProject_Span__c, IPM_Project_Type__c,IPM_Parent_Project__c, (Select id, name, Financial_External_ID__c, Target_Launch_Date__c From IPM_Financials_Regional__r)   FROM IPM_Project__c WHERE name=:TESTPROJECT001_REG limit 2];
            System.assertEquals(regionalProjList.size(), 1,PROJ_SIZE_MSG);
            
            regionalProjList[0].IPM_Phase__c=IPM_ConstantUtils.PHASE_FEASIBILITY;
            update regionalProjList[0];
            System.assertEquals(IPM_ConstantUtils.PHASE_FEASIBILITY, regionalProjList[0].IPM_Phase__c,PROJ_PHASE_FEASIBILITY_MSG);
            System.assertEquals(targetLaunchDate, regionalProjList[0].IPM_Target_Launch_Dates__c,TLD_MATCH_MSG);
            System.assertEquals(PROJECT_CREATION, regionalProjList[0].IPM_ProjectJobType__c,'Project type should be Project Creation');
            System.assertEquals(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL, regionalProjList[0].IPMProject_Span__c,'Project span should be Regional');
            System.assertEquals(IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT, regionalProjList[0].IPM_Project_Type__c,'Project type should be Rollout');
            System.assertEquals(globalProjList[0].id, regionalProjList[0].IPM_Parent_Project__c,'Project id should match with parent project');
           
            List<IPM_Project_Rollout__c>  regionalRolloutList=[SELECT Name, Target_Launch_Date__c, IPM_Project_Job_Status__c, IPM_RolloutJobType__c, IPM_Rollout_Span__c, IPM_Rollout_Type__c,IPM_Project__c, RecordTypeId, (Select Name, Financial_External_ID__c, Target_Launch_Date__c From IPM_Financials__r)   FROM IPM_Project_Rollout__c WHERE name=:TESTPROJECT001_REG limit 2];
            System.assertEquals(regionalRolloutList.size(), 1,PROJ_ROLLOUT_SIZE_MSG);
            
            System.assertEquals(targetLaunchDate, regionalRolloutList[0].Target_Launch_Date__c,TLD_MATCH_MSG);
            System.assertEquals('Completed', regionalRolloutList[0].IPM_Project_Job_Status__c,'Project rollout status should be Completed');
            System.assertEquals('Phase Change - Rollout Project Creation', regionalRolloutList[0].IPM_RolloutJobType__c,'Project rollout type should be Project Creation');
            System.assertEquals(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL, regionalRolloutList[0].IPM_Rollout_Span__c,'Project rollout span should be Regional');
            System.assertEquals('Rollout', regionalRolloutList[0].IPM_Rollout_Type__c,'Project rollout type should be Rollout');
            System.assertEquals(globalProjList[0].id, regionalRolloutList[0].IPM_Project__c,'Project rollout project id should match with parent project');
            System.assertEquals(rolloutRegionlaRecordTypeId, regionalRolloutList[0].RecordTypeId,'Record Id should match');
                
            List<IPM_Project__c> localProjList=[SELECT IPM_Project_Rollout__c,Name,IPM_Phase__c, IPM_Project_Job_Status__c, IPM_Target_Launch_Dates__c, IPM_ProjectJobType__c, IPMProject_Span__c, IPM_Project_Type__c,IPM_Parent_Project__c, (Select id, name, Financial_External_ID__c, Target_Launch_Date__c From IPM_Financials_Local__r)   FROM IPM_Project__c WHERE name=:TESTPROJECT001_REG_LOC1 limit 2];
            System.assertEquals(localProjList.size(), 1,'Project(s) size should be 3');
            System.assertEquals(rolloutProject.ID, localProjList[0].IPM_Parent_Project__c,'Project rollout project id should match with parent project');
            System.assertEquals(regionalProjectRollout.ID, localProjList[0].IPM_Project_Rollout__c,'Project rollout id should match with rollout project');
          }
    }
    
    /*
    The datasetup method of this test has Test.startTest() and Test.stopTest(). 
    So cant have another set of Test.startTest() and Test.stopTest().
    */  
    static testMethod void testSyncFinanceTableTLD_When_LocalProjectTLD_Updated() {
        setupFeasibilityPhaseDataForLocalProject();
        Date targetLanchDate1 = System.today().addYears(4);
        User globalUser = [Select Id from User where LastName =:GLOBAL_PL limit 1]; 
        System.runAs(globalUser) {
            
            IPM_Project__c localProject =[SELECT ID   FROM IPM_Project__c WHERE name=:TESTPROJECT001_REG_LOC1 limit 1];
            localProject.IPM_Target_Launch_Dates__c = targetLanchDate1;
            update localProject;
            
            
            List<IPM_Financial__c> updatedFinancialList = [Select id, Target_Launch_Date__c, 
                                                                    (   Select 
                                                                            Year__c,Year_Type__c,Name, External_Id__c,Target_Launch_Date__c, PL_Type__c 
                                                                        From 
                                                                            IPM_Financial_Years__r 
                                                                        where 
                                                                            Year_Type__c=:IPM_ConstantUtils.YEAR_TYPE_CALENDAR 
                                                                            ) 
                                                                 From 
                                                                    IPM_Financial__c 
                                                                        where Financial_External_ID__c=:TESTPROJECT001_REG_LOC1 limit 1];
            
            
            
            for(IPM_Financial__c updatedFinancial: updatedFinancialList) {
                for(IPM_Financial_Year__c financialYear:updatedFinancial.IPM_Financial_Years__r) {
                    
                    if(financialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_INCREMENTAL||financialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_GROSS) {
                        // year 1
                        if( financialYear.Year__c==IPM_ConstantUtils.Y1_YEARINDEX) {
                            System.assert(financialYear.Name != null,FIN_YEAR_MSG);
                        }
                        //year 2
                        if( financialYear.Year__c==IPM_ConstantUtils.Y2_YEARINDEX) {
                            System.assert(financialYear.Name != null,FIN_YEAR_MSG);
                        }
                        //year 3
                        if( financialYear.Year__c==IPM_ConstantUtils.Y3_YEARINDEX) {
                            System.assert(financialYear.Name != null,FIN_YEAR_MSG);
                        }
                    }
                }
            }
        }
    }
    
    
   
    /*
    The datasetup method of this test has Test.startTest() and Test.stopTest(). 
    So cant have another set of Test.startTest() and Test.stopTest().
    */  
    static testMethod  void testSyncFinanceTableTLD_When_NonkeyLocalRolloutsTLD_UpdatedToLatest_RegionalOriginal() {
        setupRegionalOriginalIdeasPhaseData();
        List<IPM_Project_Rollout__c> rollouts = new List<IPM_Project_Rollout__c>();

        Date targetLanchDate1 = System.today().addYears(3);
        String year11 = String.valueOf(targetLanchDate1.year());
        String year12 = String.valueOf(targetLanchDate1.year()+1);
        String year13 = String.valueOf(targetLanchDate1.year()+2);
        User regionalUser = [Select Id from User where lastname =: REGIONAL_PL limit 1]; 
        System.runAs(regionalUser) {
            // update rollout1 with targetLanchDate1
            IPM_Project_Rollout__c rollout1 = [SELECT ID, Name,IPM_Project__c,Regional_Rollout__c,KeyMCO__c FROM IPM_Project_Rollout__c WHERE name=:TESTPROJECT001_REG_LOC1 limit 1];
            rollout1.Target_Launch_Date__c = targetLanchDate1;
            rollouts.add(rollout1);
            
            
            Date targetLanchDate2 = System.today().addYears(5);
            IPM_Project_Rollout__c rollout2 = [SELECT ID, Name,IPM_Project__c,Regional_Rollout__c,KeyMCO__c FROM IPM_Project_Rollout__c WHERE name=:TESTPROJECT001_REG_LOC2 limit 1];
            // update rollout2 with targetLanchDate2
            rollout2.Target_Launch_Date__c = targetLanchDate2;
            rollouts.add(rollout2);
            update rollouts;
            
            List<IPM_Project__c> regionalProject = [SELECT ID, Name FROM IPM_Project__c WHERE name=:TESTPROJECT001_REG limit 1];
            System.assertEquals(regionalProject[0].Name,TESTPROJECT001_REG,'Project name must be TestProject001_REG');
            List<IPM_Financial__c> updatedFinancialList = [SELECT ID, Target_Launch_Date__c,Financial_External_ID__c FROM IPM_Financial__c WHERE Regional_Project__c=:regionalProject[0] .id limit 5];
            List<ID> updatedFinancialIDList = new List<ID>();
            
            for(IPM_Financial__c updatedFinancial: updatedFinancialList) {
                
                
                if(updatedFinancial.Financial_External_ID__c==regionalProject[0].name+'_NONKEY') {
                    // NONKEY financial record TLD should be the earliast of local rollouts, which is targetLanchDate1
                    System.assertEquals(targetLanchDate1,updatedFinancial.Target_Launch_Date__c,TLD_MATCH_MSG);
                    updatedFinancialIDList.add(updatedFinancial.id);
                }
            }
                    List<IPM_Financial__c> retrievedFinancialList = [Select id, Target_Launch_Date__c, 
                                                                            (   Select 
                                                                                    Year__c,Year_Type__c,Name, External_Id__c,Target_Launch_Date__c, PL_Type__c 
                                                                                From 
                                                                                    IPM_Financial_Years__r 
                                                                                where 
                                                                                    Year_Type__c=:IPM_ConstantUtils.YEAR_TYPE_CALENDAR 
                                                                                    ) 
                                                                         From 
                                                                            IPM_Financial__c 
                                                                                where id in : updatedFinancialIDList  and RecordTypeId = :DEFAULT_FINANCIAL_RECORDTYPE limit 5];
            
            for(IPM_Financial__c updatedFinancial:retrievedFinancialList) {
                for(IPM_Financial_Year__c financialYear:updatedFinancial.IPM_Financial_Years__r) {
                    if(financialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_INCREMENTAL||financialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_GROSS) {
                        // year 1
                        if( financialYear.Year__c==IPM_ConstantUtils.Y1_YEARINDEX) {
                            System.assert(financialYear.External_Id__c.contains(year11),FIN_YEAR_EXT_ID_MSG);
                            System.assertEquals(year11,financialYear.Name,FIN_YEAR_MSG);
                        }
                        //year 2
                        if( financialYear.Year__c==IPM_ConstantUtils.Y2_YEARINDEX) {
                            System.assert(financialYear.External_Id__c.contains(year12),FIN_YEAR_EXT_ID_MSG);
                            System.assertEquals(year12,financialYear.Name,FIN_YEAR_MSG);
                        }
                        //year 3
                        if( financialYear.Year__c==IPM_ConstantUtils.Y3_YEARINDEX) {
                            System.assert(financialYear.External_Id__c.contains(year13),FIN_YEAR_EXT_ID_MSG);
                            System.assertEquals(year13,financialYear.Name,FIN_YEAR_MSG);
                        }
                    }
                }
            }
        }
    }
    
    /*
    The datasetup method of this test has Test.startTest() and Test.stopTest(). 
    So cant have another set of Test.startTest() and Test.stopTest().
    */  
    static testMethod void testSyncFinanceTableTLD_When_OperationalProjectsTLD_Updated() {
        setupOperationalProjects();
        
        Date targetLanchDate1 = System.today().addYears(3);
        String year11 = String.valueOf(targetLanchDate1.year());
        String year12 = String.valueOf(targetLanchDate1.year()+1);
        String year13 = String.valueOf(targetLanchDate1.year()+2);
        User globalUser = [Select Id from User where Email =:GLOBAL_USER limit 1]; 
        System.runAs(globalUser) {
            List<IPM_Project__c> projlList=[SELECT Name,IPM_Phase__c, IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c FROM IPM_Project__c WHERE name like 'TESTPROJ_OPRL_%' limit 5];
            System.assertEquals(projlList.size(), 3,'The project size must be 3');
            for(IPM_Project__c proj: projlList) {
                proj.IPM_Target_Launch_Dates__c = targetLanchDate1;
            }
            update projlList;
            
            // Global operation project 
            List<IPM_Financial__c> updatedFinancialList = [SELECT ID, Target_Launch_Date__c,Financial_External_ID__c FROM IPM_Financial__c WHERE Financial_External_ID__c=:TESTPROJ_OPRL_GBL limit 1];
            System.assertEquals(updatedFinancialList[0].Financial_External_ID__c,TESTPROJ_OPRL_GBL,'Financial external id must be TESTPROJ_OPRL_GBL');
            System.assertEquals(targetLanchDate1,updatedFinancialList[0].Target_Launch_Date__c,TLD_MATCH_MSG);
            
            List<IPM_Financial__c> retrievedFinancialList = [Select id, Target_Launch_Date__c, 
                                                                    (   Select 
                                                                            Year__c,Year_Type__c,Name, External_Id__c,Target_Launch_Date__c, PL_Type__c 
                                                                        From 
                                                                            IPM_Financial_Years__r 
                                                                        where 
                                                                            Year_Type__c=:IPM_ConstantUtils.YEAR_TYPE_CALENDAR 
                                                                            ) 
                                                                 From 
                                                                    IPM_Financial__c 
                                                                        where id =: updatedFinancialList[0].id limit 5];
            
            for(IPM_Financial__c updatedFinancial:retrievedFinancialList) {
                for(IPM_Financial_Year__c financialYear:updatedFinancial.IPM_Financial_Years__r) {
                    if(financialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_INCREMENTAL||financialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_GROSS) {
                        // year 1
                        if( financialYear.Year__c==IPM_ConstantUtils.Y1_YEARINDEX) {
                            System.assert(financialYear.External_Id__c.contains(year11),FIN_YEAR_EXT_ID_MSG);
                            System.assertEquals(year11,financialYear.Name,FIN_YEAR_MSG);
                        }
                        //year 2
                        if( financialYear.Year__c==IPM_ConstantUtils.Y2_YEARINDEX) {
                            System.assert(financialYear.External_Id__c.contains(year12),FIN_YEAR_EXT_ID_MSG);
                            System.assertEquals(year12,financialYear.Name,FIN_YEAR_MSG);
                        }
                        //year 3
                        if( financialYear.Year__c==IPM_ConstantUtils.Y3_YEARINDEX) {
                            System.assert(financialYear.External_Id__c.contains(year13),FIN_YEAR_EXT_ID_MSG);
                            System.assertEquals(year13,financialYear.Name,FIN_YEAR_MSG);
                        }
                    }
                }
            }
            // Regional operation project 
            updatedFinancialList = [SELECT ID, Target_Launch_Date__c,Financial_External_ID__c FROM IPM_Financial__c WHERE Financial_External_ID__c=:TESTPROJ_OPRL_REG limit 1];
            System.assertEquals(updatedFinancialList[0].Financial_External_ID__c,TESTPROJ_OPRL_REG,'Financial external id must be TESTPROJ_OPRL_REG');
            System.assertEquals(targetLanchDate1,updatedFinancialList[0].Target_Launch_Date__c,TLD_MATCH_MSG);
            
            retrievedFinancialList = [  Select id, Target_Launch_Date__c, 
                                            (   Select 
                                                    Year__c,Year_Type__c,Name, External_Id__c,Target_Launch_Date__c, PL_Type__c 
                                                From 
                                                    IPM_Financial_Years__r 
                                                where 
                                                    Year_Type__c=:IPM_ConstantUtils.YEAR_TYPE_CALENDAR 
                                                    ) 
                                         From 
                                            IPM_Financial__c 
                                                where id =: updatedFinancialList[0].id limit 5];
            
            for(IPM_Financial__c updatedFinancial:retrievedFinancialList) {
                for(IPM_Financial_Year__c financialYear:updatedFinancial.IPM_Financial_Years__r) {
                    if(financialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_INCREMENTAL||financialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_GROSS) {
                        // year 1
                        if( financialYear.Year__c==IPM_ConstantUtils.Y1_YEARINDEX) {
                            System.assert(financialYear.External_Id__c.contains(year11),FIN_YEAR_EXT_ID_MSG);
                            System.assertEquals(year11,financialYear.Name,FIN_YEAR_MSG);
                        }
                        //year 2
                        if( financialYear.Year__c==IPM_ConstantUtils.Y2_YEARINDEX) {
                            System.assert(financialYear.External_Id__c.contains(year12),FIN_YEAR_EXT_ID_MSG);
                            System.assertEquals(year12,financialYear.Name,FIN_YEAR_MSG);
                        }
                        //year 3
                        if( financialYear.Year__c==IPM_ConstantUtils.Y3_YEARINDEX) {
                            System.assert(financialYear.External_Id__c.contains(year13),FIN_YEAR_EXT_ID_MSG);
                            System.assertEquals(year13,financialYear.Name,FIN_YEAR_MSG);
                        }
                    }
                }
            }
            // Local operation project 
            updatedFinancialList = [SELECT ID, Target_Launch_Date__c,Financial_External_ID__c FROM IPM_Financial__c WHERE Financial_External_ID__c=:TESTPROJ_OPRL_LCL limit 1];
            System.assertEquals(updatedFinancialList[0].Financial_External_ID__c,TESTPROJ_OPRL_LCL,'Financial external id must be TESTPROJ_OPRL_LCL');
            System.assertEquals(targetLanchDate1,updatedFinancialList[0].Target_Launch_Date__c,TLD_MATCH_MSG);
            
            retrievedFinancialList = [  Select id, Target_Launch_Date__c, 
                                            (   Select 
                                                    Year__c,Year_Type__c,Name, External_Id__c,Target_Launch_Date__c, PL_Type__c 
                                                From 
                                                    IPM_Financial_Years__r 
                                                where 
                                                    Year_Type__c=:IPM_ConstantUtils.YEAR_TYPE_CALENDAR 
                                                    ) 
                                         From 
                                            IPM_Financial__c 
                                                where id =: updatedFinancialList[0].id limit 5];
            
            for(IPM_Financial__c updatedFinancial:retrievedFinancialList) {
                for(IPM_Financial_Year__c financialYear:updatedFinancial.IPM_Financial_Years__r) {
                    if(financialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_INCREMENTAL||financialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_GROSS) {
                        // year 1
                        if( financialYear.Year__c==IPM_ConstantUtils.Y1_YEARINDEX) {
                            System.assert(financialYear.External_Id__c.contains(year11),FIN_YEAR_EXT_ID_MSG);
                            System.assertEquals(year11,financialYear.Name,FIN_YEAR_MSG);
                        }
                        //year 2
                        if( financialYear.Year__c==IPM_ConstantUtils.Y2_YEARINDEX) {
                            System.assert(financialYear.External_Id__c.contains(year12),FIN_YEAR_EXT_ID_MSG);
                            System.assertEquals(year12,financialYear.Name,FIN_YEAR_MSG);
                        }
                        //year 3
                        if( financialYear.Year__c==IPM_ConstantUtils.Y3_YEARINDEX) {
                            System.assert(financialYear.External_Id__c.contains(year13),FIN_YEAR_EXT_ID_MSG);
                            System.assertEquals(year13,financialYear.Name,FIN_YEAR_MSG);
                        }
                    }
                }
            }
        }     
    }

}