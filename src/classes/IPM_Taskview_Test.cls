/******************************************** 
   @Author:Cognizant
   @name:IPM_Taskview_Test
   @CreateDate:01/02/2015
   @Description:Test class to test IPM_Taskview class functionalities which is the Controller used to display Count of Tasks and Milestones.
   @Version:1.0
*********************************************/
@isTest
private class IPM_Taskview_Test{

    private static User platformUser;
    private static User BDUser;
    private static list<IPM_Project__c> insertProjectList;
    private static List<IPM_Project_Resource__c> insertProjRescourceList;
    private static ApexPages.StandardController sc;
    private static IPM_Taskview taskview;
    private static final String  PROJECT_NAME ='TestComments1';
    private static final String  GLOBAL_PL ='GLOBAL_PL';
    private static final String  GLOBAL_BD_OWNER ='GLOBAL_BD_OWNER';
    private static final Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3','TestComments4','TestComments5','TestComments6','TestComments7','TestComments8','TestComments9','TestComments10'};
    private static User adminUser = IPM_TestFactory_Helper.createUserAdmin(true);
    
   
    /***********************************
      @name: projectSetUpData
      @Description: Project Test Data Creation
      @param: none
      @return: none
      @throws: none
    ***********************************/
    @testSetup static void projectSetUpData() 
     {
        //Create users
        System.runAs(adminUser){
            
            //create PL user
            platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
            platformUser.lastname = GLOBAL_PL;
            
            BDUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
            BDUser.lastname = GLOBAL_BD_OWNER;
            
            List<User> userList = new List<User>{platformUser,BDUser};
            update userList;
            
            list<User> userUpdatedList = [SELECT lastname FROM User WHERE lastname=:GLOBAL_PL];
            system.assertEquals(userUpdatedList.size(),1,'Global PL is not created');
            
            list<User> userUpdatedList2 = [SELECT lastname FROM User WHERE lastname=:GLOBAL_BD_OWNER];
            system.assertEquals(userUpdatedList2.size(),1,'Global BD is not created');
            
        }
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
        IPM_TestFactory_Helper.getProjectMasterData();
         
         // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{platformUser,BDUser}); 
            
        list<IPM_Project__c> projectList1 = IPM_TestFactory_Helper.projectSetUp(10,platformUser);
        list<IPM_Project__c> projectList = new list<IPM_Project__c> ();
        System.runAs(platformUser)
        {  
          for(IPM_Project__c project : projectList1)
            {
                project.IPM_PM_Approach__c = IPM_ConstantUtils.IPM_APPROACH_EXTERNAL;
                project.IPM_Market_Type__c='Developing';
                project.IPM_Complexity__c= IPM_ConstantUtils.COMPLEXITY_LITE;
                project.Deputy_Project_Leader__c= UserInfo.getUserId();
                project.IPM_Technical_Project_Leader__c= UserInfo.getUserId();
                project.IPM_Project_Gatekeeper__c=UserInfo.getUserId();
                projectList.add(project);
            }
            insert projectList;  
            //check if the created projects are having the same complexity type as assigned while creating
            list<IPM_Project__c> projectsResultList = [SELECT Id,IPM_Complexity__c FROM IPM_Project__c where Name IN:projectNameSet];
            for(IPM_Project__c project : projectsResultList)
            {
                system.assertEquals(project.IPM_Complexity__c,IPM_ConstantUtils.COMPLEXITY_LITE,'Projects are not created');
            }
        } 
       }
      
      /***********************************
      @name: initializedData
      @Description: Query project,project document
      @param: none
      @return: none
      @throws: none
    ***********************************/
    public static void initializedData(){
        set<Id> projIdSet =  new set<Id>();
        
        insertProjectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Leader__c,Deputy_Project_Leader__c,IPM_GateKeeping_Model__c
                            from IPM_Project__c where Name in:projectNameSet];
        
        User globalBDUser1 = [Select Id,LastName,IsActive from User where LastName=:GLOBAL_BD_OWNER  limit 1];
        
