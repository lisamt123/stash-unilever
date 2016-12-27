/**
 * Name:        -   PACV_RiskAssessmentListView_Test
 * @description -   This is the test class for PACV_RiskAssessmentListView_CC Controller to verify the code  while Viewing Risk assessment list and submitting Questions. 
 * @Author      -   Sibatri Ray, Mindtree Ltd     
 */
@isTest
public with sharing class PACV_RiskAssessmentListView_Test {
public static PACV_Risk_Assessment__c riskAss = new PACV_Risk_Assessment__c();
public static  ApexPages.StandardController sc = new ApexPages.StandardController(riskAss);   
public static   PACV_RiskAssessmentListView_CC p=new PACV_RiskAssessmentListView_CC (sc);
    
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
   
       PACV_Risk_Assessment__c newriskAss =new PACV_Risk_Assessment__c(PACV_Project_Name__c='proj1',PACV_Project_End_Date__c=date.parse('1/1/2017'),PACV_Project_Start_Date__c=date.parse('1/12/2016'),PACV_Risk_Score_X__c=12,PACV_Risk_Status__c='Not Started',PACV_Risk_Assessment_Link__c='http://',PACV_Status__c='Not Completed');
    //   riskAssList.add(newriskAss);
   
    insert newriskAss;
    PACV_Risk_Assessment__c nameRisk = [Select id,Name from PACV_Risk_Assessment__c where  Id =: newriskAss.Id];
    
    List<PACV_Risk_Assessment__c> ResponseList = p.getResponseList();       
    System.AssertEquals(newriskAss.PACV_Status__c, 'Not Completed'); 
    ////
     PageReference pg = Page.PACV_QuestionaireTab;
    Test.setCurrentPage(pg);  
    string riskId = newriskAss.Id; 
   
    System.currentPagereference().getParameters().put('id1',riskId);
    
	PACV_Risk_Assessment_Questionnaire__c newquestionire=new PACV_Risk_Assessment_Questionnaire__c(Name='Questionaire1',PACV_Status__c='Published');
    insert newquestionire;
    
    PACV_Questions__c newques=new PACV_Questions__c(PACV_Questionnaire__c=newquestionire.Id,PACV_Answering_Method__c='Radio Button Objective Answering',PACV_Question__c='Ques1',PACV_Answers__c='Ice-cream;Hair;Laundry;Deodrants;Oral-care;Beverages',PACV_Scores__c='1;2;3;4;5;6',PACV_Question_Status__c='Activated',PACV_Weightage__c=12,PACV_Help_Text__c='http');
    insert newques;
    
    PACV_Questions__c newquesChkBox=new PACV_Questions__c(PACV_Questionnaire__c=newquestionire.Id,PACV_Answering_Method__c='Checkbox Objective Answering',PACV_Question__c='Ques2',PACV_Answers__c='Cans;Tubes;Cartons',PACV_Scores__c='1;2;3',PACV_Question_Status__c='Activated',PACV_Weightage__c=12,PACV_Help_Text__c='http');
    insert newquesChkBox;
    
    PACV_Responses__c newRes =new PACV_Responses__c(PACV_Question__c='Ques1',PACV_Answer__c='Ice-cream',PACV_Risk_Assessment__c=nameRisk.Id,PACV_Score_Value__c=12);
    insert newRes;
    
     PACV_Responses__c newResChkBox =new PACV_Responses__c(PACV_Question__c='Ques2',PACV_Answer__c='Cans',PACV_Risk_Assessment__c=nameRisk.Id,PACV_Score_Value__c=15);
    insert newResChkBox;
  
     PACV_Answers__c newAns =new PACV_Answers__c(Name='Ice-cream',PACV_Score_Value__c=23,PACV_Question__c=newques.Id);
     insert newAns; 
    
     PACV_Answers__c newAnsChkBox =new PACV_Answers__c(Name='Cans',PACV_Score_Value__c=23,PACV_Question__c=newquesChkBox.Id);
     insert newAnsChkBox;  
    
   Id resId=newRes.Id;
     Set<Id> questionIdSet = new Set<Id>();
   
    
 	
    
    PACV_Risk_Assessment_Questionnaire__c questionnaire = [Select id,PACV_Status__c, (Select id,PACV_Answering_Method__c,PACV_Question__c,PACV_Question_Status__c,PACV_Weightage__c from Questions__r)  from PACV_Risk_Assessment_Questionnaire__c where  PACV_Status__c =: 'Published' LIMIT 1];
    
    System.AssertEquals(questionnaire.PACV_Status__c, 'Published'); 
    System.AssertEquals(newques.PACV_Question_Status__c, 'Activated');
     System.AssertEquals(newquesChkBox.PACV_Question_Status__c, 'Activated');
    if(newques.PACV_Question_Status__c == 'Activated')
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
    //p.getResponseDetailFromQuestionValue(newques.PACV_Question__c);
    p.saveQuestionAnswerResponseObj();
    p.submitQuestionAnswerResponseObj();
    
    
    
    /*code by sagar for Delegate functionality*/
    
		Profile p1 = [select id,Name from Profile where Name='Standard Platform User']; 
        User opUser = new user(alias = 'test123', email='test123@noemail.com',emailencodingkey='UTF-8', firstName='Pawan', lastname='Testing', 
        languagelocalekey='en_US',localesidkey='en_US', profileid = p1.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='test01@noemail.com'); 
    
    		System.runAs(opUser)
        	{              
                PACV_RiskAssessmentListView_CC PACV_Delegate = new PACV_RiskAssessmentListView_CC();
                PACV_Delegate.showPopup();
                PACV_Delegate.closePopup();
                List<User> Users = PACV_RiskAssessmentListView_CC.searchuser('Testing');
                System.assertEquals(true, Users.size()!=0);
                
                Test.setCurrentPageReference(new PageReference('Page.PACV_QuestionaireTabTest'));            
                PACV_Delegate.selecteduser = userInfo.getUserId();
                PACV_Delegate.ExtUserEmail = 'abc@test.com';
                PACV_Delegate.QuestionID = newquesChkBox.ID;
                PACV_Delegate.redirectPopup();              
        	}
    // End of code for delegate functionality
    
   
}

}