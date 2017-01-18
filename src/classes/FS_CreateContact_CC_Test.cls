/**********************************************************************
Name: FS_CreateContact_CC_Test
======================================================
======================================================
Purpose: Test class for Contact detail controller class
-------
======================================================
======================================================
History
-------
VERSION AUTHOR     DATE        DETAIL Description
1.0     Dinesh 27/08/2016 INITIAL DEVELOPMENT 
***********************************************************************/

@istest
public class FS_CreateContact_CC_Test{
    public static testMethod void FS_CreateContact_CC_TestMethod() {
        
        Test.StartTest();
        Account varAccount =new Account();
        varAccount.name='Account name';
        varAccount.CurrencyIsoCode='USD';
        insert varAccount; 
        contact con = new contact();
        con.FirstName = 'test';
        con.LastName = 'Last';
        con.AccountId = varAccount.id;
        con.FS_RefId__c = '86fda35a-3d3f-4e49-a6aa-bcc5779f1e17';
        con.FS_PIEncryptKey__c = 'Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264=';
        insert con;
        Test.StopTest();   
        
        FS_CreateContact_CC.FS_SiteLead varSiteLead = new FS_CreateContact_CC.FS_SiteLead();
        varSiteLead.Firstname ='Firstname'; 
        varSiteLead.Surname ='lastname'; 
        varSiteLead.Email ='test@test.com'; 
        varSiteLead.Phone ='113452'; 
        varSiteLead.Address ='abc'; 
        varSiteLead.City ='Hyd'; 
        varSiteLead.BusinessPostalCode ='1234'; 
        varSiteLead.Country='US'; 
        
        
        Test.setCurrentPageReference(new PageReference('Page.FS_CreateContact')); 
        System.currentPageReference().getParameters().put('id', varAccount.id);
        
        FS_CreateContact_CC tempobj = new FS_CreateContact_CC();
        
        tempobj.varContactDetail.firstname='test';
        tempobj.varContactDetail.lastname='Last';
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
        
        
        
        Contact varContact=[select id,FS_RefId__c from contact where FS_RefId__c!=null ];
        
        Test.setCurrentPageReference(new PageReference('Page.FS_ContactDetailPage')); 
        System.currentPageReference().getParameters().put('id', varContact.FS_RefId__c);  
        System.assert(varContact.FS_RefId__c <> null);
    }
    
}