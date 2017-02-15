/***************************************************************
Name: UL_PromotionClosureBatchTest
======================================================
Purpose: Testclass for UL_PromotionClosureBatch

======================================================
History
-------
VERSION     AUTHOR			DATE             DETAIL                 Description
1.0         Marcel Schulz	18/01/2017       Initial Development    Testclass for UL_PromotionClosureBatch
***************************************************************/
@isTest(SeeAllData=false)
public class UL_PromotionClosureBatchTest {
	
    @isTest
	private static void testUL_PromotionClosureBatch(){
        //Create a User
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User sysuser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = adminProfile.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='adminuser@tpmorg.com');
        insert sysuser;
        
        //creating customer template record
        ACCL__Account_Template__c TestCustomerTemplate1 = new ACCL__Account_Template__c();
        TestCustomerTemplate1.name = 'CustomerTemplateForTest123';
        TestCustomerTemplate1.ACCL__Initial_Roles__c = 'customer';
        TestCustomerTemplate1.ACCL__Active__c = True;
        TestCustomerTemplate1.RecordTypeId = Schema.SObjectType.ACCL__Account_Template__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        TestCustomerTemplate1.ACCL__Sales_Org__c ='AR01';
        TestCustomerTemplate1.ACCL__Description_Language_1__c = 'Template description1';
        insert TestCustomerTemplate1;
        
        //ceating customer record
        Account testcustomer = new Account();
        testcustomer.name = 'TestCustomer';
        testcustomer.ACCL__Account_Number__c = '123';
        testcustomer.ACCL__Name_2__c = 'test123';
        testcustomer.ACCL__Account_Template__c = TestCustomerTemplate1.id;
        insert testcustomer;
        
        //creating Promotion template record
        ACCL__Promotion_Template__c testPromotionTemplate = new ACCL__Promotion_Template__c();
        testPromotionTemplate.Name= 'Promotion Template for Test';
        testPromotionTemplate.UL_Promo_Type_ControlView__c= 'Promotion';
        testPromotionTemplate.ACCL__Sales_Org__c= 'AR01';
        testPromotionTemplate.ACCL__Description_Language_1__c= 'Promotion Template description';
        testPromotionTemplate.ACCL__Anchor_Type__c= 'Customer';
        insert testPromotionTemplate;
        
        //Creating promotion record
        ACCL__Promotion__c testPromotion = new ACCL__Promotion__c();
        testPromotion.ACCL__Active__c=TRUE;
        testPromotion.ACCL__Promotion_Template__c=testPromotionTemplate.id;
        testPromotion.ACCL__Slogan_Language_1__c='Promotion Test';
        testPromotion.ACCL__Anchor_Account__c=testcustomer.id;
        testPromotion.ACCL__Commit_Date__c=Date.today();
        testPromotion.ACCL__Date_From__c=Date.today()-1;
        testPromotion.ACCL__Date_Thru__c=Date.today();
        testPromotion.ACCL__Phase__c='Approved';
        testPromotion.UL_WorkflowState__c='Approved';
        testPromotion.RecordTypeId= Schema.SObjectType.ACCL__Promotion__c.getRecordTypeInfosByName().get('Promotion').getRecordTypeId(); 
        insert testPromotion;
    	
        
        Test.startTest();
        	Database.executeBatch(new UL_PromotionClosureBatch(new List<ACCL__Promotion__c>{testPromotion}));
		Test.stopTest();

    }
    
    
}