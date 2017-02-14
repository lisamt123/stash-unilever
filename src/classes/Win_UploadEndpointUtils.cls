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
public with sharing virtual class Win_UploadEndpointUtils {

	@TestVisible public static String TEST_DEVICE = 'testdevice';
    @TestVisible public static String TQ_ONE = 'TquilaONE';
    @TestVisible public static String ACCOUNT = 'Account';

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


    /**
     * Process deleted items
     */
    public static void processItemsDeletion(List<sObject> objectReadyToRemove, List<Integer> objectRequestIndexesToRemove, 
    		List<Win_UploadResponse.Win_UploadResponseItem> responseItemsList, Map<String, Integer> numberOfProcessedOperationsPerRecord,
    		Set<String> failedRecordIdSet) {
        if (objectReadyToRemove.size() > 0){
            Database.DeleteResult[] deleteOperationResults = Database.delete(objectReadyToRemove, false);
            
            for (Integer index = 0; index < objectReadyToRemove.size(); index++){
                Integer requestIndex = objectRequestIndexesToRemove.get(index);
                Win_UploadResponse.Win_UploadResponseItem responseItem = responseItemsList.get(requestIndex);
                Database.DeleteResult deleteResult = deleteOperationResults.get(index);
                processItemDeleteResult(responseItem, deleteResult, numberOfProcessedOperationsPerRecord, failedRecordIdSet);
            }
        }       
    }

    /**
     * Process deleted results
     */
    private static void processItemDeleteResult(Win_UploadResponse.Win_UploadResponseItem responseItem, Database.DeleteResult deleteResult,
    		Map<String, Integer> numberOfProcessedOperationsPerRecord, Set<String> failedRecordIdSet){
        String requestId = responseItem.requestId;
        responseItem.success = deleteResult.isSuccess();
        if (deleteResult.isSuccess()){
            responseItem.executed = true;
            responseItem.responseId = null;
            responseItem.record = null;
            
            Integer newProcessedCount = numberOfProcessedOperationsPerRecord.get(requestId) + 1;
            numberOfProcessedOperationsPerRecord.put(requestId, newProcessedCount);
        }
        else {
            failedRecordIdSet.add(requestId);
        }
        
        if (deleteResult.getErrors() != null) {
            for (Database.Error error : deleteResult.getErrors()) {
                responseItem.errorList.add(error.getMessage());         
            }
        }
    }

   // /**
   //  * Process inserted items
   //  */
   // public static void processItemsInserting(List<sObject> objectReadyToInsert, List<Integer> objectRequestIndexesToInsert, 
   //       String deviceId, List<Win_Local_Assignment__c> newAssignments, List<Win_UploadResponse.Win_UploadResponseItem> responseItemsList,
   //       Map<String, String> assignedIdsMap, Map<String, Integer> numberOfProcessedOperationsPerRecord, Set<String> failedRecordIdSet,
   //       Map<String, Integer> numberOfOperationsPerRecord, Win_IUploadService service) {
   //     if (objectReadyToInsert.size() > 0){
   //         Database.SaveResult[] insertOperationResults = Database.insert(objectReadyToInsert, false);
            
   //         for (Integer index = 0; index < objectReadyToInsert.size(); index++){
   //             Integer requestIndex = objectRequestIndexesToInsert.get(index);
   //             Win_UploadResponse.Win_UploadResponseItem responseItem = responseItemsList.get(requestIndex);
   //             Database.SaveResult insertResult = insertOperationResults.get(index);
   //             processItemInsertResult(responseItem, insertResult, deviceId, newAssignments, assignedIdsMap, 
   //             	numberOfProcessedOperationsPerRecord, failedRecordIdSet, numberOfOperationsPerRecord, service);
   //         }
   //     }       
   // }

   // /**
   //  * Process insertion results
   //  */
   // private static void processItemInsertResult(Win_UploadResponse.Win_UploadResponseItem responseItem, Database.SaveResult insertResult,
			//String deviceId, List<Win_Local_Assignment__c> newAssignments, Map<String, String> assignedIdsMap, 
			//Map<String, Integer> numberOfProcessedOperationsPerRecord, Set<String> failedRecordIdSet, Map<String, Integer> numberOfOperationsPerRecord,
			//Win_IUploadService service) {
   //     String requestId = responseItem.requestId;
   //     saveResultToResponse(insertResult, responseItem);
   //     if (responseItem.success){
   //         assignedIdsMap.put(responseItem.requestId, responseItem.responseId);
                                
   //         Integer newProcessedCount = numberOfProcessedOperationsPerRecord.get(requestId) + 1;
   //         numberOfProcessedOperationsPerRecord.put(requestId, newProcessedCount);
            
   //         if (newProcessedCount == numberOfOperationsPerRecord.get(requestId)){
   //             Schema.Describesobjectresult objectDescribe = Win_TrackingUtils.getObjectDescribe(responseItem.objectApiName);
   //             if (objectDescribe != null && objectDescribe.isQueryable()){
   //                 sObject resultSObject = service.getResultSObject(responseItem.objectApiName, responseItem.responseId);
   //                 if (resultSObject != null) {
   //                     responseItem.record = resultSObject;
   //                 }
   //                 else {
   //                     //In case when new record doesn't apply for the download criteria, it should be removed locally
   //                     responseItem.operation = Win_UploadResponse.OperationDelete;
   //                 }
   //             }
   //         }
            
   //         saveAssignment(responseItem.requestId, responseItem.responseId, deviceId, newAssignments);
   //     } else {
   //         responseItem.record.put('Id', responseItem.requestId);
   //         failedRecordIdSet.add(requestId);
   //     }       
   // }

   /**
     * bind errors
     */
    public static void setRelationErrors(List<Win_UploadRequestItem> requestItemsList, 
    		List<Win_UploadResponse.Win_UploadResponseItem> responseItemsList, List<Integer> recordOperationIndexList,
    		Set<String> failedRecordIdSet, Win_IUploadService service, Map<String, Integer> numberOfProcessedOperationsPerRecord){
        //Go through the all request Items, which were not assigned yet
        for (Integer index = 0; index < requestItemsList.size(); index++) {
            //Win_UploadRequestItem requestItem = requestItemsList.get(index);
            Win_UploadResponse.Win_UploadResponseItem responseItem = responseItemsList.get(index);
            String requestId = responseItem.requestId;
            Integer recordIndex = recordOperationIndexList.get(index);
            
            if (!responseItem.executed && !failedRecordIdSet.contains(requestId) && 
                recordIndex == numberOfProcessedOperationsPerRecord.get(requestId)) {
                failedRecordIdSet.add(requestId);
                SObject recordSObject = responseItem.record;
                
                responseItem.success = false;
                responseItem.executed = false;
                responseItem.responseId = requestId;
                responseItem.operation = Win_UploadResponse.OperationUpsert;
                Map<String, String> unresolvedFieldsMap = service.getUnresolvedRelatedFields(recordSObject);
                for (String fieldName : unresolvedFieldsMap.keySet()){
                    String fieldLabel = unresolvedFieldsMap.get(fieldName);
                    String relatedId = (String)recordSObject.get(fieldName);
                    String errorMessage;
                    if (failedRecordIdSet.contains(relatedId)) {
                        errorMessage = 'Related record for field ' + fieldLabel + ' has been failed';
                    } else {
                        errorMessage = 'Related record for field ' + fieldLabel + ' hasn\'t been founded';
                    }
                    responseItem.errorList.add(errorMessage);
                }
            } else if (responseItem.operation == null){
                responseItem.operation = Win_UploadResponse.OperationUpsert;
            }
        }       
    } 

}