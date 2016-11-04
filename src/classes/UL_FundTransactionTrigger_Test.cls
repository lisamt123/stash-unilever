@isTest(SeeAllData=false)
private class UL_FundTransactionTrigger_Test{
    static user sysuser = new User(Id=Userinfo.getUserId());
    //private static ACSFUL001__Account_Template__c TestCustomerTemplate1;
    //private static Account testcustomer;
    //private static ACSFUL001__Account_Extension__c testCustomerExtension;
    //private static ACSFUL001__Product_Template__c testProductTemplate;
    //private static ACSFUL001__Product__c testProduct1;
    //private static ACSFUL001__Product__c testProduct2;
    //private static ACSFUL001__Product__c testProduct3;
    //private static ACSFUL001__Fund_Template__c testFundTemplate1;
    //private static ACSFUL001__Fund__c testFund1 = new ACSFUL001__Fund__c();
    //private static ACSFUL001__Fund__c testFund2 = new ACSFUL001__Fund__c();
    //private static ACSFUL001__Fund__c testFund3 = new ACSFUL001__Fund__c();
    //private static ACSFUL001__Transaction_Template__c testTransactionTemplate1 = new ACSFUL001__Transaction_Template__c(); 
    //private static ACSFUL001__Transaction_Template__c testTransactionTemplate2 = new ACSFUL001__Transaction_Template__c();
    //user testuser = new user();
    //private static user testuser2;
    //private static PermissionSetAssignment PermissionAssignment;
    
    
    @testSetup
    private static void CreateTestData(){
        
    //
    Integer currentYear = System.Today().year();
    
    //creating customer template record
    ACSFUL001__Account_Template__c TestCustomerTemplate1 = new ACSFUL001__Account_Template__c();
    TestCustomerTemplate1.name = 'CustomerTemplateForTest123';
    TestCustomerTemplate1.ACSFUL001__Initial_Roles__c = 'customer';
    TestCustomerTemplate1.ACSFUL001__Active__c = True;
    TestCustomerTemplate1.RecordTypeId = Schema.SObjectType.ACSFUL001__Account_Template__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); //[SELECT Id FROM RecordType WHERE Name = 'Customer']
    TestCustomerTemplate1.ACSFUL001__Sales_Org__c = 'AR01';
    TestCustomerTemplate1.ACSFUL001__Description_Language_1__c = 'Template description1';
    insert TestCustomerTemplate1;
    
    //ceating customer record
    Account testcustomer = new Account();
    testcustomer.name = 'TestCustomer';
    testcustomer.ACSFUL001__Account_Number__c = '123';
    testcustomer.ACSFUL001__Name_2__c = 'test123';
    testcustomer.ACSFUL001__Account_Template__c = TestCustomerTemplate1.id;
    system.runAs(sysuser){
    insert testcustomer;
    }
    //creating customer extension reocrd
    ACSFUL001__Account_Extension__c testCustomerExtension = new ACSFUL001__Account_Extension__c();
    testCustomerExtension.ACSFUL001__Account__c = testcustomer.id;
    testCustomerExtension.ACSFUL001__Fund_Role_Valid_From__c = Date.newInstance(2016, 1, 1);
    testCustomerExtension.ACSFUL001__Fund_Role_Valid_Thru__c = Date.newInstance(2099,12,31);
    insert testCustomerExtension;
    
    //creating product template record
    ACSFUL001__Product_Template__c testProductTemplate = new ACSFUL001__Product_Template__c();
    testProductTemplate.Name = 'ProductTemplateForTest';
    testProductTemplate.ACSFUL001__Active__c = True;
    testProductTemplate.RecordTypeId = Schema.SObjectType.ACSFUL001__Product_Template__c.getRecordTypeInfosByName().get('Product').getRecordTypeId(); //'01258000000VEcCAAW';
    testProductTemplate.ACSFUL001__Sales_Org__c = 'AR01';
    testProductTemplate.ACSFUL001__Description_Language_1__c = 'Template Description';
    insert testProductTemplate;
    
    //Creating product records
    ACSFUL001__Product__c testProduct1 = new ACSFUL001__Product__c();
    testProduct1.Name = 'TestProduct1';
    testProduct1.ACSFUL001__Product_Template__c = testProductTemplate.id;
    testProduct1.ACSFUL001__Product_Code__c = 'Test1';
    testProduct1.ACSFUL001__Product_Level__c = 'Category';
    testProduct1.ACSFUL001__Description_1_Language_1__c = 'product Description 1';
    testProduct1.ACSFUL001__Fund_Role_Valid_From__c = Date.newInstance(2016, 1, 1);
    testProduct1.ACSFUL001__Fund_Role_Valid_Thru__c = Date.newInstance(2099,12,31);
    insert testProduct1;
    
