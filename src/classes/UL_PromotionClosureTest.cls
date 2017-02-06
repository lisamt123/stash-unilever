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
public class UL_PromotionClosureTest {
	
    @testSetup 
    static void UL_PromotionClosureTestSetup(){
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
    }
    
    @isTest
	private static void UL_PromotionClosureTestBad(){
        
        
        //Creating promotion records (good one and bad one)
        List<ACCL__Promotion__c> allPromos = new List<ACCL__Promotion__c>();
        ACCL__Promotion__c testPromotion = new ACCL__Promotion__c();
        testPromotion.ACCL__Active__c=TRUE;
        testPromotion.ACCL__Promotion_Template__c=[Select Id From ACCL__Promotion_Template__c].id;
        testPromotion.ACCL__Slogan_Language_1__c='Promotion Test';
        testPromotion.ACCL__Anchor_Account__c=[Select Id From Account].id;
        testPromotion.ACCL__Commit_Date__c=Date.today()-2;
        testPromotion.ACCL__Date_From__c=Date.today()-2;
        testPromotion.ACCL__Date_Thru__c=Date.today()-2;
        testPromotion.ACCL__Phase__c='Approved';
        testPromotion.UL_WorkflowState__c='Approved';
        testPromotion.UL_Closed__c=false;
        testPromotion.RecordTypeId= Schema.SObjectType.ACCL__Promotion__c.getRecordTypeInfosByName().get('Promotion').getRecordTypeId();
        allPromos.add(testPromotion);
        ACCL__Promotion__c testPromotion2 = testPromotion.clone();
        testPromotion2.UL_WorkflowState__c='Planning';
        allPromos.add(testPromotion2);
        insert allPromos;
    	     
        Test.startTest();
        	System.debug('****UL_PromotionClosure.closePromotions(new List<Id>{testPromotion.Id, testPromotion2.Id})' + UL_PromotionClosure.closePromotions(new List<Id>{testPromotion.Id, testPromotion2.Id},false));
		Test.stopTest();
        System.assertEquals(0,[Select Id From ACCL__Promotion__c Where UL_Closed__c = true AND Id IN: allPromos].size());
    }
    
    @isTest
	private static void UL_PromotionClosureTestGood(){
        
        
        //Creating promotion records (good one and bad one)
        List<ACCL__Promotion__c> allPromos = new List<ACCL__Promotion__c>();
        ACCL__Promotion__c testPromotion = new ACCL__Promotion__c();
        testPromotion.ACCL__Active__c=TRUE;
        testPromotion.ACCL__Promotion_Template__c=[Select Id From ACCL__Promotion_Template__c].id;
        testPromotion.ACCL__Slogan_Language_1__c='Promotion Test';
        testPromotion.ACCL__Anchor_Account__c=[Select Id From Account].id;
        testPromotion.ACCL__Commit_Date__c=Date.today()-2;
        testPromotion.ACCL__Date_From__c=Date.today()-2;
        testPromotion.ACCL__Date_Thru__c=Date.today()-2;
        testPromotion.ACCL__Phase__c='Approved';
        testPromotion.UL_WorkflowState__c='Approved';
        testPromotion.UL_Closed__c=false;
        testPromotion.RecordTypeId= Schema.SObjectType.ACCL__Promotion__c.getRecordTypeInfosByName().get('Promotion').getRecordTypeId();
        allPromos.add(testPromotion);
        ACCL__Promotion__c testPromotion2 = testPromotion.clone();
        allPromos.add(testPromotion2);
        ACCL__Promotion__c testPromotion3 = testPromotion.clone();
        allPromos.add(testPromotion3);
        insert allPromos;
    	     
        Test.startTest();
        	System.debug('****UL_PromotionClosure.closePromotions(new List<Id>{testPromotion.Id, testPromotion2.Id})' + UL_PromotionClosure.closePromotions(new List<Id>{testPromotion.Id, testPromotion2.Id, testPromotion3.Id}, false));
		Test.stopTest();
        System.assertEquals(3,[Select Id From ACCL__Promotion__c Where UL_Closed__c = true AND Id IN: allPromos].size());
    }
    
    @isTest
	private static void UL_PromotionClosureTestSingleGood(){
        
        
        //Creating promotion records (good one and bad one)
        ACCL__Promotion__c testPromotion = new ACCL__Promotion__c();
        testPromotion.ACCL__Active__c=TRUE;
        testPromotion.ACCL__Promotion_Template__c=[Select Id From ACCL__Promotion_Template__c].id;
        testPromotion.ACCL__Slogan_Language_1__c='Promotion Test';
        testPromotion.ACCL__Anchor_Account__c=[Select Id From Account].id;
        testPromotion.ACCL__Commit_Date__c=Date.today()-2;
        testPromotion.ACCL__Date_From__c=Date.today()-2;
        testPromotion.ACCL__Date_Thru__c=Date.today()-2;
        testPromotion.ACCL__Phase__c='Approved';
        testPromotion.UL_WorkflowState__c='Approved';
        testPromotion.UL_Closed__c=false;
        testPromotion.RecordTypeId= Schema.SObjectType.ACCL__Promotion__c.getRecordTypeInfosByName().get('Promotion').getRecordTypeId();
        insert testPromotion;
    	     
        Test.startTest();
        	try {
        		System.debug('****UL_PromotionClosure.closePromotions(new List<Id>{testPromotion.Id, testPromotion2.Id})' + UL_PromotionClosure.closePromotions(new List<Id>{testPromotion.Id},true));
			} catch (Exception e){
        		
        	}
		Test.stopTest();
        System.assertEquals(1,[Select Id From ACCL__Promotion__c Where UL_Closed__c = true AND Id =: testPromotion.Id].size());
    }
    
    @isTest
	private static void UL_PromotionClosureTestSingleBad(){
        
        
        //Creating promotion records (good one and bad one)
        List<ACCL__Promotion__c> allPromos = new List<ACCL__Promotion__c>();
        ACCL__Promotion__c testPromotion = new ACCL__Promotion__c();
        testPromotion.ACCL__Active__c=TRUE;
        testPromotion.ACCL__Promotion_Template__c=[Select Id From ACCL__Promotion_Template__c].id;
        testPromotion.ACCL__Slogan_Language_1__c='Promotion Test';
        testPromotion.ACCL__Anchor_Account__c=[Select Id From Account].id;
        testPromotion.ACCL__Commit_Date__c=Date.today()-2;
        testPromotion.ACCL__Date_From__c=Date.today()-2;
        testPromotion.ACCL__Date_Thru__c=Date.today()-2;
        testPromotion.ACCL__Phase__c='Planning';
        testPromotion.UL_WorkflowState__c='Planning';
        testPromotion.UL_Closed__c=false;
        testPromotion.RecordTypeId= Schema.SObjectType.ACCL__Promotion__c.getRecordTypeInfosByName().get('Promotion').getRecordTypeId();
        insert testPromotion;
    	     
        Test.startTest();
        	try {
        		System.debug('****UL_PromotionClosure.closePromotions(new List<Id>{testPromotion.Id, testPromotion2.Id})' + UL_PromotionClosure.closePromotions(new List<Id>{testPromotion.Id}, true));
        	} catch (Exception e){
        		
        	}
		Test.stopTest();
        System.assertEquals(0,[Select Id From ACCL__Promotion__c Where UL_Closed__c = true AND Id IN: allPromos].size());
    }
}