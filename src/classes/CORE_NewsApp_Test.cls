/*
  Class Name: CORE_NewsApp_Test
  Author : Mindtree
  Date: 1 Nov 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Test class to cover 
                           1.Core_NC_NewsCenterController
                           2.Core_NC_NewsCenterControllerHelper
                           3.Core_NC_NewsWrapperClass
                           4.Core_NC_NewsDetailWrapperClass 

*/

@isTest //(Seealldata=false)
public class CORE_NewsApp_Test{
    
   @testSetup static void setupTest() {
        List<CORE_NEWS_ARTICLE__c> lstCustSet = new List<CORE_NEWS_ARTICLE__c>();
       
        lstCustSet.add( new CORE_NEWS_ARTICLE__c(Name='GlobalNewsDaysNumber', Text_Value__c='90'));
        lstCustSet.add( new CORE_NEWS_ARTICLE__c(Name='TrendingNewsDaysNumber', Text_Value__c='14'));
        lstCustSet.add( new CORE_NEWS_ARTICLE__c(Name='CarouselLimit', Text_Value__c='3'));
        lstCustSet.add( new CORE_NEWS_ARTICLE__c(Name='MyNewsSiteNameColorCode', Text_Value__c='red'));
        lstCustSet.add( new CORE_NEWS_ARTICLE__c(Name='GoogleAnalyticsId', Text_Value__c='UA-69390369-6'));
        lstCustSet.add( new CORE_NEWS_ARTICLE__c(Name='RecordCounNumber', Text_Value__c='10'));
        lstCustSet.add( new CORE_NEWS_ARTICLE__c(Name='NEWS_ARTICLE_AVATAR_USER', Text_Value__c='005E0000005My3X'));
        if(!lstCustSet.isEmpty()){
            insert lstCustSet;  
        }
              
    }
    
    
    
    public static testMethod void TestNewsAppGlobalNews(){
        Test.startTest();

        String strSiteTypeOrName1='News Centre';
        DateTime dt=System.now().addDays(-1);
        News_Article__c news1=new News_Article__c(Name='Test1',News_Article_Topics__c='Innovation',News_Body__c='Test Body1',
                                                  News_Publish_Date__c=dt,Sharepoint_URL__c='http://www.google.com',Site_Name__c=strSiteTypeOrName1,
                                                  Site_Type__c=strSiteTypeOrName1,Sub_Title__c='Sub Title1',Summary__c='Test Summary1',Title__c='Title1',
                                                  View_Count__c=10);
        insert news1;
        System.assert(news1!= null);
        News_Article__c news2=new News_Article__c(Name='Test2',News_Article_Topics__c='Leadership',News_Body__c='Test Body2',
                                                  News_Publish_Date__c=dt,Sharepoint_URL__c='http://www.google.com',Site_Name__c='Paul\'s Blog',
                                                  Site_Type__c='Paul\'s Blog',Sub_Title__c='Sub Title2',Summary__c='Test Summary2',Title__c='Title2',
                                                  View_Count__c=10);
        insert news2;
        System.assert(news2!= null);
        News_Article__c news3=new News_Article__c(Name='Test2',News_Article_Topics__c='Marketplace',News_Body__c='Test Body3',
                                                  News_Publish_Date__c=dt,Sharepoint_URL__c='http://www.google.com',Site_Name__c='Finance',
                                                  Site_Type__c='MCO',Sub_Title__c='Sub Title3',Summary__c='Test Summary3',Title__c='Title3',
                                                  View_Count__c=10);
        insert news3;
        System.assert(news3!= null);
        
        Attachment attachmnt1 =new Attachment();
        attachmnt1.name='textfileone1.txt';
        attachmnt1.body =blob.valueOf('my attachment text1');
        attachmnt1.ParentId =news1.Id;
        insert attachmnt1;
       // System.assert(attachmnt1!= null);
       List<Attachment> attachmentsTest2=[select id, name from Attachment where parent.id=:news1.id];
        System.assertEquals(1, attachmentsTest2.size());
        
        Attachment attachmnt2 =new Attachment();
        attachmnt2.name='textfileone2.txt';
        attachmnt2.body =blob.valueOf('my attachment text2');
        attachmnt2.ParentId =news2.Id;
        insert attachmnt2;
       // System.assert(attachmnt2!= null);
         List<Attachment> attachmentsTest=[select id, name from Attachment where parent.id=:news2.id];
        System.assertEquals(1, attachmentsTest.size());
        
        Attachment attachmnt3 =new Attachment();
        attachmnt3.name='textfileone3.txt';
        attachmnt3.body =blob.valueOf('my attachment text3');
        attachmnt3.ParentId =news3.Id;
        insert attachmnt3;
      //  System.assert(attachmnt3!= null);
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:news3.id];
        System.assertEquals(1, attachments.size());
        
