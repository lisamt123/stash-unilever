@isTest(seeAllData = false)
public class UL_CreatePromotionController_Test{
    @testSetup
    private static void prepareData(){
        
    /*   Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          User u = new User(Alias = 'standt', Email='standarduserTPM@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, IsActive= true,
          TimeZoneSidKey='America/Los_Angeles', UserName='standarduserTPM@testorg.com',ACCL__Sales_Org__c ='UK SO');  
          insert u;
          */
        //create promotion templates
        ACCL__Promotion_Template__c pTemp = new ACCL__Promotion_Template__c();
        pTemp.ACCL__Active__c = true;
        pTemp.ACCL__Sales_Org__c = 'UK SO';
        pTemp.Name = 'test template'; 
        pTemp.ACCL__Description_Language_1__c = 'test template';        
        pTemp.ACCL__Anchor_Type__c = 'Customer';
        pTemp.UL_Promo_Type_ControlView__c = 'Promotion';
        pTemp.ACCL__Promotion_Type__c = 'Promotion';
        pTemp.Calculate_In_store_Dates__c= true;
        pTemp.ACCL__Sort__c = 1;
        
        insert  pTemp;   
        
        
         //Create customer template 
        ACCL__Account_Template__c custTemp = new ACCL__Account_Template__c();
        custTemp.Name ='TestTemplate';
        custTemp.ACCL__Active__c = true;
        custTemp.ACCL__Initial_Roles__c = 'customer';
        custTemp.ACCL__Sales_Org__c = 'UK SO';
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
        testAccount.UL_Customer_Hierarchy_Level__c = 'Level 7';
        
        insert testAccount; 
        
        Account testAccount2 = new Account();
        testAccount2.Name = 'TestAccount-AR012';
        testAccount2.ACCL__Account_Number__c = '299999';
        testAccount2.ACCL__Name_2__c = 'TestAccount-AR01-2';
        testAccount2.ACCL__Account_Template__c = custTemp.id;
        testAccount2.UL_Customer_Group_Description__c = 'Customer Group Desc';
        testAccount2.UL_Market_Channel_Description__c = 'Market Channel Desc';
        testAccount2.UL_Market_Description__c = 'Market Desc';
        testAccount2.UL_Customer_Hierarchy_Level__c = 'Level 1';
        
        insert testAccount2; 
         //Account for AR01
        Account testAccount1 = new Account();
        testAccount1.Name = 'TestAccount-AR011';
        testAccount1.ACCL__Account_Number__c = '199999';
        testAccount1.ACCL__Name_2__c = 'TestAccount-AR01-21';
        testAccount1.ACCL__Account_Template__c = custTemp.id;
        testAccount1.UL_Customer_Group_Description__c = 'Customer Group Desc';
        testAccount1.UL_Market_Channel_Description__c = 'Market Channel Desc';
        testAccount1.UL_Market_Description__c = 'Market Desc';
        testAccount1.UL_Customer_Hierarchy_Level__c = 'Level 8';
        
        insert testAccount1; 
        
        ACCL__Account_Trade_Org_Hierarchy__c aT = new ACCL__Account_Trade_Org_Hierarchy__c();
        aT.ACCL__Child_Account__c = testAccount1.id;
        aT.ACCL__Parent_Account__c = testAccount.id;
        aT.ACCL__Valid_From__c = date.today().addDays(-1);
        aT.ACCL__Valid_Thru__c = date.today().addDays(230);
        insert aT;
        //create customer extention
        ACCL__Account_Extension__c aE = new ACCL__Account_Extension__c();
        aE.ACCL__Promotion_Valid_From__c = date.today().addDays(-1);
        aE.ACCL__Promotion_Valid_Thru__c = date.today().addDays(30); 
        aE.ACCL__Account__c = testAccount.id;
        
        insert aE;
            
        //create planning level
        UL_Planning_Level__c ul = new UL_Planning_Level__c();
        ul.UL_Customer__c = testAccount.id;
        ul.UL_Account__c = testAccount.id;
        ul.UL_Planning_Level_Start_Date__c = date.today().addDays(-1);
        ul.UL_Planning_Level_End_Date__c = date.today().addDays(50);
        ul.UL_Sales_Organisation__c = 'UK SO';
        
        insert ul;  
          //creating Delivery Profile
        UL_Delivery_Profile__c delProf = new UL_Delivery_Profile__c();
        delProf.UL_Delivery_Profile_Name__c = 'Test Delivery Profile';
        delProf.UL_Sales_Organisation__c = 'UK SO';
        delProf.UL_Instore_End_days__c = 1234;
        delProf.UL_Shipment_Start_days__c = 123;
        delProf.UL_Shipment_End_days__c = 235;
        delProf.UL_Valid_From__c = date.today().addDays(-1);
        delProf.UL_Week_1_Phasing__c = 101;        
        delProf.UL_Valid_Thru__c = date.today().addDays(10);          
        insert delProf;
        
        //create sales org
        UL_SalesOrg__c us = new UL_SalesOrg__c();
        us.name = 'AR01';
        insert us;
        
        
        //create promotion 
        ACCL__Promotion__c  pro = new ACCL__Promotion__c();
        pro.ACCL__Placement_Date_From__c = date.today();
        pro.ACCL__Promotion_Template__c = pTemp.id;
        pro.UL_Delivery_Profile__c= delProf.id;
        
        insert pro;
         
    }
    @isTest
    private static void loadPromotionTemplatesPositiveTest(){
      //user u = [select id from User limit 1];
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          User u = new User(Alias = 'standt', Email='standarduserTPM@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, IsActive= true,
          TimeZoneSidKey='America/Los_Angeles', UserName='standarduserTPM@testorg.com',ACCL__Sales_Org__c ='UK SO');  
          
      System.runAs(u) {    
         UL_CreatePromotionController controller = new UL_CreatePromotionController(new ApexPages.StandardController(new ACCL__Promotion__c()));
         controller.loadPromotionTemplates();
         system.assertNotEquals(null,controller.PromotionTemplates );
        }
    } 
    @isTest
    private static void loadPromotionTemplatesNegativeTest(){
     Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          User u = new User(Alias = 'standt', Email='standarduserTPM@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, IsActive= true,
          TimeZoneSidKey='America/Los_Angeles', UserName='standarduserTPM@testorg.com',ACCL__Sales_Org__c ='UK SO');  
          
      System.runAs(u) {    
      ACCL__Promotion_template__c template  = [SELECT Id,ACCL__Creation_Platform__c  FROM ACCL__Promotion_Template__c WHERE  ACCL__Active__c = true AND   
                                                                   ACCL__Sales_Org__c ='UK SO'  AND ACCL__Creation_Platform__c <> 'Mobility'];
        template.ACCL__Sales_Org__c  = 'AR01';
        update template  ;
        UL_CreatePromotionController controller = new UL_CreatePromotionController(new ApexPages.StandardController(new ACCL__Promotion__c()));
        controller.loadPromotionTemplates();
        system.assertEquals(0,controller.PromotionTemplates.size());
        }
    } 
    
    
    
