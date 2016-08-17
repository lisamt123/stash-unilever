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



public with sharing class FS_CreateContact_CC {
    
    
    Public Contact varContactDetail{get;set;}
    Public ID accId ;
    Private String varAccountName;
    Public Static Final String varResonseResult='{"AddSiteLeadResult": {     "ErrorCode": 0,     "Message": "???????? ?????????",     "SiteLead": {       "Address": "address-1, 4 - 33",       "Age": 28,       "BirthDate": "1987-01-12",       "BusinessAddress": "",       "BusinessName": "OOO MTC",       "BusinessPostalCode": "449543",       "City": "city1",       "Country": "Russia",       "Email": "tolmachev@example.com",       "ExtraParameters": [         {           "Name": "Number of pets",           "Value": "2"         },         {           "Name": "Job",           "Value": "Developer"         }       ],       "FacebookId": "897384",       "Firstname": "Tol",       "Gender": "Male",       "Id": "feff7eae-f646-4ba5-987f-ecd265e498f0",       "Income": 70000,       "JobTitle": "",       "LandlinePhone": "89345673245",       "MaritalStatus": "Married",       "Middlename": "middleName",       "OkId": "0294485",       "PassportNumber": "3606789654",       "PersonalDataAgree": true,       "Phone": "89270087098",       "PropertyStatus": "propertyStatus",       "SocialStatus": "socialStatus",       "Surname": "Machev",       "Username": "Tolmachev",       "VkId": "789347503"     },     "Success": true,     "Warnings": []   } }';
    Public Blob cryptoKey{get;set;}
    
    
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
    
        SAVETEXT='Save';
        OWNEREXT='Owner';
        lASTNAMETEXT='Last Name';
        TRUETEXT='true';
        TELEPHONETEXT='Telephone';
        
        varContactDetail=new Contact();
        try
        {
            if(apexpages.currentpage().getparameters().get(FS_ContactUtility.IDTEXTFORACCOUNT)!=null)
            {
            varContactDetail.AccountiD= apexpages.currentpage().getparameters().get(FS_ContactUtility.IDTEXTFORACCOUNT);
           // varContactDetail.AccountiD=accId;
           
            }
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
        
        
       if(varContactDetail.phone.length()==11 || varContactDetail.phone.length()==0)
       {
       System.debug('varContactDetail.AccountiD'+varContactDetail.AccountiD);
        
        try
        {
             varAccountName=[select id,name from Account where id=:varContactDetail.AccountiD limit 1].name;
             cryptoKey = Crypto.generateAesKey(256);
            
            
            
            FS_SiteLead varSiteLead = new FS_SiteLead();
            List<FS_ExtraParameters> moreListItem = new List<FS_ExtraParameters>();
            FS_ExtraParameters varExtraParameters = new FS_ExtraParameters();
            
            
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
            
            
            
            /*if(!String.isBlank(varContactDetail.Email))
            {
                
                varSiteLead.Email=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varContactDetail.Email)));
                
            } 
            else
            {
                varSiteLead.Email=null;
            }
            if(!String.isBlank(varContactDetail.phone))
            {
                
                varSiteLead.Phone=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varContactDetail.phone)));
                
            } 
            else
            {
                varSiteLead.phone=null;
            }*/
            
            varSiteLead.Email=varContactDetail.Email;
            varSiteLead.Phone=varContactDetail.phone;
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
            if(!String.isBlank(varContactDetail.MailingPostalCode))
            {
                
                varSiteLead.BusinessPostalCode=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT,cryptoKey, Blob.valueOf(varContactDetail.MailingPostalCode)));
                
            }
            else
            {
               varSiteLead.BusinessPostalCode=null; 
            }
            
            if(!String.isBlank(varContactDetail.MailingCountry))
            {
                
                varSiteLead.Country=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varContactDetail.MailingCountry)));   
            }
            else
            {
                varSiteLead.Country=null;
            }
             varExtraParameters = new FS_ExtraParameters();
            
            varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(FS_ContactUtility.DECISIONMAKER)));
            varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(string.valueOf(varContactDetail.FS_Decision_Maker__c))));
            
            moreListItem.add(varExtraParameters);
            
            
             if( !String.isBlank(varContactDetail.FS_Position__c)){
                varExtraParameters = new FS_ExtraParameters();
                
                varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(FS_ContactUtility.POSITIONTEXT)));
                varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varContactDetail.FS_Position__c)));
                moreListItem.add(varExtraParameters);
            }
            else
            {
                varExtraParameters = new FS_ExtraParameters();
            }
            if(!String.isBlank(varContactDetail.MailingState)){
                varExtraParameters = new FS_ExtraParameters();
                
                varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(FS_ContactUtility.STATETEXT)));
                varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varContactDetail.MailingState)));
                moreListItem.add(varExtraParameters);
            }
            else
            {
                varExtraParameters = new FS_ExtraParameters(); 
            }
            
            varExtraParameters = new FS_ExtraParameters();
            varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(FS_ContactUtility.OWNERIDTEXT)));
            varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(UserInfo.getUserId())));
            moreListItem.add(varExtraParameters);
            
            if(!String.isBlank(UserInfo.getName())){
                varExtraParameters = new FS_ExtraParameters();
                
                varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(FS_ContactUtility.OWNERNAMETEXT)));
                varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(UserInfo.getName())));
                moreListItem.add(varExtraParameters);
            }
            else
            {
                varExtraParameters = new FS_ExtraParameters(); 
            } 
            
            if(!String.isBlank(varContactDetail.AccountId)){
                varExtraParameters = new FS_ExtraParameters();
                
                varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(FS_ContactUtility.ACCOUNTIDTEXT)));
                varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varContactDetail.AccountId)));
                moreListItem.add(varExtraParameters);
            }
            else
            {
                varExtraParameters = new FS_ExtraParameters(); 
            }
            if(!String.isBlank(varAccountName)){
                varExtraParameters = new FS_ExtraParameters();
                
                varExtraParameters.Name=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(FS_ContactUtility.ACCOUNTNAMETEXT)));
                varExtraParameters.Value=EncodingUtil.base64Encode(Crypto.encryptWithManagedIV(FS_ContactUtility.ENCRYPTTEXT, cryptoKey, Blob.valueOf(varAccountName)));
                 moreListItem.add(varExtraParameters);
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
                    res.setStatusCode(FS_ContactUtility.STATUSCODE);
                    res.setStatus(FS_ContactUtility.STATUSVALUEOK);
                    
                }
                else
                {
               
                    res = http.send(req);
                     
                }
            }catch(System.CalloutException e) {
               
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,FS_ContactUtility.ERRORMESSAGE));
                return null;
            }
            
            System.debug('res.getStatus()'+res.getStatus());
            System.debug('res.getStatusCode()'+res.getStatusCode());
             System.debug('-----Body--'+res.getBody());
            
            //if(res.getStatus()== FS_ContactUtility.STATUSVALUEOK && Integer.valueOf(res.getStatusCode())==FS_ContactUtility.STATUSCODE){
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
                 System.debug('-----errorCode--'+errorCode);
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
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter a valid 11 digit Telephone numebr'));
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