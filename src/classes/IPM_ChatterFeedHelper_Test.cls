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
    private static List<User> userList;
    
    
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
         PL.IPM_Role__c=IPM_ConstantUtils.FUNCTIONAL_ROLE_PL;
         PL.managerid  = managerOfPL.Id;
        
         deputyPL = IPM_TestFactory_Helper.createUser(False);
         deputyPL.IPM_Role__c=IPM_ConstantUtils.FUNCTIONAL_ROLE_PL;
         deputyPL.managerid  = managerOfDeputyPL.Id;
         
         User technicalPL = IPM_TestFactory_Helper.createUser(False);
         technicalPL.IPM_Role__c=IPM_ConstantUtils.FUNCTIONAL_ROLE_PL;
           
         User gateKeeper = IPM_TestFactory_Helper.createUser(False);
         gateKeeper.IPM_Role__c=IPM_ConstantUtils.GATEKEEPER_CONSTANT;
         
         financeMember = IPM_TestFactory_Helper.createUser(False);
         financeMember.IPM_Role__c=IPM_ConstantUtils.USER_FUNCTON_FINANCE;
         
        userList = new  List<User>();                                   
        userList.add(PL);                                            
        userList.add(deputyPL);                         
        userList.add(technicalPL);     
        userList.add(gateKeeper);     
        userList.add(financeMember);  
        //User data inserted with admin context
        System.runAs(adminUser){                              
            insert userList;
        }
        iDs.clear();
        for(User eachUser : userList) {
            iDs.add(eachUser.Id);
        }
        System.assertEquals(5, [Select count() from User where id in:iDs]);
        
        IPM_TestFactory_Helper.getProjectMasterData();
        
        List<IPM_Milestone__c> milestoneList= [select IPM_Planned_Date__c,id from IPM_Milestone__c];
        system.debug('milestoneList[0].IPM_Planned_Date__c..'+milestoneList[0].IPM_Planned_Date__c);
        lstProjects = new List<IPM_Project__c>();
        
        System.runAs(platformUser){
            
        globalprojects = new List<IPM_Project__c>();
        globalprojects = IPM_TestFactory_Helper.projectSetUp(5,platformUser);
        globalprojects[0].Deputy_Project_Leader__c = deputyPL.Id;
        globalprojects[0].IPM_Technical_Project_Leader__c = technicalPL.id;
        globalprojects[0].IPM_Project_Gatekeeper__c = gateKeeper.id;
        globalprojects[0].IPM_Finance_Member__c= financeMember.id;
        insert globalprojects;
        iDs.clear();
        for(IPM_Project__c eachProj : globalprojects) {
            iDs.add(eachProj.Id);
        }
        System.assertEquals(5, [Select count() from IPM_Project__c where id in:iDs]);
        
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
        insert lstRegionalProjects;
        iDs.clear();
        for(IPM_Project__c eachProj : lstRegionalProjects) {
            iDs.add(eachProj.Id);
        }
        System.assertEquals(5, [Select count() from IPM_Project__c where id in:iDs]);  
        
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
        insert lstLocalProjects; 
        iDs.clear(); 
        for(IPM_Project__c eachProj : lstLocalProjects) {
            iDs.add(eachProj.Id);
        }
        System.assertEquals(5, [Select count() from IPM_Project__c where id in:iDs]);
        
        lstProjects.addAll(lstRegionalProjects);
        lstProjects.addAll(lstLocalProjects);
        System.assertEquals(15, lstProjects.size(),PROJECT_INSERTED_ASSERTION);
        for(integer i=0;i<5;i++)
        { 
            integer j=i+1;
            System.assertEquals(PROJ_NAME+j,lstProjects[i].name);
        }   
         
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
        for(Integer i=0;i<5;i++)
            lstProjectsRolloutsToCreate.add(lstProjects[i]);
        lstRegionalRollouts = IPM_TestFactory_Helper.createRegionalRolloutList(true, lstProjectsRolloutsToCreate, userList);
        iDs.clear();
        for(IPM_Project_Rollout__c eachRollout : lstRegionalRollouts) {
            iDs.add(eachRollout.Id);
        }
        System.assertEquals(10, [Select count() from IPM_Project_Rollout__c where id in:iDs]);
        
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
                if(projectFeed.Body.contains(CREATED))
                System.assert(projectFeed.Body.contains( CREATED),FEED_UPDATED_ASSERT);
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
    private static testmethod void testPostChatterIfUserInactive(){
           
           initializeData();
             
           test.startTest(); 
    
           IPM_TestFactory_Helper.makeUserInactive(deputyPL);
           IPM_TestFactory_Helper.makeUserInactive(financeMember);  
           System.assertEquals(financeMember.IsActive,false,'financeMember is Checked');
            
           System.runAs(platformUser) {         
           for(IPM_Project__Feed projectFeed : [SELECT Body,ParentId,CreatedDate,CreatedById FROM IPM_Project__Feed limit 50000])
            {   
                if(projectFeed.Body.contains(System.label.IPM_No_Longer_Active_User))
                    System.assert(projectFeed.Body.contains(System.label.IPM_No_Longer_Active_User),FEED_UPDATED_ASSERT);
            } 
            test.stopTest();
        }
     }
     
       /**
    *  To test chatter when project is fast track
    *  @name :testNotifyLeadsProjectIsFasttrack
    *  @param : nil
    *  @return : nil
    */
    private static testmethod void testNotifyLeadsProjectIsFasttrack (){
        
            initializeData();
            test.startTest();
            System.runAs(platformUser) {  
            lstProjects[0].IPM_Fast_Track_Project__c = true;
            update lstProjects[0];
            
            IPM_ChatterFeedHelper.notifyProjectIsFasttrack(lstProjects);
            
            for(IPM_Project__Feed projectFeed : [SELECT Body,ParentId,CreatedDate,CreatedById FROM IPM_Project__Feed limit 50000])
            {
                if(projectFeed.Body.contains(TO_FAST_TRACK_STR))
                system.assertEquals(projectFeed.Body, TO_FAST_TRACK_STR, FEED_UPDATED_ASSERT);
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
                if(projectFeed.Body.contains(System.Label.IPM_Project_Name_Change))
                System.assert(projectFeed.Body.contains(System.Label.IPM_Project_Name_Change),FEED_UPDATED_ASSERT);
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
    private static testMethod void testNotifyFinanceMemberAddedToRollout() {
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
                if(projectFeed.Body.contains(System.Label.IPM_Finance_Member_Add))
                System.assert(projectFeed.Body.contains(System.Label.IPM_Finance_Member_Add),FEED_UPDATED_ASSERT);
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
   private static testMethod void testNotifyAssigneeTaskAssigned() {
            initializeData();
            //Need system admin to insert System Generated tasks for testing
            Test.startTest();
            System.runAs(platformUser) {
             Map<Id, IPM_Project__c> mapProjects = new Map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 50000]);
             for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
                if(projectFeed.Body.contains(Label.IPM_Task_Assign_Text1))
                System.assert(projectFeed.Body.contains(Label.IPM_Task_Assign_Text1),FEED_UPDATED_ASSERT);
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
    private static testMethod void testPostChatterIfResourceInactive() {
             
            platformUser =IPM_TestFactory_Helper.returnPlatformUser();
            User prjResourceUser = IPM_TestFactory_Helper.createUser(true);
            
            Test.startTest();
            System.runAs(platformUser) {
                List<IPM_Project__c> testProjList=IPM_TestFactory_Helper.createIPMProjectList(true,3);
                User inactiveResourceUser= IPM_TestFactory_Helper.makeResourceInactive(testProjList,prjResourceUser);
                system.assertEquals(inactiveResourceUser.isActive,false,'inactiveResourceUser Is Not Checked');
            Map<Id, IPM_Project__c> mapProjects = new Map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 50000]);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
                if(projectFeed.Body.contains(Label.IPM_Inactive_Users_Text))
                System.assert(projectFeed.Body.contains(Label.IPM_Inactive_Users_Text),FEED_UPDATED_ASSERT);
            }
           Test.stopTest();
        }
    } 
    
    
      /**
    *  To test chatter when TLD misaligned
    *  @name :testPostChatterIfLocalRegionalTLDMisaligned
    *  @param : nil
    *  @return : nil
    */
    private static testMethod void testPostChatterIfLocalRegionalTLDMisaligned() {
        
            initializeData();
            Test.startTest();
            System.runAs(platformUser) {
            lstRegionalProjects[0].IPM_Target_Launch_Dates__c = System.today() + 8;
            update lstRegionalProjects;
            
            IPM_ChatterFeedHelper.postChatterIfLocalRegionalTLDMisaligned(lstRegionalProjects);
            
            lstLocalProjects[0].IPM_Target_Launch_Dates__c = System.today() + 9;
            update lstLocalProjects;
            
            IPM_ChatterFeedHelper.postChatterIfLocalRegionalTLDMisaligned(lstLocalProjects);
            
            Map<Id, IPM_Project__c> mapProjects = new Map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 50000]);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
                System.assert(projectFeed.Body.contains(System.label.IPM_TLD_Misaligned),FEED_UPDATED_ASSERT);
            }
            Test.stopTest();
            }
    }
    
     /**
    *  To test chatter when financial misaligned
    *  @name :testPostChatterIfLocalRegionalMisaligned
    *  @param : nil
    *  @return : nil
    */
    private static testMethod void testPostChatterIfLocalRegionalMisaligned() {
        
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
            IPM_ChatterFeedHelper.postChatterIfLocalRegionalMisaligned(lstLocalProjects);
            Map<Id, IPM_Project__c> mapProjects = new Map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 50000]);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
                System.assert(projectFeed.Body.contains(FINANCIAL_ALIGN),FEED_UPDATED_ASSERT);
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
    private static testMethod void testPostChatterRegionalRolloutAddedToPlan() {
        
            initializeData();
            Test.startTest();
            System.runAs(platformUser) {
            IPM_ChatterFeedHelper.postChatterRegionalRolloutAddedToPlan(lstRegionalRollouts);
            Map<Id, IPM_Project__c> mapProjects = new Map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 50000]);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
                if(projectFeed.Body.contains(System.Label.IPM_Included_In))
                System.assert(projectFeed.Body.contains(System.Label.IPM_Included_In),FEED_UPDATED_ASSERT);
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
    private static testMethod void testPostChatterIfDocumentStatusChanged(){
        
        initializeData();
        Test.startTest();
        System.runAs(platformUser) {
            
            currDocument.IPM_Document_Status__c = IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED;
            update currDocument;
            Map<Id, IPM_Project__c> mapProjects = new Map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 50000]);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
                System.assert(projectFeed.Body.contains(IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED),FEED_UPDATED_ASSERT);
            }
            
            currDocument.IPM_Document_Status__c = IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED;
            update currDocument;
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
                System.assert(projectFeed.Body.contains(IPM_ConstantUtils.DOCUMENT_STATUS_APPROVED),FEED_UPDATED_ASSERT);
            }
            
            currDocument.IPM_Document_Status__c = IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS;
            update currDocument;
            
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
                System.assert(projectFeed.Body.contains(Label.IPM_Gate_Approved_With_Edits),FEED_UPDATED_ASSERT);
            }
            Test.stopTest();
        }
    } 
   
  
}