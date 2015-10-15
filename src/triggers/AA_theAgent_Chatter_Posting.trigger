trigger AA_theAgent_Chatter_Posting on aa_Agent_Report__c (before update) {
//trigger AA_theAgent_Chatter_Posting on aa_Agent_Report__c (after update) {
public static String STATUS_VALUE_TO_POST_ON = 'Published (Public)';


for(aa_Agent_Report__c report:Trigger.new){

        if(report.Status__c != Trigger.oldMap.get(report.Id).Status__c) {
            if(AA_TheAgentSingleExecution.hasAlreadyDone()) {
                return;
            }
            else {
                AA_TheAgentSingleExecution.setAlreadyDone();
                //go
                if (report.Status__c == STATUS_VALUE_TO_POST_ON) {
                    system.debug('&&& Entry');
                    system.debug('&&&&& Topic'+report.Topic__c);
                    // brand
                    if (report.Competitor_Brand__c != NULL) {
                        //sendToChatter(report.Competitor_Brand__c, report.CreatedById, report.Name, report);
                        AA_theAgent_ChatterPost_FutureClass.sendToChatter(report.Competitor_Brand__c, report.CreatedById, report.Report_Title__c, report.id,report.Country__c);
                    }

                    //competitor
                    if (report.Competitor_Name__c != NULL) {
                        //sendToChatter(report.Competitor_Name__c, report.CreatedById, report.Name, report);  
                        AA_theAgent_ChatterPost_FutureClass.sendToChatter(report.Competitor_Name__c, report.CreatedById, report.Report_Title__c, report.id,report.Country__c);                    
                    }
                    
                    //retailer   
                    if (report.Retailer__c != NULL) {
                        //sendToChatter(report.Retailer__c, report.CreatedById, report.Name, report);
                        AA_theAgent_ChatterPost_FutureClass.sendToChatter(report.Retailer__c, report.CreatedById, report.Report_Title__c, report.id,report.Country__c);                     
                    }
                    
                    //country
                    if (report.Country__c != NULL) {
                        //sendToChatter(report.Country__c, report.CreatedById, report.Name, report);
                        AA_theAgent_ChatterPost_FutureClass.sendToChatter(report.Country__c, report.CreatedById, report.Report_Title__c, report.id,report.Country__c);                     
                    }
                    
                    //Unilever_Brand__c
                    if (report.Agent_App_Unilever_Brand__c != NULL) {
                        //sendToChatter(report.Agent_App_Unilever_Brand__c, report.CreatedById, report.Name, report);
                        AA_theAgent_ChatterPost_FutureClass.sendToChatter(report.Agent_App_Unilever_Brand__c, report.CreatedById, report.Report_Title__c, report.id,report.Country__c);                     
                    }
                    
                    //Category
                    if (report.Category__c != NULL) {
                        //sendToChatter(report.Agent_App_Unilever_Brand__c, report.CreatedById, report.Name, report);
                        AA_theAgent_ChatterPost_FutureClass.sendToChatter(report.Category__c, report.CreatedById, report.Report_Title__c, report.id,report.Country__c);                     
                    }
                    
                    //Topic
                    if (report.Topic__c != NULL) {
                        //sendToChatter(report.Agent_App_Unilever_Brand__c, report.CreatedById, report.Name, report);
                        AA_theAgent_ChatterPost_FutureClass.sendToChatter(report.Topic__c, report.CreatedById, report.Report_Title__c, report.id,report.Country__c);                     
                    }
                    
                    //Cluster   
                    if(report.Country__c!=NULL)
                    {        
                    aa_Country__c cc=[select Cluster_Id__c from aa_Country__c where Id=:report.Country__c];
                    Id clusterId=cc.Cluster_Id__c;
                    system.debug('cluster id=====>'+clusterId);
                    //sendToChatter(report.Agent_App_Unilever_Brand__c, report.CreatedById, report.Name, report);
                    AA_theAgent_ChatterPost_FutureClass.sendToChatter(clusterId, report.CreatedById, report.Report_Title__c, report.id,report.Country__c);                     
                    }
                    //User Name
                    String CaretedbyName=userInfo.getUserName();
                    if (CaretedbyName != NULL) {
                        //sendToChatter(report.Agent_App_Unilever_Brand__c, report.CreatedById, report.Name, report);
                        AA_theAgent_ChatterPost_FutureClass.sendToChatter(userInfo.getUserId(), report.CreatedById, report.Report_Title__c, report.id,report.Country__c);                     
                    }
                    
                }

            }
        }
        }
        /*
        public static void sendToChatter(Id objectId, ID userToMentionId, String postText, aa_Agent_Report__c report) {    
         
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        feedItemInput.body = new ConnectApi.MessageBodyInput();
        
        feedItemInput.body.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        //intro
        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = 'New Agent Report by ';
        feedItemInput.body.messageSegments.add(textSegment);

        // add the mention
        ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
        mentionSegment.id = userToMentionId;
        feedItemInput.body.messageSegments.add(mentionSegment);
    
        // add the text segment
        ConnectApi.TextSegmentInput textSegment2 = new ConnectApi.TextSegmentInput();
        textSegment2.text = ': ' + postText;
        feedItemInput.body.messageSegments.add(textSegment2);
        
        // add inline link
        ConnectApi.LinkSegmentInput report_link = new ConnectApi.LinkSegmentInput();
        String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + report.id;
        report_link.url = fullRecordURL;
        feedItemInput.body.messageSegments.add(report_link);
        
        //add post pic
        // Add existing content attachment
        AA_TheAgentReportWrapper report_wrapper = new AA_TheAgentReportWrapper(report);
        if (report_wrapper.first_chatter_pic_content_id(report) != null ) {
            ConnectApi.ContentAttachmentInput attachmentInput = new ConnectApi.ContentAttachmentInput();

            attachmentInput.contentDocumentId = report_wrapper.first_chatter_pic_content_id(report);
          //List<COntentDocumentLink> documentlist=[SELECT ContentDocument.id FROM ContentDocumentLink WHERE LinkedEntityId = :report.id LIMIT 1];
           // attachmentInput.contentDocumentId=documentlist[0].ContentDocument.id;
            system.debug('attachmentInput.contentDocumentId===='+attachmentInput.contentDocumentId);
            
            feedItemInput.attachment = attachmentInput;
        }
    
        // post it!
        ConnectApi.FeedItem new_chat = ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.Record, objectId, feedItemInput, null);
        
        // add country topic
        if (report.Country__c != null) {
            ConnectApi.Topics.assignTopicByName(null, new_chat.id, report.Country__c);
        }
            
    }*/
}