/**
* @author       Cognizant 
* @date         11/08/2015
* @description  This class is used to test the functionality of IPM_GlobalFinancialActionStandards class 
*/
@isTest
private class IPM_GlobalFinancialActionStandards_Test{
    private static IPM_Project__c project;// Project object initialization
    private static IPM_GlobalFinancialActionStandards ipnmGlobFinActionStn;
    private static User globalUser;
    private static User stdUserForGlobfin;
    private static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();
    private static List<IPM_Project__c>projectList=new List<IPM_Project__c>();
    private static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static final string TEST_COMMENTS_STR='TestComments1';
    private static final string PROJECT_DOC_CREATED_STR='Project Document created';
    private static List<IPM_Project_Document_Section__c> projectDocSecListObj =new List<IPM_Project_Document_Section__c>();
    private static IPM_Financial_Action_Standards__c finAction=new IPM_Financial_Action_Standards__c();
    private static List<IPM_Financial_Action_Standards__c> finActionLst=new List<IPM_Financial_Action_Standards__c>();
    /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeData(){
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            stdUserForGlobfin= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForGlobfin.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForGlobfin.id,'user id is:'+userLists[0].id);//positive test
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForGlobfin);
        System.runAs(stdUserForGlobfin) {
            insert projectList;
            
            project=projectList[0];
            List<IPM_Project__c> projlList1=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:project.ID LIMIT 1];
            System.assertEquals(projlList1[0].Name,TEST_COMMENTS_STR,'project name');//positive test
            
        }

        
    }
    
    /*************************************************************************************************************************
    * @description Test Data
    */
    static void initializeTestMethodData(){
        
        Set<String> projectNameSet = new Set<String>{TEST_COMMENTS_STR};
        globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1]; 
        system.runAs(globalUser){
            projectListObj = [Select Id, Name, (Select Id,IPM_GateDocuments__c from Project_Documents__r),(Select Id from IPM_Financials_Consolidated__r ),
            (Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r),(select ID,IPM_Project__c from IPM_Questionnaires__r)
            from IPM_Project__c where Name in:projectNameSet];
            project=projectListObj[0];
            
            for(IPM_Project__c projectObj : projectListObj) {
                projDocList = projectObj.Project_Documents__r;
                
                System.assertEquals(projDocList[0].IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,PROJECT_DOC_CREATED_STR);  
            }
            
            projectDocSecListObj = [Select Id,IPM_Section_Name__c,IPM_Master_Section_External_Id__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];  
            
            finAction.IPM_Project__c=project.Id;
            finAction.IPM_Project_Span__c=IPM_ConstantUtils.IPMREGIONAL;
            finAction.IPM_Project_Document_Section__c=projectDocSecListObj[0].Id;
        
            insert finAction;
            
            finActionLst=[select Id,IPM_Project_Span__c from IPM_Financial_Action_Standards__c where Id=:finAction.Id Limit 1];
            System.assertEquals(finActionLst[0].IPM_Project_Span__c,IPM_ConstantUtils.IPMREGIONAL,'Financial Action standard not inserted');
            
            ipnmGlobFinActionStn=new IPM_GlobalFinancialActionStandards();
            
        }
    }
    
    /*************************************************************************************************************************
            * @description Running Test Script
        */ 
    static testMethod void showFinancialActionStandardsTest(){
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipnmGlobFinActionStn.finActionId=finAction.Id;
            ipnmGlobFinActionStn.gateType=IPM_ConstantUtils.CHARTER_GATE;
            ipnmGlobFinActionStn.editTable=true;
            ipnmGlobFinActionStn.finActionSpan=IPM_ConstantUtils.IPMREGIONAL;
            ipnmGlobFinActionStn.projDocSecId=projectDocSecListObj[0].Id;
            ipnmGlobFinActionStn.numValue=1;
            
            ipnmGlobFinActionStn.setprojectId(project.Id);
            finActionLst=[select Id,IPM_Project_Span__c from IPM_Financial_Action_Standards__c WHERE IPM_Project__c=:ipnmGlobFinActionStn.project.Id 
                          AND IPM_Project_Document_Section__c=:ipnmGlobFinActionStn.projDocSecId];
            System.assertEquals(finActionLst[0].IPM_Project_Span__c,IPM_ConstantUtils.IPMREGIONAL,'Financial Action standard record is not there');
            
            test.stopTest();
        }
    }
    
    
    /*************************************************************************************************************************
            * @description Running Test Script
        */ 
    static testMethod void updateActionStandardsTest(){
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipnmGlobFinActionStn.finActionId=finAction.Id;
            ipnmGlobFinActionStn.gateType=IPM_ConstantUtils.CHARTER_GATE;
            
            ipnmGlobFinActionStn.finActionSpan=IPM_ConstantUtils.IPMREGIONAL;
            ipnmGlobFinActionStn.projDocSecId=projectDocSecListObj[0].Id;
            
            ipnmGlobFinActionStn.setprojectId(project.Id);
            
            ipnmGlobFinActionStn.field= 'Incremental';
            ipnmGlobFinActionStn.updateActionStandards();
            
            ipnmGlobFinActionStn.field='Innovation';
            ipnmGlobFinActionStn.updateActionStandards();
            
            finActionLst=[select Id,IPM_Innov_Value_Share_Action_Charter__c from IPM_Financial_Action_Standards__c WHERE Id=:ipnmGlobFinActionStn.finActionId];
            System.assertEquals(finActionLst[0].IPM_Innov_Value_Share_Action_Charter__c,ipnmGlobFinActionStn.numvalue,'innovation value is not updated');
            
            finAction.IPM_Project_Span__c=IPM_ConstantUtils.IPMGLOBAL;
            update finAction;
            finActionLst=[select Id,IPM_Innov_Value_Share_Action_Charter__c,IPM_Project_Span__c from IPM_Financial_Action_Standards__c WHERE Id=:finAction.Id];
            System.assertEquals(finActionLst[0].IPM_Project_Span__c,IPM_ConstantUtils.IPMGLOBAL,'financial action standard value is not updated');
            
            ipnmGlobFinActionStn.field= 'gTO';
            ipnmGlobFinActionStn.updateActionStandards();
            
            ipnmGlobFinActionStn.field= 'iTO';
            ipnmGlobFinActionStn.updateActionStandards();
            
            ipnmGlobFinActionStn.field='GM';
            ipnmGlobFinActionStn.updateActionStandards();
            
            ipnmGlobFinActionStn.field='NPV';
            ipnmGlobFinActionStn.updateActionStandards();
            
            ipnmGlobFinActionStn.field= 'IRR';
            ipnmGlobFinActionStn.updateActionStandards();
            
            ipnmGlobFinActionStn.field='PayBack';
            ipnmGlobFinActionStn.updateActionStandards();
            
            finActionLst=[select Id,IPM_Payback_Action_Standard_Charter__c from IPM_Financial_Action_Standards__c WHERE Id=:ipnmGlobFinActionStn.finActionId];
            System.assertEquals(finActionLst[0].IPM_Payback_Action_Standard_Charter__c,ipnmGlobFinActionStn.numvalue,'payback value is not updated');
            
            
            test.stopTest();
        }
    }
}