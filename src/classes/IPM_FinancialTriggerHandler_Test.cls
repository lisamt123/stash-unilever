/**
* @author       Cognizant 
* @date         15/04/2015
* @description  This class is used to test the functionality of IPM_FinancialTriggerHandler class 
*/
@isTest
public class IPM_FinancialTriggerHandler_Test {    
    private static String TESTPROJECT = 'TestProject001_REG'; 
    private static String TESTPROJECT_LOC = 'TestProject001_REG_LOC1';
    static void initializeData(){
        Test.startTest();
        Date targetLaunchDate = System.today().addYears(3);
        //Creation test user
        User globalUser = IPM_TestFactory_Helper.createUserAdmin(false);
        globalUser.email = 'globalUser@unilever.test.com';
        globalUser.IPM_Role__c = IPM_ConstantUtils.USER_FUNCTON_PL;
         
        User regionalUser = IPM_TestFactory_Helper.createUserAdmin(false);
        regionalUser.email = 'regionalUser@unilever.test.com';
        regionalUser.IPM_Role__c = IPM_ConstantUtils.IPM_ROLE_FINANCE;

        User localUser = IPM_TestFactory_Helper.createUserAdmin(false);
        localUser.email = 'localUser@unilever.test.com';
        localUser.IPM_Role__c = IPM_ConstantUtils.IPM_ROLE_FINANCE;
        localUser.ManagerId = UserInfo.getUserId();
        
        List<User> userList = new List<User>{globalUser,regionalUser,localUser};
        
        
        insert userList;
 
        IPM_Project__c project = IPM_TestFactory_Helper.createIPMProject(false);
        project.Name='TestProject001';
        project.Sustainability_Period__c='3';
        project.IPM_Project_Leader__c=globalUser.id;
        project.IPM_Project_Type__c='Original';
        project.IPM_GateKeeping_Model__c='RCLT'; 
        project.IPMProject_Span__c='Global';
        project.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
        project.IPM_CompanyCardText__c='Global Company Card';
        project.IPM_Temporary_Phase__c='';
        project.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
        project.IPM_Target_Launch_Dates__c = System.today().addYears(3);
        project.IPM_Project_Job_Status__c=IPM_ConstantUtils.JOB_STATUS_COMPLETED;
        project.IPM_ProjectJobType__c=IPM_ConstantUtils.JOBTYPE_PHASECHANGE;
        insert project; 
                
        String rolloutRegionlaRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name=:IPM_ConstantUtils.REGIONAL_ROLLOUT_RT].Id;
        IPM_Project_Rollout__c regionalProjectRollout=IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
        regionalProjectRollout.Name=TESTPROJECT;
        regionalProjectRollout.IPM_Rollout_Project__c = TESTPROJECT;
        regionalProjectRollout.IPM_Project__c=project.ID;
        regionalProjectRollout.Market_Cluster__c='GEO0060';
        regionalProjectRollout.IPM_Rollout_Span__c='Regional';
        regionalProjectRollout.Target_Launch_Date__c = System.today().addYears(3);
        regionalProjectRollout.External_Id__c=TESTPROJECT;
        regionalProjectRollout.RecordTypeId = rolloutRegionlaRecordTypeId;
        regionalProjectRollout.IPM_Project_Job_Status__c=IPM_ConstantUtils.JOB_STATUS_COMPLETED;
        regionalProjectRollout.IPM_RolloutJobType__c=IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_PHASECHANGE;
        regionalProjectRollout.IPM_Rollout_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        regionalProjectRollout.IPM_Regional_PL__c=regionalUser.id;
        insert regionalProjectRollout;

        IPM_Project__c rolloutProject = IPM_TestFactory_Helper.createIPMProject(false);
        rolloutProject.Name=TESTPROJECT;
        rolloutProject.Sustainability_Period__c='3';
        rolloutProject.IPM_Project_Leader__c=regionalUser.id;
        rolloutProject.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        rolloutProject.IPM_GateKeeping_Model__c='RCLT'; 
        rolloutProject.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
        rolloutProject.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
        rolloutProject.IPM_CompanyCardText__c='Global Company Card';
        rolloutProject.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
        rolloutProject.IPM_Target_Launch_Dates__c = System.today().addYears(3);
        rolloutProject.IPM_Project_Name__c=TESTPROJECT;
        rolloutProject.IPM_Parent_Project__c=project.ID;
        rolloutProject.IPM_ProjectJobType__c='Project Creation';
        rolloutProject.IPM_Project_Job_Status__c=IPM_ConstantUtils.JOB_STATUS_COMPLETED;
        insert rolloutProject; 
        