      //  Core_NC_NewsCenterController.getGlobalNewsForMostRecent('GlobalNews');
       // Core_NC_NewsCenterController.getGlobalNewsForMostRecent('PaulsBlog');
     //   Core_NC_NewsCenterController.getGlobalNewsForMostRecent('MyNews');
       // Core_NC_NewsCenterController.getNewsDetail(news1.Id);
        System.assertNotEquals(null, Core_NC_NewsCenterController.getNewsDetail(news1.Id));
        System.assertNotEquals(null, Core_NC_NewsCenterController.getGlobalNewsForMostRecent('MyNews'));
        System.assertNotEquals(null,  Core_NC_NewsCenterController.getGlobalNewsForMostRecent('PaulsBlog'));
        System.assertNotEquals(null,  Core_NC_NewsCenterController.getGlobalNewsForMostRecent('GlobalNews'));
        System.assertNotEquals(null,  Core_NC_NewsCenterController.getTopicNames());
        
        
        Test.stopTest();
    }
    
    public static testMethod void TestNewsAppTrendingNews(){
        Test.startTest();
        String strSiteTypeOrName2='News Centre';
        DateTime dt=System.now().addDays(-1);
        News_Article__c news1=new News_Article__c(Name='Test1',News_Article_Topics__c='Innovation',News_Body__c='Test Body4',
                                                  News_Publish_Date__c=dt,Sharepoint_URL__c='http://www.yahoo.com',Site_Name__c=strSiteTypeOrName2,
                                                  Site_Type__c=strSiteTypeOrName2,Sub_Title__c='Sub Title4',Summary__c='Test Summary4',Title__c='Title4',
                                                  View_Count__c=10);
        insert news1;
        News_Article__c news3=new News_Article__c(Name='Test2',News_Article_Topics__c='Marketplace',News_Body__c='Test Body5',
                                                  News_Publish_Date__c=dt,Sharepoint_URL__c='http://www.yahoo.com',Site_Name__c='Finance',
                                                  Site_Type__c='MCO',Sub_Title__c='Sub Title5',Summary__c='Test Summary5',Title__c='Title5',
                                                  View_Count__c=10);
        insert news3;
        
        Attachment attachmnt4 =new Attachment();
        attachmnt4.name='textfileone4.txt';
        attachmnt4.body =blob.valueOf('my attachment text4');
        attachmnt4.ParentId =news1.Id;
        insert attachmnt4;
        System.assert(attachmnt4!= null);
        
        Attachment attachmnt5 =new Attachment();
        attachmnt5.name='textfileone5.txt';
        attachmnt5.body =blob.valueOf('my attachment text5');
        attachmnt5.ParentId =news3.Id;
        insert attachmnt5;
        System.assert(attachmnt5!= null);
        
        System.assert(news3!= null);
        insert new FeedItem(Type='TextPost',Body='Hi',ParentId=news1.Id);
        insert new FeedItem(Type='TextPost',Body='Hi',ParentId=news3.Id);
        
       System.assert(Core_NC_NewsCenterController.putLikeForNews(news1.Id)!=null);
      System.assert(Core_NC_NewsCenterController.putLikeForNews(news3.Id)!=null);
       // Core_NC_NewsCenterController.getTrendingNews('GlobalNews','View');
       System.assert( Core_NC_NewsCenterController.getTrendingNews('GlobalNews','Like')!=null);
       System.assert(Core_NC_NewsCenterController.getTrendingNews('GlobalNews','Comment')!=null);
       System.assert( Core_NC_NewsCenterController.getTrendingNews('MyNews','View')!=null);
       System.assert( Core_NC_NewsCenterController.getTrendingNews('MyNews','Like')!=null);
       System.assert( Core_NC_NewsCenterController.getTrendingNews('MyNews','Comment')!=null);
     
       System.assert(Core_NC_NewsCenterController.getTrendingNews('GlobalNews','View')!=null);

        FeedItem feedItemObject =new FeedItem();
        feedItemObject.Type='TextPost';
        feedItemObject.Body='Hi';
        feedItemObject.ParentId=news3.Id;
        insert feedItemObject;
        
        FeedComment feedCommentObject =new FeedComment();
        feedCommentObject.CommentBody='Hi';
        feedCommentObject.FeedItemId=feedItemObject.Id;
        insert feedCommentObject;
        
        delete feedCommentObject;
        delete feedItemObject;
        
        Test.stopTest();
    }
    
    public static testMethod void TestNewsAppChatterShare(){
        Test.startTest();
        String strSiteTypeOrName3='News Centre';
        DateTime dt=System.now().addDays(-1);
        News_Article__c news1=new News_Article__c(Name='Test1',News_Article_Topics__c='Leadership',News_Body__c='Test Body6',
                                                  News_Publish_Date__c=dt,Sharepoint_URL__c='http://www.msn.com',Site_Name__c=strSiteTypeOrName3,
                                                  Site_Type__c=strSiteTypeOrName3,Sub_Title__c='Sub Title6',Summary__c='Test Summary6',Title__c='Title6',
                                                  View_Count__c=10);
        insert news1;
        News_Article__c news3=new News_Article__c(Name='Test2',News_Article_Topics__c='Marketplace',News_Body__c='Test Body7',
                                                  News_Publish_Date__c=dt,Sharepoint_URL__c='http://www.msn.com',Site_Name__c='Finance',
                                                  Site_Type__c='MCO',Sub_Title__c='Sub Title7',Summary__c='Test Summary7',Title__c='Title7',
                                                  View_Count__c=10);
        insert news3;
        System.assert(news3!= null);
        
        Attachment attachmnt6 =new Attachment();
        attachmnt6.name='textfileone6.txt';
        attachmnt6.body =blob.valueOf('my attachment text6');
        attachmnt6.ParentId =news1.Id;
        insert attachmnt6;
        System.assert(attachmnt6!= null);
        
        Attachment attachmnt7 =new Attachment();
        attachmnt7.name='textfileone7.txt';
        attachmnt7.body =blob.valueOf('my attachment text7');
        attachmnt7.ParentId =news3.Id;
        insert attachmnt7;
        System.assert(attachmnt7!= null);
        
        CollaborationGroup objgroup= new CollaborationGroup(Name = 'my_group1', CollaborationType = 'public');
        insert objgroup;
        
       System.assert( Core_NC_NewsCenterController.getGroupNames()!=null);
     //  System.assert( Core_NC_NewsCenterController.postNewsToChatter('Title1',news1.Sharepoint_URL__c,'Test','myFollowers','')!=null);
        System.assert(Core_NC_NewsCenterController.postNewsToChatter('Title2',news3.Sharepoint_URL__c,'Test','group','my_group1')!=null);
        
        Test.stopTest();
    }
    
    public static testMethod void TestNewsAppNewsFeedController(){
        Test.startTest();
        String strSiteTypeOrName4='News Centre';
        DateTime dt=System.now().addDays(-1);
        News_Article__c news1=new News_Article__c(Name='Test1',News_Article_Topics__c='Our People',News_Body__c='Test Body8',
                                                  News_Publish_Date__c=dt,Sharepoint_URL__c='http://www.yahoo.com',Site_Name__c=strSiteTypeOrName4,
                                                  Site_Type__c=strSiteTypeOrName4,Sub_Title__c='Sub Title8',Summary__c='Test Summary8',Title__c='Title8',
                                                  View_Count__c=10);
        insert news1;
        System.assert(news1!= null);
        
        Attachment attachmnt8 =new Attachment();
        attachmnt8.name='textfileone8.txt';
        attachmnt8.body =blob.valueOf('my attachment text8');
        attachmnt8.ParentId =news1.Id;
        insert attachmnt8;
        System.assert(attachmnt8!= null);
        
        Test.setCurrentPage(Page.NewsArticleFeed_NewsApp);
        ApexPages.currentPage().getParameters().put('articleId', news1.Id);
        NewsArticleFeedController_NewsApp newsFeedController=new NewsArticleFeedController_NewsApp();
      //  Core_NC_NewsCenterController.getGAInfo();
        System.assert(  Core_NC_NewsCenterController.getGAInfo()!=null);
        Test.stopTest();
    }
    
}