@isTest
public class IPM_TaskHelper_Test{
/*created to test IPM_TaskHelper class*/
    public static User adminUser = IPM_TestFactory_Helper.createUserAdmin(true);
    public static User platformUserPL1;
    public static User platformUserPL2;
    public static User userBDRole;
    public static list<IPM_Project__c> projectList;
    public static list<IPM_Project__c> projectDetailList;
    public static list<IPM_Task__c> taskDetailList;
    private static final String  USER_NAME ='PLATFORM_USER';
    
    /***********************************
      @name: projectSetUpData
      @Description: Project Test Data Creation
      @param: none
      @return: none
      @throws: none
    ***********************************/
    @testSetup static void projectSetUpData() 
     {
        System.runAs(adminUser){
            platformUserPL1 = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
            platformUserPL2  = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.TEAM_DEPUTY_PROJECT_LEADER);
            userBDRole = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.FUNCTIONAL_ROLE_BD);
        }
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
         IPM_TestFactory_Helper.getProjectMasterData();
         
         list<IPM_Project__c> projectList1 = IPM_TestFactory_Helper.projectSetUp(8,platformUserPL1);
         projectList = new list<IPM_Project__c> ();
         System.runAs(platformUserPL1)
         {  
            for(IPM_Project__c  project: projectList1)
            {
                project.Deputy_Project_Leader__c = platformUserPL2.id;
                projectList.add(project);
            }
            insert projectList;
         }  
         system.assertEquals(projectList.size(),8,'Projects are not created');
         
      }
    
    /***********************************
      @name: initializedData
      @Description: Query project,project document
      @param: none
      @return: none
      @throws: none
    ***********************************/
    public static void initializedData(){
        
        set<Id> projectIdSet = new set<Id>();
        set<Id> projectDocumentIdSet = new set<Id>();
        list<IPM_Task__c> taskList= new list<IPM_Task__c> ();
        map<id,IPM_Task__c> updateTaskMap = new map<id,IPM_Task__c> ();
        
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3','TestComments4','TestComments5','TestComments6','TestComments7','TestComments8','TestComments9','TestComments10'};
        
        projectDetailList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Leader__c,Deputy_Project_Leader__c,
                            (Select Id from Project_Documents__r),
                            (Select Id from IPM_Financials_Consolidated__r ),
                            (Select Id,Name,IPM_Task_Complexity__c,IPM_Project__c,IPM_Function__c,IPM_Section__c,IPM_Type_of_Gate__c,IPM_Project_Document_Section__c,IPM_Assignee__c,ExternalField__c,IPM_Active__c from Tasks__r),
                            (Select Id,Name,IPM_Due_Date__c,IPM_Planned_Date__c,IPM_Phase__c from IPM_Milestones__r)
                            from IPM_Project__c where Name in:projectNameSet];
          
       for(IPM_Project__c project : projectDetailList)
       {
            projectIdSet.add(project.id);
            for(IPM_Task__c task : project.Tasks__r)
            {
                system.assertEquals(task.IPM_Task_Complexity__c ,project.IPM_Complexity__c);
                system.assertEquals(task.IPM_Assignee__c ,project.IPM_Project_Leader__c);
                taskList.add(task);
            }
            for(IPM_Project_Document__c projDoc : project.Project_Documents__r)
            {
                projectDocumentIdSet.add(projDoc.id);
            }
       }
       
       list<IPM_Project_Document_Section__c> projDocSecList = [SELECT Id,IPM_Gate_Document__c,IPM_FunctionalRole__c,IPM_Project_ID__c,IPM_Section__c,IPM_Project_Document__c,IPM_Project_Document__r.IPM_Project__c 
                                                                FROM IPM_Project_Document_Section__c 
                                                                WHERE IPM_Project_Document__c IN:projectDocumentIdSet and IPM_Project_Document__r.IPM_Project__c=:projectIdSet];
      
      for(IPM_Task__c task : taskList)
       {
        if( !updateTaskMap.containsKey(task.id) && task.IPM_Section__c == null)
        {
            for(IPM_Project_Document_Section__c projDocSec: projDocSecList)
            {
                if(task.IPM_Project__c == projDocSec.IPM_Project_Document__r.IPM_Project__c && task.IPM_Type_of_Gate__c == projDocSec.IPM_Gate_Document__c && task.IPM_Function__c == projDocSec.IPM_FunctionalRole__c )
                {
                    task.IPM_Section__c = projDocSec.IPM_Section__c;
                    task.IPM_Project_Document_Section__c = projDocSec.Id;
                    updateTaskMap.put(task.id,task);
                }
            }
        }
       }
       update updateTaskMap.values();
       
       taskDetailList = [SELECT Id,Name,IPM_Task_Complexity__c,IPM_Project__c,IPM_Function__c,IPM_Section__c,IPM_Type_of_Gate__c,IPM_Project_Document_Section__c,IPM_Master_Section_Name__c,IPM_Master_Section_Sequence__c 
                         FROM IPM_Task__c WHERE IPM_Project__c IN:projectIdSet ];
       for(IPM_Task__c task : taskDetailList)
       {
            if(task.IPM_Section__c != NULL)
            {
                system.assertEquals(task.IPM_Master_Section_Name__c != NULL ,true);
                system.assertEquals(task.IPM_Master_Section_Sequence__c != NULL ,true);
            }
       }
    }
    
    /***********************************
      @name: createTaskFromMilestoneToDosTab
      @Description: PL should be able to insert task on milestone and todos tab
    ***********************************/
    public static TestMethod void reAssignFunctionalWiseTasksTest(){
        User globalUser = [Select Id,LastName from User where LastName=:USER_NAME limit 1];
        User bdUser = [Select Id,LastName,IsActive from User where LastName=:USER_NAME  limit 1];
        system.runAs(globalUser)
        {
            initializedData();
        }   
        IPM_Project_Resource__c projRes = IPM_TestFactory_Helper.createIPMProjectResource(projectDetailList[0].id,false); 
            projRes.IPM_User__c = bdUser.id;
            projRes.IPM_Role_Type__c =IPM_ConstantUtils.FUNCTIONAL_ROLE_BD;
            insert projRes;
            
            list<IPM_Project_Resource__c> projResList = [SELECT Id,IPM_User__c,IPM_Project__c FROM IPM_Project_Resource__c WHERE IPM_User__c=:bdUser.id];
            system.assertEquals(projResList[0].IPM_Project__c,projectDetailList[0].id, 'IPM_Project__c Not Matched');
            
            //project record was not shared with the project resource user, so adding the project resource expecitly in the goup for which the project record is shared.    
            list<IPM_Project__Share> projectShare = [SELECT Id,ParentID,UserOrGroupId FROM IPM_Project__Share WHERE  ParentID=:projectDetailList[0].id];
            
            System.runAs(adminUser){
                insert new GroupMember(GroupId = projectShare[0].UserOrGroupId , UserOrGroupId = bdUser.id);
            }
       
        system.runAs(bdUser)
        {
            list<IPM_Task__c> taskList = [SELECT Id,Name,IPM_Task_Complexity__c,IPM_Project__c,IPM_Function__c,IPM_Section__c,IPM_Type_of_Gate__c,IPM_Project_Document_Section__c,IPM_Master_Section_Name__c,IPM_Master_Section_Sequence__c,IPM_Assignee__c 
                                          FROM IPM_Task__c WHERE IPM_Function__c =:IPM_ConstantUtils.FUNCTIONAL_ROLE_BD];
            
            for(IPM_Task__c task :taskList)
            {
                system.assertEquals(task.IPM_Assignee__c,userinfo.getuserid(), 'User Is Different');
            }
        }
        Test.startTest();
            //IPM_TestFactory_Helper.makeUserInactive(bdUser);
            System.runAs(adminUser){
                bdUser.IsActive= false;
                update bdUser;
                
                User bdUserUpdated = [Select Id,IsActive,LastName from User where LastName=:USER_NAME limit 1];
                System.assertEquals(bdUserUpdated.IsActive,false, 'IsActive Is Checked');
            }
        Test.stopTest();
        system.runAs(globalUser)
        {
            list<IPM_Task__c> taskList = [SELECT Id,Name,IPM_Task_Complexity__c,IPM_Project__c,IPM_Project__r.IPM_Project_Leader__c,IPM_Function__c,IPM_Section__c,IPM_Type_of_Gate__c,IPM_Assignee__c 
                                          FROM IPM_Task__c WHERE IPM_Function__c =:IPM_ConstantUtils.FUNCTIONAL_ROLE_BD];
            for(IPM_Task__c task :taskList)
            {
                system.assertEquals(task.IPM_Assignee__c,task.IPM_Project__r.IPM_Project_Leader__c, 'IPM_Assignee__c Not Matched');
            }
            
        }
    }
     /***********************************
      @name: reassignProjectLeaderTaskTest
      @Description: When PL changes, task assigned to old PL should be ressigned to new PL.
    ***********************************/
    public static TestMethod void reassignProjectLeaderTest(){
        User projectLeader1 = [Select Id,LastName from User where LastName=:USER_NAME limit 1];
        User projectLeader2 = [Select Id,LastName,IsActive from User where LastName=:USER_NAME limit 1];
        
      Test.startTest();  
        system.runAs(projectLeader1)
        {
            initializedData();
        }
        list<IPM_Project__c> updateProjectList = new list<IPM_Project__c>();
            
        for(IPM_Project__c project :projectDetailList)
        {
            project.IPM_Project_Leader__c = projectLeader2.id;
            updateProjectList.add(project);
        }
        
        update updateProjectList;   
        
       
        system.runAs(projectLeader2)
        {
            set<Id> projIdSet =  new set<Id>();
            list<IPM_Project__c> projDetail = [select Id,Name,IPM_Project_Leader__c,Deputy_Project_Leader__c FROM IPM_Project__c LIMIT 8];
            
            
            for(IPM_Project__c project : projDetail)
            {   
                projIdSet.add(project.id);
                system.assertEquals(project.IPM_Project_Leader__c,userinfo.getuserid());
            
            }
            list<IPM_Task__c> updatetaskList = [SELECT Id,Name,IPM_Project__c,IPM_Project__r.IPM_Project_Leader__c,IPM_Function__c,IPM_Assignee__c 
                                          FROM IPM_Task__c where IPM_Assignee__c=:userinfo.getuserid() ];
             for(IPM_Task__c task :updatetaskList)
             {
                 system.assertEquals(task.IPM_Project__r.IPM_Project_Leader__c,userinfo.getuserid());
                 
             }
            
        }
        Test.stopTest();
     }
    /***********************************
      @name: projectComplexityWiseTaskTest
      @Description: When project complexity changes, task will generate for new complexity type.
    ***********************************/
    public static TestMethod void projectComplexityWiseTaskTest(){
        User projectLeader1 = [Select Id,LastName from User where LastName=:USER_NAME  limit 1];
        User projectLeader2 = [Select Id,LastName,IsActive from User where LastName=:USER_NAME  limit 1];
       Test.startTest(); 
        system.runAs(projectLeader1)
        {
            initializedData();
            list<IPM_Project__c> updateProjectList = new list<IPM_Project__c>();
            
            set<Id> projIdSet =  new set<Id>();
            for(IPM_Project__c project :projectDetailList)
            {
                projIdSet.add(project.id);
                project.IPM_Complexity__c = IPM_ConstantUtils.COMPLEXITY_LITE;
                updateProjectList.add(project);
            }
            update updateProjectList;
        
            list<IPM_Task__c> taskList = [SELECT Id,Name,IPM_Task_Complexity__c,IPM_Project__c,IPM_Project__r.IPM_Project_Leader__c,IPM_Function__c,IPM_Section__c,IPM_Type_of_Gate__c,IPM_Assignee__c,IPM_Active__c 
                                          FROM IPM_Task__c WHERE IPM_Project__c IN:projIdSet ];
            
            for(IPM_Task__c task :taskList)
            {
                if(task.IPM_Task_Complexity__c == IPM_ConstantUtils.COMPLEXITY_FULL)
                {
                    system.assertEquals(task.IPM_Active__c,false, 'IPM_Active__c Is Checked');
                }
                if(task.IPM_Task_Complexity__c == IPM_ConstantUtils.COMPLEXITY_LITE)
                {
                    system.assertEquals(task.IPM_Active__c,true, 'IPM_Active__c Is Unchecked');
                }
                
            }   
        }
        Test.stopTest();
    }
}