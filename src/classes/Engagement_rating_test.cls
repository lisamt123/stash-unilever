@IsTest
public class Engagement_rating_test{

  static testMethod void engagement4() {
  
   Test.startTest();
  
  Engagement_Rating__c r = new Engagement_Rating__c();
  r.Rating__c = 98;
  r.Location_Name__c = 'Warehouse1';
  r.Location__c = 'Warehouse';
  r.Username__c =  UserInfo.getUsername();
  insert r;
  System.assertEquals(r.Location__c, 'Warehouse'); 
  
  Engagement_User_Detail__c u = new Engagement_User_Detail__c();
  u.Question_Number__c = 12;
  u.Username__c =  UserInfo.getUsername();
  insert u;
   
  Engagement_rating_cc ra = new Engagement_rating_cc();
  ra.getRLists();
  ra.getAvg();
  ra.gohome();
  
  Test.stopTest(); 
  
  }
 }