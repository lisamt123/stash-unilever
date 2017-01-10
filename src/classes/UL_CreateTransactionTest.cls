@istest
/**
* Name          : CreateTransactionTest
* Description   : CreateTransactionTest test class for CreateTransactionController classes
* @author       : ankita.tukaram.parab@accenture.com
* Date          : 1-May-2016
*/
private class UL_CreateTransactionTest {
    /*Method for testing positive scenario
      to check insertion of Transaction record- Scenario 1 with Cabo FM permission set user and with Transfer type as Initial
    */
    
    public final static String CABO_USER_PROFILE = 'SoCo-Finance Admin';
    public final static String ACSF_FM_PERMISSION_SET = 'ACSF_FM';
    public final static String ACSF_FA_PERMISSION_SET = 'ACSF_FA'; 
    Public final static string FUND_STATUS_ACTIVE = 'Active';
    Public final static string TRANSACTION_TYPE_INITIAL = 'Initial';
    Public final static string TRANSACTION_TYPE_ADJUSTMENT = 'Adjustment';
    Public final static string TRANSACTION_TYPE_TRANSFER = 'Transfer';
    public final static String STRING_NULL = null;
    public final static String NAME = 'TestClass_Testing';
    Public final static string ANCHOR_TYPE_CUSTOMER = 'Customer';
    
