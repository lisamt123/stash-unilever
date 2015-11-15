/******************************************** 
*@Author:Cognizant
*@Date:01/02/2015
*@Description : Test class for ipmRolloutPlansTableController class functionalities
*********************************************/

@isTest
public class IPM_RolloutPlansTableControllerTests{
    public static IPM_Project__c project;
    public static IPM_Project__c project1;
    public static IPM_Project_Rollout__c proRoll; 
    public static String projectId;
    public static final String TEST_FINANCE_D_STR = 'Test Finanace D';
    public static final String TEST_FINANCE_D1_STR = 'Test Finanace D1';
    public static final String TEST_FINANCE_D_EUR_STR = 'TEST FINANCE D_EUR';
    public static final String FEASIBILITY_STR = 'Feasibility';
    public static final String SHOULD_BE_SAME_STR = 'Should be same';
    /*
    * @description For Running Test Script
    */ 
    static void initializeData(){
        project=IPM_TestFactory_Helper.createIPMProject(FALSE);
        project.Name=TEST_FINANCE_D_STR;
        project.IPM_Project_Name__c = TEST_FINANCE_D_STR;
        project.IPM_Phase__c=FEASIBILITY_STR;
        project.Sustainability_Period__c='3';
        project.IPMProject_Span__c = 'Global';
        insert project;
        
        System.Assert(project.Name== TEST_FINANCE_D_STR,SHOULD_BE_SAME_STR);
        
        //insert projects
        project1=IPM_TestFactory_Helper.createIPMProject(FALSE);
        project1.IPM_Parent_Project__c=project.Id;
        project1.Name=TEST_FINANCE_D1_STR;
        project1.IPM_Phase__c=FEASIBILITY_STR;
        project1.Sustainability_Period__c='3';
        project1.IPMProject_Span__c = 'Regional';
        insert project1;
        System.Assert(project1.Name ==TEST_FINANCE_D1_STR,SHOULD_BE_SAME_STR);

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = IPM_TestFactory_Helper.createUser(FALSE);  
        u.Email='standarduser@testorg9224.com';
        u.UserName='standarduser@testorg4.com';
        u.profileId = p.id;
        insert u;
        
        System.debug('USERRRRRRRRRRRRRRRRRRRRRRRRRRR11'+u);
        System.debug('---------------------------->'+p.id);
        System.debug('============================>'+u.profileId);
        System.runAs(u) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
        }
        IPM_User_Profile__c ipmUserProfile = IPM_TestFactory_Helper.createUserProfile(FALSE);
        ipmUserProfile.IPM_user__c =  u.id;
        ipmUserProfile.IPM_User_Function__c='Project Leader';
        insert ipmUserProfile ; 
        
        System.Assert(ipmUserProfile.IPM_User_Function__c =='Project Leader',SHOULD_BE_SAME_STR);
        // Projectrollouts
        String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name='Regional Rollout'].Id;
        proRoll=IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
        proRoll.Name=TEST_FINANCE_D_EUR_STR;
        proRoll.RecordTypeId=strRecordTypeId;//
        proRoll.Regional_Project__c=project1.Id;
        proRoll.IPM_Project__c=project.Id;
        proRoll.Target_Launch_Date__c=System.today();//
        proRoll.IPM_Regional_PL__c = u.Id;
        proRoll.IPM_Regional_PL_Text__c = 'IPMUSER_LASTNAME';
        ApexPages.CurrentPage().getparameters().put('id', project.Id);
        insert proRoll;
        System.Assert(proRoll.Name==TEST_FINANCE_D_EUR_STR,SHOULD_BE_SAME_STR);   
    }
    
    /*
    * @description For Initializing the data
    */ 
    static void initializeData1(){
        project=IPM_TestFactory_Helper.createIPMProject(FALSE);
        project.Name=TEST_FINANCE_D_STR;
        project.IPM_Project_Name__c = TEST_FINANCE_D_STR;
        project.IPM_Phase__c=FEASIBILITY_STR;
        project.Sustainability_Period__c='3';
        project.IPMProject_Span__c='Global';
        insert project;
        System.Assert(project.Name==TEST_FINANCE_D_STR,SHOULD_BE_SAME_STR);

        project1=IPM_TestFactory_Helper.createIPMProject(FALSE);
        project1.IPM_Parent_Project__c=project.Id;
        project1.Name=TEST_FINANCE_D1_STR;
        project1.IPM_Phase__c=FEASIBILITY_STR;
        project1.Sustainability_Period__c='3';
        project1.IPMProject_Span__c = 'Regional';
        insert project1;
        ApexPages.CurrentPage().getparameters().put('id', ''+project1.Id);
        System.Assert(project1.Name== TEST_FINANCE_D1_STR,SHOULD_BE_SAME_STR);
        System.Assert(ApexPages.CurrentPage().getparameters().get('id') == ''+project1.Id,SHOULD_BE_SAME_STR);
         
        String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name='Regional Rollout'].Id;
        proRoll=IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
        proRoll.Name=TEST_FINANCE_D_EUR_STR;
        proRoll.RecordTypeId=strRecordTypeId;//
        proRoll.IPM_Project__c=project.ID;
        proRoll.Target_Launch_Date__c=System.today();//
        //proRoll.IPM_Regional_PL__c = u.Id;//
        insert proRoll;
        System.Assert(proRoll.Name==TEST_FINANCE_D_EUR_STR,SHOULD_BE_SAME_STR);  
    }

    /********************************************************************
    * @Description: This method is used to add method of the main class           
    * *******************************************************************/
    static testMethod void doTest() {
        
        initializeData();
        Test.startTest();
        projectId = ApexPages.currentPage().getParameters().get('id');
        IPM_RolloutPlansTableController irp= new IPM_RolloutPlansTableController();
        PageReference pRef = new PageReference('apex/ipmrolloutplansadd?id='+project.ID);
        Test.setCurrentPageReference(pRef);
        irp.project = project;
        irp.editRollout();
        irp.cancelRollout();
        irp.checkRollouts();
        irp.addRollout();
        
        irp.saveRollout();
        irp.selectedMCORollout= proRoll.Id; 
        irp.deleteMCORollout();
        system.assert(irp.project!=null);
        Test.stopTest();
   }

    /********************************************************************
    * @Description: This method is used to add method of the main class           
    * *******************************************************************/
    static testMethod void doTest1() {
        Test.startTest();
        initializeData1();
        projectId = ApexPages.currentPage().getParameters().get('project.Id');
        IPM_RolloutPlansTableController irp= new IPM_RolloutPlansTableController();
        PageReference pRef = new PageReference('apex/ipmrolloutplansadd?id='+project.ID);
        Test.setCurrentPageReference(pRef);
        irp.project = project1;
        irp.editRollout();
        irp.cancelRollout();
        irp.checkRollouts();
        irp.addRollout();
        irp.saveRollout();
        irp.selectedMCORollout= proRoll.Id; 
        irp.deleteMCORollout();  
        system.assert(irp.project!=null);
        Test.stopTest();       
    }
 }