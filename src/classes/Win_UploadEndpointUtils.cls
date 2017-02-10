/*************************************************************** 
    Name: Win_UploadEndpointUtils
    Copyright © 2016 Accenture
    ======================================================
    Purpose:
    -------
    Endpoint used by the mobile app can to upload Chatter post / comments / likes
    ======================================================
    History
    -------
    VERSION     AUTHOR          DATE        DETAIL          Description
    1.0         Nicola Tassini  22/12/2016  Initial Dev     First version
***************************************************************/
public with sharing class Win_UploadEndpointUtils {

	/**
     * Post a feed with an image associated
     */
    public static ConnectApi.FeedElement post(FeedItem myFeedItem, Map<String, Object> additionalDataMap) {
        // Form a basic post attached to our own feed.
        ConnectApi.FeedItemInput chatterFeedItem = new ConnectApi.FeedItemInput();
        chatterFeedItem.subjectId = myFeedItem.ParentId;
        
        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = myFeedItem.Body;
        messageInput.messageSegments.add(textSegment);
        chatterFeedItem.body = messageInput;
        
        System.debug('CHATTER_POSTING ' + additionalDataMap);
        
        if(additionalDataMap.containsKey('ChatterPostContentDataBlob') 
                && additionalDataMap.get('ChatterPostContentDataBlob') != null) {
            ContentVersion version = new ContentVersion();
            version.Title = (String) additionalDataMap.get('ChatterPostContentFileName');
            version.PathOnClient = (String) additionalDataMap.get('ChatterPostContentFileName');
            version.VersionData = (Blob) additionalDataMap.get('ChatterPostContentDataBlob');

            // Now connect the feeditem to our already uploaded file.
            chatterFeedItem.capabilities = new ConnectAPI.FeedElementCapabilitiesInput();
            chatterFeedItem.capabilities.files = new ConnectAPI.FilesCapabilityInput();
            chatterFeedItem.capabilities.files.items = new List<ConnectAPI.FileIdInput>();
            ConnectAPI.FileIdInput attachFile = new ConnectAPI.FileIDInput();
            insert version;
            
            // After you insert the ContentVersion object, a base 'ContentDocument' is established
            // The ID of the ContentDocument is what you need to attach the file to the Chatter post.
            version = [SELECT ID,ContentDocumentId FROM ContentVersion WHERE ID = :version.id];

            //**** Here is where we attach the specific file to the post!
            attachFile.id = version.contentDocumentid; 
            chatterFeedItem.capabilities.files.items.add(attachFile);
        }

        // Execute the posting
        return Test.isRunningTest() ? null : ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), chatterFeedItem);
    }

    /**
     * Return the map of the assignments 
     */
    public static Map<String, String> getAssignmentsMap(){
        List<Win_Local_Assignment__c> assignments = [SELECT Local_Id__c, Salesforce_Id__c FROM Win_Local_Assignment__c
                                                    WHERE CreatedById = :UserInfo.getUserId()];
                                                    
        Map<String, String> assignmentsMap = new Map<String, String>();
        for (Win_Local_Assignment__c assignement : assignments){
            assignmentsMap.put(assignement.Local_Id__c, assignement.Salesforce_Id__c);
        }
        return assignmentsMap;
    }

    /**
     * Save an assignment
     */
    public static void saveAssignment(String localId, String salesforceId, String deviceId, List<Win_Local_Assignment__c> assignments){
        if (salesforceId != null && localId != salesforceId){
            Win_Local_Assignment__c assignment = new Win_Local_Assignment__c(
                Local_Id__c = localId, Salesforce_Id__c = salesforceId, Device_Id__c = deviceId
            );
            
            assignments.add(assignment);
        }
    }
    
    /**
     * Save upsert result to the upload response
     */
    public static void saveResultToResponse(Database.SaveResult saveResult, Win_UploadResponse.Win_UploadResponseItem responseItem){
        responseItem.success = saveResult.isSuccess();
        responseItem.executed = true;       
        //We should retrieve a new object only if UpsertResult is successful
        if (responseItem.success) {
            responseItem.responseId = saveResult.getId();
        } else {
            responseItem.responseId = responseItem.requestId;
        }
            
        if (saveResult.getErrors() != null) {
            for (Database.Error error : saveResult.getErrors()) {
                responseItem.errorList.add(error.getMessage());
            }
        }
    }

}