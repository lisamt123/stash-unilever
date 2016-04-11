@isTest(SeeAllData=false)
private class IPM_ValidationHelper_Test {
    public static IPM_Project_Rollout__c proRoll1=new IPM_Project_Rollout__c();
    public static IPM_Project_Rollout__c proRoll2=new IPM_Project_Rollout__c();
    public static IPM_Project_Rollout__c proRollLocal=new IPM_Project_Rollout__c();
    public static IPM_Financial__c fin=new IPM_Financial__c();
    public static IPM_Financial_Year__c finYear=new IPM_Financial_Year__c();
    public static List<IPM_Financial__c> lstFinancial=new List<IPM_Financial__c>();
    public static List<IPM_Financial_Year__c> financialYearList=new List<IPM_Financial_Year__c>();
    public static Integer noOfRecordsForBulkTest = 200;
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
    private static final String PROJ_STATUS_COMPLETED_MSG='Project status should be Completed';
    private static final String TLD_MATCH_MSG='Target launch date should be set correctly';
    private static final String PROJ_ROLLOUT_SIZE_MSG='Project rollout(s) size should be 1';
    private static final String PROJ_PHASE_FEASIBILITY_MSG='Project phase should be FEASIBILITY';
    private static final String TESTPROJECT001_CONSOLIDATED='TestProject001_CONSOLIDATED';
    private static final String NOT_STARTED='Not Started';
    private static final String INVALIE_PROJECT = 'The passed project must be invalid';
  	static void setupRegionalOriginalIdeasPhaseData(){
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
        System.runAs(regionalUser) {
             // create project
            IPM_Project__c project = IPM_TestFactory_Helper.createIPMProject(false);
            project.Name=TESTPROJECT001_REG;
            project.Sustainability_Period__c=IPM_ConstantUtils.YEAR_3;
            project.IPM_Project_Leader__c=globalUser.id;
            project.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            project.IPM_GateKeeping_Model__c=IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT; 
            project.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            project.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
            project.IPM_CompanyCardText__c=IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
            project.IPM_Temporary_Phase__c=IPM_ConstantUtils.EMPTY_STRING_INITIAL;
            project.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
            project.IPM_Target_Launch_Dates__c = targetLaunchDate;
            project.IPM_Project_Job_Status__c=IPM_ConstantUtils.JOB_STATUS_COMPLETED;
            insert project; 

            List<IPM_Project_Rollout__c> rollouts = new List<IPM_Project_Rollout__c>();
            String rolloutLocalRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name=:IPM_ConstantUtils.LOCAL_ROLLOUT_RT].Id;
            IPM_Project_Rollout__c localNonkeyProjectRollout1 =IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
            localNonkeyProjectRollout1.Name=TESTPROJECT001_REG_LOC1;
            localNonkeyProjectRollout1.IPM_Rollout_Project__c = TESTPROJECT001_REG_LOC1;
            localNonkeyProjectRollout1.Regional_Project__c=project.ID;
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
            localNonkeyProjectRollout2.Regional_Project__c=project.ID;
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
            localKeyProjectRollout1.Regional_Project__c=project.ID;
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
            fin1.Regional_Project__c=project.id;
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
            fin2.Regional_Project__c=project.id;
            fin2.Volume_Unit__c=IPM_ConstantUtils.VOLUME_UNIT_TONS;
            fin2.Status__c=NOT_STARTED;
            fin2.Project_Sustainability_Period__c=IPM_ConstantUtils.YEAR_3;//YEAR_5
            fin2.Target_Launch_Date__c = targetLaunchDate;
            fin2.isActive__c = true;
            fins.add(fin2);
            insert fins;

            IPM_Milestone__c milestone = IPM_TestFactory_Helper.createIPMMilestone(project.id,false);
            milestone.IPM_Active__c=true;
            milestone.IPM_Name__c=IPM_ConstantUtils.CHARTER_GATE_APPROVAL_MILESTONE;
            milestone.IPM_Due_Date__c= System.today().addDays(10);
            insert milestone;

            Test.stopTest();
            
            List<IPM_Project__c> projlList=[SELECT Name,IPM_Phase__c, IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c FROM IPM_Project__c WHERE name=:TESTPROJECT001_REG limit 1];
            System.assertEquals(projlList.size(), 1,PROJ_SIZE_MSG);
            
            System.assertEquals(IPM_ConstantUtils.PHASE_IDEAS, projlList[0].IPM_Phase__c,PROJ_PHASE_IDEAS_MSG);
            System.assertEquals(IPM_ConstantUtils.JOB_STATUS_COMPLETED, projlList[0].IPM_Project_Job_Status__c,PROJ_STATUS_COMPLETED_MSG);
            System.assertEquals(targetLaunchDate, projlList[0].IPM_Target_Launch_Dates__c,TLD_MATCH_MSG);
           
            List<IPM_Project_Rollout__c>  projRollOutList=[SELECT Name, Target_Launch_Date__c FROM IPM_Project_Rollout__c WHERE name like 'TestProject001_REG_LOC%' limit 4];
            
            System.assertEquals(3,projRollOutList.size(),'Project rollout(s) size should be 3');
            
            for(IPM_Project_Rollout__c rollout : projRollOutList) {
                
                System.assertEquals(targetLaunchDate, rollout.Target_Launch_Date__c,TLD_MATCH_MSG);
            }
        }
        
    }
   static void setupIdeasPhaseData(){
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
            IPM_Project__c project = IPM_TestFactory_Helper.createIPMProject(false);
            project.Name=TESTPROJECT001;
            project.Sustainability_Period__c=IPM_ConstantUtils.YEAR_3;
            project.IPM_Project_Leader__c=globalUser.id;
            project.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            project.IPM_GateKeeping_Model__c=IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT; 
            project.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
            project.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
            project.IPM_CompanyCardText__c=IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
            project.IPM_Temporary_Phase__c=IPM_ConstantUtils.EMPTY_STRING_INITIAL;
            project.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
            project.IPM_Target_Launch_Dates__c = targetLaunchDate;
            project.IPM_Project_Job_Status__c=IPM_ConstantUtils.JOB_STATUS_COMPLETED;
            insert project; 
    
    
            // create region rollout
            String rolloutRegionlaRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name=:IPM_ConstantUtils.REGIONAL_ROLLOUT_RT].Id;
            IPM_Project_Rollout__c regionalProjectRollout=IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
            regionalProjectRollout.Name=TESTPROJECT001_REG;
            regionalProjectRollout.IPM_Rollout_Project__c = TESTPROJECT001_REG;
            regionalProjectRollout.IPM_Project__c=project.ID;
            regionalProjectRollout.Market_Cluster__c=MARKET_CLUSTER;
            regionalProjectRollout.IPM_Rollout_Span__c=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            regionalProjectRollout.Target_Launch_Date__c = targetLaunchDate;
            regionalProjectRollout.External_Id__c=TESTPROJECT001_REG;
            regionalProjectRollout.RecordTypeId = rolloutRegionlaRecordTypeId;
            regionalProjectRollout.isActive__c=true;
            insert regionalProjectRollout;
    
            
            List<IPM_Project_Rollout__c> rollouts = new List<IPM_Project_Rollout__c>();
            String rolloutLocalRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name=:IPM_ConstantUtils.LOCAL_ROLLOUT_RT].Id;
            IPM_Project_Rollout__c localNonkeyProjectRollout1 =IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
            localNonkeyProjectRollout1.Name=TESTPROJECT001_REG_LOC1;
            localNonkeyProjectRollout1.IPM_Rollout_Project__c = TESTPROJECT001_REG_LOC1;
            localNonkeyProjectRollout1.IPM_Project__c=project.ID;
            localNonkeyProjectRollout1.Regional_Rollout__c=regionalProjectRollout.id;
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
            localNonkeyProjectRollout2.IPM_Project__c=project.ID;
            localNonkeyProjectRollout2.Regional_Rollout__c=regionalProjectRollout.id;
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
            localKeyProjectRollout1.IPM_Project__c=project.ID;
            localKeyProjectRollout1.Regional_Rollout__c=regionalProjectRollout.id;
            localKeyProjectRollout1.Market_Cluster__c=MARKET_CLUSTER;
            localKeyProjectRollout1.IPM_Rollout_Span__c=IPM_ConstantUtils.EMPTY_STRING_INITIAL;
            localKeyProjectRollout1.Target_Launch_Date__c = targetLaunchDate;
            localKeyProjectRollout1.RecordTypeId = rolloutLocalRecordTypeId;
            localKeyProjectRollout1.KeyMCO__c = true;
            localKeyProjectRollout1.External_Id__c=TESTPROJECT001_REG_LOC_K;
            localKeyProjectRollout1.isActive__c=true;
            rollouts.add(localKeyProjectRollout1);
            insert rollouts;
    
            IPM_Financial__c fin1=new IPM_Financial__c();
            String consolidatedRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Consolidated'].Id;
            fin1.RecordTypeId=consolidatedRecordTypeId;
            fin1.Financial_External_ID__c=TESTPROJECT001_CONSOLIDATED;
            fin1.Parent_Project__c=project.id;
            fin1.Volume_Unit__c=IPM_ConstantUtils.VOLUME_UNIT_TONS;
            fin1.Status__c=NOT_STARTED;
            fin1.Project_Sustainability_Period__c=IPM_ConstantUtils.YEAR_3;//YEAR_5
            fin1.Target_Launch_Date__c = targetLaunchDate;
            fin1.isActive__c=true;
            insert fin1;
    
    
            IPM_Milestone__c milestone = IPM_TestFactory_Helper.createIPMMilestone(project.id,false);
            milestone.IPM_Active__c=true;
            milestone.IPM_Name__c=IPM_ConstantUtils.CHARTER_GATE_APPROVAL_MILESTONE;
            milestone.IPM_Due_Date__c= System.today().addDays(10);
            insert milestone;
            
            Test.stopTest();
            
            List<IPM_Project__c> projlList=[SELECT Name,IPM_Phase__c, IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c FROM IPM_Project__c WHERE name=:TESTPROJECT001 limit 1];
            System.assertEquals(projlList.size(), 1,PROJ_SIZE_MSG);
            
            System.assertEquals(IPM_ConstantUtils.PHASE_IDEAS, projlList[0].IPM_Phase__c,PROJ_PHASE_IDEAS_MSG);
            System.assertEquals(IPM_ConstantUtils.JOB_STATUS_COMPLETED, projlList[0].IPM_Project_Job_Status__c,PROJ_STATUS_COMPLETED_MSG);
            System.assertEquals(targetLaunchDate, projlList[0].IPM_Target_Launch_Dates__c,TLD_MATCH_MSG);
            
    
            List<IPM_Project_Rollout__c>  projRollOutList=[SELECT Name, Target_Launch_Date__c FROM IPM_Project_Rollout__c WHERE name= :TESTPROJECT001_REG limit 1];
            System.assertEquals(projRollOutList.size(), 1,PROJ_ROLLOUT_SIZE_MSG);
            
            System.assertEquals(targetLaunchDate, projRollOutList[0].Target_Launch_Date__c,TLD_MATCH_MSG);
    
    
            projRollOutList=[SELECT Name, Target_Launch_Date__c FROM IPM_Project_Rollout__c WHERE name like 'TestProject001_REG_LOC%' limit 4];
            
            System.assertEquals(3,projRollOutList.size(),'Project rollout(s) size should be 3');
            
            for(IPM_Project_Rollout__c rollout : projRollOutList) {
                
                System.assertEquals(targetLaunchDate, rollout.Target_Launch_Date__c,TLD_MATCH_MSG);
            }
        }
    }
    static void setupFeasibilityPhaseDataForLocalProject(){
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
        
            IPM_Project__c project = IPM_TestFactory_Helper.createIPMProject(false);
            project.Name=TESTPROJECT001;
            project.Sustainability_Period__c=IPM_ConstantUtils.YEAR_3;
            project.IPM_Project_Leader__c=globalUser.id;
            project.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            project.IPM_GateKeeping_Model__c=IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT; 
            project.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
            project.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
            project.IPM_CompanyCardText__c=IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
            project.IPM_Temporary_Phase__c=IPM_ConstantUtils.EMPTY_STRING_INITIAL;
            project.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
            project.IPM_Target_Launch_Dates__c = targetLaunchDate;
            project.IPM_Project_Job_Status__c=IPM_ConstantUtils.JOB_STATUS_COMPLETED;
            project.IPM_ProjectJobType__c=IPM_ConstantUtils.JOBTYPE_PHASECHANGE;
            insert project; 
                    
            String rolloutRegionlaRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name=:IPM_ConstantUtils.REGIONAL_ROLLOUT_RT].Id;
            IPM_Project_Rollout__c regionalProjectRollout=IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
            regionalProjectRollout.Name=TESTPROJECT001_REG;
            regionalProjectRollout.IPM_Rollout_Project__c = TESTPROJECT001_REG;
            regionalProjectRollout.IPM_Project__c=project.ID;
            regionalProjectRollout.Market_Cluster__c=MARKET_CLUSTER;
            regionalProjectRollout.IPM_Rollout_Span__c=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            regionalProjectRollout.Target_Launch_Date__c = targetLaunchDate;
            regionalProjectRollout.External_Id__c=TESTPROJECT001_REG;
            regionalProjectRollout.RecordTypeId = rolloutRegionlaRecordTypeId;
            regionalProjectRollout.IPM_Project_Job_Status__c=IPM_ConstantUtils.JOB_STATUS_COMPLETED;
            regionalProjectRollout.IPM_RolloutJobType__c=IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_PHASECHANGE;
            regionalProjectRollout.IPM_Rollout_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            regionalProjectRollout.IPM_Regional_PL__c=regionalUser.id;
            regionalProjectRollout.isActive__c=true;
            insert regionalProjectRollout;
    
            IPM_Project__c rolloutProject = IPM_TestFactory_Helper.createIPMProject(false);
            rolloutProject.Name=TESTPROJECT001_REG;
            rolloutProject.Sustainability_Period__c=IPM_ConstantUtils.YEAR_3;
            rolloutProject.IPM_Project_Leader__c=regionalUser.id;
            rolloutProject.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            rolloutProject.IPM_GateKeeping_Model__c=IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT; 
            rolloutProject.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            rolloutProject.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
            rolloutProject.IPM_CompanyCardText__c=IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_GLOBAL;
            rolloutProject.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
            rolloutProject.IPM_Target_Launch_Dates__c = targetLaunchDate;
            rolloutProject.IPM_Project_Name__c=TESTPROJECT001_REG;
            rolloutProject.IPM_Parent_Project__c=project.ID;
            rolloutProject.IPM_ProjectJobType__c=PROJECT_CREATION;
            rolloutProject.IPM_Project_Job_Status__c=IPM_ConstantUtils.JOB_STATUS_COMPLETED;
            insert rolloutProject; 
            
            List<IPM_Project_Rollout__c> rollouts = new List<IPM_Project_Rollout__c>();
            String rolloutLocalRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name=:IPM_ConstantUtils.LOCAL_ROLLOUT_RT].Id;
            IPM_Project_Rollout__c localNonkeyProjectRollout1 =IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
            localNonkeyProjectRollout1.Name=TESTPROJECT001_REG_LOC1;
            localNonkeyProjectRollout1.IPM_Rollout_Project__c = TESTPROJECT001_REG_LOC1;
            localNonkeyProjectRollout1.IPM_Project__c=project.ID;
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
            localNonkeyProjectRollout2.IPM_Project__c=project.ID;
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
            localProject.IPM_Project_Leader__c=localUser.id;
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
    
            List<IPM_Financial__c> financials = new List<IPM_Financial__c>();
            IPM_Financial__c fin1=new IPM_Financial__c();
            String defaultRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Default'].Id;
            fin1.RecordTypeId=defaultRecordTypeId;
            fin1.Financial_External_ID__c='TestProject001_REG_NONKEY';
            fin1.Regional_Project__c=rolloutProject.id;
            fin1.Local_Project__c=localProject.id;
            fin1.Volume_Unit__c=IPM_ConstantUtils.VOLUME_UNIT_TONS;
            fin1.Status__c=IPM_ConstantUtils.STATUS_IN_PROGRESS;
            fin1.Project_Sustainability_Period__c=IPM_ConstantUtils.YEAR_3;//YEAR_5
            fin1.Target_Launch_Date__c = targetLaunchDate;
            fin1.isActive__c=true;
            financials.add(fin1);
    
            IPM_Financial__c fin3=new IPM_Financial__c();
            String consolidatedRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Consolidated'].Id;
            fin3.RecordTypeId=consolidatedRecordTypeId;
            fin3.Financial_External_ID__c=TESTPROJECT001_CONSOLIDATED;
            fin3.Parent_Project__c=project.id;
            fin3.Volume_Unit__c=IPM_ConstantUtils.VOLUME_UNIT_TONS;
            fin3.Status__c=NOT_STARTED;
            fin3.Project_Sustainability_Period__c=IPM_ConstantUtils.YEAR_3;//YEAR_5
            fin3.Target_Launch_Date__c = targetLaunchDate;
            fin3.isActive__c=true;
            financials.add(fin3);
            insert financials;
            
            financials = new List<IPM_Financial__c>();
            IPM_Financial__c ipmFinancials1 = [select id from IPM_Financial__c where Financial_External_ID__c='TestProject001_REG_CONSOLIDATED' limit 1];
            ipmFinancials1.Regional_Project__c = rolloutProject.id;
            ipmFinancials1.isActive__c=true;
            financials.add(ipmFinancials1);
            
            IPM_Financial__c ipmFinancials2 = [select id from IPM_Financial__c where Financial_External_ID__c='TestProject001_REG_NONKEY' limit 1];
            ipmFinancials2.Regional_Project__c = rolloutProject.id;
            ipmFinancials2.IPM_Project_Rollout__c = regionalProjectRollout.id;
            ipmFinancials2.isActive__c=true;
            financials.add(ipmFinancials2);
    
            IPM_Financial__c ipmFinancials3 = [select id from IPM_Financial__c where Financial_External_ID__c=:TESTPROJECT001_REG_LOC1 limit 1];
            ipmFinancials3.Regional_Project__c=rolloutProject.id;
            ipmFinancials3.Local_Project__c=localProject.id;
            ipmFinancials3.isActive__c=true;
            financials.add(ipmFinancials3);
   
            update financials;

            IPM_Milestone__c milestone = IPM_TestFactory_Helper.createIPMMilestone(project.id,false);
            milestone.IPM_Active__c=true;
            milestone.IPM_Name__c=IPM_ConstantUtils.CONTRACT_GATE_APPROVAL_MILESTONE;
            milestone.IPM_Due_Date__c= System.today().addDays(10);
            insert milestone;

            Test.stopTest();
            
            List<IPM_Project__c> globalProjList=[SELECT Name,IPM_Phase__c, IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c,IPM_ProjectJobType__c FROM IPM_Project__c WHERE name=:TESTPROJECT001 limit 1];
            System.assertEquals(globalProjList.size(), 1,PROJ_SIZE_MSG);
            
            globalProjList[0].IPM_Phase__c=IPM_ConstantUtils.PHASE_FEASIBILITY;
            update globalProjList[0];
            System.assertEquals(IPM_ConstantUtils.PHASE_FEASIBILITY, globalProjList[0].IPM_Phase__c,PROJ_PHASE_FEASIBILITY_MSG);
            System.assertEquals(IPM_ConstantUtils.JOB_STATUS_COMPLETED, globalProjList[0].IPM_Project_Job_Status__c,PROJ_STATUS_COMPLETED_MSG);
            System.assertEquals(targetLaunchDate, globalProjList[0].IPM_Target_Launch_Dates__c,TLD_MATCH_MSG);
            
            List<IPM_Project__c> regionalProjList=[SELECT Name,IPM_Phase__c, IPM_Project_Job_Status__c, IPM_Target_Launch_Dates__c, IPM_ProjectJobType__c, IPMProject_Span__c, IPM_Project_Type__c,IPM_Parent_Project__c, (Select id, name, Financial_External_ID__c, Target_Launch_Date__c From IPM_Financials_Regional__r)   FROM IPM_Project__c WHERE name=:TESTPROJECT001_REG limit 2];
            System.assertEquals(regionalProjList.size(), 1,PROJ_SIZE_MSG);
            
            regionalProjList[0].IPM_Phase__c=IPM_ConstantUtils.PHASE_FEASIBILITY;
            update regionalProjList[0];
            System.assertEquals(IPM_ConstantUtils.PHASE_FEASIBILITY, regionalProjList[0].IPM_Phase__c,PROJ_PHASE_FEASIBILITY_MSG);
            System.assertEquals(IPM_ConstantUtils.JOB_STATUS_COMPLETED, regionalProjList[0].IPM_Project_Job_Status__c,PROJ_STATUS_COMPLETED_MSG);
            System.assertEquals(targetLaunchDate, regionalProjList[0].IPM_Target_Launch_Dates__c,TLD_MATCH_MSG);
            System.assertEquals(PROJECT_CREATION, regionalProjList[0].IPM_ProjectJobType__c,'Project type should be Project Creation');
            System.assertEquals(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL, regionalProjList[0].IPMProject_Span__c,'Project span should be Regional');
            System.assertEquals(IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT, regionalProjList[0].IPM_Project_Type__c,'Project type should be Rollout');
            System.assertEquals(globalProjList[0].id, regionalProjList[0].IPM_Parent_Project__c,'Project id should match with parent project');
            for( IPM_Financial__c ipmFinancial: regionalProjList[0].IPM_Financials_Regional__r) {
                System.debug('RTDebug ipmFinancial.Financial_External_ID__c ' + ipmFinancial.Financial_External_ID__c);
            }
            // 1 Consolidated, 2 Nonkey, 1 local
            System.assertEquals(4,regionalProjList[0].IPM_Financials_Regional__r.size(),'Project(s) size should be 3');
            
            List<IPM_Project_Rollout__c>  regionalRolloutList=[SELECT Name, Target_Launch_Date__c, IPM_Project_Job_Status__c, IPM_RolloutJobType__c, IPM_Rollout_Span__c, IPM_Rollout_Type__c,IPM_Project__c, RecordTypeId, (Select Name, Financial_External_ID__c, Target_Launch_Date__c From IPM_Financials__r)   FROM IPM_Project_Rollout__c WHERE name=:TESTPROJECT001_REG limit 2];
            System.assertEquals(regionalRolloutList.size(), 1,PROJ_ROLLOUT_SIZE_MSG);
            
            System.assertEquals(targetLaunchDate, regionalRolloutList[0].Target_Launch_Date__c,TLD_MATCH_MSG);
            System.assertEquals('Completed', regionalRolloutList[0].IPM_Project_Job_Status__c,'Project rollout status should be Completed');
            System.assertEquals('Phase Change - Rollout Project Creation', regionalRolloutList[0].IPM_RolloutJobType__c,'Project rollout type should be Project Creation');
            System.assertEquals(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL, regionalRolloutList[0].IPM_Rollout_Span__c,'Project rollout span should be Regional');
            System.assertEquals('Rollout', regionalRolloutList[0].IPM_Rollout_Type__c,'Project rollout type should be Rollout');
            System.assertEquals(globalProjList[0].id, regionalRolloutList[0].IPM_Project__c,'Project rollout project id should match with parent project');
            System.assertEquals(rolloutRegionlaRecordTypeId, regionalRolloutList[0].RecordTypeId,'Record Id should match');
            // 1 Consolidated, 1 Nonkey
            System.assertEquals(2,regionalRolloutList[0].IPM_Financials__r.size(),'Project rollout(s) size should be 2');
            
                
            List<IPM_Project__c> localProjList=[SELECT IPM_Project_Rollout__c,Name,IPM_Phase__c, IPM_Project_Job_Status__c, IPM_Target_Launch_Dates__c, IPM_ProjectJobType__c, IPMProject_Span__c, IPM_Project_Type__c,IPM_Parent_Project__c, (Select id, name, Financial_External_ID__c, Target_Launch_Date__c From IPM_Financials_Local__r)   FROM IPM_Project__c WHERE name=:TESTPROJECT001_REG_LOC1 limit 2];
            System.assertEquals(localProjList.size(), 1,'Project(s) size should be 3');
            System.assertEquals(rolloutProject.ID, localProjList[0].IPM_Parent_Project__c,'Project rollout project id should match with parent project');
            System.assertEquals(regionalProjectRollout.ID, localProjList[0].IPM_Project_Rollout__c,'Project rollout id should match with rollout project');
            // 1 loal
            System.assertEquals(2,localProjList[0].IPM_Financials_Local__r.size(),'Project financial(s) size should be 1');
        }
    }
	static testMethod void testValidateMilestoneAndFinacialData_IdeasProject() {
		setupIdeasPhaseData();
		List<IPM_Project__c> projlList=[SELECT Name,IPM_Phase__c, IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c,IPM_Project_Type__c,IPMProject_Span__c FROM IPM_Project__c WHERE name=:TESTPROJECT001 limit 1];
  		System.assertEquals(projlList.size(), 1,PROJ_SIZE_MSG);
  		List<IPM_Milestone__c> ipmMs = [Select Id, Name, IPM_Name__c,IPM_Due_Date__c,IPM_Planned_Date__c,IPM_Type_of_Milestone__c,ExternalField__c from IPM_Milestone__c WHERE IPM_Project__c =:projlList[0].id];
        System.debug('RTDebug ipmMs.size ' + ipmMs.size());
        System.debug('RTDebug ipmMs ' + ipmMs);
        List<IPM_Project__c> invalidProjlList = IPM_ValidationHelper.validateMilestoneAndFinacialData(projlList); 
        System.assertEquals(invalidProjlList.size(), 1,PROJ_SIZE_MSG);
  		System.assertEquals(projlList[0].id,invalidProjlList[0].id,INVALIE_PROJECT);
  		   
	}
	static testMethod void testValidateMilestoneAndFinacialData_IdeasRegionalOriginalProject() {
		setupRegionalOriginalIdeasPhaseData();
		List<IPM_Project__c> projlList=[SELECT Name,IPM_Phase__c, IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c,IPM_Project_Type__c,IPMProject_Span__c FROM IPM_Project__c WHERE name=:TESTPROJECT001_REG limit 1];
  		System.assertEquals(projlList.size(), 1,PROJ_SIZE_MSG);
  		List<IPM_Milestone__c> ipmMs = [Select Id, Name, IPM_Name__c,IPM_Due_Date__c,IPM_Planned_Date__c,IPM_Type_of_Milestone__c,ExternalField__c from IPM_Milestone__c WHERE IPM_Project__c =:projlList[0].id];
        System.debug('RTDebug ipmMs.size ' + ipmMs.size());
        System.debug('RTDebug ipmMs ' + ipmMs);
        List<IPM_Project__c> invalidProjlList = IPM_ValidationHelper.validateMilestoneAndFinacialData(projlList); 
        System.assertEquals(invalidProjlList.size(), 1,PROJ_SIZE_MSG);
  		System.assertEquals(projlList[0].id,invalidProjlList[0].id,INVALIE_PROJECT);
  		   
	}
	static testMethod void testValidateMilestoneAndFinacialData_FeasibilityProject() {
		setupFeasibilityPhaseDataForLocalProject();
		List<IPM_Project__c> projlList=[SELECT Name,IPM_Phase__c, IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c,IPM_Project_Type__c,IPMProject_Span__c FROM IPM_Project__c WHERE name=:TESTPROJECT001 limit 1];
  		System.assertEquals(projlList.size(), 1,PROJ_SIZE_MSG);
  		List<IPM_Milestone__c> ipmMs = [Select Id, Name, IPM_Name__c,IPM_Due_Date__c,IPM_Planned_Date__c,IPM_Type_of_Milestone__c,ExternalField__c from IPM_Milestone__c WHERE IPM_Project__c =:projlList[0].id];
        System.debug('RTDebug ipmMs.size ' + ipmMs.size());
        System.debug('RTDebug ipmMs ' + ipmMs);
        List<IPM_Project__c> invalidProjlList = IPM_ValidationHelper.validateMilestoneAndFinacialData(projlList); 
        System.assertEquals(invalidProjlList.size(), 1,PROJ_SIZE_MSG);
  		System.assertEquals(projlList[0].id,invalidProjlList[0].id,INVALIE_PROJECT);
  		   
	}
	
}