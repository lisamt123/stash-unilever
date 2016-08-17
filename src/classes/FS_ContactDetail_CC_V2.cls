/**********************************************************************
Name: FS_ContactDetail_CC_V2
======================================================
======================================================
Purpose: For Displaying Contact in Vf page fetching from 
Brandtone.
-------
======================================================
======================================================
History
-------
VERSION AUTHOR   DATE        DETAIL Description
1.0     santhosh 20/07/2016 INITIAL DEVELOPMENT 
***********************************************************************/

Public with sharing class FS_ContactDetail_CC_V2{
    
    Public Contact varContactDetail{get;set;}
    public FS_ContactDetailHelper_CC varContactDetailHelper{get;set;}
    public String Position{get;set;}
    public String State{get;set;}
    public Boolean DecisionMakerBoolean{get;set;}
    public String  FName{get;set;}
    
    //Public Static String varResponseForTestClass='{   "GetSiteLeadResult": {      "ErrorCode": 0,         "Message": "Операция выполнена",        "SiteLead": {           "Address": "RqcfxYazzIpNR5ps3vqfWMjSimsngIu/kMRhFXvCkKUqYAXfxwuVp7GsYHpt7qCF",          "BirthDate": "0001-01-01",          "BusinessAddress": "",          "BusinessName": "",             "BusinessPostalCode": "E+7wWTOqSsXUwJPpvGanMZYsVh154MXG0Ko4wJO6Gcw=",           "City": "TqxDca9IqWTrb32i2FdYPyUCJnPIPbJfB5jQC6Btx6M=",             "Country": "DBffqd8Fpy2bXtRaRWMBMxcLXrQJLNqER8qCgAXXyQU=",          "Email": "S8pmHZvRs9itW7/zLyiNjV+55PO5a4HulkPP9XXC4Ts=",            "ExtraParameters": [                {                   "Name": "1BiWAMvmLe05A/ZMDEtPH6SyI4DK8aNZ4cJ8pdIV8nk=",                     "Value": "opBxW9OLqkCFOdvI+1pgSG/xQqNy+SlbtkknQGzKEXo="                 },              {                   "Name": "vPM9agVP3+aUMgb2veDqgdx+easpT+Esdu79fEHBFWk=",                     "Value": "iqnbI6nuaQHhxX4BkgWiViZQ5CwpoKYwJFGBzGPTc2E="                 },              {                   "Name": "I17mXitMCw+Qn+Pxn3Wq6We9E1lvttZppz+mNTklXVs=",                     "Value": "RqcfxYazzIpNR5ps3vqfWMjSimsngIu/kMRhFXvCkKUqYAXfxwuVp7GsYHpt7qCF"                 }           ],          "FacebookId": "",           "Firstname": "V7+T1Rb//GtyU4HWJamNP94r17yKPtBsTkqeRlVOuEc=",            "Gender": "",           "Id": "a954e345-1b61-4789-bb0c-8eca7fb6545d",           "JobTitle": "",             "LandlinePhone": "",            "MaritalStatus": "",            "Middlename": "",           "OkId": "",             "PassportNumber": "",           "PersonalDataAgree": true,          "Phone": "BkH0uQ0e3wP/6rGheV4yiWl3kg7V8jMIxAXXw2uFz50=",            "PropertyStatus": "",           "SocialStatus": "",             "Surname": "k0wXYSPr5CMDyFNRsTT1bD6Vk1ICmxqAjoFRld8gt/4=",          "Username": "",             "VkId": ""      },      "Success": true,        "Warnings": []  } }';
    Public Static String varResponseForTestClass{get;set;}
    public Boolean EditMode{get;set;}
    
    /* * Constructor for FS_ContactDetail_CC
*  @name FS_ContactDetail_CC
*  @param custom controller
*  @return 
*  @throws 
*/ 
    Public FS_ContactDetail_CC_V2()
    {
        EditMode=false;
        Blob cryptoKey = Crypto.generateAesKey(256);
        
        varContactDetail=new Contact();
        String accountId = apexpages.currentpage().getparameters().get(FS_ContactUtility.IDTEXTFORACCOUNT );
        
        varContactDetail = [select id,FirstName, LastName,FS_PIEncryptKey__c, OwnerId,Owner.name, FS_RefId__c,Account.Name, AccountId from Contact where FS_RefId__c=:accountId limit 1];
        
        
        String urlId =Label.FS_UrlId+FS_ContactUtility.SITELEADID+accountId;
        String clientId =Label.FS_PIIClientId; 
        String clientSecretKey=Label.FS_ClientSecretKey; 
        Http h = new Http();
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest varRequest = new HttpRequest();
        varRequest.setHeader(FS_ContactUtility.CONTENTTYPE, FS_ContactUtility.APPLICATIONJSON);
        varRequest.setHeader(FS_ContactUtility.CLIENTIDTEXT, clientId);
        varRequest.setHeader(FS_ContactUtility.CLIENTSECRETTEXT, clientSecretKey);
        
        
        varRequest.setEndpoint(urlId);
        varRequest.setMethod(FS_ContactUtility.GETTEXTVALUE);
        
        // Send the request, and return a response
        HttpResponse varResponse = new HttpResponse();
        try
        { 
            if(Test.isRunningTest())
            {  
                varResponse.setBody(varResponseForTestClass);
                varResponse.setStatusCode(200);
                varResponse.setStatus('Ok'); 
            }
            else
            {
                System.debug(varRequest.getBody());
                varResponse = h.send(varRequest);
                System.debug(varResponse.getBody());
            }
        }
        catch(Exception e)
            
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
        
        
        varContactDetailHelper= FS_ContactDetailHelper_CC.parse(varResponse.getBody());
        
        if(!String.isBlank(varContactDetailHelper.GetSiteLeadResult.SiteLead.Firstname))
        {
            varContactDetail.firstname=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(varContactDetailHelper.GetSiteLeadResult.SiteLead.Firstname))).toString();
        }
        else
        {
            varContactDetail.firstname=null;
        }
        
        varContactDetail.lastname=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(varContactDetailHelper.GetSiteLeadResult.SiteLead.Surname))).toString();
        
        
        if(!String.isBlank(varContactDetailHelper.GetSiteLeadResult.SiteLead.Email))
        {
            varContactDetail.Email=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(varContactDetailHelper.GetSiteLeadResult.SiteLead.Email))).toString();
        }
        else
        {
            varContactDetail.Email=null; 
        }
        if(!String.isBlank(varContactDetailHelper.GetSiteLeadResult.SiteLead.Phone))
        {
            varContactDetail.Phone=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(varContactDetailHelper.GetSiteLeadResult.SiteLead.Phone))).toString();
        }
        else
        {
            varContactDetail.Phone=null;
        }
        if(!String.isBlank(varContactDetailHelper.GetSiteLeadResult.SiteLead.Address))
        {
            varContactDetail.MailingStreet=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(varContactDetailHelper.GetSiteLeadResult.SiteLead.Address))).toString();
        }
        else
        {
            varContactDetail.MailingStreet=null;
        }
        if(!String.isBlank(varContactDetailHelper.GetSiteLeadResult.SiteLead.City))
        {
            varContactDetail.mailingcity=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(varContactDetailHelper.GetSiteLeadResult.SiteLead.City))).toString();
        }
        else
        {
            varContactDetail.mailingcity=null;
        }
        if(!String.isBlank(varContactDetailHelper.GetSiteLeadResult.SiteLead.BusinessPostalCode))
        {
            varContactDetail.MailingPostalCode=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(varContactDetailHelper.GetSiteLeadResult.SiteLead.BusinessPostalCode))).toString();
        }
        else
        {
            varContactDetail.MailingPostalCode=null;
        }
        
        if(!String.isBlank(varContactDetailHelper.GetSiteLeadResult.SiteLead.Country))
        {
            varContactDetail.MailingCountry=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(varContactDetailHelper.GetSiteLeadResult.SiteLead.Country))).toString();
        }  
        else
        {
            varContactDetail.MailingCountry=null;
        }
        
        
        
        for(FS_ContactDetailHelper_CC.FS_ExtraParameters str: varContactDetailHelper.GetSiteLeadResult.SiteLead.extraParameters)
        {
            if (((Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(str.name))).toString()).equals(FS_ContactUtility.POSITIONTEXTVALUE))
            {
                Position= (Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(str.Value))).toString();
                
            }
            if (((Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(str.name))).toString()).equals(FS_ContactUtility.STATETEXTVALUE))
            {
                State=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(str.Value))).toString();
            }
            if (((Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(str.name))).toString()).equals(FS_ContactUtility.DECISIONMAKER))
            {
                String DecisionMaker=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(str.Value))).toString();
                
                if(DecisionMaker.equals(FS_ContactUtility.TRUETEXT))
                {
                    DecisionMakerBoolean=true;
                }
                else
                {         
                    DecisionMakerBoolean=false;
                }
            }
        }    
    }    
    
    Public PageReference editPage()
    {
    EditMode=true;
    return null;
    }
    Public PageReference DetailPage()
    {
    EditMode=false;
    return null;
    }
}