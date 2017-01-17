/**
 * Name:        -   SAFE_RiskAssessmentListView_Test
 * @description -   This is the test class for SAFE_RiskAssessmentListView_CC Controller to verify the code  while Viewing Risk assessment list and submitting Questions. 
 * @Author      -   Sibatri Ray, Mindtree Ltd     
 */
@isTest
public with sharing class SAFE_RiskAssessmentListView_Test {
public static SAFE_Risk_Assessment__c riskAss = new SAFE_Risk_Assessment__c();
public static  ApexPages.StandardController sc = new ApexPages.StandardController(riskAss);   
public static   SAFE_RiskAssessmentListView_CC p=new SAFE_RiskAssessmentListView_CC (sc);
    
 /*code by Sibatri for Pagination functionality*/
public static testMethod void testPagination() {
    
    p.Firstbtn();
    p.prvbtn();
    p.Nxtbtn();
    p.lstbtn();
    p.getNxt();
    p.getPrv();
}
 /*code by Sibatri for ProcesslinkClick,Save,Submit functionality*/
public static testMethod void testResponseList() {
   
       SAFE_Risk_Assessment__c newriskAss =new SAFE_Risk_Assessment__c(SAFE_Project_Name__c='proj1',SAFE_Project_End_Date__c=date.parse('1/1/2017'),SAFE_Project_Start_Date__c=date.parse('1/12/2016'),SAFE_Risk_Assessment_Link__c='http://',SAFE_Status__c='Not Completed');
    //   riskAssList.add(newriskAss);
   
    insert newriskAss;
    SAFE_Risk_Assessment__c nameRisk = [Select id,Name from SAFE_Risk_Assessment__c where  Id =: newriskAss.Id];
    
    List<SAFE_Risk_Assessment__c> ResponseList = p.getResponseList();       
    System.AssertEquals(newriskAss.SAFE_Status__c, 'Not Completed'); 
    ////
     PageReference pg = Page.SAFE_QuestionaireTab;
     
    Test.setCurrentPage(pg);  
    string riskId = newriskAss.Id; 
   
    System.currentPagereference().getParameters().put('id1',riskId);
    
    SAFE_Risk_Assessment_Questionnaire__c newquestionire=new SAFE_Risk_Assessment_Questionnaire__c(Name='Questionaire1',SAFE_Status__c='Published');
    insert newquestionire;
    
    SAFE_Questions__c newques=new SAFE_Questions__c(SAFE_Questionnaire__c=newquestionire.Id,SAFE_Answering_Method__c='Radio Button Objective Answering',SAFE_Question__c='Ques1',SAFE_Answers__c='Ice-cream;Hair;Laundry;Deodrants;Oral-care;Beverages',SAFE_Scores__c='1;2;3;4;5;6',SAFE_Question_Status__c='Activated',SAFE_Weightage__c=12,SAFE_Help_Text__c='http');
    insert newques;
    
    SAFE_Questions__c newquesChkBox=new SAFE_Questions__c(SAFE_Questionnaire__c=newquestionire.Id,SAFE_Answering_Method__c='Checkbox Objective Answering',SAFE_Question__c='Ques2',SAFE_Answers__c='Cans;Tubes;Cartons',SAFE_Scores__c='1;2;3',SAFE_Question_Status__c='Activated',SAFE_Weightage__c=12,SAFE_Help_Text__c='http');
    insert newquesChkBox;
    
    SAFE_Responses__c newRes =new SAFE_Responses__c(SAFE_Question__c='Ques1',SAFE_Answer__c='Ice-cream',SAFE_Risk_Assessment__c=nameRisk.Id,SAFE_Score_Value__c=12);
    insert newRes;
    
     SAFE_Responses__c newResChkBox =new SAFE_Responses__c(SAFE_Question__c='Ques2',SAFE_Answer__c='Cans',SAFE_Risk_Assessment__c=nameRisk.Id,SAFE_Score_Value__c=15);
    insert newResChkBox;
  
     SAFE_Answers__c newAns =new SAFE_Answers__c(Name='Ice-cream',SAFE_Score_Value__c=23,SAFE_Question__c=newques.Id);
     insert newAns; 
    
     SAFE_Answers__c newAnsChkBox =new SAFE_Answers__c(Name='Cans',SAFE_Score_Value__c=23,SAFE_Question__c=newquesChkBox.Id);
     insert newAnsChkBox;  
    
   Id resId=newRes.Id;
     Set<Id> questionIdSet = new Set<Id>();
   
    
    
    
    SAFE_Risk_Assessment_Questionnaire__c questionnaire = [Select id,SAFE_Status__c, (Select id,SAFE_Answering_Method__c,SAFE_Question__c,SAFE_Question_Status__c,SAFE_Weightage__c from Questions__r)  from SAFE_Risk_Assessment_Questionnaire__c where  SAFE_Status__c =: 'Published' LIMIT 1];
    
    System.AssertEquals(questionnaire.SAFE_Status__c, 'Published'); 
    System.AssertEquals(newques.SAFE_Question_Status__c, 'Activated');
     System.AssertEquals(newquesChkBox.SAFE_Question_Status__c, 'Activated');
    if(newques.SAFE_Question_Status__c == 'Activated')
    {
       questionIdSet.add(newques.Id);
        questionIdSet.add(newquesChkBox.Id);
        
    }
    Set<String> strList = new Set<String>();
    
        strList.add(newAnsChkBox.Id);
        strList.add ('Cans');
        strList.add('false');
  
    p.processLinkClick();
 //   p.setAnswerOptions(strList);
   // p.setAnswerOptions(strList) ;
    
   // public void setAnswerOptions(List<String> strList) {
      //  answerOptions=strList;
//        }
   // p.getAnswerOptions();
    //p.getResponseDetailFromQuestionValue(newques.SAFE_Question__c);
    p.saveQuestionAnswerResponseObj();
    p.submitQuestionAnswerResponseObj();
    
    
    
    /*code by sagar for Delegate functionality*/
    
        Profile p1 = [select id,Name from Profile where Name='Standard Platform User']; 
        User opUser = new user(alias = 'test123', email='test123@noemail.com',emailencodingkey='UTF-8', firstName='Pawan', lastname='Testing', 
        languagelocalekey='en_US',localesidkey='en_US', profileid = p1.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='test01@noemail.com'); 
    
            System.runAs(opUser)
            {              
                SAFE_RiskAssessmentListView_CC SAFE_Delegate = new SAFE_RiskAssessmentListView_CC();
                SAFE_Delegate.showPopup();
                SAFE_Delegate.closePopup();
                List<User> Users = SAFE_RiskAssessmentListView_CC.searchuser('Testing');
                System.assertEquals(true, Users.size()!=0);
                
                Test.setCurrentPageReference(new PageReference('Page.SAFE_QuestionaireTabTest'));            
                SAFE_Delegate.selecteduser = userInfo.getUserId();
                SAFE_Delegate.ExtUserEmail = 'abc@test.com';
                SAFE_Delegate.QuestionID = newquesChkBox.ID;
                SAFE_Delegate.redirectPopup();              
            }
    // End of code for delegate functionality
    
   
}

}