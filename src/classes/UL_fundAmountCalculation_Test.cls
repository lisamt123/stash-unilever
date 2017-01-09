@isTest(SeeAllData=false)
private class UL_fundAmountCalculation_Test{

//static user sysuser = new User(Id=Userinfo.getUserId());

@testSetup

private static void CreateTestData(){

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
    
  //creating Fund Template Record
    ACCL__Fund_Template__c testFundTemplate1 = new ACCL__Fund_Template__c();
    testFundTemplate1.Name = 'FundTemplateForTest1';
    testFundTemplate1.ACCL__Active__c = True;
    testFundTemplate1.ACCL__Sales_Org__c = 'AR01';
    testFundTemplate1.ACCL__Description_Language_1__c = 'fund template description1';
    testFundTemplate1.ACCL__Anchor_Type__c = 'Customer';
    insert testFundTemplate1;
    
  //creating Fund Records
    ACCL__Fund__c testFund1 = new ACCL__Fund__c();
    testFund1.ACCL__Fund_Template__c = testFundTemplate1.id;
    testFund1.ACCL__Valid_From__c = Date.today();
    testFund1.ACCL__Valid_Thru__c = Date.today();
    testFund1.ACCL__Anchor_Account__c = testcustomer.id;
    testFund1.ACCL__Description_Language_1__c = 'Fund Description1';
    testFund1.ACCL__Status__c = 'Active';
    insert testFund1;
    
    ACCL__Fund__c testFund2 = new ACCL__Fund__c();
    testFund2.ACCL__Fund_Template__c = testFundTemplate1.id;
    testFund2.ACCL__Valid_From__c = Date.today();
    testFund2.ACCL__Valid_Thru__c = Date.today();
    testFund2.ACCL__Anchor_Account__c = testcustomer.id;
    testFund2.ACCL__Description_Language_1__c = 'Fund Description2';
    testFund2.ACCL__Status__c = 'Active';
    insert testFund2;
    
  //Creating Fund Transaction Template
    ACCL__Fund_Transaction_Template__c testTransactionTemplate1 = new ACCL__Fund_Transaction_Template__c();
    testTransactionTemplate1.Name = 'TransactionTemplateForTest1';
    testTransactionTemplate1.ACCL__Active__c = True;
    testTransactionTemplate1.ACCL__Sales_Org__c = 'AR01';
    testTransactionTemplate1.ACCL__Description_Language_1__c = 'Transaction Template Description 1';
    testTransactionTemplate1.ACCL__Transaction_Type__c = 'Initial';
    testTransactionTemplate1.UL_Cross_Category_Transfer_Allowed__c = True;
    testTransactionTemplate1.RecordTypeId = Schema.SObjectType.ACCL__Fund_Transaction_Template__c.getRecordTypeInfosByName().get('Fund Transaction').getRecordTypeId(); 
    insert testTransactionTemplate1;
    
    ACCL__Fund_Transaction_Template__c testTransactionTemplate2 = new ACCL__Fund_Transaction_Template__c();
    testTransactionTemplate2.Name = 'TransactionTemplateForTest2';
    testTransactionTemplate2.ACCL__Active__c = True;
    testTransactionTemplate2.ACCL__Sales_Org__c = 'AR01';
    testTransactionTemplate2.ACCL__Description_Language_1__c = 'Transaction Template Description 2';
    testTransactionTemplate2.ACCL__Transaction_Type__c = 'Adjustment';
    testTransactionTemplate2.UL_Cross_Category_Transfer_Allowed__c = False;
    testTransactionTemplate2.RecordTypeId = Schema.SObjectType.ACCL__Fund_Transaction_Template__c.getRecordTypeInfosByName().get('Fund Transaction').getRecordTypeId(); 
    insert testTransactionTemplate2;
    
    ACCL__Fund_Transaction_Template__c testTransactionTemplate3 = new ACCL__Fund_Transaction_Template__c();
    testTransactionTemplate3.Name = 'TransactionTemplateForTest3';
    testTransactionTemplate3.ACCL__Active__c = True;
    testTransactionTemplate3.ACCL__Sales_Org__c = 'AR01';
    testTransactionTemplate3.ACCL__Description_Language_1__c = 'Transaction Template Description 3';
    testTransactionTemplate3.ACCL__Transaction_Type__c = 'Transfer';
    testTransactionTemplate3.UL_Cross_Category_Transfer_Allowed__c = False;
    testTransactionTemplate3.RecordTypeId = Schema.SObjectType.ACCL__Fund_Transaction_Template__c.getRecordTypeInfosByName().get('Fund Transaction').getRecordTypeId(); 
    insert testTransactionTemplate3;
    
  //creating user
   Profile p = [SELECT Id FROM Profile WHERE Name = 'SoCo-Finance Admin'];
   system.debug('profile  '+ p) ;
    user testuser = new User(Alias = 'standt', Email='standarduser123@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser123@testorg123.com');

    system.runAs(sysuser){
    insert testuser;
    }

   //permission set assignment ACSF_FM to user
        PermissionSet ps = [SELECT Id FROM PermissionSet where Name = 'ACSF_FM'];   
        
        PermissionSetAssignment PermissionAssignment = new PermissionSetAssignment();
        PermissionAssignment.AssigneeId = testuser.id;
        PermissionAssignment.PermissionSetId = ps.id;
        
        system.runAs(sysuser){
        insert PermissionAssignment;
        }
}


// testing trigger for Fund transaction creation
    @isTest
    private static void TransactionTriggerTest(){
    
    //User testUser = [Select Id,Name From User Where UserName='standarduser123@testorg123.com'] ;
    
     User sysuser = [SELECT id FROM User where UserName='adminuser@tpmorg.com'];
    ACCL__Fund__c testFund2 = [Select Id,Name,ACCL__Sales_Org__c From ACCL__Fund__c Where ACCL__Description_Language_1__c = 'Fund Description2'] ;
    ACCL__Fund__c testFund1 = [Select Id,Name,ACCL__Sales_Org__c From ACCL__Fund__c Where ACCL__Description_Language_1__c = 'Fund Description1'] ;
    ACCL__Fund_Transaction_Template__c testTransactionTemplate1= [Select Id,Name,ACCL__Sales_Org__c, RecordTypeId  From ACCL__Fund_Transaction_Template__c Where Name='TransactionTemplateForTest1'];
    ACCL__Fund_Transaction_Template__c testTransactionTemplate2= [Select Id,Name,ACCL__Sales_Org__c, RecordTypeId  From ACCL__Fund_Transaction_Template__c Where Name='TransactionTemplateForTest2'];
    ACCL__Fund_Transaction_Template__c testTransactionTemplate3= [Select Id,Name,ACCL__Sales_Org__c, RecordTypeId  From ACCL__Fund_Transaction_Template__c Where Name='TransactionTemplateForTest3'];
    system.runAs(sysuser){
    
    
    ACCL__Fund_Transaction__c testTransaction1 = new ACCL__Fund_Transaction__c();
    testTransaction1.ACCL__Fund_Transaction_Template__c = testTransactionTemplate1.id;
    testTransaction1.ACCL__Amount__c = 100;
    testTransaction1.ACCL__Target_Fund__c = testFund1.id;
    insert testTransaction1;
    
    ACCL__Fund_Transaction_Row__c transRow1 = new ACCL__Fund_Transaction_Row__c();
    transRow1.ACCL__Amount__c = testTransaction1.ACCL__Amount__c;
    transRow1.ACCL__Target_Fund__c = testTransaction1.ACCL__Target_Fund__c;
    transRow1.ACCL__Fund_Transaction__c = testTransaction1.id;
    insert transRow1;
    
    ACCL__Fund__c FundVariable1 =[select id, Name, ACCL__Amount__c, UL_Available_to_Spend__c from ACCL__Fund__c where ACCL__Description_Language_1__c = 'Fund Description1'];
    System.AssertEquals(FundVariable1.UL_Available_to_Spend__c, testTransaction1.ACCL__Amount__c);
    
    ACCL__Fund_Transaction__c testTransaction2 = new ACCL__Fund_Transaction__c();
    testTransaction2.ACCL__Fund_Transaction_Template__c = testTransactionTemplate2.id;
    testTransaction2.ACCL__Amount__c = 20;
    testTransaction2.ACCL__Target_Fund__c = testFund1.id;
    insert testTransaction2;
    
    ACCL__Fund_Transaction_Row__c transRow2 = new ACCL__Fund_Transaction_Row__c();
    transRow2.ACCL__Amount__c = (-1)*testTransaction2.ACCL__Amount__c;
    //transRow1.Source_Fund__c = sourceFund;
    transRow2.ACCL__Target_Fund__c = testTransaction2.ACCL__Target_Fund__c;
    transRow2.ACCL__Fund_Transaction__c = testTransaction2.id;
    insert transRow2;
    
    ACCL__Fund__c FundVariable2 =[select id, Name, ACCL__Amount__c, UL_Available_to_Spend__c from ACCL__Fund__c where ACCL__Description_Language_1__c = 'Fund Description1'];
    System.AssertEquals(FundVariable2.UL_Available_to_Spend__c, FundVariable2.ACCL__Amount__c);
    
   /* ACCL__Fund_Transaction__c testTransaction3 = new ACCL__Fund_Transaction__c();
    testTransaction3.ACCL__Fund_Transaction_Template__c = testTransactionTemplate3.id;
    testTransaction3.ACCL__Amount__c = 30;
    testTransaction3.ACCL__Source_Fund__c = testFund1.id;
    testTransaction3.ACCL__Target_Fund__c = testFund2.id;
    insert testTransaction3;
    
    ACCL__Fund_Transaction_Row__c transRow3 = new ACCL__Fund_Transaction_Row__c();
    transRow3.ACCL__Amount__c = testTransaction3.ACCL__Amount__c;
    transRow3.ACCL__Source_Fund__c = testTransaction3.ACCL__Source_Fund__c;
    transRow3.ACCL__Target_Fund__c = testTransaction3.ACCL__Target_Fund__c;
    transRow3.ACCL__Fund_Transaction__c = testTransaction3.id;
    insert transRow3;
    
    ACCL__Fund_Transaction_Row__c transRow4 = new ACCL__Fund_Transaction_Row__c();
    transRow4.ACCL__Amount__c = (-1)*testTransaction3.ACCL__Amount__c;
    transRow4.ACCL__Source_Fund__c = testTransaction3.ACCL__Target_Fund__c;
    transRow4.ACCL__Target_Fund__c = testTransaction3.ACCL__Source_Fund__c;
    transRow4.ACCL__Fund_Transaction__c = testTransaction3.id;
    insert transRow4;
    
    ACCL__Fund__c FundVariable3 =[select id, Name, ACCL__Amount__c, UL_Available_to_Spend__c from ACCL__Fund__c where ACCL__Description_Language_1__c = 'Fund Description1'];
    ACCL__Fund__c FundVariable4 =[select id, Name, ACCL__Amount__c, UL_Available_to_Spend__c from ACCL__Fund__c where ACCL__Description_Language_1__c = 'Fund Description2'];
    System.AssertEquals(FundVariable3.UL_Available_to_Spend__c, FundVariable3.ACCL__Amount__c);
    System.AssertEquals(FundVariable4.UL_Available_to_Spend__c, FundVariable4.ACCL__Amount__c); */
    
    }
    }
}