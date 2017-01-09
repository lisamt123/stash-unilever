@isTest(SeeAllData=false)
private class UL_FundTransactionHandler_Test{
    
       
    
    @testSetup
    private static void CreateTestData(){
    Integer currentYear = System.Today().year();
    
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
    TestCustomerTemplate1.RecordTypeId = Schema.SObjectType.ACCL__Account_Template__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); //[SELECT Id FROM RecordType WHERE Name = 'Customer']
    TestCustomerTemplate1.ACCL__Sales_Org__c = 'AR01';
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
    //creating customer extension reocrd
    ACCL__Account_Extension__c testCustomerExtension = new ACCL__Account_Extension__c();
    testCustomerExtension.ACCL__Account__c = testcustomer.id;
    testCustomerExtension.ACCL__Fund_Role_Valid_From__c = Date.newInstance(2016, 1, 1);
    testCustomerExtension.ACCL__Fund_Role_Valid_Thru__c = Date.newInstance(2099,12,31);
    insert testCustomerExtension;
    
    //creating product template record
    ACCL__Product_Template__c testProductTemplate = new ACCL__Product_Template__c();
    testProductTemplate.Name = 'ProductTemplateForTest';
    testProductTemplate.ACCL__Active__c = True;
    testProductTemplate.RecordTypeId = Schema.SObjectType.ACCL__Product_Template__c.getRecordTypeInfosByName().get('Product').getRecordTypeId(); //'01258000000VEcCAAW';
    testProductTemplate.ACCL__Sales_Org__c = 'AR01';
    testProductTemplate.ACCL__Description_Language_1__c = 'Template Description';
    insert testProductTemplate;
    
    //Creating product records
    ACCL__Product__c testProduct1 = new ACCL__Product__c();
    testProduct1.Name = 'TestProduct1';
    testProduct1.ACCL__Product_Template__c = testProductTemplate.id;
    testProduct1.ACCL__Product_Code__c = 'Test1';
    testProduct1.ACCL__Product_Level__c = 'Category';
    testProduct1.ACCL__Category__c = 'Beverages';
    testProduct1.ACCL__Description_1_Language_1__c = 'product Description 1';
    testProduct1.ACCL__Fund_Valid_From__c = Date.newInstance(2016, 1, 1);
    testProduct1.ACCL__Fund_Valid_Thru__c = Date.newInstance(2099,12,31);
    insert testProduct1;
    
    ACCL__Product__c testProduct2 = new ACCL__Product__c();
    testProduct2.Name = 'TestProduct2';
    testProduct2.ACCL__Product_Template__c = testProductTemplate.id;
    testProduct2.ACCL__Product_Code__c = 'Test2';
    testProduct2.ACCL__Product_Level__c = 'Category';
    testProduct2.ACCL__Category__c = 'Beverages';
    testProduct2.ACCL__Description_1_Language_1__c = 'product Description 2';
    testProduct2.ACCL__Fund_Valid_From__c = Date.newInstance(2016, 1, 1);
    testProduct2.ACCL__Fund_Valid_Thru__c = Date.newInstance(2099,12,31);
    insert testProduct2;
    
    ACCL__Product__c testProduct3 = new ACCL__Product__c();
    testProduct3.Name = 'TestProduct3';
    testProduct3.ACCL__Product_Template__c = testProductTemplate.id;
    testProduct3.ACCL__Product_Code__c = 'Test3';
    testProduct3.ACCL__Product_Level__c = 'Variant';
    testProduct3.ACCL__Category__c = 'Chips';
    testProduct3.ACCL__Description_1_Language_1__c = 'product Description 3';
    testProduct3.ACCL__Fund_Valid_From__c = Date.newInstance(2016, 1, 1);
    testProduct3.ACCL__Fund_Valid_Thru__c = Date.newInstance(2099,12,31);
    insert testProduct3;
    
