/*************************************************************** 
    Name: Win_UploadService
    Copyright © 2016 Accenture
    ======================================================
    Purpose:
    -------
    Upload service used for Chatter and other objects to sync up

    ======================================================
    History
    -------
    VERSION     AUTHOR          DATE        DETAIL          Description
    1.0         Nicola Tassini  20/12/2016  Initial Dev     Upload Service
***************************************************************/
public with sharing class Win_UploadService implements Win_IUploadService{
    public static final String LocalIdPreffix = 'Local_';
    public static final String DELETE_OPERATION = 'DELETE';
    public static final String INSERT_OPERATION = 'INSERT';
    public static final String UPDATE_OPERATION = 'UPDATE';
    private static final String DefaultAppId = 'Win_uilaONE';
    private Win_MetadataService metadataService;
//    private Win_DownloadService downloadService;
    
    public Map<String,List<String>> fieldListMap;
    public final String ClientAppId;
    
    private static final Set<String> fieldsToExclude = new Set<String>{'BillingAddress', 'BillingAddres', 'ShippingAddress'};

    
    public Win_UploadService(){
        this(DefaultAppId);
    } 
    
    public Win_UploadService(String clientAppId){
        this.ClientAppId = clientAppId;
        metadataService = new Win_MetadataService(ClientAppId);
        //downloadService = new Win_DownloadService(ClientAppId);
        fieldListMap = getObjectFieldListMap();
    } 
    
    //Initialize for each sObject type all the required fields, which should be returned in upload response
    public Map<String, List<String>> getObjectFieldListMap(){
        Map<String, List<String>> fieldListMap = new Map<String, List<String>>();
        
        Map<String, Win_Tracked_Object_Config__c> objectsSetting = Win_TrackingUtils.getObjects(ClientAppId);
        List<String> testingFields = new List<String>();
        testingFields.add('Address__c');
        Map<String, List<String>> testingMap = new Map<String, List<String>>();
        testingMap.put('firstFieldSet', testingFields);
        
        //Check on the argument
        for (String objectAPIName : objectsSetting.keySet()) {
            
                List<String> fieldsSet = new List<String>();
                Set<String> includedFields = new Set<String>();
                
                Map<String, List<String>> trackedObjectFieldSetsMap = Test.isRunningTest() 
                    ? testingMap
                    : metadataService.trackedObjectFieldSets(objectApiName);
                for(String trackedObjectFieldSetName : trackedObjectFieldSetsMap.keySet()) {
                    for(String trackedObjectField : trackedObjectFieldSetsMap.get(trackedObjectFieldSetName)) {
                        if (!includedFields.contains(trackedObjectField)) {
                            fieldsSet.add(trackedObjectField);
                            includedFields.add(trackedObjectField);
                        }
                    }
                }
                
                // Add all the fields if no field sets are specified in the custom setting
                // RawRecordFieldSet contains detailFieldSet + Required fields + relathionship fields + system fields
                fieldsSet = (fieldsSet == null || fieldsSet.size() == 0)
                    ? metadataService.getAllFieldSet(objectApiName)
                    : metadataService.getFullRecordFieldSet(objectApiName, fieldsSet);
                
               fieldListMap.put(objectApiName, fieldsSet); 
        }       
        return fieldListMap;        
    }
    
    //Make List of strings unique removing all the repetitive elements
    @TestVisible
    private List<String> getUniqueArray(List<String> stringList){
        List<String> resultList = new List<String>();
        Set<String> stringSet = new Set<String>();
        
        for (String val : stringList){
            //If element was not added to resulting array before
            if (!stringSet.contains(val)) {
                resultList.add(val);
                stringSet.add(val);
            }
        }
        
        return resultList;
    }
    
    //Recognize if sObject Id is local
    public Boolean isLocalId(String id){
        return id.startsWith(LocalIdPreffix);
    }
    
    //Recognize which DML operation should be done with object: insert, update or delete
    public String getOperationType(sObject record){
        String recordId = (String)record.get('Id');
        Schema.Describesobjectresult objDescribe = record.getSObjectType().getDescribe();
        
        if (objDescribe.isDeletable() && record.get('isDeleted') != null && Boolean.valueOf(record.get('isDeleted'))) {        
            return DELETE_OPERATION;
        } else if (isLocalId(recordId)){
            return INSERT_OPERATION;
        } else {
            return UPDATE_OPERATION;
        }
    }
    
    
    //Go through the all reference fields of sObject to replace all local Ids with all ids inserted before
    public Boolean reassignLocalReferences(sObject recordObject, Map<String, String> assignmentMap){
        Boolean assignmentComplete = true;
        String sObjectId = (String)recordObject.get('Id');
        recordObject.put('Id', null);
        Schema.DescribeSObjectResult objectDescribe = recordObject.getSObjectType().getDescribe();
        Map<String, Schema.SObjectField> fieldDescribeMap = objectDescribe.fields.getMap();
        //Type objectType = Type.forName(objectDescribe.getName());

        for (String fieldName : fieldDescribeMap.keySet()) {
            Schema.DescribeFieldResult fieldDescribe = fieldDescribeMap.get(fieldName).getDescribe();
            
            //Check if field is Lookup or Parent-Child field to replace it
            if (fieldName != 'Id' && fieldDescribe.getType() == Schema.Displaytype.Reference){
                Object fieldValue = recordObject.get(fieldName);
                if (fieldValue instanceof String) {
                    String stringValue = String.valueOf(fieldValue);
                    if (isLocalId(stringValue)){
                        if (assignmentMap.containsKey(stringValue)) {
                            // Replace local Id of Lookup with the actual one
                            String assignedId = assignmentMap.get(stringValue);
                            recordObject.put(fieldName, assignedId);
                        } 
                        else {
                            // sObject still does not contains assigned fields so should be processed later
                            assignmentComplete = false;
                        }
                    }
                }
            }
        }
        
        recordObject.put('Id', sObjectId);
        
        return assignmentComplete;
    }
    
    //Convert JSON string in request item to the sObject
    public sObject deserializeSObject(Win_UploadRequestItem requestItem, Map<String, Object> additionalData){
        Map<String, Object> dataMap = (Map<String, Object>)JSON.deserializeUntyped(requestItem.record);
        Map<String, Blob> blobDataMap = new Map<String, Blob>();
        System.debug('WIN-DEBUG: inside the deserializeSObject ' + dataMap);
        
        Map<String, Schema.DescribeFieldResult> fieldDescriptionMap = metadataService.getFieldDescriptionMap(requestItem.objectApiName);
        System.debug('WIN-DEBUG: inside the deserializeSObject fieldDescriptionMap ' + fieldDescriptionMap);
        
        if (fieldDescriptionMap != null){
            for (String key : dataMap.keySet()){
                System.debug('WIN-DEBUG: inside the deserializeSObject key ' + key);
            
                Schema.DescribeFieldResult fieldDescribe = fieldDescriptionMap.get(key);
                System.debug('WIN-DEBUG: inside the deserializeSObject fieldDescribe ' + fieldDescribe);
                
                Object fieldValue = dataMap.get(key);
                System.debug('WIN-DEBUG: inside the deserializeSObject fieldValue ' + fieldValue);

                if (key == 'Win_Attachment_Link__c' && fieldValue instanceof String) {
                    Blob dataBlob = null;

                    try {
                        dataBlob = EncodingUtil.base64Decode((String) fieldValue);
                        if (dataMap.containsKey('Win_Attachment_FileName__c')){
                            additionalData.put('Win_Attachment_FileName__c' , '' + 
                                               dataMap.get('Win_Attachment_FileName__c'));
                        } else {
                            additionalData.put('Win_Attachment_FileName__c' , 'MomentFile.jpg');
                        }
                        
                        additionalData.put('AttachmentData', dataBlob);
                        dataMap.remove(key);
                    } catch(Exception e) {
                        System.debug('WIN-DEBUG: inside the Win_Attachment_Link__c block exception ' + e);
                    }
                 } else if (key == 'ContentData' && fieldValue instanceof String) {
                    System.debug('WIN-DEBUG: inside the deserializeSObject ContentDATA BOOOM ');
                    prepareAdditionalData(additionalData, dataMap, key, fieldValue);
                } 
                
                
                if (fieldDescribe != null && fieldDescribe.getType() == Schema.Displaytype.base64 &&
                        fieldValue instanceof String) {
                    Blob DataBlob = EncodingUtil.base64Decode((String) fieldValue);
                    blobDataMap.put(key, DataBlob);
                    dataMap.remove(key);
                }
                
                if (fieldDescribe == null) {
                    dataMap.remove(key);
                }
            }
        }
        
        String cleanSObjectString = JSON.serialize(dataMap);
        
        Type objectType = Type.forName(requestItem.objectApiName);
        sObject resultObject = (sObject)JSON.deserializeStrict(cleanSObjectString, objectType);
        
        if (blobDataMap.size() > 0) {
            Object objectId = resultObject.get('Id');
            resultObject.put('Id', null);
            
            for (String key : blobDataMap.keySet()) {
                resultObject.put(key, blobDataMap.get(key));
            }
                
            if (objectId != null) {
                resultObject.put('Id', objectId);
            }
        }
                
        //sObject resultObject = (sObject)JSON.deserializeStrict(requestItem.record, objectType);
        
        return resultObject;
    }
    
    public Map<String, String> getUnresolvedRelatedFields(sObject recordObject){    
        Map<String, String> unresolvedFields = new Map<String, String>();
            
        Schema.DescribeSObjectResult objectDescribe = recordObject.getSObjectType().getDescribe();
        Map<String, Schema.SObjectField> fieldDescribeMap = objectDescribe.fields.getMap();
        //Type objectType = Type.forName(objectDescribe.getName());

        for (String fieldName : fieldDescribeMap.keySet()) {
            Schema.DescribeFieldResult fieldDescribe = fieldDescribeMap.get(fieldName).getDescribe();
            
            //Check if field is Lookup or Parent-Child field to replace it
            if (fieldName != 'Id' && fieldDescribe.getType() == Schema.Displaytype.Reference){
                Object fieldValue = recordObject.get(fieldName);
                if (fieldValue instanceof String) {
                    String stringValue = String.valueOf(fieldValue);
                    if (isLocalId(stringValue)){
                        unresolvedFields.put(fieldName, fieldDescribe.getLabel());
                    }
                }
            }
        }       
        
        return unresolvedFields;
    }
    
    //Fetch new sObject data after DML operation was finished successfully
    public sObject getResultSObject(String objectApiName, String objectId){
        List<String> fieldList = fieldListMap.get(objectApiName);
        if (fieldList == null || fieldList.size() == 0){
            fieldList = new List<String>{'Id'};
        }
        
        //Prepare list of select fields in query
        String fieldsString = '';
        for (String fieldName : fieldList){
            if (fieldsToExclude.contains(fieldName) || (objectApiName == 'Account' && fieldName.endsWith('Address'))) continue;
            if (fieldsString != '')
                fieldsString += ', ';
            fieldsString += fieldName;
        }
        
        // NT: DownloadService not installed
        //String whereClause = downloadService.calculateWhereClauseForObject(objectApiName, false);
        String whereClause = null;
        String query = 'SELECT ' + fieldsString + ' FROM ' + objectApiName + ' WHERE Id = \'' + objectId + '\'';
        if (whereClause != null)
            query += ' AND (' + whereClause + ')';
            
        List<sObject> resultObjects = Database.query(query);
        sObject resultObject = (resultObjects.size() > 0) ? resultObjects.get(0) : null;
        
        if (resultObject != null) {
            for (String fieldName : fieldList)
                try {
                    if (resultObject.get(fieldName) == null)
                        resultObject.put(fieldName, null);
                } catch (Exception e) {
                    System.debug('WIN-DEBUG: inside the getResultSObject field reading exception ' + e);
                }
        }
        return resultObject;
    }
    
    public Boolean shouldForceSharingInDml(sObject sObjectToCheck, String operation){       
        if ((sObjectToCheck instanceof Account || operation == Win_UploadService.UPDATE_OPERATION)) {
            User currentUser = [SELECT Id, Contact.AccountId FROM User WHERE Id = :UserInfo.getUserId()];
            if (currentUser.Contact == null) return false;
            if (sObjectToCheck instanceof Account)
                return ((Id)sObjectToCheck.get('Id')) == currentUser.Contact.AccountId;
        }
        
        return false;
    }
    
    //Because this methods is executing in Win_UploadService class which is without sharing, 
    //all operations done here will be executed successfully
    public Database.SaveResult insertForceSharing(sObject sObjectToInsert){
        return Database.insert(sObjectToInsert, false);
    }
            
    //Because this methods is executing in Win_UploadService class which is without sharing, 
    //all operations done here will be executed successfully
    public Database.SaveResult updateForceSharing(sObject sObjectToUpdate){
        return Database.update(sObjectToUpdate, false);
    }

    // Prepare the data with the additional info
    public void prepareAdditionalData(Map<String, Object> additionalData, Map<String, Object> dataMap, 
            String key, Object fieldValue) {
        Blob dataBlob = null;

        try {
            String fieldValueStr = (String) fieldValue;
            dataBlob = EncodingUtil.base64Decode(fieldValueStr.substringAfter(','));
            System.debug('WIN-DEBUG: inside the deserializeSObject fieldValue converted ' + (dataBlob != null));
            
            //Inlcude the content type
            additionalData.put('ChatterPostContentType' , dataMap.containsKey('ContentType') 
                ? '' + dataMap.get('ContentType') : 'image/jpg');

            //Inlcude the file name
            additionalData.put('ChatterPostContentFileName' , dataMap.containsKey('ContentFileName') 
                ? '' + dataMap.get('ContentFileName') : 'image.jpg');
            
            //Inlcude the blob
            additionalData.put('ChatterPostContentDataBlob', dataBlob);
            
            dataMap.remove(key);
        } catch(Exception e) {
             System.debug('WIN-DEBUG: inside the deserializeSObject conversion exception ' + e);
        }
    }                    

}