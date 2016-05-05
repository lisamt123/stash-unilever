/**
   @Author: Cognizant
   @name : IPM_DueDateNotificationBatch_Test
   @CreateDate : 10/01/2015
   @Description : Test class for IPM_DueDateNotificationBatch
   @Version <1.0>
   @reference 
  */
  
@isTest
public class IPM_DueDateNotificationBatch_Test { 
    private static User platformUser;
    private static List<IPM_Project__c> projectList  ;
    private static final String  FEED_UPDATED_ASSERT = 'Feed Updated';
    private static final String PROJECT_INSERTED_ASSERTION = 'Projects Inserted';
    private static final String BATCH_SUCCESS = 'Batch excecuted successfully!';
    private static final String  USER_NAME ='PLATFORM_USER';
    private static final String  ADMIN_USER_NAME ='IPMUSER_LASTNAME';
   
   /***********************************
      @name: projectSetUpData
      @Description: create project records
      @param: none
      @return: none
      @throws: none
    ***********************************/
    
     @testSetup static void projectSetUpData() 
     {
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
            platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
         IPM_TestFactory_Helper.getProjectMasterData();
         
         projectList = IPM_TestFactory_Helper.projectSetUp(8,platformUser);
         
         System.runAs(platformUser)
         {
           insert projectList;
         }  
         system.assertEquals(projectList.size(),8,PROJECT_INSERTED_ASSERTION);
      }
      
   /***********************************
      @name: initializeData
      @Description: update milestone due date
      @param: Date mileStoneDuteDate
      @return: none
      @throws: none
    ***********************************/
      private static void initializeData(Date mileStoneDuteDate){
        
         Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3','TestComments4','TestComments5'};
         list<IPM_Project__c> projectDetailList = [Select Id,IPM_Phase__c,Name,IPM_PM_Approach__c,IPM_Complexity__c,IPM_Project_Gatekeeper__c,Deputy_Project_Leader__c,IPM_Project_Leader__c,IPM_Finance_Member__c,
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
         update lstIpmMilestones;     
         
         list<IPM_Project__c> updatedProjectList = [Select Id,IPM_Phase__c,Name,IPM_PM_Approach__c,IPM_Complexity__c,IPM_Project_Gatekeeper__c,
                                                   (Select Id,Name,IPM_Planned_Date__c,IPM_Due_Date__c,IPM_Type_of_gate__c,IPM_Phase__c from IPM_Milestones__r)
                                                   from IPM_Project__c where Name in:projectNameSet];
                                                   
         for(IPM_Project__c project : updatedProjectList)
         {
            System.assertEquals(project.IPM_Project_Gatekeeper__c, UserInfo.getUserId(),PROJECT_INSERTED_ASSERTION);
            for(IPM_Milestone__c milestone : project.IPM_Milestones__r)
            { 
                if(milestone.IPM_Phase__c == project.IPM_Phase__c)
                {
                    System.assertEquals(milestone.IPM_Due_Date__c , mileStoneDuteDate,PROJECT_INSERTED_ASSERTION);
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
            Test.stopTest();
                    
            map<Id,IPM_Project__c> mapProjects = new map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 50000]);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
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
            Test.stopTest();
            map<Id,IPM_Project__c> mapProjects = new map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 50000]);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
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
            Test.stopTest();
            list<IPM_Milestone__c> milestoneResult = [Select Id,Name,IPM_Planned_Date__c,IPM_Due_Date__c,IPM_Type_of_gate__c,IPM_Phase__c,IPM_Milestone_Due_Date_In_Past__c from IPM_Milestone__c where IPM_Due_Date__c=:(System.today()-1)];
            for(IPM_Milestone__c milestone: milestoneResult )
            {
                System.assertEquals(milestone.IPM_Milestone_Due_Date_In_Past__c,true,'IPM_Milestone_Due_Date_In_Past__c is not checked');
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
        Id batchId = database.executeBatch(ipmDueDateNotificationBatchctrl);
        System.assert(batchId!= NULL, BATCH_SUCCESS);
    }

}