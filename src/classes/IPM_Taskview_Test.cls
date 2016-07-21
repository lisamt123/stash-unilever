/******************************************** 
   @Author:Cognizant
   @name:IPM_Taskview_Test
   @CreateDate:01/02/2015
   @Description:Test class to test IPM_Taskview class functionalities which is the Controller used to display Count of Tasks and Milestones.
   @Version:1.0
*********************************************/
@isTest
public class IPM_Taskview_Test{
    public static final String STR_TEST = 'test';
    public static final String BLANK_STR='';
    public static IPM_Project__c projects;
    
    private static User platformUser;
    
    private static ApexPages.StandardController sc;
    private static IPM_Taskview taskview;
    private static List<IPM_Project_Resource__c> ipmProjRescourceTestList;
    private static PermissionSetAssignment permissionAssignment;
    public static void initialisedData(){
        
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
            platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
            
        }
        
        permissionAssignment = new PermissionSetAssignment();
        permissionAssignment.AssigneeId = platformUser.Id;
        permissionAssignment.PermissionSetId = [SELECT Id FROM PermissionSet WHERE Name =:IPM_Utils.IPM_Central_Team limit 1].Id;
        insert permissionAssignment;
        
        system.assertEquals(permissionAssignment.AssigneeId,platformUser.Id);
        
