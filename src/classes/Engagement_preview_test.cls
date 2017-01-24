@IsTest
public class Engagement_preview_test{

  static testMethod void engagement2() {
  
  Test.startTest();
  
  Engagement_Answers__c a = new Engagement_Answers__c();
  a.Location__c = 'Warehouse';
  a.Location_Name__c = 'Warehouse1';
  a.Username__c = UserInfo.getUsername();
  a.Rating__c = 7;
  insert a;
  System.assertEquals(a.Location__c, 'Warehouse'); 
  
  Engagement_Question__c q = new Engagement_Question__c();
  q.Name = 'W1';
  q.Location__c = 'Warehouse';
  insert q;
  
  Engagement_User_Detail__c ud = new Engagement_User_Detail__c();
  ud.Question_Number__c = 2;
  ud.Username__c = UserInfo.getUsername();
  insert ud;
  
  Engagement_preview_cc epreview = new  Engagement_preview_cc();
  epreview.getQuestions();
  epreview.Submit();
  
  Test.stopTest(); 
  }
  
 }