    ACSFUL001__Product__c testProduct2 = new ACSFUL001__Product__c();
    testProduct2.Name = 'TestProduct2';
    testProduct2.ACSFUL001__Product_Template__c = testProductTemplate.id;
    testProduct2.ACSFUL001__Product_Code__c = 'Test2';
    testProduct2.ACSFUL001__Product_Level__c = 'Category';
    testProduct2.ACSFUL001__Description_1_Language_1__c = 'product Description 2';
    testProduct2.ACSFUL001__Fund_Role_Valid_From__c = Date.newInstance(2016, 1, 1);
    testProduct2.ACSFUL001__Fund_Role_Valid_Thru__c = Date.newInstance(2099,12,31);
    insert testProduct2;
    
    ACSFUL001__Product__c testProduct3 = new ACSFUL001__Product__c();
    testProduct3.Name = 'TestProduct3';
    testProduct3.ACSFUL001__Product_Template__c = testProductTemplate.id;
    testProduct3.ACSFUL001__Product_Code__c = 'Test3';
    testProduct3.ACSFUL001__Product_Level__c = 'Variant';
    testProduct3.ACSFUL001__Description_1_Language_1__c = 'product Description 3';
    testProduct3.ACSFUL001__Fund_Role_Valid_From__c = Date.newInstance(2016, 1, 1);
    testProduct3.ACSFUL001__Fund_Role_Valid_Thru__c = Date.newInstance(2099,12,31);
    insert testProduct3;
    
    //creating Fund Template Record
    ACSFUL001__Fund_Template__c testFundTemplate1 = new ACSFUL001__Fund_Template__c();
    testFundTemplate1.Name = 'FundTemplateForTest1';
    testFundTemplate1.ACSFUL001__Active__c = True;
    testFundTemplate1.ACSFUL001__Sales_Org__c = 'AR01';
    testFundTemplate1.ACSFUL001__Description_Language_1__c = 'fund template description1';
    testFundTemplate1.ACSFUL001__Anchor_Type__c = 'Customer Product';
    insert testFundTemplate1;
    
    //creating Fund Records
    ACSFUL001__Fund__c testFund1 = new ACSFUL001__Fund__c();
    testFund1.ACSFUL001__Fund_Template__c = testFundTemplate1.id;
    testFund1.ACSFUL001__Valid_From__c = Date.today();
    testFund1.ACSFUL001__Valid_Thru__c = Date.today();
    testFund1.ACSFUL001__Anchor_Account__c = testcustomer.id;
    testFund1.ACSFUL001__Anchor_Product__c = testProduct1.id;
    testFund1.ACSFUL001__Description_Language_1__c = 'Fund Description1';
    testFund1.ACSFUL001__Status__c = 'Active';
    insert testFund1;
    
    ACSFUL001__Fund__c testFund2 = new ACSFUL001__Fund__c();
    testFund2.ACSFUL001__Fund_Template__c = testFundTemplate1.id;
    testFund2.ACSFUL001__Valid_From__c = Date.today();
    testFund2.ACSFUL001__Valid_Thru__c = Date.today();
    testFund2.ACSFUL001__Anchor_Account__c = testcustomer.id;
    testFund2.ACSFUL001__Anchor_Product__c = testProduct2.id;
    testFund2.ACSFUL001__Description_Language_1__c = 'Fund Description2';
    testFund2.ACSFUL001__Status__c = 'Active';
    insert testFund2;
    
    ACSFUL001__Fund__c testFund3 = new ACSFUL001__Fund__c();
    testFund3.ACSFUL001__Fund_Template__c = testFundTemplate1.id;
    testFund3.ACSFUL001__Valid_From__c = Date.today();
    testFund3.ACSFUL001__Valid_Thru__c = Date.today();
    testFund3.ACSFUL001__Anchor_Account__c = testcustomer.id;
    testFund3.ACSFUL001__Anchor_Product__c = testProduct3.id;
    testFund3.ACSFUL001__Description_Language_1__c = 'Fund Description3';
    testFund3.ACSFUL001__Status__c = 'Active';
    insert testFund3;
    
    //Creating Fund Transaction Template
    ACSFUL001__Transaction_Template__c testTransactionTemplate1 = new ACSFUL001__Transaction_Template__c();
    testTransactionTemplate1.Name = 'TransactionTemplateForTest1';
    testTransactionTemplate1.ACSFUL001__Active__c = True;
    testTransactionTemplate1.ACSFUL001__Sales_Org__c = 'AR01';
    testTransactionTemplate1.ACSFUL001__Description_Language_1__c = 'Transaction Template Description 1';
    testTransactionTemplate1.ACSFUL001__Transaction_Type__c = 'Transfer';
    testTransactionTemplate1.UL_Cross_Category_Transfer_Allowed__c = True;
    insert testTransactionTemplate1;
    
    ACSFUL001__Transaction_Template__c testTransactionTemplate2 = new ACSFUL001__Transaction_Template__c();
    testTransactionTemplate2.Name = 'TransactionTemplateForTest2';
    testTransactionTemplate2.ACSFUL001__Active__c = True;
    testTransactionTemplate2.ACSFUL001__Sales_Org__c = 'AR01';
    testTransactionTemplate2.ACSFUL001__Description_Language_1__c = 'Transaction Template Description 2';
    testTransactionTemplate2.ACSFUL001__Transaction_Type__c = 'Transfer';
    testTransactionTemplate2.UL_Cross_Category_Transfer_Allowed__c = False;
    insert testTransactionTemplate2;
    
