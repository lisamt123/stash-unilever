/**********************************************************************
Name:  CEC_NewAccountControllerTest 
Copyright ? 2015  Unilever
======================================================================
=======================================================================
Purpose: This is the test class for the class for CEC_NewAccountController                                                                                                                      
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE            DETAIL               Description
1.0 - Pavan             21/01/2015      INITIAL DEVELOPMENT  CSR
1.1 - Sathish            Mar-2016        Code Refactoring    Included CEC_TestDataFactory
***********************************************************************/

/**
Test class for the class CEC_NewAccountCaseController
*/

@isTest(SeeAllData=true)
public without sharing class CEC_NewAccountControllerTest{
    
    private static final string acctName = 'Test Account';
    private static final string phoneNo = '0991236785';
    
    static Case insertCase1(){
        
        CRMfusionDBR101.DB_Api.preventMatching();
        cec_Org_Settings__c orgSetting =  cec_Org_Settings__c.getOrgDefaults();
        orgSetting.Local_Identifier_Special_roles__c = 'CEC User - Brazil;CEC User - Planitox Brazil;CEC Manager - Brazil';
        upsert orgSetting;
        
        
        Id rtId = [select Id, name from RecordType where name = 'Person Account' and SObjectType = 'Account' limit 1].Id;
        
        // Create Account
        Account accObj = new Account(lastname= CEC_Constants.lastName, Phone = phoneNo, PersonMailingPostalCode = CEC_Constants.PersonMailingPostalCode, PersonEmail='account_test@test00de0000000bblj.com', Local_Identifier__c = '111.222.333-12', Local_Identifier_No_Special_Char__c = '111.222.333-12');
        accObj.RecordTypeId = rtId;
        insert accObj;
        
        Account accObj2 = new Account(lastname=acctName+' 2', PersonMailingCity = 'TestCity', PersonMailingStreet = '123 Church Street', PersonMailingPostalCode =  CEC_Constants.PersonMailingPostalCode);
        accObj2.RecordTypeId = rtId;
        insert accObj2;
        
        Account accObj3 = new Account(lastname=acctName+' 3', PersonMailingCity = 'Manchester', PersonMailingStreet = '101 Greenland Street', PersonMailingPostalCode =  CEC_Constants.PersonMailingPostalCode);
        accObj2.RecordTypeId = rtId;
        insert accObj3;
        
        Account accObj4 = new Account(lastname='TestFireStorm', PersonMailingCity = 'London', PersonMailingStreet = '123 Holloway Street', PersonMailingPostalCode =  'NA12 0AB');
        accObj2.RecordTypeId = rtId;
        insert accObj4;
        
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
        Account accObj = new Account(lastname= CEC_Constants.lastName, Phone = phoneNo, PersonMailingPostalCode = CEC_Constants.PersonMailingPostalCode, PersonMailingStreet = 'George Street');
        accObj.RecordTypeId = rtId;
        insert accObj;
        
        Contact personContact = [select Id from Contact where Name =: acctName LIMIT 1];
        
        // Create Case
        Case caseObj = new Case();
        caseObj.AccountId = accObj.Id;
        caseObj.ContactId = personContact.id;
        insert caseObj;
        
        CRMfusionDBR101.DB_Api.allowMatching();
        
        return caseObj;
    }
    
    /*
Test Class to check the Fuzzy Street name + City search for CSC-4073
*/
    static testMethod void searchConsumerStreetCity() {
        User u = CEC_TestDataFactory.createStandardCECTestUser();
        System.runAs(u) {
            
            Case caseObj = insertCase1();        
            ApexPages.currentPage().getParameters().put('Id', caseObj.id); 
            CEC_NewAccountController testController= new CEC_NewAccountController();
            pageReference pr = testController.searchConsumer();
            
            //Scenario 1 - Fuzzy Street search with Matching Street(No House Number) and City
            testController.newConsumer.PersonMailingStreet = 'Holloway Street';
            testController.newConsumer.PersonMailingCity = 'London';
            pr = testController.searchConsumer();
            system.debug('testController.duplicateConsumerList.size() @@@@' + testController.duplicateConsumerList);
            System.assertEquals(null,pr);
            //System.assertEquals(1,testController.duplicateConsumerList.size());
            //System.assertEquals('123 Holloway Street',testController.duplicateConsumerList.get(0).consumer.PersonMailingStreet);
            
            //Scenario 2 - Fuzzy Street search(No House Number) with no matching city
            testController.newConsumer.PersonMailingStreet = 'Holloway Street';
            testController.newConsumer.PersonMailingCity = 'Manchester';
            pr = testController.searchConsumer();
            System.assertEquals(null,pr);
            system.debug('testController.duplicateConsumerList.size() @@@@' + testController.duplicateConsumerList);
            //System.assertEquals(0,testController.duplicateConsumerList.size());
            
            //Scenario 3 - Email + Fuzzy Street search with Matching Street (Different House Number) and City. Also to check the order of the returned results
            testController.newConsumer.PersonMailingStreet = '456 Holloway Street';
            testController.newConsumer.PersonMailingCity = 'London';
            testController.newConsumer.PersonEmail = 'account_test@test00de0000000bblj.com';
            pr = testController.searchConsumer(); 
            System.assertEquals(null,pr);
            system.debug('testController.duplicateConsumerList.size() @@@@' + testController.duplicateConsumerList);
            //System.assertEquals(2,testController.duplicateConsumerList.size());
            //System.assertEquals('account_test@test00de0000000bblj.com', testController.duplicateConsumerList.get(0).consumer.PersonEmail);
            //System.assertEquals('123 Holloway Street',testController.duplicateConsumerList.get(1).consumer.PersonMailingStreet);
        }
    }
    
    /**
Test method for Search Consumer
*/
    static testMethod void searchConsumer(){
        
        User u = CEC_TestDataFactory.createStandardCECTestUser();
        System.runAs(u) {
            
            Case caseObj = insertCase1();
            
            ApexPages.currentPage().getParameters().put('Id', caseObj.id);      
            
            // Scenario 1 - duplicates found
            
            CEC_NewAccountController testController= new CEC_NewAccountController();
            testController.newConsumer.lastname = CEC_Constants.lastName;
            testController.newConsumer.Phone = phoneNo;
            testController.newConsumer.PersonMailingPostalCode = CEC_Constants.PersonMailingPostalCode;
            testController.newConsumer.PersonMailingStreet = 'George Street';
            testController.newConsumer.PersonEmail = 'account_test@test00de0000000bblj.com';
            testController.newConsumer.Local_Identifier__c = '111.222.333-12';
            
            pageReference pr = testController.searchConsumer();
            
            System.assertEquals(null,pr);
            system.debug('testController.duplicateConsumerList.size() @@@@' + testController.duplicateConsumerList);
            //  System.assertEquals(3,testController.duplicateConsumerList.size());
            //  System.assertEquals('111.222.333-12',testController.duplicateConsumerList.get(0).consumer.Local_Identifier__c);
            
            
            // Scenario 2 - duplicates not found
            
            testController.newConsumer.PersonMailingPostalCode = 'TA10 0AC';
            
            pr = testController.searchConsumer();
            
            
            
            // Scenario 3 - LastName + Street
            
            testController.newConsumer.Lastname = acctName+' 2';
            testController.newConsumer.PersonMailingStreet = 'Greenland Street';
            
            pr = testController.searchConsumer();
            
            // Scenario 4 - Valid Postcode Search
            
            testController.newConsumer.PersonMailingPostalCode = CEC_Constants.PersonMailingPostalCode;
            
            pr = testController.searchConsumer();
            
            System.assertEquals(null,pr);
            
            // Scenario 5 - duplicates not found for Local Identifier
            
            testController.newConsumer.Local_Identifier__c = '111.222.333-44';
            
            pr = testController.searchConsumer();
        } 
    }
    
    /**
Test method for Attach Consumer to Case
*/
    static testMethod void attachConsumerToCase(){
        User u = CEC_TestDataFactory.createStandardCECTestUser();
        System.runAs(u) {
            
            Case caseObj = insertCase1();
            
            
            List<CRMfusionDBR101__Scenario__c> dsclist =  [Select Name from CRMfusionDBR101__Scenario__c limit 100];
            System.debug('~~~dsclist '  + dsclist);
            
            List<CRMfusionDBR101__Scenario_Rule__c> dsrlist =  [Select Name from CRMfusionDBR101__Scenario_Rule__c limit 100];
            System.debug('~~~dsrlist '  + dsrlist);
            
            // Scenario 1 - Choose account for a Case without Account
            
            ApexPages.currentPage().getParameters().put('Id', caseObj.id);
            CEC_NewAccountController testController= new CEC_NewAccountController();
            testController.newConsumer.lastname = CEC_Constants.lastName;
            testController.newConsumer.Phone = phoneNo;
            testController.newConsumer.PersonMailingPostalCode = CEC_Constants.PersonMailingPostalCode;
            testController.newConsumer.Local_Identifier__c = '111.222.333-44';
            
            pageReference pr = testController.searchConsumer();
            
            testController.selectedAccountId = testController.duplicateConsumerList.get(0).consumer.Id;
            pr = testController.chooseAccount();
            
            System.assertEquals(null,pr);
            
            
            // Scenario 2 - Choose account for a Case with Account
            
            ApexPages.currentPage().getParameters().put('Id', caseObj.id);
            testController = new CEC_NewAccountController();
            testController.newConsumer.lastname = CEC_Constants.lastName;
            testController.newConsumer.Phone = phoneNo;
            testController.newConsumer.PersonMailingPostalCode = CEC_Constants.PersonMailingPostalCode;
            pr = testController.searchConsumer();
            testController.selectedAccountId = testController.duplicateConsumerList.get(0).consumer.Id;
            pr = testController.chooseAccount();
            
            System.assertEquals(null,pr);
        }
    }
    
    /**
Test method for Save Consumer
*/  
    static testMethod void saveConsumer(){
        
        User u = CEC_TestDataFactory.createStandardCECTestUser();
        System.runAs(u) {
            
            Case caseObj = insertCase1();
            
            // Scenario 1 - Save account and attach it to a Case
            
            ApexPages.currentPage().getParameters().put('Id', caseObj.id);
            CEC_NewAccountController testController = new CEC_NewAccountController();
            
            testController.newConsumer.lastname = CEC_Constants.lastName;
            testController.newConsumer.Phone = phoneNo;
            testController.newConsumer.PersonMailingPostalCode = 'TA10 0AC';
            testController.newConsumer.Local_Identifier__c = '111.222.333-44';
            
            testController.getSalutation();
            testController.back();
            pageReference pr = testController.saveAccount();
            
            System.assertEquals(null,pr);
            
            // Scenario 2 - Save account and override it to a Case which already has an account
            
            ApexPages.currentPage().getParameters().put('Id', caseObj.id);
            testController = new CEC_NewAccountController();
            testController.newConsumer.lastname = CEC_Constants.lastName;
            testController.newConsumer.Phone = phoneNo;
            testController.newConsumer.PersonMailingPostalCode = 'TA10 0AC';
            
            pr = testController.saveAccount();
            
            System.assertEquals(null,pr);
        }
    }
    
    /**
Test method for Rollback Save
*/
    static testMethod void rollbackSave(){
        User u = CEC_TestDataFactory.createStandardCECTestUser();
        System.runAs(u) {
            Case caseObj = insertCase2();
            
            Boolean result = CEC_NewAccountController.rollbackSave(caseObj.id);
            System.assertEquals(true,result);
            
            result = CEC_NewAccountController.rollbackSave(null);
            System.assertEquals(false,result);
        }
    }
}