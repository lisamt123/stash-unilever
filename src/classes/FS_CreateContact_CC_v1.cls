/**********************************************************************
Name: FS_CreateContact_CC
======================================================
======================================================
Purpose: For Creating Contact Vf page
-------
======================================================
======================================================
History
-------
VERSION AUTHOR   DATE        DETAIL Description
1.0     Dinesh  20/07/2016   INITIAL DEVELOPMENT 
***********************************************************************/



public with sharing class FS_CreateContact_CC_v1 {
    
    
    Public Contact varContactDetail{get;set;}
    Public ID accId ;
    Private String varAccountName;
    Public Static Final String varResonseResult='{"AddSiteLeadResult": {     "ErrorCode": 0,     "Message": "???????? ?????????",     "SiteLead": {       "Address": "address-1, 4 - 33",       "Age": 28,       "BirthDate": "1987-01-12",       "BusinessAddress": "",       "BusinessName": "OOO MTC",       "BusinessPostalCode": "449543",       "City": "city1",       "Country": "Russia",       "Email": "tolmachev@example.com",       "ExtraParameters": [         {           "Name": "Number of pets",           "Value": "2"         },         {           "Name": "Job",           "Value": "Developer"         }       ],       "FacebookId": "897384",       "Firstname": "Tol",       "Gender": "Male",       "Id": "feff7eae-f646-4ba5-987f-ecd265e498f0",       "Income": 70000,       "JobTitle": "",       "LandlinePhone": "89345673245",       "MaritalStatus": "Married",       "Middlename": "middleName",       "OkId": "0294485",       "PassportNumber": "3606789654",       "PersonalDataAgree": true,       "Phone": "89270087098",       "PropertyStatus": "propertyStatus",       "SocialStatus": "socialStatus",       "Surname": "Machev",       "Username": "Tolmachev",       "VkId": "789347503"     },     "Success": true,     "Warnings": []   } }';
    Public Blob cryptoKey{get;set;}
    
    /* * Constructor for FS_CreateContact_CC
*  @name FS_CreateContact_CC
*  @param custom controller
*  @return 
*  @throws 
*/ 
    
    
    Public FS_CreateContact_CC_v1()
    {
        varContactDetail=new Contact();
        try
        {
            accId = apexpages.currentpage().getparameters().get('id');
            varContactDetail.AccountiD=accId;
            varAccountName=[select id,name from Account where id=:accId limit 1].name;
        }
        Catch(Exception e)
        {
        }
        
    }
    
    
    /* * Function for creating Contact
*  @name createContact
*  @param custom controller
*  @return PageReference 
*  @throws 
*/ 
    
    Public PageReference createContact()
    {
        
        try
        {
            
            cryptoKey = Crypto.generateAesKey(256);
            system.debug('++++++++++ cryptoKey ++++++++++++'+cryptoKey);
            
            
            
            FS_SiteLead varSiteLead = new FS_SiteLead();
            List<FS_ExtraParameters> moreListItem = new List<FS_ExtraParameters>();
            FS_ExtraParameters varExtraParameters = new FS_ExtraParameters();
            
            
            if(!String.isBlank(varContactDetail.firstname))
            {
                if(test.isRunningTest()){
                    
                    varSiteLead.Firstname = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='),Blob.valueOf(varContactDetail.firstname)));
                }else{
                    varSiteLead.Firstname = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey,Blob.valueOf(varContactDetail.firstname)));
                }
                system.debug(varSiteLead.Firstname);
            }
            else
            {
                varSiteLead.Firstname=null;
            }
            
            if(!String.isBlank(varContactDetail.Lastname))
            {
                if(test.isRunningTest()){
                    
                    varSiteLead.Surname = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='),Blob.valueOf(varContactDetail.lastname)));
                }else{
                    
                    varSiteLead.Surname = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varContactDetail.lastname)));
                    system.debug(varSiteLead.Surname );
                }
            }
            else
            {
                varSiteLead.Surname=null;
            }
            
            
            
            if(!String.isBlank(varContactDetail.Email))
            {
                if(test.isRunningTest()){
                    
                    //varSiteLead.Surname = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='),Blob.valueOf(varContactDetail.lastname)));
                    varSiteLead.Email=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(varContactDetail.Email)));
                }else{
                    
                    varSiteLead.Email=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varContactDetail.Email)));
                }
                
            } 
            else
            {
                varSiteLead.Email=null;
            }
            if(!String.isBlank(varContactDetail.phone))
            {
                if(test.isRunningTest()){
                    
                    //varSiteLead.Surname = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='),Blob.valueOf(varContactDetail.lastname)));
                    varSiteLead.Phone=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT,  EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(varContactDetail.phone)));
                }else{
                    varSiteLead.Phone=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varContactDetail.phone)));
                }
            } 
            else
            {
                varSiteLead.phone=null;
            }
            if(!String.isBlank(varContactDetail.MailingStreet))
            {
                if(test.isRunningTest()){
                    
                    //varSiteLead.Surname = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='),Blob.valueOf(varContactDetail.lastname)));
                    varSiteLead.Address=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(varContactDetail.MailingStreet)));
                }else{
                    varSiteLead.Address=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varContactDetail.MailingStreet)));
                } }
            else
            {
                varSiteLead.Address=null;
            }
            if(!String.isBlank(varContactDetail.mailingcity))
            {
                if(test.isRunningTest()){
                    
                    //varSiteLead.Surname = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='),Blob.valueOf(varContactDetail.lastname)));
                    varSiteLead.City=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(varContactDetail.mailingcity)));          
                }else{
                    varSiteLead.City=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varContactDetail.mailingcity)));          
                }
            } 
            else
            {
                varSiteLead.City=null;
            }
            if(!String.isBlank(varContactDetail.MailingPostalCode))
            {
                if(test.isRunningTest()){
                    
                    //varSiteLead.Surname = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='),Blob.valueOf(varContactDetail.lastname)));
                    varSiteLead.BusinessPostalCode=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT,EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(varContactDetail.MailingPostalCode)));
                }else{
                    
                    varSiteLead.BusinessPostalCode=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT,cryptoKey, Blob.valueOf(varContactDetail.MailingPostalCode)));
                }
            }
            else
            {
                varSiteLead.BusinessPostalCode=null; 
            }
            
            if(!String.isBlank(varContactDetail.MailingCountry))
            {
                if(test.isRunningTest()){
                    
                    //varSiteLead.Surname = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='),Blob.valueOf(varContactDetail.lastname)));
                    varSiteLead.Country=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(varContactDetail.MailingCountry)));
                }else{
                    varSiteLead.Country=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varContactDetail.MailingCountry)));   
                }
            }
            else
            {
                varSiteLead.Country=null;
            }
            varExtraParameters = new FS_ExtraParameters();
            if(test.isRunningTest()){
                varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(FS_ContactUtility.DECISIONMAKER)));
                varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(string.valueOf(varContactDetail.FS_Decision_Maker__c))));
                
                
            }
            else{
                varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(FS_ContactUtility.DECISIONMAKER)));
                varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(string.valueOf(varContactDetail.FS_Decision_Maker__c))));
            }
            moreListItem.add(varExtraParameters);
            
            
            if( !String.isBlank(varContactDetail.FS_Position__c)){
                varExtraParameters = new FS_ExtraParameters();
                if(test.isRunningTest()){
                    varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(FS_ContactUtility.POSITIONTEXT)));
                    varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT,  EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(varContactDetail.FS_Position__c)));
                    
                }
                else{
                    varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(FS_ContactUtility.POSITIONTEXT)));
                    varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varContactDetail.FS_Position__c)));
                    
                }
                moreListItem.add(varExtraParameters);
            }
            else
            {
                varExtraParameters = new FS_ExtraParameters();
            }
            if(!String.isBlank(varContactDetail.MailingState)){
                varExtraParameters = new FS_ExtraParameters();
                if(test.isRunningTest()){
                    varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(FS_ContactUtility.STATETEXT)));
                    varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT,  EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(varContactDetail.MailingState)));
                    
                }
                else{
                    
                    varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(FS_ContactUtility.STATETEXT)));
                    varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varContactDetail.MailingState)));
                }
                moreListItem.add(varExtraParameters);
            }
            else
            {
                varExtraParameters = new FS_ExtraParameters(); 
            }
            
            varExtraParameters = new FS_ExtraParameters();
            if(test.isRunningTest()){
                varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT,  EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(FS_ContactUtility.OWNERIDTEXT)));
                varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT,  EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(UserInfo.getUserId())));
                
            }else{
                varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(FS_ContactUtility.OWNERIDTEXT)));
                varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(UserInfo.getUserId())));
                
            }
            moreListItem.add(varExtraParameters);
            
            if(!String.isBlank(UserInfo.getName())){
                varExtraParameters = new FS_ExtraParameters();
                if(test.isRunningTest()){
                    varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT,  EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(FS_ContactUtility.OWNERNAMETEXT)));
                    varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT,  EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(UserInfo.getName())));
                }else{
                    varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT,  cryptoKey, Blob.valueOf(FS_ContactUtility.OWNERNAMETEXT)));
                    varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT,  cryptoKey, Blob.valueOf(UserInfo.getName()))); 
                }
                moreListItem.add(varExtraParameters);
            }
            else
            {
                varExtraParameters = new FS_ExtraParameters(); 
            } 
            
            if(!String.isBlank(varContactDetail.AccountId)){
                varExtraParameters = new FS_ExtraParameters();
                if(test.isRunningTest()){
                    varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT,  EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(FS_ContactUtility.ACCOUNTIDTEXT)));
                    varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT,  EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(varContactDetail.AccountId)));
                    moreListItem.add(varExtraParameters); 
                }else{
                    varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(FS_ContactUtility.ACCOUNTIDTEXT)));
                    varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varContactDetail.AccountId)));
                    moreListItem.add(varExtraParameters);
                }
            }
            else
            {
                varExtraParameters = new FS_ExtraParameters(); 
            }
            if(!String.isBlank(varAccountName)){
                varExtraParameters = new FS_ExtraParameters();
                if(test.isRunningTest()){
                    varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT,  EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(FS_ContactUtility.ACCOUNTNAMETEXT)));
                    varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT,  EncodingUtil.base64Decode('Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264='), Blob.valueOf(varAccountName)));
                    moreListItem.add(varExtraParameters); 
                }else{
                    varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(FS_ContactUtility.ACCOUNTNAMETEXT)));
                    varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varAccountName)));
                    moreListItem.add(varExtraParameters);
                }
            }
            else
            {
                varExtraParameters = new FS_ExtraParameters(); 
            }
            if(moreListItem.size()!=0)
                varSiteLead.ExtraParameters=moreListItem;
            else
            {
                varSiteLead.ExtraParameters=null;
            }
            
            FS_SiteLeadMain varSiteLeadMain = new FS_SiteLeadMain();
            
            varSiteLeadMain.SiteLead=varSiteLead;
            
            String reqString;
            reqString=JSON.serialize(varSiteLeadMain);
            system.debug('Request'+reqString);
            
            
            String clientId =Label.FS_PIIClientId; 
            String clientSecret=Label.FS_ClientSecretKey;
            
            
            HttpRequest req = new HttpRequest();
            
            req.setHeader(FS_ContactUtility.CONTENTTYPETEXT, FS_ContactUtility.APPPLICATIONJSONTEXT);
            req.setHeader(FS_ContactUtility.CLIENTIDTEXT, clientId);
            req.setHeader(FS_ContactUtility.CLIENTSECRETTEXT, clientSecret);
            
            req.setEndpoint(Label.FS_UrlId);
            req.setMethod(FS_ContactUtility.POSTTEXTVALUE);         
            req.setBody(reqString);
            
            Http http = new Http();
            HTTPResponse res = new HTTPResponse();
            try{
                if(Test.isRunningTest())
                {
                    
                    res.setBody(varResonseResult);
                    res.setStatusCode(200);
                    res.setStatus('Ok');
                    
                }
                else
                {
                    System.debug('resuest String'+req.getBody());
                    res = http.send(req);
                    System.debug('respose String'+res.getBody() );
                }
            }catch(System.CalloutException e) {
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,FS_ContactUtility.ERRORMESSAGE));
                return null;
            }
            
            if(res.getStatus()!= FS_ContactUtility.STATUSVALUEOK && Integer.valueOf(res.getStatusCode())!=200){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,FS_ContactUtility.ERRORMESSAGE));
            }else{
                //cls_AddSiteLeadResult companycontacts = (cls_AddSiteLeadResult )JSON.deserialize(String.valueOf(res.getBody()),cls_AddSiteLeadResult.class);
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
                
                
                Contact newCon = new Contact();
                newCon.AccountID =accId;
                newCon.FirstName =varContactDetail.FirstName ;
                newCon.LastName =varContactDetail.LastName ;
                if(test.isRunningTest()){
                    newCon.FS_PIEncryptKey__c='Kx6nJNIC3mEFbiIGNG+YELANLyA7Qj45uY5F1SqX264=';
                }else{
                    newCon.FS_PIEncryptKey__c=EncodingUtil.base64Encode(cryptoKey); 
                }
                
                newCon.FS_RefId__c=resId;
                insert newCon ;
                
                system.debug('====FS_PIEncryptKey__c ========='+newCon.FS_PIEncryptKey__c);
                
                PageReference acctPage = new PageReference(FS_ContactUtility.CONTACTDETAILURL+resId);
                acctPage.setRedirect(true);
                return acctPage;
            }
        }
        Catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,FS_ContactUtility.ERRORMESSAGE));
            return null;
        }
        
        return null;
    }
    
    /* * Wrapper cals for creating Contact to intract with Brandton though mulesoft
*  @name FS_SiteLeadMain
*  @param 
*  @return  
*  @throws 
*/ 
    
    public  without sharing class FS_SiteLeadMain{
        FS_SiteLead SiteLead;
    }
    
    /* * Wrapper cals for creating Contact to intract with Brandton though mulesoft
*  @name FS_SiteLead 
*  @param 
*  @return  
*  @throws 
*/    
    public without sharing class FS_SiteLead {
        public String Email;
        public String Phone;
        public String Firstname;
        //public Blob Firstname;
        public String Middlename;   //middleName
        public String Surname;  //Machev
        public Integer Age; //28
        public String BirthDate;    //1987-01-12Z
        public String Country;  //Russia
        public String Address;  //address-1, 4 - 33
        public String City; //city1
        public boolean PersonalDataAgree;
        public String Gender;   //Male
        public String BusinessName; //OOO MTC
        public String BusinessPostalCode;   //449543
        public String FacebookId;   //897384
        public String VkId; //789347503
        public String OkId; //0294485
        public String MaritalStatus;    //Married
        public String SocialStatus; //socialStatus
        public String PropertyStatus;   //propertyStatus
        public String Profession;   //Developer
        public Integer Income;   //70000
        public String PassportNumber;   //3606789654
        public List<FS_ExtraParameters > ExtraParameters;
        public FS_SiteLead(){
            Age=0;
            BirthDate=FS_ContactUtility.BLANKTEXT;
            PersonalDataAgree=true;
            Gender=FS_ContactUtility.BLANKTEXT;
            BusinessName=FS_ContactUtility.BLANKTEXT;
            FacebookId=FS_ContactUtility.BLANKTEXT;
            VkId=FS_ContactUtility.BLANKTEXT;
            OkId=FS_ContactUtility.BLANKTEXT;
            MaritalStatus=FS_ContactUtility.BLANKTEXT;
            SocialStatus=FS_ContactUtility.BLANKTEXT;
            PropertyStatus=FS_ContactUtility.BLANKTEXT;
            Profession=FS_ContactUtility.BLANKTEXT;
            Income=0;
            PassportNumber=FS_ContactUtility.BLANKTEXT;      
        }
    }
    
    /* * Wrapper cals for creating Contact to intract with Brandton though mulesoft
*  @name FS_ExtraParameters 
*  @param 
*  @return  
*  @throws 
*/ 
    public  without sharing class FS_ExtraParameters {
        public String Name; //Number of pets
        public String Value;    //2
    }
    
    
    
}