    //creating Fund Template Record
    ACCL__Fund_Template__c testFundTemplate1 = new ACCL__Fund_Template__c();
    testFundTemplate1.Name = 'FundTemplateForTest1';
    testFundTemplate1.ACCL__Active__c = True;
    testFundTemplate1.ACCL__Sales_Org__c = 'AR01';
    testFundTemplate1.ACCL__Description_Language_1__c = 'fund template description1';
    testFundTemplate1.ACCL__Anchor_Type__c = 'Customer Product';
    insert testFundTemplate1;
    
    //creating Fund Records
    ACCL__Fund__c testFund1 = new ACCL__Fund__c();
    testFund1.ACCL__Fund_Template__c = testFundTemplate1.id;
    testFund1.ACCL__Valid_From__c = Date.today();
    testFund1.ACCL__Valid_Thru__c = Date.today();
    testFund1.ACCL__Anchor_Account__c = testcustomer.id;
    testFund1.ACCL__Anchor_Product__c = testProduct1.id;
    testFund1.ACCL__Description_Language_1__c = 'Fund Description1';
    testFund1.ACCL__Status__c = 'Active';
    insert testFund1;
    
    ACCL__Fund__c testFund2 = new ACCL__Fund__c();
    testFund2.ACCL__Fund_Template__c = testFundTemplate1.id;
    testFund2.ACCL__Valid_From__c = Date.today();
    testFund2.ACCL__Valid_Thru__c = Date.today();
    testFund2.ACCL__Anchor_Account__c = testcustomer.id;
    testFund2.ACCL__Anchor_Product__c = testProduct2.id;
    testFund2.ACCL__Description_Language_1__c = 'Fund Description2';
    testFund2.ACCL__Status__c = 'Active';
    insert testFund2;
    
    ACCL__Fund__c testFund3 = new ACCL__Fund__c();
    testFund3.ACCL__Fund_Template__c = testFundTemplate1.id;
    testFund3.ACCL__Valid_From__c = Date.today();
    testFund3.ACCL__Valid_Thru__c = Date.today();
    testFund3.ACCL__Anchor_Account__c = testcustomer.id;
    testFund3.ACCL__Anchor_Product__c = testProduct3.id;
    testFund3.ACCL__Description_Language_1__c = 'Fund Description3';
    testFund3.ACCL__Status__c = 'Active';
    insert testFund3;
    
    //Creating Fund Transaction Template
    ACCL__Fund_Transaction_Template__c testTransactionTemplate1 = new ACCL__Fund_Transaction_Template__c();
    testTransactionTemplate1.Name = 'TransactionTemplateForTest1';
    testTransactionTemplate1.ACCL__Active__c = True;
    testTransactionTemplate1.ACCL__Sales_Org__c = 'AR01';
    testTransactionTemplate1.ACCL__Description_Language_1__c = 'Transaction Template Description 1';
    testTransactionTemplate1.ACCL__Transaction_Type__c = 'Transfer';
    testTransactionTemplate1.UL_Cross_Category_Transfer_Allowed__c = True;
    insert testTransactionTemplate1;
    
    Profile p = [SELECT Id FROM Profile WHERE Name = 'SoCo-Finance Admin'];
    user testuser = new User(Alias = 'standt', Email='standarduser123@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser123@testorg123.com');

    system.runAs(sysuser){
    insert testuser;
    }
    
    ACCL__Fund_Transaction_Template__c testTransactionTemplate2 = new ACCL__Fund_Transaction_Template__c();
    testTransactionTemplate2.Name = 'TransactionTemplateForTest2';
    testTransactionTemplate2.ACCL__Active__c = True;
    testTransactionTemplate2.ACCL__Sales_Org__c = 'AR01';
    testTransactionTemplate2.ACCL__Description_Language_1__c = 'Transaction Template Description 2';
    testTransactionTemplate2.ACCL__Transaction_Type__c = 'Transfer';
    testTransactionTemplate2.UL_Cross_Category_Transfer_Allowed__c = False;
    testTransactionTemplate2.OwnerId = testuser.id;
    insert testTransactionTemplate2;
    
    
   

