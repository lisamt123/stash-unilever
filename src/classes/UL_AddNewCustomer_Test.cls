@isTest(SeeAllData=false)
private class UL_AddNewCustomer_Test{

    @testSetup
    private static void prepareData(){
                
        //Create CustomerSet
        ACSFUL001__Account_Set__c testAccSet = new ACSFUL001__Account_Set__c();
        testAccSet.ACSFUL001__Sales_Org__c = 'AR01';
        testAccSet.ACSFUL001__Description_Language_1__c = 'en';
        insert testAccSet;
        
        //Create customer template 
        ACSFUL001__Account_Template__c custTemp = new ACSFUL001__Account_Template__c();
        custTemp.Name ='TestTemplate';
        custTemp.ACSFUL001__Active__c = true;
        custTemp.ACSFUL001__Initial_Roles__c = 'customer';
        custTemp.ACSFUL001__Sales_Org__c = testAccSet.ACSFUL001__Sales_Org__c;
        insert custTemp;
        
        //Create Accounts
        //Account for AR01
        Account testAccount = new Account();
        testAccount.Name = 'TestAccount-AR01';
        testAccount.ACSFUL001__Account_Number__c = '99999';
        testAccount.ACSFUL001__Name_2__c = 'TestAccount-AR01-2';
        testAccount.ACSFUL001__Account_Template__c = custTemp.id;
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
        
        ACSFUL001__Account_Set__c accSet = [SELECT Id,ACSFUL001__Sales_Org__c FROM ACSFUL001__Account_Set__c  WHERE ACSFUL001__Sales_Org__c = 'AR01'];
        ApexPages.currentPage().getParameters().put('setId', accSet.id);
        ApexPages.currentPage().getParameters().put('orgId', accSet.ACSFUL001__Sales_Org__c);
        ApexPages.currentPage().getParameters().put('referer', Null);
    
        UL_AddNewCustomer controller = new UL_AddNewCustomer();
        controller.doPageLoad();
        system.assertEquals(controller.customerList.size(),1);
    } 
    
    //Test different search schenario
    @isTest
    private static void doSearchTest(){
        PageReference pageRef = Page.UL_AddCustomer;
        Test.setCurrentPage(pageRef);
        
        ACSFUL001__Account_Set__c accSet = [SELECT Id,ACSFUL001__Sales_Org__c FROM ACSFUL001__Account_Set__c  WHERE ACSFUL001__Sales_Org__c = 'AR01'];
        ApexPages.currentPage().getParameters().put('setId', accSet.id);
        ApexPages.currentPage().getParameters().put('orgId', accSet.ACSFUL001__Sales_Org__c);
        ApexPages.currentPage().getParameters().put('referer', Null);
    
        UL_AddNewCustomer controller = new UL_AddNewCustomer();
        //Do search without setting any search criteria
        controller.doSearch();
        system.assertEquals(controller.customerList, null);
    
        //Set search criteria
        controller.field1 = 'Customer Group';
        controller.doSearch();
        system.assertEquals(controller.customerList.size(),1);
    
        controller.field1 = 'Customer Group123';
        controller.field2 = 'Customer Group123';
        controller.field3 = 'Customer Group123';
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
        
        ACSFUL001__Account_Set__c accSet = [SELECT Id,ACSFUL001__Sales_Org__c FROM ACSFUL001__Account_Set__c  WHERE ACSFUL001__Sales_Org__c = 'AR01'];
        ApexPages.currentPage().getParameters().put('setId', accSet.id);
        ApexPages.currentPage().getParameters().put('orgId', accSet.ACSFUL001__Sales_Org__c);
        ApexPages.currentPage().getParameters().put('referer', Null);
    
        UL_AddNewCustomer controller = new UL_AddNewCustomer();
        controller.doPageLoad();
        system.assertEquals(controller.customerList.size(),1);
        
        //Try to save without selecting any record
        controller.submit();

        //Try to save after selecting a record
        controller.customerList[0].selected = true;
        controller.submit();
        
        //Adding Account to CustmerSet 
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'TestAccount-AR01'];
        List<ACSFUL001__Account_Set_Account__c> custSetList = [SELECT Id FROM ACSFUL001__Account_Set_Account__c WHERE ACSFUL001__Account__c=:testAccount.id AND ACSFUL001__Account_Set__c=:accSet.id];
        system.assertEquals(custSetList.size(),1);
        
        //After adding the test account, it should not be available to add again 
        controller.field1 = 'Customer Group';
        controller.doSearch();
        system.assertEquals(controller.customerList.size(), 0);
      }
}