public with sharing class IPM_ChatterUtils {
    
    public static String ASSIGNMENT_USER_TEXT = 'You have been assigned as a team member for this project ';
    public static String ASSIGNMENT_PROJECT_TEXT = 'Following team member(s) added to the project : ';
    public static String INACTIVE_USERS_TEXT = ' is no longer an active user in IPM Navigator. You may need to find another person to fill this role on your project.';
    public static String TASK_COMPLETION_TEXT = ' Task is completed!';
    public static String USER_CHANGED_ROLES = ' is no longing performing the same role, according to the Unilever Active Directory. You may need to find another person to fill this role on your project ';
    public static String PROJECT_DOCUMENT_TEXT = ' Document is ';
    public static String PROJECT_SECTION_TEXT = ' Section is updated.';
    public static String PROJECT_TLD_CHANGE_TEXT = '\'s Target Launch Period is changed.';
    
// makes a simple chatter text post to the specified record from the running user 
    public static void postRecordFeedWithMention(Id recordId, String postText, Set<Id> userMentionIds) {

        ConnectApi.FeedType feedType = ConnectApi.FeedType.Record;
    
        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        messageInput.messageSegments = new List<connectapi.messagesegmentinput>();
    
        // add the text segment
        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = postText;
        messageInput.messageSegments.add(textSegment);
       
       // add the mention
       for(Id eachUser : userMentionIds) {
           ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
           mentionSegment.id = eachUser;
           messageInput.messageSegments.add(mentionSegment);
       }
        
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        feedItemInput.body = messageInput;
    
        // post it
        if(!Test.isRunningTest()) {
        	//ConnectApi.ChatterFeeds.postFeedItem(null, feedType, recordId, feedItemInput, null);  
        }
    }
    
    public static void postRecordFeed(Id recordId, String postText) {

        ConnectApi.FeedType feedType = ConnectApi.FeedType.Record;
    
        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        messageInput.messageSegments = new List<connectapi.messagesegmentinput>();
    
        // add the text segment
        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = postText;
        messageInput.messageSegments.add(textSegment);
       
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        feedItemInput.body = messageInput;
    
        // post it
        if(!Test.isRunningTest()) {
        	//ConnectApi.ChatterFeeds.postFeedItem(null, feedType, recordId, feedItemInput, null);  
        }
    }
    /*
  // makes a chatter post with some text and a link
  public static void simpleLinkPost(Id userId, String postText, String url, String urlName) {

    ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
    feedItemInput.body = new ConnectApi.MessageBodyInput();

    // add the text segment
    ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
    feedItemInput.body.messageSegments = new List<connectapi.messagesegmentinput>();
    textSegment.text = postText;
    feedItemInput.body.messageSegments.add(textSegment);
    
    // add the attachment
    ConnectApi.LinkAttachmentInput linkIn = new ConnectApi.LinkAttachmentInput();
    linkIn.urlName = urlName;
    linkIn.url = url;
    feedItemInput.attachment = linkIn;

    // post it!
    ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.News, userId, feedItemInput, null);

  }   */

  // makes a simple chatter text post to the specified user from the running user 
  public static void postUserFeedWithMention(Id userId, Id userToMentionId, String postText) { 

    ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
    messageInput.messageSegments = new List<connectapi.messagesegmentinput>();

    // add some text before the mention
    ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
    textSegment.text = 'Hey ';
    messageInput.messageSegments.add(textSegment);

    // add the mention
    ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
    mentionSegment.id = userToMentionId;
    messageInput.messageSegments.add(mentionSegment);

    // add the text that was passed
    textSegment = new ConnectApi.TextSegmentInput();
    textSegment.text = postText;
    messageInput.messageSegments.add(textSegment);

    ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
    input.body = messageInput;

    // post it
    if(!Test.isRunningTest()) {
    	//ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.UserProfile, userId, input, null);
    }
  }     
}