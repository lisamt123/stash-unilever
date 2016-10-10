Public with sharing class FS_ContactDetail_CC {
    
    Public Contact varContactDetail{get;set;}
    public FS_ContactDetailHelper_CC varContactDetailHelper {get;set;}
    public String Position {get;set;}
    public String State{get;set;}
    public Boolean DecisionMakerBoolean{get;set;}
    public String FName {get;set;}
    public Boolean EditMode{get;set;}
    public String SecretKey;
    public Blob cryptoKey;
    List<FS_ExtraParameters> moreListItem = new List<FS_ExtraParameters>();
    Public String workPhoneNumber{get;set;}
    Public String personalPhoneNumber{get;set;}
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
    
    
    
    /* * Constructor for FS_ContactDetail_CC
*  @name FS_ContactDetail_CC
*  @param custom controller
*  @return 
*  @throws 
*/ 
    Public FS_ContactDetail_CC()
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
        String mode= apexpages.currentpage().getparameters().get(FS_ContactUtility.MODETEXT);
        
        if(mode==FS_ContactUtility.EDITTEXT){
            EditMode=true;
        }
        
        varContactDetail = [select id,FirstName, LastName,FS_PIEncryptKey__c,Phone,Email,FS_Position__c,FS_Decision_Maker__c,MailingStreet,MailingCity,MailingPostalCode,MailingCountry, OwnerId,Owner.name, FS_RefId__c,Account.Name, AccountId from Contact where FS_RefId__c=:accountId limit 1];
        String urlId =Label.FS_UrlId+FS_ContactUtility.SITELEADID+accountId;
        String clientId =Label.FS_PIIClientId; 
        String clientSecretKey=Label.FS_ClientSecretKey; 
        Http varHttp = new Http();
        
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
                varResponse.setStatusCode(FS_ContactUtility.STATUSCODE);
                varResponse.setStatus(FS_ContactUtility.STATUSVALUEOK); 
            }
            else
            {
                varResponse = varHttp.send(varRequest);
                
            }
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,FS_ContactUtility.ERRORMESSAGERETRIVE));
        }
        
        if(varResponse.getStatus()!=FS_ContactUtility.STATUSVALUEOK && Integer.valueOf(varResponse.getStatusCode())!=FS_ContactUtility.STATUSCODE){
            varContactDetail= new Contact();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,FS_ContactUtility.ERRORMESSAGERETRIVE ));
        }
        else{
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
            
            
            SecretKey=varContactDetailHelper.GetSiteLeadResult.SiteLead.SecretKey;
            
            for(FS_ContactDetailHelper_CC.FS_ExtraParameters str: varContactDetailHelper.GetSiteLeadResult.SiteLead.extraParameters)
            {
                if(!String.isblank(str.name))
                {
                    if(str.name.equals(FS_ContactUtility.MYEMAILTEXT))        
                    {       
                        varContactDetail.Email=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(str.Value))).toString();        
                    }       
                    if(str.name.equals(FS_ContactUtility.CODEPOSTALTEXT))       
                    {       
                        varContactDetail.MailingPostalCode=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(str.Value))).toString();       
                    }
                    
                    if(str.name.equals(FS_ContactUtility.MOBILEPHONETEXT))        
                    {       
                        varContactDetail.Phone=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(str.Value))).toString();        
                    }       
                    if(str.name.equals(FS_ContactUtility.WORKPHONETEXT))       
                    {       
                        workPhoneNumber=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(str.Value))).toString();       
                    }
                    if(str.name.equals(FS_ContactUtility.PERSONALPHONETEXT))       
                    {       
                        personalPhoneNumber=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(str.Value))).toString();       
                    }
                    
                    if (str.name.equals(FS_ContactUtility.STATETEXTVALUE))
                    {
                        varContactDetail.MailingState=(Crypto.decryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c),  EncodingUtil.base64Decode(str.Value))).toString();
                    }
                    
                }
                
            }    
        }    
    }
    
    
    
    /* * Method for update Contact
*  @name updateContact
*  @param custom controller
*  @return PageReference 
*  @throws 
*/ 
    
    Public PageReference updateContact()
    {
        if( (String.Isblank(varContactDetail.phone) || (varContactDetail.phone.length()<FS_ContactUtility.VALIDPHONELENGTH)) &&
           (String.Isblank(workPhoneNumber) || (workPhoneNumber.length()<FS_ContactUtility.VALIDPHONELENGTH)) &&
           (String.Isblank(personalPhoneNumber) || (personalPhoneNumber.length()<FS_ContactUtility.VALIDPHONELENGTH))
          )
        {
            try
            {
                String  varAccountName=[select id,name from Account where id=:varContactDetail.AccountiD limit 1].name;   
                FS_UserData varSiteLead= new FS_UserData();
                
                varSiteLead.Firstname = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(varContactDetail.firstname)));
                varSiteLead.Surname= EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(varContactDetail.lastname)));
                varSiteLead.SecretKey=SecretKey;
                varSiteLead.UserId=varContactDetail.FS_RefId__c;
                varSiteLead.Address=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(varContactDetail.MailingStreet)));
                varSiteLead.City=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(varContactDetail.mailingcity)));
                varSiteLead.BusinessPostalCode=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(varContactDetail.MailingPostalCode)));
                varSiteLead.Country=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(varContactDetail.MailingCountry)));
                
                
                addExtraParameter(FS_ContactUtility.DECISIONMAKER,string.valueOf(varContactDetail.FS_Decision_Maker__c));
                addExtraParameter(FS_ContactUtility.MYEMAILTEXT,varContactDetail.Email);     
                addExtraParameter(FS_ContactUtility.CODEPOSTALTEXT,varContactDetail.MailingPostalCode);        
                addExtraParameter(FS_ContactUtility.MOBILEPHONETEXT,varContactDetail.phone); 
                addExtraParameter(FS_ContactUtility.WORKPHONETEXT,workPhoneNumber); 
                addExtraParameter(FS_ContactUtility.PERSONALPHONETEXT,personalPhoneNumber);
                addExtraParameter(FS_ContactUtility.POSITIONTEXT,varContactDetail.FS_Position__c);
                addExtraParameter(FS_ContactUtility.STATETEXT,varContactDetail.MailingState);
                addExtraParameter(FS_ContactUtility.OWNERIDTEXT,UserInfo.getUserId());
                addExtraParameter(FS_ContactUtility.OWNERNAMETEXT,UserInfo.getName());
                addExtraParameter(FS_ContactUtility.ACCOUNTIDTEXT,varContactDetail.AccountId);
                addExtraParameter(FS_ContactUtility.ACCOUNTNAMETEXT,varAccountName);
                
                if(moreListItem.size()!=0)
                    varSiteLead.ExtraParameters=moreListItem;
                else
                {
                    varSiteLead.ExtraParameters=null;
                }
                
                
                FS_RequestForEdit varSiteLeadMain = new FS_RequestForEdit();
                varSiteLeadMain.UserData=varSiteLead;
                String reqString;
                reqString=JSON.serialize(varSiteLeadMain);
                
                String clientId =Label.FS_PIIClientId; 
                String clientSecret=Label.FS_ClientSecretKey;
                
                
                HttpRequest req = new HttpRequest();
                req.setHeader(FS_ContactUtility.CONTENTTYPETEXT, FS_ContactUtility.APPPLICATIONJSONTEXT);
                req.setHeader(FS_ContactUtility.CLIENTIDTEXT, clientId);
                req.setHeader(FS_ContactUtility.CLIENTSECRETTEXT, clientSecret);
                req.setTimeout(120000);
                req.setEndpoint(Label.FS_UrlId);
                req.setMethod('PUT');         
                req.setBody(reqString);
                
                Http http = new Http();
                HTTPResponse res = new HTTPResponse();
                try{
                    if(Test.isRunningTest())
                    {
                        res.setBody(jsonresponse);
                        res.setStatusCode(200);
                        res.setStatus('Ok'); 
                    }
                    else
                    {
                        res = http.send(req);
                    }
                }catch(System.CalloutException e) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,FS_ContactUtility.ERRORMESSAGE));
                    return null;
                }
                
                if(Integer.valueOf(res.getStatusCode())==FS_ContactUtility.STATUSCODE){
                    JSONParser varParserForCode = JSON.createParser(String.valueOf(res.getBody()));
                    String errorCode;
                    while (varParserForCode.nextToken() != null) {
                        if ((varParserForCode.getCurrentToken() == JSONToken.FIELD_NAME)) {
                            String fieldName = varParserForCode.getText();
                            varParserForCode.nextToken();
                            if (!String.isBlank(fieldName) && fieldName.equals(FS_ContactUtility.CODEERROR)) {
                                errorCode= varParserForCode.getText();
                            } 
                        }
                    }
                    
                    if(errorCode==FS_ContactUtility.THREEHUNTEXT){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,FS_ContactUtility.TELEPHONETEXT));
                        return null;
                    }else if(errorCode==FS_ContactUtility.ZEROTEXT){
                        
                        varContactDetail.Phone=null;
                        varContactDetail.Email=null;
                        varContactDetail.MailingStreet=null;
                        varContactDetail.mailingcity=null;
                        varContactDetail.mailingState=null;
                        varContactDetail.MailingPostalCode=null;
                        varContactDetail.MailingCountry=null;
                        update varContactDetail; 
                        PageReference acctPage = new PageReference(FS_ContactUtility.CONTACTDETAILURL+varContactDetail.FS_RefId__c);
                        acctPage.setRedirect(true);
                        return acctPage;
                    }  
                } 
            }
            Catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,FS_ContactUtility.ERRORMESSAGE));
                return null;
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,FS_ContactUtility.MOBILEERRORTEXT));
            return null;
        } 
        return null;
    }
    
    
    
    /* * Method for Adding ExtraParameter values
*  @name addExtraParameter
*  @param String 
*  @return  
*  @throws 
*/
    Private void addExtraParameter(String Name,String Value)
    {
        FS_ExtraParameters varExtraParameters = new FS_ExtraParameters();
        varExtraParameters.Name=Name;
        if(!String.isBlank(Value))
        varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf(value)));
        else
        varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode(varContactDetail.FS_PIEncryptKey__c), Blob.valueOf('')));
        moreListItem.add(varExtraParameters);
    }
    
    /* * Method for Changing page From Detail to Edit 
*  @name editPage
*  @param  
*  @return  
*  @throws 
*/
    Public PageReference editPage()
    {
        EditMode=true;
        return null;
    }
    
    /* * Method for Changing page From Edit to  Detail 
*  @name editPage
*  @param  
*  @return  
*  @throws 
*/
    Public PageReference DetailPage()
    {
        PageReference acctPage = new PageReference(FS_ContactUtility.CONTACTDETAILURL+varContactDetail.FS_RefId__c);
        acctPage.setRedirect(true);
        return acctPage;
    }
    
    
    /* * Wrapper cals for Edit Contact to intract with Brandton though mulesoft
*  @name FS_RequestForEdit 
*  @param 
*  @return  
*  @throws 
*/   
    public without sharing class FS_RequestForEdit{
        public FS_UserData UserData;
    }
    
    /* * Sub class for Edit Contact to intract with Brandton though mulesoft
*  @name FS_RequestForEdit 
*  @param 
*  @return  
*  @throws 
*/ 



