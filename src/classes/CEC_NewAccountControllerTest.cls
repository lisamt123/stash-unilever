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
    static Case insertCase1(){
        
        CRMfusionDBR101.DB_Api.preventMatching();
        
        Id rtId = [select Id, name from RecordType where name = 'Person Account' and SObjectType = 'Account' limit 1].Id;
        
        // Create Account
<<<<<<< HEAD
        Account accObj = new Account(lastname='Test Account', Phone = '0991236785', PersonMailingPostalCode = 'TA10 0AB');
        accObj.RecordTypeId = rtId;
        insert accObj;
=======
        Account accObj = new Account(lastname='Test Account', Phone = '0991236785', PersonMailingPostalCode = 'TA10 0AB', PersonEmail='test@test.com');
        accObj.RecordTypeId = rtId;
        insert accObj;

        Account accObj2 = new Account(lastname='Test Account 2', PersonMailingStreet = 'Greenland Street', PersonMailingPostalCode =  'TA10 0AB');
        accObj2.RecordTypeId = rtId;
        insert accObj2;
>>>>>>> FETCH_HEAD
        
        // Create Case
        Case caseObj = new Case();
        insert caseObj;
        
        return caseObj;
    }
    
    /**
        Insert Account, Case Objects and attach Account to Case Obj.
    */
    static Case insertCase2(){
        
        CRMfusionDBR101.DB_Api.preventMatching();
        
        Id rtId = [select Id, name from RecordType where name = 'Person Account' and SObjectType = 'Account' limit 1].Id;
        
        // Create Account
<<<<<<< HEAD
        Account accObj = new Account(lastname='Test Account', Phone = '0991236785', PersonMailingPostalCode = 'TA10 0AB');
=======
        Account accObj = new Account(lastname='Test Account', Phone = '0991236785', PersonMailingPostalCode = 'TA10 0AB', PersonMailingStreet = 'George Street');
>>>>>>> FETCH_HEAD
        accObj.RecordTypeId = rtId;
        insert accObj;
        
        Contact personContact = [select Id from Contact where Name = 'Test Account' LIMIT 1];
    
        // Create Case
        Case caseObj = new Case();
        caseObj.AccountId = accObj.Id;
        caseObj.ContactId = personContact.id;
        insert caseObj;
        
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
<<<<<<< HEAD
=======
        testController.newConsumer.PersonMailingStreet = 'George Street';
        testController.newConsumer.PersonEmail = 'test@test.com';
>>>>>>> FETCH_HEAD
        
        pageReference pr = testController.searchConsumer();
    
        System.assertEquals(null,pr);

        // Scenario 2 - duplicates not found
        
        testController.newConsumer.PersonMailingPostalCode = 'TA10 0AC';

        pr = testController.searchConsumer();

<<<<<<< HEAD
=======
         // Scenario 3 - LastName + Street
        
        testController.newConsumer.Lastname = 'Test Account 2';
        testController.newConsumer.PersonMailingStreet = 'Greenland Street';

        pr = testController.searchConsumer();

        // Scenario 4 - Valid Postcode Search
        
        testController.newConsumer.PersonMailingPostalCode = 'TA10 0AB';

        pr = testController.searchConsumer();

>>>>>>> FETCH_HEAD
        System.assertEquals(null,pr);
        
    }
    
    /**
        Test method for Attach Consumer to Case
    */
    static testMethod void attachConsumerToCase(){

        Case caseObj = insertCase1();

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