/**
* @author       Cognizant 
* @date         11/08/2015
* @description  This class is used to test the functionality of IPM_GatekeeperChecklist class 
*/
@isTest
private class IPM_GatekeeperChecklist_Test{

    public static IPM_Project__c project;// Project object initialization
    public static IPM_Project_Document__c projDoc;
    public static List<IPM_Project_Document__c> projDocList=new List<IPM_Project_Document__c>();
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    public static IPM_GatekeeperChecklist ipmGK;
    public static List<IPM_Questionnaire__c> quesList;
    private static final string TEST_COMMENTS_STR='TestComments1';
    private static final string PROJECT_DOC_CREATED_STR='Project Document created';
    private static final string RECORD_TYPE_UPDATED = 'Questionnaire Record Type is Updated'; 
    public static PageReference  pRef;
    public static List<IPM_Project__c>projectListObj=new List<IPM_Project__c>();
    public static List<IPM_Project__c> projlList=new List<IPM_Project__c>();
    public static List<IPM_Project_Document_Section__c>projectDocSecListObj=new List<IPM_Project_Document_Section__c>();
    public static User globalUser;
    private static final String GETTER_SETTER_STR='getterSetter';
    private static final string ANSWERED_STR = 'Answered';
    private static final string PARTLY_STR = 'Partly';
    public static User stdUserForAGateKeeper;
    
     /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeData(){
         System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
          {
          // user has to be created as system admin 
            stdUserForAGateKeeper= IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }       
       
        List<User>userLists=[SELECT id FROM user WHERE id=:stdUserForAGateKeeper.id LIMIT 1];
        System.AssertEquals(userLists[0].id, stdUserForAGateKeeper.id,'user id is:'+userLists[0].id);//positive test
       
           // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        List<IPM_Company_Card__c>comList=[select Id from IPM_Company_Card__c where Id=:companyCardList[0].Id limit 1];
        System.assertEquals(comList[0].Id,companyCardList[0].Id,'company card insertion fails'); // Positive Test
        
        IPM_TestFactory_Helper.getProjectMasterData();
        projectList = IPM_TestFactory_Helper.projectSetUp(1,stdUserForAGateKeeper);
        System.runAs(stdUserForAGateKeeper) {
            insert projectList;
        
        project=projectList[0];
        List<IPM_Project__c> projlList1=[SELECT ID,Name,IPM_Phase__c,IPM_Complexity__c,IPM_GateKeeping_Model__c FROM IPM_Project__c WHERE ID=:project.ID LIMIT 1];
        System.assertEquals(projlList1[0].Name,TEST_COMMENTS_STR,'project name is not validate');//positive test
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
            System.assertEquals(projlList[0].id,project.id, 'Project insertion fails');//positive test
            for(IPM_Project__c projectObj : projectListObj) {
                projDocList = projectObj.Project_Documents__r;
                quesList=projectObj.IPM_Questionnaires__r;
                System.assertEquals(projDocList[0].IPM_GateDocuments__c,IPM_ConstantUtils.CHARTER_GATE,PROJECT_DOC_CREATED_STR);// Positive Test;
            }
            projectDocSecListObj = [Select Id,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Project_Document__c from IPM_Project_Document_Section__c 
            where IPM_Project_Document__c=:projDocList[0].Id];
            system.assertEquals(projectDocSecListObj[0].IPM_Project_Document__c,projDocList[0].Id, 'Project Document insertion fails'); // Positive Test;
            ipmGK=new IPM_GatekeeperChecklist();
            
        }
        
         for(IPM_Questionnaire__c questionnaire:quesList) 
          {
           
            questionnaire.IPM_GK_Answers_Multiselect__c='Yes~Yes; Partly~Partly; No~No; NA~Not Applicable; Dontknow~Dontknow';
            questionnaire.IPM_HelpText_Yes__c='Help Text for Yes';
            questionnaire.IPM_HelpText_Partly__c='Help Text for Partly';
            questionnaire.IPM_HelpText_No__c='Help Text for No';
            questionnaire.IPM_Question_Help_Text__c='IPM Question Help Text';
            questionnaire.IPM_RQS_Gate_Type__c='Charter';
            questionnaire.RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.GATEKEEPER_CHECKLIST_RECORD_TYPE).RecordTypeId;
            questionnaire.IPM_Section_Sequence_Number__c=projectDocSecListObj[0].IPM_Section_Sequence__c;
            
          }
         
          update quesList; 
          
