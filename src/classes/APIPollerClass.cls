global class APIPollerClass implements Schedulable { 
    
       global APIPollerClass(){
       }
       
       global void execute(SchedulableContext ctx) {
           
          System.debug('Job Starting.....');
          //System.schedule('Simp Hourly', '0 0 * * * ?', new APIPollerClass());  
          APIPollerClass.Poll();
          System.debug('Job Completed');
       }
      @future(callout=true)
      public static void Poll()
      {    
         
         string sUsername;
         string sPassword;
         string sPasswordDecrypted;
         string sEndPointUrl;
         integer iPurgeTime;
         
         api_setting__c settings;
         try
          {
              List<api_setting__c> lstSettings = api_setting__c.getall().values();
              
              if(lstSettings.size()>0) 
                  settings=lstSettings[0];
              system.debug('settings1111--------->' + settings);
              
              sUsername = settings.Username__c;
              sPassword = settings.Password__c;
              sEndPointUrl = settings.Endpoint_URL__c;
              iPurgeTime = Integer.ValueOf(settings.Purge_Time__c);
             
             
               system.debug('sPassword--------->' + sPassword);
              //String sUserIds = settings.UserIds__c;
              //if(sUserIds != null)
                  //listUsersIds = sUserIds.split(','); 
             
             system.debug('settings.Password__c--------->' + settings.Password__c);
             
              
              if (settings.Password__c != null)
              {
                  Blob encryptedData = EncodingUtil.base64Decode(settings.Password__c);
                  Blob cryptoKey = EncodingUtil.base64Decode(settings.Key__c);
                  Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, encryptedData);
                  sPasswordDecrypted  = decryptedData.toString();
              } 
             
             if (sEndPointUrl != null && sEndPointUrl.length()>0)
             {
              List<KeyOrientation__c> listObjKeyOrntn = [  
                                                 SELECT timestamp__c 
                                                 FROM KeyOrientation__c 
                                                 WHERE Response_code__c = 'Changed' or Response_code__c = 'First Time Stamp'
                                                 ORDER BY Name DESC // name is autonumber
                                                 LIMIT 1 
                                              ];
              KeyOrientation__c objKeyOrntn = (listObjKeyOrntn != null && listObjKeyOrntn.size()>0) ? (listObjKeyOrntn[0]) : null;
                       
              //String sUrl = sEndPointUrl;
              String sLastTimeStamp = '';
              if (objKeyOrntn == null)
              {
                 sLastTimeStamp = '?timestamp=1970-01-01T01:01:01.389-07:00';
              }
              else
              {
                 sLastTimeStamp = '?timestamp=' + String.ValueOf(objKeyOrntn.timestamp__c);
              }
              String sUrl = sEndPointUrl + sLastTimeStamp;
              
              System.debug('sUrl >>' + sUrl);
               
                  
              HTTP h = new HTTP();
              HTTPRequest r = new HTTPRequest();
              r.setEndpoint(sUrl);
              Blob headerValue = Blob.valueOf(sUsername  + ':' + sPasswordDecrypted);
              String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
              r.setHeader('Authorization', authorizationHeader);
              r.setHeader('Accept', 'application/json');
              r.setHeader('Content-Type', 'application/json');
              r.setMethod('GET');
              r.setTimeout(60000);
              String strResp ;
             
             HTTPResponse resp;
              if(Test.isRunningTest()==false){
                  resp = h.send(r);
                  strResp = resp.toString();
              }else{
                strResp='200';
              }
              if (strResp.contains('200'))
              {
                  if(Test.isRunningTest()==false){
                      strResp = resp.getBody();
                  }else{
                    strResp='{"version": 3,"timestamp": "2014-07-23T17:14:55.000-07:00"}';
                  }
                  
                  String sNewTimeStamp = ParseData(strResp);
                  
                  If(sNewTimeStamp != null)
                  {
                      KeyOrientation__c objKeyOrntnToInsert;
                      if (objKeyOrntn == null)
                       {
                         objKeyOrntnToInsert = new KeyOrientation__c();
                         objKeyOrntnToInsert.timestamp__c = sNewTimeStamp;
                         objKeyOrntnToInsert.Response_code__c = 'First Time Stamp';
                         insert objKeyOrntnToInsert ;
                         
                         System.debug('INFO: ' + 'First Time Stamp');
                         
                         SendEmailToAdmin(sNewTimeStamp);
                      }
                      else 
                      {
                         if (String.valueOf(objKeyOrntn.timestamp__c) != sNewTimeStamp) 
                         {
                               objKeyOrntnToInsert = new KeyOrientation__c();
                               objKeyOrntnToInsert.timestamp__c = sNewTimeStamp;
                               objKeyOrntnToInsert.Response_code__c = 'Changed';
                               insert objKeyOrntnToInsert;
                               
                               System.debug('INFO: ' + 'Changed');
                               
                               SendEmailToAdmin(sNewTimeStamp);
                           
                          }
                             else
                             {
                               objKeyOrntnToInsert = new KeyOrientation__c();
                               objKeyOrntnToInsert.timestamp__c = sNewTimeStamp;
                               objKeyOrntnToInsert.Response_code__c = 'No Change';
                               insert objKeyOrntnToInsert;
                               
                               System.debug('INFO: ' + 'No Change');
                               
                               // To be removed
                               //SendEmailToAdmin(sNewTimeStamp);
                             
                             }
                             
                          }
                     }
                     else
                     {
                       System.debug('Error in Polling: ' + 'No Timestamp returned');
                     }
                 }
                 else
                 {
                     System.debug('Error in Polling: ' + strResp);
                 }
            }
            else
            {
              System.debug('Error in Polling: ' + 'No Endpoint URL defined in API Settings.');
            }
            
            // Purge logic goes here
            if (iPurgeTime != null && iPurgeTime > 0)
            {
                Datetime dtPurgeTime = datetime.now().AddHours(-iPurgeTime );
                System.debug('Purge Time >>' + dtPurgeTime);
                List<KeyOrientation__c> listObjKO = [select id from KeyOrientation__c where LastModifiedDate < :dtPurgeTime and response_code__c = 'No Change'];
                System.debug('Data to be deleted >>' + listObjKO);
                Delete listObjKO; 
            } 
              
          }
          catch(Exception e)
          {
            System.debug('Error in Polling: ' + e.getMessage());
          }
          
        }
        
    Public static string ParseData(string str)
    {
       JSONParser parser = JSON.createParser(str);
        string sTimestamp;
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                (parser.getText() == 'timestamp')) {
                // Get the value.
                    parser.nextToken();
                    sTimestamp = parser.getText();
                    break;
            }
        }
        return sTimestamp ;
    }

    
    Public static void SendEmailToAdmin(String sTimeStamp)
    {
        api_setting__c settings;
        List<api_setting__c> lstSettings = api_setting__c.getall().values();
        
        if(lstSettings.size()>0) 
              settings=lstSettings[0];
        
        if (settings == null) settings = new api_setting__c();
      
        List<Id> listUsersIds = new List<Id>();
        String sUserIds = settings.UserIds__c;
        if(sUserIds != null)
           listUsersIds = sUserIds.split(','); 
      
        String[] sToAddress = new String[]{};
                
        List<User> listUser = [select email from User where id in :listUsersIds];
       
        for(user objUser:listUser) {
         sToAddress.add(String.valueOf(objUser.Email));
        }
        
        System.debug('sToAddress-->' + sToAddress);
        if (sToAddress.size() > 0)
        {
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //Send Email
            string subject='Key Rotation event captured';
            string htmBody =  'Dear Administrator ' + ',<br/><br/>';
            htmBody=htmBody+'A Key Rotation event has been captured. Please find details below.<br/><br/>';
            htmBody=htmBody+'<table border="1" cellspacing="0" cellpadding="2">';
            htmBody=htmBody+'<tr><th align="left">Timestamp</th><td>' + sTimeStamp + '</td></tr>';
            htmBody=htmBody+'</table>';
            htmBody=htmBody+'<br/><br/>Best Regards,<br/>Skyhigh Networks</p>';
            //mail.setTargetObjectId(objKO.ownerid);    
            mail.setSubject(subject);
            mail.setSaveAsActivity(false);
            mail.setHtmlBody(htmbody);
            mail.setToAddresses(sToAddress);
            OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address LIKE 'donotreply%'];
           
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            
             
            mailList.add(mail);
            system.debug('My Email Adresses User:>>> '+mailList);
            // Send Email
            sendEmail(mailList);

        }
    }
    
    public static void sendEmail(List<Messaging.SingleEmailMessage> singleEmailList)
    {
       List<Messaging.SingleEmailMessage> mailList=singleEmailList;
       if(mailList!=null && mailList.size()>0){ 
            try{
                Messaging.sendEmail(mailList);
            }
            catch(Exception ex){
                system.debug('Email does not Exist'+ex.getMessage());
            }
        }
    }
    
    
    
  
}