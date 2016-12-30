@isTest
private class UL_UpdatePromotionTypeControllerTest{

     @testSetup
    private static void promotioTemplateData(){
         
        //Create promotion template
        ACCL__Promotion_Template__c pTemp = new ACCL__Promotion_Template__c ();
        pTemp.Name = 'UK user';
        pTemp.UL_Promo_Type_ControlView__c = 'Promotion';
        pTemp.ACCL__Sales_Org__c = 'UK SO';
        pTemp.UL_Calculate_Promotion_Type__c = true;
        pTemp.ACCL__Description_Language_1__c = 'UK user';
        pTemp.ACCL__Anchor_Type__c= 'Customer';
        pTemp.ACCL__Active__c = true;
     insert pTemp;
     
     //Create customer template 
        ACCL__Account_Template__c custTemp = new ACCL__Account_Template__c();
        custTemp.Name ='TestTemplate';
        custTemp.ACCL__Active__c = true;
        custTemp.ACCL__Initial_Roles__c = 'customer';
        custTemp.ACCL__Sales_Org__c = 'UK SO';
        insert custTemp;
     //Create Accounts
        //Account for UK SO
        Account testAccount = new Account();
        testAccount.Name = 'TestAccount-UK SO';
        testAccount.ACCL__Account_Number__c = '99999';
        testAccount.ACCL__Name_2__c = 'TestAccount-UK SO-2';
        testAccount.ACCL__Account_Template__c = custTemp.id;
        testAccount.UL_Customer_Group_Description__c = 'Customer Group Desc';
        testAccount.UL_Market_Channel_Description__c = 'Market Channel Desc';
        testAccount.UL_Market_Description__c = 'Market Desc';
        testAccount.UL_Direct_Indirect_Flag__c= 'Direct';
        testAccount.UL_NCF_Flag__c = true;
        testAccount.UL_Customer_Hierarchy_Level__c = 'Level 8';
        insert testAccount;
        
        //Create promotions
        ACCL__promotion__c  testPromotion = new ACCL__promotion__c ();
        testPromotion.ACCL__Promotion_Template__c = pTemp.id;
        testPromotion.UL_Account__c  = testAccount.id;
        testPromotion.ACCL__Placement_Date_From__c= system.today();
        testPromotion.ACCL__Placement_Date_Thru__c= system.today().addDays(2);
        insert testPromotion;
    }
    
    @isTest
    private static void updatepromotionTypeTest(){
    list<ACCL__promotion__c> pRecords = [select id,ACCL__Promotion_Template__c , UL_Account__c   from ACCL__promotion__c  limit 1];
    UL_UpdatePromotionTypeController.updatePromotionType(pRecords);
    }
}