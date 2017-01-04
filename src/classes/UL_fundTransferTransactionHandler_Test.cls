@isTest(SeeAllData=false)
private class UL_fundTransferTransactionHandler_Test{

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
    testProduct1.ACCL__Fund_Valid_From__c = Date.newInstance(2017, 1, 1);
    testProduct1.ACCL__Fund_Valid_Thru__c = Date.newInstance(2099,12,31);
    insert testProduct1;
    
    ACCL__Product__c testProduct2 = new ACCL__Product__c();
    testProduct2.Name = 'TestProduct2';
    testProduct2.ACCL__Product_Template__c = testProductTemplate.id;
    testProduct2.ACCL__Product_Code__c = 'Test2';
    testProduct2.ACCL__Product_Level__c = 'Category';
    testProduct2.ACCL__Category__c = 'Chips';
    testProduct2.ACCL__Description_1_Language_1__c = 'product Description 2';
    testProduct2.ACCL__Fund_Valid_From__c = Date.newInstance(2017, 1, 1);
    testProduct2.ACCL__Fund_Valid_Thru__c = Date.newInstance(2099,12,31);
    insert testProduct2;

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
    testFund1.ACCL__Valid_From__c = Date.newInstance(2017, 1, 1);
    testFund1.ACCL__Valid_Thru__c = Date.newInstance(2017, 1, 31);
    testFund1.ACCL__Anchor_Account__c = testcustomer.id;
    testFund1.ACCL__Anchor_Product__c = testProduct1.id;
    testFund1.ACCL__Description_Language_1__c = 'Fund Description1';
    testFund1.ACCL__Status__c = 'Active';
    insert testFund1;
    
    ACCL__Fund__c testFund2 = new ACCL__Fund__c();
    testFund2.ACCL__Fund_Template__c = testFundTemplate1.id;
    testFund2.ACCL__Valid_From__c = Date.newInstance(2017, 1, 1);
    testFund2.ACCL__Valid_Thru__c = Date.newInstance(2017, 1, 31);
    testFund2.ACCL__Anchor_Account__c = testcustomer.id;
    testFund2.ACCL__Anchor_Product__c = testProduct2.id;
    testFund2.ACCL__Description_Language_1__c = 'Fund Description2';
    testFund2.ACCL__Status__c = 'Active';
    insert testFund2;
    
  //creating Transaction Template record
    ACCL__Fund_Transaction_Template__c testTransactionTemplate1 = new ACCL__Fund_Transaction_Template__c();
    testTransactionTemplate1.Name = 'TransactionTemplateForTest1';
    testTransactionTemplate1.ACCL__Active__c = True;
    testTransactionTemplate1.ACCL__Sales_Org__c = 'AR01';
    testTransactionTemplate1.ACCL__Description_Language_1__c = 'Transaction Template Description 1';
    testTransactionTemplate1.ACCL__Transaction_Type__c = 'Initial';
    testTransactionTemplate1.UL_Cross_Category_Transfer_Allowed__c = False;
    testTransactionTemplate1.RecordTypeId = Schema.SObjectType.ACCL__Fund_Transaction_Template__c.getRecordTypeInfosByName().get('Fund Transaction').getRecordTypeId(); 
    insert testTransactionTemplate1;
    
    ACCL__Fund_Transaction_Template__c testTransactionTemplate2 = new ACCL__Fund_Transaction_Template__c();
    testTransactionTemplate2.Name = 'CrossCategoryTransactionTemplateForTest1';
    testTransactionTemplate2.ACCL__Active__c = True;
    testTransactionTemplate2.ACCL__Sales_Org__c = 'AR01';
    testTransactionTemplate2.ACCL__Description_Language_1__c = 'Cross Category Transaction Template Description 2';
    testTransactionTemplate2.ACCL__Transaction_Type__c = 'Transfer';
    testTransactionTemplate2.UL_Cross_Category_Transfer_Allowed__c = True;
    testTransactionTemplate2.RecordTypeId = Schema.SObjectType.ACCL__Fund_Transaction_Template__c.getRecordTypeInfosByName().get('Fund Transaction').getRecordTypeId(); 
    insert testTransactionTemplate2;
    
  //creating Fund transaction for Initial Deposit to fund
    ACCL__Fund_Transaction__c testTransaction1 = new ACCL__Fund_Transaction__c();
    testTransaction1.ACCL__Fund_Transaction_Template__c = testTransactionTemplate1.id;
    testTransaction1.ACCL__Amount__c = 1000;
    testTransaction1.ACCL__Target_Fund__c = testFund1.id;
    testTransaction1.UL_Status__c = 'Approved';
    testTransaction1.UL_Transaction_Description__c = 'Initial Deposit for Fund 1';
    insert testTransaction1;
    
