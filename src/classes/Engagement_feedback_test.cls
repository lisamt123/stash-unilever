@IsTest
public class Engagement_feedback_test{

  static testMethod void engagement3() {
  
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
  
  Engagement_feedback_cc efeed = new Engagement_feedback_cc();
  efeed.submit();
  efeed.preview();
  
   Test.stopTest(); 
  
  }
 }