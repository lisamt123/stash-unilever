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

    System.assert(bet.First_Release_Due_Date__c != null,'First Release Due Date should be set');
    System.assert(bet.Final_Release_Due_Date__c != null,'Final Release Due Date should be set');
  }

  @isTest static void updateFileIdTest(){
    uw_Bet__c bet = BET_TestUtils.getTestBet();
    bet.Launch_Date__c = Date.today();
    insert bet;

    uw_Asset__c asset = new uw_Asset__c(URL_of_Asset__c = 'smth/download/'+bet.id+'?smth');
    List<uw_Asset__c> assets = new List<uw_Asset__c>{asset};
    List<uw_Asset__c> nAssets = BET_AssetService.updateFileId(assets);
    System.assert(!nAssets.isEmpty(),'List should not be empty');
  }
  
}