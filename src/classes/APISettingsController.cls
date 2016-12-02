public class APISettingsController
{
    public decimal sPurgetime { get; set; }
    public string sUsername{get;set;}
    public string sPassword{get;set;}
    public string sEndPointUrl{get;set;}
   
    
    public String[] chkUserList = new String[]{};
  
    public APISettingsController()
    {
      api_setting__c settings;
      try
        {
         
          List<api_setting__c> lstSettings = api_setting__c.getall().values();
          
          if(lstSettings.size()>0) 
              settings=lstSettings[0];
          
          if (settings == null) settings = new api_setting__c();
          
          sEndPointUrl = settings.Endpoint_URL__c;
          sUsername = settings.Username__c;
          sPurgetime = Integer.valueOf(settings.Purge_time__c);
          sPassword = '';
          string sUserIds = settings.userids__c ;
          if (sUserIds != null)
              chkUserList  = sUserIds.split(',');
        }
        catch (Exception e)
        {
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
          ApexPages.addMessage(myMsg);
          System.debug('Error >>' + e.getMessage());
        }
   }
   
   //List of select options to populate select boxes  
    public List<SelectOption> getList() {  
    List<SelectOption> options = new List<SelectOption>();  
       for (User u : [  
          SELECT Id, Name, Profile.Name From User
          WHERE Profile.Name = 'System Administrator'
          AND IsActive=true
          ]) {   
         options.add(new SelectOption(u.id, u.Name));   
       }    
     return options;
    }
       
    public String[] getChkUserList() {
        return chkUserList ;
    }

    public void setChkUserList(String[] chkUserList) {
        this.chkUserList = chkUserList ;
    }
   
    public PageReference Save()
    {
       api_setting__c settings;
       try
       {
           List<api_setting__c> lstSettings = api_setting__c.getall().values();
           
           if(lstSettings.size()>0) 
              settings=lstSettings[0];
         
           if (settings == null) settings = new api_setting__c();
           
           
           settings.Name = 'api_setting__c';
           settings.Endpoint_URL__c = sEndPointUrl;
           settings.Username__c = sUsername;
           settings.Purge_time__c = sPurgetime;
           Blob cryptoKey = Crypto.generateAesKey(256);
          
           if (sPassword.length() != 0)
           {
              // Generate the data to be encrypted. 
              Blob data = Blob.valueOf(sPassword);
              Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey, data);
              settings.Password__c = EncodingUtil.base64Encode(encryptedData); 
              settings.key__c = EncodingUtil.base64Encode(cryptoKey);  
           }
        
           String coalesceString = '';
           for(string s:chkUserList) {
             coalesceString += (coalesceString==''?'':',')+ String.valueOf(s);
           }
           settings.userids__c = String.valueOf(coalesceString); 
           
           upsert settings ;
           
           sPassword = '';
           
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Data saved successfully.');
           ApexPages.addMessage(myMsg);
           
           if (sEndPointUrl.length() > 0)
               ScheduleJob();
           
       }
       catch (Exception e)
       {
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
         ApexPages.addMessage(myMsg);
         System.debug('Error >>' + e.getMessage());
       }
    
       return null;
    }
    
    Public void scheduleJob()
    {
         try
         {
         Integer count = [SELECT count() FROM CronTrigger where CronJobDetail.Name = 'Simp Hourly'];
         if (count == 0){
           System.schedule('Simp Hourly', '0 0 * * * ?', new APIPollerClass());  
         }
         }catch(Exception e){
          System.debug('Error in Scheduling Job' + e.getMessage());
         }
    }

}