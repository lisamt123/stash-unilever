@IsTest
Public class FS_ContactDetail_Test {
    
    public  String clientId =Label.FS_PIIClientId; 
    public  String clientSecret=Label.FS_ClientSecretKey;
    Public Static Final String varResonseResult='{"AddSiteLeadResult": {     "ErrorCode": 0,     "Message": "???????? ?????????",     "SiteLead": {       "Address": "address-1, 4 - 33",       "Age": 28,       "BirthDate": "1987-01-12",       "BusinessAddress": "",       "BusinessName": "OOO MTC",       "BusinessPostalCode": "449543",       "City": "city1",       "Country": "Russia",       "Email": "tolmachev@example.com",       "ExtraParameters": [         {           "Name": "Number of pets",           "Value": "2"         },         {           "Name": "Job",           "Value": "Developer"         }       ],       "FacebookId": "897384",       "Firstname": "Tol",       "Gender": "Male",       "Id": "feff7eae-f646-4ba5-987f-ecd265e498f0",       "Income": 70000,       "JobTitle": "",       "LandlinePhone": "89345673245",       "MaritalStatus": "Married",       "Middlename": "middleName",       "OkId": "0294485",       "PassportNumber": "3606789654",       "PersonalDataAgree": true,       "Phone": "89270087098",       "PropertyStatus": "propertyStatus",       "SocialStatus": "socialStatus",       "Surname": "Machev",       "Username": "Tolmachev",       "VkId": "789347503"     },     "Success": true,     "Warnings": []   } }';
    // Public static final string jsonresponse = '{    "GetSiteLeadResult": {      "ErrorCode": 0,         "Message": "Операция выполнена",        "SiteLead": {           "Address": "XA0YwGv7kenfhXflrSiI48LsDIRPd2ybqbwCp8L8MQ0=",          "BirthDate": "0001-01-01",          "BusinessAddress": "",          "BusinessName": "",             "BusinessPostalCode": "JHD3qjpWcj1khpoQO+KYF2yyybatSeh9j6B+tm0BL8o=",           "City": "IEAj8OKVGEICBDdUEDyP0Ruz6NhQgRyRSSjMU5Zxaek=",             "Country": "/ULLG+pCdlRd4v9sIFCkrEHGFpZ8gP9YRDtQOYxipM8=",          "Email": "test.gmail.com",            "ExtraParameters": [                {                   "Value": "lXXDll6UXsxUHzYuPRTdMdynd0XAr6+R/dD0vEk028o=",                    "Name": "KA0uhZUNDVAiBGrXfDUAyysbVxlzytEA+0jISSux0VU="              },              {                   "Value": "o8f79SlVa77Fde1JJcJK/p1YV3o09a7yaP4Pi6mYFNc=",                    "Name": "EtaNVj4q+fAcSmkJtLAShefrpn1+LQdmDBHiKIJN8fw="              },              {                   "Value": "EVc4owmOy/DBkCKHU98SEvSERV8F5JJVIWkSaChmLEA=",                    "Name": "fwJzimc1PN+1aLRkf1A2If2eSBCyYUaJSZ5k7FZMY7Y="              },              {                   "Value": "/jK9nEZ8pLmdUa9lDKz/UnAgd+PGT0Zyb9p2aAP1X1GvM5/5JTiiPzZg312NtKyl",                    "Name": "alzUkJthURP051F4vbUWcuBu6wnrwq+yFY/l9hIFnkc="              },              {                   "Value": "VTXRTDVaI5tEju8w38wfMhYatEnu8AhjAG0gq857xTGxilpqMwV02icbMEQvkaya",                    "Name": "Q35QIoKwEB0OXBgBCvIkbpX0eM+SiPNYYxoroMd1u7Q="              },              {                   "Value": "wdB4aaWeSnbKKwQq3bv96INXFREoO1pJ3JoUc+SmHKAwh7GtQ08SI39icBxTCdwH",                    "Name": "TvVCz5vTgcYQ7yxGvns5sOhvgFwxKgXrUxelwWkyclk="              },              {                   "Value": "e6qLzSE5tHg1b/A0a3cnctDYPBgBc4WK2BkmT8RG4yo=",                    "Name": "naK3edhKLsOIOtmhsWeyMv218m3vasUx9FC/XbbYiT0="              }           ],          "FacebookId": "",           "Firstname": "K2yytRw0BzBRgNEFB4WqAZNPCHheJE59iIfIBS4ifqw=",            "Gender": "",           "Id": "86fda35a-3d3f-4e49-a6aa-bcc5779f1e17",           "JobTitle": "",             "LandlinePhone": "",            "MaritalStatus": "",            "Middlename": "",           "OkId": "",             "PassportNumber": "",           "PersonalDataAgree": true,          "Phone": "90876543217",            "PropertyStatus": "",           "SocialStatus": "",             "Surname": "j+uzsfiEbJ7mbtKE/KuhxV5qoZeXsycl34ng2rrvp98=",          "Username": "",             "VkId": ""      },      "Success": true,        "Warnings": []  } }';
    public static testMethod void FS_CreateContact_CC_TestMethod() {
        
        Test.StartTest();
        Account varAccount =new Account();
        varAccount.name='Account name';
        varAccount.CurrencyIsoCode='USD';
        insert varAccount; 
        
        HTTPResponse res = new HTTPResponse();
        res.setBody(varResonseResult);
        res.setStatusCode(200);
        res.setStatus('Ok');
        
        Test.setCurrentPageReference(new PageReference('Page.FS_CreateContact')); 
        System.currentPageReference().getParameters().put('id', varAccount.id);
        
        contact con = new contact();
        con.FirstName = 'test';
        con.LastName = 'Last';
        con.AccountId = varAccount.id;
        con.FS_RefId__c = '86fda35a-3d3f-4e49-a6aa-bcc5779f1e17';
        con.FS_PIEncryptKey__c = 'Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264=';
        insert con;
        Test.StopTest();
        
        Test.setCurrentPageReference(new PageReference('Page.FS_ContactDetailPage')); 
        System.currentPageReference().getParameters().put('id',  con.FS_RefId__c);
        
        Test.setCurrentPageReference(new PageReference('Page.FS_ContactDetailPage')); 
        System.currentPageReference().getParameters().put('id',  con.FS_RefId__c);
        
        FS_ContactDetail_CC tempdetail = new FS_ContactDetail_CC();
        tempdetail.editPage();
        tempdetail.updateContact();
        System.assert(con.FS_PIEncryptKey__c <> null);
        FS_ContactDetailHelper_CC.FS_GetSiteLeadResult  varFSGetSiteLeadResult=new FS_ContactDetailHelper_CC.FS_GetSiteLeadResult();
        varFSGetSiteLeadResult.errorCode=0;
        FS_ContactDetailHelper_CC.FS_SiteLead varFS_SiteLead=new FS_ContactDetailHelper_CC.FS_SiteLead();
        varFS_SiteLead.email='dinesh.singla24@gmail.com';
        varFS_SiteLead.Middlename='test';
        varFS_SiteLead.phone='3333';    
    }
    
}