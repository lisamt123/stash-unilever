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
public class FS_CreateContact_CC_Test{
    
    public  String clientId =Label.FS_PIIClientId; 
    public  String clientSecret=Label.FS_ClientSecretKey;
    String jsonresponse = '{    "SiteLead": {      "Email": "firstlast@example.com","Phone": "89270087098",      "LandlinePhone": "89345673245",   "Username": "first",      "Firstname": "first",      "Middlename": "middle",      "Surname": "last",      "Age": 28,      "BirthDate": "1987-01-12Z",      "Country": "Russia",      "Address": "address-1, 4 - 33",      "City": "city1",      "PersonalDataAgree": true,      "Gender": "Male",      "BusinessName": "OOO MTC",      "BusinessPostalCode": "449543",     "FacebookId": "897384",      "VkId": "789347503",      "OkId": "0294485",      "MaritalStatus": "Married",      "SocialStatus": "socialStatus",      "PropertyStatus": "propertyStatus",      "Profession": "Developer",      "Income": "70000",      "PassportNumber": "1234567890",    "ExtraParameters": [     {          "Name": "Number of pets",          "Value": "2"        },        {          "Name": "Job",          "Value": "Developer"        }]    }}';
    Public Static Final String varResonseResult='{"AddSiteLeadResult": {     "ErrorCode": 0,     "Message": "???????? ?????????",     "SiteLead": {       "Address": "address-1, 4 - 33",       "Age": 28,       "BirthDate": "1987-01-12",       "BusinessAddress": "",       "BusinessName": "OOO MTC",       "BusinessPostalCode": "449543",       "City": "city1",       "Country": "Russia",       "Email": "tolmachev@example.com",       "ExtraParameters": [         {           "Name": "Number of pets",           "Value": "2"         },         {           "Name": "Job",           "Value": "Developer"         }       ],       "FacebookId": "897384",       "Firstname": "Tol",       "Gender": "Male",       "Id": "feff7eae-f646-4ba5-987f-ecd265e498f0",       "Income": 70000,       "JobTitle": "",       "LandlinePhone": "89345673245",       "MaritalStatus": "Married",       "Middlename": "middleName",       "OkId": "0294485",       "PassportNumber": "3606789654",       "PersonalDataAgree": true,       "Phone": "89270087098",       "PropertyStatus": "propertyStatus",       "SocialStatus": "socialStatus",       "Surname": "Machev",       "Username": "Tolmachev",       "VkId": "789347503"     },     "Success": true,     "Warnings": []   } }';
    
    public static testMethod void FS_CreateContact_CC_TestMethod() {
        Account varAccount =new Account();
        varAccount.name='Account name';
        varAccount.CurrencyIsoCode='USD';
        insert varAccount; 
        FS_CreateContact_CC.FS_SiteLead varSiteLead = new FS_CreateContact_CC.FS_SiteLead();
        varSiteLead.Firstname ='Firstname'; 
        varSiteLead.Surname ='lastname'; 
        varSiteLead.Email ='test@test.com'; 
        varSiteLead.Phone ='113452'; 
        varSiteLead.Address ='abc'; 
        varSiteLead.City ='Hyd'; 
        varSiteLead.BusinessPostalCode ='1234'; 
        varSiteLead.Country='US';
        
        varSiteLead.age = 33;
        varSiteLead.businessName = 'ABC';
        varSiteLead.gender = 'male';
        varSiteLead.passportNumber = '3606789654';
        varSiteLead.okId = '0294485';
        varSiteLead.personalDataAgree = true;
            
            
            FS_CreateContact_CC.FS_SiteLeadMain FS_SiteLeadMain=new FS_CreateContact_CC.FS_SiteLeadMain();
        FS_CreateContact_CC.FS_SiteLead SiteLead;
        SiteLead=varSiteLead; 
        
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        res.setBody(varResonseResult);
        res.setStatusCode(200);
        res.setStatus('Ok');
        
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
        //tempobj.varContactDetail.Owner.name=UserInfo.getUserName();
        tempobj.varContactDetail.AccountId=varAccount.id;
        //tempobj.varContactDetail.Account.Name='Account name';
        tempobj.varContactDetail.MailingStreet='street';
        tempobj.varContactDetail.mailingcity='Narwana';
        tempobj.varContactDetail.MailingPostalCode='126116';
        tempobj.varContactDetail.MailingCountry='India';
        tempobj.createContact();
        
        
        // Contact varContact=[select id,FS_RefId__c from contact where FS_RefId__c=null limit 1 ];
        
        //varContact.FS_RefId__c='a954e345-1b61-4789-bb0c-8eca7fb6545d';
        // update varContact;
        
        //  Test.setCurrentPageReference(new PageReference('Page.FS_ContactDetailPage')); 
        //  System.currentPageReference().getParameters().put('id', varContact.FS_RefId__c);
        // String testLbl = Label.FS_ClientSecretKey;
        
        //  FS_ContactDetail_CC.varResponseForTestClass=FS_CreateContact_CC.varResonseResult;
        //  FS_ContactDetail_CC varCreateContact= new FS_ContactDetail_CC();
        tempobj.varContactDetail.firstname='';
        tempobj.varContactDetail.lastname='singla';
        tempobj.varContactDetail.Email='';
        tempobj.varContactDetail.phone='';
        tempobj.varContactDetail.MailingState='';
        tempobj.varContactDetail.FS_Position__c='';
        tempobj.varContactDetail.OwnerID=UserInfo.getUserId();        
        //tempobj.varContactDetail.Owner.name=UserInfo.getUserName();
        tempobj.varContactDetail.AccountId=varAccount.id;
        //tempobj.varContactDetail.Account.Name='Account name';
        tempobj.varContactDetail.MailingStreet='';
        tempobj.varContactDetail.mailingcity='';
        tempobj.varContactDetail.MailingPostalCode='';
        tempobj.varContactDetail.MailingCountry='';
        tempobj.createContact();
        
    }
    
   
}