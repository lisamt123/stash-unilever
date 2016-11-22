@isTest
public with sharing class SuMoPBS_FeedbackTriggerTest {
  private static testmethod void executeRewardingTest () {
    success.SuMoObjectSettings.getInstance().add('PBS_Training_Plan_Feedback__c');
    success.TestData.loadCustomSettingData();
    insert success.TestData.SuMoSets.defaultSet;
    system.runAs(new User(Id = UserInfo.getUserId())) {
      update new User(Id = UserInfo.getUserId(), success__SuMo_User__c = TRUE);
    }
    Integer startExperience = Integer.valueOf([SELECT success__Experience__c FROM User WHERE Id = :UserInfo.getUserId()].success__Experience__c);
    if (startExperience == null) {
      startExperience = 0;
    }
    insert new success__Achievement__c (Name = 'testAchievement',
								success__Action__c = 'Created',
								success__Object__c = 'PBS_Training_Plan_Feedback__c',
								success__Active__c = true,
								success__Recipient__c = 'CreatedById',
								success__Experience_Formula__c = '42',
								success__Level_Up__c = false,
								RecordTypeID = success.TestData.RecordTypeMap.get('One_Off').Id,
								success__Automatically_Awarded__c = true,
								success__Reward_Message__c = 'Hurra!');
    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {      //Create a PBS_Training_Plan__c record
      PBS_Training_Plan__c mainRecorddddparent = new PBS_Training_Plan__c(
      );
      insert mainRecorddddparent;

      //Create a PBS_Training_Plan_Feedback__c record
      PBS_Training_Plan_Feedback__c mainRecord = new PBS_Training_Plan_Feedback__c(
      Training_Plan__c = mainRecorddddparent.Id
      );
      insert mainRecord;

    }
    Test.stopTest();
    System.assertEquals(startExperience + 42, [SELECT success__Experience__c FROM User WHERE Id = :UserInfo.getUserId()].success__Experience__c);
  }
}