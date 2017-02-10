/*************************************************************** 
    Name: Win_MetadataService
    Copyright © 2016 Accenture
    ======================================================
    Purpose:
    -------
    Implementation of the Win_IMetadataService, to handle the metadata information

    ======================================================
    History
    -------
    VERSION     AUTHOR          DATE        DETAIL          Description
    1.0         Nicola Tassini  20/12/2016  Initial Dev     Metadata Service
***************************************************************/
public with sharing class Win_MetadataService implements Win_IMetadataService {
    
    private Map<String, Win_Tracked_Object_Config__c> objectsSetting;
    private Map<String, Schema.SObjectType> globalDescribe;
    private String ClientAppID;
    
    private final String ACTIVE_FIELD_NAME = 'Active__c';
    //private final String PRIORITY_FIELD_NAME = 'Priority__c';
    //private final String CLIENTAPP_ID_NAME = 'ClientApp_ID__c';
    public final static String DefaultAppId = 'Win_uilaONE';

    /**
    *   Default constructor
    */
    public Win_MetadataService() {
        this(DefaultAppId);
    }    
    
    /**
    *   Default constructor
    */
    public Win_MetadataService(String clientAppId) {
        this.ClientAppID = clientAppId;
        System.debug('Win_MetadataService initialised with clientAppId = ' + this.ClientAppID);
        //Init the custom setting
        objectsSetting = Win_TrackingUtils.getObjects(clientAppId);
        
        //Global describe on all the objects, for the field sets
        globalDescribe = Win_TrackingUtils.getGlobalDescribe();
    }
    
    /**
    *   Implementation of Win_IMetadataService.trackedObjectsAPINames()
    */
    public List<String> trackedObjectsAPINames(String appID) {
        List<String> trackedObjectsAPIName = null;
        
        if(objectsSetting != null) {
            // Initialize a static array of strings         
            trackedObjectsAPIName = new List<String>();
            
            //Iterate on all the tracked objects
            for(String objectsSettingKey : objectsSetting.keySet()) {
                Win_Tracked_Object_Config__c trackedObjectSetting = objectsSetting.get(objectsSettingKey);
                
                //Use only active TrackedObjects
                if(Boolean.valueOf(trackedObjectSetting.get(ACTIVE_FIELD_NAME))) { 
                    //Get the object Name and Layout info
                    String trackedObjectName = trackedObjectSetting.Object_Api_Name__c;
                    if(trackedObjectSetting != null && globalDescribe.containsKey(trackedObjectName)) {
                        
                        // Fetch the priority and add the object
                        trackedObjectsAPIName.add(trackedObjectName);
                    }
                }
            }
        } else {
            throw new Win_Exception(Win_MetadataResponse.SERVER_ERROR_CUSTOMSETTING);
        }

        return trackedObjectsAPIName;
    }

    /**
    *   Implementation of Win_IMetadataService.trackedObjectAccessible(String)
    */
    public Boolean trackedObjectAccessible(String objectAPIName) {
        if(objectAPIName != null && objectAPIName.length() > 0 && globalDescribe.containsKey(objectAPIName)) {
           Schema.DescribeSObjectResult objectDescribe = globalDescribe.get(objectAPIName).getDescribe();
           return objectDescribe.isQueryable();
        }
        else
            return false;
    }
        
    /**
    *   Implementation of Win_IMetadataService.trackedObjectLayouts(String)
    */
    public Boolean trackedObjectLayouts(String objectAPIName) {
        //Check on the argument
        if(objectAPIName != null && objectAPIName.length() > 0) {
            
            //Read the setting on that object
            Win_Tracked_Object_Config__c trackedObjectSetting = objectsSetting.get(objectAPIName);
            
            //return the setting value
            if(trackedObjectSetting != null) {
                return trackedObjectSetting.Layout_Needed__c;
            } else {
                throw new Win_Exception(Win_MetadataResponse.SERVER_ERROR_OBJECTNOTFOUND);
            }
        }

        return false;
    }
    
    /**
    *   Implementation of Win_IMetadataService.trackedObjectDisplayable(String)
    */
    public Boolean trackedObjectDisplayable(String objectAPIName) {
        //Check on the argument
        if(objectAPIName != null && objectAPIName.length() > 0) {
            
            //Read the setting on that object
            Win_Tracked_Object_Config__c trackedObjectSetting = objectsSetting.get(objectAPIName);
            
            //return the setting value
            if(trackedObjectSetting != null) {
                return trackedObjectSetting.Displayable__c;
            } else {
                throw new Win_Exception(Win_MetadataResponse.SERVER_ERROR_OBJECTNOTFOUND);
            }
        }

        return false;
    }
    
    /**
    *   Implementation of Win_IMetadataService.trackedObjectDisplayable(String)
    */
    public Boolean trackedObjectOnlyMetadataNeeded(String objectAPIName) {
        //Check on the argument
        if(objectAPIName != null && objectAPIName.length() > 0) {
            
            //Read the setting on that object
            Win_Tracked_Object_Config__c trackedObjectSetting = objectsSetting.get(objectAPIName);
            
            //return the setting value
            if(trackedObjectSetting != null) {
                return trackedObjectSetting.Only_Metadata_Needed__c;
            } else {
                throw new Win_Exception(Win_MetadataResponse.SERVER_ERROR_OBJECTNOTFOUND);
            }
        }

        return false;
    }
        
    /**
    *   Implementation of Win_IMetadataService.trackedObjectCustomIndexList(String)
    */
    public List<String> trackedObjectCustomIndexList(String objectAPIName) {
        //Check on the argument
        if(objectAPIName != null && objectAPIName.length() > 0) {
            
            //Read the setting on that object
            Win_Tracked_Object_Config__c trackedObjectSetting = objectsSetting.get(objectAPIName);
            
            //return the setting value
            if(trackedObjectSetting != null) {
                String customIndexList = trackedObjectSetting.Custom_Index_List__c;
                return customIndexList != null ? customIndexList.split(',') : new List<String>();
            } else {
                throw new Win_Exception(Win_MetadataResponse.SERVER_ERROR_OBJECTNOTFOUND);
            }
        }

        return new List<String>();  
    }
    
    /**
    *   Implementation of Win_IMetadataService.trackedObjectFieldSetList(String)
    */
    public List<String> trackedObjectFieldSetList(String objectAPIName) {
        List<String> fieldSetList = new List<String>();
        
        //Check on the argument
        if(objectAPIName != null && objectAPIName.length() > 0) {
            
            //Read the setting on that object
            Win_Tracked_Object_Config__c trackedObjectSetting = objectsSetting.get(objectAPIName);
            
            //If the setting is found and the globalDescribe is ready
            if(trackedObjectSetting != null && globalDescribe != null) {
                
                //Filter the describe for the object
                if(globalDescribe.containsKey(objectAPIName)) {
                    Schema.DescribeSObjectResult objectDescribe = globalDescribe.get(objectAPIName).getDescribe();
                    
                    //Check that the object has been described
                    if(objectDescribe != null) {
                        //Get the fieldSet Map for the particular object
                        Map<String, Schema.FieldSet> fsMap = objectDescribe.fieldSets.getMap();
                        
                        //Check that the field set is ready
                        if(fsMap != null) {
                            List<String> fieldSetSplitList = Win_TrackingUtils.splitList(trackedObjectSetting.Fieldset_Name_List__c);
                            if (trackedObjectSetting.Custom_Index_List__c != null){
                                fieldSetList.addAll(Win_TrackingUtils.splitList(trackedObjectSetting.Custom_Index_List__c));
                            }

                            //Read all the field set names
                            for(String fieldSetName : fieldSetSplitList) {
                                if (fsMap.containsKey(fieldSetName))
                                  fieldSetList.add(fieldSetName);       
                            }
                        }
                    }
                }
            } else {
                throw new Win_Exception(Win_MetadataResponse.SERVER_ERROR_OBJECTNOTFOUND);
            }       
        }
        
        return fieldSetList;
    }
    
    /**
    *   Implementation of Win_IMetadataService.trackedObjectFieldSets(String)
    */
    public Map<String, List<String>> trackedObjectFieldSets(String objectAPIName) {
        //Map with field set name as key, list of fields as value
        Map<String, List<String>> fieldSets = new Map<String, List<String>>();
        
        //Check on the argument
        if(objectAPIName != null && objectAPIName.length() > 0) {
            
            //Read the setting on that object
            Win_Tracked_Object_Config__c trackedObjectSetting = objectsSetting.get(objectAPIName);
            
            //If the setting is found and the globalDescribe is ready
            if(trackedObjectSetting != null && globalDescribe != null) {
                
                //Filter the describe for the object
                if(globalDescribe.containsKey(objectAPIName)) {
                    Schema.DescribeSObjectResult objectDescribe = globalDescribe.get(objectAPIName).getDescribe();
                    
                    //Check that the object has been described
                    if(objectDescribe != null) {
                        //Get the fieldSet Map for the particular object
                        Map<String, Schema.FieldSet> fsMap = objectDescribe.fieldSets.getMap();
                        Map<String, Schema.DescribeFieldResult> fieldDescriptionMap;
                        fieldDescriptionMap = getFieldDescriptionMap(objectAPIName);
                        
                        //Check that the field set is ready
                        if(fsMap != null) {
                            List<String> fieldSetList = Win_TrackingUtils.splitList(trackedObjectSetting.Fieldset_Name_List__c);
                            if (trackedObjectSetting.Custom_Index_List__c != null){
                                fieldSetList.addAll(Win_TrackingUtils.splitList(trackedObjectSetting.Custom_Index_List__c));
                            }
                            //Read all the field set names
                            for(String fieldSetName : fieldSetList) {
                                Schema.FieldSet fieldSetSchema = fsMap.get(fieldSetName);
                                
                                if(fieldSetSchema != null) {
                                    //Iterate on all the fields of the current fieldSet
                                    List<String> fieldList = new List<String>();
                                    for(Schema.FieldSetMember f : fieldSetSchema.getFields()) {
                                        String fieldName = f.getFieldPath();
                                        Schema.DescribeFieldResult fieldDescribe = fieldDescriptionMap.get(fieldName);
                                        
                                        // Check if the user has access to the field
                                        if(fieldDescribe != null && fieldDescribe.isAccessible()) {
                                            fieldList.add(f.getFieldPath());
                                        }
                                    }
                                
                                    //Add this field set info on the main map
                                    fieldSets.put(fieldSetName, fieldList);     
                                }
                            }
                        }
                    }
                }
            } else {
                System.debug('Issue with object not found objectAPIName: ' + objectAPIName);
                throw new Win_Exception(Win_MetadataResponse.SERVER_ERROR_OBJECTNOTFOUND);
            }
        }       
        return fieldSets;
    }
    
    public Map<String, Schema.DescribeFieldResult>getFieldDescriptionMap(String objectApiName){
        Map<String, Schema.DescribeFieldResult> resultMap = new Map<String, Schema.DescribeFieldResult>();
        Schema.SObjectType sObjType = globalDescribe.get(objectApiName);
        if (sObjType != null){
            Map<String, Schema.SObjectField> fieldMap = sObjType.getDescribe().fields.getMap();
            for (String fieldKey : fieldMap.keySet()) {
                Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldKey).getDescribe();
                resultMap.put(fieldDescribe.Name, fieldDescribe);
            }
        }
        return resultMap;        
    }
    
    /**
    *   Implementation of Win_IMetadataService.trackedObjectHeaderFieldSet(String)
    */
    public List<String> trackedObjectHeaderFieldSet(String objectAPIName) {
        //Final list of fields
        List<String> trackedObjectHeaderFieldSet = new List<String>();
                    
        //Read the setting on that object
        Win_Tracked_Object_Config__c trackedObjectSetting = objectsSetting.get(objectAPIName);
            
        //If the setting is found and the globalDescribe is ready
        if(trackedObjectSetting != null) {
            // split string into strings
            for(String fieldName : Win_TrackingUtils.splitList(trackedObjectSetting.List_Header_Fieldset__c)) {
                trackedObjectHeaderFieldSet.add(fieldName);
            }

        } else {
            throw new Win_Exception(Win_MetadataResponse.SERVER_ERROR_OBJECTNOTFOUND);
        }

        return trackedObjectHeaderFieldSet;
    }
    
    
    public sObject trackedObjectDefaultValues(String objectApiName){
        sObject emptySObject = (sObject)Type.forName(objectApiName).newInstance();
        sObjectType sObjType = emptySObject.getSObjectType();
        
        SObject defaultValuesSObject = sObjType.newSObject(null, true);
        String defaultRecordTypeId = getDefaultRecordTypeId(sObjType);
        if (defaultRecordTypeId != null)
            try {
                defaultValuesSObject.put('RecordTypeId', defaultRecordTypeId);
            }
            catch (Exception e){
                System.debug('It\'s impossible to set Record type for object ' + objectApiName);
            }
       
        return defaultValuesSObject;
    }
    
    private String getDefaultRecordTypeId(sObjectType sObjType){
        String defaultRecordTypeId = null;
        try {
            Schema.DescribeSObjectResult dsr = sObjType.getDescribe();
            for(Schema.RecordTypeInfo rti : dsr.getRecordTypeInfos()) {
                if(rti.isDefaultRecordTypeMapping()) {
                    defaultRecordTypeId = rti.getRecordTypeId();
                    break;
                }
            } 
        }
        catch (Exception e) {
            defaultRecordTypeId = null;    
        }   
        return defaultRecordTypeId;
    }
    
    public Set<String> getSystemFieldSet(String objectApiName){
        Set<String> resultSet = new Set<String>{'Id', 'Name', 'IsDeleted', 'CreatedById', 'CreatedDate', 
            'LastModifiedById', 'LastModifiedDate', 'OwnerId'};
            
        String nameField = getNameField(objectApiName);
        
        if (nameField != null)
            resultSet.add(nameField);
            
        return resultSet;
    }
    
    public String getNameField (String objectApiName){
        Schema.SObjectType sObjType = globalDescribe.get(objectApiName);
        if(sObjType != null) {
            Map<String, Schema.SObjectField> fieldMap = sObjType.getDescribe().fields.getMap();
            for (String fieldKey : fieldMap.keySet()) {
                Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldKey).getDescribe();
                if(fieldDescribe != null && fieldDescribe.isNameField() ) {
                    return fieldDescribe.getName();
                }
            }
        }       
        
        return null;
    }
    
    public List<String> getAllFieldSet(String objectApiName){
        List<String> fullFieldSet = new List<String>();
        Schema.SObjectType sObjType = globalDescribe.get(objectApiName);
        if(sObjType != null) {
            Map<String, Schema.SObjectField> fieldMap = sObjType.getDescribe().fields.getMap();
            for (String fieldKey : fieldMap.keySet()) {
                Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldKey).getDescribe();
                if(fieldDescribe != null && fieldDescribe.isAccessible()) {
                    fullFieldSet.add(fieldDescribe.getName());
                }
            }
        }
        return fullFieldSet;
    }
    
    public List<String> getFullRecordFieldSet(String objectApiName, List<String> fieldSet){
        List<String> fullFieldSet = new List<String>(fieldSet);
        Set<String> includedFields = new Set<String>(fieldSet);
        Set<String> systemFieldSet = getSystemFieldSet(objectApiName);
        
        Schema.SObjectType sObjType = globalDescribe.get(objectApiName);
        if(sObjType != null) {
            Map<String, Schema.SObjectField> fieldMap = sObjType.getDescribe().fields.getMap();
            for (String fieldKey : fieldMap.keySet()) {
                Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldKey).getDescribe();
                String fieldName = fieldDescribe.getName();
                
                if(!includedFields.contains(fieldName) && fieldDescribe.isAccessible()) {
                    if(systemFieldSet.contains(fieldName) || 
                        fieldDescribe.getType() == Schema.DisplayType.Reference ||
                        (!fieldDescribe.isNillable() && fieldDescribe.getType() != Schema.Displaytype.Boolean
                        && (fieldDescribe.isCreateable() || fieldDescribe.isUpdateable()))) {
                            fullFieldSet.add(fieldName);
                    }
                }
            }
        }
        
        return fullFieldSet;
    }
    
    public List<String> getCreateableFieldSet(String objectApiName, List<String> fieldSet) {
        List<String> createableFieldSet = new List<String>();
        
        Schema.SObjectType sObjType = globalDescribe.get(objectApiName);
        if (sObjType != null){
            Map<String, Schema.SObjectField> fieldMap = sObjType.getDescribe().fields.getMap();
            for (String fieldName : fieldSet) {
                Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();
                
                if (fieldDescribe.isCreateable()) {
                    createableFieldSet.add(fieldName);
                }
            }
        }
        
        return createableFieldSet;
    }
    
    public List<String> getUpdateableFieldSet(String objectApiName, List<String> fieldSet){
        List<String> updateableFieldSet = new List<String>();
        
        Schema.SObjectType sObjType = globalDescribe.get(objectApiName);
        if (sObjType != null){
            Map<String, Schema.SObjectField> fieldMap = sObjType.getDescribe().fields.getMap();
            for (String fieldName : fieldSet) {
                Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldName).getDescribe();
                
                if (fieldDescribe.isUpdateable()) {
                    updateableFieldSet.add(fieldName);
                }
            }
        }
        
        return updateableFieldSet;
    }
}