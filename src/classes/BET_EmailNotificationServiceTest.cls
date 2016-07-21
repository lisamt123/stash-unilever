@isTest
private class BET_EmailNotificationServiceTest {

  private static final String TEST_COMMENT = 'One email should be created';

  private static final String TEST_PROJECT_NAME = 'Unit Test Project Name';
  
  @isTest static void notifyBetOwnerThatProjectIsUnlinkedTest() {
    uw_BET__c bet = BET_TestUtils.getTestBet();
    insert bet;
    IPM_Project__c oldProject = BET_TestUtils.createIPMProject(TEST_PROJECT_NAME);
    IPM_BETWrapper project = new IPM_BETWrapper(oldProject);
    Test.startTest();
    List<Messaging.SingleEmailMessage> mails = BET_EmailNotificationService.notifyBetOwnerThatProjectIsUnlinked(bet,project,project);
    Test.stopTest();
    System.assertEquals(mails.size(),1,TEST_COMMENT);
  }
  
  @isTest static void notifyBetOwnerOfNewLeadProjectTest() {
    uw_BET__c bet = BET_TestUtils.getTestBet();
    insert bet;
    Test.startTest();
    List<Messaging.SingleEmailMessage> mails = BET_EmailNotificationService.notifyBetOwnerOfNewLeadProject(bet,new IPM_BETWrapper(BET_TestUtils.createIPMProject(TEST_PROJECT_NAME)));
    Test.stopTest();
    System.assertEquals(mails.size(),1,TEST_COMMENT);
  }

  @isTest static void notifyBetOwnerOfUnfollowTest() {
    uw_BET__c bet = BET_TestUtils.getTestBet();
    insert bet;
    IPM_BETWrapper project = new IPM_BETWrapper(BET_TestUtils.createIPMProject(TEST_PROJECT_NAME));
    Test.startTest();
    List<Messaging.SingleEmailMessage> mails = BET_EmailNotificationService.notifyBetOwnerOfUnfollow(bet,project);
    Test.stopTest();
    System.assertEquals(mails.size(),1,TEST_COMMENT);
  }

  @isTest static void notifyBetOwnerOfMultipleMemberRequestsFromIPMTest(){
    uw_BET__c bet = BET_TestUtils.getTestBet();
    insert bet;
    IPM_BETWrapper project = new IPM_BETWrapper(BET_TestUtils.createIPMProject(TEST_PROJECT_NAME));
    Test.startTest();
    List<Messaging.SingleEmailMessage> mails = BET_EmailNotificationService.notifyBetOwnerOfMultipleMemberRequestsFromIPM(bet.id, project.projectId);
    Test.stopTest();
    System.assertEquals(mails.size(),1,TEST_COMMENT);
  }

  @isTest static void notifyBetOwnerOfLeadProjectFollowRequestTest(){
    uw_BET__c bet = BET_TestUtils.getTestBet();
    insert bet;
    IPM_BETWrapper project = new IPM_BETWrapper(BET_TestUtils.createIPMProject(TEST_PROJECT_NAME));
    Test.startTest();
    List<Messaging.SingleEmailMessage> mails = BET_EmailNotificationService.notifyBetOwnerOfLeadProjectFollowRequest(bet,project);
    Test.stopTest();
    System.assertEquals(mails.size(),1,TEST_COMMENT);
  }
  
}