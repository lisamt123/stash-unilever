@isTest
private class cp_NewsControllerTest {

  private static testMethod void testGetRecords(){
    //cp_News__c activeHT = buildNewsItem('Hot Topics', 'Active', true);
        cp_News__c activeHT = new cp_News__c();
        activeHT.short_description__c ='Hot Topics';
        activeHT.status__c = 'Active';
        activeHT.news_type__c = 'true';
        
    insert activeHT;
    //cp_News__c inactiveHT = buildNewsItem('Hot Topics', 'Active', false);
    cp_News__c inactiveHT = new cp_News__c();
        inactiveHT.short_description__c ='Hot Topics';
        inactiveHT.status__c = 'Active';
        inactiveHT.news_type__c = 'false';
        
    insert inactiveHT;

    //cp_News__c activeAGA = buildNewsItem('At a Glance', 'Active', true);
    cp_News__c activeAGA = new cp_News__c();
        activeAGA.short_description__c ='At a Glance';
        activeAGA.status__c = 'Active';
        activeAGA.news_type__c = 'true';
        insert activeAGA;
    //cp_News__c inactiveAGA = buildNewsItem('At a Glance', 'Active', false);
    
        cp_News__c inactiveAGA = new cp_News__c();
        inactiveAGA.short_description__c ='At a Glance';
        inactiveAGA.status__c = 'Active';
        inactiveAGA.news_type__c = 'false';
        insert inactiveAGA;

    cp_NewsController nc = new cp_NewsController();
    System.assertNotEquals(2, nc.numHotTopics);
    System.assertNotEquals(2, nc.numAtaGlances);
    
  }


  private static cp_News__c buildNewsItem(String type, String status, Boolean approved) {
    cp_News__c newsItem = new cp_News__c(short_description__c = 'Test', status__c = status, news_type__c = type);
    insert newsItem;

    return newsItem;
  }
}