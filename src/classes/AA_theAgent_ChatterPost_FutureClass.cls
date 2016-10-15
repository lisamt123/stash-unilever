Public with sharing class AA_theAgent_ChatterPost_FutureClass{      
       
    @future 
    Public static void CallSendToChatter(Map<String,String> lsttriggerList)
    {
      //Map<ID,aa_Agent_Report__c> countryList=new Map<ID,aa_Agent_Report__c>(); 
        for ( String objOnfeedID : lsttriggerList.keySet() ){
          aa_Agent_Report__c report = (aa_Agent_Report__c) JSON.deserialize(lsttriggerList.get(objOnfeedID), aa_Agent_Report__c.class);
               //if(objOnfeedID!='Cluster_Id'){
                       system.debug('create chatter post for '+Id.valueof(objOnfeedID));    
                 AA_theAgent_ChatterPost_FutureClass.sendToChatter(Id.valueof(objOnfeedID), report.CreatedById, report.Report_Title__c, report.id,report.Country__c);
                // }else{
                
                 //  countryList.put(report.Country__c,report);
                // }
     
         }
     /*     List<aa_Country__c> countryclusterlist=[select Cluster_Id__c from aa_Country__c where Id IN:countryList.keySet()];
              for(aa_Country__c countryobj :countryclusterlist)
               {
                   for ( String objreport : countryList.keySet() ){
                     aa_Agent_Report__c report = (aa_Agent_Report__c)countryList.get(countryobj.Id);
                     AA_theAgent_ChatterPost_FutureClass.sendToChatter(countryobj.Cluster_Id__c, report.CreatedById, report.Report_Title__c, report.id,report.Country__c);
                   }
               }  
               */      
    }
    
    public static void sendToChatter(Id objectId, ID userToMentionId, String postText, Id reportId,string Country) {    
        
        String reportCreatorName = [SELECT Name FROM User where Id=:userToMentionId].Name;
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        feedItemInput.body = new ConnectApi.MessageBodyInput();
        system.debug('In sent to chatter'+objectId);
        
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
    
     
}