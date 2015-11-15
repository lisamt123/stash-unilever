/**
    @Description: Business logic resides in this class Chatter Notification class to fire notifications.
    @Author: Cognizant Technology
    @Date: Dec 2014
**/
public with sharing class IPM_ChatterUtils {
    
    /* The constant variables which helps in contextual messagings of the chatter message.
     * The names are pretty much self-explanatory, needs no further elucidations.
    */
/*  public static String ASSIGNMENT_USER_TEXT = 'You have been assigned as a team member for this project ';
    public static String ASSIGNMENT_PROJECT_TEXT = 'Following team member(s) added to the project : ';
    public static String INACTIVE_USERS_TEXT = ' is no longer an active user in IPM Navigator. You may need to find another person to fill this role on your project.';
    public static String TASK_COMPLETION_TEXT = ' Task is completed!';
    public static String USER_CHANGED_ROLES = ' is no longing performing the same role, according to the Unilever Active Directory. You may need to find another person to fill this role on your project ';
    public static String PROJECT_DOCUMENT_TEXT = ' Document is ';
    public static String PROJECT_SECTION_TEXT = ' Section is updated.';
    public static String PROJECT_TLD_CHANGE_TEXT = '\'s Target Launch Period is changed.';
    public static String TASK_ASSIGN_TEXT1 = '- You have been assigned some tasks for ';
    public static String TASK_ASSIGN_TEXT2 ='. Please go have a look. '; */
    
    /*******************************************************************************************************
    * @description: Makes a simple chatter text post to the specified record from the running user 
    * @param1 - recordId: The record id of the project record on whose the chatter feed gets posted 
    * @param2 - postText: The message string to be posted
    * @param3 - userMentionIds: The set of user ids to be @mentioned
    */
    public static void postRecordFeedWithMention(Id recordId, String postText, Set<Id> userMentionIds) {

        ConnectApi.FeedType feedType = ConnectApi.FeedType.Record;
    
        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        messageInput.messageSegments = new List<connectapi.messagesegmentinput>();
        
         // add the mention
        for(Id eachUser : userMentionIds) {
           ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
           mentionSegment.id = eachUser;
           messageInput.messageSegments.add(mentionSegment);
        }
        // add the text segment
        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = postText;
        messageInput.messageSegments.add(textSegment);
       
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        feedItemInput.body = messageInput;
    
        // post it
        if(!Test.isRunningTest() && !isNotificationDisabled()) {
            ConnectApi.ChatterFeeds.postFeedItem(null, feedType, recordId, feedItemInput, null);  
        }
    }
    
    
    /*******************************************************************************************************
    * @description: Makes a simple post to a record 
    * @param1 - recordId: The record id of the project record on whose the chatter feed gets posted 
    * @param2 - postText: The message string to be posted
    */
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
        if(!Test.isRunningTest() && !isNotificationDisabled()) {
            ConnectApi.ChatterFeeds.postFeedItem(null, feedType, recordId, feedItemInput, null);  
        }
    }
    

    /*******************************************************************************************************
    * @description: Makes a simple post to a record 
    * @param1 - map<recordId,postText> : The record id of the project record and the list of chatter feeds needs to be posted 
    */
    public static void postRecordFeed(Map<Id,List<String>> recordIdListPostText) {

        ConnectApi.FeedType feedType = ConnectApi.FeedType.Record;
    
        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        messageInput.messageSegments = new List<connectapi.messagesegmentinput>();

        for(Id recordId : recordIdListPostText.keySet()) {
            List<String> postTextList = recordIdListPostText.get(recordId); 
            for(String postText : postTextList) {
                    
                // add the text segment
                ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
                textSegment.text = postText;
                messageInput.messageSegments.add(textSegment);
                ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                feedItemInput.body = messageInput;
            
                // post it
                if(!Test.isRunningTest() && !isNotificationDisabled()) {
                    ConnectApi.ChatterFeeds.postFeedItem(null, feedType, recordId, feedItemInput, null);  
                }
                textSegment.text = '';
            }
        }
    }
    
    /*******************************************************************************************************
    * @description: makes a simple chatter text post to the specified user from the running user 
    * @param1 - userId: The From User who is posting this message. 
    * @param2 - userToMentionId: The To User on whom the message is posted
    * @param3 - postText: The message
    */
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
        if(!Test.isRunningTest() && !isNotificationDisabled()) {
            ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.UserProfile, userId, input, null);
        }
    
    }  
    /*******************************************************************************************************
    * @description: There is a hierarchical custom settings which checks if the notifications is disabled for that user
    */  
   //
    public static Boolean isNotificationDisabled() {
        
        Boolean paramToReturn = false; //var to return
        IPM_No_Notifications__c profileObj = IPM_No_Notifications__c.getInstance(UserInfo.getProfileId()); //custom settings variable profile wise
        IPM_No_Notifications__c userObj = IPM_No_Notifications__c.getInstance(UserInfo.getUserId()); //custom settings variable user wise
        
        //Check either by profile or by user.
        if(profileObj != null && profileObj.Disabled__c != null && profileObj.Disabled__c) {
            paramToReturn = true;
        }
        //Check by user.
        if(userObj != null && userObj.Disabled__c != null && userObj.Disabled__c) {
            paramToReturn = true;
        }
        
        return paramToReturn;
    } 
}