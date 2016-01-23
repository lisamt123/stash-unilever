/*********************************************************************************************************
Class Name      :       uw_FetchFeedItems_Test
Class Desc.     :       Test Class for Controller class uw_FetchFeedItems
Author          :       Accenture India
********************************************************************************************************/
@isTest
public class uw_FetchFeedItems_Test{

   /* 
   Method Name  : testfetchBetFeeds
   Description  : test Method to fetch bet feeds 
   ReturnType   : void */

    private static testmethod void testfetchBetFeeds() {
        Test.startTest();
        uw_Inoplan_Project__c projectName = new uw_Inoplan_Project__c();
        projectName.Name = 'No Inoplan Project';
        insert projectName;
        uw_BET__c bet = uw_UnitTestDataFactory.initBET('betName',true,projectName);
        ContentVersion cv = uw_UnitTestDataFactory.initContentVersion();
        uw_Asset__c asset = uw_UnitTestDataFactory.initAsset('n', cv, bet);
        uw_TriggerHandler th = new uw_TriggerHandler();
        FeedItem fi = new FeedItem(Type='LinkType', ParentId=bet.Id);
        uw_FetchFeedItems.fetchFeedOfBet(bet.id);
        Test.stopTest(); 
    } 
    
     /* 
   Method Name  : testfetchChatterGroupFeeds
   Description  : test Method to fetch chatter group feeds 
   ReturnType   : void */
  
    
    private static testmethod void testfetchChatterGroupFeeds() {
        Test.startTest();
        uw_Inoplan_Project__c projectName = new uw_Inoplan_Project__c();
        projectName.Name = 'No Inoplan Project';
        insert projectName;
        Id cGroupId = uw_UnitTestDataFactory.getTestChatterGroupId();
        uw_BET__c bet = uw_UnitTestDataFactory.initBET('betName',true,projectName);
        ContentVersion cv = uw_UnitTestDataFactory.initContentVersion();
        FeedItem fi = new FeedItem(Type='LinkType',RelatedRecordId=cGroupId,ParentId=bet.Id);
        uw_FetchFeedItems.getFeedItemsOfChatterGroup(cGroupId);
        Test.stopTest(); 
    }   
}