    system.runAs(sysuser){
    
    //permission set assignment ACSF_FM to user
        PermissionSet ps = [SELECT Id FROM PermissionSet where Name = 'ACSF_FM'];   
        
        PermissionSetAssignment PermissionAssignment = new PermissionSetAssignment();
        PermissionAssignment.AssigneeId = testuser.id;
        PermissionAssignment.PermissionSetId = ps.id;
        insert PermissionAssignment;
        
    }
    
    }
    
    // testing trigger for Fund transaction creation
    @isTest
    private static void TransactionTriggerTest(){
    
    
    //Since criteria based sharing rule cannot be evaluated in test class, nees to run the class with a user having sys admin profile.
    //Ref - https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_bulk_sharing_understanding.htm
    User sysuser = [SELECT id FROM User where UserName='adminuser@tpmorg.com'];
    
    
    //User testUser = [Select Id,Name From User Where UserName='standarduser123@testorg123.com'] ;
    
    ACCL__Fund__c testFund2 = [Select Id,Name,ACCL__Sales_Org__c From ACCL__Fund__c Where ACCL__Description_Language_1__c = 'Fund Description2'] ;
    ACCL__Fund__c testFund1 = [Select Id,Name,ACCL__Sales_Org__c From ACCL__Fund__c Where ACCL__Description_Language_1__c = 'Fund Description1'] ;
    ACCL__Fund__c testFund3 = [Select Id,Name,ACCL__Sales_Org__c From ACCL__Fund__c Where ACCL__Description_Language_1__c = 'Fund Description3'] ;
    ACCL__Fund_Transaction_Template__c testTransactionTemplate1= [Select Id,Name,ACCL__Sales_Org__c From ACCL__Fund_Transaction_Template__c Where Name='TransactionTemplateForTest1'] ;
    ACCL__Fund_Transaction_Template__c testTransactionTemplate2= [Select Id,Name,ACCL__Sales_Org__c From ACCL__Fund_Transaction_Template__c Where Name='TransactionTemplateForTest2'] ;
                    system.runAs(sysuser){
                    ACCL__Fund_Transaction__c testTransaction1 = new ACCL__Fund_Transaction__c();
                    testTransaction1.ACCL__Fund_Transaction_Template__c = testTransactionTemplate1.id;
                    testTransaction1.ACCL__Amount__c = 100;
                    testTransaction1.ACCL__Source_Fund__c = testFund1.id;
                    testTransaction1.ACCL__Target_Fund__c = testFund2.id;
                    system.debug('trans temp so '+testTransactionTemplate1.ACCL__Sales_Org__c) ;
                    system.debug('fund2 so '+testFund2.ACCL__Sales_Org__c) ;
                    try{
                        insert testTransaction1;                    
                        //System.AssertEquals(Null, testTransaction1);
                    }
                    catch(Exception e){
                        system.debug(e);
                        Boolean expectedExceptionThrown =  e.getMessage().contains('For Cross Category Transfer transaction the product category in funds cannot be same') ? true : false;
                        System.AssertEquals(expectedExceptionThrown, true);
                    }
                     
               
                    ACCL__Fund_Transaction__c testTransaction2 = new ACCL__Fund_Transaction__c();
                    testTransaction2.ACCL__Fund_Transaction_Template__c = testTransactionTemplate2.id;
                    testTransaction2.ACCL__Amount__c = 100;
                    testTransaction2.ACCL__Source_Fund__c = testFund1.id;
                    testTransaction2.ACCL__Target_Fund__c = testFund3.id;
                    try{
                        insert testTransaction2;
                    }                    
                    catch(Exception e){
                        Boolean expectedExceptionThrown =  e.getMessage().contains('For Transfer transaction the product category in funds must be same') ? true : false;
                        System.AssertEquals(expectedExceptionThrown, true);
                    }
                    
                    }
                    }
                }