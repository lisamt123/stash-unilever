/**
   @Author: Cognizant
   @name : IPM_BETDueDateNotificationBatch_Test
   @CreateDate : 10/01/2015
   @Description : Test class for IPM_BETDueDateNotificationBatch
   @Version <1.0>
   @reference 
  */
  
@isTest
private class IPM_BETDueDateNotificationBatch_Test{
     
    private static IPM_Project__c project;
    private static List<IPM_Project__c> lstProjects;
    private static IPM_Milestone__c ipmMilestone;
    private static List<IPM_Milestone__c> lstIpmMilestones;
    private static IPM_Company_Card__c ipmCompanyCard;
    private static Map<Id, IPM_Project__c> mapProjects;
    private static final String PROJECT_INSERTED_ASSERTION = 'Projects Not Inserted';
    private static final String TESTPROJECTNAME = 'Acme';
    private static final String MILESTONE_INSERTED_ASSERTION = 'Milestones not Inserted';    
    private static final String BATCH_FAILURE = 'Batch excecution failed!';
    private static final String COMPANY_CARD_INSERTED_ASSERTION= 'Company card not inserted';
    private static final String  FEED_UPDATE_NOT_ASSERTED = 'Feed not Updated successfully';
    private static final String  BET_FIRSTMILESTONE_NAME = 'BETFirstRelease';
    private static final String  BET_FINALMILESTONE_NAME = 'BETFinalRelease';
    private static User platformUser;
    
    /*Desciption:- Method to initialise test data
    @param mileStoneDuteDate:- Due date of milestone which will be different for different test scenarios
    */
    