        //Creating project and assigning project resource as IPM Platform user's context
        System.runAs(platformUser){
            //Creation of IPM Project
            projects = IPM_TestFactory_Helper.createOriginalProjectList(false, 1)[0];
            
            projects.IPM_PM_Approach__c = IPM_ConstantUtils.IPM_APPROACH_EXTERNAL;
            projects.IPM_Market_Type__c='Developing';
            projects.IPM_Complexity__c= IPM_ConstantUtils.COMPLEXITY_LITE;
            projects.Deputy_Project_Leader__c= UserInfo.getUserId();
            projects.IPM_Technical_Project_Leader__c= UserInfo.getUserId();
            projects.IPM_Project_Gatekeeper__c=UserInfo.getUserId();
            insert projects;  
            system.assertEquals(projects.IPM_Complexity__c,IPM_ConstantUtils.COMPLEXITY_LITE);
            
            putCurrentPageParameter('Id',projects.Id);
           
            ipmProjRescourceTestList = IPM_TestFactory_Helper.createIPMProjectResourceList(false, 1); 
            
            ipmProjRescourceTestList[0].IPM_Role_Type__c = IPM_ConstantUtils.IPM_ROLE_BD_MARKETING;
            ipmProjRescourceTestList[0].IPM_Project__c = projects.Id;
            insert ipmProjRescourceTestList;
            system.assertEquals(ipmProjRescourceTestList[0].IPM_Role_Type__c,IPM_ConstantUtils.IPM_ROLE_BD_MARKETING);
        }
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
            ipmProjRescourceTestList[0].IPM_User__c =platformUser.Id;
            ipmProjRescourceTestList[0].IPM_Project_Role_Owner__c = true;
            update ipmProjRescourceTestList;
        }

        
        
    }
    
    /**
    *  Description: Method to put the current page parameters
    *  @name: putCurrentPageParameter
    **/
    public static void putCurrentPageParameter(String idStr,Id id){
        ApexPages.currentPage().getParameters().put(idStr,id);
    }
    
    /**
    *  Test method to test GetIpmuserType as BD user
    *  @name:testGetIpmuserTypeAsBDUser
    */
    public static TestMethod void testGetIpmuserTypeAsBDUser(){
        
       initialisedData(); 
       
       Test.startTest(); 
       
        System.runAs(platformUser){
            sc = new ApexPages.StandardController(projects);
            taskview =new IPM_Taskview(sc);
            
            System.assertEquals(true,taskview.isTaskeditable);
            System.assertEquals(true,taskview.isCreateTask);
            System.assertEquals(true,taskview.isupdateDates);
            System.assertEquals(true,taskview.updateApproach);
            System.assertEquals(true,taskview.updateComplexity);
       }
        Test.stopTest();
    }
    
    /**
    *  Test method to test GetIpmuserType as CD user
    *  @name:testGetIpmuserTypeAsCDUser
    */
    public static TestMethod void testGetIpmuserTypeAsCDUser(){
        
       initialisedData(); 
       
       Test.startTest(); 
       
       System.runAs(platformUser){
            ipmProjRescourceTestList[0].IPM_Role_Type__c = IPM_Utils.CD;
            update ipmProjRescourceTestList[0];
                      
            sc = new ApexPages.StandardController(projects);
            taskview =new IPM_Taskview(sc);
            System.assertEquals(false,taskview.isupdateDates, 'updateDates Failed');
            
        }
        Test.stopTest();
    }
    
    /**
    *  Test method to test GetIpmuserType as Guest User
    *  @name:testGetIpmuserTypeAsGuestUser
    */
    public static TestMethod void testGetIpmuserTypeAsGuestUser(){
        
       initialisedData(); 
       
       Test.startTest(); 
       
       System.runAs(platformUser){
            ipmProjRescourceTestList[0].IPM_Role_Type__c = IPM_Utils.Guest;
            update ipmProjRescourceTestList[0];
                      
            sc = new ApexPages.StandardController(projects);
            taskview =new IPM_Taskview(sc);
            System.assertEquals(true,taskview.isMilestoneEditable, 'MilestoneEditable is Unchecked');
            
        }
        Test.stopTest();
    }
    
    /**
    *  Test method to test when project is moved to PLE
    *  @name:testProjectMovedtoPLE
    */
    public static TestMethod void testProjectMovedtoPLE(){
        
       initialisedData(); 
       
       Test.startTest(); 
       
       System.runAs(platformUser){
            projects.IPM_Phase__c = IPM_ConstantUtils.PHASE_PLE;
            update projects;
                      
            sc = new ApexPages.StandardController(projects);
            taskview =new IPM_Taskview(sc);
            System.assertEquals(true,taskview.isMilestoneEditable, 'MilestoneEditable is Unchecked');
            System.assertEquals(true,taskview.isTaskeditable, 'Taskeditable is Unchecked' );
            System.assertEquals(true,taskview.isupdateDates, 'updateDates is Unchecked');    
            
        }
        Test.stopTest();
    }
    
    /**
    *  Test method to test GetIpmuserType as PL
    *  @name:testGetIpmuserTypeAsPLUser
    */
    
    
    /**
    *  Test method to test the save task complexity functionality
    *  @name:testSaveTaskComplexity
    */
    public static TestMethod void testSaveTaskComplexity(){
        
        initialisedData();
        Test.startTest();
        System.runAs(platformUser){
            sc = new ApexPages.StandardController(projects);
            taskview =new IPM_Taskview(sc);
            taskview.isupdateDates=true;
            taskview.isvisible=true;
            taskview.FunctionRole=BLANK_STR;
            taskView.ComplexityType= IPM_ConstantUtils.COMPLEXITY_FULL;
            taskView.saveComplexityType();
            system.assertEquals(taskView.project.IPM_Child_Complexity__c,IPM_ConstantUtils.COMPLEXITY_FULL, 'IPM_Child_Complexity__c Not Matched');
        }
        Test.stopTest();   
        
    }
    
    
    /**
    *  Negative test data method,to cover the catch blocks
    *  @name:incorrectDataNegativeTest
    */
    public static TestMethod void incorrectDataNegativeTest(){
        initialisedData();
        Test.startTest();
        System.runAs(platformUser){
                projects.IPM_Phase__c= IPM_ConstantUtils.PHASE_PLE;
                projects.IPM_Market_Type__c='Developing';
                update projects; 
        
                sc = new ApexPages.StandardController(projects);
                taskview =new IPM_Taskview(sc);
                taskview.getIpmuserType();
                List<Apexpages.Message> pageMessages = ApexPages.getMessages();
                for(ApexPages.Message message : pageMessages) {
                   system.assertEquals(message.getDetail(),Label.IPM_Generic_ErrorMessage, 'Message Changed');
                }
        }  
        Test.stopTest(); 
     }
}