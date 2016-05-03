/**********************************************************************
Name: BET_ReleaseDateEmails_Test 
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: test for BET_ReleaseDateEmails
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             22/12/2014      INITIAL DEVELOPMENT
**********************************************************************/

@isTest
private class BET_ReleaseDateEmails_Test {
  
    static testMethod void testTwo(){
      BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET1' + system.now(), true);

      Date myDate = date.today();
      Date launchDate = Date.newInstance(myDate.year()+1, 1, 15);

      wrap.BET.Launch_Date__c = launchDate;
      update wrap.BET;

      BET_Request_Access__c setting = new BET_Request_Access__c(Name = 'Test', Send_Mail_To_Owner__c = true, Email_Address__c='test@test.com', Logo_Url__c='http://test.com/img.jpg');
      insert setting;

      Test.startTest();
      Integer currentMonth = 3;
      BET_ReleaseDateEmails batchFinal = new BET_ReleaseDateEmails('SELECT Id, Name, Status__c, Launch_Date__c, First_Release_Due_Date__c, Owner.Name, Owner.Id, Owner.Email FROM uw_BET__c', false);
      database.executebatch(batchFinal, 5); 

      wrap.BET.Status__c = 'Final Release';
      update wrap.BET;

      BET_ReleaseDateEmails batchFinal2 = new BET_ReleaseDateEmails('SELECT Id, Name, Status__c, Launch_Date__c, First_Release_Due_Date__c, Owner.Name, Owner.Id, Owner.Email FROM uw_BET__c', false);
      database.executebatch(batchFinal2, 5); 

      Test.stopTest();
    }

    static testMethod void testThree(){
      BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET1' + system.now(), true);

      Date myDate = date.today();
      Date launchDate = Date.newInstance(myDate.year()+1, 1, 15);

      wrap.BET.Launch_Date__c = launchDate;
      update wrap.BET;

      BET_Request_Access__c setting = new BET_Request_Access__c(Name = 'Test', Send_Mail_To_Owner__c = true, Email_Address__c='test@test.com', Logo_Url__c='http://test.com/img.jpg');
      insert setting;

      Test.startTest();
      wrap.BET.Status__c = 'First Release';
      update wrap.BET;

      Integer currentMonth = 3;
      BET_ReleaseDateEmails batchFinal = new BET_ReleaseDateEmails('SELECT Id, Name, Status__c, Launch_Date__c, Final_Release_Due_Date__c, Owner.Name, Owner.Id, Owner.Email FROM uw_BET__c', true);
      database.executebatch(batchFinal, 5);

      Test.stopTest();
    }

    static testMethod void testFourGenerateTemplateFirstRelease(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET1' + system.now(), true);

        Date myDate = date.today();
        Date launchDate = Date.newInstance(myDate.year()+1, 1, 15);

        wrap.BET.Launch_Date__c = launchDate;
        update wrap.BET;

        BET_Request_Access__c setting = new BET_Request_Access__c(Name = 'Test', Send_Mail_To_Owner__c = true, Email_Address__c='test@test.com', Logo_Url__c='http://test.com/img.jpg');
        insert setting;

        Test.startTest();

        Integer currentMonth = 4;
        uw_BET__c BET = [SELECT Id, Name, Status__c, Launch_Date__c, First_Release_Due_Date__c, Owner.Name, Owner.Id, Owner.Email FROM uw_BET__c WHERE Id =: wrap.BET.ID];
        String template = BET_ReleaseDateEmails.generateTemplate(BET, setting, true);
        Test.stopTest();

        System.assert(template.containsIgnoreCase('First Release'));
        System.assert(!template.containsIgnoreCase('Final Release'));
    }

    static testMethod void testFiveGenerateTemplateFinalRelease(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET1' + system.now(), true);

        Date myDate = date.today();
        Date launchDate = Date.newInstance(myDate.year()+1, 1, 15);

        wrap.BET.Launch_Date__c = launchDate;
        update wrap.BET;

        BET_Request_Access__c setting = new BET_Request_Access__c(Name = 'Test', Send_Mail_To_Owner__c = true, Email_Address__c='test@test.com', Logo_Url__c='http://test.com/img.jpg');
        insert setting;

        Test.startTest();

        uw_BET__c BET = [SELECT Id, Name, Status__c, Launch_Date__c, Final_Release_Due_Date__c, Owner.Name, Owner.Id, Owner.Email FROM uw_BET__c WHERE Id =: wrap.BET.ID];
        String template = BET_ReleaseDateEmails.generateTemplate(BET, setting, false);
        Test.stopTest();

        system.debug(template);
        System.assert(template.containsIgnoreCase('Final Release'));
        System.assert(!template.containsIgnoreCase('First Release'));
    }

    static testMethod void updateEmailParams(){
      BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET1' + system.now(), true);

      Date myDate = date.today();
      Date launchDate = Date.newInstance(myDate.year()+1, 1, 15);

      wrap.BET.Launch_Date__c = launchDate;
      update wrap.BET;

      BET_Request_Access__c setting = new BET_Request_Access__c(Name = 'Test', Send_Mail_To_Owner__c = true, Email_Address__c='test@test.com', Logo_Url__c='http://test.com/img.jpg');
      insert setting;

      Test.startTest();
      System.assert(BET_ReleaseDateEmails.updateEmailParams(new Messaging.SingleEmailMessage(),wrap.BET,setting,true,new List<String>()) != null,'Email should not be null');
      Test.stopTest();
    }
}