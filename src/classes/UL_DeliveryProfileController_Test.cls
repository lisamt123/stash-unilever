@isTest(seeAllData = false)
public class UL_DeliveryProfileController_Test {
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
        //create planning level
        UL_Planning_Level__c ul = new UL_Planning_Level__c();
        ul.UL_Customer__c = testAccount.id;
        ul.UL_Account__c = testAccount.id;
        ul.UL_Planning_Level_Start_Date__c = date.today();
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
        delProf.UL_Valid_From__c = date.today();
        delProf.UL_Week_1_Phasing__c = 101;        
        delProf.UL_Valid_Thru__c = date.today().addDays(10);          
        insert delProf;
    }
    @isTest
    private static void savePositiveTest(){      
        UL_DeliveryProfileController controller = new UL_DeliveryProfileController(new ApexPages.StandardController(new UL_Delivery_Profile__c()));
        controller.releatedRecord.UL_Delivery_Profile_Name__c = 'Test Delivery Profile1';
        controller.releatedRecord.UL_Sales_Organisation__c = 'UK SO';
        controller.releatedRecord.UL_Week_1_Phasing__c = 101; 
        controller.releatedRecord.UL_Instore_End_days__c = 12;
        controller.shipmentEndDaysSet();
        controller.releatedRecord.UL_Valid_From__c = date.today();
        controller.validThruDateSet();
        controller.releatedRecord.UL_Shipment_Start_days__c = 10 ;
        controller.shipmentStartDaysSet();
        UL_Planning_Level__c uPLevel= [select id from UL_Planning_Level__c limit 1];
        controller.releatedRecord.UL_Planning_Level__c = uPLevel.id;        
        controller.save();    
        System.assertNotEquals(null,controller.releatedRecord.id);  
    }
    @isTest
    private static void saveNegativeTest(){      
        UL_DeliveryProfileController controller = new UL_DeliveryProfileController(new ApexPages.StandardController(new UL_Delivery_Profile__c()));
        controller.releatedRecord.UL_Delivery_Profile_Name__c = 'Test Delivery Profile2';    
        controller.releatedRecord.UL_Instore_End_days__c = 12;
        controller.shipmentEndDaysSet();
        controller.releatedRecord.UL_Valid_From__c = date.today();
        controller.validThruDateSet();
        controller.releatedRecord.UL_Shipment_Start_days__c = 10 ;
        controller.shipmentStartDaysSet();
        UL_Planning_Level__c uPLevel= [select id from UL_Planning_Level__c limit 1];
        controller.releatedRecord.UL_Planning_Level__c = uPLevel.id;        
        controller.save();   
        System.assertEquals(null,controller.releatedRecord.id); 
        
    }
    
    @isTest
    private static void saveAndNewTest(){ 
    ApexPages.currentPage().getParameters().put('saveAndNew', 'saveAndNew');       
        UL_DeliveryProfileController controller = new UL_DeliveryProfileController(new ApexPages.StandardController(new UL_Delivery_Profile__c()));
        controller.releatedRecord.UL_Delivery_Profile_Name__c = 'Test Delivery Profile3';
        controller.releatedRecord.UL_Sales_Organisation__c = 'UK SO';
        controller.releatedRecord.UL_Week_1_Phasing__c = 101; 
        controller.releatedRecord.UL_Instore_End_days__c = 12;
        controller.shipmentEndDaysSet();
        controller.releatedRecord.UL_Valid_From__c = date.today();
        controller.validThruDateSet();
        controller.releatedRecord.UL_Shipment_Start_days__c = 10 ;
        controller.shipmentStartDaysSet();
        UL_Planning_Level__c uPLevel= [select id from UL_Planning_Level__c limit 1];
        controller.releatedRecord.UL_Planning_Level__c = uPLevel.id;        
        controller.save();   
         
        
    }
    @isTest
    private static void editPositiveTest(){ 
        UL_Delivery_Profile__c profSet = [SELECT Id, UL_Sales_Organisation__c FROM UL_Delivery_Profile__c  WHERE UL_Sales_Organisation__c = 'UK SO'];
        ApexPages.currentPage().getParameters().put('Id', profSet.Id);       
        UL_DeliveryProfileController controller = new UL_DeliveryProfileController(new ApexPages.StandardController(profSet));
        controller.editDeliveryProfile();  
        System.assertNotEquals(null,controller.releatedRecord.id);  
    }
    @isTest
    private static void editNegativeTest(){ 
        UL_Delivery_Profile__c profSet = [SELECT Id, UL_Sales_Organisation__c FROM UL_Delivery_Profile__c  WHERE UL_Sales_Organisation__c = 'UK SO'];
        ApexPages.currentPage().getParameters().put('Id', profSet.Id);       
        UL_DeliveryProfileController controller = new UL_DeliveryProfileController(new ApexPages.StandardController(profSet));
        delete profSet;
        controller.editDeliveryProfile();   
        System.assertEquals(null,controller.releatedRecord.id); 
    }
    
    
    
}