@isTest
public with sharing class SuMoSuMo_Job_CoursesTriggerTest {
  private static testmethod void executeRewardingTest () {
    success.SuMoObjectSettings.getInstance().add('SuMo_Job_Courses__c');
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
								success__Object__c = 'SuMo_Job_Courses__c',
								success__Active__c = true,
								success__Recipient__c = 'CreatedById',
								success__Experience_Formula__c = '42',
								success__Level_Up__c = false,
								RecordTypeID = success.TestData.RecordTypeMap.get('One_Off').Id,
								success__Automatically_Awarded__c = true,
								success__Reward_Message__c = 'Hurra!');
    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {      //Create a SuMo_Job_Courses__c record
      SuMo_Job_Courses__c mainRecord = new SuMo_Job_Courses__c(
      );
      insert mainRecord;

    }
    Test.stopTest();
    System.assertEquals(startExperience + 42, [SELECT success__Experience__c FROM User WHERE Id = :UserInfo.getUserId()].success__Experience__c);
  }
}