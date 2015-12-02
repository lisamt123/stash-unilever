/**
* @author       Cognizant 
* @date         11/08/2015
* @description  This class is used to test the functionality of IPM_GateDocumentRiskManagement class 
*/
@isTest
public class IPM_GateDocumentRiskManagement_Test{

    public static IPM_Project__c project;// Project object initialization
    public static IPM_Project_Document__c projDoc;
    public static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    public static IPM_GateDocumentRiskManagement ipm_gateRiskManage;
    public static List<IPM_Questionnaire__c> quesList;
    private static final string TEST_COMMENTS_STR='TestComments1';
    private static final string PROJECT_DOC_CREATED_STR='Project Document created';
    public static PageReference  pRef;
    public static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();
    public static List<IPM_Project__c> projlList=new List<IPM_Project__c>();
    public static List<IPM_Project_Document_Section__c>projectDocSecListObj=new List<IPM_Project_Document_Section__c>();
    public static User globalUser;
    public static User stdUserForRiskMang;

    /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeData(){
        
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            stdUserForRiskMang= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
        
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForRiskMang.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForRiskMang.id,'user id is:'+userLists[0].id);//positive test
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card inserted');
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForRiskMang);
        System.runAs(stdUserForRiskMang) {
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
            projlList=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:projectListObj[0].ID LIMIT 1];
            System.assertEquals(projlList[0].id,project.id);//positive test
            for(IPM_Project__c projectObj : projectListObj) {
                projDocList = projectObj.Project_Documents__r;
                quesList=projectObj.IPM_Questionnaires__r;
                System.assertEquals(projDocList[0].IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,PROJECT_DOC_CREATED_STR);
            }
            projectDocSecListObj = [Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];
            system.assertEquals(projectDocSecListObj[0].IPM_Project_Document__c,projDocList[0].Id);
            
            ipm_gateRiskManage=new IPM_GateDocumentRiskManagement();
            
        }
    }
    
    
    /*************************************************************************************************************************
    * @description Running Test Script
    */
    static testMethod void saveScoreTest(){
        initializeTestMethodData();
        test.startTest();
        system.runAs(globalUser){
            quesList[0].RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.POS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
            update quesList[0];
            ipm_gateRiskManage.projectId=projectListObj[0].Id;
            ipm_gateRiskManage.qId=quesList[0].Id;
            IPM_GateDocumentRiskManagement.questions=new List<IPM_Questionnaire__c>();
            IPM_GateDocumentRiskManagement.questionsForProject=new List<IPM_Questionnaire__c>();
            IPM_GateDocumentRiskManagement.questionsForProject.add(quesList[0]);
            IPM_GateDocumentRiskManagement.questions.add(quesList[0]);
            ipm_gateRiskManage.getRecords();
            ipm_gateRiskManage.score=5;
            ipm_gateRiskManage.saveScore();
            List<IPM_Questionnaire__c>quesListObj=[select IPM_Score__c from IPM_Questionnaire__c where Id=:ipm_gateRiskManage.posQuestionsList[0].Id];
            System.assertEquals(quesListObj[0].IPM_Score__c,ipm_gateRiskManage.score,'score saved');
            test.stopTest();
        }
    }
    
    /*************************************************************************************************************************
* @description Running Test Script
*/ 
    static testMethod void getRecordsTest(){
        initializeTestMethodData();
        test.startTest();
        system.runAs(globalUser){
            quesList[0].RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.POS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
            update quesList[0];
            ipm_gateRiskManage.projectId=projectListObj[0].Id;
            ipm_gateRiskManage.qId=quesList[0].Id;
            ipm_gateRiskManage.getRecords();  
            quesList[0].RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.RQS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
            quesList[0].IPM_Active_RQS__c=true;
            quesList[0].IPM_RQS_Gate_Type__c=IPM_ConstantUtils.CHARTER_GATE;
            update quesList[0];
            ipm_gateRiskManage.projDocType=IPM_ConstantUtils.CHARTER_GATE;
            ipm_gateRiskManage.getRecords(); 
            ipm_gateRiskManage.projDocType=IPM_ConstantUtils.CONTRACT_GATE;
            ipm_gateRiskManage.getRecords(); 
            quesList[0].IPM_Active_RQS__c=false;
            quesList[0].IPM_Is_Added_Question__c=false;
            update quesList[0];
            ipm_gateRiskManage.getPOSList();
            ipm_gateRiskManage.generateMitigationPlan();
            ipm_gateRiskManage.getRecords(); 
            List<IPM_Questionnaire__c>quesListObj=[SELECT Id,IPM_Is_Added_Question__c FROM IPM_Questionnaire__c where Id=:ipm_gateRiskManage.questionsList[0].Id];
            System.assertEquals(quesListObj[0].IPM_Is_Added_Question__c,false,'records retrieved');
            test.stopTest();
        }
    }

    
    /*************************************************************************************************************************
* @description Running Test Script
*/ 
    static testMethod void saveRQSScoreTest(){
        initializeTestMethodData();
        test.startTest();
        system.runAs(globalUser){
            ipm_gateRiskManage.qId=quesList[0].Id;
            ipm_gateRiskManage.saveRQSScore();
            List<IPM_Questionnaire__c>quesListObj=[SELECT Id,IPM_Score__c,IPM_Is_Added_Question__c FROM IPM_Questionnaire__c where Id=:ipm_gateRiskManage.question.Id];
            System.assertEquals(quesListObj[0].IPM_Score__c,ipm_gateRiskManage.score,'score saved');
            test.stopTest();
        }
    }
    
    /*************************************************************************************************************************
* @description Running Test Script
*/ 
    static testMethod void proceedTest(){
        initializeTestMethodData();
        test.startTest();
        system.runAs(globalUser){
            quesList[0].RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.POS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
            quesList[0].IPM_Score__c = IPM_ConstantUtils.POS_QUESTIONNAIRE_SCORE;
            update quesList[0];
            ipm_gateRiskManage.projectId=projectListObj[0].Id;
            ipm_gateRiskManage.rqsSeqActiveNumberCharter=new List<String>();
            ipm_gateRiskManage.rqsSeqActiveNumberCharter.add('1');
            ipm_gateRiskManage.rqsSeqActiveNumberContract=new List<String>();
            ipm_gateRiskManage.rqsSeqActiveNumberContract.add('2');
            ipm_gateRiskManage.proceed();
            ipm_gateRiskManage.projDocType=IPM_ConstantUtils.CHARTER_GATE;
            quesList[0].RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.RQS_QUESTIONNAIRE_RECORDTYPE).RecordTypeId;
            quesList[0].IPM_Score__c = IPM_ConstantUtils.POS_QUESTIONNAIRE_SCORE;
            quesList[0].IPM_Sequence_Number__c=1;
            update quesList[0];
            ipm_gateRiskManage.proceed();
            quesList[0].IPM_Sequence_Number__c=2;
            update quesList[0];
            ipm_gateRiskManage.proceed();
            List<IPM_Questionnaire__c>quesListObj=[SELECT Id FROM IPM_Questionnaire__c where IPM_Project__c =:ipm_gateRiskManage.projectId limit 1];
            System.assertEquals(quesListObj[0].Id,quesList[0].Id,'record is there so we can proceed');
            test.stopTest();
            
        }
    }
    
    /*************************************************************************************************************************
* @description Running Test Script
*/ 
    static testMethod void addQuestionTest(){
        initializeTestMethodData();
        test.startTest();
        system.runAs(globalUser){
            ipm_gateRiskManage=new IPM_GateDocumentRiskManagement();
            ipm_gateRiskManage.addQuestion();
            ipm_gateRiskManage.question.IPM_Question__c=null;
            ipm_gateRiskManage.addQuestion();
            ipm_gateRiskManage.question.IPM_Question__c='abc';
            ipm_gateRiskManage.question.IPM_RQS_Question_Type__c='Consumer';
            ipm_gateRiskManage.addQuestion();
            List<IPM_Questionnaire__c>quesListObj=[SELECT Id,IPM_RQS_Gate_Type__c FROM IPM_Questionnaire__c where Id=:ipm_gateRiskManage.question.Id limit 1];
            System.assertEquals(quesListObj.size(),0,'clear view state');
            test.stopTest();
            
        }
    }
    
    /*************************************************************************************************************************
* @description Running Test Script
*/ 
    static testMethod void deleteQuestionTest(){
        initializeTestMethodData();
        test.startTest();
        system.runAs(globalUser){
            ipm_gateRiskManage.qId=quesList[0].Id;
            ipm_gateRiskManage.stayRQSPage();
            ipm_gateRiskManage.changeQuestionView();
            ipm_gateRiskManage.cancelQuestion();
            ipm_gateRiskManage.backToPos();
            ipm_gateRiskManage.deleteQuestion();
            List<IPM_Questionnaire__c>quesListObj=[SELECT Id FROM IPM_Questionnaire__c WHERE Id=:ipm_gateRiskManage.qId];
            System.assertEquals(quesListObj.size(),0,'record deleted');
            test.stopTest();
        }
    }
}