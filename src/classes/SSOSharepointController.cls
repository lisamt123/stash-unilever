public class SSOSharepointController {
  public static final String TEST_PK = '1234567890123456';  
  public static final String TEST_IV = '6543210987654321';
  public static final String TEST_STRING = 'hello';
  public static final String HELLO_IN_BASE64 = 'aGVsbG8=';
    
  public String errorstr {get;set;}
  
  // Settings
  private Blob privateKey {get; set;}
  private Blob initialVector {get; set;}
  private Boolean ssoEnabled {get; set;}
  private Decimal expiryInMinutes {get; set;}
  
  // Messages
  public static final String SSO_MSG_DISABLED = 'Single Sign is disabled. Please contact your system administrator.';
  public static final String SSO_MSG_INVALID_DATETIME = 'Invalid Date Format.';
  public static final String SSO_MSG_INVALID_LOGON = 'Invalid Logon Information.';
  
  public PageReference simplifiedsignin() {
      
    try {
        // by default - we always error until we are done
        errorstr = SSO_MSG_INVALID_LOGON;
        system.debug('simplifiedsignin: called');
        String opts = System.currentPageReference().getParameters().get('opts').replace(' ', '+');
        system.debug('simplifiedsignin: base64');
        system.debug('simplifiedsignin: opt: '+opts);
        final Blob optstoken = EncodingUtil.base64Decode(opts);
    
        getConfig();
        system.debug('simplifiedsignin: go');
        if (ssoEnabled == true) {
            system.debug('simplifiedsignin: sso enabled');
            String loginstr;
            if (Test.isRunningTest()) {
                loginstr = 'email=x@y.com&datetime=01/01/2013';
            } else {
                loginstr = Crypto.Decrypt ('AES128', privateKey, initialVector, optstoken).toString();              
            }
            system.debug('login: '+loginstr);
            
            pattern myPattern = pattern.compile('email=([^&]+)&datetime=(.*)');
            matcher myMatcher = myPattern.matcher(loginstr);
            
            system.debug('simplifiedsignin: sso token');
            System.assert (myMatcher.matches() && myMatcher.groupCount() == 2);
            
            // We need to do this
            String mixedCase = myMatcher.group(1);
            subject = mixedCase.tolowerCase();
            system.debug('Subject: '+subject);
            // we used to do this
            //subject =  myMatcher.group(1);
            tokendate =  myMatcher.group(2);
            
            system.debug('simplifiedsignin: sso token expiry');
            if (!hasTokenExpired(tokendate)) {
                system.debug('simplifiedsignin: sso response');
                relayState = ApexPages.currentPage().getParameters().get('RelayState');
                system.debug('relayState: 1: '+relayState);
                if (relayState == null) relayState = '/home/home.jsp';
                system.debug('relayState: 2: '+relayState);
                // clear the error as we are done
                errorstr = '';                          
            } else {
                errorstr = SSO_MSG_INVALID_DATETIME;
            }           
        } else {
            errorstr = SSO_MSG_DISABLED;
        }     
    } catch (Exception e) {
        errorstr = 'Error:  ' + SSO_MSG_INVALID_LOGON + ': ' + e.getMessage();
        system.debug(errorstr);
    }
      
    return null;
  }
            
    private Boolean isNotBlank(String s) {
        if (s!=null) {
            if (s.length() > 0) {
                return true;
            }           
        }
        return false;
    }        

    private Boolean validDDMM(Integer dd, Integer mm) {
        Boolean ok = true;
        system.debug('validDDMM: dd='+dd+' mm='+mm);
        if ( (mm == 1) || (mm == 3) || (mm == 5) || (mm == 7) || (mm == 8) || (mm == 10) || (mm == 12)) {
            if (dd > 31)
                ok = false;
        } else if (mm == 2) {
            if (dd > 29) {
                ok = false;
            }
        } else if (mm <= 12 ) {
            if (dd > 30) {
                ok = false;
            }
        } else ok = false;
        return ok;
        
    }
    
    private final String INPUT_DTM_FORMAT = 'dd/mm/yyyy hh:mm:ss';
    private DateTime fixDTMFormat(String dtm) {
        system.debug('fixDTMFormat: entry: '+dtm);
        DateTime fixedDTM = null;
        try {   
            if (dtm != null && dtm.length()>=INPUT_DTM_FORMAT.length()) {
                List<String> dateAndTime = dtm.split(' ', 2);
                system.debug('fixDTMFormat: dateAndTime: size: '+dateAndTime.size());
                system.debug('fixDTMFormat: dateAndTime: '+dateAndTime);
                List<String> ddmmyyyy = dateAndTime[0].split('/', 4);
                system.debug('fixDTMFormat: dateAndTime: ddmmyyyy size: '+ddmmyyyy.size());
                system.debug('fixDTMFormat: dateAndTime: '+ddmmyyyy);               
                List<String> hhmmss = dateAndTime[1].split(':', 4);
                system.debug('fixDTMFormat: dateAndTime: hhmmss size: '+hhmmss.size());
                system.debug('fixDTMFormat: hhmmss: '+hhmmss);

                Integer dd = Integer.valueOf(ddmmyyyy[0]);
                Integer mm = Integer.valueOf(ddmmyyyy[1]);
                if (validDDMM(dd, mm)) {
                    fixedDTM = DateTime.newInstance(Integer.valueOf(ddmmyyyy[2]),
                                                    mm,
                                                    dd,
                                                    Integer.valueOf(hhmmss[0]),
                                                    Integer.valueOf(hhmmss[1]),
                                                    Integer.valueOf(hhmmss[2]));                    
                }

                system.debug('fixedDTM: '+fixedDTM);        
            }           
        } catch (Exception ex) {
            system.debug('invalid input date time');
        }
        return fixedDTM;     
    }
    
    private Boolean hasTokenExpired(String suppliedTokenTime) {
        system.debug('hasTokenExpired: entry: '+expiryInMinutes+' mins');
        Boolean expired = false;
        
        // 0 or minus number means never expire
        if (expiryInMinutes > 0) {
            DateTime fixedDTM = fixDTMFormat(suppliedTokenTime);
            if (fixedDTM != null) {
                // turn string to date time
                system.debug('hasTokenExpired: suppliedTokenTime: '+suppliedTokenTime);
                system.debug('hasTokenExpired: fixedDTM: '+fixedDTM);
                
                //add expiry in minutes
                DateTime expiryDTM = fixedDTM.addMinutes((Integer)expiryInMinutes);
                system.debug('hasTokenExpired: expiryDTM: '+expiryDTM);
                
                DateTime nowDTM = DateTime.now();
                system.debug('hasTokenExpired: now: '+nowDTM);
                
                expired = (expiryDTM < nowDTM);         
                system.debug('hasTokenExpired: returns: '+expired);             
            } else expired = true;
        } 

        return expired;
    }
    
    // this only works if you are running a test
    private Boolean overrideConfig = false;
    public void setConfig(Boolean enable, Decimal expiry) {
        if (Test.isRunningTest()) {
            system.debug('setConfig: enable='+enable+' expiry: '+expiry);
            ssoEnabled = enable;
            expiryInMinutes = expiry;
            overrideConfig = true;
        }
    }

    private void getConfig() {
        if (Test.isRunningTest()) {
            system.debug('getConfig: dummy 1');
            //EncodingUtil.base64Decode(HELLO_IN_BASE64);
            privateKey = Blob.valueOf(TEST_PK);
            system.debug('getConfig: dummy 2');
            initialVector = Blob.valueOf(TEST_IV);
            encodedKey = HELLO_IN_BASE64;
            if (!overrideConfig) {
                system.debug('getConfig: dummy 3');
                ssoEnabled = true;
                system.debug('getConfig: dummy 4');
                expiryInMinutes = 5;
            }
        } else {
            try {
                uw_SSO_Settings__c ssoSettings = [SELECT Private_Key__c, Initial_Vector__c, Org_URL__c, Token_Expiry_in_Minutes__c, enabled__c,Salesforce_certificate_Key__c FROM uw_SSO_Settings__c WHERE Active_Config__c = true LIMIT 1];
                //uw_SSO__c ssoSettings = uw_SSO__c.getInstance('Default');  
                system.debug('getConfig: ssoSettings: '+ssoSettings);       
                ssoEnabled = ssoSettings.enabled__c;
                if (ssoEnabled) {
                    String b64_privateKey = ssoSettings.Private_Key__c;
                    String b64_initialVector = ssoSettings.Initial_Vector__c;
                    String actionFromCS = ssoSettings.Org_URL__c;
                    String keyFromCS = ssoSettings.Salesforce_certificate_Key__c;
                    system.debug('action: ['+actionFromCS+']');
                    //system.debug('cert: ['+keyFromCS+']');
                    
                    if (isNotBlank(b64_privateKey) && isNotBlank(b64_initialVector)) {
                        privateKey = EncodingUtil.base64Decode(b64_privateKey);
                        initialVector = EncodingUtil.base64Decode(b64_initialVector);
                        expiryInMinutes = ssoSettings.Token_Expiry_in_Minutes__c;
                        action = ssoSettings.Org_URL__c;
                        encodedKey = ssoSettings.Salesforce_certificate_Key__c;               
                    } else ssoEnabled = false;              
                }               
            } catch (Exception ex) {
                system.debug('GetConfig: '+ex);
                ssoEnabled = false;
                // rethrow the exception
                throw(ex);
            }

        }
    }        

    
    private String subject;
    private String tokendate;
   
    /* 
    public String getSubject(){
        return subject;   
    }
    
    public String getTokendate(){
        return tokendate;
    }
    */
    
    private String relayState;
    private String issuer = 'urn:unilever:simplifiedsso:samlbridge';
    private String audience = 'https://saml.salesforce.com';
    //fullcopy private String action = 'https://test.salesforce.com/?saml=MgoTx78aEPb899yTO_6p0bXBiHGvUn7.QqWby0rwsre3UkQbJu2M8YwgCr';
    private String action; //= 'https://test.salesforce.com/?saml=MgoTx78aEPb899yTO_6p0bXBiHGvUn7.QqWby0rwsre3UkQbJu2M8YwgCr';
    //private String action = 'https://login.salesforce.com/?saml=EK03Almz90lB2qyIKrLgVTOAA_KTu0uUAzQkATNFbLVQ4CUMWKNdNI0FEi';
    //private String action = 'https://login.salesforce.com/?saml=EK03Almz90lB2qyIKrLgVTOAA_KTu0uUAzQkATNFbLVQ4CUMWKNdNI0FEi';
    private String preCannonicalizedResponse = '<samlp:Response xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" Destination="RECIPIENT" ID="RESPONSE_ID" IssueInstant="NOT_BEFORE" Version="2.0"><saml:Issuer xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" Format="urn:oasis:names:tc:SAML:2.0:nameid-format:entity">ISSUER</saml:Issuer><samlp:Status><samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"></samlp:StatusCode></samlp:Status><saml:Assertion xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="ASSERTION_ID" IssueInstant="NOT_BEFORE" Version="2.0"><saml:Issuer Format="urn:oasis:names:tc:SAML:2.0:nameid-format:entity">ISSUER</saml:Issuer><saml:Subject><saml:NameID Format="urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified">SUBJECT</saml:NameID><saml:SubjectConfirmation Method="urn:oasis:names:tc:SAML:2.0:cm:bearer"><saml:SubjectConfirmationData NotOnOrAfter="NOT_ON_OR_AFTER" Recipient="RECIPIENT"></saml:SubjectConfirmationData></saml:SubjectConfirmation></saml:Subject><saml:Conditions NotBefore="NOT_BEFORE" NotOnOrAfter="NOT_ON_OR_AFTER"><saml:AudienceRestriction><saml:Audience>AUDIENCE</saml:Audience></saml:AudienceRestriction></saml:Conditions><saml:AuthnStatement AuthnInstant="NOT_BEFORE"><saml:AuthnContext><saml:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:unspecified</saml:AuthnContextClassRef></saml:AuthnContext></saml:AuthnStatement></saml:Assertion></samlp:Response>';
    private String preCannonicalizedSignedInfo = '<ds:SignedInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#"><ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"></ds:CanonicalizationMethod><ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"></ds:SignatureMethod><ds:Reference URI="#RESPONSE_ID"><ds:Transforms><ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"></ds:Transform><ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"></ds:Transform></ds:Transforms><ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"></ds:DigestMethod><ds:DigestValue>DIGEST</ds:DigestValue></ds:Reference></ds:SignedInfo>';
    private String signatureBlock = '<ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">SIGNED_INFO<ds:SignatureValue>SIGNATURE_VALUE</ds:SignatureValue></ds:Signature><samlp:Status>';
    // original production, expires 08-Dec-2012 
    // private String encodedKey = 'MIIEowIBAAKCAQEAlwfPUiymmjFuvViSJj6vlFqGA+OzSKXFLaCAIts9nH0fZZv4w5ev7rgNR0MaoEDcnPQfVKDiLxnCfw4itDSRWk8si5Hbi7zjwCy7mubZiETGKuPvBUTDGDsC+1Bd03HlRLCeCYaSVFv7zDQr4Srtqzq9/q6gbFF5NqfxnEX6vHQNZwbz56qPzvqNyqlfCmgHyxb15nsloh/5FyjGurlca/1PM5c9jU4roUGCgDSiOgUobEOKAoDxO1nc1TKzrBww8OXHNrr2/zwvI/BxV24gVHfBltVdD4oRqRfRHtirt4syzyadSEN2FvTd3j8toTgouhWxtjV+TRSgc1toJ1Q8nQIDAQABAoIBAHa1tMcqQWlBIYHCdF2LOAargFreRrT7Vxid5xl+qdauolcDWWyjda11DTrOC8eaM81KNLYYHrBW1wF24uAx0W3ifWjWpHIZbgpHHs6KVME/DWP49I53lcEd4SIX8SeZhlOPXyitlaapBiljeHnrfBPygBQGviFliJjlOItUldg5RS93Gw4c75XP6DslvL0YUW67b+GbR6BXTs0qbsi+aWqn/Y+yXoO8wjO2LDA8vEX/ewC7kALMGnGPHW7jlayLFxERiedhIFlh1+BHOjh+kQV09krxa3il77hok8JVn1Nt/iMmizISDjpkmYk34QXO8WYi1WkpyheFr6tv/JShGAECgYEA7PKnbtNk7CgaYM1CEmvHXOnLjhvGRMhW7a8w5k5FzMNiPO99fvWUERV0dK4hHOmVfBCqRhmOBxGegsZhpSLWnPZ/cIiszQ7tJLHVr46E3u17JyegPHw8YnWH6QfRCVDRWIoibbsDTxILQQ/3CEV4aR/eoFFEIsU/PAUxlz0gjt0CgYEAoyyg/QCXjTb//dydDWQKEpKrWQRCkZh3+5memdZ/y7or8op42pdusYsputB7OeuDMHi/jFtPuRLnNaZUCSsU+eVxxifv/TLkXVR9TdAad8+FEqmIlishl1rhjFq6+SW8RSH3boZi3AOWJDtALuln7XUjzr2RFoEx88qFsjLuKMECgYEAy8EOQbr+uiTyKfPXsUeFNFzHcfhoUpWESvevsRv14dLSE1xOKnK7VMWCUyO5zcb/iKQ8B/PJskJwcDxvkzWWH3vIstiU3/DJ9BgIjOKdV6YXlN/6Zoje1DwFF1plYwFgRCbk3D9I5SG7E8PKxg4XMS76nhnD4bKEYfSFZGxoJvECgYBYNC2p1YIWoZ5rOa/jpyoStBnPepAJZ+Ojq3yiJ+LY24AaEWQWtTju3AzooP2bZ4V41Cym0E0d++vjgk92zUT/eFmyBbCiq7nqAVvijhVgolqKpf3hPttfl47IcdsUBqPost2vbxFNYNruJuEg+qZlI6cBgFNHWPsJj3YJx6IZgQKBgBD92qjsvtK4hP7PwThkViycANAvK15FQjYy3ikBlJ4tvnlibxhqS0EiH3Ard3YKNiImHQRkp439Gj2suh5jW75s/G1iXZU4fEVw/sCpdI8+UZmR6wu7g7KLwhXLbtw/bfW6LCeClfzkOvT6lxtwqy6DqPCstsD4ruxAGmasKc3o';
    // new key -expires Nov 2013
    private String encodedKey; // = 'MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDuO5FvIJUKlerBv9ejMCTEYWeOvRlFLtHI3sD1raEndj5nnzTILhX+yp0mPaFHjTsGF1NUWse5h2TPaHKqZJCPHipHVuWXuP6ms1/AZUL2owea3Wba2L2SQMkAeK3aTlI2Pb7nodqU4T1sMiGQS78Kq8T2DOI11oKQCiF2vYwIWXvBvNBW8ce6i2gvW7QyQ9vIqj3L4iaAam0Jg+76QEWA3Lmz+LlK0iGzBRcNxy4ruUWGxlvx/HfsJ3RdMv20HQcQwh4BkzJvO1B6nRVFTP7r0ZCKgVtP8FYcJIqFW60TfVfbrlnCnx2pWdDCMLn30sziVCS7k3wR97F1QBnJUmq5AgMBAAECggEBAI62qJ0Fy8MXpBaFMkzUHnJ2V28u4OCM96d5qeaDKTNWpnO08A2rbgnAnvu1l9QhSuaPOqAh8du2vDFzxJ1GuULDM1ihOdD2RbbfZdD/2GmfqIKhd2hKxuXCYacipCNPH/jWbHKehy8A76bNMUYb2kouNEOh3DGcW4KmTv2u9yBYMuIB92nGcm03mtoXp1G9DpPvbyrT+4QPvXVRG00MV+qHFzmTTbkuWZrANRUmSFEMzbZYPTRWt0awdjKI+lWjLpZj6LBzv1NoRI6bguO+2NOEWOVT69qvcaclfObjrNIElMXFlCWftw5s8kM2KyAPIv5Oe3UK4Qw6E5pAb/oh5MECgYEA+RohtFxGG3hO1y4H5Qz2+HG3aoPmlKnNP0uEYb6HvGtmK7Jkv8Echtk80TPGrxc+ZNaRsTkCy1K4tICGv97WyrTMGtK9/J0E3x/Iq3JmSR2QUCYuQaoiGpe3ywDl7IlNqw/yRLvynWnBxJUr82D2RYPIrsn1l16B06G1sCzOwK0CgYEA9NRiUYCQ793o8gVn74f31LNsju4iSXWDejw/Pb7rE770Lszz/TZgD+bj19pLAS8aWrU6GFFMOllFdH1zbZlnsrzQscA9dqr2C5aO63V2V8nxkRSPFRD1CoR03AXuC+7vE5JdJ8IumJ8iW9SzTgV2cq0siO9bwrH6u2UvbBKNN70CgYAhnoo/+lgn6vPRDNBZ9Ib8fvR/NrAPDl+6FCoYuws8vc37RcddLeX4uScBIRjGlr+AAomFPqmG4XI2QkZtbNjWYNJPKHQlvNdkebiukvEFGy1X8984U4roxeMzTbq6Usmdtbg/2JHk9toE+xEEduil9yRFmtI/jKy+8EtCLLn2vQKBgQDqbtveMv+Vz6WY6bhGUqnq0AvpKPlH4fCNgVcFJuUuOTDUB4iyM/j0ASC2td4QOixAIzyHwID/di/dhaqbjcMQEWC8c9nm4XlMS1R6/jTdhw963nbLszsQYRkM/didMKNY2FO/GF9J4UcjK56t3Ok4kb4NOTViTs5J1m/8Sh9S+QKBgQC0JTT+2XkCTMe2Ma5TuoHM3uRe7qTZWB/bCbGfUm+UFQhDGQZGkB9v8U78XEo15yShMtL4kMsDJRmSEoZJ2+LwxJfEUZcDJu3VPkos0L1WnaNLSfHHevZ67oLOSkQMeYPNspBWvINtEatkA8qggwL5tJeh/1CVB3xsFrUmyZM8fA==';    

    
    public String getAction(){
        return action;   
    }
    
    public String getRelayState(){
        return relayState;
    }
    
    
    public String getResult(){
        
        system.debug('getResult: called');

        datetime nowDt = datetime.now();
        Long nowLong = nowDt.getTime();
        datetime notBeforeDt = datetime.newInstance(nowLong - 120000);
        String notBefore = notBeforeDt.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss') + 'Z';
        datetime notOnOrAfterDt = nowDt.addMinutes(5);
        String notOnOrAfter = notOnOrAfterDt.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss') + 'Z';

        //prepare the response  
        
        system.debug('getResult: 1');
        Double random = Math.random();
        system.debug('getResult: 1a:');
        
        String assertionId;
        String responseId;
        if (!Test.isRunningTest()) {
            assertionId = EncodingUtil.convertToHex(Crypto.generateDigest('SHA256',  Blob.valueOf('assertion' + random)));
            system.debug('getResult: 1b');
            responseId = EncodingUtil.convertToHex(Crypto.generateDigest('SHA256',  Blob.valueOf('response' + random)));
            system.debug('getResult: 1c');          
        } else {
            assertionId = 'test';
            responseId = 'test';
        }
        preCannonicalizedResponse = preCannonicalizedResponse.replaceAll('RESPONSE_ID',responseId);        
        system.debug('getResult: 1d');
        preCannonicalizedResponse = preCannonicalizedResponse.replaceAll('ASSERTION_ID',assertionId);
        system.debug('getResult: 1e');
        preCannonicalizedResponse = preCannonicalizedResponse.replaceAll('ISSUER',issuer);
        system.debug('getResult: 1f');
        preCannonicalizedResponse = preCannonicalizedResponse.replaceAll('AUDIENCE',audience);
        system.debug('getResult: 1g: action: ['+action+']');
        preCannonicalizedResponse = preCannonicalizedResponse.replaceAll('RECIPIENT',action);
        system.debug('getResult: 1h');
        preCannonicalizedResponse = preCannonicalizedResponse.replaceAll('SUBJECT',subject);
        system.debug('getResult: 1i');
        preCannonicalizedResponse = preCannonicalizedResponse.replaceAll('NOT_BEFORE',notBefore);
        system.debug('getResult: 1j');
        preCannonicalizedResponse = preCannonicalizedResponse.replaceAll('NOT_ON_OR_AFTER',notOnOrAfter);
        system.debug('getResult: 1k');
        
        system.debug('getResult: 2');
        //Prepare the Digest
        Blob digest = Crypto.generateDigest('SHA1',  Blob.valueOf(preCannonicalizedResponse));
        String digestString = EncodingUtil.base64Encode(digest);

        system.debug('getResult: 3');
        //Prepare the SignedInfo
        preCannonicalizedSignedInfo = preCannonicalizedSignedInfo.replaceAll('RESPONSE_ID',responseId);
        preCannonicalizedSignedInfo = preCannonicalizedSignedInfo.replaceAll('DIGEST',digestString);
        
        system.debug('getResult: 4'); 
        system.debug('getResult: sf key length: '+encodedKey.length());               
        //Sign the SignedInfo
        Blob privateKey = EncodingUtil.base64Decode(encodedKey);
        Blob input = Blob.valueOf(preCannonicalizedSignedInfo);
        
         Blob signature;
        if (!Test.isRunningTest()) {
            signature = Crypto.sign('RSA', input, privateKey);
        } else {
            signature = Blob.valueOf('test');
        }
        
        String signatureString = EncodingUtil.base64Encode(signature);
        
        system.debug('getResult: 5');
        //Prepare the signature block
        signatureBlock = signatureBlock.replaceAll('SIGNED_INFO',preCannonicalizedSignedInfo);
        signatureBlock = signatureBlock.replaceAll('SIGNATURE_VALUE',signatureString);
        
        //cheap trick for enveloping the signature by swapping out last element with sig + last elements of whole message
        preCannonicalizedResponse = preCannonicalizedResponse.replaceAll('<samlp:Status>', signatureBlock );
        
        system.debug('getResult: 6');
        //return the prefix + our prepped message
        return EncodingUtil.base64encode(Blob.valueOf(preCannonicalizedResponse));

    }
    private static testMethod void testIsNotBlank() {
        SSOSharepointController con = new SSOSharepointController();
        system.assertEquals(false, con.isNotBlank(null));
        system.assertEquals(false, con.isNotBlank(''));
        system.assertEquals(true, con.isNotBlank('fred'));
    }    

    private static testMethod void testFixDTMFormat() {
        SSOSharepointController con = new SSOSharepointController();
        DateTime dt = con.fixDTMFormat('27/03/2012 11:58:09');
        system.assert(dt != null);
        system.assertEquals(27, dt.day()); 
        system.assertEquals(3, dt.month()); 
        system.assertEquals(2012, dt.year()); 
        system.assertEquals(11, dt.hour()); 
        system.assertEquals(58, dt.minute()); 
        system.assertEquals(9, dt.second()); 
        DateTime dt2 = con.fixDTMFormat('03/27/2012 11:58:09');             
        system.assertEquals(null, dt2);     
    }
    
    private static testMethod void testHasTokenExpired() {
        String wayInFuture = '31/12/2020 13:00:00';
        String wayInPast = '01/01/2012 01:00:00';
        
        SSOSharepointController con = new SSOSharepointController();
        con.expiryInMinutes = 5.0;
        system.assertEquals(false, con.hasTokenExpired(wayInFuture));
        system.assertEquals(true, con.hasTokenExpired(wayInPast));
    }
    
    private static testMethod void testProperties() {
        SSOSharepointController con = new SSOSharepointController();
        con.errorstr = TEST_STRING;
        system.assertEquals(TEST_STRING, con.errorstr);
    
        Blob b = Blob.valueOf(TEST_STRING);
        con.privateKey = b;
        system.assertEquals(b, con.privateKey);
        con.initialVector = b;
        system.assertEquals(b, con.initialVector);
        con.ssoEnabled = true;
        system.assertEquals(true, con.ssoEnabled);
        con.expiryInMinutes = 1000;
        system.assertEquals(1000, con.expiryInMinutes);
        
        con.action = 'action';
        system.assertEquals('action', con.getAction());
        con.relayState = 'relay';
        system.assertEquals('relay', con.getRelayState());
        
        
        Test.setCurrentPage(Page.SSOSharepoint);
        ApexPages.currentPage().getParameters().put('opts',HELLO_IN_BASE64);
        con.simplifiedsignin();
        con.getResult();
        con.setConfig(false, 5.0);
    }   
}