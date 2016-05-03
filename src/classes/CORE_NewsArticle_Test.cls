@isTest
public class CORE_NewsArticle_Test{
    @isTest(SeeAllData = true)
    static void testCreateNewsArticle(){
        Test.startTest();
        CollaborationGroup cg ;
        
        try{
            cg = [Select Id, Name from CollaborationGroup where Name = 'News Centre' LIMIT 1];
        }catch(Exception e){
            insert (cg=new CollaborationGroup(Name = 'News Centre', CollaborationType = 'Public'));
        }
        
        Profile p = [Select Id from Profile where Name = 'System Administrator' LIMIT 1];     
        User usr = new User(ProfileId = p.Id, Username = 'TestUser3248787878SSDDD1234@test1341.com', Email = 'test12341@abc123.com',
                            FirstName = 'Test1234', LastName = 'User1234', alias='tx1234', EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
        insert usr;
        
            
        News_Article__c newsArticle = new News_Article__c(Name = 'Article 1', Title__c = 'Article 1 Title', Socialise_Activity__c=TRUE,
            Sub_Title__c = 'Article 1 Sub Title', Sharepoint_URL__c = 'http://www.salesforce.com', Post_To_NewsCentre__c = true,Chatter_Groups__c =cg.id,Site_Type__c ='News Centre',Admin_Chatter_Group__c='test12341@abc123.com');//,Chatter_Groups__c ='News Centre');
        
        insert newsArticle;
        
        
        Test.setCurrentPage(Page.NewsArticleFeed);
        ApexPages.currentPage().getParameters().put('articleId', newsArticle.Id);
        
        
        NewsArticleFeedController newsArticleFeedCon = new NewsArticleFeedController();
        
        newsArticleFeedCon.likeArticle();
        
        newsArticleFeedCon.doNothing();
        
        System.assertEquals(1, [Select Id, Like_Count_RSF__C from News_Article__c where Id = :newsArticle.Id].Like_Count_RSF__C);
        
        newsArticleFeedCon.unlikeArticle();
        
        System.assertEquals(0, [Select Id from NewsArticleLike__c where News_Article__c = :newsArticle.Id].size());

        FeedItem articleComment = new FeedItem(ParentId = newsArticle.Id, Body = 'Comment 1');
        insert articleComment;
        
        FeedComment childComment = new FeedComment(FeedItemId = articleComment.Id, CommentBody='Child Comment 1');
        insert childComment;
        
        System.assertEquals(2, [Select Id, Comment_Count__c from News_Article__c where Id = :newsArticle.Id].Comment_Count__c);
        
        //delete childComment;
        //delete articleComment;
        Test.stopTest();
    }
    @isTest(SeeAllData = true)
    static void testCreateMCO(){
        Test.startTest();
        
            CollaborationGroup cg ;
        
        try{
            cg = [Select Id, Name from CollaborationGroup where Name = 'News Centre' LIMIT 1];
        }catch(Exception e){
            insert (cg=new CollaborationGroup(Name = 'News Centre', CollaborationType = 'Public'));
        }
        
        Profile p = [Select Id from Profile where Name = 'System Administrator' LIMIT 1];     
        User usr = new User(ProfileId = p.Id, Username = 'TestUser3248787878SSDDD1234@test1341.com', Email = 'test12341@abc123.com',
                            FirstName = 'Test1234', LastName = 'User1234', alias='tx1234', EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
         insert usr;  
          
            News_Article__c newsArticle1 = new News_Article__c(Name = 'Article 1', Title__c = 'Article 1 Title', Socialise_Activity__c=TRUE,
            Sub_Title__c = 'Article 1 Sub Title', Sharepoint_URL__c = 'http://www.salesforce.com', Post_To_NewsCentre__c = true,Chatter_Groups__c =cg.id,Site_Type__c ='MCO',Admin_Chatter_Group__c=cg.id);//,Chatter_Groups__c ='News Centre');
        
        insert newsArticle1;
        
        Test.setCurrentPage(Page.NewsArticleFeed);
        ApexPages.currentPage().getParameters().put('articleId', newsArticle1.Id);
        
        NewsArticleFeedController newsArticleFeedCon1 = new NewsArticleFeedController();
        
        newsArticleFeedCon1.likeArticle();
        
        newsArticleFeedCon1.doNothing();
        
        System.assertEquals(1, [Select Id, Like_Count_RSF__C from News_Article__c where Id = :newsArticle1.Id].Like_Count_RSF__C);
        
        newsArticleFeedCon1.unlikeArticle();
        
        System.assertEquals(0, [Select Id from NewsArticleLike__c where News_Article__c = :newsArticle1.Id].size());

        FeedItem articleComment1 = new FeedItem(ParentId = newsArticle1.Id, Body = 'Comment 123');
        insert articleComment1;
        
        FeedComment childComment1 = new FeedComment(FeedItemId = articleComment1.Id, CommentBody='Child Comment 123');
        insert childComment1;
        
        System.assertEquals(2, [Select Id, Comment_Count__c from News_Article__c where Id = :newsArticle1.Id].Comment_Count__c);
        
        //delete childComment1;
        //delete articleComment1;
        Test.stopTest();
    }
    
    @isTest(SeeAllData = true)
    static void testOverrideView(){
        Test.startTest();
        News_Article__c newsArticle = new News_Article__c(Name = 'Article 2', Title__c = 'Article 2 Title', Socialise_Activity__c = TRUE,
            Sub_Title__c = 'Article 1 Sub Title', Sharepoint_URL__c = 'http://www.salesforce.com', Post_To_NewsCentre__c = false);
        
        insert newsArticle;
        
        Profile chatterOnly = [Select Id from Profile where Name = 'Unilever - Chatter Only' LIMIT 1];     
        User u = new User(ProfileId = chatterOnly.Id, Username = 'TestUser3248787878SSDDD@test134.com', Email = 'TestUser3248787878SSDDD@test134.com',
                            FirstName = 'Test', LastName = 'User', alias='tusrxxt', EmailEncodingKey='UTF-8',  LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', TimeZoneSidKey='America/Los_Angeles');
        insert u;
        
        Apexpages.currentPage().getParameters().put('fromEmail','1');
        
        
      PageReference pageRef = Page.NewsArticle_OverrideView;
      Test.setCurrentPage(pageRef);
        
        NewsArticle_OverrideViewCon con = new NewsArticle_OverrideViewCon(new ApexPages.StandardController(newsArticle));
        con.Email='0';
        //con.bolmessage=true;
        Test.setCurrentPage(Page.NewsArticle_OverrideView);
        
        System.runAs(u){
                System.assertEquals(null, con.routeOnLoad());
        }
        Test.stopTest();
    }
    
    @future
    static void insertPermissionSetAssignment(Id userId){
        Test.startTest();
        PermissionSet permSet = [Select Id from PermissionSet where Id = :uw_Custom_Setting__c.getInstance('NEWS_CENTRE_PERM_SET').Text_Value__c LIMIT 1];
        
        PermissionSetAssignment permSetAssignment = new PermissionSetAssignment(AssigneeId = userId, PermissionSetId = permSet.Id);
        insert permSetAssignment;
        System.assert(permSetAssignment != null);
        Test.stopTest();
    }

}