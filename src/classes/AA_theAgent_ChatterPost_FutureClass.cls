Public class AA_theAgent_ChatterPost_FutureClass{    
   
    @future 
    public static void sendToChatter(Id objectId, ID userToMentionId, String postText, Id reportId,string Country) {    
        
        String reportCreatorName = [SELECT Name FROM User where Id=:userToMentionId].Name;
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        feedItemInput.body = new ConnectApi.MessageBodyInput();
        
        feedItemInput.body.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        //intro
        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = 'New Agent Report by '+reportCreatorName +' ';
        feedItemInput.body.messageSegments.add(textSegment);

        // add the mention
       // ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
        //mentionSegment.id = userToMentionId;
        //feedItemInput.body.messageSegments.add(mentionSegment);
        
    //    system.debug('Mention not added -- '+feedItemInput);
        // add the text segment       
        ConnectApi.TextSegmentInput textSegment2 = new ConnectApi.TextSegmentInput();
        textSegment2.text = ': ' + postText;
        feedItemInput.body.messageSegments.add(textSegment2);
        
        // add inline link
        ConnectApi.LinkSegmentInput report_link = new ConnectApi.LinkSegmentInput();
        String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + reportId;
        report_link.url = fullRecordURL;
        feedItemInput.body.messageSegments.add(report_link);
        
        //Adding Attachment            
        List<COntentDocumentLink> documentlist=[SELECT ContentDocument.id FROM ContentDocumentLink WHERE LinkedEntityId = :reportId LIMIT 1];
        if(!documentlist.IsEmpty()){
             ConnectApi.ContentAttachmentInput attachmentInput = new ConnectApi.ContentAttachmentInput(); 
             attachmentInput.contentDocumentId=documentlist[0].ContentDocument.id;
             system.debug('attachmentInput.contentDocumentId===='+attachmentInput.contentDocumentId);  
             feedItemInput.attachment = attachmentInput;
        } 
                    
        // post it!
        system.debug('&&&&Topic1234567890'+feedItemInput);
        ConnectApi.FeedItem new_chat = ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, objectId, feedItemInput, null);
        system.debug('post created here'+new_chat);
        /*
        // add country topic
        if (Country != null) {
            ConnectApi.Topics.assignTopicByName(null, new_chat.id, Country);
        }  */
    }
    
     //@future 
    public static void CreateChatterPost(Id objectId,String postText, Id reportId){
    	
    	system.debug('In createChatterPost method');
    	//String reportCreatorName = [SELECT Name FROM User where Id=:userToMentionId].Name;
        /*ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        feedItemInput.body = new ConnectApi.MessageBodyInput();
        
        feedItemInput.body.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        //intro
        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
       // textSegment.text = 'New Agent Report by '+reportCreatorName +' ';
       textSegment.text = 'New Agent Report by Aslesha';
        feedItemInput.body.messageSegments.add(textSegment);
    	
    	// add the text segment       
        ConnectApi.TextSegmentInput textSegment2 = new ConnectApi.TextSegmentInput();
        textSegment2.text = ': ' + postText;
        feedItemInput.body.messageSegments.add(textSegment2);
        
        // add inline link
        ConnectApi.LinkSegmentInput report_link = new ConnectApi.LinkSegmentInput();
        String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + reportId;
        report_link.url = fullRecordURL;
        feedItemInput.body.messageSegments.add(report_link);
        
        //Adding Attachment            
        List<COntentDocumentLink> documentlist=[SELECT ContentDocument.id FROM ContentDocumentLink WHERE LinkedEntityId = :reportId LIMIT 1];
        if(!documentlist.IsEmpty()){
             ConnectApi.ContentAttachmentInput attachmentInput = new ConnectApi.ContentAttachmentInput(); 
             attachmentInput.contentDocumentId=documentlist[0].ContentDocument.id;
             system.debug('attachmentInput.contentDocumentId===='+attachmentInput.contentDocumentId);  
             feedItemInput.attachment = attachmentInput;
        } 
        
        system.debug('final feed item'+feedItemInput);
        ConnectApi.FeedItem new_chat = ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, objectId, feedItemInput, null);
        //system.debug('post created here'+new_chat);
    }*/
    
    /*    ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        feedItemInput.body.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        feedItemInput.body.messageSegments.add('djkldjfds dsfkjsdlkfds');
        addMessageSegments(messageBodyInput, 'tyuyyi gfhgf gfhgfghfffffjj');
      //  ConnectApi.FeedType targetFeedType = FeedFormatter.getFeedType(feedType);
        ConnectApi.ChatterFeeds.postFeedItem('a6Hc0000000054a',  ConnectApi.FeedType.Record,objectId, feedItemInput, null);*/
    } 
}