    //creating user
    /*Profile p = [SELECT Id FROM Profile WHERE Name = 'SoCo-Finance Admin'];
    UserRole R = [SELECT Id FROM UserRole Where Name = 'COO'];
    //user testuser = new user();
    testuser.firstname = 'User1';
    testuser.lastName = 'Test1';
    testuser.email = 'User1.Test1@testorg.com';
    testuser.Username = 'User1.Test1@testorg1.com';
    testuser.EmailEncodingKey = 'ISO-8859-1';
    testuser.Alias = 'utest';
    testuser.CommunityNickname = 'User1.Test1';
    testuser.TimeZoneSidKey = 'America/Los_Angeles';
    testuser.LocaleSidKey = 'en_US';
    testuser.LanguageLocaleKey = 'en_US';
    testuser.ProfileId = p.id;
    testuser.UserRoleid = R.id;
    system.runAs(sysuser){
    insert testuser;
    }*/
   
   Profile p = [SELECT Id FROM Profile WHERE Name = 'SoCo-Finance Admin'];
   system.debug('profile  '+ p) ;
    user testuser = new User(Alias = 'standt', Email='standarduser123@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser123@testorg123.com');

system.runAs(sysuser){
    insert testuser;
    }

    //creating sys admin user
    /*Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    
    user testuser2 = new user();
    testuser2.firstname = 'User2';
    testuser2.lastName = 'Test2';
    testuser2.email = 'User2.Test1@testorg.com';
    testuser2.Username = 'User2.Test1@testorg1.com';
    testuser2.EmailEncodingKey = 'ISO-8859-1';
    testuser2.Alias = 'utest';
    testuser2.CommunityNickname = 'User2.Test2';
    testuser2.TimeZoneSidKey = 'America/Los_Angeles';
    testuser2.LocaleSidKey = 'en_US';
    testuser2.LanguageLocaleKey = 'en_US';
    testuser2.ProfileId = p1.id;  
    insert testuser2;*/
    
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
    //CreateTestData() ;
    
    User testUser = [Select Id,Name From User Where UserName='standarduser123@testorg123.com'] ;
    system.debug('test user '+testUser);
    ACSFUL001__Fund__c testFund2 = [Select Id,Name,ACSFUL001__Sales_Org__c From ACSFUL001__Fund__c Where ACSFUL001__Description_Language_1__c = 'Fund Description2'] ;
    ACSFUL001__Fund__c testFund1 = [Select Id,Name,ACSFUL001__Sales_Org__c From ACSFUL001__Fund__c Where ACSFUL001__Description_Language_1__c = 'Fund Description1'] ;
    ACSFUL001__Fund__c testFund3 = [Select Id,Name,ACSFUL001__Sales_Org__c From ACSFUL001__Fund__c Where ACSFUL001__Description_Language_1__c = 'Fund Description3'] ;
ACSFUL001__Transaction_Template__c testTransactionTemplate1= [Select Id,Name,ACSFUL001__Sales_Org__c From ACSFUL001__Transaction_Template__c Where Name='TransactionTemplateForTest1'] ;
ACSFUL001__Transaction_Template__c testTransactionTemplate2= [Select Id,Name,ACSFUL001__Sales_Org__c From ACSFUL001__Transaction_Template__c Where Name='TransactionTemplateForTest2'] ;
                    system.runAs(testuser){
                    ACSFUL001__Fund_Transaction__c testTransaction1 = new ACSFUL001__Fund_Transaction__c();
                    testTransaction1.ACSFUL001__Transaction_Template__c = testTransactionTemplate1.id;
                    testTransaction1.ACSFUL001__Amount__c = 100;
                    testTransaction1.ACSFUL001__Source_Fund__c = testFund1.id;
                    testTransaction1.ACSFUL001__Target_Fund__c = testFund2.id;
                    system.debug('trans temp so '+testTransactionTemplate1.ACSFUL001__Sales_Org__c) ;
                    system.debug('fund2 so '+testFund2.ACSFUL001__Sales_Org__c) ;
                    try{
                        insert testTransaction1;                    
                        //System.AssertEquals(Null, testTransaction1);
                    }
                    catch(Exception e){
                        Boolean expectedExceptionThrown =  e.getMessage().contains('For Cross Category Transfer transaction the product category in funds cannot be same') ? true : false;
                        System.AssertEquals(expectedExceptionThrown, true);
                    }
                     
               
                    ACSFUL001__Fund_Transaction__c testTransaction2 = new ACSFUL001__Fund_Transaction__c();
                    testTransaction2.ACSFUL001__Transaction_Template__c = testTransactionTemplate2.id;
                    testTransaction2.ACSFUL001__Amount__c = 100;
                    testTransaction2.ACSFUL001__Source_Fund__c = testFund1.id;
                    testTransaction2.ACSFUL001__Target_Fund__c = testFund3.id;
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