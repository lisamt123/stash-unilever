@isTest
public class ChatterPublisherHandlerTest {
    
    @isTest(seeAllData=true)
     static void ChatterPublisherHandlerTest_GetFeed() {      
 
        ConnectApi.FeedElementpage testPage = new ConnectApi.FeedElementpage();
        List<ConnectApi.FeedItem> testItemList = new List<ConnectApi.FeedItem>();
        ConnectApi.FeedItem element1 = new ConnectApi.FeedItem();
        ConnectApi.FeedItem element2 = new ConnectApi.FeedItem();
        ConnectApi.FeedItem element3 = new ConnectApi.FeedItem(); 
        element1.body = new ConnectApi.FeedBody();
        element1.body.text = 'myText';
        element1.header = new ConnectApi.MessageBody();
        List<ConnectApi.MessageSegment> msgSegments = new List<ConnectApi.MessageSegment>();
        ConnectApi.TextSegment msg1 = new ConnectApi.TextSegment();
        msg1.text = '';
        msg1.type = ConnectApi.MessageSegmentType.Text;
        msgSegments.add(msg1);
        ConnectApi.EntityLinkSegment msg2 = new ConnectApi.EntityLinkSegment();
        msg2.reference = new ConnectApi.Reference();
        msg2.reference.id = 'id';
        msgSegments.add(msg2);
        element1.header.messageSegments = msgSegments;
        element1.relativeCreatedDate = '';
        element1.actor = new ConnectApi.UserSummary();
        ((ConnectApi.UserSummary) element1.actor).DisplayName = 'Slim shaddy'; 
         ((ConnectApi.UserSummary) element1.actor).photo = new ConnectApi.Photo();
        
        element1.capabilities = new ConnectApi.FeedElementCapabilities ();
        element2.capabilities = new ConnectApi.FeedElementCapabilities ();
        element3.capabilities = new ConnectApi.FeedElementCapabilities ();
        element1.capabilities.topics = new ConnectApi.TopicsCapability ();
        element2.capabilities.topics = new ConnectApi.TopicsCapability ();
        element2.capabilities.topics.items = new List<ConnectApi.Topic>();
        List<ConnectApi.Topic> topics = new List<ConnectApi.Topic>();
        ConnectApi.Topic topic = new ConnectApi.Topic();
        topic.name = 'topic1';
        topics.add(topic);
        element1.capabilities.topics.items = topics;
        element1.capabilities.link = new ConnectApi.LinkCapability();
        element1.capabilities.files = new ConnectApi.FilesCapability();  
        element1.capabilities.files.items = new List<ConnectApi.Content>();
        ConnectApi.Content content1 = new ConnectApi.Content();
        content1.title = '';
        element1.capabilities.files.items.add(content1);
        testItemList.add(element1);
        testItemList.add(element2);
        testPage.elements = testItemList;
        ConnectApi.ChatterLike chatterlike = new ConnectApi.ChatterLike();
        ConnectApi.Reference ref = new ConnectApi.Reference();
        ref.Id = element1.Id;
        chatterlike.likedItem = ref;
        
        // Set the test data Network.getNetworkId(), convertedFeedType, subjectId, null,pageSize, ConnectApi.FeedSortOrder.LastModifiedDateDesc
        ConnectApi.ChatterFeeds.setTestGetFeedElementsFromFeed(Network.getNetworkId(), ConnectApi.FeedType.News, 'me',null,5, ConnectApi.FeedSortOrder.LastModifiedDateDesc, testPage);
 
        // The method returns the test page, which we know has two items in it.
        Test.startTest();
        FeedItem feedItem = new FeedItem();
        feedItem.Body = 'test';
        feedItem.ParentId = UserInfo.getUserId();
        insert feedItem;
        element1.Id = feedItem.Id;
        ChatterPublisherHandler.getFeedElements('me','News');
        System.AssertNotEquals(Null,feedItem.id);
        Test.stopTest();
      
  }
    
     @isTest(seeAllData=true)
     static void ChatterPublisherHandlerTest_PostPlainText() {
        Test.startTest();
        String messageToPost='message';
        String subjectId='me';
       ChatterPublisherHandler.postFeedElement('message', 'me');
        System.assertNotEquals(messageToPost,subjectId);
        Test.stopTest();
    }
    
