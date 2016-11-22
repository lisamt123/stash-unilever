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
        Test.StartTest();
        Account varAccount =new Account(name = 'Account name',CurrencyIsoCode='USD');
        Test.setCurrentPageReference(new PageReference('Page.FS_CreateContact')); 
        System.currentPageReference().getParameters().put('id', varAccount.id);
        FS_CreateContact_CC tempobj = new FS_CreateContact_CC();
        Test.StopTest();
        tempobj.varContactDetail.firstname='test first';
        tempobj.varContactDetail.lastname='test Last';
        tempobj.varContactDetail.Email='dinesh@gmail.com';
        tempobj.varContactDetail.phone='9738266192';
        tempobj.varContactDetail.MailingState='haryana';
        tempobj.varContactDetail.FS_Position__c='Buyer';
        tempobj.varContactDetail.OwnerID=UserInfo.getUserId();
        tempobj.varContactDetail.AccountId=varAccount.id;
        tempobj.varContactDetail.MailingStreet='street';
        tempobj.varContactDetail.mailingcity='Narwana';
        tempobj.varContactDetail.MailingPostalCode='126116';
        tempobj.varContactDetail.MailingCountry='India';
        tempobj.createContact();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(varAccount);
        FS_ContactExtend_CX instance = new FS_ContactExtend_CX(sc);
        instance.createContact();
        Contact varContact=new Contact();
        varContact.lastname='test';
        insert varContact;
        instance.varContactIdForDeletion=varContact.id;
        instance.deleteContact();
        instance.deleteContact();  
        System.assert(varContact.lastname <> null);
        FS_ContactExtend_CX varContactExtend = new FS_ContactExtend_CX();
        varContactExtend.createContact(); 
    }  
}
