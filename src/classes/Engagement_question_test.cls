@IsTest
public class Engagement_question_test{

  static testMethod void engagement5() {
  
  Test.startTest();
  
  List<Engagement_User_Detail__c> engage1 = new List<Engagement_User_Detail__c>();
  Engagement_User_Detail__c ud = new Engagement_User_Detail__c();
  ud.Question_Number__c = 0;
  ud.Location__c = 'Warehouse';
  ud.Location_Name__c = 'Warehouse1';
  ud.Username__c = UserInfo.getUsername();
  insert ud;
  System.assertEquals(ud.Location__c, 'Warehouse'); 
  
  Engagement_Question__c q = new Engagement_Question__c();
  q.Name = 'W1';
  q.Location__c = 'Warehouse';
  q.Name = 'W1';
  q.Answer1__c = 'a';
  q.Answer2__c = 'b';
  q.Answer3__c = 'c';
  q.Answer4__c = 'd';
  q.Answer5__c = 'e';
  insert q;
  
  List<Engagement_Answers__c> engage = new List<Engagement_Answers__c>();
  Engagement_Answers__c a = new Engagement_Answers__c();
  a.Location__c = 'Warehouse';
  a.Location_Name__c = 'Warehouse1';
  a.Username__c = UserInfo.getUsername();
  a.Rating__c = 7; 
  insert a;
  
  ApexPages.CurrentPage().getParameters().put('param','Warehouse');
  ApexPages.CurrentPage().getParameters().put('param1','Warehouse1');
  
  Engagement_question_cc eques = new Engagement_question_cc();
  eques.bar = 25;
  eques.getRecords();
  eques.getItems();
  eques.getBar1() ;
  eques.val1 = 'a';
  eques.val2 = 7;
  eques.SaveRecord();
  eques.save();
  eques.val1 = '';
  eques.save();
  
    Test.stopTest(); 
  }
 }