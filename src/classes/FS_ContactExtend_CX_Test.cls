/**********************************************************************
Name: FS_ContactExtend_CE_Test
======================================================
======================================================
Purpose: Test class for Contact detail controller class
-------
======================================================
======================================================
History
-------
VERSION AUTHOR     DATE        DETAIL Description
1.0     Dinesh 27/07/2016 INITIAL DEVELOPMENT 
***********************************************************************/

@istest
public class FS_ContactExtend_CX_Test{

    public static testMethod void FS_ContactExtend_CE_TestMethod() {
      Account varAccount =new Account(name = 'Account name',CurrencyIsoCode='USD');
        /* Account varAccount =new Account();
          varAccount.name='Account name';
          varAccount.CurrencyIsoCode='USD';
          insert varAccount; 
        */
     
        Test.setCurrentPageReference(new PageReference('Page.FS_CreateContact')); 
    System.currentPageReference().getParameters().put('id', varAccount.id);
   // String testLbl = Label.FS_ClientSecretKey;
    FS_CreateContact_CC tempobj = new FS_CreateContact_CC();
    
        tempobj.varContactDetail.firstname='test first';
        tempobj.varContactDetail.lastname='test Last';
        tempobj.varContactDetail.Email='dinesh@gmail.com';
        tempobj.varContactDetail.phone='9738266192';
        tempobj.varContactDetail.MailingState='haryana';
        tempobj.varContactDetail.FS_Position__c='Buyer';
        tempobj.varContactDetail.OwnerID=UserInfo.getUserId();
        //tempobj.varContactDetail.Owner.name=UserInfo.getName();
        tempobj.varContactDetail.AccountId=varAccount.id;
       // tempobj.varContactDetail.Account.Name=a.name;
        tempobj.varContactDetail.MailingStreet='street';
        tempobj.varContactDetail.mailingcity='Narwana';
        tempobj.varContactDetail.MailingPostalCode='126116';
        tempobj.varContactDetail.MailingCountry='India';
        tempobj.createContact();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(varAccount);
      //  FS_ContactExtend_CX controller = new FS_ContactExtend_CX();
        FS_ContactExtend_CX instance = new FS_ContactExtend_CX(sc);
        instance.createContact();
        
        Contact varContact=new Contact();
        
        varContact.lastname='test';
        insert varContact;
        instance.varContactIdForDeletion=varContact.id;
        instance.deleteContact();
       
        instance.deleteContact();
        
}
    
    public static testMethod void FS_ContactExtend_CE_TestMethod1() {
      // Account varAccount =new Account(name = 'Account name',CurrencyIsoCode='USD');
        Account acc = new Account();
          //varAccount.name='Account name';
          //varAccount.CurrencyIsoCode='USD';
          //insert varAccount; 
        
     
       // Test.setCurrentPageReference(new PageReference('Page.FS_CreateContact')); 
    //System.currentPageReference().getParameters().put('id', varAccount.id);
   // String testLbl = Label.FS_ClientSecretKey;
    /*FS_CreateContact_CC tempobj = new FS_CreateContact_CC();
    
        tempobj.varContactDetail.firstname='test first';
        tempobj.varContactDetail.lastname='test Last';
        tempobj.varContactDetail.Email='dinesh@gmail.com';
        tempobj.varContactDetail.phone='9738266192';
        tempobj.varContactDetail.MailingState='haryana';
        tempobj.varContactDetail.FS_Position__c='Buyer';
        tempobj.varContactDetail.OwnerID=UserInfo.getUserId();
        //tempobj.varContactDetail.Owner.name=UserInfo.getName();
        tempobj.varContactDetail.AccountId=varAccount.id;
       // tempobj.varContactDetail.Account.Name=a.name;
        tempobj.varContactDetail.MailingStreet='street';
        tempobj.varContactDetail.mailingcity='Narwana';
        tempobj.varContactDetail.MailingPostalCode='126116';
        tempobj.varContactDetail.MailingCountry='India';
        tempobj.createContact();*/
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        //FS_ContactExtend_CE controller = new FS_ContactExtend_CE();
        FS_ContactExtend_CX instance = new FS_ContactExtend_CX(sc);
        instance.createContact();
}
    
}