        //create Proeject resource for project
            list<IPM_Project_Resource__c> projResList = IPM_TestFactory_Helper.createIPMProjectResourceList(false, 10); 
            list<IPM_Project_Resource__c> projectResourceResultList =  new list<IPM_Project_Resource__c>();
            for(integer i=0;i<10;i++)
            {
                projResList[i].IPM_Role_Type__c = IPM_ConstantUtils.IPM_ROLE_BD_MARKETING;
                projResList[i].IPM_Project__c = insertProjectList[i].Id;
                projResList[i].IPM_User__c = globalBDUser1.Id;
                projResList[i].IPM_Project_Role_Owner__c = true;
                projectResourceResultList.add(projResList[i]);
                projIdSet.add(insertProjectList[i].Id);
                
            }
            insert projectResourceResultList;
            
            //check if the created project resources having the same BD role as assigned 
            insertProjRescourceList= [SELECT Id,IPM_Role_Type__c FROM IPM_Project_Resource__c LIMIT 500];
            for(IPM_Project_Resource__c projectResource : insertProjRescourceList)
            {
                system.assertEquals(projectResource.IPM_Role_Type__c,IPM_ConstantUtils.IPM_ROLE_BD_MARKETING,'Projects Resources are note created');
            }
            
            //set current page with project id
            putCurrentPageParameter('Id',insertProjectList[0].Id);
            
