@IsTest
public class Engagement_question_edit_test{

  static testMethod void engagement6() {
  
  Test.startTest();
  
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
  
  List<Engagement_Answers__c> alist = new List<Engagement_Answers__c>();
  Engagement_Answers__c a = new Engagement_Answers__c();
  a.Location__c = 'Warehouse';
  a.Location_Name__c = 'Warehouse1';
  a.Username__c = UserInfo.getUsername();
  a.Rating__c = 7;
  a.Question_Id__c = q.id;
  insert a;
  System.assertEquals(a.Location__c, 'Warehouse'); 
  
  Attachment d = new Attachment();
  d.Name = 'Eng1';
  Blob bodyBlob=Blob.valueOf('Eng1'); 
  d.body = bodyblob;
  d.Parentid = a.id;
  insert d;
  
  ApexPages.CurrentPage().getParameters().put('qId',q.id);
  
  Engagement_question_Edit_cc eques1 = new Engagement_question_Edit_cc();
  eques1.val1 = 'a';
  eques1.file = Blob.valueOf('Eng1');
  eques1.file2 = Blob.valueOf('Eng1');
  eques1.file3 = Blob.valueOf('Eng1');
  eques1.getPhotos();
  eques1.getPhotos1();
  eques1.getPhotos2();
  eques1.save();
  
  Test.stopTest();  
  }
 }