@isTest
                                
private class TestSchedulableClass {

  // CRON expression: midnight on March 15.
   // Because this is a test, job executes
   // immediately after Test.stopTest().
   public static String CRON_EXP = '0 0 0 15 3 ? 2022';

   static testmethod void test() {
      //Test.startTest();
      

     // api_setting__c settings = api_setting__c.getInstance('api_setting__c');
      //if (settings == null) settings = new api_setting__c();
      api_setting__c settings = new api_setting__c();
      
      settings.Endpoint_URL__c = 'https://beta.myshn.net/shnapi/rest/encryption/key_rotation_event';
      settings.Key__c = 'RnSQnkR73oIIZgsgwTjH/AXplOCU61jyXvrwhSkXT40=';
      settings.Password__c = 'dHFV5k8RlyBssZIBp2ud7EtVRXRrt5Zffu4Qn2o2Nhc=';
      settings.Purge_Time__c = 2;
      settings.Userids__c = '00590000002rKbWAAU';
      settings.Username__c = 'test1212@sf.com';
      settings.name = 'API_setting__c';
      insert settings ; 
      
      system.debug('settings--------->' + settings);
      
      APIPollerClass.Poll();
      
      KeyOrientation__c objKO = new KeyOrientation__c();
      objKO.Response_code__c = 'First Time Stamp';
      objKO.Timestamp__c = '2014-07-23T17:14:55.000-07:00';
      insert objKO;
      
      APIPollerClass.Poll();
      
      KeyOrientation__c objKO1 = new KeyOrientation__c();
      objKO1.Response_code__c = 'First Time Stamp';
      objKO1.Timestamp__c = '2014-07-24T17:14:55.000-07:00';
      insert objKO1;
      
      APIPollerClass.Poll();
      
      List<KeyOrientation__c> lstKO = [SELECT Id FROM KeyOrientation__c];
      delete lstKO;
      
       APIPollerClass.Poll();
       
      KeyOrientationController objKOC = new KeyOrientationController(); 
      List<KeyOrientation__c> lstKO1 = objKOC.getDetails(); 
      objKOC.getHistory(); 
      
      
      APISettingsController controller = new APISettingsController();
      PageReference pageRef = Page.APISettings; 
      Test.setCurrentPage(pageRef);
      controller.getList();
      controller.getChkUserList();
      controller.sUserName= 'dummy'; 
      controller.sPassword = '12345';
      pageRef = controller.Save();
      settings = null;
      APISettingsController controller1 = new APISettingsController();
      //System.assertEquals(settings.Username__c, controller.sUserName);
     
      
       
      // Schedule the test job
      /*String jobId = System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new APIPollerClass());
         
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(CRON_EXP, 
         ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run
      System.assertEquals('2022-03-15 00:00:00', 
         String.valueOf(ct.NextFireTime));
      // Verify the scheduled job hasn't run yet.
      //Merchandise__c[] ml = [SELECT Id FROM Merchandise__c 
                             //WHERE Name = 'Scheduled Job Item'];
      //System.assertEquals(ml.size(),0);
      */
      
    //  Test.stopTest();

      // Now that the scheduled job has executed after Test.stopTest(),
      //   fetch the new merchandise that got added.
      //ml = [SELECT Id FROM Merchandise__c 
                             //WHERE Name = 'Scheduled Job Item'];
      //System.assertEquals(ml.size(), 1);
    
   }
}