    @isTest
    private static void savePositiveTest(){
     //user u = [select id from User limit 1];
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          User u = new User(Alias = 'standt', Email='standarduserTPM@testorg.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, IsActive= true,
          TimeZoneSidKey='America/Los_Angeles', UserName='standarduserTPM@testorg.com',ACCL__Sales_Org__c ='UK SO');  
           ACCL__Promotion_template__c template  = [SELECT Id,ACCL__Creation_Platform__c  FROM ACCL__Promotion_Template__c WHERE  ACCL__Active__c = true AND   
                                                                   ACCL__Sales_Org__c ='UK SO'  AND ACCL__Creation_Platform__c <> 'Mobility'];
           
           UL_Delivery_Profile__c profSet = [SELECT Id, UL_Sales_Organisation__c FROM UL_Delivery_Profile__c  WHERE UL_Sales_Organisation__c = 'UK SO'];
           Account acc = [select id from Account limit 1];
          
      System.runAs(u){   
        //create custom manger
            ACCL__Account_Manager__c aM = new ACCL__Account_Manager__c();
            aM.ACCL__Active__c = true;
            aM.ACCL__Valid_From__c = date.today().addDays(-1);
            aM.ACCL__Valid_Thru__c = date.today().addDays(30);
            aM.ACCL__User__c = u.id;
            aM.ACCL__Account__c = acc.id; 
            insert aM;         
            UL_CreatePromotionController controller = new UL_CreatePromotionController(new ApexPages.StandardController(new ACCL__Promotion__c()));
            controller.relatedRecord.ACCL__Promotion_Template__c = template.id;            
            controller.loadPromotionTemplates(); 
            controller.controllFieldsWithTemplates();             
            template.UL_Promo_Type_ControlView__c ='SpecialHoliday'; 
            update template;
            controller.controllFieldsWithTemplates();            
            template.UL_Promo_Type_ControlView__c ='MarketingEvent'; 
            update template;
            controller.controllFieldsWithTemplates();        
            controller.loadCustomers();
            controller.fetchingDefaultsoldto();
            controller.dafaultSoldToSet();
            controller.deliveryProfileSet();
            controller.redirectPage();
            controller.loadDeliveryProfile();            
            controller.relatedRecord.ACCL__Date_From__c = date.today();
            controller.dateThruPopulate();
            controller.save();            
            controller.relatedRecord.UL_Delivery_Profile__c = profSet.id;
            
            controller.save();
           }
    } 
    
    @isTest
    private static void updateInstoredates(){
    ACCL__Promotion__c pro = [select id,ACCL__Placement_Date_From__c from ACCL__Promotion__c limit 1];
    pro.ACCL__Placement_Date_From__c = date.today().addDays(5);
    update pro;
    }
    
     
}