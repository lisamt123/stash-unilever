/***************************************************************
Name: UL_CannibalisationRateControllerTest
Copyright © 2016 Salesforce
======================================================
Purpose:
Test Class for UL_CannibalisationRateController
======================================================
History
-------
VERSION     AUTHOR         DATE             DETAIL                 Description
1.0         Omkar Narkar    27/12/2016       Initial Development   Test Class for UL_CannibalisationRateController
***************************************************************/
@isTest
public class UL_CannibalisationRateControllerTest{
    
    //Test metup method to setup user data
    @testSetup
    private static void userData(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        //Create user
        User u = new User(Alias = 'standt', 
                          Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', 
                          LastName='Testing', 
                          LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', 
                          ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', 
                          UserName='standarduserUKSO@testorg.com',
                          ACCL__Sales_Org__c ='UK SO');
        insert u;
    }
    
    //Test metup method to setup existing Cannibalisation Rate Records
    @testSetup
    private static void setupExistingRecords(){
        //Inserting Account Template
        Id custTemplateRecordTypeId = Schema.SObjectType.ACCL__Account_Template__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        ACCL__Account_Template__c newAccountTemplate = new ACCL__Account_Template__c(
            RecordTypeId = custTemplateRecordTypeId,
            Name = 'Account Template_UK_SO',
            ACCL__Initial_Roles__c = 'customer',
            ACCL__Active__c = True,
            ACCL__Description_Language_1__c = 'Account Template_UK_SO',
            ACCL__Sales_Org__c = 'UK SO');
        Database.Insert(newAccountTemplate);
        
        //Inserting Account
        Account newAccount = new Account(
            Name = 'Account 1 AR01',
            ACCL__Account_Number__c = '100000',
            ACCL__Account_Template__c = newAccountTemplate.Id,
            ACCL__Name_2__c = 'Test Name 2',
            UL_Sales_Organization__c = 'AR01',
            UL_Customer_Hierarchy_Level__c = 'Level 7'
        );
        Database.Insert(newAccount);
        
        //Inserting Planning level
        UL_Planning_Level__c newPlaningLevel = new UL_Planning_Level__c(
            Name = newAccount.Name,
            UL_Customer__c = newAccount.Id,
            UL_Planning_Level_Start_Date__c = Date.today(),
            UL_Planning_Level_End_Date__c = Date.today(),
            UL_Sales_Organisation__c = 'UKI'
        );
        Database.insert(newPlaningLevel);
        
        //Prepare product template
        ACCL__Product_Template__c productTemplate = new ACCL__Product_Template__c();
        productTemplate.Name = 'Test Product Template';
        productTemplate.ACCL__Active__c = true;
        productTemplate.ACCL__Sales_Org__c = 'UK SO';
        productTemplate.ACCL__Description_Language_1__c = 'English';
        insert productTemplate;
        
        //Prepare a product to insert
        ACCL__Product__c product = new ACCL__Product__c();
        product.Name = 'Test Product';
        product.ACCL__Product_Template__c = productTemplate.id;
        product.ACCL__Product_Level__c = 'Commodity';
        product.ACCL__Product_Code__c = '99999';
        insert product;
    }
    
    //Test method for positive test scenario
    @isTest
    private static void cannibalisationControllerPositiveTest(){
        
        Account testAccount = [SELECT Id FROM Account limit 1];
        
        ACCL__Product__c testProduct = [SELECT Id FROM ACCL__Product__c limit 1];
        
        UL_Planning_Level__c planningLevel = [SELECT Id FROM UL_Planning_Level__c LIMIT 1];
        
        UL_CannibalisationRateController cannibCtrl = new UL_CannibalisationRateController(new ApexPages.StandardController(new UL_Cannibalisation_Rate__c()));
        cannibCtrl.record.UL_Valid_From__c = Date.today();
        cannibCtrl.updateThruDate();
        cannibCtrl.record.UL_Cannibalisation_Rate__c = 10;
        cannibCtrl.record.UL_Sales_Organization__c = 'UK SO';
        cannibCtrl.saveNew();
    }
    
    //Test method for negative test scenario
    @isTest
    private static void cannibalisationControllerNegativeTest(){
        
        Account testAccount = [SELECT Id FROM Account limit 1];
        
        ACCL__Product__c testProduct = [SELECT Id FROM ACCL__Product__c limit 1];
        
        UL_Planning_Level__c planningLevel = [SELECT Id FROM UL_Planning_Level__c LIMIT 1];
        
        UL_CannibalisationRateController cannibCtrl = new UL_CannibalisationRateController(new ApexPages.StandardController(new UL_Cannibalisation_Rate__c()));
        cannibCtrl.record.UL_Valid_From__c = NULL;
        cannibCtrl.updateThruDate();
        cannibCtrl.record.UL_Cannibalisation_Rate__c = 10;
        cannibCtrl.record.UL_Sales_Organization__c = 'UK SO1';
        cannibCtrl.saveNew();
    }
}