/*************************************************************** 
    Name: Win_UploadEndpoint
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
@RestResource(urlMapping='/tqupload/*')
global with sharing class Win_UploadEndpoint {
    //To do implement one by one execution if total number of items less then described
    @TestVisible static Integer EXECUTE_DML_BY_RECORD_LIMIT = 1;
    
    static List<Win_UploadRequestItem> requestItemsList;
    static List<Win_UploadResponse.Win_UploadResponseItem> responseItemsList;
    
    static List<Integer> recordOperationIndexList;
    static List<Map<String, Object>> recordAdditonalDataList;
    static Map<String, Integer> numberOfOperationsPerRecord;
    static Map<String, Integer> numberOfProcessedOperationsPerRecord;
    //Map which contains which SalesforceId were set for the object with Local Id
    static Map<String, String> assignedIdsMap;  
    static Win_IUploadService service;
    //Set of Ids which hasn't failed during the DML operation
    static Set<String> failedRecordIdSet;
    static Boolean useDmlBatches;
    
    /**
     * Do the upload data functionality to prepare data for execution
     */
    @HttpPost
    webservice static Win_UploadResponse uploadRequest(String clientAppID, List<Win_UploadRequestItem> recordList, String deviceId) {
        service = new Win_UploadService(clientAppID);
        
        Win_UploadResponse response = new Win_UploadResponse();
        try {
            initVariables(recordList);
            
            Boolean cycleShouldContinue = true;
            while (cycleShouldContinue){
                cycleShouldContinue = processRequestCycle(true, deviceId);
            }
            
            setRelationErrors();
            
            response.body = responseItemsList;
            
            response.setStatus(0);
            response.setError(null);
        } catch (Exception e){
            response.setError(e.getMessage());
            response.setStatus(e.getLineNumber());
        }
                
        return response;
    }
    
    /**
     * Process one cycle iteration
     */
    private static Boolean processRequestCycle(Boolean reassignmentNeeded, String deviceId) {
    
        Boolean itemsToProcessFouneded = false;
        //Set<String> itemIdsGoingToProcess = new Set<String>();

        List<Integer> objectRequestIndexesToRemove = new List<Integer>();
        List<sObject> objectReadyToRemove = new List<sObject>();
        
        List<Integer> objectRequestIndexesToUpdate = new List<Integer>();
        List<sObject> objectReadyToUpdate = new List<sObject>();
        
        List<Integer> objectRequestIndexesToInsert = new List<Integer>();
        List<sObject> objectReadyToInsert = new List<sObject>();    
        
        List<Win_Local_Assignment__c> newAssignments = new List<Win_Local_Assignment__c>();   
        
        //Go through the all request Items, which were not assigned yet
        for (Integer index = 0; index < requestItemsList.size(); index++) {
            //Win_UploadRequestItem requestItem = requestItemsList.get(index);
            Win_UploadResponse.Win_UploadResponseItem responseItem = responseItemsList.get(index);
            Integer recordOperationIndex = recordOperationIndexList.get(index);         
            SObject recordSObject = responseItem.record;
            String requestId  = responseItem.requestId;
            String originalRequestId = requestId;
            Map<String, Object> additionalDataMap = recordAdditonalDataList.get(index);
            
            if (Boolean.valueOf(responseItem.executed) || failedRecordIdSet.contains(requestId)
                || recordOperationIndex != numberOfProcessedOperationsPerRecord.get(requestId)){
                continue;
            }
            
            if (assignedIdsMap.containsKey(requestId)){
                requestId = assignedIdsMap.get(requestId);
                recordSObject.put('Id', requestId);
            }
            
            String operation = service.getOperationType(recordSObject);
            
            //Process DELETE operation
            if (operation == 'DELETE') {
                manageDeleteOperation(requestId, responseItem, objectRequestIndexesToRemove, objectReadyToRemove, 
                    index, recordSObject, originalRequestId, itemsToProcessFouneded);
            } else {
                //Process Upsert operation
                if (reassignmentNeeded) {
                    //Try to replace all references to object with Local Ids to Salesforce Ids
                    Boolean assignmentComplete = service.reassignLocalReferences(recordSObject, assignedIdsMap);
                        
                    if (!assignmentComplete) {
                        continue;
                    }
                }
                
                responseItem.operation = Win_UploadResponse.OperationUpsert;
                try {
                    Boolean isInsert = (operation == Win_UploadService.INSERT_OPERATION);
                    
                    //sObject should be cloned to remove all the readOnly instances
                    sObject recordSObjectToUpsert = recordSObject.clone(true, false, false, false);
                    //If we are inserting object, then remove localId from sObject
                    if (isInsert)
                        recordSObjectToUpsert.put('Id', null);
                        
                    Database.SaveResult saveResult = null;
                    System.debug('using this ' + saveResult);
                        
                    if (isInsert) {
                        insertRecordItem(recordSObjectToUpsert, additionalDataMap, responseItem, 
                                requestId, deviceId, saveResult, newAssignments, originalRequestId,
                                objectReadyToInsert, objectRequestIndexesToInsert, index);
                    }
                    else {
                        if (useDmlBatches){
                            objectRequestIndexesToUpdate.add(index);
                            objectReadyToUpdate.add(recordSObjectToUpsert); 
                        }
                        else {
                            Database.SaveResult updateResult = null;
                            if (service.shouldForceSharingInDml(recordSObjectToUpsert,Win_UploadService.UPDATE_OPERATION)) {
                                updateResult = service.updateForceSharing(recordSObjectToUpsert);
                            //TMP Fix to DML inside loop
                            //} else {
                            //    updateResult = Database.update(recordSObjectToUpsert, false); //DML inside loop
                            }
                            responseItem.requestId = originalRequestId;
                            processItemUpdateResult(responseItem, updateResult);  
                            saveResult = updateResult;                          
                        }                   
                    }

                    System.debug('using this ' + saveResult);
                    //TMP Fix No Attachments
                    //// If the record contains a file attached to it, create & link an Attachment
                    //if(saveResult != null && saveResult.isSuccess() && additionalDataMap.containsKey('TQ_Attachment_FileName__c')
                    //        && additionalDataMap.containsKey('AttachmentData')) {
                    //    Attachment attachment = new Attachment();
                    //    attachment.Body = (Blob)additionalDataMap.get('AttachmentData');
                    //    attachment.Name = String.valueOf(additionalDataMap.get('TQ_Attachment_FileName__c'));
                    //    attachment.ParentId = responseItem.responseId;
                    //    insert attachment; //DML inside loop

                    //    responseItem.record.put('TQ_Attachment_Link__c', '/services/data/v30.0/sobjects/Attachment/' + attachment.Id + '/Body');
                    //    update responseItem.record; //DML inside loop
                    //}
                }
                catch (Exception e){
                    responseItem.success = false;
                    responseItem.executed = true;
                    responseItem.errorList.add(e.getMessage());
                    failedRecordIdSet.add(originalRequestId);
                }
                finally {
                    itemsToProcessFouneded = true;
                    responseItem.requestId = originalRequestId;
                }
            }
        }    
        
        // finish up
        wrapUpOperations(objectReadyToRemove, objectRequestIndexesToRemove, objectReadyToInsert, 
            objectRequestIndexesToInsert, objectReadyToUpdate, objectRequestIndexesToUpdate, deviceId, newAssignments);

        return itemsToProcessFouneded;          
    }

    private static void insertRecordItem(sObject recordSObjectToUpsert, Map<String, Object> additionalDataMap,
            Win_UploadResponse.Win_UploadResponseItem responseItem, String requestId, String deviceId, 
            Database.SaveResult saveResult, List<Win_Local_Assignment__c> newAssignments, String originalRequestId,
            List<sObject> objectReadyToInsert, List<Integer> objectRequestIndexesToInsert, Integer index) {
        if(recordSObjectToUpsert instanceof FeedItem) {
            ConnectApi.FeedElement feedElement = Win_UploadEndpointUtils.post((FeedItem) recordSObjectToUpsert, additionalDataMap);
            responseItem.success = true;
            responseItem.executed = true; 
            responseItem.responseId = feedElement.id;
            
            assignedIdsMap.put(responseItem.requestId, responseItem.responseId);
                                
            Integer newProcessedCount = numberOfProcessedOperationsPerRecord.get(requestId) + 1;
            numberOfProcessedOperationsPerRecord.put(requestId, newProcessedCount);
            
            if (newProcessedCount == numberOfOperationsPerRecord.get(requestId)){
                Schema.Describesobjectresult objectDescribe = Win_TrackingUtils.getObjectDescribe(responseItem.objectApiName);
                if (objectDescribe != null && objectDescribe.isQueryable()){
                    sObject resultSObject = service.getResultSObject(responseItem.objectApiName, responseItem.responseId);
                    if (resultSObject != null) {
                        responseItem.record = resultSObject;
                    } else {
                        //In case when new record doesn't apply for the download criteria, it should be removed locally
                        responseItem.operation = Win_UploadResponse.OperationDelete;
                    }
                }
            }
            
            Win_UploadEndpointUtils.saveAssignment(responseItem.requestId, responseItem.responseId, deviceId, newAssignments);
        } else {
            //Database.SaveResult insertResult = null;
            //if (service.shouldForceSharingInDml(recordSObjectToUpsert,Win_UploadService.INSERT_OPERATION)) {
            //    insertResult = service.insertForceSharing(recordSObjectToUpsert);
            //} 
            ////TMP Fix to DML inside loop
            ////else {
            ////    insertResult = Database.insert(recordSObjectToUpsert, false); //DML inside loop
            ////}
            //responseItem.requestId = originalRequestId;
            //processItemInsertResult(responseItem, insertResult, deviceId, newAssignments);
            //saveResult = insertResult;
            objectRequestIndexesToInsert.add(index);
            objectReadyToInsert.add(recordSObjectToUpsert);
        }
    }

    private static void manageDeleteOperation(String requestId, Win_UploadResponse.Win_UploadResponseItem responseItem,
        List<Integer> objectRequestIndexesToRemove, List<sObject> objectReadyToRemove, Integer index, sObject recordSObject,
        String originalRequestId, Boolean itemsToProcessFouneded) {
        try {
            if (service.isLocalId(requestId)) {
                responseItem.success = true;
                responseItem.executed = true; 
                //continue;
            }
            
            if (useDmlBatches) {
                objectRequestIndexesToRemove.add(index);
                objectReadyToRemove.add(recordSObject);
            }
            //TMP Fix to DML inside loop
            //else {
            //    Database.DeleteResult deleteResult = Database.delete(recordSObject, false); //DML inside loop
            //    responseItem.requestId = originalRequestId;
            //    processItemDeleteResult(responseItem, deleteResult);
            //}

        } catch (Exception e){
            responseItem.success = false;
            responseItem.executed = true;
            responseItem.errorList.add(e.getMessage());
            failedRecordIdSet.add(originalRequestId);
        } finally{
            itemsToProcessFouneded = true;
            
            responseItem.requestId = originalRequestId;
            responseItem.responseId = null;
            responseItem.operation = Win_UploadResponse.OperationDelete;
        }
    }

    /**
     *  Finish the required operations
     */
    private static void wrapUpOperations(List<sObject> objectReadyToRemove, List<Integer> objectRequestIndexesToRemove, 
            List<sObject> objectReadyToInsert, List<Integer> objectRequestIndexesToInsert, 
            List<sObject> objectReadyToUpdate, List<Integer> objectRequestIndexesToUpdate, 
            String deviceId, List<Win_Local_Assignment__c> newAssignments) {
        processItemsDeletion(objectReadyToRemove, objectRequestIndexesToRemove);
        
        processItemsInserting(objectReadyToInsert, objectRequestIndexesToInsert, deviceId, newAssignments);
                
        processItemsUpdating(objectReadyToUpdate, objectRequestIndexesToUpdate);
        
        if (newAssignments.size() > 0) {
            Database.insert(newAssignments, false);
        }
    }

    /**
     * Process deleted results
     */
    private static void processItemDeleteResult(Win_UploadResponse.Win_UploadResponseItem responseItem, Database.DeleteResult deleteResult){
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
    
    /**
     * Process insertion results
     */
    private static void processItemInsertResult(Win_UploadResponse.Win_UploadResponseItem responseItem, Database.SaveResult insertResult,
                                                String deviceId, List<Win_Local_Assignment__c> newAssignments){
        String requestId = responseItem.requestId;
        Win_UploadEndpointUtils.saveResultToResponse(insertResult, responseItem);
        if (responseItem.success){
            assignedIdsMap.put(responseItem.requestId, responseItem.responseId);
                                
            Integer newProcessedCount = numberOfProcessedOperationsPerRecord.get(requestId) + 1;
            numberOfProcessedOperationsPerRecord.put(requestId, newProcessedCount);
            
            if (newProcessedCount == numberOfOperationsPerRecord.get(requestId)){
                Schema.Describesobjectresult objectDescribe = Win_TrackingUtils.getObjectDescribe(responseItem.objectApiName);
                if (objectDescribe != null && objectDescribe.isQueryable()){
                    sObject resultSObject = service.getResultSObject(responseItem.objectApiName, responseItem.responseId);
                    if (resultSObject != null) {
                        responseItem.record = resultSObject;
                    }
                    else {
                        //In case when new record doesn't apply for the download criteria, it should be removed locally
                        responseItem.operation = Win_UploadResponse.OperationDelete;
                    }
                }
            }
            
            Win_UploadEndpointUtils.saveAssignment(responseItem.requestId, responseItem.responseId, deviceId, newAssignments);
        }
        else {
            responseItem.record.put('Id', responseItem.requestId);
            failedRecordIdSet.add(requestId);
        }       
    }
    
    /**
     * Process updated results
     */
    private static void processItemUpdateResult(Win_UploadResponse.Win_UploadResponseItem responseItem, Database.SaveResult updateResult){
        String requestId = responseItem.requestId;
        Win_UploadEndpointUtils.saveResultToResponse(updateResult, responseItem);
        if (responseItem.success){
            assignedIdsMap.put(responseItem.requestId, responseItem.responseId);
            
            Integer newProcessedCount = numberOfProcessedOperationsPerRecord.get(requestId) + 1;
            numberOfProcessedOperationsPerRecord.put(requestId, newProcessedCount);
            
            if (newProcessedCount == numberOfOperationsPerRecord.get(requestId)){
                sObject resultSObject = service.getResultSObject(responseItem.objectApiName, responseItem.responseId);
                if (resultSObject != null) {
                    responseItem.record = resultSObject;
                }
                else {
                    //In case when new record doesn't apply for the download criteria, it should be removed locally
                    responseItem.operation = Win_UploadResponse.OperationDelete;
                }
            }
        }
        else {
            failedRecordIdSet.add(requestId);
        }
    }
    
    /**
     * Process deleted items
     */    
    private static void processItemsDeletion(List<sObject> objectReadyToRemove, List<Integer> objectRequestIndexesToRemove){
        if (objectReadyToRemove.size() > 0){
            Database.DeleteResult[] deleteOperationResults = Database.delete(objectReadyToRemove, false);
            
            for (Integer index = 0; index < objectReadyToRemove.size(); index++){
                Integer requestIndex = objectRequestIndexesToRemove.get(index);
                Win_UploadResponse.Win_UploadResponseItem responseItem = responseItemsList.get(requestIndex);
                Database.DeleteResult deleteResult = deleteOperationResults.get(index);
                processItemDeleteResult(responseItem, deleteResult);
            }
        }       
    }
    
    /**
     * Process inserted items
     */
    private static void processItemsInserting(List<sObject> objectReadyToInsert, List<Integer> objectRequestIndexesToInsert, 
                                              String deviceId, List<Win_Local_Assignment__c> newAssignments){
        if (objectReadyToInsert.size() > 0){
            Database.SaveResult[] insertOperationResults = Database.insert(objectReadyToInsert, false);
            
            for (Integer index = 0; index < objectReadyToInsert.size(); index++){
                Integer requestIndex = objectRequestIndexesToInsert.get(index);
                Win_UploadResponse.Win_UploadResponseItem responseItem = responseItemsList.get(requestIndex);
                Database.SaveResult insertResult = insertOperationResults.get(index);
                processItemInsertResult(responseItem, insertResult, deviceId, newAssignments);
            }
        }       
    }
    
    /**
     * Process updated items
     */
    private static void processItemsUpdating(List<sObject> objectReadyToUpdate, List<Integer> objectRequestIndexesToUpdate){
        if (objectReadyToUpdate.size() > 0){
            Database.SaveResult[] updateOperationResults = Database.update(objectReadyToUpdate, false);
            
            for (Integer index = 0; index < objectReadyToUpdate.size(); index++){
                Integer requestIndex = objectRequestIndexesToUpdate.get(index);
                Win_UploadResponse.Win_UploadResponseItem responseItem = responseItemsList.get(requestIndex);
                Database.SaveResult updateResult = updateOperationResults.get(index);
                processItemUpdateResult(responseItem, updateResult);
            }
        }  
    }
    
    /**
     * bind errors
     */
    private static void setRelationErrors(){
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
    
    /**
     * Initialize all processing variables plus predefine response data
     */
    private static void initVariables(List<Win_UploadRequestItem> recordList){
        useDmlBatches = (recordList.size() > EXECUTE_DML_BY_RECORD_LIMIT);
        requestItemsList = recordList;
        responseItemsList = new List<Win_UploadResponse.Win_UploadResponseItem>();
        recordOperationIndexList = new List<Integer>();     
        numberOfOperationsPerRecord = new Map<String, Integer>();
        numberOfProcessedOperationsPerRecord = new Map<String, Integer>();  
        recordAdditonalDataList = new List<Map<String, Object>>();
            
        assignedIdsMap = Win_UploadEndpointUtils.getAssignmentsMap();
        failedRecordIdSet = new Set<String>();
        
        for (Integer index = 0; index < recordList.size(); index++){
            Win_UploadRequestItem requestItem = recordList.get(index);
            String requestId = requestItem.Id;
            Win_UploadResponse.Win_UploadResponseItem responseItem;
            responseItem = new Win_UploadResponse.Win_UploadResponseItem(requestItem.objectApiName, requestId);
            Boolean sObjectConversionSuccess;
            sObject recordObject = null;
            Map<String,Object> additionalData = new Map<String, Object>();
            
            try {
                // Try convert JSON string of record to SObject
                recordObject = service.deserializeSObject(requestItem, additionalData);
                sObjectConversionSuccess = true;
            } catch(Exception e) {
                sObjectConversionSuccess = false;
                responseItem.errorList.add('Wrong data of ' + requestItem.objectApiName +' : ' + e.getMessage());
                failedRecordIdSet.add(requestId);
            } finally {
                responseItem.record = recordObject;
                responseItem.success = false;
                responseItem.executed = false;
                responseItem.changeDate = requestItem.changeDate;
            }
            responseItemsList.add(responseItem);
            recordAdditonalDataList.add(additionalData);
            System.debug('Win_UploadEndpoint: sObjectConversionSuccess is ' + sObjectConversionSuccess);
            
            Integer operationsNumber = numberOfOperationsPerRecord.get(requestId);
            if (operationsNumber == null){
                recordOperationIndexList.add(0);
                numberOfProcessedOperationsPerRecord.put(requestId, 0);
                numberOfOperationsPerRecord.put(requestId, 1);
            } else {
                recordOperationIndexList.add(operationsNumber);
                numberOfOperationsPerRecord.put(requestId, operationsNumber + 1);
            }
        }   
    }   
}