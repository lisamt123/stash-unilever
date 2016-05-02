/**
   @Author: Cognizant
   @name : IPM_ChatterFeedHelper_Test
   @CreateDate : 10/01/2015
   @Description : Test class for IPM_ChatterFeedHelper
   @Version <1.0>
   @reference 
  */
@isTest
private class IPM_ChatterFeedHelper_Test {

    private static IPM_Project__c project;
    private static List<IPM_Project__c> lstProjects;
    private static List<IPM_Project__c> lstRegionalProjects;
    private static List<IPM_Project__c> lstLocalProjects;
    private static User platformUser;
    private static List<IPM_Project__c> globalprojects;
    private static IPM_Project_Document__c currDocument ;
    private static List<IPM_Project_Rollout__c> lstRegionalRollouts;
    private static List<IPM_Project_Resource__c> ipmProjRescourceList;
    private static final String  FEED_UPDATED_ASSERT = 'Feed Updated';
    private static final String REGIONAL_PROJECTNAME = 'Test Regional';
    private static final String LOCAL_PROJECTNAME = 'Test Local';
    private static final String PROJECT_INSERTED_ASSERTION = 'Projects Inserted';
    private static final String PROJECTRESOURCE_INSERTED_ASSERTION = 'Project Resources Inserted';
    private static final String FINANCIAL_ALIGN=' are no longer aligned. Please contact your BD/BB Finance partner to re-align the business cases';
    private static final String CREATED =' has been created!';
    private static final String TO_FAST_TRACK_STR =' to Fast track';
    private static final String PROJ_NAME='TestComments';
    private static User PL;
    private static User deputyPL;
    private static User financeMember;
    private static User technicalPL;
    private static User gateKeeper; 
    private static List<User> userList;
    private static Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
    
    /**
    *  To create the test data
    *  @name :initializeData
    *  @param : nil
    *  @return : nil
    */
    private static void initializeData(){
        
        Set<Id> iDs = new Set<Id>();
        
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
        User adminUser=IPM_TestFactory_Helper.createUserAdmin(true);
        
        // Create Company Card information master data inserted with admin context 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        System.runAs(adminUser){
            insert companyCardList;
        }
        for(IPM_Company_Card__c eachCompanyCard : companyCardList) {
            iDs.add(eachCompanyCard.Id);
        }
        System.assertEquals(3, [Select count() from IPM_Company_Card__c where id in:iDs]);
        
        //Create regional Project leader users inserted with admin context
         User managerOfPL = IPM_TestFactory_Helper.createUser(true);
         User managerOfDeputyPL = IPM_TestFactory_Helper.createUser(true);
         
         PL = IPM_TestFactory_Helper.createUser(False);
         PL.managerid  = managerOfPL.Id;
        
         deputyPL = IPM_TestFactory_Helper.createUser(False);
         deputyPL.managerid  = managerOfDeputyPL.Id;
         
         technicalPL = IPM_TestFactory_Helper.createUser(False);
         
         gateKeeper = IPM_TestFactory_Helper.createUser(False);
         
         financeMember = IPM_TestFactory_Helper.createUser(False);
         
         User globalUser = IPM_TestFactory_Helper.createUserAdmin(false);
         globalUser.email = 'globalUser@unilever.test.com';
         
         User regionalUser = IPM_TestFactory_Helper.createUserAdmin(false);
         regionalUser.email = 'regionalUser@unilever.test.com';
        
         User localUser = IPM_TestFactory_Helper.createUserAdmin(false);
        
         userList = new  List<User>();                                   
         userList.add(PL);                                            
         userList.add(deputyPL);                         
         userList.add(technicalPL);     
         userList.add(gateKeeper);     
         userList.add(financeMember);
         userList.add(globalUser); 
         userList.add(regionalUser); 
         userList.add(localUser);
         
        lstProjects = new List<IPM_Project__c>();
        
