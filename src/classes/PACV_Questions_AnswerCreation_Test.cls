/**
 * Name:        -   PACV_Questions_AnswerCreation_Test
 * @description -   This is the test class for PACV_Questions_AnswerCreation Trigger to verify the code  while creating PACV Question record. 
 * @Author      -   Deepika Gulati, Mindtree Ltd     
 */

@isTest
public class PACV_Questions_AnswerCreation_Test {
/*******************************************************************
Purpose: Method to test trigger by creating a question record.
********************************************************************/
    static testMethod void createQuestionTest() {
    
           PACV_Risk_Assessment_Questionnaire__c questionnaire = createQuestionnaire();
        try{
        
            PACV_Questions__c question = new PACV_Questions__c();
            question.PACV_Questionnaire__c = questionnaire.Id;
            question.PACV_Answers__c ='Ans1;Ans2;Ans3';
            question.PACV_Scores__c = '1;2;3';
            question.PACV_Answering_Method__c = 'Radio Button Objective Answering';
            question.PACV_Weightage__c = 12;
            question.PACV_Question_Status__c = 'Activated';
            question.PACV_Help_Text__c = 'Test';
            insert question; 
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
    }
    static testMethod void createQuestionTest1() 
    {
        PACV_Risk_Assessment_Questionnaire__c questionnaire = createQuestionnaire();
        try{
            PACV_Questions__c question1 = new PACV_Questions__c();
            question1.PACV_Questionnaire__c = questionnaire.Id;
            question1.PACV_Answers__c ='Ans1;Ans2;Ans3';
            question1.PACV_Scores__c = '1;2';
            question1.PACV_Answering_Method__c = 'Radio Button Objective Answering';
            question1.PACV_Weightage__c = 12;
            question1.PACV_Question_Status__c = 'Activated';
            question1.PACV_Help_Text__c = 'Test';
            insert question1; 
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
    }
    
    static testMethod void createQuestionTest2() 
    {    
        
        PACV_Risk_Assessment_Questionnaire__c questionnaire = createQuestionnaire();
        try{
            PACV_Questions__c question2 = new PACV_Questions__c();
            question2.PACV_Questionnaire__c = questionnaire.Id;
            question2.PACV_Answers__c ='Ans1;Ans2;Ans3';
            question2.PACV_Scores__c = '1;Ans;Ans2';
            question2.PACV_Answering_Method__c = 'Radio Button Objective Answering';
            question2.PACV_Weightage__c = 12;
            question2.PACV_Question_Status__c = 'Activated';
            question2.PACV_Help_Text__c = 'Test';
            insert question2;
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
        
    }
    
    public static PACV_Risk_Assessment_Questionnaire__c createQuestionnaire()
    {
        PACV_Risk_Assessment_Questionnaire__c questionnaire = new PACV_Risk_Assessment_Questionnaire__c();
        questionnaire.Name = 'Test';
        questionnaire.PACV_Description__c = 'Test';
        questionnaire.PACV_Status__c    = 'Published';
        insert questionnaire;
        return questionnaire ;
        
    }
}