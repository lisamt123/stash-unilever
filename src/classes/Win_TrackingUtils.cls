/*************************************************************** 
    Name: Win_MetadataService
    Copyright © 2016 Accenture
    ======================================================
    Purpose:
    -------
    Utils for the tracking (web) services 

    ======================================================
    History
    -------
    VERSION     AUTHOR          DATE        DETAIL          Description
    1.0         Nicola Tassini  20/12/2016  Initial Dev     Tracking Service
***************************************************************/
public with sharing class Win_TrackingUtils {
    private final static String CLIENTAPP_ID_NAME = 'ClientApp_ID__c';  
    private static Map<String, Schema.SObjectType> globalDescribe;
    private static User currentUser = null;
    
    /**
    * Keeps in memory global limit to get it for every class. Use to prevent governor limit of calls to get global describes
    * Should be used everywhere in Win_ classes
    **/
    public static Map<String, Schema.SObjectType> getGlobalDescribe(){
        if (globalDescribe == null) {
            globalDescribe = Schema.getGlobalDescribe();
        }
        
        return globalDescribe;
    }
    
    public static Schema.Describesobjectresult getObjectDescribe(String objectApiName){
        Schema.SObjectType objectType = getGlobalDescribe().get(objectApiName);
        if (objectType != null) {
            return objectType.getDescribe();
        }
        else 
            return null;
    }
    
    /**
    * Returns Users object for current user with all accessible fields.
    **/
    public static User getCurrentUser(){
        if (currentUser == null) {
            // making the query
            String query = '';
            Schema.DescribeSObjectResult userDescribe = getGlobalDescribe().get('User').getDescribe();
            
            Map<String, Schema.SObjectField> fieldMap = userDescribe.fields.getMap();
            for (String fieldKey : fieldMap.keySet()) {
                Schema.DescribeFieldResult fieldDescribe = fieldMap.get(fieldKey).getDescribe();
                if(fieldDescribe != null && fieldDescribe.isAccessible() && fieldDescribe.isUpdateable()) {
                    query += (query == '') ? 'SELECT ' : ', ';
                    query += fieldDescribe.getName();
                }
            }
            query += ' FROM User WHERE Id = \'' + UserInfo.getUserId() + '\'';
        
            currentUser = (User)Database.query(query);
        }
        
        return currentUser;
    }

         
    /**
     *  Get the tracked object settings
     *  @returns the tracking custom setting for the objects
     */
    public static Map<String, Win_Tracked_Object_Config__c> getObjects(String appID) {
         Map<String, Win_Tracked_Object_Config__c> customSettingMap = new Map<String, Win_Tracked_Object_Config__c>();
         
         // Build the map of custom settings by ObjectAPIName
         for(Win_Tracked_Object_Config__c customSetting : Win_Tracked_Object_Config__c.getAll().values()) {
            if (appID != null && appID.length() > 0 && customSetting.get(CLIENTAPP_ID_NAME) != null 
               && appId.equalsIgnoreCase(String.valueOf(customSetting.get(CLIENTAPP_ID_NAME)))){
                    customSettingMap.put(customSetting.Object_Api_Name__c, customSetting);
               }
         }
         
         return customSettingMap;
    }
    
    /**
     *  Split a list of comma separated values in a Set of Strings
     *  Now ordered
     *  @returns Set of Strings
     */
    public static List<String> splitList(String field) {
        Set<String> valuesSet = new Set<String>();
        List<String> values = new List<String>();
        
        if(field != null && field.length() > 0) {
            String[] fieldArray = field.split(',', 0);
                
            for(String fieldVal : fieldArray) {
                if (!valuesSet.contains(fieldVal)){
                    values.add(fieldVal);
                    valuesSet.add(fieldVal);
                }
            }
        }
        
        return values;
    }
    
    /**
     *  Compute the set of fields that are matching the criteria specified
     *  @param params field set selection criteria
     *  @returns List of fields compliant with the selected criteria
     */
    public static List<String> getFieldSetFields(Map<String, Schema.SObjectType> globDescribe, FieldSetSelectionCriteria params) {
        List<String> fields = new List<String>();
        
        if(globDescribe != null && params.objectAPIName != null && params.objectAPIName.length() > 0 && params.fieldSetName != null && params.fieldSetName.length() > 0) {
            Schema.DescribeSObjectResult objectDescribe = globDescribe.get(params.objectAPIName).getDescribe();
                        
            //Check that the object has been described
            if(objectDescribe != null) {
                //Get the fieldSet Map for the particular object
                Map<String, Schema.FieldSet> fsMap = objectDescribe.fieldSets.getMap();
                
                //Check that the field set is ready
                if(fsMap != null) {
                    //Read all the field set names
                    Schema.FieldSet fieldSetSchema = fsMap.get(params.fieldSetName);
                    
                    if(fieldSetSchema != null) {
                        parseFields(fieldSetSchema, params, objectDescribe, fields);
                    }
                }
            }
        }
        
        return fields;
    }

    /**
     *  Parse the fields and add them to the passed array
     */
    private static void parseFields(Schema.FieldSet fieldSetSchema, FieldSetSelectionCriteria params,
            Schema.DescribeSObjectResult objectDescribe, List<String> fields) {
        //Return the describe on the fields
        Map<String,Schema.SObjectField> fieldsDescribe = objectDescribe.fields.getMap();
        
        //Iterate on all the fields of the current fieldSet
        Schema.DescribeFieldResult fieldDescribe = null;

        for(Schema.FieldSetMember f : fieldSetSchema.getFields()) {
            //Describe on this field
            if(fieldsDescribe.get(f.getFieldPath()) != null) {
                fieldDescribe = fieldsDescribe.get(f.getFieldPath()).getDescribe();
                
                if(fieldDescribe != null && !(  
                    (params.enforceIsAccessible && !fieldDescribe.isAccessible()) ||
                    (params.enforceIsCreateable && !fieldDescribe.isCreateable()) ||
                    (params.enforceIsUpdateable && !fieldDescribe.isUpdateable()) ||
                    (params.enforceIsRequired && fieldDescribe.isNillable()) 
                )) {
                    fields.add(f.getFieldPath());
                }
            }
        }
    }
    
    /**
     *  FieldSet selection criteria wraps all the parameters to select a subset of fields
     */
    public class FieldSetSelectionCriteria {
        
        public String  objectAPIName        { get; set; }
        public String  fieldSetName         { get; set; }
        public Boolean enforceIsAccessible  { get; set; }
        public Boolean enforceIsCreateable  { get; set; }
        public Boolean enforceIsUpdateable  { get; set; }
        public Boolean enforceIsRequired    { get; set; }
    }
}