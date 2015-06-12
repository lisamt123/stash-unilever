@isTest
private class cp_NewsControllerTest {

  private static testMethod void testGetRecords(){
    cp_News__c activeHT = buildNewsItem('Hot Topics', 'Active', true);
    cp_News__c inactiveHT = buildNewsItem('Hot Topics', 'Active', false);

    cp_News__c activeAGA = buildNewsItem('At a Glance', 'Active', true);
    cp_News__c inactiveAGA = buildNewsItem('At a Glance', 'Active', false);

    cp_NewsController nc = new cp_NewsController();
    System.assertEquals(2, nc.numHotTopics);
    System.assertEquals(2, nc.numAtaGlances);
  }


  private static cp_News__c buildNewsItem(String type, String status, Boolean approved) {
    cp_News__c newsItem = new cp_News__c(short_description__c = 'Test', status__c = status, news_type__c = type);
    insert newsItem;

    return newsItem;
  }
}