@isTest(SeeAllData=false)
private class UL_FundAmountUpdateHandler_Test{

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
    
  //creating Transaction Template record
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
    testTransactionTemplate2.RecordTypeId = Schema.SObjectType.ACCL__Fund_Transaction_Template__c.getRecordTypeInfosByName().get('Promotion Transaction').getRecordTypeId(); 
    insert testTransactionTemplate2;
    
  //creating Fund transaction for Initial Deposit to fund
    ACCL__Fund_Transaction__c testTransaction1 = new ACCL__Fund_Transaction__c();
    testTransaction1.ACCL__Fund_Transaction_Template__c = testTransactionTemplate1.id;
    testTransaction1.ACCL__Amount__c = 1000;
    testTransaction1.ACCL__Target_Fund__c = testFund1.id;
    insert testTransaction1;
    
  //creating Fund transaction rows for the initial Deposit to fund done in the above step
    ACCL__Fund_Transaction_Row__c testtransactionRow1 = new ACCL__Fund_Transaction_Row__c();
    testtransactionRow1.ACCL__Amount__c = testTransaction1.ACCL__Amount__c;
    //transRow1.Source_Fund__c = sourceFund;
    testtransactionRow1.ACCL__Target_Fund__c = testTransaction1.ACCL__Target_Fund__c;
    testtransactionRow1.ACCL__Fund_Transaction__c = testTransaction1.id;
    insert testtransactionRow1;
    
    testFund1.UL_Available_to_Spend__c = 1000;
    update testTransaction1;
    
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
    
  //Creating Tactic Fund Record
    ACCL__Tactic_Fund__c testTacticFund = new ACCL__Tactic_Fund__c();
    testTacticFund.ACCL__Fund__c=testFund1.id;
    testTacticFund.ACCL__Tactic__c=testTactic.id;
    insert testTacticFund;
        
}

