/**********************************************************************
Name: FS_ContactDetail_CC 
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

Public with sharing class FS_ContactDetail_CC_v1 {
    
    Public Contact varContactDetail{get;set;}
    public FS_ContactDetailHelper_CC varContactDetailHelper {get;set;}
    public String Position {get;set;}
    public String State{get;set;}
    public Boolean DecisionMakerBoolean{get;set;}
    public String FName {get;set;}
    
    Public Static Final String varResponseForTestClass='{   "GetSiteLeadResult": {      "ErrorCode": 0,         "Message": "Операция выполнена",        "SiteLead": {           "Address": "RqcfxYazzIpNR5ps3vqfWMjSimsngIu/kMRhFXvCkKUqYAXfxwuVp7GsYHpt7qCF",          "BirthDate": "0001-01-01",          "BusinessAddress": "",          "BusinessName": "",             "BusinessPostalCode": "E+7wWTOqSsXUwJPpvGanMZYsVh154MXG0Ko4wJO6Gcw=",           "City": "TqxDca9IqWTrb32i2FdYPyUCJnPIPbJfB5jQC6Btx6M=",             "Country": "DBffqd8Fpy2bXtRaRWMBMxcLXrQJLNqER8qCgAXXyQU=",          "Email": "S8pmHZvRs9itW7/zLyiNjV+55PO5a4HulkPP9XXC4Ts=",            "ExtraParameters": [                {                   "Name": "1BiWAMvmLe05A/ZMDEtPH6SyI4DK8aNZ4cJ8pdIV8nk=",                     "Value": "opBxW9OLqkCFOdvI+1pgSG/xQqNy+SlbtkknQGzKEXo="                 },              {                   "Name": "vPM9agVP3+aUMgb2veDqgdx+easpT+Esdu79fEHBFWk=",                     "Value": "iqnbI6nuaQHhxX4BkgWiViZQ5CwpoKYwJFGBzGPTc2E="                 },              {                   "Name": "I17mXitMCw+Qn+Pxn3Wq6We9E1lvttZppz+mNTklXVs=",                     "Value": "RqcfxYazzIpNR5ps3vqfWMjSimsngIu/kMRhFXvCkKUqYAXfxwuVp7GsYHpt7qCF"                 }           ],          "FacebookId": "",           "Firstname": "V7+T1Rb//GtyU4HWJamNP94r17yKPtBsTkqeRlVOuEc=",            "Gender": "",           "Id": "a954e345-1b61-4789-bb0c-8eca7fb6545d",           "JobTitle": "",             "LandlinePhone": "",            "MaritalStatus": "",            "Middlename": "",           "OkId": "",             "PassportNumber": "",           "PersonalDataAgree": true,          "Phone": "BkH0uQ0e3wP/6rGheV4yiWl3kg7V8jMIxAXXw2uFz50=",            "PropertyStatus": "",           "SocialStatus": "",             "Surname": "k0wXYSPr5CMDyFNRsTT1bD6Vk1ICmxqAjoFRld8gt/4=",          "Username": "",             "VkId": ""      },      "Success": true,        "Warnings": []  } }';
    Public static final string jsonresponse = '{ 	"GetSiteLeadResult": { 		"ErrorCode": 0, 		"Message": "Операция выполнена", 		"SiteLead": { 			"Address": "4XIgzDLm2SbbbSQgY15uAiYr+xzXLmEyfCdSORNv1Wc=", 			"BirthDate": "0001-01-01", 			"BusinessAddress": "", 			"BusinessName": "", 			"BusinessPostalCode": "uV2v0HJ0H2W1B9xQq7DghdgG8N3WlmEZ1YOaxwY8RD8=", 			"City": "ODjAWOLzJ6e4c8F538MWB8fAGSbKzVuN7gZTstpTtzo=", 			"Country": "Nn3+M7EEFnffoxUnoL0hXPbWWJ9HiNuktp1XLdDZsqY=", 			"Email": "EUNYBbDUjfip+ADoCHfS4H5xn1G5+xxlKTwKA5qR82Dtq90HOiORnV9wv2GFnrFK", 			"ExtraParameters": [ 				{ 					"Value": "lXXDll6UXsxUHzYuPRTdMdynd0XAr6+R/dD0vEk028o=", 					"Name": "KA0uhZUNDVAiBGrXfDUAyysbVxlzytEA+0jISSux0VU=" 				}, 				{ 					"Value": "o8f79SlVa77Fde1JJcJK/p1YV3o09a7yaP4Pi6mYFNc=", 					"Name": "EtaNVj4q+fAcSmkJtLAShefrpn1+LQdmDBHiKIJN8fw=" 				}, 				{ 					"Value": "EVc4owmOy/DBkCKHU98SEvSERV8F5JJVIWkSaChmLEA=", 					"Name": "fwJzimc1PN+1aLRkf1A2If2eSBCyYUaJSZ5k7FZMY7Y=" 				}, 				{ 					"Value": "/jK9nEZ8pLmdUa9lDKz/UnAgd+PGT0Zyb9p2aAP1X1GvM5/5JTiiPzZg312NtKyl", 					"Name": "alzUkJthURP051F4vbUWcuBu6wnrwq+yFY/l9hIFnkc=" 				}, 				{ 					"Value": "VTXRTDVaI5tEju8w38wfMhYatEnu8AhjAG0gq857xTGxilpqMwV02icbMEQvkaya", 					"Name": "Q35QIoKwEB0OXBgBCvIkbpX0eM+SiPNYYxoroMd1u7Q=" 				}, 				{ 					"Value": "wdB4aaWeSnbKKwQq3bv96INXFREoO1pJ3JoUc+SmHKAwh7GtQ08SI39icBxTCdwH", 					"Name": "TvVCz5vTgcYQ7yxGvns5sOhvgFwxKgXrUxelwWkyclk=" 				}, 				{ 					"Value": "e6qLzSE5tHg1b/A0a3cnctDYPBgBc4WK2BkmT8RG4yo=", 					"Name": "naK3edhKLsOIOtmhsWeyMv218m3vasUx9FC/XbbYiT0=" 				} 			], 			"FacebookId": "", 			"Firstname": "8DnGfugdD3t6fPmmkf7ApogwZ/r93BdiZjRsjIM8GJo=", 			"Gender": "", 			"Id": "86fda35a-3d3f-4e49-a6aa-bcc5779f1e17", 			"JobTitle": "", 			"LandlinePhone": "", 			"MaritalStatus": "", 			"Middlename": "", 			"OkId": "", 			"PassportNumber": "", 			"PersonalDataAgree": true, 			"Phone": "oA1klMrcjwBL4gdFF4lP4gmQYNC3eRUeKlZLLJR4HeI=", 			"PropertyStatus": "", 			"SocialStatus": "", 			"Surname": "gT1gDrLN8urC5fgnjJ9hkhj6zORqcEYtF/P6Ffn6RJg=", 			"Username": "", 			"VkId": "" 		}, 		"Success": true, 		"Warnings": [] 	} }';
    /* * Constructor for FS_ContactDetail_CC
*  @name FS_ContactDetail_CC
*  @param custom controller
*  @return 
*  @throws 
*/ 
    Public FS_ContactDetail_CC_v1()
    {
        
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
                
                varResponse.setBody(jsonresponse);
                varResponse.setStatusCode(200);
                varResponse.setStatus('Ok'); 
            }
            else
            {
                varResponse = h.send(varRequest);
            system.debug('======varResponse========'+varResponse);
                
            }
        }
        catch(Exception e)
            
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
        
        
        varContactDetailHelper= FS_ContactDetailHelper_CC.parse(varResponse.getBody());
        system.debug('======varContactDetailHelper========'+varContactDetailHelper);
        
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
}