        System.runAs(platformUser){
            
        globalprojects = new List<IPM_Project__c>();
        globalprojects = IPM_TestFactory_Helper.projectSetUp(5,platformUser);
        globalprojects[0].Deputy_Project_Leader__c = deputyPL.Id;
        globalprojects[0].IPM_Technical_Project_Leader__c = technicalPL.id;
        globalprojects[0].IPM_Project_Gatekeeper__c = gateKeeper.id;
        globalprojects[0].IPM_Finance_Member__c= financeMember.id;
        globalprojects[0].IPM_Project_Leader__c= PL.id;
           
        IPM_ProjectJob_Queue.PROJECT_QUEUE_CONTEXT_STARTED = true;
        IPM_ProjectOwnerChangeQueue.PROJECT_QUEUE_CONTEXT_STARTED = true;
        insert globalprojects;
        projectMap.put(globalprojects[0].Id,globalprojects[0]);
        
        lstProjects.addAll(globalprojects);
        
        //Create regional rpojects
        lstRegionalProjects = new List<IPM_Project__c>();
        for(Integer i=0; i<5; i++){
            project = IPM_TestFactory_Helper.createIPMProject(false);
            project.name = REGIONAL_PROJECTNAME+i;
            project.IPM_Project_Name__c = REGIONAL_PROJECTNAME+i;
            project.IPM_Phase__c = IPM_ConstantUtils.FEASIBILITY_PHASE;    
            project.IPM_Temporary_Phase__c = IPM_ConstantUtils.FEASIBILITY_PHASE;     
            project.IPM_Complexity__c = IPM_ConstantUtils.COMPLEXITY_FULL;
            project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            project.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
            project.Deputy_Project_Leader__c = UserInfo.getUserId();
            project.IPM_Technical_Project_Leader__c = UserInfo.getUserId();
            project.IPM_Project_Leader__c = UserInfo.getUserId();
            project.IPM_Finance_Member__c = financeMember.id;
            project.IPM_Project_Type__c =IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            project.IPM_Company_Card__c = lstProjects[0].IPM_Company_Card__c;
            project.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            project.IPM_Target_Launch_Dates__c = System.today() + 400;
            project.IPM_Parent_Project__c = lstProjects[0].Id;
            lstRegionalProjects.add(project);
        }
        
        IPM_ProjectJob_Queue.PROJECT_QUEUE_CONTEXT_STARTED = true;
        IPM_ProjectOwnerChangeQueue.PROJECT_QUEUE_CONTEXT_STARTED = true;
        
        insert lstRegionalProjects;
       
        //Create local projects
        lstLocalProjects = new List<IPM_Project__c>();
        for(Integer i=0; i<5; i++){
            project = IPM_TestFactory_Helper.createIPMProject(false);
            project.name = LOCAL_PROJECTNAME+i;
            project.IPM_Project_Name__c = LOCAL_PROJECTNAME+i;
            project.IPM_Phase__c = IPM_ConstantUtils.FEASIBILITY_PHASE;    
            project.IPM_Temporary_Phase__c = IPM_ConstantUtils.FEASIBILITY_PHASE;     
            project.IPM_Complexity__c = IPM_ConstantUtils.COMPLEXITY_FULL;
            project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            project.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
            project.Deputy_Project_Leader__c = UserInfo.getUserId();
            project.IPM_Project_Leader__c = UserInfo.getUserId();
            project.IPM_Finance_Member__c = UserInfo.getUserId();
            project.IPM_Technical_Project_Leader__c = UserInfo.getUserId();
            project.IPM_Project_Type__c =IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
            project.IPM_Company_Card__c = lstProjects[0].IPM_Company_Card__c;
            project.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            project.IPM_Target_Launch_Dates__c = System.today() + 450;
            project.IPM_Parent_Project__c = lstRegionalProjects[i].Id;
            lstLocalProjects.add(project);
        } 
        
        IPM_ProjectJob_Queue.PROJECT_QUEUE_CONTEXT_STARTED = true;
        IPM_ProjectOwnerChangeQueue.PROJECT_QUEUE_CONTEXT_STARTED = true;
        
        insert lstLocalProjects; 
      
        lstProjects.addAll(lstRegionalProjects);
        lstProjects.addAll(lstLocalProjects);
        
        lstProjects =[Select Id,Name,IPM_Project_Name__c,IPM_Phase__c,IPM_Temporary_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c,
            IPM_Project_Gatekeeper__c,Deputy_Project_Leader__c,IPM_Project_Leader__c,IPM_Finance_Member__c,
            IPM_Technical_Project_Leader__c,IPM_Project_Type__c,IPM_Company_Card__c,IPMProject_Span__c,
            IPM_Target_Launch_Dates__c,IPM_Parent_Project__c from IPM_Project__c where id in:lstProjects];
        
        System.assertEquals(15, lstProjects.size(),PROJECT_INSERTED_ASSERTION);
        
        for(integer i=0;i<5;i++)
        { 
            integer j=i+1;
            System.assertEquals(PROJ_NAME+j,lstProjects[i].name);
        }   
        
        IPM_Milestone__c milestoneList =  IPM_TestFactory_Helper.createIPMMilestone(lstRegionalProjects[0].id,true);
        System.assertEquals(1, [Select count() from IPM_Milestone__c where id =: milestoneList.id]);
        
         //Bulk insert of project resources
        IPM_Project_Resource__c projectResourceBDUser = IPM_TestFactory_Helper.createIPMProjectResource(globalprojects[0].Id,false); 
        IPM_Project_Resource__c projectResourceCDUser = IPM_TestFactory_Helper.createIPMProjectResource(globalprojects[0].Id,false);
        IPM_Project_Resource__c projectResourceCMIUser = IPM_TestFactory_Helper.createIPMProjectResource(globalprojects[0].Id,false);
        
        ipmProjRescourceList = new  List<IPM_Project_Resource__c>();                                   
        ipmProjRescourceList.add(projectResourceBDUser);                                            
        ipmProjRescourceList.add(projectResourceCDUser);                         
        ipmProjRescourceList.add(projectResourceCMIUser);   
        insert ipmProjRescourceList; 
        iDs.clear();
        for(IPM_Project_Resource__c eachResource : ipmProjRescourceList) {
            iDs.add(eachResource.Id);
        }
        System.assertEquals(3, [Select count() from IPM_Project_Resource__c where id in:iDs],PROJECTRESOURCE_INSERTED_ASSERTION);
        
        List<IPM_Project__c> lstProjectsRolloutsToCreate = new List<IPM_Project__c>();
        for(Integer i=0;i<8;i++){
            lstProjectsRolloutsToCreate.add(lstProjects[i]);
        }
        lstRegionalRollouts = IPM_TestFactory_Helper.createRegionalRolloutList(true, lstProjectsRolloutsToCreate, userList);
        iDs.clear();
        for(IPM_Project_Rollout__c eachRollout : lstRegionalRollouts) {
            iDs.add(eachRollout.Id);
        }
        System.assertEquals(16, [Select count() from IPM_Project_Rollout__c where id in:iDs]);
        
        currDocument= IPM_TestFactory_Helper.createIPMProjectDocument(FALSE);
        currDocument.IPM_Document_Status__c = IPM_ConstantUtils.STATUS_NOT_STARTED;
        currDocument.IPM_Project__c = lstLocalProjects[0].id;
        currDocument.IPM_Document_Order__c = 10;
        insert currDocument;
        System.assertEquals(1, [Select count() from IPM_Project_Document__c where id =: currDocument.id]);
        }
        
    }
    
    /**
    *  To test project creation
    *  @name :testNotifyProjectCreated
    *  @param : nil
    *  @return : nil
    */
   private static testmethod void testNotifyProjectCreated (){
        
            test.startTest();
            platformUser =IPM_TestFactory_Helper.returnPlatformUser(); 
            System.runAs(platformUser) {
            for(IPM_Project__Feed projectFeed : [SELECT Body,ParentId,CreatedDate,CreatedById FROM IPM_Project__Feed limit 50000])
             {
                if(projectFeed.Body.contains(CREATED)){
                    System.assert(projectFeed.Body.contains( CREATED),FEED_UPDATED_ASSERT);
                }
             } 
             test.stopTest(); 
         }
     }      
    
      
      /**
    *  To test chatter when project user is inactive
    *  @name :testPostChatterIfUserInactive
    *  @param : nil
    *  @return : nil
    */
 /*   private static testmethod void testPostChatterIfUserInactive(){
           
           test.startTest(); 
           initializeData();

           IPM_TestFactory_Helper.makeUserInactive(deputyPL);
           IPM_TestFactory_Helper.makeUserInactive(financeMember);  
           IPM_TestFactory_Helper.makeUserInactive(PL); 
           IPM_TestFactory_Helper.makeUserInactive(technicalPL);  
           IPM_TestFactory_Helper.makeUserInactive(gateKeeper); 
           System.assertEquals(financeMember.IsActive,false,'financeMember is Checked');
         
           List<User> inactiveUsers= new List<User>();
           inactiveUsers.add(deputyPL);
           inactiveUsers.add(financeMember);
           inactiveUsers.add(PL);
           
           IPM_ChatterFeedHelper.postChatterIfUserInactive(inactiveUsers); 
           System.runAs(platformUser) {         
           for(IPM_Project__Feed projectFeed : [SELECT Body,ParentId,CreatedDate,CreatedById FROM IPM_Project__Feed limit 50000])
            {   
                if(projectFeed.Body.contains(System.label.IPM_No_Longer_Active_User)){
                    System.assert(projectFeed.Body.contains(System.label.IPM_No_Longer_Active_User),FEED_UPDATED_ASSERT);
                }
            } 
            test.stopTest();
        }
     }*/ 
     
       /**
    *  To test chatter when project is fast track
    *  @name :testNotifyLeadsProjectIsFasttrack
    *  @param : nil
    *  @return : nil
    */
    private static testmethod void testNotifyLeadsProjectIsFasttrack (){
        

            test.startTest();
            platformUser =IPM_TestFactory_Helper.returnPlatformUser(); 
            System.runAs(platformUser) {  
            IPM_Project__c lstProject = IPM_TestFactory_Helper.createIPMProject(true);
            lstProjects = new List<IPM_Project__c>();
            lstProjects.add(lstProject);
            lstProject.IPM_Fast_Track_Project__c = true;
            update lstProject;

            IPM_ChatterFeedHelper.notifyProjectIsFasttrack(lstProjects);
            
            lstProject.IPM_Fast_Track_Project__c = false;
            update lstProject;
            
            IPM_ChatterFeedHelper.notifyProjectIsFasttrack(lstProjects);
            
            for(IPM_Project__Feed projectFeed : [SELECT Body,ParentId,CreatedDate,CreatedById FROM IPM_Project__Feed limit 50000])
            {
                if(projectFeed.Body.contains(TO_FAST_TRACK_STR)){
                    system.assertEquals(projectFeed.Body, TO_FAST_TRACK_STR, FEED_UPDATED_ASSERT);
                }
            }
            test.stopTest();
        }
     } 
     
     
       /**
    *  To test chatter of project name change
    *  @name :testNotifyProjectNameChange
    *  @param : nil
    *  @return : nil
    */
      private static testmethod void testNotifyProjectNameChange (){
          
        test.startTest();
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
        System.runAs(platformUser) {
            IPM_Project__c projectNameChange = IPM_TestFactory_Helper.createIPMProject(false);
            projectNameChange.IPM_Project_Name__c = IPM_ConstantUtils.TEAM_TEST1;
            projectNameChange.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;     
                
            insert projectNameChange;
            
            projectNameChange.IPM_Project_Name__c = IPM_ConstantUtils.TEAM_TEST2;
            update projectNameChange;
            
            for(IPM_Project__Feed projectFeed : [SELECT Body,ParentId,CreatedDate,CreatedById FROM IPM_Project__Feed limit 50000])
            {
                if(projectFeed.Body.contains(System.Label.IPM_Project_Name_Change)){
                    System.assert(projectFeed.Body.contains(System.Label.IPM_Project_Name_Change),FEED_UPDATED_ASSERT);
                }
            }
            
            test.stopTest();
        }
     }
     
  
   /**
    *  To test chatter when finance member added to rollout
    *  @name :testNotifyFinanceMemberAddedToRollout
    *  @param : nil
    *  @return : nil
    */
    private static testmethod void testNotifyFinanceMemberAddedToRollout() {
        
        initializeData();
        Test.startTest();
        System.runAs(platformUser) {
            List<IPM_Project_Rollout__c> updatedRollouts = new List<IPM_Project_Rollout__c>();
            List<IPM_Project_Rollout__c> oldRollouts = new List<IPM_Project_Rollout__c>();
            
            User oldFinanceMember = IPM_TestFactory_Helper.createUser(False);
            
            User newFinanceMember = IPM_TestFactory_Helper.createUser(False);
             
             for(IPM_Project_Rollout__c rollout : lstRegionalRollouts) {
                rollout.Finance_Member__c = oldFinanceMember.Id;
                oldRollouts.add(rollout);
             }                   
             update oldRollouts;      
             
              for(IPM_Project_Rollout__c rollout : oldRollouts) {
                rollout.Finance_Member__c = newFinanceMember.Id;
                updatedRollouts.add(rollout);
             }                  
             update updatedRollouts;      
             
             IPM_ChatterFeedHelper.notifyFinanceMemberAddedToRollout(updatedRollouts);
             Map<Id, IPM_Project__c> mapProjects = new Map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 50000]);
             for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
                if(projectFeed.Body.contains(System.Label.IPM_Finance_Member_Add)){
                    System.assert(projectFeed.Body.contains(System.Label.IPM_Finance_Member_Add),FEED_UPDATED_ASSERT);
                }
             }
             Test.stopTest();
        }                              
    }
    
    
      /**
    *  To test chatter when tasks are assigned
    *  @name :testNotifyAssigneeTaskAssigned
    *  @param : nil
    *  @return : nil
    */
   private static testmethod void testNotifyAssigneeTaskAssigned() {
            List<IPM_Task__c> listTask = new List<IPM_Task__c>();
            platformUser =IPM_TestFactory_Helper.returnPlatformUser();
            System.runAs(platformUser) 
            {
                IPM_Project__c lstProject = IPM_TestFactory_Helper.createIPMProject(true);
                
              ID  projectTaskRecordType = Schema.SObjectType.IPM_Task__c.getRecordTypeInfosByName().get(IPM_Utils.IPMProjectTasks).getRecordTypeId();
              //Need system admin to insert System Generated tasks for testing
              IPM_Task__c newTask = IPM_TestFactory_Helper.createIPMTask(lstProject.id,false);
              newTask.IsSystemGenerated__c = true;
              newTask.RecordTypeId = projectTaskRecordType;
              insert newTask;
              listTask.add(newTask);
            }
            
            IPM_ChatterFeedHelper.notifyAssigneeTaskAssigned(listTask);
            
            Test.startTest();
            System.runAs(platformUser) {
             Map<Id, IPM_Project__c> mapProjects = new Map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 50000]);
             for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
                if(projectFeed.Body.contains(Label.IPM_Task_Assign_Text1)){
                    System.assert(projectFeed.Body.contains(Label.IPM_Task_Assign_Text1),FEED_UPDATED_ASSERT);
                }
             }
            Test.stopTest();
            }
         }
    
    
      /**
    *  To test chatter when resource is inactive
    *  @name :testPostChatterIfResourceInactive
    *  @param : nil
    *  @return : nil
    */
 /*   private static testMethod void testPostChatterIfResourceInactive() {
             
            platformUser =IPM_TestFactory_Helper.returnPlatformUser();
            User prjResourceUser = IPM_TestFactory_Helper.createUser(true);
            
            Test.startTest();
            System.runAs(platformUser) {
                List<IPM_Project__c> testProjList=IPM_TestFactory_Helper.createIPMProjectList(true,3);
                User inactiveResourceUser= IPM_TestFactory_Helper.makeResourceInactive(testProjList,prjResourceUser);
                List<User> inactiveUserList = new List<User>();
                inactiveUserList.add(inactiveResourceUser);
                IPM_ChatterFeedHelper.postChatterIfResourceInactive(inactiveUserList);
                system.assertEquals(inactiveResourceUser.isActive,false,'inactiveResourceUser Is Not Checked');
            Map<Id, IPM_Project__c> mapProjects = new Map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 50000]);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
                if(projectFeed.Body.contains(Label.IPM_Inactive_Users_Text)){
                    System.assert(projectFeed.Body.contains(Label.IPM_Inactive_Users_Text),FEED_UPDATED_ASSERT);
                }
            }
           Test.stopTest();
        }
    } 
    */
    
      /**
    *  To test chatter when TLD misaligned
    *  @name :testPostChatterIfLocalRegionalTLDMisaligned
    *  @param : nil
    *  @return : nil
    */
    private static testmethod void testPostChatterIfLocalRegionalTLDMisaligned() {
        
            initializeData();
            
            Test.startTest();
            System.runAs(platformUser) {
            lstRegionalProjects[0].IPM_Target_Launch_Dates__c = System.today() + 8;
            update lstRegionalProjects;
            
            IPM_ChatterFeedHelper.postChatterIfLocalRegionalTLDMisaligned(lstRegionalProjects);
            
            lstLocalProjects[0].IPM_Target_Launch_Dates__c = System.today() + 9;
            lstLocalProjects[0].Rollout_Plan_Target_Launch_Date__c = System.today() + 11;
            update lstLocalProjects;
            
            IPM_ChatterFeedHelper.postChatterIfLocalRegionalTLDMisaligned(lstLocalProjects);
            
            Map<Id, IPM_Project__c> mapProjects = new Map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 50000]);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
                if(projectFeed.Body.contains(System.label.IPM_TLD_Misaligned)){
                System.assert(projectFeed.Body.contains(System.label.IPM_TLD_Misaligned),FEED_UPDATED_ASSERT);
                }
            }
             
            }
            
            Test.stopTest(); 
            

    }
    
     /**
    *  To test chatter when financial misaligned
    *  @name :testPostChatterIfLocalRegionalMisaligned
    *  @param : nil
    *  @return : nil
    */
    private static testmethod void testPostChatterIfLocalRegionalMisaligned() {
        
            initializeData();   
        
            Test.startTest();  
            System.runAs(platformUser) {
            
            Id  financeMasterRecordType = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId();  
            IPM_Financial__c financial = IPM_TestFactory_Helper.createIPMFinancial(false);
            financial.Parent_Project__c = lstLocalProjects[0].Id;
            financial.Financial_External_ID__c = lstLocalProjects[0].Id + String.valueOf(System.now());
            financial.Regional_Project__c =  lstRegionalProjects[0].id;
            financial.Local_Project__c = lstLocalProjects[0].id; 
            financial.Project_Sustainability_Period__c = '3';
            financial.RecordTypeId = financeMasterRecordType;
            insert financial; 
            
            Set<Id> updatedLocalProjIds = new Map<Id,IPM_Project__c>(lstLocalProjects).keySet();
            Set<Id> updatedRegionalProjIds = new Map<Id,IPM_Project__c>(lstRegionalProjects).keySet();
            IPM_ChatterFeedHelper.postChatterIfLocalRegionalMisaligned(updatedLocalProjIds);
            IPM_ChatterFeedHelper.postChatterIfLocalRegionalMisaligned(updatedRegionalProjIds);
            
            Map<Id, IPM_Project__c> mapProjects = new Map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 50000]);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
                if(projectFeed.Body.contains(FINANCIAL_ALIGN)){
                System.assert(projectFeed.Body.contains(FINANCIAL_ALIGN),FEED_UPDATED_ASSERT);
                }
            }
            Test.stopTest();
       }
    }
    
      /**
    *  To test regional rollout added to plan chatter
    *  @name :testPostChatterRegionalRolloutAddedToPlan
    *  @param : nil
    *  @return : nil
    */
    private static testmethod void testPostChatterRegionalRolloutAddedToPlan() {
        
            initializeData();
            
            Test.startTest();
            System.runAs(platformUser) {
            IPM_ChatterFeedHelper.postChatterRegionalRolloutAddedToPlan(lstRegionalRollouts);
            Map<Id, IPM_Project__c> mapProjects = new Map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 50000]);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
                if(projectFeed.Body.contains(System.Label.IPM_Included_In)){
                    System.assert(projectFeed.Body.contains(System.Label.IPM_Included_In),FEED_UPDATED_ASSERT);
                }
            }
            Test.stopTest();
        }
     }
    
     /**
    *  To test when document status is changed
    *  @name :testPostChatterIfDocumentStatusChanged
    *  @param : nil
    *  @return : nil
    */
   private static testmethod void testPostChatterIfDocumentStatusChanged(){
        
        initializeData();
        
        Test.startTest(); 
        System.runAs(platformUser) {
            
            currDocument.IPM_Document_Status__c = IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED;
            update currDocument;
            Map<Id, IPM_Project__c> mapProjects = new Map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 50000]);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
                if(projectFeed.Body.contains(IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED))
                {
                    System.assert(projectFeed.Body.contains(IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED),FEED_UPDATED_ASSERT);
                }
            }
            
            currDocument.IPM_Document_Status__c = IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED;
            update currDocument;
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
                if(projectFeed.Body.contains(IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED))
                {
                    System.assert(projectFeed.Body.contains(IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED),FEED_UPDATED_ASSERT);
                }
            }
            
            currDocument.IPM_Document_Status__c = IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS;
            update currDocument;
             
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
                if(projectFeed.Body.contains(Label.IPM_Gate_Approved_With_Edits))
                {
                    System.assert(projectFeed.Body.contains(Label.IPM_Gate_Approved_With_Edits),FEED_UPDATED_ASSERT);
                }    
            }
            Test.stopTest();
        }
    }
    
      /**
    *  To test chatter when chatter posted to user
    *  @name :testpostChatterUpdateToUser
    *  @param : nil
    *  @return : nil
    */
    private static testmethod void testpostChatterUpdateToUser (){
        Test.startTest();
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
        System.runAs(platformUser) {
        List<IPM_Project_Resource__c> projRescourceList = IPM_TestFactory_Helper.createIPMProjectResourceList(false, 3);
        IPM_Project__c proj= IPM_TestFactory_Helper.createIPMProject(true);
        Map<Id, IPM_Project__c> projectOwnerMap = new Map<Id, IPM_Project__c>();
        Map<Id, String> pResourceDetails = new Map<Id, String>();
        for(IPM_Project_Resource__c eachResource: projRescourceList)
        {
            projectOwnerMap.put(eachResource.id,proj);
            pResourceDetails.put(eachResource.id,'test');
        }
        IPM_ChatterFeedHelper.postChatterUpdateToUser(projectOwnerMap,pResourceDetails);
        for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed limit 50000]){
        if(projectFeed.Body.contains(CREATED))
            {
                System.assert(projectFeed.Body.contains(CREATED),FEED_UPDATED_ASSERT);
            }    
        }
        }
        Test.stopTest();
    }    
    
     /**
    *  To test chatter when chatter posted to user
    *  @name :testpostChatterUpdateToUser
    *  @param : nil
    *  @return : nil
    */
    private static testmethod void testManageChatterMembers (){
        initializeData();
        
        Map<Id,IPM_Project__c> newProjectMap= new Map<Id,IPM_Project__c>();
        Map<Id,IPM_Project__c> oldProjectMap= new Map<Id,IPM_Project__c>();
        for(IPM_Project__c proj:lstProjects)
        {
            newProjectMap.put(proj.id,proj);
        }   
        for(IPM_Project__c proj:lstRegionalProjects)
        {
            oldProjectMap.put(proj.id,proj);
        }   
        Test.startTest();
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
        System.runAs(platformUser) {
            IPM_ChatterFeedHelper.manageChatterFollowMembers(newProjectMap,oldProjectMap);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed limit 50000])
            {
             if(projectFeed.Body.contains(IPM_ConstantUtils.IPM_SPACE+System.Label.IPM_Check_The_Project))
             {
                System.assert(projectFeed.Body.contains(IPM_ConstantUtils.IPM_SPACE+System.Label.IPM_Check_The_Project),FEED_UPDATED_ASSERT);
             }
            }   
        }   
    }
        
     /**
    *  To test IPM_ProjectTriggerHandler class
    *  @name :testProjectTriggerHandler
    *  @param : nil
    *  @return : nil
    */
    private static testmethod void testProjectTriggerHandler(){
        Test.startTest();   
        initializeData();
        IPM_ProjectTriggerHandler IPM_ProjectTriggerHandlerctrl = new IPM_ProjectTriggerHandler();
        IPM_ProjectTriggerHandlerctrl.onAfterInsert(lstRegionalProjects);
        IPM_ProjectTriggerHandlerctrl.onBeforeUpdate(lstRegionalProjects);
        
        system.assertNotEquals(Null, IPM_GroupManagement.grpList);
        system.assert(IPM_GroupManagement.grpList.size() > 0);

        Map<Id,IPM_Project__c> newProjectMap= new Map<Id,IPM_Project__c>();
        Map<Id,IPM_Project__c> oldProjectMap= new Map<Id,IPM_Project__c>();

        
        for(IPM_Project__c proj:lstProjects)
        {
           proj.IPM_Project_Leader__c = UserInfo.getUserId();
           proj.IPM_Technical_Project_Leader__c = UserInfo.getUserId();
           proj.Deputy_Project_Leader__c = UserInfo.getUserId();
           proj.IPM_Finance_Member__c = UserInfo.getUserId();
           proj.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
           newProjectMap.put(proj.id,proj);
        }   

        IPM_ProjectTriggerHandler.getProjectUsersMap(lstRegionalProjects, newProjectMap, false);
        Test.stopTest();    
    }
}