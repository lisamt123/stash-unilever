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
1.0     Dinesh 27/07/2016 INITIAL DEVELOPMENT 
***********************************************************************/

@istest
public class FS_CreateContact_CC_Test_v1{
    public static testMethod void FS_CreateContact_CC_TestMethod() {
        Account varAccount =new Account();
        varAccount.name='Account name';
        varAccount.CurrencyIsoCode='USD';
        insert varAccount; 
        FS_CreateContact_CC_v1.FS_SiteLead varSiteLead = new FS_CreateContact_CC_v1.FS_SiteLead();
        varSiteLead.Firstname ='Firstname'; 
        varSiteLead.Surname ='lastname'; 
        varSiteLead.Email ='test@test.com'; 
        varSiteLead.Phone ='113452'; 
        varSiteLead.Address ='abc'; 
        varSiteLead.City ='Hyd'; 
        varSiteLead.BusinessPostalCode ='1234'; 
        varSiteLead.Country='US'; 
        
        FS_CreateContact_CC_v1.FS_SiteLeadMain FS_SiteLeadMain=new FS_CreateContact_CC_v1.FS_SiteLeadMain();
        FS_CreateContact_CC_v1.FS_SiteLead SiteLead;
        SiteLead=varSiteLead; 
        
        Test.setCurrentPageReference(new PageReference('Page.FS_CreateContact')); 
        System.currentPageReference().getParameters().put('id', varAccount.id);
        // String testLbl = Label.FS_ClientSecretKey;
        FS_CreateContact_CC_v1 tempobj = new FS_CreateContact_CC_v1();
        
        tempobj.varContactDetail.firstname='test';
        tempobj.varContactDetail.lastname='Last';
        tempobj.varContactDetail.Email='dinesh@gmail.com';
        tempobj.varContactDetail.phone='9738266192';
        tempobj.varContactDetail.MailingState='haryana';
        tempobj.varContactDetail.FS_Position__c='Buyer';
        tempobj.varContactDetail.OwnerID=UserInfo.getUserId();        
        //tempobj.varContactDetail.Owner.name=UserInfo.getUserName();
        tempobj.varContactDetail.AccountId=varAccount.id;
        //tempobj.varContactDetail.Account.Name='Account name';
        tempobj.varContactDetail.MailingStreet='street';
        tempobj.varContactDetail.mailingcity='Narwana';
        tempobj.varContactDetail.MailingPostalCode='126116';
        tempobj.varContactDetail.MailingCountry='India';
        tempobj.createContact();
        
         Contact varContact=[select id,FS_RefId__c from contact where FS_RefId__c!=null ];
        
        Test.setCurrentPageReference(new PageReference('Page.FS_ContactDetailPage')); 
        System.currentPageReference().getParameters().put('id', varContact.FS_RefId__c);  
    }
    /*
     public static testMethod void FS_CreateContact_CC_TestMethod2() {
        Account varAccount =new Account();
        varAccount.name='Account name';
        varAccount.CurrencyIsoCode='USD';
        insert varAccount; 
        FS_CreateContact_CC_v1.FS_SiteLead varSiteLead = new FS_CreateContact_CC_v1.FS_SiteLead();
        varSiteLead.Firstname =''; 
        varSiteLead.Surname =''; 
        varSiteLead.Email =''; 
        varSiteLead.Phone =''; 
        varSiteLead.Address =''; 
        varSiteLead.City =''; 
        varSiteLead.BusinessPostalCode =''; 
        varSiteLead.Country=''; 
        
        FS_CreateContact_CC_v1.FS_SiteLeadMain FS_SiteLeadMain=new FS_CreateContact_CC_v1.FS_SiteLeadMain();
        FS_CreateContact_CC_v1.FS_SiteLead SiteLead;
        SiteLead=varSiteLead; 
        
        Test.setCurrentPageReference(new PageReference('Page.FS_CreateContact')); 
        System.currentPageReference().getParameters().put('id', varAccount.id);
        // String testLbl = Label.FS_ClientSecretKey;
        FS_CreateContact_CC_v1 tempobj = new FS_CreateContact_CC_v1();
        
        tempobj.varContactDetail.firstname='';
        tempobj.varContactDetail.lastname='';
        tempobj.varContactDetail.Email='';
        tempobj.varContactDetail.phone='';
        tempobj.varContactDetail.MailingState='';
        tempobj.varContactDetail.FS_Position__c=' ';
        tempobj.varContactDetail.OwnerID=UserInfo.getUserId();        
        //tempobj.varContactDetail.Owner.name=UserInfo.getUserName();
        tempobj.varContactDetail.AccountId=varAccount.id;
        //tempobj.varContactDetail.Account.Name='Account name';
        tempobj.varContactDetail.MailingStreet='';
        tempobj.varContactDetail.mailingcity='';
        tempobj.varContactDetail.MailingPostalCode='';
        tempobj.varContactDetail.MailingCountry='';
        tempobj.createContact();
        
        Contact varContact1=[select id,FS_RefId__c from contact where FS_RefId__c!=null];
        
        Test.setCurrentPageReference(new PageReference('Page.FS_ContactDetailPage')); 
        System.currentPageReference().getParameters().put('id', varContact1.FS_RefId__c);  
    }*/
}