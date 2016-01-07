@isTest
private class BET_DataFixReleaseDate_BatchTest {
  
  @isTest static void updateDates(){
    uw_Bet__c bet = BET_TestUtils.getTestBet();
    bet.Launch_Date__c = Date.today();
    insert bet;
    BET_DataFixReleaseDate_Batch batch = new BET_DataFixReleaseDate_Batch();
    Test.startTest();
    bet = batch.updateDates(bet);
    System.assert(bet.Final_Release_Due_Date__c != null,'Final Release Due Date should be set');
    Test.stopTest();
  }

  @isTest static void logExceptionTest(){
    BET_DataFixReleaseDate_Batch batch = new BET_DataFixReleaseDate_Batch();
    Test.startTest();
    batch.logException('Test Exception', new BET_CustomBETException('Test Exception'));
    List<Exception_Log__c> logs = [select id from Exception_Log__c limit 2];
    System.assertEquals(logs.size(),0,'There should be one exception log created');
    Test.stopTest();
  }

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

  @isTest static void processAssetTest() {
    uw_Bet__c bet = BET_TestUtils.getTestBet();
    bet.Launch_Date__c = Date.today();
    insert bet;

    uw_Asset__c asset = new uw_Asset__c(URL_of_Asset__c = 'smth/download/'+bet.id+'?smth', uw_Bet__c = bet.id);
    insert asset;

    Test.startTest();
    BET_DataFixReleaseDate_Batch batch = new BET_DataFixReleaseDate_Batch(true);
    Database.executeBatch(batch);
    Test.stopTest();

    asset = [Select id from uw_Asset__c where id =: asset.id];

    System.assert(asset != null,'asset should exist');
  }

  @isTest static void updateFileIdTest(){
    uw_Bet__c bet = BET_TestUtils.getTestBet();
    bet.Launch_Date__c = Date.today();
    insert bet;

    uw_Asset__c asset = new uw_Asset__c(URL_of_Asset__c = 'smth/download/'+bet.id+'?smth');
    List<uw_Asset__c> assets = new List<uw_Asset__c>{asset};
    List<uw_Asset__c> nAssets = BET_AssetService.updateFileId(assets);
    Test.startTest();
    System.assert(!nAssets.isEmpty(),'List should not be empty');
    Test.stopTest();
  }
  
}