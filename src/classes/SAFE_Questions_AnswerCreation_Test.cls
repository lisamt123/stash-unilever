/**
 * Name:        -   SAFE_Questions_AnswerCreation_Test
 * @description -   This is the test class for SAFE_Questions_AnswerCreation Trigger to verify the code  while creating SAFE Question record. 
 * @Author      -   Deepika Gulati, Mindtree Ltd     
 */

@isTest
public class SAFE_Questions_AnswerCreation_Test {
/*******************************************************************
Purpose: Method to test trigger by creating a question record.
********************************************************************/
    static testMethod void createQuestionTest() {
    
           SAFE_Risk_Assessment_Questionnaire__c questionnaire = createQuestionnaire();
        try{
        
            SAFE_Questions__c question = new SAFE_Questions__c();
            question.SAFE_Questionnaire__c = questionnaire.Id;
            question.SAFE_Answers__c ='Ans1;Ans2;Ans3';
            question.SAFE_Scores__c = '1;2;3';
            question.SAFE_Answering_Method__c = 'Radio Button Objective Answering';
            question.SAFE_Weightage__c = 12;
            question.SAFE_Question_Status__c = 'Activated';
            question.SAFE_Help_Text__c = 'Test';
            insert question; 
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
    }
    static testMethod void createQuestionTest1() 
    {
        SAFE_Risk_Assessment_Questionnaire__c questionnaire = createQuestionnaire();
        try{
            SAFE_Questions__c question1 = new SAFE_Questions__c();
            question1.SAFE_Questionnaire__c = questionnaire.Id;
            question1.SAFE_Answers__c ='Ans1;Ans2;Ans3';
            question1.SAFE_Scores__c = '1;2';
            question1.SAFE_Answering_Method__c = 'Radio Button Objective Answering';
            question1.SAFE_Weightage__c = 12;
            question1.SAFE_Question_Status__c = 'Activated';
            question1.SAFE_Help_Text__c = 'Test';
            insert question1; 
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
    }
    
    static testMethod void createQuestionTest2() 
    {    
        
        SAFE_Risk_Assessment_Questionnaire__c questionnaire = createQuestionnaire();
        try{
            SAFE_Questions__c question2 = new SAFE_Questions__c();
            question2.SAFE_Questionnaire__c = questionnaire.Id;
            question2.SAFE_Answers__c ='Ans1;Ans2;Ans3';
            question2.SAFE_Scores__c = '1;Ans;Ans2';
            question2.SAFE_Answering_Method__c = 'Radio Button Objective Answering';
            question2.SAFE_Weightage__c = 12;
            question2.SAFE_Question_Status__c = 'Activated';
            question2.SAFE_Help_Text__c = 'Test';
            insert question2;
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
        }
        
    }
    
    public static SAFE_Risk_Assessment_Questionnaire__c createQuestionnaire()
    {
        SAFE_Risk_Assessment_Questionnaire__c questionnaire = new SAFE_Risk_Assessment_Questionnaire__c();
        questionnaire.Name = 'Test';
        questionnaire.SAFE_Description__c = 'Test';
        questionnaire.SAFE_Status__c    = 'Published';
        insert questionnaire;
        return questionnaire ;
        
    }
}