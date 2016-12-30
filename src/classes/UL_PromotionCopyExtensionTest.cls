@isTest
private class UL_PromotionCopyExtensionTest{
    private static testMethod void test1(){
    
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
        system.runAs(sysuser){
        insert testcustomer;
        }
    
      //creating Fund Template Record
        ACCL__Fund_Template__c testFundTemplate1 = new ACCL__Fund_Template__c();
        testFundTemplate1.Name = 'FundTemplateForTest1';
        testFundTemplate1.ACCL__Active__c = True;
        testFundTemplate1.ACCL__Sales_Org__c = 'AR01';
        testFundTemplate1.ACCL__Description_Language_1__c = 'fund template description1';
        testFundTemplate1.ACCL__Anchor_Type__c = 'Customer';
        insert testFundTemplate1;       

        
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
        testPromotion.ACCL__Date_From__c=Date.today();
        testPromotion.ACCL__Date_Thru__c=Date.today();
        testPromotion.ACCL__Phase__c='Planning';
        testPromotion.RecordTypeId= Schema.SObjectType.ACCL__Promotion__c.getRecordTypeInfosByName().get('Promotion').getRecordTypeId(); 
        insert testPromotion;
       
       system.debug('>>>>>>>>>>'+testPromotion);
      //Creating Tactic Template Record
        ACCL__Tactic_Template__c testTacticTemplate = new ACCL__Tactic_Template__c();
        testTacticTemplate.Name='TacticTemplateForTest';
        testTacticTemplate.ACCL__Active__c=TRUE;
        testTacticTemplate.ACCL__Sales_Org__c='AR01';
        testTacticTemplate.ACCL__Tactic_Type__c='Display';
        testTacticTemplate.ACCL__Description_Language_1__c='Tactic Template Description 1';
        insert testTacticTemplate;
      
    
      //Creating Tactic Record
        ACCL__Tactic__c testTactic = new ACCL__Tactic__c();
        testTactic.ACCL__Included__c=TRUE;
        testTactic.ACCL__Promotion__c=testPromotion.id;
        testTactic.ACCL__Amount__c=200;
        testTactic.ACCL__Payment_Method__c='OnInvoice';
        testTactic.ACCL__Compensation_Model__c='LumpSum';
        testTactic.ACCL__Date_From__c=Date.today();
        testTactic.ACCL__Date_From__c=Date.today();
        testTactic.UL_Promotion_Phase__c='Planning';
        testTactic.ACCL__Tactic_Template__c=testTacticTemplate.id;
        testTactic.RecordTypeId= Schema.SObjectType.ACCL__Tactic__c.getRecordTypeInfosByName().get('Display').getRecordTypeId();
        insert testTactic;
        
        Test.startTest();
        PageReference pageRef = Page.UL_PromotionCopy;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(testPromotion);
        UL_PromotionCopyExtension promotionCopy = new UL_PromotionCopyExtension(sc);
        promotionCopy.save();
        promotionCopy.updateAccountsAccountSets();
        UL_PromotionCopyExtension.isPromotionTemplateAnchorTypeCustomer(testPromotionTemplate.id);
        promotionCopy.reloadAccountSets();
        promotionCopy.updateSelectedAccountAccountSet();
        promotionCopy.reloadAccounts();
        promotionCopy.updateAnchorcustomer();
        promotionCopy.cancel1();
        //UL_PromotionUtility promotionUtility = new UL_PromotionUtility();
        
        
        Test.stopTest();

    } 
}