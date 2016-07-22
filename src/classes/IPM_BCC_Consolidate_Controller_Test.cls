/******************************************** 
*@Author:Cognizant
*@Date:26/10/2015
*@Description : To test IPM_CompanyCard class functionalities
*********************************************/
@isTest
private class  IPM_BCC_Consolidate_Controller_Test{
    private static IPM_Project__c project;
    private static User bbConsUser;
    private static IPM_Project__c childProject;
    private static IPM_Project__c locProject;
    private static String RECORD_INSERTION_FAILED = 'Record insertion failed.';
    /****************************************************************************************************************************
    *  @Description Initializing test data  
    *  @name initializeData
    *  @param None
    *  @return void
    */
    static void initializeData(){
        bbConsUser=IPM_TestFactory_Helper.createUser(true);
        System.runAs(bbConsUser){
            project=IPM_TestFactory_Helper.createIPMProject(false);
            project.IPM_Project_Type__c ='Original';
            project.IPM_Project_Name__c='TESTAPPROVERCL';
            project.IPM_Target_Launch_Dates__c=system.today();
            project.IPM_IsCompleted__c=true;
            project.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
            project.IPM_Phase__c='Ideas';
            insert project;
            IPM_Project__c projectObj=[select IPM_IsCompleted__c from IPM_Project__c where id=:project.Id limit 1];
            system.assert(projectObj.IPM_IsCompleted__c,RECORD_INSERTION_FAILED);
            
            childProject=IPM_TestFactory_Helper.createIPMProject(false);
            childProject.IPM_IsCompleted__c=true;
            childProject.IPM_Parent_Project__c=project.Id;
            insert childProject;
            IPM_Project__c childProjectObj=[select IPM_IsCompleted__c from IPM_Project__c where id=:childProject.Id and IPM_Parent_Project__c=:project.Id limit 1];
            system.assert(childProjectObj.IPM_IsCompleted__c,RECORD_INSERTION_FAILED);
            
            locProject=IPM_TestFactory_Helper.createIPMProject(false);
            locProject.IPM_IsCompleted__c=true;
            locProject.IPM_Parent_Project__c=childProject.Id;
            insert locProject;
            IPM_Project__c locProjectObj=[select IPM_IsCompleted__c from IPM_Project__c where id=:locProject.Id and IPM_Parent_Project__c=:childProject.Id limit 1];
            system.assert(locProjectObj.IPM_IsCompleted__c,RECORD_INSERTION_FAILED);
            
        }
    }
    /******************************************************************************
    *@Description :Testmethod To craete projecr,rollout,company card
    */
    static testMethod void testForGlobalProject(){
        initializeData();
        System.runAs(bbConsUser){
            test.startTest();
            IPM_BCC_Consolidate_Controller conGlob=new IPM_BCC_Consolidate_Controller();
           
            conGlob.projId=project.Id;
            conGlob.getprojId();
            conGlob.setprojId(project.Id);
            conGlob.projectSpan=IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
            conGlob.project=project;
            conGlob.showBCC();
            List<IPM_Project__c> proList=[SELECT Id FROM IPM_Project__c WHERE IPM_Parent_Project__r.IPM_Parent_Project__c=:conGlob.projId];
            system.assertNotEquals(proList.size(),0,'Project list should not be empty');
            test.stopTest();
        }
    }
    /******************************************************************************
    *@Description :Testmethod To craete projecr,rollout,company card
    */
    static testMethod void testForRegionalAndLocalProject(){
        initializeData();
        System.runAs(bbConsUser){
            test.startTest();
            
      
            project.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            update project;
            IPM_Project__c projectObjReg=[select IPMProject_Span__c from IPM_Project__c where id=:project.Id limit 1];
            system.assertEquals(projectObjReg.IPMProject_Span__c,IPM_ConstantUtils.PROJECT_SPAN_REGIONAL,'Project Not Updated Successfully');
            
            IPM_BCC_Consolidate_Controller conReg=new IPM_BCC_Consolidate_Controller();
            conReg.projId=project.Id;
            conReg.getprojId();
            conReg.projectSpan=IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            conReg.showBCC();
            conReg.projectSpan=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            conReg.showBCC();
            List<IPM_Project__c> proList = [SELECT Id FROM IPM_Project__c WHERE  IPM_Parent_Project__c=:conReg.projId];
            system.assertNotEquals(proList.size(),0,'Project list should not be empty');
            test.stopTest();
        }
    }
    
   
}