// testing trigger for Fund transaction creation
@isTest
private static void FundAmountUpdateTest(){

    User sysuser = [SELECT id FROM User where UserName='adminuser@tpmorg.com'];
    ACCL__Promotion__c promotionRecord =[Select id, name, ACCL__Anchor_Account__c, ACCL__Phase__c from ACCL__Promotion__c where ACCL__Slogan_Language_1__c='Promotion Test'];
    ACCL__Tactic__c tacticRecord =[select id, name, ACCL__Amount__c, UL_Promotion_Phase__c, ACCL__Promotion__c from ACCL__Tactic__c where ACCL__Promotion__c=:promotionRecord.id];
    ACCL__Fund__c fundRecord =[Select Id, Name, ACCL__Sales_Org__c, ACCL__Amount__c, UL_Available_to_Spend__c, UL_Uncommitted__c, UL_Committed__c From ACCL__Fund__c Where ACCL__Description_Language_1__c = 'Fund Description1'];
    ACCL__Fund_Transaction_Template__c transactionTemplateRecord =[select id, name from ACCL__Fund_Transaction_Template__c where ACCL__Description_Language_1__c = 'Transaction Template Description 2'];
    ACCL__Tactic_Fund__c tacticFundRecord =[Select id, ACCL__Fund__c, ACCL__Tactic__c from ACCL__Tactic_Fund__c where ACCL__Tactic__c=:tacticRecord.id];

    system.runAs(sysuser){
       
    promotionRecord.ACCL__Phase__c = 'ForApproval';
    update promotionRecord;

    //tacticRecord.UL_Promotion_Phase__c = 'ForApproval';
    //update tacticRecord;

    ACCL__Fund__c fundRecord2 =[Select Id, Name, ACCL__Sales_Org__c, ACCL__Amount__c, UL_Available_to_Spend__c, UL_Uncommitted__c, UL_Committed__c From ACCL__Fund__c Where ACCL__Description_Language_1__c = 'Fund Description1'];

    System.AssertEquals(fundRecord2.UL_Uncommitted__c, tacticRecord.ACCL__Amount__c);
    System.AssertEquals(fundRecord2.UL_Available_to_Spend__c, fundRecord.ACCL__Amount__c-tacticRecord.ACCL__Amount__c);

    promotionRecord.ACCL__Phase__c = 'Rejected';
    update promotionRecord;

    //tacticRecord.UL_Promotion_Phase__c = 'Rejected';
    //update tacticRecord;

    ACCL__Fund__c fundRecord3 =[Select Id, Name, ACCL__Sales_Org__c, ACCL__Amount__c, UL_Available_to_Spend__c, UL_Uncommitted__c, UL_Committed__c From ACCL__Fund__c Where ACCL__Description_Language_1__c = 'Fund Description1'];

    System.AssertEquals(fundRecord3.UL_Uncommitted__c, fundRecord2.UL_Uncommitted__c-tacticRecord.ACCL__Amount__c);
    System.AssertEquals(fundRecord3.UL_Available_to_Spend__c, fundRecord2.UL_Available_to_Spend__c+tacticRecord.ACCL__Amount__c);

    promotionRecord.ACCL__Phase__c = 'ForApproval';
    update promotionRecord;

    //tacticRecord.UL_Promotion_Phase__c = 'ForApproval';
    //update tacticRecord;

    ACCL__Fund__c fundRecord4 =[Select Id, Name, ACCL__Sales_Org__c, ACCL__Amount__c, UL_Available_to_Spend__c, UL_Uncommitted__c, UL_Committed__c From ACCL__Fund__c Where ACCL__Description_Language_1__c = 'Fund Description1'];

    System.AssertEquals(fundRecord4.UL_Uncommitted__c, tacticRecord.ACCL__Amount__c);
    System.AssertEquals(fundRecord4.UL_Available_to_Spend__c, fundRecord4.ACCL__Amount__c-tacticRecord.ACCL__Amount__c);


    promotionRecord.ACCL__Phase__c = 'Approved';
    update promotionRecord;

    //tacticRecord.UL_Promotion_Phase__c = 'Approved';
    //update tacticRecord;

    ACCL__Fund__c fundRecord5 =[Select Id, Name, ACCL__Sales_Org__c, ACCL__Amount__c, UL_Available_to_Spend__c, UL_Uncommitted__c, UL_Committed__c From ACCL__Fund__c Where ACCL__Description_Language_1__c = 'Fund Description1'];

/*  //creating Fund transaction for the amount taken out of the fund
    ACCL__Fund_Transaction__c testTransaction2 = new ACCL__Fund_Transaction__c();
    testTransaction2.ACCL__Fund_Transaction_Template__c = transactionTemplateRecord.id;
    testTransaction2.ACCL__Amount__c = tacticRecord.ACCL__Amount__c;
    testTransaction2.ACCL__Target_Fund__c = fundRecord5.id;
    insert testTransaction2;
    
  //creating Fund transaction rows for the amount taken off from the fund done in the above step
    ACCL__Fund_Transaction_Row__c testTransactionRow2 = new ACCL__Fund_Transaction_Row__c();
    testtransactionRow2.ACCL__Amount__c = (-1)*tacticRecord.ACCL__Amount__c;
    testtransactionRow2.ACCL__Target_Fund__c = fundRecord5.id;
    testtransactionRow2.ACCL__Fund_Transaction__c = testTransaction2.id;
    insert testtransactionRow2;
    
    ACCL__Fund__c fundRecord6 =[Select Id, Name, ACCL__Sales_Org__c, ACCL__Amount__c, UL_Available_to_Spend__c, UL_Uncommitted__c, UL_Committed__c From ACCL__Fund__c Where ACCL__Description_Language_1__c = 'Fund Description1'];
*/
    System.AssertEquals(fundRecord5.UL_Uncommitted__c, 0);
    System.AssertEquals(fundRecord5.UL_Committed__c, tacticRecord.ACCL__Amount__c);
    System.AssertEquals(fundRecord5.UL_Available_to_Spend__c, fundRecord5.ACCL__Amount__c);

}
   
    }

}