@isTest
private class BET_DataFixReleaseDate_BatchTest {
  
  @isTest static void processTest() {
    uw_Bet__c bet = BET_TestUtils.getTestBet();
    bet.Launch_Date__c = Date.today();
    insert bet;

    Test.startTest();
      BET_DataFixReleaseDate_Batch batch = new BET_DataFixReleaseDate_Batch();
      Database.executeBatch(batch);
      Test.stopTest();

      bet = [Select First_Release_Due_Date__c, Final_Release_Due_Date__c, Launch_Date__c from uw_BET__c where id =: bet.id];

    System.assert(bet.First_Release_Due_Date__c != null);
    System.assert(bet.Final_Release_Due_Date__c != null);
  }
  
}