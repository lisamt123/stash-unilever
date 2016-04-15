/**********************************************************************
 Name:  CEC_Test_NewAccountController 
 Copyright ? 2015  Unilever
 ======================================================================
=======================================================================
Purpose: This is the test class for the class for CEC_Test_NewAccountController                                                                                                                      
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE            DETAIL               Description
   1.0 - Pavan             21/01/2015      INITIAL DEVELOPMENT  CSR
   
***********************************************************************/

/**
Test class for the class CEC_NewAccountCaseController
*/

@isTest(SeeAllData=true)
public without sharing class CEC_NewAccountControllerTest{
       
    /**
        Insert Account and Case Objects
    */
    /**static void dupeTest(){     
CRMfusionDBR101__Scenario__c dsc1 = new CRMfusionDBR101__Scenario__c();
dsc1.Name = 'CEC_ConsumerComponent_Phone';
dsc1.CRMfusionDBR101__Scenario_Type__c = 'Account';
dsc1.CRMfusionDBR101__Match_on_Insert_Action__c = 'Report Duplicate';
dsc1.CRMfusionDBR101__Match_on_Update_Action__c = 'Report Duplicate';
dsc1.CRMfusionDBR101__Create_Task__c = 'Yes-Current User';
dsc1.CRMfusionDBR101__Deployed__c = true;
dsc1.CRMfusionDBR101__Person_Account_Scenario__c = true;
dsc1.CRMfusionDBR101__Rebuild_Needed__c =false;
insert dsc1;
System.debug('DSC1'+dsc1);

CRMfusionDBR101__Scenario_Rule__c dsr1 = new CRMfusionDBR101__Scenario_Rule__c();
dsr1.CRMfusionDBR101__Mapping_Type__c = 'Regular Expression';
dsr1.CRMfusionDBR101__Scenario_Type__c = 'Account';
dsr1.CRMfusionDBR101__Match_Field__c = 'Phone No Special Char';
dsr1.CRMfusionDBR101__Regex__c = '[0-9]{6}$';
dsr1.CRMfusionDBR101__Scenario__c = dsc1.id;
 insert dsr1;
 System.debug('DSR1'+dsr1);
 
CRMfusionDBR101__Scenario__c dsc2 = new CRMfusionDBR101__Scenario__c();
dsc2.Name = 'CEC_ConsumerComponent_Email';
dsc2.CRMfusionDBR101__Scenario_Type__c = 'Account';
dsc2.CRMfusionDBR101__Match_on_Insert_Action__c = 'Do Not Insert';
dsc2.CRMfusionDBR101__Match_on_Update_Action__c = 'Report Duplicate';
dsc2.CRMfusionDBR101__Create_Task__c = 'No';
dsc2.CRMfusionDBR101__Deployed__c = true;
dsc2.CRMfusionDBR101__Person_Account_Scenario__c = true;
dsc2.CRMfusionDBR101__Rebuild_Needed__c = false;
dsc2.CRMfusionDBR101__Error_Message__c ='Duplicate Consumer found with the same Email';
insert dsc2;
System.debug('DSC2'+dsc2);

CRMfusionDBR101__Scenario_Rule__c dsr2 = new CRMfusionDBR101__Scenario_Rule__c();
dsr2.CRMfusionDBR101__Mapping_Type__c = 'Exact';
dsr2.CRMfusionDBR101__Scenario_Type__c = 'Account';
dsr2.CRMfusionDBR101__Match_Field__c = 'Email';
dsr2.CRMfusionDBR101__Scenario__c = dsc2.id;
 insert dsr2;
 System.debug('DSR2'+dsr2);
 
CRMfusionDBR101__Scenario__c dsc3 = new CRMfusionDBR101__Scenario__c();
dsc3.Name = 'CEC_ConsumerComponent_Lastname_Street';
dsc3.CRMfusionDBR101__Scenario_Type__c = 'Account';
dsc3.CRMfusionDBR101__Match_on_Insert_Action__c = 'Do Nothing';
dsc3.CRMfusionDBR101__Match_on_Update_Action__c = 'Do Nothing';
dsc3.CRMfusionDBR101__Create_Task__c = 'No';
dsc3.CRMfusionDBR101__Deployed__c = true;
dsc3.CRMfusionDBR101__Person_Account_Scenario__c = true;
dsc3.CRMfusionDBR101__Rebuild_Needed__c = false;
insert dsc3;
System.debug('DSC3'+dsc3);

CRMfusionDBR101__Scenario_Rule__c dsr3 = new CRMfusionDBR101__Scenario_Rule__c();
dsr3.CRMfusionDBR101__Mapping_Type__c = 'Relaxed Street Address Match';
dsr3.CRMfusionDBR101__Scenario_Type__c = 'Account';
dsr3.CRMfusionDBR101__Match_Field__c = 'Mailing Street';
dsr3.CRMfusionDBR101__Scenario__c = dsc3.id;
 insert dsr3;
 System.debug('DSR3'+dsr3);
 
CRMfusionDBR101__Scenario_Rule__c dsr4 = new CRMfusionDBR101__Scenario_Rule__c();
dsr4.CRMfusionDBR101__Mapping_Type__c = 'Exact';
dsr4.CRMfusionDBR101__Scenario_Type__c = 'Account';
dsr4.CRMfusionDBR101__Match_Field__c = 'Last Name';
dsr4.CRMfusionDBR101__Scenario__c = dsc3.id;
 insert dsr4;
  System.debug('DSR4'+dsr4);
 
CRMfusionDBR101__Scenario__c dsc4 = new CRMfusionDBR101__Scenario__c();
dsc4.Name = 'CEC_ConsumerComponent_Phone_One_WS';
dsc4.CRMfusionDBR101__Scenario_Type__c = 'Account';
dsc4.CRMfusionDBR101__Match_on_Insert_Action__c = 'Do Nothing';
dsc4.CRMfusionDBR101__Match_on_Update_Action__c = 'Do Nothing';
dsc4.CRMfusionDBR101__Create_Task__c = 'No';
dsc4.CRMfusionDBR101__Deployed__c = false;
dsc4.CRMfusionDBR101__Person_Account_Scenario__c = true;
dsc4.CRMfusionDBR101__Rebuild_Needed__c =false;
insert dsc4;
 System.debug('DSC4'+dsc4);

CRMfusionDBR101__Scenario_Rule__c dsr5 = new CRMfusionDBR101__Scenario_Rule__c();
dsr5.CRMfusionDBR101__Mapping_Type__c = 'Relaxed NA Phone Match';
dsr5.CRMfusionDBR101__Scenario_Type__c = 'Account';
dsr5.CRMfusionDBR101__Match_Field__c = 'Account Phone';
dsr5.CRMfusionDBR101__Scenario__c = dsc4.id;
 insert dsr5;
  System.debug('DSR5'+dsr5);
 
CRMfusionDBR101__Scenario__c dsc5 = new CRMfusionDBR101__Scenario__c();
dsc5.Name = 'CEC_ConsumerComponent_PostalCode';
dsc5.CRMfusionDBR101__Scenario_Type__c = 'Account';
dsc5.CRMfusionDBR101__Match_on_Insert_Action__c = 'Do Nothing';
dsc5.CRMfusionDBR101__Match_on_Update_Action__c = 'Do Nothing';
dsc5.CRMfusionDBR101__Create_Task__c = 'No';
dsc5.CRMfusionDBR101__Deployed__c = true;
dsc5.CRMfusionDBR101__Person_Account_Scenario__c = true;
dsc5.CRMfusionDBR101__Rebuild_Needed__c =false;
insert dsc5;
 System.debug('DSC5'+dsc5);

CRMfusionDBR101__Scenario_Rule__c dsr6 = new CRMfusionDBR101__Scenario_Rule__c();
dsr6.CRMfusionDBR101__Mapping_Type__c = 'Exact';
dsr6.CRMfusionDBR101__Scenario_Type__c = 'Account';
dsr6.CRMfusionDBR101__Match_Field__c = 'Mailing Zip/Postal Code';
dsr6.CRMfusionDBR101__Scenario__c = dsc5.id;
 insert dsr6;
  System.debug('DSR6'+dsr6);
 }*/

    static Case insertCase1(){
        
        CRMfusionDBR101.DB_Api.preventMatching();
        
        Id rtId = [select Id, name from RecordType where name = 'Person Account' and SObjectType = 'Account' limit 1].Id;
        
        // Create Account
        Account accObj = new Account(lastname='Test Account', Phone = '0991236785', PersonMailingPostalCode = 'TA10 0AB', PersonEmail='account_test@test00DE0000000bbLj.com');
        accObj.RecordTypeId = rtId;
        insert accObj;

        Account accObj2 = new Account(lastname='Test Account 2', PersonMailingStreet = 'Greenland Street', PersonMailingPostalCode =  'TA10 0AB');
        accObj2.RecordTypeId = rtId;
        insert accObj2;
        
        // Create Case
        Case caseObj = new Case();
        insert caseObj;
        
        CRMfusionDBR101.DB_Api.allowMatching();
        
        return caseObj;
    }
    
    /**
        Insert Account, Case Objects and attach Account to Case Obj.
    */
    static Case insertCase2(){
        
        CRMfusionDBR101.DB_Api.preventMatching();
        
        Id rtId = [select Id, name from RecordType where name = 'Person Account' and SObjectType = 'Account' limit 1].Id;
        
        // Create Account
        Account accObj = new Account(lastname='Test Account', Phone = '0991236785', PersonMailingPostalCode = 'TA10 0AB', PersonMailingStreet = 'George Street');
        accObj.RecordTypeId = rtId;
        insert accObj;
        
        Contact personContact = [select Id from Contact where Name = 'Test Account' LIMIT 1];
    
        // Create Case
        Case caseObj = new Case();
        caseObj.AccountId = accObj.Id;
        caseObj.ContactId = personContact.id;
        insert caseObj;
        
        CRMfusionDBR101.DB_Api.allowMatching();
        
        return caseObj;
    }
    
    /**
        Test method for Search Consumer
    */
    static testMethod void searchConsumer(){
    
        Case caseObj = insertCase1();
        
        ApexPages.currentPage().getParameters().put('Id', caseObj.id);      
        
        // Scenario 1 - duplicates found
        
        CEC_NewAccountController testController= new CEC_NewAccountController();
        testController.newConsumer.lastname = 'Test Account';
        testController.newConsumer.Phone = '0991236785';
        testController.newConsumer.PersonMailingPostalCode = 'TA10 0AB';
        testController.newConsumer.PersonMailingStreet = 'George Street';
        testController.newConsumer.PersonEmail = 'account_test@test00DE0000000bbLj.com';
        
        pageReference pr = testController.searchConsumer();
    
        System.assertEquals(null,pr);

        // Scenario 2 - duplicates not found
        
        testController.newConsumer.PersonMailingPostalCode = 'TA10 0AC';

        pr = testController.searchConsumer();

         // Scenario 3 - LastName + Street
        
        testController.newConsumer.Lastname = 'Test Account 2';
        testController.newConsumer.PersonMailingStreet = 'Greenland Street';

        pr = testController.searchConsumer();

        // Scenario 4 - Valid Postcode Search
        
        testController.newConsumer.PersonMailingPostalCode = 'TA10 0AB';

        pr = testController.searchConsumer();

        System.assertEquals(null,pr);
        
    }
    
    /**
        Test method for Attach Consumer to Case
    */
    static testMethod void attachConsumerToCase(){

        Case caseObj = insertCase1();
        
        
        List<CRMfusionDBR101__Scenario__c> dsclist =  [Select Name from CRMfusionDBR101__Scenario__c];
        System.debug('~~~dsclist '  + dsclist);
        
        List<CRMfusionDBR101__Scenario_Rule__c> dsrlist =  [Select Name from CRMfusionDBR101__Scenario_Rule__c];
        System.debug('~~~dsrlist '  + dsrlist);
        
        // Scenario 1 - Choose account for a Case without Account

        ApexPages.currentPage().getParameters().put('Id', caseObj.id);
        CEC_NewAccountController testController= new CEC_NewAccountController();
        testController.newConsumer.lastname = 'Test Account';
        testController.newConsumer.Phone = '0991236785';
        testController.newConsumer.PersonMailingPostalCode = 'TA10 0AB';
        
        pageReference pr = testController.searchConsumer();
        testController.selectedAccountId = testController.duplicateConsumerList.get(0).consumer.Id;
        pr = testController.chooseAccount();

        System.assertEquals(null,pr);

        // Scenario 2 - Choose account for a Case with Account

        ApexPages.currentPage().getParameters().put('Id', caseObj.id);
        testController = new CEC_NewAccountController();
        testController.newConsumer.lastname = 'Test Account';
        testController.newConsumer.Phone = '0991236785';
        testController.newConsumer.PersonMailingPostalCode = 'TA10 0AB';
        pr = testController.searchConsumer();
        testController.selectedAccountId = testController.duplicateConsumerList.get(0).consumer.Id;
        pr = testController.chooseAccount();

        System.assertEquals(null,pr);
    }

    /**
        Test method for Save Consumer
    */  
    static testMethod void saveConsumer(){

        Case caseObj = insertCase1();

        // Scenario 1 - Save account and attach it to a Case
        
        ApexPages.currentPage().getParameters().put('Id', caseObj.id);
        CEC_NewAccountController testController = new CEC_NewAccountController();
        
        testController.newConsumer.lastname = 'Test Account';
        testController.newConsumer.Phone = '0991236785';
        testController.newConsumer.PersonMailingPostalCode = 'TA10 0AC';
        
        pageReference pr = testController.saveAccount();
        
        System.assertEquals(null,pr);

        // Scenario 2 - Save account and override it to a Case which already has an account
        
        ApexPages.currentPage().getParameters().put('Id', caseObj.id);
        testController = new CEC_NewAccountController();
        testController.newConsumer.lastname = 'Test Account';
        testController.newConsumer.Phone = '0991236785';
        testController.newConsumer.PersonMailingPostalCode = 'TA10 0AC';
        
        pr = testController.saveAccount();
        
        System.assertEquals(null,pr);
    }
    
    /**
        Test method for Rollback Save
    */
    static testMethod void rollbackSave(){
        
        Case caseObj = insertCase2();
        
        Boolean result = CEC_NewAccountController.rollbackSave(caseObj.id);
        System.assertEquals(true,result);

        result = CEC_NewAccountController.rollbackSave(null);
        System.assertEquals(false,result);
    }
    
}