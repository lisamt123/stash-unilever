Public with sharing class FS_ContactDetail_CC_EditV1 {
    
    Public Contact varContactDetail{get;set;}
    public FS_ContactDetailHelper_CC varContactDetailHelper {get;set;}
    public String Position {get;set;}
    public String State{get;set;}
    public Boolean DecisionMakerBoolean{get;set;}
    public String FName {get;set;}
    public Boolean EditMode{get;set;}
    public String SecretKey;
    public Blob cryptoKey;
    
    
    //Public static final string jsonresponse = '{   "GetSiteLeadResult": {     "ErrorCode": 0,     "Message": "Операция выполнена",     "SiteLead": {       "Address": "4XIgzDLm2SbbbSQgY15uAiYr+xzXLmEyfCdSORNv1Wc=",       "BirthDate": "0001-01-01",       "BusinessAddress": "",       "BusinessName": "",       "BusinessPostalCode": "uV2v0HJ0H2W1B9xQq7DghdgG8N3WlmEZ1YOaxwY8RD8=",       "City": "ODjAWOLzJ6e4c8F538MWB8fAGSbKzVuN7gZTstpTtzo=",       "Country": "Nn3+M7EEFnffoxUnoL0hXPbWWJ9HiNuktp1XLdDZsqY=",       "Email": "EUNYBbDUjfip+ADoCHfS4H5xn1G5+xxlKTwKA5qR82Dtq90HOiORnV9wv2GFnrFK",       "ExtraParameters": [         {           "Value": "lXXDll6UXsxUHzYuPRTdMdynd0XAr6+R/dD0vEk028o=",           "Name": "KA0uhZUNDVAiBGrXfDUAyysbVxlzytEA+0jISSux0VU="         },         {           "Value": "o8f79SlVa77Fde1JJcJK/p1YV3o09a7yaP4Pi6mYFNc=",           "Name": "EtaNVj4q+fAcSmkJtLAShefrpn1+LQdmDBHiKIJN8fw="         },         {           "Value": "EVc4owmOy/DBkCKHU98SEvSERV8F5JJVIWkSaChmLEA=",           "Name": "fwJzimc1PN+1aLRkf1A2If2eSBCyYUaJSZ5k7FZMY7Y="         },         {           "Value": "/jK9nEZ8pLmdUa9lDKz/UnAgd+PGT0Zyb9p2aAP1X1GvM5/5JTiiPzZg312NtKyl",           "Name": "alzUkJthURP051F4vbUWcuBu6wnrwq+yFY/l9hIFnkc="         },         {           "Value": "VTXRTDVaI5tEju8w38wfMhYatEnu8AhjAG0gq857xTGxilpqMwV02icbMEQvkaya",           "Name": "Q35QIoKwEB0OXBgBCvIkbpX0eM+SiPNYYxoroMd1u7Q="         },         {           "Value": "wdB4aaWeSnbKKwQq3bv96INXFREoO1pJ3JoUc+SmHKAwh7GtQ08SI39icBxTCdwH",           "Name": "TvVCz5vTgcYQ7yxGvns5sOhvgFwxKgXrUxelwWkyclk="         },         {           "Value": "e6qLzSE5tHg1b/A0a3cnctDYPBgBc4WK2BkmT8RG4yo=",           "Name": "naK3edhKLsOIOtmhsWeyMv218m3vasUx9FC/XbbYiT0="         }       ],       "FacebookId": "",       "Firstname": "8DnGfugdD3t6fPmmkf7ApogwZ/r93BdiZjRsjIM8GJo=",       "Gender": "",       "Id": "86fda35a-3d3f-4e49-a6aa-bcc5779f1e17",       "JobTitle": "",       "LandlinePhone": "",       "MaritalStatus": "",       "Middlename": "",       "OkId": "",       "PassportNumber": "",       "PersonalDataAgree": true,       "Phone": "oA1klMrcjwBL4gdFF4lP4gmQYNC3eRUeKlZLLJR4HeI=",       "PropertyStatus": "",       "SocialStatus": "",       "Surname": "gT1gDrLN8urC5fgnjJ9hkhj6zORqcEYtF/P6Ffn6RJg=",       "Username": "",       "VkId": ""     },     "Success": true,     "Warnings": []   } }';
    Public static final string jsonresponse = '{   "GetSiteLeadResult": {     "ErrorCode": 0,     "Message": "Операция выполнена",     "SiteLead": {       "Address": "4XIgzDLm2SbbbSQgY15uAiYr+xzXLmEyfCdSORNv1Wc=",       "BirthDate": "0001-01-01",       "BusinessAddress": "",       "BusinessName": "",       "BusinessPostalCode": "uV2v0HJ0H2W1B9xQq7DghdgG8N3WlmEZ1YOaxwY8RD8=",       "City": "ODjAWOLzJ6e4c8F538MWB8fAGSbKzVuN7gZTstpTtzo=",       "Country": "Nn3+M7EEFnffoxUnoL0hXPbWWJ9HiNuktp1XLdDZsqY=",       "Email": "test@gmail.com",       "ExtraParameters": [         {           "Value": "lXXDll6UXsxUHzYuPRTdMdynd0XAr6+R/dD0vEk028o=",           "Name": "KA0uhZUNDVAiBGrXfDUAyysbVxlzytEA+0jISSux0VU="         },         {           "Value": "o8f79SlVa77Fde1JJcJK/p1YV3o09a7yaP4Pi6mYFNc=",           "Name": "EtaNVj4q+fAcSmkJtLAShefrpn1+LQdmDBHiKIJN8fw="         },         {           "Value": "EVc4owmOy/DBkCKHU98SEvSERV8F5JJVIWkSaChmLEA=",           "Name": "fwJzimc1PN+1aLRkf1A2If2eSBCyYUaJSZ5k7FZMY7Y="         },         {           "Value": "/jK9nEZ8pLmdUa9lDKz/UnAgd+PGT0Zyb9p2aAP1X1GvM5/5JTiiPzZg312NtKyl",           "Name": "alzUkJthURP051F4vbUWcuBu6wnrwq+yFY/l9hIFnkc="         },         {           "Value": "VTXRTDVaI5tEju8w38wfMhYatEnu8AhjAG0gq857xTGxilpqMwV02icbMEQvkaya",           "Name": "Q35QIoKwEB0OXBgBCvIkbpX0eM+SiPNYYxoroMd1u7Q="         },         {           "Value": "wdB4aaWeSnbKKwQq3bv96INXFREoO1pJ3JoUc+SmHKAwh7GtQ08SI39icBxTCdwH",           "Name": "TvVCz5vTgcYQ7yxGvns5sOhvgFwxKgXrUxelwWkyclk="         },         {           "Value": "e6qLzSE5tHg1b/A0a3cnctDYPBgBc4WK2BkmT8RG4yo=",           "Name": "naK3edhKLsOIOtmhsWeyMv218m3vasUx9FC/XbbYiT0="         }       ],       "FacebookId": "",       "Firstname": "8DnGfugdD3t6fPmmkf7ApogwZ/r93BdiZjRsjIM8GJo=",       "Gender": "",       "Id": "86fda35a-3d3f-4e49-a6aa-bcc5779f1e17",       "JobTitle": "",       "LandlinePhone": "",       "MaritalStatus": "",       "Middlename": "",       "OkId": "",       "PassportNumber": "",       "PersonalDataAgree": true,       "Phone": "12345678900",       "PropertyStatus": "",       "SocialStatus": "",       "Surname": "gT1gDrLN8urC5fgnjJ9hkhj6zORqcEYtF/P6Ffn6RJg=",       "Username": "",       "VkId": ""     },     "Success": true,     "Warnings": []   } }';
    
    Public final String CONTACTINFORMATIONEXT{get;set;}
    Public final String FIRSTNAMETEXT{get;set;}
    Public final String LASTNAMETEXT{get;set;}
    Public final String ACCOUNTNAMETEXT{get;set;}
    Public final String TELEPHONETEXT{get;set;}
    Public final String EMAILTEXT{get;set;}
    Public final String POSITIONTEXT{get;set;}
    Public final String DECISIONMAKERTEXT{get;set;}
    Public final String MAILINGSTREETTEXT{get;set;}
    Public final String MAILINGCITYTEXT{get;set;}
    Public final String MAILINGSTATETEXT{get;set;}
    Public final String MAILINGPOSTALTEXT{get;set;}
    Public final String MAILINGCOUNTRYTEXT{get;set;}
    Public final String ADDRESSTEXT{get;set;}
    
    /* * Method for update Contact
*  @name updateContact
*  @param custom controller
*  @return PageReference 
*  @throws 
*/ 
    
    Public PageReference updateContact()
    {
        
        if(!String.isBlank(varContactDetail.phone) &&(varContactDetail.Phone.length()==11 || varContactDetail.Phone.length()==0))
        {
            String  varAccountName=[select id,name from Account where id=:varContactDetail.AccountiD limit 1].name;   
            cls_UserData varSiteLead= new cls_UserData();
            List<cls_ExtraParameters> moreListItem = new List<cls_ExtraParameters>();
            cls_ExtraParameters varExtraParameters = new cls_ExtraParameters();
            
            varSiteLead.Firstname = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(varContactDetail.firstname)));
            varSiteLead.Surname= EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(varContactDetail.lastname)));
           // varSiteLead.Surname= EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(varContactDetail.lastname)));
            varSiteLead.Phone=varContactDetail.Phone;
            varSiteLead.Email=varContactDetail.Email;
            varSiteLead.SecretKey=SecretKey;
            varSiteLead.UserId=varContactDetail.FS_RefId__c;
            varSiteLead.Address=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(varContactDetail.MailingStreet)));
            varSiteLead.City=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(varContactDetail.mailingcity)));
            varSiteLead.BusinessPostalCode=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(varContactDetail.MailingPostalCode)));
            varSiteLead.Country=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(varContactDetail.MailingCountry)));
            
            varExtraParameters = new cls_ExtraParameters();
            
            varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(FS_ContactUtility.DECISIONMAKER)));
            varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(string.valueOf(varContactDetail.FS_Decision_Maker__c))));
            
            moreListItem.add(varExtraParameters);
            
            if(!String.isBlank(UserInfo.getName())){
                varExtraParameters = new cls_ExtraParameters();
                
                varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(FS_ContactUtility.OWNERNAMETEXT)));
                varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(UserInfo.getName())));
                moreListItem.add(varExtraParameters);
            }
            else
            {
                varExtraParameters = new cls_ExtraParameters(); 
            } 
             if(!String.isBlank(UserInfo.getName())){
                varExtraParameters = new cls_ExtraParameters();
                
                varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(FS_ContactUtility.OWNERNAMETEXT)));
                varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(UserInfo.getName())));
                moreListItem.add(varExtraParameters);
            }
            else
            {
                varExtraParameters = new cls_ExtraParameters(); 
            } 
            
            if(!String.isBlank(varContactDetail.AccountId)){
                varExtraParameters = new cls_ExtraParameters();
                
                varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(FS_ContactUtility.ACCOUNTIDTEXT)));
                varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(varContactDetail.AccountId)));
                moreListItem.add(varExtraParameters);
            }
            else
            {
                varExtraParameters = new cls_ExtraParameters(); 
            }
            if(!String.isBlank(varContactDetail.mailingState)){
                varExtraParameters = new cls_ExtraParameters();
                
                varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(FS_ContactUtility.STATETEXTVALUE)));
                varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(varContactDetail.mailingState)));
                moreListItem.add(varExtraParameters);
            }
            else
            {
                varExtraParameters = new cls_ExtraParameters(); 
            } 
            if(moreListItem.size()!=0)
                varSiteLead.ExtraParameters=moreListItem;
            else
            {
                varSiteLead.ExtraParameters=null;
            }
            fromJSON varSiteLeadMain = new fromJSON();
            
            varSiteLeadMain.UserData=varSiteLead;
            
            String reqString;
            reqString=JSON.serialize(varSiteLeadMain);
            system.debug('+++++++++++Request++++++++++++++++'+reqString);
            
            
            String clientId =Label.FS_PIIClientId; 
            String clientSecret=Label.FS_ClientSecretKey;
            
            
            HttpRequest req = new HttpRequest();
            
            req.setHeader(FS_ContactUtility.CONTENTTYPETEXT, FS_ContactUtility.APPPLICATIONJSONTEXT);
            req.setHeader(FS_ContactUtility.CLIENTIDTEXT, clientId);
            req.setHeader(FS_ContactUtility.CLIENTSECRETTEXT, clientSecret);
            
            req.setEndpoint('https://pii.eu.cloudhub.io/api/siteLead');
            req.setMethod('PUT');         
            req.setBody(reqString);
            
            Http http = new Http();
            HTTPResponse res = new HTTPResponse();
            try{
                
                res = http.send(req);
                
            }catch(System.CalloutException e) {
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,FS_ContactUtility.ERRORMESSAGE));
                return null;
            }
            
            
            System.debug('res.getStatus()'+res.getStatus());
            System.debug('res.getStatusCode()'+res.getStatusCode());
            System.debug('-----Body--'+res.getBody());
          
          
             if(Integer.valueOf(res.getStatusCode())==FS_ContactUtility.STATUSCODE){
                
                JSONParser parser1 = JSON.createParser(String.valueOf(res.getBody()));
                String errorCode;
                while (parser1 .nextToken() != null) {
                    if ((parser1 .getCurrentToken() == JSONToken.FIELD_NAME)) {
                        String fieldName = parser1.getText();
                        parser1.nextToken();
                        if (fieldName.equals('ErrorCode')) {
                            errorCode= parser1.getText();
                        } 
                    }
                    
                }
                
                if(errorCode=='300'){
                      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Entered Telephone numebr or Email is already existed'));
                      return null;
                
                }else if(errorCode=='0'){
                
                JSONParser parser = JSON.createParser(String.valueOf(res.getBody()));
                String resId;
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                        String fieldName = parser.getText();
                        parser.nextToken();
                        if (fieldName.equals(FS_ContactUtility.IDTEXTFOREXTRAPARAMETERS)) {
                            resId = parser.getText();
                        } 
                    }
                    
                }
                
            /*    
                Contact newCon = new Contact();
                newCon.AccountID =varContactDetail.AccountiD;
                newCon.FirstName =varContactDetail.FirstName ;
                newCon.LastName =varContactDetail.LastName ;
                newCon.FS_PIEncryptKey__c=EncodingUtil.base64Encode(cryptoKey);
                 newCon.FS_Position__c=varContactDetail.FS_Position__c;
                newCon.FS_Decision_Maker__c =varContactDetail.FS_Decision_Maker__c;
                newCon.FS_RefId__c=resId;
                insert newCon ;
                
                PageReference acctPage = new PageReference(FS_ContactUtility.CONTACTDETAILURL+resId);
                acctPage.setRedirect(true);
                return acctPage;  */
               
                varContactDetail.Phone=null;
            varContactDetail.Email=null;
            varContactDetail.MailingStreet=null;
            varContactDetail.mailingcity=null;
            varContactDetail.mailingState=null;
            varContactDetail.MailingPostalCode=null;
            varContactDetail.MailingCountry=null;
            update varContactDetail; 
            PageReference acctPage = new PageReference('/apex/FS_ContactDetailPage?id='+varContactDetail.FS_RefId__c);
            acctPage.setRedirect(true);
            return acctPage;
               
            }  
             
            
          } 
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter a valid 11 digit Telephone numebr'));
            return null;
        }
        
        return null;
    }
    
    
    /* * Constructor for FS_ContactDetail_CC
*  @name FS_ContactDetail_CC
*  @param custom controller
*  @return 
*  @throws 
*/ 
    Public FS_ContactDetail_CC_EditV1()
    {
        FIRSTNAMETEXT='First Name';
        CONTACTINFORMATIONEXT='Contact Information';
        LASTNAMETEXT='Last Name';
        ACCOUNTNAMETEXT='Account Name';
        TELEPHONETEXT='Telephone';
        EMAILTEXT='Email';
        POSITIONTEXT='Position';
        DECISIONMAKERTEXT='Decision Maker';
        MAILINGSTREETTEXT='Mailing Street';
        MAILINGCITYTEXT='Mailing City';
        MAILINGSTATETEXT='Mailing State/Province';
        MAILINGPOSTALTEXT='Mailing PostalCode';
        MAILINGCOUNTRYTEXT='Mailing Country';
        ADDRESSTEXT='Address Information';
        EditMode=false;
        
        cryptoKey = Crypto.generateAesKey(FS_ContactUtility.ENCRYPTINTEGER);
        
        varContactDetail=new Contact();
        
        String accountId = apexpages.currentpage().getparameters().get(FS_ContactUtility.IDTEXTFORACCOUNT );
        
        String mode= apexpages.currentpage().getparameters().get('mode');
        
        if(mode=='edit')
        {
        EditMode=true;
        }
        
        
        varContactDetail = [select id,FirstName, LastName,FS_Position__c,FS_Decision_Maker__c,FS_PIEncryptKey__c,Phone,Email,MailingStreet,MailingCity,MailingPostalCode,MailingCountry, OwnerId,Owner.name, FS_RefId__c,Account.Name, AccountId from Contact where FS_RefId__c=:accountId limit 1];
        
        
        String urlId =Label.FS_UrlId+FS_ContactUtility.SITELEADID+accountId;
        String clientId =Label.FS_PIIClientId; 
        String clientSecretKey=Label.FS_ClientSecretKey; 
        Http h = new Http();
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest varRequest = new HttpRequest();
        varRequest.setHeader(FS_ContactUtility.CONTENTTYPE, FS_ContactUtility.APPLICATIONJSON);
        varRequest.setHeader(FS_ContactUtility.CLIENTIDTEXT, clientId);
        varRequest.setHeader(FS_ContactUtility.CLIENTSECRETTEXT, clientSecretKey);
        varRequest.setTimeout(120000);
        
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
                System.debug('varResponse'+varResponse.getBody());
            }
        }
        catch(Exception e)
            
        {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            varContactDetail= new Contact();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,FS_ContactUtility.ERRORMESSAGERETRIVE));
            
        }
        
        if(varResponse.getStatus()!=FS_ContactUtility.STATUSVALUEOK && Integer.valueOf(varResponse.getStatusCode())!=FS_ContactUtility.STATUSCODE){
            varContactDetail= new Contact();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,FS_ContactUtility.ERRORMESSAGERETRIVE ));
        }else{
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
            
            
            /*if(!String.isBlank(varContactDetailHelper.GetSiteLeadResult.SiteLead.Email))
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
}*/
            
            varContactDetail.Email=varContactDetailHelper.GetSiteLeadResult.SiteLead.Email;
            
            if(!String.isBlank(varContactDetailHelper.GetSiteLeadResult.SiteLead.Phone))
                varContactDetail.Phone=varContactDetailHelper.GetSiteLeadResult.SiteLead.Phone;
            
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
        /*    if(!String.isBlank(varContactDetailHelper.GetSiteLeadResult.SiteLead.BusinessPostalCode))
            {
                varContactDetail.MailingPostalCode=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(varContactDetailHelper.GetSiteLeadResult.SiteLead.BusinessPostalCode))).toString();
            }
            else
            {
                varContactDetail.MailingPostalCode=null;
            }
            */
            if(!String.isBlank(varContactDetailHelper.GetSiteLeadResult.SiteLead.Country))
            {
                varContactDetail.MailingCountry=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(varContactDetailHelper.GetSiteLeadResult.SiteLead.Country))).toString();
            }  
            else
            {
                varContactDetail.MailingCountry=null;
            }
            
            SecretKey=varContactDetailHelper.GetSiteLeadResult.SiteLead.SecretKey;
            
            for(FS_ContactDetailHelper_CC.FS_ExtraParameters str: varContactDetailHelper.GetSiteLeadResult.SiteLead.extraParameters)
            {
                /*   if (((Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(str.name))).toString()).equals(FS_ContactUtility.POSITIONTEXTVALUE))
{
varContactDetail.FS_Position__c= (Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(str.Value))).toString();

} */
if(str.name.equals('Email'))
{
varContactDetail.Email=varContactDetail.MailingState=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(str.Value))).toString();
}
if(str.name.equals('PostalCode'))
{
varContactDetail.MailingPostalCode= varContactDetail.MailingState=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(str.Value))).toString();
              
}
                if (str.name.equals(FS_ContactUtility.STATETEXTVALUE))
                {
                    varContactDetail.MailingState=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(str.Value))).toString();
                }
                /*  if (((Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(str.name))).toString()).equals(FS_ContactUtility.DECISIONMAKER))
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
} */
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
    
    
    
    public without sharing class fromJSON{
        public cls_UserData UserData;
        
    }
    
    
    class cls_UserData {
        public String SecretKey;    //47955bc44438c3f85617f38d176dd885
        public String UserId;   //a0afbed0-1028-4366-a581-2f5754317de6
        public String Password; //123456
        public String Email;    //pavan.svnit@gmail.com
        public String Firstname;    //Pavan2
        public String Middlename;   //middle2
        public String Surname;  //lastName2
        public Integer Age; //25
        public String BirthDate;    //1990-09-01Z
        public String Country;  //Russia2
        public String Address;  //address, 4 - 331
        public String City; //231
        public boolean PersonalDataAgree;
        public String Gender;   //Male
        public String Phone;    //11234567801
        public String BusinessName; //OOO MTC
        public String BusinessPostalCode;   //449543
        public String FacebookId;   //8973841
        public String MaritalStatus;    //Married
        public String SocialStatus; //socialStatus
        public String PropertyStatus;   //propertyStatus
        public String Profession;   //Developer
        public Integer Income;   //70000
        public String PassportNumber;   //3606789654
        public List<cls_ExtraParameters> ExtraParameters;
        public cls_UserData(){
            Age=0;
            BirthDate=FS_ContactUtility.BLANKTEXT;
            PersonalDataAgree=true;
            Gender=FS_ContactUtility.BLANKTEXT;
            BusinessName=FS_ContactUtility.BLANKTEXT;
            FacebookId=FS_ContactUtility.BLANKTEXT;
            
            
            MaritalStatus=FS_ContactUtility.BLANKTEXT;
            SocialStatus=FS_ContactUtility.BLANKTEXT;
            PropertyStatus=FS_ContactUtility.BLANKTEXT;
            Profession=FS_ContactUtility.BLANKTEXT;
            Income=0;
            PassportNumber=FS_ContactUtility.BLANKTEXT;      
        }
    }
    class cls_ExtraParameters {
        public String Name; //Number of pets
        public String Value;    //2
    }
    public static fromJSON parse(String json){
        return (fromJSON) System.JSON.deserialize(json, fromJSON.class);
    }
    
    
}