/*
  Class Name: CORE_CA_Delete_Fullyapproved_Batch_Test
  Author : Mindtree
  Date: 26 sep 2016
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Test class to cover 
                           1.CORE_CA_Delete_Fullyapproved_Batch
                           
*/

@isTest(SeeAllData=true)
public class CORE_CA_Delete_Fullyapproved_Batch_Test {    
    public static testMethod void testMethodFullyapprovedBatch(){
       
       //Test User
       profile p=[select id from profile where name=:'System Administrator']; 
       User obj_user1 = new User (username='Core_CA_testHeaderUser1@admintest.com',IsActive=true,Alias='user1',timezonesidkey='America/Los_Angeles',
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser1@admintest.com',FederationIdentifier='feed1', FirstName='Header',
                                 LastName='user1',emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US');
       insert obj_user1;
       //Test Data for custom settings
  
       //Test data for Header object.
       Core_Approval_Header__c objHeader = new Core_Approval_Header__c(Name = 'testHeader1',Source_System__c = 'Ariba',Status__c= 'Fully Approved',CreatedDate=Date.Today().addDays(-35),LastModifiedDate=Date.Today().addDays(-30));
       insert objHeader;
       System.assert(objHeader != null);
       
       // Code coverage for 'CORE_CA_Delete_Fullyapproved_Batch'
       Test.StartTest();
       List<Core_Approval_Header__c> scope = new List<Core_Approval_Header__c>(); 
       scope.add(objheader);
       Database.BatchableContext BC;
       CORE_CA_Delete_Fullyapproved_Batch objReminderAlertBatch = new CORE_CA_Delete_Fullyapproved_Batch();
       //objReminderAlertBatch.start(bc);
       objReminderAlertBatch.execute(BC, scope); 
       objReminderAlertBatch.finish(BC);        
       Test.stopTest();
    
    }
   
  
}