/**
   @Author: Cognizant
   @name : IPM_DueDateNotificationBatch_Test
   @CreateDate : 10/01/2015
   @Description : Test class for IPM_DueDateNotificationBatch
   @Version <1.0>
   @reference 
  */
  
@isTest
private class IPM_DueDateNotificationBatch_Test { 
    private static User platformUser;
    private static List<IPM_Project__c> projectList  ;
    private static final String  FEED_UPDATED_ASSERT = 'Feed Not Updated';
    private static final String PROJECT_NOT_INSERTED = 'Projects Not Inserted';
    private static final String MILESTONE_NOT_INSERTED='Milestone is not inserted';
    private static final String MILESTONE_NOT_UPDATED='Milestone is not updated';
    private static final String PROJECT_NOT_UPDATED = 'Projects not updated';
    private static final String BATCH_FAILURE = 'Batch not excecuted successfully!';
    private static final String  USER_NAME ='PLATFORM_USER';
    private static final String  ADMIN_USER_NAME ='IPMUSER_LASTNAME';
    private static final String COMPANY_CARD_NOT_INSERTED='Company Cards are not inserted';
    private static final String MILESTONE_DUE_DATE_IN_PAST='IPM_Milestone_Due_Date_In_Past__c is not checked';
    private static Set<Id> iDs;
    private static Id batchId;
   
   /***********************************
      @name: projectSetUpData
      @Description: create project records
      @param: none
      @return: none
      @throws: none
    ***********************************/
    
     @testSetup static void projectSetUpData() 
     {
     	iDs = new Set<Id>();
     	
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
            platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
        for(IPM_Company_Card__c eachCompanyCard : companyCardList) {
            iDs.add(eachCompanyCard.Id);
        }
        System.assertEquals(3, [Select count() from IPM_Company_Card__c where id in:iDs],COMPANY_CARD_NOT_INSERTED );
        
         IPM_TestFactory_Helper.getProjectMasterData();
         List<IPM_Project__c>masterList=[Select id,IPM_Project_Type__c from IPM_Project__c where Name='IPM_MasterProject'];
         List<IPM_Project__c> updatedList = new List<IPM_Project__c>();
         for(IPM_Project__c masterProj:masterList)
         {
         	masterProj.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
         	updatedList.add(masterProj);
         	
         }
         update updatedList;
         
         iDs.clear();
         for(IPM_Project__c eachProj : updatedList) {
           iDs.add(eachProj.Id);
         }
         List<IPM_Project__c> masterProjList=[Select IPM_Project_Type__c from IPM_Project__c where id in:iDs];
         for(IPM_Project__c eachProj:masterProjList)
         {
         	System.assertEquals(eachProj.IPM_Project_Type__c,IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL,PROJECT_NOT_UPDATED);
         }	
         
         projectList = IPM_TestFactory_Helper.projectSetUp(20,platformUser);
         
         System.runAs(platformUser)
         {
           insert projectList;
         }  
         iDs.clear();
         for(IPM_Project__c eachProj : projectList) {
           iDs.add(eachProj.Id);
         }
         System.assertEquals(20, [Select count() from IPM_Project__c where id in:iDs],PROJECT_NOT_INSERTED);
      }
      
   /***********************************
      @name: initializeData
      @Description: update milestone due date
      @param: Date mileStoneDuteDate
      @return: none
      @throws: none
    ***********************************/
      private static void initializeData(Date mileStoneDuteDate){
         iDs = new Set<Id>();
         Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3','TestComments4','TestComments5'};
         list<IPM_Project__c> projectDetailList = [Select IPM_Project_Type__c,Id,IPM_Phase__c,Name,IPM_PM_Approach__c,IPM_Complexity__c,IPM_Project_Gatekeeper__c,Deputy_Project_Leader__c,IPM_Project_Leader__c,IPM_Finance_Member__c,
                                                   (Select Id,Name,IPM_Planned_Date__c,IPM_Due_Date__c,IPM_Type_of_gate__c,IPM_Phase__c from IPM_Milestones__r)
                                                   from IPM_Project__c where Name in:projectNameSet];
         
         list<IPM_Project__c> lstProjects = new list<IPM_Project__c>();   
         list<IPM_Milestone__c> lstIpmMilestones = new list<IPM_Milestone__c>();       
         for(IPM_Project__c project : projectDetailList)
         {
            project.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
            project.Deputy_Project_Leader__c = UserInfo.getUserId();
            project.IPM_Project_Leader__c = UserInfo.getUserId();
            project.IPM_Finance_Member__c = UserInfo.getUserId();
            project.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            lstProjects.add(project);   
            
            for(IPM_Milestone__c milestone : project.IPM_Milestones__r)
            { 
                if(milestone.IPM_Phase__c == project.IPM_Phase__c)
                {   
                    milestone.IPM_Planned_Date__c = mileStoneDuteDate;
                    milestone.IPM_Due_Date__c =  mileStoneDuteDate;
                    lstIpmMilestones.add(milestone);
                }
            }
         }
         update lstProjects; 
         
         iDs.clear();
         for(IPM_Project__c eachProj : lstProjects) {
           iDs.add(eachProj.Id);
         }
         List<IPM_Project__c> updatedProjs=[Select IPM_Project_Type__c from IPM_Project__c where id in:iDs];
         for(IPM_Project__c eachProj: updatedProjs)
         {
         	System.assertEquals(eachProj.IPM_Project_Type__c,IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL,PROJECT_NOT_UPDATED);
         }	
         
         update lstIpmMilestones;     
         for(IPM_Milestone__c milestone : lstIpmMilestones)
         {
         	System.assertEquals(milestone.IPM_Due_Date__c,mileStoneDuteDate,MILESTONE_NOT_UPDATED);
         }
                  
         list<IPM_Project__c> updatedProjectList = [Select IPM_Project_Type__c,Id,IPM_Phase__c,Name,IPM_PM_Approach__c,IPM_Complexity__c,IPM_Project_Gatekeeper__c,
                                                   (Select Id,Name,IPM_Planned_Date__c,IPM_Due_Date__c,IPM_Type_of_gate__c,IPM_Phase__c from IPM_Milestones__r)
                                                   from IPM_Project__c where Name in:projectNameSet];
         for(IPM_Project__c project : updatedProjectList)
         {
            System.assertEquals(project.IPM_Project_Gatekeeper__c, UserInfo.getUserId(),PROJECT_NOT_INSERTED);
            for(IPM_Milestone__c milestone : project.IPM_Milestones__r)
            { 
                if(milestone.IPM_Phase__c == project.IPM_Phase__c)
                {
                    System.assertEquals(milestone.IPM_Due_Date__c , mileStoneDuteDate,MILESTONE_NOT_INSERTED);
                }
            }
         }             
        
      }
    
