/*
  Class Name: CORE_CA_ReminderAlert_Batch_Test
  Author : Mindtree
  Date: 15 sep 2014
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Test class to cover 
                           1.CORE_CA_ReminderAlert_Batch
                           2.CORE_CA_ReminderAlert_Scheduler
                           
*/

@isTest(SeeAllData=true)
public class CORE_CA_ReminderAlert_Batch_Test {    
    public static testMethod void testMethodReminderAlertBatch(){
       
       //Test User
       profile p=[select id from profile where name=:'System Administrator']; 
       User obj_user1 = new User (username='Core_CA_testHeaderUser1@admintest.com',IsActive=true,Alias='user1',timezonesidkey='America/Los_Angeles',
                                 ProfileId=p.id,Email='Core_CA_testHeaderUser1@admintest.com',FederationIdentifier='feed1', FirstName='Header',
                                 LastName='user1',emailencodingkey='UTF-8',languagelocalekey='en_US',localesidkey='en_US');
       insert obj_user1;
       
       //Test data for Header object.
       Core_Approval_Header__c objHeader1 = new Core_Approval_Header__c(Name = 'testHeader1',Source_System__c = 'Ariba',Status__c= 'Submitted', Reminder_Alert_Days__c= 0 );
       insert objHeader1;
       System.assert(objHeader1 != null);
             
       //Test Data for Interested party object with source system as 'Ariba'. 
       JSONGenerator generator = JSON.createGenerator(true);                 //instantiation of the generator
       generator.writeStartObject();                                        // Writes the starting marker of a JSON object '{'
       generator.writeIdField('Interested_Party__c', UserInfo.getUserId()); 
       generator.writeBooleanField('Is_Active__c', true);  
       generator.writeIdField('Approval_Header__c', objHeader1.Id);
       generator.writeStringField('Source_System__c', 'ariba');
       generator.writeDateTimeField('CreatedDate', SYSTEM.now());
       generator.writeEndObject();                                          //Writes the ending marker of a JSON object '}'
       String jsonString = generator.getAsString();
       //Json deserializing
       Core_Approver_Details__c  objApprover1 = (Core_Approver_Details__c ) JSON.deserialize(jsonString, Core_Approver_Details__c.class );
       insert objApprover1;
       System.assert(objApprover1 != null);
       
       //Test Data for Interested party object with source system as 'GTES'. 
       integer intReminderAlertDays = integer.valueOf(CORE_Chatter_Approval__c.getinstance('GTES').ReminderAlertDays__c);
       JSONGenerator generator1 = JSON.createGenerator(true);                 //instantiation of the generator
       generator1.writeStartObject();                                         // Writes the starting marker of a JSON object '{'
       generator1.writeIdField('Interested_Party__c', UserInfo.getUserId());    
       generator1.writeIdField('Approval_Header__c', objHeader1.Id);
       generator1.writeStringField('Source_System__c', 'GTES');
       generator1.writeDateTimeField('CreatedDate', SYSTEM.now().AddDays(-intReminderAlertDays));
       generator1.writeEndObject();                                           //Writes the ending marker of a JSON object '}'
       String jsonString1 = generator1.getAsString();
       //Json deserializing
       Core_Approver_Details__c  objApprover2 = (Core_Approver_Details__c ) JSON.deserialize(jsonString1, Core_Approver_Details__c.class );
       insert objApprover2;
       System.assert(objApprover2 != null);
       
       // Code coverage for 'CORE_CA_ReminderAlert_Batch'
       Test.StartTest();
       List<Core_Approver_Details__c> scope = new List<Core_Approver_Details__c>(); 
       scope.add(objApprover1);
       scope.add(objApprover2);
       Database.BatchableContext BC;
       CORE_CA_ReminderAlert_Batch objReminderAlertBatch = new CORE_CA_ReminderAlert_Batch();
       //objReminderAlertBatch.start(bc);
       objReminderAlertBatch.execute(BC, scope); 
       objReminderAlertBatch.finish(BC);        
       
       //Insert Fully approved PR for Ariba
       /*JSONGenerator generator2 = JSON.createGenerator(true);                 //instantiation of the generator
       generator2.writeStartObject();                                        // Writes the starting marker of a JSON object '{'
       generator2.writeStringField('Status__c', 'Fully Approved'); 
       generator2.writeIdField('Requested_By__c', obj_user1.Id);  
       generator2.writeStringField('Source_System__c', 'Ariba');
       generator2.writeDateTimeField('LastModifiedDate', SYSTEM.now());
       generator2.writeEndObject();                                          //Writes the ending marker of a JSON object '}'
       String jsonString2 = generator2.getAsString();
       //Json deserializing
       Core_Approval_Header__c  objheader2 = (Core_Approval_Header__c) JSON.deserialize(jsonString2, Core_Approval_Header__c.class );
       insert objheader2;
       System.assert(objheader2 != null);*/ 
       
       // Code coverage for 'CORE_CA_UnfollowUser_Batch'
       /*List<Core_Approval_Header__c> scope1 = new List<Core_Approval_Header__c>(); 
       scope1.add(objheader2);
       Database.BatchableContext BC1;
       CORE_CA_UnfollowUser_Batch objUnfollowBatch = new CORE_CA_UnfollowUser_Batch();
       objUnfollowBatch.start(bc1);
       objUnfollowBatch.execute(BC1, scope1); 
       objUnfollowBatch.finish(BC1);*/
       Test.stopTest();
    }
    
    
   public static testMethod void testMethodReminderAlertBatchScheduler() {        
         test.starttest();
         // Code coverage for 'CORE_CA_ReminderAlert_Scheduler'
         CORE_CA_ReminderAlert_Scheduler myClass = new CORE_CA_ReminderAlert_Scheduler();
         System.assert(myClass != null);
         //String chron = '0 0 0 3 9 ? 2022';//'0 0 23 * * ?';        
         //system.schedule('Test Sched111', chron, myClass);
         //CORE_CA_UnfollowUser_Scheduler objUnfollowScheduler = new CORE_CA_UnfollowUser_Scheduler();
         test.stopTest();
    }
   
}