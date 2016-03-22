/**
* @author       Cognizant 
* @date         11/08/2015
* @description  This class is used to test the functionality of IPM_GateRiskSection class 
*/
@isTest
private class IPM_GateRiskSection_Test{

    private static IPM_Project__c project;// Project object initialization
    private static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static List<IPM_Project_Document_Section__c> projectDocSecListObj =new List<IPM_Project_Document_Section__c>();
    private static List<IPM_Project__c>projectListObj;
    private static List<IPM_Project__c>projectList=new List<IPM_Project__c>();
    private static IPM_GateRiskSection ipm_gaterisksection;
    private static List<IPM_Questionnaire__c> quesList;
    private static final string TEST_COMMENTS_STR='TestComments1';
    private static final string PROJECT_DOC_CREATED_STR='Project Document created';
    private static final string COMMENTS_STR='this is comment string';
    private static User globalUser;
    private static User stdUserForRiskSec;
    private static List<IPM_Questionnaire__c>quesListObj=new List<IPM_Questionnaire__c>();

    /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeData(){
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            stdUserForRiskSec= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForRiskSec.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForRiskSec.id,'user id is:'+userLists[0].id);//positive test
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForRiskSec);
        System.runAs(stdUserForRiskSec) {
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
                quesList=projectObj.IPM_Questionnaires__r;
                System.assertEquals(projDocList[0].IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,PROJECT_DOC_CREATED_STR);  
            }
            quesList[0].RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.RQS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
            quesList[0].IPM_Active_RQS__c=true;
            quesList[0].IPM_Contract_Score__c =IPM_ConstantUtils.RISK_QUESTIONNAIRE_SCORE;
            update quesList;
            quesListObj=[select Id,RecordTypeId from IPM_Questionnaire__c where Id=:quesList[0].Id];
            System.assertEquals(quesListObj[0].RecordTypeId,Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.RQS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId,'ques not created');
            
            quesList[1].RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.POS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
            update quesList;
            quesListObj=[select Id,RecordTypeId from IPM_Questionnaire__c where Id=:quesList[1].Id];
            System.assertEquals(quesListObj[0].RecordTypeId,Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.POS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId,'ques not created');
            
            projectDocSecListObj = [Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];            
            ipm_gaterisksection=new IPM_GateRiskSection();
        }
    }
    
    
    /*************************************************************************************************************************
* @description Running Test Script
*/ 
    static testMethod void rmpPlanTest(){
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipm_gaterisksection.projDocType=IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE;
            ipm_gaterisksection.projectId=project.Id;
            ipm_gaterisksection.projDocType=IPM_ConstantUtils.MARKET_READY_GATE;
            ipm_gaterisksection.ProjectId=project.id; 
            ipm_gaterisksection.projDocType=IPM_ConstantUtils.CHARTER_GATE;
            ipm_gaterisksection.ProjectId=project.id;
            ipm_gaterisksection.projDocType=IPM_ConstantUtils.CONTRACT_GATE;
            ipm_gaterisksection.ProjectId=project.id;                                       
            ipm_gaterisksection.edit=true;
            ipm_gaterisksection.projDocSecId=projectDocSecListObj[0].Id;
            ipm_gaterisksection.IsEditable=true;
            quesList[0].RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.POS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
            update quesList[0];
            ipm_gaterisksection.rmpPlan();
            List<IPM_Questionnaire__c> posQuestionsListObj=[select Id,RecordTypeId from IPM_Questionnaire__c where Id=:ipm_gaterisksection.posQuestionsList[0].Id];
            system.assertEquals(posQuestionsListObj[0].RecordTypeId,Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.POS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId,'POS questions is there in list');
            quesList[0].IPM_Show_Create_Link__c=true;
            update quesList[0];
            ipm_gaterisksection.rmpPlan();
            quesList[0].RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.RQS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
            quesList[0].IPM_Active_RQS__c=true;
            quesList[0].IPM_Score__c=IPM_ConstantUtils.RISK_QUESTIONNAIRE_SCORE;
            update quesList[0];
            ipm_gaterisksection.rmpPlan();
            List<IPM_Questionnaire__c> rqsQuestionsListObj=[select Id,RecordTypeId from IPM_Questionnaire__c where Id=:ipm_gaterisksection.displayRQSQuestionsList[0].Id];
            system.assertEquals(rqsQuestionsListObj[0].RecordTypeId,Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.RQS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId,'RQS questions is there in list');
            
            quesList[0].RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.CORPORATE_RISK_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
            quesList[0].IPM_Contract_Score__c = IPM_ConstantUtils.RISK_QUESTIONNAIRE_SCORE;
            update quesList[0]; 
            quesListObj=[select Id,RecordTypeId from IPM_Questionnaire__c where Id=:quesList[0].Id];
            System.assertEquals(quesListObj[0].RecordTypeId,Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.CORPORATE_RISK_QUESTIONNAIRE_RECORDTYPE).RecordTypeId,'ques not created');          
            ipm_gaterisksection.rmpPlan();
            List<IPM_Questionnaire__c> CRQuestionsListObj=[select Id,RecordTypeId from IPM_Questionnaire__c where Id=:ipm_gaterisksection.displayCRQuestionsList[0].Id];
            system.assertEquals(CRQuestionsListObj[0].RecordTypeId,Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.CORPORATE_RISK_QUESTIONNAIRE_RECORDTYPE).RecordTypeId,'CR questions is there in list');
            test.stopTest();
            
            
        }
    }
    
    
    /*************************************************************************************************************************
* @description Running Test Script
*/ 
    static testMethod void saveCommentTest(){
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            
            ipm_gaterisksection.comments=COMMENTS_STR;
            
            ipm_gaterisksection.projDocType=IPM_ConstantUtils.CHARTER_GATE;
            ipm_gaterisksection.ProjectId=project.id;
            ipm_gaterisksection.quesId=quesList[0].Id;
            
            ipm_gaterisksection.projDocType=IPM_ConstantUtils.CHARTER_GATE;
            ipm_gaterisksection.saveComment();
            quesListObj=[select IPM_Comments__c,IPM_Charter_Comments__c from IPM_Questionnaire__c where Id=:quesList[0].Id];
            System.assertEquals(quesListObj[0].IPM_Charter_Comments__c,ipm_gaterisksection.comments,'comments saved');
            
            ipm_gaterisksection.projDocType=IPM_ConstantUtils.CONTRACT_GATE;
            ipm_gaterisksection.saveComment();
            quesListObj=[select IPM_Comments__c,IPM_Contract_Comments__c from IPM_Questionnaire__c where Id=:quesList[0].Id];
            System.assertEquals(quesListObj[0].IPM_Contract_Comments__c,ipm_gaterisksection.comments,'comments saved');
            
            ipm_gaterisksection.projDocType=IPM_ConstantUtils.MARKET_READY_GATE;
            ipm_gaterisksection.saveComment();
            quesListObj=[select IPM_Comments__c,IPM_Market_Ready_Comments__c from IPM_Questionnaire__c where Id=:quesList[0].Id];
            System.assertEquals(quesListObj[0].IPM_Market_Ready_Comments__c,ipm_gaterisksection.comments,'comments saved');
            
            ipm_gaterisksection.projDocType=IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE;
            ipm_gaterisksection.saveComment();
            quesListObj=[select IPM_Comments__c,IPM_Market_Deployment_Comments__c from IPM_Questionnaire__c where Id=:quesList[0].Id];
            System.assertEquals(quesListObj[0].IPM_Market_Deployment_Comments__c,ipm_gaterisksection.comments,'comments saved');
            test.stopTest();
            
        }
    }

}