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



public without sharing class FS_CreateContact_CC {
    
    
    Public Contact varContactDetail{get;set;}
    Public ID accId ;
    Private String varAccountName;
    Public String workPhoneNumber{get;set;}
    Public String personalPhoneNumber{get;set;}
    Public Static Final String varResonseResult='{"AddSiteLeadResult": {     "ErrorCode": 0,     "Message": "???????? ?????????",     "SiteLead": {       "Address": "address-1, 4 - 33",       "Age": 28,       "BirthDate": "1987-01-12",       "BusinessAddress": "",       "BusinessName": "OOO MTC",       "BusinessPostalCode": "449543",       "City": "city1",       "Country": "Russia",       "Email": "tolmachev@example.com",       "ExtraParameters": [         {           "Name": "Number of pets",           "Value": "2"         },         {           "Name": "Job",           "Value": "Developer"         }       ],       "FacebookId": "897384",       "Firstname": "Tol",       "Gender": "Male",       "Id": "feff7eae-f646-4ba5-987f-ecd265e498f0",       "Income": 70000,       "JobTitle": "",       "LandlinePhone": "89345673245",       "MaritalStatus": "Married",       "Middlename": "middleName",       "OkId": "0294485",       "PassportNumber": "3606789654",       "PersonalDataAgree": true,       "Phone": "89270087098",       "PropertyStatus": "propertyStatus",       "SocialStatus": "socialStatus",       "Surname": "Machev",       "Username": "Tolmachev",       "VkId": "789347503"     },     "Success": true,     "Warnings": []   } }';
    Public Blob cryptoKey{get;set;}
    List<FS_ExtraParameters> moreListItem = new List<FS_ExtraParameters>();
    Public Final String SAVETEXT{get;set;}
    Public Final String OWNEREXT{get;set;}
    Public Final String lASTNAMETEXT{get;set;}
    Public Final String TRUETEXT{get;set;}
    Public Final String TELEPHONETEXT{get;set;}
    
    /* * Constructor for FS_CreateContact_CC
*  @name FS_CreateContact_CC
*  @param custom controller
*  @return 
*  @throws 
*/ 
    Public FS_CreateContact_CC()
    {
        
        SAVETEXT=FS_ContactUtility.MYSAVETEXT;
        OWNEREXT=FS_ContactUtility.MYOWNERTEXT;
        lASTNAMETEXT=FS_ContactUtility.MYLASTNAMETEXT;
        TRUETEXT=FS_ContactUtility.MYTRUETEXT;
        TELEPHONETEXT=FS_ContactUtility.MYTELEPHONETEXT;
        
        varContactDetail=new Contact();
        try
        {
            if(apexpages.currentpage().getparameters().get(FS_ContactUtility.IDTEXTFORACCOUNT)!=null)
            {
                varContactDetail.AccountiD= apexpages.currentpage().getparameters().get(FS_ContactUtility.IDTEXTFORACCOUNT);
            }
        }
        Catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,FS_ContactUtility.ERRORMESSAGE));
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
        if((!String.Isblank(varContactDetail.phone) && (varContactDetail.phone.length()<20)) ||
                (!String.Isblank(workPhoneNumber) && (workPhoneNumber.length()<20)) ||
                    (!String.Isblank(personalPhoneNumber) && (personalPhoneNumber.length()<20))
            )
        {
        try
        {
            varAccountName=[select id,name from Account where id=:varContactDetail.AccountiD limit 1].name;
            cryptoKey = Crypto.generateAesKey(256);
            FS_SiteLead varSiteLead = new FS_SiteLead();
            if(!String.isBlank(varContactDetail.firstname))
            {
                varSiteLead.Firstname = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey,Blob.valueOf(varContactDetail.firstname)));
            }
            else
            {
                varSiteLead.Firstname=null;
            }
            
            if(!String.isBlank(varContactDetail.Lastname))
            {
                varSiteLead.Surname = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varContactDetail.lastname)));
            }
            else
            {
                varSiteLead.Surname=null;
            }
            if(!String.isBlank(varContactDetail.MailingStreet))
            {
                
                varSiteLead.Address=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varContactDetail.MailingStreet)));
            } 
            else
            {
                varSiteLead.Address=null;
            }
            if(!String.isBlank(varContactDetail.mailingcity))
            {
                varSiteLead.City=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varContactDetail.mailingcity)));          
            } 
            else
            {
                varSiteLead.City=null;
            }
            if(!String.isBlank(varContactDetail.MailingCountry))
            {
                varSiteLead.Country=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varContactDetail.MailingCountry)));   
            }
            addExtraParameter(FS_ContactUtility.DECISIONMAKER,string.valueOf(varContactDetail.FS_Decision_Maker__c));
            
            if( !String.isBlank(varContactDetail.Email))       
                addExtraParameter(FS_ContactUtility.MYEMAILTEXT,varContactDetail.Email);     
            
            if( !String.isBlank(varContactDetail.MailingPostalCode))
                addExtraParameter(FS_ContactUtility.CODEPOSTALTEXT,varContactDetail.MailingPostalCode);        
            
            if( !String.isBlank(varContactDetail.phone))
                addExtraParameter(FS_ContactUtility.MOBILEPHONETEXT,varContactDetail.phone); 
            
            
            if( !String.isBlank(workPhoneNumber))
                addExtraParameter(FS_ContactUtility.WORKPHONETEXT,workPhoneNumber); 
            
            if( !String.isBlank(personalPhoneNumber))
                addExtraParameter(FS_ContactUtility.PERSONALPHONETEXT,personalPhoneNumber);
            
            if( !String.isBlank(varContactDetail.FS_Position__c))
                addExtraParameter(FS_ContactUtility.POSITIONTEXT,varContactDetail.FS_Position__c);
            
            if(!String.isBlank(varContactDetail.MailingState))
                addExtraParameter(FS_ContactUtility.STATETEXT,varContactDetail.MailingState);
            
            addExtraParameter(FS_ContactUtility.OWNERIDTEXT,UserInfo.getUserId());
            
            if(!String.isBlank(UserInfo.getName()))
                addExtraParameter(FS_ContactUtility.OWNERNAMETEXT,UserInfo.getName());
            
            if(!String.isBlank(varContactDetail.AccountId))
                addExtraParameter(FS_ContactUtility.ACCOUNTIDTEXT,varContactDetail.AccountId);
            
            if(!String.isBlank(varAccountName))
                addExtraParameter(FS_ContactUtility.ACCOUNTNAMETEXT,varAccountName);
            
            if(moreListItem.size()!=0)
                varSiteLead.ExtraParameters=moreListItem;
            else
                varSiteLead.ExtraParameters=null;
            
            FS_SiteLeadMain varSiteLeadMain = new FS_SiteLeadMain();
            varSiteLeadMain.SiteLead=varSiteLead;
            
            String reqString;
            reqString=JSON.serialize(varSiteLeadMain);
            
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
                    res.setStatusCode(FS_ContactUtility.STATUSCODE);
                    res.setStatus(FS_ContactUtility.STATUSVALUEOK);
                }
                else
                {
                    res = http.send(req);
                }
            }
            catch(System.CalloutException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,FS_ContactUtility.ERRORMESSAGE));
                return null;
            }
            
            
            if(Integer.valueOf(res.getStatusCode())==FS_ContactUtility.STATUSCODE){
                JSONParser parser1 = JSON.createParser(String.valueOf(res.getBody()));
                String errorCode;
                while (parser1 .nextToken() != null) {
                    if ((parser1 .getCurrentToken() == JSONToken.FIELD_NAME)) {
                        String fieldName = parser1.getText();
                        parser1.nextToken();
                        if (fieldName.equals(FS_ContactUtility.CODEERROR)){
                            errorCode= parser1.getText();
                        } 
                    }
                }
                
                if(errorCode==FS_ContactUtility.THREEHUNTEXT){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,FS_ContactUtility.TELEPHONETEXT));
                    return null;
                }else if(errorCode==FS_ContactUtility.ZEROTEXT){
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
                    return acctPage;
                }  
                
            }else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,FS_ContactUtility.ERRORMESSAGE));
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
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter valid Phone number'));
                return null;
        }
        return null;
    }
    
    
    Private void addExtraParameter(String Name,String Value)
    {
        if(!String.isBlank(Value))
        {
            FS_ExtraParameters varExtraParameters = new FS_ExtraParameters();
            varExtraParameters.Name=Name;
            varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(Value)));
            moreListItem.add(varExtraParameters);
        }
        
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