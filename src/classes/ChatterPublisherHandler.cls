public with sharing  class ChatterPublisherHandler {
   
     /* ============================================== Retrieving data ================================ */
    
   /* Get Feed Elements From a Feed 
    * This method retrieves the feed while loading the component 
    * Used in : ChatterFeedCmp.cmp  */
    
   @AuraEnabled
   public static List<ChatterAuraFeedItem> getFeedElements(String subjectId, String feedType) { 
            List<ChatterAuraFeedItem> auraFeedItems = new List<ChatterAuraFeedItem>();
            // ChatterAuraFeedItem cfe;
            ConnectApi.FeedType convertedFeedType = convertFeedType(feedtype);
            Integer pageSize = 5 ; // default value
            ChatterPublisherSettings__c setting = ChatterPublisherSettings__c.getInstance('Default');
               if(setting != null) {
                               if(setting.Number_Of_Feed_Elements_to_Display__c != null) {
                       pageSize = setting.Number_Of_Feed_Elements_to_Display__c.intValue(); 
                } 
               }
           // System.debug('pageSize::' + pageSize);
            List<ConnectApi.FeedElement> feedElements = (ConnectApi.ChatterFeeds.getFeedElementsFromFeed(Network.getNetworkId(), convertedFeedType, subjectId, null,pageSize, ConnectApi.FeedSortOrder.LastModifiedDateDesc)).elements; 
            for(ConnectApi.FeedElement fe : feedElements){
                    auraFeedItems.add(getChatterAuraFeedItemFromFeedElement(fe));
           }
           return auraFeedItems;
   } 
   
    /* Get a feed element by Id */
    
   @AuraEnabled
   public static ChatterAuraFeedItem getFeedElement(String feedElementId) {     
           ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.getFeedElement(Network.getNetworkId(), feedElementId); 
           return getChatterAuraFeedItemFromFeedElement(feedElement);
   }
    
    /* Get a comment by Id in order to refresh a comment
     * Used in ChatterFeedElement.cmp */
    
   @AuraEnabled
   public static ChatterAuraFeedComment getCommentById(String commentId) { 
           ConnectApi.Comment comment = ConnectApi.ChatterFeeds.getComment(Network.getNetworkId(), commentId); 
           ChatterAuraFeedComment feedComment = getChatterAuraCommentFromComment(comment);
           return feedComment ; 
   }
    
    /*  This method is used to get suggestions based on typed characters    
     * while mentioning a user or group in the publisher component  */
    
   @AuraEnabled
    public static String getMentionCompletions(String q, String contextId) { 
           String result = '';
           if(contextId != null & contextId.equalsIgnoreCase('me')) {
               contextId = UserInfo.getUserId();
           }
           ConnectApi.MentionCompletionPage mentionCompletionPage = ConnectApi.Mentions.getMentionCompletions(Network.getNetworkId(),q, contextId);
           result = '{ \n  tags: [ \n';
           if(mentionCompletionPage.mentionCompletions != null && !mentionCompletionPage.mentionCompletions.isEmpty()) {
               Integer size = mentionCompletionPage.mentionCompletions.size();
               for(Integer i=0 ; i<size ; i++) {
                    result += '{name: \'' + ((mentionCompletionPage.mentionCompletions).get(i)).name + '\'}';   
                   if(i != size-1) {
                       result+=',';
                   }
               }
 
           }
          result += '\n ] \n }';
          return  result;
 
   }  
    /* Used in ChatterPublisherCmp.cmp in order to display the name of subject Id */
    
    @AuraEnabled 
    public static String getSubjectNameById(String subjectId) {
         String objectName;
        String result;
        if(subjectId != null && subjectId.equalsIgnoreCase('me')) {
            result = 'My Followers';
        } else if(subjectId != null){
            String myIdPrefix = String.valueOf(subjectId).substring(0,3);
           
            //Get schema information
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe();
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype : gd.values()){
                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
              //  System.debug('Prefix is ' + prefix);
                //Check if the prefix matches with requested prefix
                if(prefix!=null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();
                    System.debug('Object Name! ' + objectName);
                    break;
                }
            }
            String query = 'SELECT Id, Name FROM '+ objectName + ' WHERE Id = \'' + subjectId + '\'' ;
        //    System.Debug('My query : ' + query);
            List<sObject> sobjList = Database.query(query);
            if(!sobjList.isEmpty()) {
                sObject mySObject = sobjList.get(0);
                result = String.valueOf( mySObject.get('Name') );
            }
            
        }
        return result;
    } 
    
   
    /* ============================================== Posting to feed  ================================ */
    
   /* Post a new feed element, including Link and mention capabilities
    * Used in : ChatterPublisherCmp.cmp */
   @AuraEnabled
   public static void postFeedElement(String messageToPost,String subjectId) { 
           ConnectApi.FeedItemInput feedItemInput = getFeedItemInputWithMentions(messageToPost,subjectId);
           ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
           feedElementCapabilitiesInput.link = getLinkCapability(messageToPost);
           feedItemInput.capabilities = feedElementCapabilitiesInput;     
   ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
     
   }
    
   /* Posting a new comment to a feed element
    * Used in ChatterFeedElement.cmp */
     
   @AuraEnabled
   public static ChatterAuraFeedItem postCommentToFeedElement(String feedElementId, String text) { 
           ConnectApi.FeedElement feedElement;
           if(text != null && text.trim() != '') {
               ConnectApi.Comment comment = ConnectApi.ChatterFeeds.postCommentToFeedElement(Network.getNetworkId(), feedElementId, text);
                
           } 
           feedElement = ConnectApi.ChatterFeeds.getFeedElement(Network.getNetworkId(), feedElementId);
           return getChatterAuraFeedItemFromFeedElement(feedElement);
           
   }
    
    /* This method allows the upload of a new file form device
     * file is stored in contentVersion object
     * a contentDocument is generated by default for the created ContentVersion
     * The contentDocument Id is used to create a new post */
    
    @AuraEnabled 
    public static String uploadNewFile(String fileName, String base64Data, String contentType, String subjectId, String textToPost, String fileId){
        
        if (fileId == '' || fileId == null) {

            fileId = saveTheFile(subjectId,fileName, base64Data, contentType,textToPost);
        } else {

            fileId = appendToFile(fileId, base64Data, subjectId, textToPost);
        }

        return fileId;
       
    } 
    
    private static String appendToFile(Id fileId, String base64Data, String subjectId, String textToPost) {
        // TO BE DONE : 
        // UPDATE THIS METHOD to enable appending file body for large data file upload
        /*
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');

        ContentVersion oldContentVersion = [
            SELECT Id, VersionData,Title, PathOnClient, ContentDocumentId
            FROM ContentVersion
            WHERE Id = :fileId
        ];

        String existingBody = EncodingUtil.base64Encode(oldContentVersion.VersionData);
 
        ContentVersion newContentVersion = new ContentVersion();
        // see https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_contentversion.htm
        newContentVersion.Title = oldContentVersion.Title;
        newContentVersion.PathOnClient = oldContentVersion.PathOnClient;
        newContentVersion.VersionData = EncodingUtil.base64Decode(existingBody + base64Data);
        newContentVersion.Origin = 'H';
        
        insert newContentVersion;
        
        ContentVersion c = [Select Id, ContentDocumentId from ContentVersion where id =: newContentVersion.Id LIMIT 1]; 
        
        ContentDocument cd = new ContentDocument();
        cd.Id = oldContentVersion.ContentDocumentId;
        delete cd;
        
        List<ConnectApi.FeedElement> feedElements = (ConnectApi.ChatterFeeds.getFeedElementsFromFeed(Network.getNetworkId(), connectApi.FeedType.News, subjectId, null,1, ConnectApi.FeedSortOrder.CreatedDateDesc)).elements; 
        ConnectApi.ChatterFeeds.deleteFeedElement(Network.getNetworkId(), feedElements.get(0).Id);  
        
        postFeedElementWithExistingFile(subjectId,textToPost,c.ContentDocumentId); */
        

        return fileId;
  
    }
    
     @AuraEnabled
    public static String saveTheFile(String subjectId,String fileName, String base64Data, String contentType,String textToPost) { 
    //    System.debug('saveTheFile');
         base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        ContentVersion newContentVersion = new ContentVersion();
        // see https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_contentversion.htm
        newContentVersion.Title = fileName;
        newContentVersion.PathOnClient = fileName;
        newContentVersion.VersionData = EncodingUtil.base64Decode(base64Data);
        newContentVersion.Origin = 'H'; 
        insert newContentVersion;
        ContentVersion c = [Select Id, ContentDocumentId from ContentVersion where id =: newContentVersion.Id LIMIT 1]; 
        postFeedElementWithExistingFile(subjectId,textToPost,c.ContentDocumentId);
        return newContentVersion.Id;
    }
    
    /* Method to create a new post with link, mention and file capabilities */
    
    @AuraEnabled 
    public static void postFeedElementWithExistingFile(String subjectId, String textSegment, id contentDocumentId){
            
        if(textSegment == null){
            textSegment = '';
        }
        
        ConnectApi.FeedItemInput feedItemInput = getFeedItemInputWithMentions(textSegment,subjectId);
        ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
        feedElementCapabilitiesInput.link = getLinkCapability(textSegment);
        feedItemInput.capabilities = feedElementCapabilitiesInput;
        
        
        // The FeedElementCapabilitiesInput object holds the capabilities of the feed item.
        // For this feed item, we define a files capability to hold the file(s).
        
        List<String> fileIds = new List<String>();
        fileIds.add(contentDocumentId);
        
        ConnectApi.FilesCapabilityInput filesInput = new ConnectApi.FilesCapabilityInput();
        filesInput.items = new List<ConnectApi.FileIdInput>();
        
        for (String fileId : fileIds) {
            ConnectApi.FileIdInput idInput = new ConnectApi.FileIdInput();
            idInput.id = fileId;
            filesInput.items.add(idInput);
        }

        feedItemInput.capabilities.files = filesInput;  
    
        // Post the feed item.
         ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
        
        
        
    } 
    
    /* parse a text and prepare letion segments to be posted  */
    
    @AuraEnabled
    public Static ConnectApi.FeedItemInput getFeedItemInputWithMentions (String msg, String subjectId){

        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();     
         
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
         
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
     
        //parse @[User Name]
        //use pattern matching group ()  so we can easily extract name later*
        Pattern p = Pattern.compile('\\@\\[([a-z|A-Z|0-9].*?)\\]'); 
        //use regex to split all all non-mentions into segments

        String [] textSegments = p.split(msg,-1);
         
        //create a pattern matcher object
        Matcher pm = p.matcher( msg );
     
        //all @[mentions] in order (we will need this to build the segments later**)
        List<String> mentionedNames = new List<String>{};   
     
        Map<String,ConnectApi.MentionSegmentInput> nameToInputMap = new Map<String,ConnectApi.MentionSegmentInput>{};
     
        //iterate through each @mention and build a map of unique @mentions 
        if( pm.find() ){
     
            do {
                //now we can extract the pattern matching group defined earlier*
                String mentionName = pm.group(1);
                //use lowercase to ensure case neutrality later***
                String lcName = mentionName.toLowerCase();
                if(!nameToInputMap.containsKey(lcName)){
                    nameToInputMap.put(lcName, new ConnectApi.MentionSegmentInput());               
                }
                mentionedNames.add(lcName);
            } while(pm.find());
     
        }
     
        ConnectApi.MentionSegmentInput[] mentions = new ConnectApi.MentionSegmentInput[]{};
     
        //check the @[chatter names] against user Names
        for(User u: [SELECT Id, Name FROM User WHERE name IN: mentionedNames]){
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            //making sure to fetch using lowercased name***
            nameToInputMap.get(u.Name.toLowerCase()).id = u.id;
            mentionSegmentInput.id = u.id;   
        }
     
        //check the @[chatter names] against Chatter group Names (aka CollaborationGroup)
        for(CollaborationGroup cg: [SELECT Id, Name FROM CollaborationGroup WHERE name IN: mentionedNames]){
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            //making sure to fetch using lowercased name***
            nameToInputMap.get(cg.Name.toLowerCase()).id = cg.id;
            mentionSegmentInput.id = cg.id;  
        }
     
        //shuffle the mentions back in with the text segments
        for(Integer i=0;i<textSegments.size();i++){
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            textSegmentInput.text = textSegments[i];
            messageBodyInput.messageSegments.add(textSegmentInput);
            //due to splitting, there should always be one less mention than text segments
            if(mentionedNames.size() > i){
                // now "sandwich" the @mentions into the text Segments in their original order
                messageBodyInput.messageSegments.add(nameToInputMap.get(mentionedNames[i]));
            }
        }
     
        feedItemInput.body = messageBodyInput;
        feedItemInput.subjectId = subjectId;
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
         
        return feedItemInput;
     
    } 

   /* ============================================== Liking & Unliking feed elements ================================ */
    
   /* Like a feed element by conyext user 
    Used in ChatterFeedElement.cmp */
   @AuraEnabled
   public static ChatterAuraFeedItem likeFeedElement(String feedElementId) {    
           ConnectApi.ChatterLike likeFeedElement = ConnectApi.ChatterFeeds.likeFeedElement(Network.getNetworkId(), feedElementId); 
           ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.getFeedElement(Network.getNetworkId(), feedElementId);
           return getChatterAuraFeedItemFromFeedElement(feedElement);
       
   }
    
   /* Like a feed element by conyext user 
    Used in ChatterFeedElement.cmp */
   @AuraEnabled
    public static ChatterAuraFeedItem unlikeFeedElement(String feedElementId) {
           ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.getFeedElement(Network.getNetworkId(), feedElementId);
            if(feedElement != null) {
                if(feedElement.capabilities != null) {
                    if(feedElement.capabilities.chatterLikes != null) {
                        if(feedElement.capabilities.chatterLikes.isLikedByCurrentUser) {
                            if(feedElement.capabilities.chatterLikes.myLike != null) {
                                ConnectApi.ChatterFeeds.deleteLike(Network.getNetworkId(), feedElement.capabilities.chatterLikes.myLike.Id);
                            }                           
                        }
                        
                    }
                }
            } 
           feedElement = ConnectApi.ChatterFeeds.getFeedElement(Network.getNetworkId(), feedElementId);
           return getChatterAuraFeedItemFromFeedElement(feedElement);
   }
    
    /* ============================================== Liking & Unliking comments ================================ */
   
    /* Like and Unlike a comment  by conyext user 
    Used in ChatterFeedElement.cmp */
   @AuraEnabled
   public static void likeUnlikeComment(String commentIdtoHandleLike) {

       ConnectApi.Comment comment = ConnectApi.ChatterFeeds.getComment(Network.getNetworkId(), commentIdtoHandleLike); 
       ChatterAuraFeedComment feedComment = getChatterAuraCommentFromComment(comment);
       if(feedComment.myLikeId != null) {
               ConnectApi.ChatterFeeds.deleteLike(Network.getNetworkId(), feedComment.myLikeId);
               feedComment.myLikeId = null;
           } else {
               ConnectApi.ChatterLike likeComment = ConnectApi.ChatterFeeds.likeComment (Network.getNetworkId(), commentIdtoHandleLike);
               feedComment.myLikeId = likeComment.Id;
           }

   }
   

    
    
    
  /* ===========================================  Private helper methods =============================================================== */
    

    /* parse links in post */
    
    private static boolean parseLink(String text) {
        boolean result = false;
        if(text != null) {
            if(text.contains('www.')) {
                result = true;
            }
        }
        return result;
    }
    
    /* create a link capability from text segment to post */
    
    private static ConnectApi.LinkCapabilityInput getLinkCapability(String messageToPost){
 
        String linkUrl;
        
        String[] postTextSegments = messageToPost.split(' ');
        for(String s : postTextSegments) {
            if(s.startsWithIgnoreCase('www.')) {
                linkUrl = s;
                break;
            }
        }
        
        ConnectApi.LinkCapabilityInput linkInput;
        
        if(linkUrl != null && linkUrl.trim() != '') {
                linkInput = new ConnectApi.LinkCapabilityInput();
                linkInput.url = linkUrl;
                linkInput.urlName = linkUrl;
        }
        
        
        return linkInput;

    }

    /* Convertind feed type from string to enum */
    
    private static ConnectApi.FeedType convertFeedType(String sFeedType) {
        ConnectApi.FeedType result;
        for(ConnectApi.FeedType feedType : ConnectApi.FeedType.values()) {
            if(feedType.name() == sFeedType) {
                result =  feedType;
            }
        }
        return result;
    }
    
    
    /* map a ConnectApi.Comment to a ChatterAuraFeedComment */
    
    private static ChatterAuraFeedComment getChatterAuraCommentFromComment(ConnectApi.Comment comment) {
        ChatterAuraFeedComment feedComment = new ChatterAuraFeedComment();
        feedComment.Id = comment.Id;
        if(comment.body != null) {
            feedComment.text = comment.body.text;
        }  
        if(comment.user != null) {
            feedComment.userDisplayName = comment.user.displayName;
            feedComment.userId = comment.user.id;
            if(comment.user.photo != null) {
                feedComment.userSmallPhotoUrl = comment.user.photo.smallPhotoUrl;
            }       
        }
        feedComment.relativeCreatedDate = comment.relativeCreatedDate;
        if(comment.myLike != null) { 
            feedComment.myLikeId = comment.myLike.Id;
        }
        return feedComment;                               
    }
    
   /* map a ConnectApi.FeedElement  to a ChatterAuraFeedItem */
   private static ChatterAuraFeedItem getChatterAuraFeedItemFromFeedElement(ConnectApi.FeedElement fe) {
               ChatterAuraFeedItem cfe = new ChatterAuraFeedItem();
               if(fe instanceof connectApi.FeedItem){
                   cfe.elementId = fe.Id; 
                   
                   /** get feed element body & message segments **/
                   if(((connectApi.FeedItem) fe).body != null) {
                           cfe.bodyText = ((connectApi.FeedItem) fe).body.text;  
                   }
                   List<ChatterAuraMessageSegment> messageSegments = new List<ChatterAuraMessageSegment>();  
                   ChatterAuraMessageSegment ms;
                   if(((connectApi.FeedItem) fe).header != null){
                       if(((connectApi.FeedItem) fe).body.isRichText == null || ((connectApi.FeedItem) fe).body.isRichText == false) {
                           cfe.isRichText = false;
                       } else {
                           cfe.isRichText = true;
                       }   
                      for(ConnectApi.MessageSegment messageSegment : ((connectApi.FeedItem) fe).header.messageSegments){
                       ms = new ChatterAuraMessageSegment();
                       ms.text = messageSegment.text;
                       if(messageSegment.type != null) {
                               ms.type = messageSegment.type.name();
                       }
                       if(messageSegment instanceof ConnectApi.EntityLinkSegment) {
                           if(((ConnectApi.EntityLinkSegment) messageSegment).reference != null) {
                               ms.referenceId = ((ConnectApi.EntityLinkSegment) messageSegment).reference.id;
                           }                           
                       }

                       messageSegments.add(ms); 
                    } 
                   } 
                   cfe.messageSegments = messageSegments; 
                   ChatterAuraFeedItem.ChatterRichTextSegment richTextSegment;
                   if(((connectApi.FeedItem) fe).body != null) {
                       if(((connectApi.FeedItem) fe).body.messageSegments != null) {
                        for(ConnectApi.MessageSegment messageSegment : ((connectApi.FeedItem) fe).body.messageSegments){
                                 if(cfe.richBodyText == null) {
                                      cfe.richBodyText = new List<ChatterAuraFeedItem.ChatterRichTextSegment>();
                                  }
                                  richTextSegment = new ChatterAuraFeedItem.ChatterRichTextSegment();
                            
                                  if(messageSegment instanceof ConnectApi.MarkupBeginSegment) {
                                      richTextSegment.segmentBody = ' <' + ((ConnectApi.MarkupBeginSegment) messageSegment).htmlTag + '> ';
                                      cfe.isRichText = true;
                                  }
                                  if(messageSegment instanceof ConnectApi.MarkupEndSegment) {
                                      richTextSegment.segmentBody = ' </' + ((ConnectApi.MarkupEndSegment) messageSegment).htmlTag + '> '  ;                  
                                  }
                                  if(messageSegment instanceof ConnectApi.TextSegment) {
                                      richTextSegment.segmentBody = messageSegment.text;
                                  }
                                  if(messageSegment instanceof ConnectApi.MentionSegment) {
                                      cfe.isRichText = true;
                                      richTextSegment.segmentType = 'mention';
                                      if(((ConnectApi.MentionSegment) messageSegment).record != null) {
                                          richTextSegment.refId = ((ConnectApi.ActorWithId)((ConnectApi.MentionSegment) messageSegment).record).Id;
                                      }
                                      richTextSegment.refName = ((ConnectApi.MentionSegment) messageSegment).name ;
                                  }
                                  if(messageSegment instanceof ConnectApi.LinkSegment) {
                                      cfe.isRichText = true;
                                      String refId = '#';
                                      richTextSegment.segmentBody = ' <a href="' + ((ConnectApi.LinkSegment) messageSegment).url + '"> ' + ((ConnectApi.LinkSegment) messageSegment).text + '</a>';
                                  } 
                                  cfe.richBodyText.add(richTextSegment);
                            }
                        }
                   }
                       
                   
                   /** get feed likes **/
                   
                   if(fe.Id != null) {
                       ConnectApi.ChatterLikePage likePage = ConnectApi.ChatterFeeds.getLikesForFeedElement(Network.getNetworkId(), fe.Id);
                       List<ConnectApi.ChatterLike> likesList = likePage.items;
                       cfe.numberOfLikes = likesList.size();  
                       cfe.likers = new List<ChatterAuraLiker>();
                       for(ConnectApi.ChatterLike liker : likePage.items) {
                           ChatterAuraLiker cal = new ChatterAuraLiker();
                           cal.displayName = ((ConnectApi.UserSummary) liker.user).displayName;
                           cal.referenceId = ((ConnectApi.UserSummary) liker.user).id;
                           cfe.likers.add(cal);
                       }
                   } 
                   
                   /** get feed elemnt actor info **/
                   cfe.createdDate = String.ValueOf(((connectApi.FeedItem) fe).relativeCreatedDate);
                   if((((connectApi.FeedItem) fe).actor) instanceof connectApi.UserSummary){
                       cfe.actorDisplayName = ((connectApi.UserSummary)(((connectApi.FeedItem) fe).actor)).displayName;
                       if(((connectApi.UserSummary)(((connectApi.FeedItem) fe).actor)).photo != null) {
                           cfe.actorSmallPhotoUrl = ((connectApi.UserSummary)(((connectApi.FeedItem) fe).actor)).photo.smallPhotoUrl;
                       }        
                   }
                   
                   /** get feed elements topics **/
                   cfe.topics = new List<String>();
                   if(((connectApi.FeedItem) fe).capabilities != null ) {     
                      if((((connectApi.FeedItem) fe).capabilities).topics != null) {
                           List<ConnectApi.Topic> topics = ((connectApi.FeedItem) fe).capabilities.topics.items;
                          if(topics != null){
                              for (ConnectApi.Topic t : topics){
                               cfe.topics.add(t.name);  
                              }
                             if(cfe.topics.isEmpty()){
                               cfe.isEmptyTopics = true;
                             }
                          } else {
                              cfe.isEmptyTopics = true;
                          }
                      }
                   } 
                   
                   /** if feed element contains capabilities : link or file **/
                   if(((ConnectApi.FeedElementCapabilities) fe.capabilities) != null){
                       if(((ConnectApi.FeedElementCapabilities) fe.capabilities).link != null){
                            cfe.isLink = true;
                            cfe.linkUrl = (((ConnectApi.FeedElementCapabilities) fe.capabilities).link).url;
                            cfe.linkUrlName = (((ConnectApi.FeedElementCapabilities) fe.capabilities).link).urlName;
                       }
                       if(((ConnectApi.FeedElementCapabilities) fe.capabilities).files != null){
                            cfe.isFile = true;
                            cfe.files = new List<ChatterAuraContent>();
                            ChatterAuraContent feedFile; 
                           if(((ConnectApi.FeedElementCapabilities) fe.capabilities).files.items != null) {
                               for(ConnectApi.Content content : ((ConnectApi.FeedElementCapabilities) fe.capabilities).files.items){
                                   feedFile = new ChatterAuraContent();
                                   feedFile.fileType = content.fileType;
                                   feedFile.title = content.title;
                                   feedFile.downloadUrl = content.downloadUrl;
                                   feedFile.fileExtension = content.fileExtension;
                                   feedFile.renditionUrl = content.renditionUrl;
                                   feedFile.renditionUrl240By180 = content.renditionUrl240By180;
                                   feedFile.renditionUrl720By480 = content.renditionUrl720By480;
                                   feedFile.contentUrl = content.contentUrl;
                                   feedFile.versionId = content.versionId;
                                   feedFile.contentId = content.id;
                                   (cfe.files).add(feedFile);  
                                }
                           }
                            
                       }
                   } 
                   
                   /* if feed element liked by current user */
                   if(((ConnectApi.FeedElementCapabilities) fe.capabilities) != null){
                       if(((ConnectApi.FeedElementCapabilities) fe.capabilities).chatterLikes != null){
                           cfe.isLikedByCurrentUser = (((ConnectApi.FeedElementCapabilities) fe.capabilities).chatterLikes).isLikedByCurrentUser;  
                       }
                   }
                   

                   /** get feed element comments **/
                   
                    if(fe.Id != null) {
                       ConnectApi.CommentPage commentPage = ConnectApi.ChatterFeeds.getCommentsForFeedElement(Network.getNetworkId(), fe.Id);
                       List<ConnectApi.Comment> comments = commentPage.items;
                       if(!comments.isEmpty()){
                           cfe.hasComments = true;
                           cfe.comments = new List<ChatterAuraFeedComment>();
                           for(ConnectApi.Comment comment : comments) {
                               ChatterAuraFeedComment feedComment = getChatterAuraCommentFromComment(comment);
                               cfe.comments.add(feedComment);
                           }
                       } 
                   } 
                   
                   
               }
       
       return cfe;
   }
 
    /* ================================================ Upload from SF capability: search existing files  ========================================================*/

    /**
     * Aura enabled method to search a specified SObject for a specific string
     */
    @AuraEnabled
    public static Result[] lookup(String searchString, String sObjectAPIName)
    {
        // Sanitze the input
        String sanitizedSearchString = String.escapeSingleQuotes(searchString);
        String sanitizedSObjectAPIName = String.escapeSingleQuotes(sObjectAPIName);
 
        List<Result> results = new List<Result>();
 
        // Build our SOSL query
        String searchQuery = 'FIND \'' + sanitizedSearchString + '*\' IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,Title,FileExtension,ArchivedDate) Limit 50'; 
 
        // Execute the Query
        List<List<SObject>> searchList = search.query(searchQuery);
 
        // Create a list of matches to return
        for (SObject so : searchList[0])
        {
            results.add(new Result((String)so.get('Title'),(String)so.get('FileExtension'),(String)so.get('ArchivedDate'), so.Id));
        }
         
        return results;
    }
     
    /**
     * Inner class to wrap up an SObject Label and its Id
     */
    public class Result
    {
        @AuraEnabled public String SObjectLabel {get; set;}
        @AuraEnabled public String FileExtension {get; set;}
        @AuraEnabled public String ArchivedDate {get; set;}
        @AuraEnabled public Id SObjectId {get; set;}
         
        public Result(String sObjectLabel,String FileExtension, String ArchivedDate, Id sObjectId)
        {
            this.SObjectLabel = sObjectLabel;
            this.SObjectId = sObjectId;
            this.FileExtension = FileExtension;
            this.ArchivedDate = ArchivedDate;
        }
    }
    
}