    private static void initializeData(Date mileStoneDuteDate, String milestoneName){
        
        Set<Id> iDs = new Set<Id>();
        
        user systAdmin=IPM_TestFactory_Helper.createUserAdmin(false);
        system.runAS(systAdmin){
            ipmCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
            ipmCompanyCard.IPM_Business_Partner__c = UserInfo.getUserId();
            insert ipmCompanyCard;
        }
        
        System.assertEquals(1, [Select count() from IPM_Company_Card__c where id =: ipmCompanyCard.id],COMPANY_CARD_INSERTED_ASSERTION);
        
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
        System.runAs(platformUser) 
        {
        lstProjects = new List<IPM_Project__c>();
        for(Integer i=1; i<=20; i++){
            project = IPM_TestFactory_Helper.createIPMProject(false);
            project.name = TESTPROJECTNAME+i;
            project.IPM_Project_Name__c = TESTPROJECTNAME+i;
            project.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;    
            project.IPM_Temporary_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;     
            project.IPM_Complexity__c = IPM_ConstantUtils.COMPLEXITY_FULL;
            project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            project.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
            project.Deputy_Project_Leader__c = UserInfo.getUserId();
            project.IPM_Project_Leader__c = UserInfo.getUserId();
            project.IPM_Finance_Member__c = UserInfo.getUserId();
            project.IPM_Target_Launch_Dates__c = System.today()+400;
            project.IPM_Company_Card__c = ipmCompanyCard.id;
            
            lstProjects.add(project);
        }
        insert lstProjects;
        
        for(IPM_Project__c eachProj : lstProjects) {
            iDs.add(eachProj.Id);
        }
        System.assertEquals(20, [Select count() from IPM_Project__c where id in:iDs],PROJECT_INSERTED_ASSERTION);
        
        Id  PROJECT_MILESTONE_RECTYPE = Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.milePMRecordType).getRecordTypeId(); 
        lstIpmMilestones = new List<IPM_Milestone__c>();
        for(Integer i=1; i<=20; i++){
            ipmMilestone = IPM_TestFactory_Helper.createIPMMilestone(lstProjects[i-1].id, false);
            ipmMilestone.Name = milestoneName+i;
            ipmMilestone.IPM_Project__c = project.id;
            ipmMilestone.IPM_Due_Date__c = mileStoneDuteDate;
            ipmMilestone.IPM_Name__c = milestoneName+i;
            ipmMilestone.IPM_Type_of_gate__c = IPM_ConstantUtils.CHARTER_GATE;
            ipmMilestone.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
            ipmMilestone.IPM_Type_of_Milestone__c = IPM_ConstantUtils.BET;
            ipmMilestone.IPM_Completed_On__c = null;
			ipmMilestone.RecordTypeId = PROJECT_MILESTONE_RECTYPE; 
            lstIpmMilestones.add(ipmMilestone);
            
        }
        insert lstIpmMilestones;
        System.assertEquals(20, lstIpmMilestones.size(),MILESTONE_INSERTED_ASSERTION);
        for(IPM_Milestone__c eachMilestone : lstIpmMilestones) {
            iDs.add(eachMilestone.Id);
        }
        System.assertEquals(20, [Select count() from IPM_Milestone__c where id in:iDs],MILESTONE_INSERTED_ASSERTION);
        }
    }
     
    /**
    *  Description : when BET milestone first release due date is after 15 days from today then chatter feed should get post for PLs. 
    *  @name chatterFeedPostForFirstReleasePositive
   */
    private static testmethod void testChatterFeedPostForFirstReleasePositive(){
        
            initializeData(System.today() + 15, BET_FIRSTMILESTONE_NAME);
            
            Test.startTest();    
            executeBatch();
            mapProjects = new Map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 200]);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
            	//To check that the chatter post is fired exactly when first release date is 15 days from now
                System.assert(projectFeed.Body.contains(IPM_ConstantUtils.BET_FINAL_RELEASE_MESSAGE_STR1),FEED_UPDATE_NOT_ASSERTED);
            }
            Test.stopTest();
    }
    
    /**
    *  Description : when BET milestone first release due date is after 15 days from today then chatter feed should get post for PLs. 
    *  @name chatterFeedPostForFirstReleasePositive
   */
    private static testmethod void testChatterFeedPostForFinalReleasePositive(){
       
          initializeData(System.today() + 15, BET_FINALMILESTONE_NAME);
            
            Test.startTest();    
            executeBatch();
            mapProjects = new Map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 200]);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
            	//To check that the chatter post is fired exactly when final release date is 15 days from now
                System.assert(projectFeed.Body.contains(IPM_ConstantUtils.BET_FINAL_RELEASE_MESSAGE_STR1),FEED_UPDATE_NOT_ASSERTED);
            }
            Test.stopTest();
    }
    
    /**
    *  Description : when BET milestone first release due date is 10 days from today then chatter feed should not get post for PLs. 
    *  @name chatterFeedPostForFirstReleasePositive
   */
    private static testmethod void testChatterFeedPostForFirstReleaseNegative(){
        
            initializeData(System.today() + 10, BET_FIRSTMILESTONE_NAME);
            
            Test.startTest();    
            executeBatch();
            mapProjects = new Map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 200]);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
            	//To check that the chatter post is not fired when first release date is 10 days from now
                System.assert(!projectFeed.Body.contains(IPM_ConstantUtils.BET_FINAL_RELEASE_MESSAGE_STR1),FEED_UPDATE_NOT_ASSERTED);
            }
            Test.stopTest();
    }
    
    /**
    *  Description : when BET milestone first release due date is 10 days from today then chatter feed should not get post for PLs. 
    *  @name chatterFeedPostForFirstReleasePositive
   */
    private static testmethod void testChatterFeedPostForFinalReleaseNegative(){
        
            initializeData(System.today() + 10, BET_FINALMILESTONE_NAME);
            
            Test.startTest();    
            executeBatch();
            mapProjects = new Map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 200]);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
            	//To check that the chatter post is not fired when final release date is 10 days from now
                System.assert(!projectFeed.Body.contains(IPM_ConstantUtils.BET_FINAL_RELEASE_MESSAGE_STR1),FEED_UPDATE_NOT_ASSERTED);
            }
            Test.stopTest();
        
    }
    
    //Generic method to execute batch  
    private static void executeBatch(){
        IPM_BETDueDateNotificationBatch betNotificationBatch = new IPM_BETDueDateNotificationBatch();
        Id batchId = database.executeBatch(betNotificationBatch);
        System.assert(batchId!= NULL, BATCH_FAILURE);
    }
    
}