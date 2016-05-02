/**********************************************************************
 Name:  CEC_Test_NewAccountCaseController 
 Copyright © 2014  Unilever
 ======================================================================
=======================================================================
Purpose: This is the test class for the class for CEC_NewAccountCaseController                                                                                                                      
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE            DETAIL               Description
   1.0 - Shashank            21/10/2014      INITIAL DEVELOPMENT  CSR
 
***********************************************************************/

/**
Test class for the class CEC_NewAccountCaseController
*/

@isTest(SeeAllData=false)
public without sharing class CEC_Test_NewAccountCaseController{

/*static testMethod void testCC () {


    Id rtId = [select Id, name from RecordType where name = 'Person Account' and SObjectType = 'Account' limit 1].Id;
    

    //create account
    Account acc = new Account(lastname='Test Account');
    acc.RecordTypeId=rtId;
    //enter details  
    //acc.Name = 'Test Account';  
   try {
    insert acc;
   } catch (DmlException e) {           
            //Assert Error Message 
            System.assert( e.getMessage().contains('Insert failed'), e.getMessage() );           
           
    }
    
    Contact personContact = [select Id,LastName,Email,FirstName,Phone,MailingStreet,MailingCity,MailingPostalCode,MailingState,MailingCountry from Contact where Name = 'Test Account'];

    //create case
    Case c = new Case();
    //enter details
    c.AccountId = acc.Id;
    c.ContactId = personContact.id;
   
    c.Type = 'My Type';
    c.Origin = 'My Origin';
    c.Status = 'My Status';
    
    try{
    insert c;
    } catch (DmlException e) {           
            //Assert Error Message 
            System.assert( e.getMessage().contains('Insert failed'), e.getMessage() );           
           
    }
    Case c1= new Case();
    c1.ContactId=personContact.id;
    c1.Type='My Type1';
    c1.Origin='uu';
    c1.Status='My Status1';
    
    ApexPages.StandardController std=new ApexPages.StandardController(personContact);
    ApexPages.currentPage().getParameters().put('recordPreviewID',acc.id);
    ApexPages.currentPage().getParameters().put('acceptAccountID',acc.id);
  
    CEC_NewAccountCaseController testController= new CEC_NewAccountCaseController(std);
    Case caseNewTest=new Case();
    caseNewTest.ContactId=personContact.id;
    caseNewTest.Type='My Type1';
    caseNewTest.Origin='uu';
    caseNewTest.Status='';
    //insert caseNewTest;
    testController.newCase=caseNewTest;
    //New Consumer
    Contact conNewTest=new Contact();
    conNewTest.LastName='sample';
    conNewTest.Email='sample@sample.com';
    testController.newConsumer=conNewTest;    
    testController.buttonEnable=true;
    
    testController.searchConsumer();
    testController.newCase=c1;
    testController.accId=acc.id;
    testController.proceed();
    testController.populateRecordPreviewID();
    
    CEC_NewAccountCaseController.ConsumerWrapper  testConWrapper= new CEC_NewAccountCaseController.ConsumerWrapper('Sample',acc);
    Map<Id, CEC_NewAccountCaseController.ConsumerWrapper> testMapWrapper= new Map<Id, CEC_NewAccountCaseController.ConsumerWrapper>();
    testMapWrapper.put(personContact.id,testConWrapper);
    testController.duplicateConsumers.put(acc.id,testConWrapper);
    testController.acceptAccount();
    testController.cancelPage();    
    
    CEC_NewAccountCaseController testController1= new CEC_NewAccountCaseController(std);
    Case caseNewTest1=new Case();
    caseNewTest1.ContactId=personContact.id;
    caseNewTest1.Type='My Type1';
    caseNewTest1.Origin='aa';
    caseNewTest1.Status='uu';
    //insert caseNewTest;
    testController1.newCase=caseNewTest1;
    Contact conSamp=new Contact();
    conSamp.LastName=null;
    conSamp.Email=null;
    testController1.newConsumer=conSamp;   
    testController1.searchConsumer(); 
    
    CEC_NewAccountCaseController testController10= new CEC_NewAccountCaseController(std);
    Case caseNewTest10=new Case();
    caseNewTest10.ContactId=personContact.id;
    caseNewTest10.Type='My Type1';
    caseNewTest10.Origin='aa';
    caseNewTest10.Status='uu';
    //insert caseNewTest;
    testController10.newCase=caseNewTest10;
    Contact conSamp10=new Contact();
    conSamp10.LastName='sample';
    conSamp10.Email='sample@sample.com';
    
    testController10.newConsumer=conSamp10;   
    testController10.searchConsumer(); 
    
    
    CEC_NewAccountCaseController testController11= new CEC_NewAccountCaseController(std);
    Contact conSamp11=new Contact();
    conSamp11.LastName=null;
    conSamp11.Email='sample@sample.com';
    testController11.newConsumer=conSamp11;   
    testController11.searchConsumer(); 
    
    CEC_NewAccountCaseController testController12= new CEC_NewAccountCaseController(std);
    Contact conSamp12=new Contact();
    conSamp12.LastName='sample';
    conSamp12.Email=null;
    testController12.newConsumer=conSamp12;
       
    testController12.searchConsumer(); 
    
    }*/
}