    ACCL__Fund_Transaction__c testTransaction2 = new ACCL__Fund_Transaction__c();
    testTransaction2.ACCL__Fund_Transaction_Template__c = testTransactionTemplate1.id;
    testTransaction2.ACCL__Amount__c = 1000;
    testTransaction2.ACCL__Target_Fund__c = testFund2.id;
    testTransaction2.UL_Status__c = 'Approved';
    testTransaction2.UL_Transaction_Description__c = 'Initial Deposit for Fund 2';
    insert testTransaction2;
    
  //creating Fund transaction rows for the initial Deposit to fund done in the above step
    ACCL__Fund_Transaction_Row__c testtransactionRow1 = new ACCL__Fund_Transaction_Row__c();
    testtransactionRow1.ACCL__Amount__c = testTransaction1.ACCL__Amount__c;
    testtransactionRow1.ACCL__Target_Fund__c = testTransaction1.ACCL__Target_Fund__c;
    testtransactionRow1.ACCL__Fund_Transaction__c = testTransaction1.id; 
    insert testtransactionRow1;
    
    testFund1.UL_Available_to_Spend__c = 1000;
    update testFund1;
    
    ACCL__Fund_Transaction_Row__c testtransactionRow2 = new ACCL__Fund_Transaction_Row__c();
    testtransactionRow2.ACCL__Amount__c = testTransaction2.ACCL__Amount__c;
    testtransactionRow2.ACCL__Target_Fund__c = testTransaction2.ACCL__Target_Fund__c;
    testtransactionRow2.ACCL__Fund_Transaction__c = testTransaction2.id;
    insert testtransactionRow2;
    
    testFund2.UL_Available_to_Spend__c = 1000;
    update testFund2;

   //Creating Fund transaction for Cross category    
    ACCL__Fund_Transaction__c testTransaction3 = new ACCL__Fund_Transaction__c();
    testTransaction3.ACCL__Fund_Transaction_Template__c = testTransactionTemplate2.id;
    testTransaction3.ACCL__Amount__c = 100;
    testTransaction3.ACCL__Target_Fund__c = testFund1.id;
    testTransaction3.ACCL__Source_Fund__c = testFund2.id;
    testTransaction3.UL_Status__c = 'Sent/Pending Approval';
    testTransaction3.UL_Transaction_Description__c = 'test trigger';
    insert testTransaction3;
        
}

   // testing trigger on approval of a Cross Category Fund transaction 
    @isTest
    
    private static void ApprovalTriggerTest(){
    
    ACCL__Fund__c beforeTestFund1 = [Select id, name, ACCL__Anchor_Account__c, ACCL__Anchor_Product__c, ACCL__Description_Language_1__c,
                           ACCL__Status__c, ACCL__Amount__c From ACCL__Fund__c 
                           where ACCL__Description_Language_1__c='Fund Description1'];
                           
    ACCL__Fund__c beforeTestFund2 = [Select id, name, ACCL__Anchor_Account__c, ACCL__Anchor_Product__c, ACCL__Description_Language_1__c,
                           ACCL__Status__c, ACCL__Amount__c From ACCL__Fund__c 
                           where ACCL__Description_Language_1__c='Fund Description2'];
        
    ACCL__Fund_Transaction__c testTransaction = [Select Name, id, ACCL__Fund_Transaction_Template__c, ACCL__Amount__c, 
                                                 ACCL__Target_Fund__c, ACCL__Source_Fund__c, UL_Status__c, UL_Transaction_Description__c
                                                 From ACCL__Fund_Transaction__c Where UL_Transaction_Description__c = 'test trigger'];
                                                 
    testTransaction.UL_Status__c = 'Approved';
    update testTransaction;
    
    ACCL__Fund__c afterTestFund1 = [Select id, name, ACCL__Anchor_Account__c, ACCL__Anchor_Product__c, ACCL__Description_Language_1__c,
                           ACCL__Status__c, ACCL__Amount__c From ACCL__Fund__c 
                           where ACCL__Description_Language_1__c='Fund Description1'];
                           
    ACCL__Fund__c afterTestFund2 = [Select id, name, ACCL__Anchor_Account__c, ACCL__Anchor_Product__c, ACCL__Description_Language_1__c,
                           ACCL__Status__c, ACCL__Amount__c From ACCL__Fund__c 
                           where ACCL__Description_Language_1__c='Fund Description2'];
    
    System.AssertEquals(afterTestFund1.ACCL__Amount__c, beforeTestFund1.ACCL__Amount__c+testTransaction.ACCL__Amount__c);
    System.AssertEquals(afterTestFund2.ACCL__Amount__c, beforeTestFund2.ACCL__Amount__c-testTransaction.ACCL__Amount__c);
    }

}