          system.assertEquals([Select IPM_RQS_Gate_Type__c from IPM_Questionnaire__c where Id=: quesList[0].Id].IPM_RQS_Gate_Type__c, quesList[0].IPM_RQS_Gate_Type__c, 'Failed to update questionnaire record.'); 
          
         
         
    }


    /*************************************************
    * @Description: Test invoke update GatekeeperChecklist
    * ***********************************************/
    static testMethod void testupdateGKchecklist(){
        initializeTestMethodData();
        system.RunAs(globalUser){
            test.startTest();
            ipmGK.quesId=quesList[0].Id;
            ipmGK.isEditable=true;
            ipmGK.gateType=GETTER_SETTER_STR;
            ipmGK.projectId=project.Id;
            ipmGK.gateTypeRND=GETTER_SETTER_STR;
            ipmGK.gateTypeSCFeas=GETTER_SETTER_STR;
            ipmGK.gateTypeRNDFeas=GETTER_SETTER_STR;
            ipmGK.gateTypeTradeMark=GETTER_SETTER_STR;
            ipmGK.editTable=true;
            ipmGK.updateGKchecklist();
            ipmGK.cmts = true;
            ipmGK.comment=ANSWERED_STR;
            ipmGK.ans=PARTLY_STR;
            ipmGK.updateGKchecklist();
            List<IPM_Questionnaire__c>gkQuesCommentList=[select IPM_Comments__c from IPM_Questionnaire__c where Id=:ipmGK.gkCheck.Id limit 1];
            System.assertEquals(ipmGK.gkCheck.IPM_Comments__c ,gkQuesCommentList[0].IPM_Comments__c,'updation fails'); // Positive Test;
            System.assertEquals(ANSWERED_STR, gkQuesCommentList[0].IPM_Comments__c, 'updated successfully');// Positive Test;
            ipmGK.quesId=quesList[0].Id;
            ipmGK.cmts = false;
            ipmGK.updateGKchecklist();
            List<IPM_Questionnaire__c>gkQuesAnsList=[select IPM_GK_Answers__c from IPM_Questionnaire__c where Id=:ipmGK.gkCheck.Id limit 1];
            System.assertEquals(ipmGK.gkCheck.IPM_GK_Answers__c, gkQuesAnsList[0].IPM_GK_Answers__c,'data updated');// Positive Test ;
            System.assertEquals(PARTLY_STR, gkQuesAnsList[0].IPM_GK_Answers__c,'data updation fails');// Positive Test ;
            test.stopTest();
        }
    }
    
    /*************************************************
    * @Description: Test invoke sectionwise GatekeeperChecklist
    * ***********************************************/
    static testMethod void testgetSectioWiseGKChecklist(){
        initializeTestMethodData();
        
        system.RunAs(globalUser){
        	
            Test.startTest(); 
            
            ipmgk.getSectioWiseGKChecklist();
            ipmGK.SecId=projectDocSecListObj[0].Id;
            ipmGK.gateType='Charter';
            ipmGK.projectID=quesList[0].IPM_Project__c; 
            ipmgk.getSectioWiseGKChecklist();
            
            System.assert(ipmgk.gkChecklistAnsMap.keyset().size()>0,'Failed to populate controller map : gkChecklistAnsMap');
            
            List<IPM_Project_Document_Section__c> docSecList=[SELECT Id,IPM_Section_Sequence__c FROM IPM_Project_Document_Section__c WHERE Id=:ipmGk.SecId limit 1];
            
            System.assertEquals(docSecList[0].Id,ipmGK.projDocSec.Id,'data is not avalilable there so we can not get section wise checklist');// Positive Test;
            
            Test.stopTest();
            
            
        }
    }
    
    /*************************************************
    * @Description: Test invoke getChecklistQuestions GatekeeperChecklist
    * ***********************************************/
    static testMethod void testgetChecklistQuestions(){
        initializeTestMethodData();
        
        system.RunAs(globalUser){
            test.startTest();
            quesList[0].RecordTypeId=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.TRADEMARK_RECORD_TYPE).RecordTypeId;
            update quesList[0];
            IPM_Questionnaire__c ipmQuestionnaire = [SELECT Id,RecordTypeId FROM IPM_Questionnaire__c WHERE Id =:quesList[0].id  LIMIT 1];
            System.assertEquals(ipmQuestionnaire.RecordTypeId, quesList[0].RecordTypeId, RECORD_TYPE_UPDATED);//Positive Test;
            
            IPM_GatekeeperChecklist.recTypeTrademark=Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.TRADEMARK_RECORD_TYPE).RecordTypeId;
            ipmGk.projectID=project.Id;
            ipmgk.getChecklistQuestions(IPM_ConstantUtils.SC_FEASIBILITY,IPM_ConstantUtils.CHARTER_GATE);
            ipmgk.getChecklistQuestions(IPM_ConstantUtils.RND_FEASIBILITY,IPM_ConstantUtils.CHARTER_GATE);
            ipmgk.getChecklistQuestions(IPM_ConstantUtils.RND,IPM_ConstantUtils.CHARTER_GATE);
            ipmgk.getChecklistQuestions(IPM_ConstantUtils.TRADEMARK_RECORD_TYPE,IPM_ConstantUtils.CHARTER_GATE);
            List<IPM_Questionnaire__c>quesListObj=[SELECT ID,RecordTypeId FROM IPM_Questionnaire__c WHERE IPM_Project__c=:ipmGk.projectId limit 1];
            System.assertEquals(quesListObj[0].RecordTypeId,Schema.SObjectType.IPM_Questionnaire__c.RecordTypeInfosByName.get(IPM_ConstantUtils.TRADEMARK_RECORD_TYPE).RecordTypeId,'ques list is retrieved with the specific record type');// Positive Test
            test.stopTest();
        }
    }
    
    
}