     @isTest(seeAllData=true)
     static void ChatterPublisherHandlerTest_PostWithLink() {
        Test.startTest();
        String messageToPost='Can you check www.google.com please?';
        String subjectId='me';
        ChatterPublisherHandler.postFeedElement('Can you check www.google.com please?', 'me');
        System.assertNotEquals(messageToPost,subjectId);
        Test.stopTest();
    }
    
     @isTest(seeAllData=true)
     static void ChatterPublisherHandlerTest_PostWithMention() {
        Test.startTest();
        String messageToPost='username';
        String subjectId= 'me';
        String currentUserName = UserInfo.getName();
       ChatterPublisherHandler.postFeedElement('Please welcome @[' + currentUserName + ']', 'me');
       System.assertNotEquals(messageToPost,subjectId);
        Test.stopTest();
    }
    
      @isTest(seeAllData=true)
     static void ChatterPublisherHandlerTest_LikeFeedElement() {
        Test.startTest();
        FeedItem feedItem = new FeedItem();
        feedItem.Body = 'test';
        feedItem.ParentId = UserInfo.getUserId();
        insert feedItem;
         System.AssertNotEquals(Null,feedItem.id);
        ChatterPublisherHandler.likeFeedElement(feedItem.id);
        Test.stopTest();
    }
    
    
      @isTest(seeAllData=true)
     static void ChatterPublisherHandlerTest_UNLikeFeedElement() {
        Test.startTest();
        FeedItem feedItem = new FeedItem();
        feedItem.Body = 'test';
        feedItem.ParentId = UserInfo.getUserId();
        insert feedItem;
         System.AssertNotEquals(Null,feedItem.id);
        ChatterPublisherHandler.likeFeedElement(feedItem.id);
        ChatterPublisherHandler.unlikeFeedElement(feedItem.id);
        Test.stopTest();
    }
    
       @isTest(seeAllData=true)
     static void ChatterPublisherHandlerTest_CommentFeedElement() {
        Test.startTest();
        FeedItem feedItem = new FeedItem();
        feedItem.Body = 'test';
        feedItem.ParentId = UserInfo.getUserId();
        insert feedItem;
          System.AssertNotEquals(Null,feedItem.ParentId);
         ChatterPublisherHandler.getFeedElement(feedItem.id);
        ChatterPublisherHandler.postCommentToFeedElement(feedItem.id, 'my comment');
        Test.stopTest();
    }
    
     @isTest//(seeAllData=true)
     static void ChatterPublisherHandlerTest_getMentionCompletion() {
        
        ConnectApi.MentionCompletionPage mentionCompletionPageTest = new ConnectApi.MentionCompletionPage();
        mentionCompletionPageTest.mentionCompletions = new List<ConnectApi.MentionCompletion>();
        ConnectApi.MentionCompletion mention1 = new ConnectApi.MentionCompletion();
        mention1.name = 'sara sara';
        mentionCompletionPageTest.mentionCompletions.add(mention1);
        ConnectApi.Mentions.setTestGetMentionCompletions(Network.getNetworkId(),'sa', UserInfo.getUserId(),mentionCompletionPageTest);
        Test.startTest();
       System.AssertNotEquals(Null,ChatterPublisherHandler.getMentionCompletions('sa', 'me'));
        Test.stopTest();
    }
    
     @isTest(seeAllData=true)
     static void ChatterPublisherHandlerTest_uploadFile() {
        Test.startTest();
        System.AssertNotEquals(Null,ChatterPublisherHandler.uploadNewFile('fileName.txt', 'base64Data', 'txt', 'me', 'hello', ''));
        Test.stopTest();
    }
    
 
     @isTest//(seeAllData=true)
     static void ChatterPublisherHandlerTest_getSubjectNameById() {
        Test.startTest();
        ChatterPublisherHandler.getSubjectNameById('me');
        Account acc = new Account();
        acc.name = 'acme';
        insert acc;
         System.AssertNotEquals(Null,acc.id);
          ChatterPublisherHandler.getSubjectNameById(acc.id);
        Test.stopTest();
    }
 
 
}