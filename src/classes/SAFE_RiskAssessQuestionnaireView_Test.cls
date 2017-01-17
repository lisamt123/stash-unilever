/**
* Name:        -   SAFE_RiskAssessQuestionnaireView_Test
* @description -   This is the test class for SAFE_Risk_Assessment_Questionnaire__c Controller to verify the code  while Viewing Risk assessment list and submitting Questions. 
* @Author      -   Sibatri Ray, Mindtree Ltd     
*/
@isTest
public with sharing class SAFE_RiskAssessQuestionnaireView_Test {
    
    
    /*code by Sibatri for Pagination functionality*/
    public static testMethod void testPagination() {
        
        SAFE_Risk_Assessment_Questionnaire__c riskAss = new SAFE_Risk_Assessment_Questionnaire__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(riskAss);   
        SAFE_RiskAssessmentQuestionnaireView_CC p=new SAFE_RiskAssessmentQuestionnaireView_CC (sc);
        
        p.Firstbtn();
        p.prvbtn();
        p.Nxtbtn();
        p.lstbtn();
        p.getNxt();
        p.getPrv();
        PageReference pg = Page.SAFE_QuestionnaireTabBP;
        Test.setCurrentPage(pg);  
        string actionPerform;
        string actPerform =p.actionPerform;
        ApexPages.currentPage().getParameters().put('actionPerform',actPerform);
        
        
        SAFE_Risk_Assessment_Questionnaire__c newquestionire=new SAFE_Risk_Assessment_Questionnaire__c(Name='Questionaire1',OwnerId='0053C000000QPbFQAW',SAFE_Description__c='desc1',SAFE_Status__c='Published');
        insert newquestionire;
        string questionnaireId = newquestionire.Id; 
        System.currentPagereference().getParameters().put('id1',questionnaireId);
        SAFE_Risk_Assessment_Questionnaire__c raq= [select SAFE_Description__c,OwnerId,Name,Id,SAFE_Status__c from SAFE_Risk_Assessment_Questionnaire__c where Id=: newquestionire.Id];
        p.getQuestionnaireList();
        p.createQuestionnaire();
        p.editQuestionnaire();
        p.backToQuestionnaireList();
        p.viewQuestionnaireRecord();
        p.showPopup();
        p.closePopup();
        p.deleteQuestionnaire();
        SAFE_Risk_Assessment_Questionnaire__c newquestionire1=new SAFE_Risk_Assessment_Questionnaire__c(Name='Questionaire1',OwnerId='0053C000000QPbFQAW',SAFE_Description__c='desc1',SAFE_Status__c='Published');
        insert newquestionire1;
        
        string questionnaireId1 = newquestionire1.Id;
        System.currentPagereference().getParameters().put('id1',questionnaireId1);
        p.cloneQuestionnaire();
        p.createQuestion();
        p.backToQuestionList();
        
        p.cancelQuestion();
        
        p.showPopup_deleteQuestion();
        p.closePopup_deleteQuestion();
        
        SAFE_Questions__c newquestion=new SAFE_Questions__c(SAFE_Answering_Method__c='Checkbox Objective Answering',SAFE_Answers__c='a;b;c',SAFE_Help_Text__c='dfd',SAFE_Questionnaire__c=questionnaireId1,SAFE_Question_Status__c='Activated',SAFE_Question__c='Test',SAFE_Scores__c='1;2;3',SAFE_Impact_Value__c='1;2;3',SAFE_Likelihood_Value__c='1;2;3',SAFE_Weightage__c=12);
        insert newquestion;
        
        SAFE_Risk_Assessment_Questionnaire__c QuestionnaireDetails = [SELECT Id,Name,OwnerId,SAFE_Description__c,SAFE_Status__c FROM SAFE_Risk_Assessment_Questionnaire__c WHERE Id =: questionnaireId1];        
        SAFE_Questions__c questionList = [SELECT Id,Name,SAFE_Answering_Method__c,SAFE_Answers__c,SAFE_Help_Text__c,SAFE_Questionnaire__c,SAFE_Question_Status__c,SAFE_Question__c,SAFE_Scores__c,SAFE_Weightage__c FROM SAFE_Questions__c WHERE SAFE_Questionnaire__c =: questionnaireId1 ];
        SAFE_Questions__c PrepopulateQuestion = [SELECT Id,Name,OwnerId,SAFE_Answering_Method__c,SAFE_Answers__c,SAFE_Help_Text__c,SAFE_Questionnaire__c,SAFE_Question_Status__c,SAFE_Question__c,SAFE_Scores__c,SAFE_Weightage__c FROM SAFE_Questions__c WHERE Id =: newquestion.Id ];
        
        
        System.currentPagereference().getParameters().put('q_Id',newquestion.Id);
        p.EditQuestion();   
        
        /* clone case */
        //actPerform='edit';
        p.actionPerform = 'edit';
        p.saveQuestionnaire();
        
        p.actionPerform = 'clone';
        p.saveQuestionnaire();
        p.actionPerform = 'null';
        p.saveQuestionnaire();
        
        
        System.currentPagereference().getParameters().put('q_Id',newquestion.Id);
        p.SaveQuestion();      
        
        p.IDdeleteQ = newquestion.Id;
        p.deleteQuestion(); 
        
    }
}