/**********************************************************************
Name:  CEC_AnonymiseConsumerBatchScheduler_Test
Copyright � 2015  Unilever
======================================================================
=======================================================================
Purpose: This is the test class for the Batch/Scheduler class for CEC_AnonymiseConsumer_BatchScheduler
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0      Masood           Dec-2015      INITIAL DEVELOPMENT   

***********************************************************************/
@isTest(SeeAllData=false)
public class CEC_AnonymiseConsumerBatchScheduler_Test {
    public static User insertUser()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Unilever - Salesforce MultiApp Standard'];
        
        User u = new User(LastName = 'Testing', 
                          Username = 'cectestuser@test00DE0000000bbLj.org', 
                          Email = 'testuser@test.com', 
                          Alias = 'utest', 
                          TimeZoneSidKey = 'Europe/London', 
                          LocaleSidKey = 'en_GB', 
                          EmailEncodingKey = 'UTF-8', 
                          ProfileId = p.Id, 
                          LanguageLocaleKey = 'en_US',
                          UserPermissionsKnowledgeUser = true);  
        
        insert u;
        List<PermissionSet> pslist = [SELECT Id FROM PermissionSet WHERE Name IN ('CEC_User','CEC_Manager','CEC_CRUD','CEC_Business_Admin','CEC_Knowledge_Manager','CEC_Automated_User')];
        List<PermissionSetAssignment> psalist = new List<PermissionSetAssignment>();
        for(PermissionSet ps:pslist)
        {
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = u.Id;
            psa.PermissionSetId = ps.Id;
            
            psalist.add(psa);
            
        }
        
        insert psalist;
        
        Group GR = [SELECT Id,name FROM Group WHERE Name = 'CEC - Knowledge Manager'];
        GroupMember GM = new GroupMember();
        GM.GroupId = GR.id;
        GM.UserOrGroupId = u.Id;
        insert GM;
        
        return u;
        
    }
    
    
    // Test method for the batch interface implementation
    @isTest static void test_AnonymiseConsumerBatchMethod() {
        // Implement test code
        Test.startTest(); 
        User u = insertUser();
        
        System.runAs(u)
        {
            date d1 = System.today().addDays(-3);
            string personRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            account accountObj1 = new Account(Salutation='Mr',FirstName='Peter',LastName='Parker',PersonEmail='abc@abc00DE0000000bbLj.com',Phone='12121212',BillingStreet='St peters',PersonMailingStreet='St peters',ShippingStreet='St peters',Retention_Date__c=d1,Anonymise_check__c=true);
           
            account accountObj2 = new Account(Salutation='Mr',FirstName='ben',LastName='afex',PersonEmail='abc2@abc00DE0000000bbLj.com',Phone='343535353',BillingStreet='bandra',PersonMailingStreet='bandra',ShippingStreet='bandra',Retention_Date__c=d1,Anonymise_check__c=true);
            
            account accountObj3 = new Account(Salutation='Mr',FirstName='jay',LastName='Z',PersonEmail='abc3@abc00DE0000000bbLj.com',Phone='12121464758',BillingStreet='santacruz',PersonMailingStreet='santacruz',ShippingStreet='santacruz');
            
            List<Account> accountList= new List<Account>();
            accountList.add(accountObj1);
            accountList.add(accountObj2);
            accountList.add(accountObj3);
            insert accountList;
            
            CEC_AnonymiseConsumer_BatchScheduler scheduler = new CEC_AnonymiseConsumer_BatchScheduler();
            database.executeBatch(scheduler);
           
            Test.stopTest();
            List<account> resultAccountList = [Select id,Anonymise_check__c, Date_Anonymized__c, Salutation,FirstName,LastName,PersonEmail,Phone,BillingStreet, PersonMailingStreet, ShippingStreet, Retention_Date__c from account where Id IN: accountList];
            
            for (Account accountObj : resultAccountList) {
                if (accountObj.Anonymise_check__c == false && accountObj.Date_Anonymized__c == null) {
                    System.assertNotEquals(accountObj.PersonEmail, null);
                    System.assertNotEquals(accountObj.Salutation, null);
                    System.assertNotEquals(accountObj.FirstName, null);
                    System.assertNotEquals(accountObj.LastName, null);
                    System.assertNotEquals(accountObj.Phone, null);
                    System.assertNotEquals(accountObj.BillingStreet, null);
                    System.assertNotEquals(accountObj.PersonMailingStreet, null);
                    System.assertNotEquals(accountObj.ShippingStreet, null);
                    System.assertEquals(accountObj.Retention_Date__c, null);
                    System.assertEquals(accountObj.Anonymise_check__c, false);
                } else if (accountObj.Anonymise_check__c == false && accountObj.Date_Anonymized__c != null){
                    System.assertEquals(accountObj.PersonEmail, null);
                    System.assertEquals(accountObj.Salutation, null);
                    System.assertEquals(accountObj.FirstName, null);
                    System.assertEquals(accountObj.Phone, null);
                    System.assertEquals(accountObj.BillingStreet, null);
                    System.assertEquals(accountObj.PersonMailingStreet, null);
                    System.assertEquals(accountObj.ShippingStreet, null);
                    System.assertEquals(accountObj.Phone, null);                    
                    System.assertEquals(accountObj.Anonymise_check__c, false);
                    System.assertNotEquals(accountObj.Retention_Date__c, null);
                    System.assertEquals(accountObj.LastName, accountObj.Id);
                }                
            }
        }
    }
    
    
    @isTest static void test_AnonymiseConsumerBatchMethod_Exception() {
        // Implement test code
        Test.startTest(); 
        User u = insertUser();
        
        System.runAs(u)
        {
            account accountObj= new Account(Salutation='Mr',FirstName='Peter',LastName='Parker',PersonEmail='abc@abc.com',Phone='12121212',BillingStreet='St peters',PersonMailingStreet='St peters',ShippingStreet='St peters',Anonymise_check__c=true);
            insert accountObj;
            
            CEC_AnonymiseConsumer_BatchScheduler scheduler = new CEC_AnonymiseConsumer_BatchScheduler();
            database.executeBatch(scheduler);
            
            Test.stopTest();
            
        }
    }
    
    
    // Test method for the Schedulable interface implementation
    @isTest static void test_AnonymiseConsumerSchedulerMethod() {
        // Implement test code
        Test.startTest(); 
        User u = insertUser();
        
        System.runAs(u)
        {
            String CRON_EXP = '0 20 * * * ?';
            String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new CEC_AnonymiseConsumer_BatchScheduler());
            CronTrigger ct = [SELECT Id, CronExpression FROM CronTrigger WHERE id = :jobId];
            // Verify the expressions are the same
            System.assertEquals(CRON_EXP, ct.CronExpression);
            Test.stopTest();
        }
    }
    
}