     private static testMethod void insertTxnWithInitialTypeFM() {    
        User testUser = UL_UserTestFactory.insertUserWithProfile(1,CABO_USER_PROFILE);
        UL_UserTestFactory.insertUserPermissionset(testUser,ACSF_FM_PERMISSION_SET);
        System.runAs(testUser) {
            //Sales_Organization__c globalSalesOrg = SalesOrgTestFactory.insertGlobalSalesOrg(SALES_ORG_CANADA,SALES_ORG_CANADA_CURRENCY);
            ACCL__Sales_Organization__c globalSalesOrg = new ACCL__Sales_Organization__c(Name='Global Sales Org',ACCL__Description_Language_1__c = 'Global Sales Org - 1', 
                                                                           ACCL__Language_1__c = 'English', ACCL__Currency__c = 'USD');
            insert globalSalesOrg ;
            ACCL__Fund_Transaction__c transactionRecord= UL_TransactionTestFactory.buildDefaultTransaction();
            Test.startTest();
            ApexPages.StandardController standardController = new ApexPages.standardController(transactionRecord);
            UL_CreateTransactionController controller = new UL_CreateTransactionController (standardController);
            // Calling the Save Method.
            PageReference pgRef = controller.saveRecord(); 
            Test.stopTest();
            System.assertNotEquals(null,pgRef);
            System.assertNotEquals(null,transactionRecord.id); 
        }
     }
     /*Method for testing positive scenario
      to check insertion of Transaction record- Scenario 2 with Cabo FM permission set user and with Transfer type as Adjustment
    */
      private static testMethod void insertTxnWithAdjustmentTypeFM() {    
        User testUser = UL_UserTestFactory.insertUserWithProfile(1,CABO_USER_PROFILE);
        UL_UserTestFactory.insertUserPermissionset(testUser,ACSF_FM_PERMISSION_SET);
        System.runAs(testUser) {
            List<ACCL__Fund__c>listFund=UL_FundTestFactory.insertFundList(UL_AccountExtensionTestFactory.getDefaultAccountExtension(),UL_ProductTestFactory.insertProducts(10),UL_FundTemplateTestFactory.getDefaultFundTemplate(),FUND_STATUS_ACTIVE,System.Today(),System.Today().adddays(5));
            ACCL__Fund_Transaction__c initialTransaction=UL_TransactionTestFactory.insertTransaction(1000,listFund[0],listFund[1],UL_TransactionTemplateTestFactory.insertTransactionTemplate(1,TRANSACTION_TYPE_INITIAL,1,STRING_NULL));
            UL_TransactionRowTestFactory.insertTransactionRow(1000,listFund[0],listFund[1],initialTransaction);
            ACCL__Fund_Transaction__c transactionRecord= UL_TransactionTestFactory.buildTransaction(500,listFund[0],listFund[1],UL_TransactionTemplateTestFactory.insertTransactionTemplate(2,TRANSACTION_TYPE_ADJUSTMENT,1,STRING_NULL));
            Test.startTest();
            ApexPages.StandardController standardController = new ApexPages.standardController(transactionRecord);
            UL_CreateTransactionController controller = new UL_CreateTransactionController (standardController);
            // Calling the Save Method.
            PageReference pgRef = controller.saveRecord(); 
            Test.stopTest();
            System.assertNotEquals(null,pgRef);
            System.assertNotEquals(null,transactionRecord.id); 
        }
     }
    /*Method for testing positive scenario
      to check insertion of Transaction record- Scenario 3 with Cabo FM permission set user and with Transfer type as Transfer
    */
    /*  private static testMethod void insertTxnWithTransferTypeFM() {    
        User testUser = UL_UserTestFactory.insertUserWithProfile(1,CABO_USER_PROFILE);
        UL_UserTestFactory.insertUserPermissionset(testUser,ACSF_FM_PERMISSION_SET);
        System.runAs(testUser) {
            List<ACCL__Fund__c>listFund=UL_FundTestFactory.insertFundList(UL_AccountExtensionTestFactory.getDefaultAccountExtension(),UL_ProductTestFactory.insertProducts(10),UL_FundTemplateTestFactory.getDefaultFundTemplate(),FUND_STATUS_ACTIVE,System.Today(),System.Today().adddays(5));
            ACCL__Fund_Transaction__c initialTransaction=UL_TransactionTestFactory.insertTransaction(1000,listFund[0],listFund[1],UL_TransactionTemplateTestFactory.insertTransactionTemplate(1,TRANSACTION_TYPE_INITIAL,1,STRING_NULL));
            UL_TransactionRowTestFactory.insertTransactionRow(1000,listFund[0],listFund[1],initialTransaction);
            ACCL__Fund_Transaction__c transactionRecord= UL_TransactionTestFactory.buildTransaction(500,listFund[1],listFund[0],UL_TransactionTemplateTestFactory.insertTransactionTemplate(2,TRANSACTION_TYPE_TRANSFER,1,STRING_NULL));
            Test.startTest();
            ApexPages.StandardController standardController = new ApexPages.standardController(transactionRecord);
            UL_CreateTransactionController controller = new UL_CreateTransactionController (standardController);
            // Calling the Save Method.
            PageReference pgRef = controller.saveRecord(); 
            Test.stopTest();
            System.assertNotEquals(null,pgRef);
            System.assertNotEquals(null,transactionRecord.id); 
        }
     } */
      /*Method for testing positive scenario
      to check insertion of Transaction record- Scenario 4 with Cabo FA permission set user and with Transfer type as Transfer
    */
      private static testMethod void insertTxnWithTransferTypeFA() {    
        User testUser = UL_UserTestFactory.insertUserWithProfile(1,CABO_USER_PROFILE);
        UL_UserTestFactory.insertUserPermissionset(testUser,ACSF_FM_PERMISSION_SET);
        List<ACCL__Fund__c>listFund=UL_FundTestFactory.insertFundList(UL_AccountExtensionTestFactory.getDefaultAccountExtension(),UL_ProductTestFactory.insertProducts(10),UL_FundTemplateTestFactory.getDefaultFundTemplate(),FUND_STATUS_ACTIVE,System.Today(),System.Today().adddays(5));
        System.runAs(testUser) {
            ACCL__Fund_Transaction__c initialTransaction=UL_TransactionTestFactory.insertTransaction(1000,listFund[0],listFund[1],UL_TransactionTemplateTestFactory.insertTransactionTemplate(1,TRANSACTION_TYPE_INITIAL,1,STRING_NULL));
            UL_TransactionRowTestFactory.insertTransactionRow(1000,listFund[0],listFund[1],initialTransaction);
            ACCL__Fund_Transaction__c transactionRecord= UL_TransactionTestFactory.buildTransaction(500,listFund[1],listFund[0],UL_TransactionTemplateTestFactory.insertTransactionTemplate(2,TRANSACTION_TYPE_TRANSFER,1,STRING_NULL));
            Test.startTest();
            ApexPages.StandardController standardController = new ApexPages.standardController(transactionRecord);
            UL_CreateTransactionController controller = new UL_CreateTransactionController (standardController);
            // Calling the Save Method.
            PageReference pgRef = controller.saveRecord();
            system.debug('$$1'+pgRef);
            Test.stopTest();
            System.assertNotEquals(null,pgRef);
            System.assertNotEquals(null,transactionRecord.id); 
        }
     }
     /*Method for testing positive scenario
      to check insertion of Transaction record- Scenario 5 with Cabo FM permission set user and when transfer Transaction is initiated through Button
    */
    /*  private static testMethod void insertTxnThroughButton() {    
        User testUser = UL_UserTestFactory.insertUserWithProfile(1,CABO_USER_PROFILE);
        UL_UserTestFactory.insertUserPermissionset(testUser,ACSF_FM_PERMISSION_SET);
        System.runAs(testUser) {
            List<ACCL__Fund__c>listFund=UL_FundTestFactory.insertFundList(UL_AccountExtensionTestFactory.getDefaultAccountExtension(),UL_ProductTestFactory.insertProducts(10),UL_FundTemplateTestFactory.getDefaultFundTemplate(),FUND_STATUS_ACTIVE,System.Today(),System.Today().adddays(5));
            ACCL__Fund_Transaction__c initialTransaction=UL_TransactionTestFactory.insertTransaction(1000,listFund[0],listFund[1],UL_TransactionTemplateTestFactory.insertTransactionTemplate(1,TRANSACTION_TYPE_INITIAL,1,STRING_NULL));
            UL_TransactionRowTestFactory.insertTransactionRow(1000,listFund[1],listFund[0],initialTransaction);
            ACCL__Fund_Transaction__c transactionRecord= UL_TransactionTestFactory.buildTransaction(500,listFund[0],listFund[1],UL_TransactionTemplateTestFactory.insertTransactionTemplate(2,TRANSACTION_TYPE_TRANSFER,1,STRING_NULL));
            PageReference pgRef = Page.UL_CreateTransactionPage;
            //CreatePageRef
            Test.setCurrentPage(pgRef);
            ApexPages.currentPage().getParameters().put('sourceFund',listFund[0].id);
            Test.startTest();
            ApexPages.StandardController standardController = new ApexPages.standardController(transactionRecord);
            UL_CreateTransactionController controller = new UL_CreateTransactionController (standardController);
            // Calling the Save Method.
            pgRef = controller.saveRecord();
            system.debug('$$2PageIdentifier'+pgRef);
            Test.stopTest();
            System.assertNotEquals(null,pgRef);
            System.assertNotEquals(null,transactionRecord.id); 
        }
     }*/
     /*Method for testing positive scenario for Sales Org Canada.
    */
      private static testMethod void unitTestForSalesOrg() {    
        User testUser = UL_UserTestFactory.insertUserWithProfile(1,CABO_USER_PROFILE);
        UL_UserTestFactory.insertUserPermissionset(testUser,ACSF_FM_PERMISSION_SET);
        ACCL__Account_Template__c accountTemplate= new ACCL__Account_Template__c(Name= NAME, 
                                                                        recordtypeid=UL_RecordTypeUtil.getRecordTypeIdsByDeveloperName(ACCL__Account_Template__c.sobjecttype).get('Customer'),
                                                                        ACCL__Active__c = true);
        insert accountTemplate;
       // System.runAs(testUser) {
            //Sales_Organization__c globalSalesOrg = SalesOrgTestFactory.insertSalesOrg(SALES_ORG_CANADA,SALES_ORG_CANADA_CURRENCY);
            ACCL__Sales_Organization__c globalSalesOrg = new ACCL__Sales_Organization__c(Name='Global Sales Org',ACCL__Description_Language_1__c = 'Global Sales Org - 1', 
                                                                           ACCL__Language_1__c = 'English', ACCL__Currency__c = 'USD');
            insert globalSalesOrg ;
            Account accountRecord=UL_AccountTestFactory.buildAccount(1);
            accountRecord.ACCL__Account_Template__c = accountTemplate.id;
            accountRecord.recordtypeid = UL_RecordTypeUtil.getRecordTypeIdsByDeveloperName(Account.sobjecttype).get('Customer');
            insert accountRecord;
            ACCL__Account_Extension__c accountExtensionRecord=UL_AccountExtensionTestFactory.insertAccountExtension(accountRecord,
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5),
                                    System.Today(),System.Today().addDays(5));
            ACCL__Fund_Template__c fundTemplate = UL_FundTemplateTestFactory.insertFundTemplate(4,ANCHOR_TYPE_CUSTOMER,1,null);
            ACCL__Fund__c fundRecord = UL_FundTestFactory.insertFund(accountExtensionRecord,null,fundTemplate,
                                    FUND_STATUS_ACTIVE,System.Today(),System.Today().adddays(5));
            ACCL__Fund_Transaction_Template__c transactionTemplate = UL_TransactionTemplateTestFactory.insertTransactionTemplate(1,TRANSACTION_TYPE_INITIAL,1,null);
            ACCL__Fund_Transaction__c initialTransaction = UL_TransactionTestFactory.buildTransaction(1000,null,fundRecord,transactionTemplate);
            PageReference pgRef = Page.UL_CreateTransactionPage;
            //CreatePageRef
            Test.setCurrentPage(pgRef);
            ApexPages.currentPage().getParameters().put('sourceFund',fundRecord.id);
            Test.startTest();
            ApexPages.StandardController standardController = new ApexPages.standardController(initialTransaction);
            UL_CreateTransactionController controller = new UL_CreateTransactionController (standardController);
            // Calling the Save Method.
            controller.relatedRecord.ACCL__Fund_Transaction_Template__c= transactionTemplate.id;
            controller.reloadTransaction();
            pgRef = controller.saveRecord(); 
            Test.stopTest();
            System.assertEquals(null,pgRef);
            System.assertEquals(null,initialTransaction.id); 
       // }
     }
     /*Method for testing negative scenario- Scenario 2 with Cabo FM permission set user and with Transfer type as Transfer where source Fund = Target fund
    */
      private static testMethod void verifyErrorForSameFund() {    
        User testUser = UL_UserTestFactory.insertUserWithProfile(1,CABO_USER_PROFILE);
        UL_UserTestFactory.insertUserPermissionset(testUser,ACSF_FM_PERMISSION_SET);
        System.runAs(testUser) {
            List<ACCL__Fund__c>listFund=UL_FundTestFactory.insertFundList(UL_AccountExtensionTestFactory.getDefaultAccountExtension(),UL_ProductTestFactory.insertProducts(10),UL_FundTemplateTestFactory.getDefaultFundTemplate(),FUND_STATUS_ACTIVE,System.Today(),System.Today().adddays(5));
            ACCL__Fund_Transaction__c transactionRecord= UL_TransactionTestFactory.buildTransaction(500,listFund[1],listFund[1],UL_TransactionTemplateTestFactory.insertTransactionTemplate(2,TRANSACTION_TYPE_TRANSFER,1,STRING_NULL));
            Test.startTest();
            ApexPages.StandardController standardController = new ApexPages.standardController(transactionRecord);
            UL_CreateTransactionController controller = new UL_CreateTransactionController (standardController);
            // Calling the Save Method.
            PageReference pgRef = controller.saveRecord(); 
            Test.stopTest();
            System.assertEquals(null,pgRef);
            System.assertEquals(Label.ACCL.SOURCE_FUND_TARGET_FUND_SHOULD_NOT_BE_SAME,ApexPages.getMessages()[0].getDetail());
        }
     }
    /*Method for testing negative scenario- Scenario 3 with Cabo FM permission set user and with Transfer type as adjustment and there is no value in source fund
    */
      private static testMethod void verifyErrorForNegatitveFund() {    
        User testUser = UL_UserTestFactory.insertUserWithProfile(1,CABO_USER_PROFILE);
        UL_UserTestFactory.insertUserPermissionset(testUser,ACSF_FM_PERMISSION_SET);
        System.runAs(testUser) {
            List<ACCL__Fund__c>listFund=UL_FundTestFactory.insertFundList(UL_AccountExtensionTestFactory.getDefaultAccountExtension(),UL_ProductTestFactory.insertProducts(10),UL_FundTemplateTestFactory.getDefaultFundTemplate(),FUND_STATUS_ACTIVE,System.Today(),System.Today().adddays(5));
            ACCL__Fund_Transaction__c transactionRecord= UL_TransactionTestFactory.buildTransaction(500,listFund[0],listFund[1],UL_TransactionTemplateTestFactory.insertTransactionTemplate(2,TRANSACTION_TYPE_ADJUSTMENT,1,STRING_NULL));
            Test.startTest();
            ApexPages.StandardController standardController = new ApexPages.standardController(transactionRecord);
            UL_CreateTransactionController controller = new UL_CreateTransactionController (standardController);
            // Calling the Save Method.
            PageReference pgRef = controller.saveRecord(); 
            Test.stopTest();
            System.assertEquals(null,pgRef);
            system.assertEquals(Label.ACCL.REMANING_FUND_AMOUNT_GREATER_THAN_ZERO,ApexPages.getMessages()[0].getDetail());
        }
     }
    /*Method for testing negative scenario- Scenario 4 with Cabo FM permission set user and with Transfer type as Transfer where source fund is null
    */
      private static testMethod void verifyErrorForEmptyFund() {    
        User testUser = UL_UserTestFactory.insertUserWithProfile(1,CABO_USER_PROFILE);
        UL_UserTestFactory.insertUserPermissionset(testUser,ACSF_FM_PERMISSION_SET);
        System.runAs(testUser) {
            List<ACCL__Fund__c>listFund=UL_FundTestFactory.insertFundList(UL_AccountExtensionTestFactory.getDefaultAccountExtension(),UL_ProductTestFactory.insertProducts(10),UL_FundTemplateTestFactory.getDefaultFundTemplate(),FUND_STATUS_ACTIVE,System.Today(),System.Today().adddays(5));
            ACCL__Fund_Transaction__c transactionRecord= UL_TransactionTestFactory.buildTransaction(500,listFund[0],listFund[1],UL_TransactionTemplateTestFactory.insertTransactionTemplate(2,TRANSACTION_TYPE_TRANSFER,1,STRING_NULL));
            Test.startTest();
            ApexPages.StandardController standardController = new ApexPages.standardController(transactionRecord);
            UL_CreateTransactionController controller = new UL_CreateTransactionController (standardController);
            controller.relatedRecord.ACCL__Source_Fund__c = null;
            // Calling the Save Method.
            PageReference pgRef = controller.saveRecord(); 
            Test.stopTest();
            System.assertEquals(null,pgRef);
            system.assertEquals(Label.ACCL.SOURCE_FUND_IS_NULL,ApexPages.getMessages()[0].getDetail());
        }
     }
    /*Method for testing negative scenario- Scenario 5 with Cabo FA permission set user and with Transfer type as Transfer.CABO FA should not have access to Create transfer transaction
    */
      private static testMethod void verifyErrorForAccessFA() {    
        User testUser = UL_UserTestFactory.insertUserWithProfile(1,CABO_USER_PROFILE);
        UL_UserTestFactory.insertUserPermissionset(testUser,ACSF_FA_PERMISSION_SET);
        List<ACCL__Fund__c>listFund=UL_FundTestFactory.insertFundList(UL_AccountExtensionTestFactory.getDefaultAccountExtension(),UL_ProductTestFactory.insertProducts(10),UL_FundTemplateTestFactory.getDefaultFundTemplate(),FUND_STATUS_ACTIVE,System.Today(),System.Today().adddays(5));
        System.runAs(testUser) {
            ACCL__Fund_Transaction__c transactionRecord= UL_TransactionTestFactory.buildTransaction(500,listFund[0],listFund[1],UL_TransactionTemplateTestFactory.insertTransactionTemplate(2,TRANSACTION_TYPE_TRANSFER,1,STRING_NULL));
            PageReference pgRef = Page.UL_CreateTransactionPage;
            //CreatePageRef
            Test.setCurrentPage(pgRef);
            ApexPages.currentPage().getParameters().put('sourceFund',listFund[0].id);
            Test.startTest();
            ApexPages.StandardController standardController = new ApexPages.standardController(transactionRecord);
            UL_CreateTransactionController controller = new UL_CreateTransactionController (standardController);
            // Calling the Save Method.
            pgRef = controller.saveRecord(); 
            Test.stopTest();
            System.assertEquals(null,pgRef);
            system.assertEquals(Label.ACCL.TRANSFER_TRANSACTION_ACCESS,ApexPages.getMessages()[0].getDetail());
        }
     }
     /*Method for testing negative scenario- Scenario 6 with Cabo FM permission set user and Negative amount
    */
      private static testMethod void verifyErrorForNegativeAmount() {    
        User testUser = UL_UserTestFactory.insertUserWithProfile(1,CABO_USER_PROFILE);
        UL_UserTestFactory.insertUserPermissionset(testUser,ACSF_FM_PERMISSION_SET);
        System.runAs(testUser) {
            List<ACCL__Fund__c>listFund=UL_FundTestFactory.insertFundList(UL_AccountExtensionTestFactory.getDefaultAccountExtension(),UL_ProductTestFactory.insertProducts(10),UL_FundTemplateTestFactory.getDefaultFundTemplate(),FUND_STATUS_ACTIVE,System.Today(),System.Today().adddays(5));
            ACCL__Fund_Transaction__c transactionRecord= UL_TransactionTestFactory.buildTransaction(-500,listFund[0],listFund[1],UL_TransactionTemplateTestFactory.insertTransactionTemplate(2,TRANSACTION_TYPE_ADJUSTMENT,1,STRING_NULL));
            Test.startTest();
            ApexPages.StandardController standardController = new ApexPages.standardController(transactionRecord);
            UL_CreateTransactionController controller = new UL_CreateTransactionController (standardController);
            // Calling the Save Method.
            PageReference pgRef = controller.saveRecord(); 
            Test.stopTest();
            system.assertEquals(Label.ACCL.TRANSACTION_AMOUNT_GREATER_THAN_ZERO,ApexPages.getMessages()[0].getDetail());
            System.assertEquals(null,pgRef);
        }
     }
    /*Method for testing positive scenario- Scenario 1 with Cabo FM permission set user and changing the transaction template to Transfer
    */
      private static testMethod void VerifyChangeInTransferTypeTemplate() {    
        User testUser = UL_UserTestFactory.insertUserWithProfile(1,CABO_USER_PROFILE);
        UL_UserTestFactory.insertUserPermissionset(testUser,ACSF_FM_PERMISSION_SET);
        System.runAs(testUser) {
            List<ACCL__Fund__c>listFund=UL_FundTestFactory.insertFundList(UL_AccountExtensionTestFactory.getDefaultAccountExtension(),UL_ProductTestFactory.insertProducts(10),UL_FundTemplateTestFactory.getDefaultFundTemplate(),FUND_STATUS_ACTIVE,System.Today(),System.Today().adddays(5));
            ACCL__Fund_Transaction__c transactionRecord= UL_TransactionTestFactory.buildTransaction(500,listFund[0],listFund[1],UL_TransactionTemplateTestFactory.insertTransactionTemplate(2,TRANSACTION_TYPE_TRANSFER,1,STRING_NULL));
            Test.startTest();
            ApexPages.StandardController standardController = new ApexPages.standardController(transactionRecord);
            UL_CreateTransactionController controller = new UL_CreateTransactionController (standardController);
            // Calling the Save Method.
            PageReference pgRef = controller.reloadTransaction(); 
            Test.stopTest();
            System.assertEquals(null,pgRef);
        }
     }
    /*Method for testing positive scenario- Scenario 2 with Cabo FM permission set user and changing the transaction template to adjustment
    */
      private static testMethod void VerifyChangeInAdjustmentTypeTemplate() {    
        User testUser = UL_UserTestFactory.insertUserWithProfile(1,CABO_USER_PROFILE);
        UL_UserTestFactory.insertUserPermissionset(testUser,ACSF_FM_PERMISSION_SET);
        System.runAs(testUser) {
            List<ACCL__Fund__c>listFund=UL_FundTestFactory.insertFundList(UL_AccountExtensionTestFactory.getDefaultAccountExtension(),UL_ProductTestFactory.insertProducts(10),UL_FundTemplateTestFactory.getDefaultFundTemplate(),FUND_STATUS_ACTIVE,System.Today(),System.Today().adddays(5));
            ACCL__Fund_Transaction__c transactionRecord= UL_TransactionTestFactory.buildTransaction(500,listFund[0],listFund[1],UL_TransactionTemplateTestFactory.insertTransactionTemplate(2,TRANSACTION_TYPE_ADJUSTMENT,1,STRING_NULL));
            Test.startTest();
            ApexPages.StandardController standardController = new ApexPages.standardController(transactionRecord);
            UL_CreateTransactionController controller = new UL_CreateTransactionController (standardController);
            // Calling the Save Method.
            PageReference pgRef = controller.reloadTransaction(); 
            Test.stopTest();
            System.assertEquals(null,pgRef);
        }
     }
}