        List<IPM_Project_Rollout__c> rollouts = new List<IPM_Project_Rollout__c>();
        String rolloutLocalRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name=:IPM_ConstantUtils.LOCAL_ROLLOUT_RT].Id;
        IPM_Project_Rollout__c localNonkeyProjectRollout1 =IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
        localNonkeyProjectRollout1.Name=TESTPROJECT_LOC;
        localNonkeyProjectRollout1.IPM_Rollout_Project__c = TESTPROJECT_LOC;
        localNonkeyProjectRollout1.IPM_Project__c=project.ID;
        localNonkeyProjectRollout1.Regional_Rollout__c=regionalProjectRollout.id;
        localNonkeyProjectRollout1.Market_Cluster__c='GEO0060';
        localNonkeyProjectRollout1.IPM_Rollout_Span__c=IPM_ConstantUtils.ROLLOUT_SPAN_LOCAL;
        localNonkeyProjectRollout1.Target_Launch_Date__c = targetLaunchDate;
        localNonkeyProjectRollout1.RecordTypeId = rolloutLocalRecordTypeId;
        localNonkeyProjectRollout1.KeyMCO__c = false;
        localNonkeyProjectRollout1.External_Id__c=TESTPROJECT_LOC;
        localNonkeyProjectRollout1.Regional_Project__c=rolloutProject.id;
        localNonkeyProjectRollout1.IPM_RolloutJobType__c=IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
        localNonkeyProjectRollout1.IPM_Rollout_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        localNonkeyProjectRollout1.IPM_Project_Job_Status__c=IPM_ConstantUtils.JOB_STATUS_COMPLETED;
        rollouts.add(localNonkeyProjectRollout1);

        IPM_Project_Rollout__c localNonkeyProjectRollout2 =IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
        localNonkeyProjectRollout2.Name='TestProject001_REG_LOC2';
        localNonkeyProjectRollout2.IPM_Rollout_Project__c = 'TestProject001_REG_LOC2';
        localNonkeyProjectRollout2.IPM_Project__c=project.ID;
        localNonkeyProjectRollout2.Regional_Rollout__c=regionalProjectRollout.id;
        localNonkeyProjectRollout2.Market_Cluster__c='GEO0060';
        localNonkeyProjectRollout2.IPM_Rollout_Span__c=IPM_ConstantUtils.ROLLOUT_SPAN_LOCAL;
        localNonkeyProjectRollout2.Target_Launch_Date__c = targetLaunchDate;
        localNonkeyProjectRollout2.RecordTypeId = rolloutLocalRecordTypeId;
        localNonkeyProjectRollout2.KeyMCO__c = false;
        localNonkeyProjectRollout2.External_Id__c='TestProject001_REG_LOC2';
        localNonkeyProjectRollout2.Regional_Project__c=rolloutProject.id;
        localNonkeyProjectRollout2.IPM_RolloutJobType__c=IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_ADHOC;
        localNonkeyProjectRollout2.IPM_Rollout_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        localNonkeyProjectRollout2.IPM_Project_Job_Status__c=IPM_ConstantUtils.JOB_STATUS_COMPLETED;
        rollouts.add(localNonkeyProjectRollout2);

        insert rollouts;

        IPM_Project__c localProject = IPM_TestFactory_Helper.createIPMProject(false);
        localProject.Name=TESTPROJECT_LOC;
        localProject.Sustainability_Period__c='3';
        localProject.IPM_Project_Leader__c=localUser.id;
        localProject.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        localProject.IPM_GateKeeping_Model__c='RCLT'; 
        localProject.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
        localProject.IPM_Phase__c=IPM_ConstantUtils.PHASE_IDEAS;
        localProject.IPM_CompanyCardText__c='Global Company Card';
        localProject.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
        localProject.IPM_Target_Launch_Dates__c = System.today().addYears(3);
        localProject.IPM_Project_Name__c=TESTPROJECT_LOC;
        localProject.IPM_Parent_Project__c=rolloutProject.ID;
        localProject.IPM_Project_Rollout__c = regionalProjectRollout.id;
        localProject.IPM_ProjectJobType__c='Project Creation';
        localProject.IPM_Project_Job_Status__c=IPM_ConstantUtils.JOB_STATUS_COMPLETED;
        insert localProject; 

        List<IPM_Financial__c> financials = new List<IPM_Financial__c>();
        IPM_Financial__c fin1=new IPM_Financial__c();
        String defaultRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Default'].Id;
        fin1.RecordTypeId=defaultRecordTypeId;
        fin1.Financial_External_ID__c=TESTPROJECT_LOC;
        fin1.Regional_Project__c=rolloutProject.id;
        fin1.Local_Project__c=localProject.id;
        fin1.Volume_Unit__c=IPM_ConstantUtils.VOLUME_UNIT_TONS;
        fin1.Status__c=IPM_ConstantUtils.STATUS_IN_PROGRESS;
        fin1.Project_Sustainability_Period__c=IPM_ConstantUtils.YEAR_3;//YEAR_5
        fin1.Target_Launch_Date__c = targetLaunchDate;
        financials.add(fin1);

        IPM_Financial__c fin3=new IPM_Financial__c();
        String consolidatedRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Consolidated'].Id;
        fin3.RecordTypeId=consolidatedRecordTypeId;
        fin3.Financial_External_ID__c='TestProject001_CONSOLIDATED';
        fin3.Parent_Project__c=project.id;
        fin3.Volume_Unit__c=IPM_ConstantUtils.VOLUME_UNIT_TONS;
        fin3.Status__c='Not Started';
        fin3.Project_Sustainability_Period__c=IPM_ConstantUtils.YEAR_3;//YEAR_5
        fin3.Target_Launch_Date__c = targetLaunchDate;
        financials.add(fin3);
        insert financials;
        Test.stopTest();
   }
       
    static testMethod void testOnBeforeDelete() {
        initializeData();
        IPM_Financial__c ipmFinancials3 = [select id from IPM_Financial__c where Financial_External_ID__c=:TESTPROJECT_LOC limit 1];
        System.assert(ipmFinancials3.id!=null);
        delete ipmFinancials3;
        try {
            ipmFinancials3 = [select id from IPM_Financial__c where Financial_External_ID__c=:TESTPROJECT_LOC limit 1];
            System.assert(false);
        } catch( QueryException qe ){
            System.assert(true);
        }
        
    }
}