            System.runAs(adminUser){
              //project record was not shared with the project resource user, so adding the project resource expecitly in the goup for which the project record is shared.    
              list<IPM_Project__Share> projectShare = [SELECT Id,ParentID,UserOrGroupId FROM IPM_Project__Share WHERE  ParentID IN :projIdSet];
              User bdOwnerUser = [Select Id,LastName,IsActive from User where LastName=:GLOBAL_BD_OWNER  limit 1];
              //User centralUser = [Select Id,LastName,IsActive from User where LastName=:CENTRAL_TEAM_MEMBER  limit 1];
              
              List<GroupMember>listGroupMember = new List<GroupMember>();  
              set<Id> projectShareIdSet =  new set<Id>();
              for(IPM_Project__Share projShare : projectShare)
              {
                  listGroupMember.add(new GroupMember(GroupId = projShare.UserOrGroupId , UserOrGroupId = bdOwnerUser.id));
                  projectShareIdSet.add(projShare.UserOrGroupId);
              }
              insert listGroupMember;
              
              //check if the project is shared with project resource
              List<GroupMember> groupMemberList = [SELECT UserOrGroupId,GroupId FROM GroupMember where GroupId IN:projectShareIdSet];
              system.assertEquals(false,groupMemberList.isEmpty(),'Project resource for BD role is not inserted');
            }
    }
    
    /***********************************
      @name: putCurrentPageParameter
      @Description: Method to put the current page parameters
      @param: String idStr,Id id
      @return: none
      @throws: none
    ***********************************/
    public static void putCurrentPageParameter(String idStr,Id id){
        ApexPages.currentPage().getParameters().put(idStr,id);
    }
    
    /***********************************
      @name: testGetIpmuserTypeAsPLUser
      @Description: PL user's access for Tasks , milestone,project complexity and approach.
      @param: None
      @return: none
      @throws: none
    ***********************************/
    public static TestMethod void testGetIpmuserTypeAsPLUser(){
       
       //get PL 
       User globalPL = [Select Id,LastName,IsActive from User where LastName=:GLOBAL_PL  limit 1];
       
       Test.startTest(); 
        System.runAs(globalPL){
            //create test data
            initializedData();
            
            sc = new ApexPages.StandardController(insertProjectList[0]);
            taskview = new IPM_Taskview(sc);
            
            System.assertEquals(true,taskview.isTaskeditable,'isTaskeditable false for PL');
            System.assertEquals(true,taskview.isCreateTask,'isCreateTask false for PL');
            System.assertEquals(true,taskview.isupdateDates,'isupdateDates false for PL');
            System.assertEquals(true,taskview.updateApproach,'updateApproach false for PL');
            System.assertEquals(true,taskview.isMilestoneEditable,'isMilestoneEditable false for PL');
            System.assertEquals(true,taskview.isAllTask,'isAllTask false for PL');
            
        }
        Test.stopTest();
    }
    
    /***********************************
      @name: testGetIpmuserTypeAsBDUser
      @Description: BD  user's access for Tasks , milestone,project complexity and approach.
      @param: None
      @return: none
      @throws: none
    ***********************************/
    public static TestMethod void testGetIpmuserTypeAsBDUser(){
        
       //get PL
       User globalPL = [Select Id,LastName,IsActive from User where LastName=:GLOBAL_PL  limit 1];
       
       //get BD user
       User globalBDUser = [Select Id,LastName,IsActive from User where LastName=:GLOBAL_BD_OWNER  limit 1];
       
       Test.startTest();
        // create test data as PL
        System.runAs(globalPL){
            initializedData();
        }
        //View page as BD user
        System.runAs(globalBDUser){
            
            List<IPM_Project__c>  projectList = [SELECT Id,IPM_Complexity__c,IPM_PM_Approach__c,IPM_Market_Type__c,Deputy_Project_Leader__c,IPM_Technical_Project_Leader__c 
                                                 FROM IPM_Project__c where Name=:PROJECT_NAME];
            
            sc = new ApexPages.StandardController(projectList[0]);
            taskview = new IPM_Taskview(sc);
            
            System.assertEquals(true,taskview.isTaskeditable,'isTaskeditable is unchecked');
            System.assertEquals(true,taskview.isCreateTask,'isCreateTask is unchecked');
            System.assertEquals(true,taskview.isupdateDates,'isupdateDates is unchecked');
            System.assertEquals(false,taskview.updateApproach,'updateApproach is checked');
            System.assertEquals(false,taskview.isMilestoneEditable,'isMilestoneEditable is checked');
            System.assertEquals(true,taskview.isBDuser,'isBDuse is unchecked');
            
        }
        Test.stopTest();
    }
    /***********************************
      @name: testGetIpmuserTypeAsCDUser
      @Description: CD user's access for Tasks , milestone,project complexity and approach.
      @param: None
      @return: none
      @throws: none
    ***********************************/
    public static TestMethod void testGetIpmuserTypeAsCDUser(){
        
        //get PL
       User globalUser = [Select Id,LastName from User where LastName=:GLOBAL_PL limit 1]; 
       
       //get CD user
       User cdUser = [Select Id,LastName from User where LastName=:GLOBAL_BD_OWNER limit 1]; 
       
       Test.startTest(); 
        //create test data as PL
        System.runAs(globalUser){
            initializedData();
            List<IPM_Project__c>  projectList = [SELECT Id,IPM_Complexity__c,IPM_PM_Approach__c,IPM_Market_Type__c,Deputy_Project_Leader__c,IPM_Technical_Project_Leader__c 
                                                 FROM IPM_Project__c where Name=:PROJECT_NAME];
            
            //change user role from BD to CD 
            list<IPM_Project_Resource__c> projectResourceResultList = [SELECT Id,IPM_Role_Type__c,IPM_Project__c FROM IPM_Project_Resource__c WHERE IPM_Project__c =:projectList[0].Id];
            projectResourceResultList[0].IPM_Role_Type__c = IPM_Utils.CD;
            update projectResourceResultList[0];
            
            //check that user has been assigend with CD role
            list<IPM_Project_Resource__c> projectResUpdatedList = [SELECT Id,IPM_Role_Type__c,IPM_Project__c FROM IPM_Project_Resource__c WHERE IPM_Project__c =:projectList[0].Id];
            for(IPM_Project_Resource__c projRes : projectResUpdatedList)
            {
                System.assertEquals(IPM_Utils.CD,projRes.IPM_Role_Type__c, 'Role Assignment Failed');
            }
        }
        
        //View page as CD user
        System.runAs(cdUser){
            
            List<IPM_Project__c>  projectList1 = [SELECT Id,IPM_Complexity__c,IPM_PM_Approach__c,IPM_Market_Type__c,Deputy_Project_Leader__c,IPM_Technical_Project_Leader__c 
                                                 FROM IPM_Project__c where Name=:PROJECT_NAME];
            
            sc = new ApexPages.StandardController(projectList1[0]);
            taskview = new IPM_Taskview(sc);
            
            System.assertEquals(false,taskview.isupdateDates, 'updateDates is checked');
            System.assertEquals(false,taskview.isMilestoneEditable, 'isMilestoneEditable is checked');
            System.assertEquals(TRUE,taskview.isTaskeditable, 'isTaskeditable is unchecked');
            System.assertEquals(TRUE,taskview.isCreateTask, 'isCreateTask is unchecked');
            
         }
       Test.stopTest();
    }
    
    /***********************************
      @name: testGetIpmuserTypeAsGuestUser
      @Description: Guest user's access for Tasks , milestone,project complexity and approach.
      @param: None
      @return: none
      @throws: none
    ***********************************/
    public static TestMethod void testGetIpmuserTypeAsGuestUser(){
        
        //get PL 
       User globalUser = [Select Id,LastName from User where LastName=:GLOBAL_PL limit 1]; 
       
       //get Guest user
       User globalGuestUser = [Select Id,LastName from User where LastName=:GLOBAL_BD_OWNER limit 1]; 
       
       Test.startTest(); 
       //create test data as PL
        System.runAs(globalUser){
            initializedData();
            
            List<IPM_Project__c>  projectList = [SELECT Id,IPM_Complexity__c,IPM_PM_Approach__c,IPM_Market_Type__c,Deputy_Project_Leader__c,IPM_Technical_Project_Leader__c 
                                                 FROM IPM_Project__c where Name=:PROJECT_NAME];
            
            //change users role from BD to Guest
            list<IPM_Project_Resource__c> projectResourceResultList = [SELECT Id,IPM_Role_Type__c,IPM_Project__c FROM IPM_Project_Resource__c WHERE IPM_Project__c =:projectList[0].Id];
            projectResourceResultList[0].IPM_Role_Type__c = IPM_Utils.Guest;
            update projectResourceResultList[0];
            
            //check if the role has been changed to Guest
            list<IPM_Project_Resource__c> projectResUpdatedList = [SELECT Id,IPM_Role_Type__c,IPM_Project__c FROM IPM_Project_Resource__c WHERE IPM_Project__c =:projectList[0].Id];
            for(IPM_Project_Resource__c projRes : projectResUpdatedList)
            {
                System.assertEquals(IPM_Utils.Guest,projRes.IPM_Role_Type__c, 'Role Assignment Failed');
            }
        }
        
        //View page as Guest
        System.runAs(globalGuestUser){
            List<IPM_Project__c>  projectList1 = [SELECT Id,IPM_Complexity__c,IPM_PM_Approach__c,IPM_Market_Type__c,Deputy_Project_Leader__c,IPM_Technical_Project_Leader__c 
                                                 FROM IPM_Project__c where Name=:PROJECT_NAME];
            
            
            sc = new ApexPages.StandardController(projectList1[0]);
            taskview = new IPM_Taskview(sc);
            
            System.assertEquals(false,taskview.isMilestoneEditable, 'MilestoneEditable is checked');
            System.assertEquals(false,taskview.isupdateDates, 'isupdateDates is checked');
        }
       Test.stopTest();
    }
   
    
    /***********************************
      @name: testSaveTaskComplexity
      @Description: Method to check whether, PL is able to change complexity of project
      @param: None
      @return: none
      @throws: none
    ***********************************/
    public static TestMethod void testSaveTaskComplexity(){
        
        //get PL
        User globalUser = [Select Id,LastName from User where LastName=:GLOBAL_PL limit 1]; 
       
        Test.startTest();
        
        //Create test data
        System.runAs(globalUser){
            
            initializedData();
            List<IPM_Project__c>  projectList1 = [SELECT Id,IPM_Complexity__c,IPM_PM_Approach__c,IPM_Market_Type__c,Deputy_Project_Leader__c,IPM_Technical_Project_Leader__c,IPM_Child_Complexity__c 
                                                 FROM IPM_Project__c where Name=:PROJECT_NAME];
            
            //update project complexity
            sc = new ApexPages.StandardController(projectList1[0]);
            taskview =new IPM_Taskview(sc);
            taskview.isupdateDates=true;
            taskview.isvisible=true;
            taskview.FunctionRole=IPM_ConstantUtils.BLANK;
            taskView.ComplexityType= IPM_ConstantUtils.COMPLEXITY_LITE;
            taskView.saveComplexityType();
            
            //Check if project's complexity has been changed
            List<IPM_Project__c>  projectList2 = [SELECT Id,IPM_Complexity__c,IPM_PM_Approach__c,IPM_Market_Type__c,Deputy_Project_Leader__c,IPM_Technical_Project_Leader__c,IPM_Child_Complexity__c
                                                 FROM IPM_Project__c where Name=:PROJECT_NAME];
            
            system.assertEquals(projectList2[0].IPM_Child_Complexity__c,IPM_ConstantUtils.COMPLEXITY_LITE, 'Child Complexity Not Matched');
        }
        Test.stopTest();   
        
    }
    
}