public virtual without sharing class FS_SiteLeadMainchild {
    
              
                public String MaritalStatus;    //Married
                public String SocialStatus; //socialStatus
                public String PropertyStatus;   //propertyStatus
                public String Profession;   //Developer
                public Integer Income;   //70000
                public String PassportNumber;   //3606789654
              
    }
    
    public virtual without sharing class FS_SiteLeadMainchildAdress extends FS_SiteLeadMainchild  {
    
                public String Address;  //address-1, 4 - 33
                public String City; //city1
                public String BusinessPostalCode;   //449543 
                public String Country;  //Russia
    }
    
    
    class FS_UserData extends FS_SiteLeadMainchildAdress {
        public String SecretKey;    //47955bc44438c3f85617f38d176dd885
        public String UserId;   //a0afbed0-1028-4366-a581-2f5754317de6
        public String Password; //123456
        public String Email;    //pavan.svnit@gmail.com
        public String Firstname;    //Pavan2
        public String Middlename;   //middle2
        public String Surname;  //lastName2
        public Integer Age; //25
        public String BirthDate;    //1990-09-01Z
        public boolean PersonalDataAgree;
        public String Gender;   //Male
        public String Phone;    //11234567801
        public String BusinessName; //OOO MTC
        public String FacebookId;   //8973841
        public List<FS_ExtraParameters> ExtraParameters;
        public FS_UserData(){
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
    class FS_ExtraParameters {
        public String Name; //Number of pets
        public String Value;    //2
    }
    public static FS_RequestForEdit parse(String json){
        return (FS_RequestForEdit) System.JSON.deserialize(json, FS_RequestForEdit.class);
    }
    
}