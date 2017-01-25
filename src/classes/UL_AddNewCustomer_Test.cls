@isTest(SeeAllData=false)
private class UL_AddNewCustomer_Test{

    @testSetup
    private static void prepareData(){
                
        //Create CustomerSet
        ACCL__Account_Set__c testAccSet = new ACCL__Account_Set__c();
        testAccSet.ACCL__Sales_Org__c = 'AR01';
        testAccSet.ACCL__Description_Language_1__c = 'en';
        insert testAccSet;
        
        //Create customer template 
        ACCL__Account_Template__c custTemp = new ACCL__Account_Template__c();
        custTemp.Name ='TestTemplate';
        custTemp.ACCL__Active__c = true;
        custTemp.ACCL__Initial_Roles__c = 'customer';
        custTemp.ACCL__Sales_Org__c = testAccSet.ACCL__Sales_Org__c;
        insert custTemp;
        
        //Create Accounts
        //Account for AR01
        Account testAccount = new Account();
        testAccount.Name = 'TestAccount-AR01';
        testAccount.ACCL__Account_Number__c = '99999';
        testAccount.ACCL__Name_2__c = 'TestAccount-AR01-2';
        testAccount.ACCL__Account_Template__c = custTemp.id;
        testAccount.UL_Customer_Group_Description__c = 'Customer Group Desc';
        testAccount.UL_Market_Channel_Description__c = 'Market Channel Desc';
        testAccount.UL_Market_Description__c = 'Market Desc';
        
        insert testAccount;
    }
    
    //Test method while landing into the page
    @isTest
    private static void listAllAccountTest(){
        PageReference pageRef = Page.UL_AddCustomer;
        Test.setCurrentPage(pageRef);
        
        ACCL__Account_Set__c accSet = [SELECT Id,ACCL__Sales_Org__c FROM ACCL__Account_Set__c  WHERE ACCL__Sales_Org__c = 'AR01'];
        ACCL__Account_Set_Account__c accountSetAccount = new ACCL__Account_Set_Account__c();
        accountSetAccount.ACCL__Account_Set__c = accSet.Id;
        ApexPages.StandardController accountSetController = new ApexPages.StandardController(accountSetAccount);
        UL_AddNewCustomer controller = new UL_AddNewCustomer(accountSetController);
        controller.doPageLoad();
        system.assertEquals(controller.customerList.size(),1);
    } 
    
    //Test different search schenario
    @isTest
    private static void doSearchTest(){
        PageReference pageRef = Page.UL_AddCustomer;
        Test.setCurrentPage(pageRef);
        
        ACCL__Account_Set__c accSet = [SELECT Id,ACCL__Sales_Org__c FROM ACCL__Account_Set__c  WHERE ACCL__Sales_Org__c = 'AR01'];
        ACCL__Account_Set_Account__c accountSetAccount = new ACCL__Account_Set_Account__c();
        accountSetAccount.ACCL__Account_Set__c = accSet.Id;
        ApexPages.StandardController accountSetController = new ApexPages.StandardController(accountSetAccount);
        UL_AddNewCustomer controller = new UL_AddNewCustomer(accountSetController);
        
        controller.doPageLoad();
        
        //Do search with non-available field value
        controller.field1 = 'Customer Group - AR01';
        controller.doSearch();
        system.assertEquals(controller.customerList.size(), 0);
    
        //Set search criteria
        controller.field1 = 'Customer Group';
        controller.doSearch();
        system.assertEquals(controller.customerList.size(),1);
    
        controller.field1 = 'Customer Group123';
        controller.field2 = 'Customer Group123';
        controller.field3 = 'Customer Group123';
        controller.field4 = 'Customer Group123';
        controller.field5 = 'Customer Group123';
        controller.isInclusive = true;
        controller.doSearch();
        system.assertEquals(controller.customerList.size(),0);
    
        //Clear filter
        controller.doClearFilter();
        system.assertEquals(controller.customerList.size(),1);
    }
    
    //Test adding Account to CustomerSet 
    @isTest
    private static void doSubmitTest(){
        PageReference pageRef = Page.UL_AddCustomer;
        Test.setCurrentPage(pageRef);
        
        ACCL__Account_Set__c accSet = [SELECT Id,ACCL__Sales_Org__c FROM ACCL__Account_Set__c  WHERE ACCL__Sales_Org__c = 'AR01'];
        ACCL__Account_Set_Account__c accountSetAccount = new ACCL__Account_Set_Account__c();
        accountSetAccount.ACCL__Account_Set__c = accSet.Id;
        ApexPages.StandardController accountSetController = new ApexPages.StandardController(accountSetAccount);
        UL_AddNewCustomer controller = new UL_AddNewCustomer(accountSetController);
        controller.doPageLoad();
        system.assertEquals(controller.customerList.size(),1);
        
        //Try to save without selecting any record
        controller.submit();

        //Try to save after selecting a record
        controller.customerList[0].selected = true;
        controller.submit();
        
        //Adding Account to CustmerSet 
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'TestAccount-AR01'];
        List<ACCL__Account_Set_Account__c> custSetList = [SELECT Id FROM ACCL__Account_Set_Account__c WHERE ACCL__Account__c=:testAccount.id AND ACCL__Account_Set__c=:accSet.id];
        system.assertEquals(custSetList.size(),1);
        
        //After adding the test account, it should not be available to add again 
        controller.field1 = 'Customer Group';
        controller.doSearch();
        system.assertEquals(controller.customerList.size(), 0);
      }
}