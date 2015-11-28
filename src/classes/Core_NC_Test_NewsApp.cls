/*
  Class Name: Core_NC_Test_NewsApp
  Author : Mindtree
  Date: 1 Nov 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Test class to cover 
                           1.Core_NC_NewsCenterController
                           2.Core_NC_NewsCenterControllerHelper
                           3.Core_NC_NewsWrapperClass
                           4.Core_NC_NewsDetailWrapperClass 

*/

@isTest (Seealldata=true)
public class Core_NC_Test_NewsApp{
    
    public static testMethod void TestNewsAppGlobalNews(){
        test.starttest();
        DateTime dt=System.now().addDays(-1);
        News_Article__c news1=new News_Article__c(Name='Test1',News_Article_Topics__c='Innovation',News_Body__c='Test Body',
                                                  News_Publish_Date__c=dt,Sharepoint_URL__c='http://www.google.com',Site_Name__c='News Centre',
                                                  Site_Type__c='News Centre',Sub_Title__c='Sub Title1',Summary__c='Test Summary',Title__c='Title1',
                                                  View_Count__c=10);
        insert news1;
        System.assert(news1!= null);
        News_Article__c news2=new News_Article__c(Name='Test2',News_Article_Topics__c='Innovation',News_Body__c='Test Body',
                                                  News_Publish_Date__c=dt,Sharepoint_URL__c='http://www.google.com',Site_Name__c='Paul\'s Blog',
                                                  Site_Type__c='Paul\'s Blog',Sub_Title__c='Sub Title1',Summary__c='Test Summary',Title__c='Title1',
                                                  View_Count__c=10);
        insert news2;
        System.assert(news2!= null);
        News_Article__c news3=new News_Article__c(Name='Test2',News_Article_Topics__c='Innovation',News_Body__c='Test Body',
                                                  News_Publish_Date__c=dt,Sharepoint_URL__c='http://www.google.com',Site_Name__c='Finance',
                                                  Site_Type__c='MCO',Sub_Title__c='Sub Title1',Summary__c='Test Summary',Title__c='Title1',
                                                  View_Count__c=10);
        insert news3;
        System.assert(news3!= null);
        Core_NC_NewsCenterController.getGlobalNewsForMostRecent('GlobalNews');
        Core_NC_NewsCenterController.getGlobalNewsForMostRecent('PaulsBlog');
        Core_NC_NewsCenterController.getGlobalNewsForMostRecent('MyNews');
        Core_NC_NewsCenterController.getNewsDetail(news1.Id);
        
        test.stoptest();
    }
    
    public static testMethod void TestNewsAppTrendingNews(){
        test.starttest();
        DateTime dt=System.now().addDays(-1);
        News_Article__c news1=new News_Article__c(Name='Test1',News_Article_Topics__c='Innovation',News_Body__c='Test Body',
                                                  News_Publish_Date__c=dt,Sharepoint_URL__c='http://www.google.com',Site_Name__c='News Centre',
                                                  Site_Type__c='News Centre',Sub_Title__c='Sub Title1',Summary__c='Test Summary',Title__c='Title1',
                                                  View_Count__c=10);
        insert news1;
        News_Article__c news3=new News_Article__c(Name='Test2',News_Article_Topics__c='Innovation',News_Body__c='Test Body',
                                                  News_Publish_Date__c=dt,Sharepoint_URL__c='http://www.google.com',Site_Name__c='Finance',
                                                  Site_Type__c='MCO',Sub_Title__c='Sub Title1',Summary__c='Test Summary',Title__c='Title1',
                                                  View_Count__c=10);
        insert news3;
        System.assert(news3!= null);
        insert new FeedItem(Type='TextPost',Body='Hi',ParentId=news1.Id);
        insert new FeedItem(Type='TextPost',Body='Hi',ParentId=news3.Id);
        
        Core_NC_NewsCenterController.putLikeForNews(news1.Id);
        Core_NC_NewsCenterController.putLikeForNews(news3.Id);
        Core_NC_NewsCenterController.getTrendingNews('GlobalNews','View');
        Core_NC_NewsCenterController.getTrendingNews('GlobalNews','Like');
        Core_NC_NewsCenterController.getTrendingNews('GlobalNews','Comment');
        Core_NC_NewsCenterController.getTrendingNews('MyNews','View');
        Core_NC_NewsCenterController.getTrendingNews('MyNews','Like');
        Core_NC_NewsCenterController.getTrendingNews('MyNews','Comment');
        
        
        test.stoptest();
    }
    
    public static testMethod void TestNewsAppChatterShare(){
        test.starttest();
        DateTime dt=System.now().addDays(-1);
        News_Article__c news1=new News_Article__c(Name='Test1',News_Article_Topics__c='Innovation',News_Body__c='Test Body',
                                                  News_Publish_Date__c=dt,Sharepoint_URL__c='http://www.google.com',Site_Name__c='News Centre',
                                                  Site_Type__c='News Centre',Sub_Title__c='Sub Title1',Summary__c='Test Summary',Title__c='Title1',
                                                  View_Count__c=10);
        insert news1;
        News_Article__c news3=new News_Article__c(Name='Test2',News_Article_Topics__c='Innovation',News_Body__c='Test Body',
                                                  News_Publish_Date__c=dt,Sharepoint_URL__c='http://www.google.com',Site_Name__c='Finance',
                                                  Site_Type__c='MCO',Sub_Title__c='Sub Title1',Summary__c='Test Summary',Title__c='Title1',
                                                  View_Count__c=10);
        insert news3;
        System.assert(news3!= null);
        
        CollaborationGroup objgroup= new CollaborationGroup(Name = 'my_group1', CollaborationType = 'public');
        insert objgroup;
        
        Core_NC_NewsCenterController.getGroupNames();
        Core_NC_NewsCenterController.postNewsToChatter('Title1',news1.Sharepoint_URL__c,'Test','myFollowers','');
        Core_NC_NewsCenterController.postNewsToChatter('Title2',news3.Sharepoint_URL__c,'Test','group','my_group1');
        
        test.stoptest();
    }
    
    public static testMethod void TestNewsAppNewsFeedController(){
        test.starttest();
        DateTime dt=System.now().addDays(-1);
        News_Article__c news1=new News_Article__c(Name='Test1',News_Article_Topics__c='Innovation',News_Body__c='Test Body',
                                                  News_Publish_Date__c=dt,Sharepoint_URL__c='http://www.google.com',Site_Name__c='News Centre',
                                                  Site_Type__c='News Centre',Sub_Title__c='Sub Title1',Summary__c='Test Summary',Title__c='Title1',
                                                  View_Count__c=10);
        insert news1;
        System.assert(news1!= null);
        
        Test.setCurrentPage(Page.NewsArticleFeed_NewsApp);
        ApexPages.currentPage().getParameters().put('articleId', news1.Id);
        NewsArticleFeedController_NewsApp newsFeedController=new NewsArticleFeedController_NewsApp();
        Core_NC_NewsCenterController.getGAInfo();
        
        test.stoptest();
    }
    
}