    /***********************************
      @name: testMilestoneDueDateIsToday
      @Description: This testmethod is written to validate that when milestone due date is today, then notification should be sent.
      @param: none
      @return: none
      @throws: none
    ***********************************/    
    
    static testMethod void testMilestoneDueDateIsToday()
    {
        User globalUser = [Select Id,LastName from User where LastName=:USER_NAME limit 1];
        system.RunAs(globalUser)
        {
            initializeData(System.today());
        }
            
        //batch will be executed in system administrator context
        User systemAdmin = [Select Id,LastName from User where LastName=:ADMIN_USER_NAME limit 1];
        System.runAs(systemAdmin) { 
                
            Test.startTest(); 
                executeBatch();
                System.assert(batchId!= NULL, BATCH_FAILURE);
            Test.stopTest();
                    
            map<Id,IPM_Project__c> mapProjects = new map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 50000]);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
            	//to validate that when milestone due date is today, then chatter post should be sent
                System.assert(projectFeed.Body.contains(System.Label.IPM_DUE_ON_TODAY+System.Label.IPM_Remember_To_Update),FEED_UPDATED_ASSERT);
            }
        }
    }
    
    /***********************************
      @name: testMilestoneDueDateIsInFuture
      @Description: This testmethod is written to validate that when milestone due date is approaching next 21 days, then notification should be sent.
      @param: none
      @return: none
      @throws: none
    ***********************************/    
   
    static testMethod void testMilestoneDueDateIsInFuture()
    {
        User globalUser = [Select Id,LastName from User where LastName=:USER_NAME limit 1];
        system.RunAs(globalUser)
        {
            initializeData(System.today()+21);
        }
        
        //batch will be executed in system administrator context  
        User systemAdmin = [Select Id,LastName from User where LastName=:ADMIN_USER_NAME limit 1];
        System.runAs(systemAdmin) {  
            
            Test.startTest(); 
                executeBatch();
                System.assert(batchId!= NULL, BATCH_FAILURE);
            Test.stopTest();
            map<Id,IPM_Project__c> mapProjects = new map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 50000]);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
            	//to validate that when milestone due date is 21 days approaching, then chatter post should be sent
                System.assert(projectFeed.Body.contains(System.Label.IPM_Due_Date_In_21_days+System.Label.IPM_Remember_To_Update),FEED_UPDATED_ASSERT);
            }
        }
    }
    
    
    /***********************************
      @name: testMilestoneDueDateIsInPast
      @Description: This testmethod is written to validate that when milestone due date is passed, then notification should be sent.
      @param: none
      @return: none
      @throws: none
    ***********************************/    
    
    static testMethod void testMilestoneDueDateIsInPast()
    {
        User globalUser = [Select Id,LastName from User where LastName=:USER_NAME limit 1];
        system.RunAs(globalUser)
        {
            initializeData(System.today()-1);
        }
        
        //batch will be executed in system administrator context  
        User systemAdmin = [Select Id,LastName from User where LastName=:ADMIN_USER_NAME limit 1];
        System.runAs(systemAdmin) { 
            
            Test.startTest(); 
                executeBatch();
                System.assert(batchId!= NULL, BATCH_FAILURE);
            Test.stopTest();
            list<IPM_Milestone__c> milestoneResult = [Select Id,Name,IPM_Planned_Date__c,IPM_Due_Date__c,IPM_Type_of_gate__c,IPM_Phase__c,IPM_Milestone_Due_Date_In_Past__c from IPM_Milestone__c where IPM_Due_Date__c=:System.today()-1];
            for(IPM_Milestone__c milestone: milestoneResult )
            {	//to validate that when milestone due date is passed, then chatter post should be sent
                System.assertEquals(milestone.IPM_Milestone_Due_Date_In_Past__c,true,MILESTONE_DUE_DATE_IN_PAST);
            }
        }
    } 
    
    /***********************************
      @name: executeBatch
      @Description: Generic method to execute batch
      @param: none
      @return: none
      @throws: none
    ***********************************/    
    private static void executeBatch(){
        IPM_DueDateNotification_Batch ipmDueDateNotificationBatchctrl = new IPM_DueDateNotification_Batch();
        batchId = database.executeBatch(ipmDueDateNotificationBatchctrl);
    }

}