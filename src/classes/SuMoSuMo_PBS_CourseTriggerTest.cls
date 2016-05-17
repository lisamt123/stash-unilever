@isTest
public with sharing class SuMoSuMo_PBS_CourseTriggerTest {
  private static testmethod void executeRewardingTest () {
    success.SuMoObjectSettings.getInstance().add('SuMo_PBS_Course__c');
    success.TestData.loadCustomSettingData();
    insert success.TestData.SuMoSets.defaultSet;
    User testUser = success.TestData.Users.player;
    Profile[] profiles = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
    Profile testProfile;
    if (profiles.size() > 0) testProfile = profiles[0];
    else {
	   profiles = [SELECT Id FROM Profile WHERE Name LIKE '%admin%' LIMIT 1];
      if (profiles.size() > 0) testProfile = profiles[0];
      else testProfile = [SELECT Id FROM Profile LIMIT 1][0];
    }
    system.runAs(new User(Id = UserInfo.getUserId())) {
      update new User(Id = UserInfo.getUserId(), success__SuMo_User__c = TRUE);
      insert testUser;
    }
    Integer startExperience = Integer.valueOf([SELECT success__Experience__c FROM User WHERE Id = :UserInfo.getUserId()].success__Experience__c);
    if (startExperience == null) {
      startExperience = 0;
    }
    insert new success__Achievement__c (Name = 'testAchievement',
								success__Action__c = 'Created',
								success__Object__c = 'SuMo_PBS_Course__c',
								success__Active__c = true,
								success__Recipient__c = 'CreatedById',
								success__Experience_Formula__c = '42',
								success__Level_Up__c = false,
								RecordTypeID = success.TestData.RecordTypeMap.get('One_Off').Id,
								success__Automatically_Awarded__c = true,
								success__Reward_Message__c = 'Hurra!');
    Test.startTest();
    System.runAs(new User(Id = UserInfo.getUserId())) {      //Create a SuMo_PBS_Course__c record
      SuMo_PBS_Course__c mainRecord = new SuMo_PBS_Course__c(
      );
      insert mainRecord;

    }
    Test.stopTest();
    System.assertEquals(startExperience + 42, [SELECT success__Experience__c FROM User WHERE Id = :UserInfo.getUserId()].success__Experience__c);
  }
}