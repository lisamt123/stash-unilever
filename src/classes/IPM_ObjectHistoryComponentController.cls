/***********************************************************************************************************************************************************
* @author Cognizant
* @date  12/03/2015
* @description To meet requirements for getting History for Gate Document referred by component
*/
public with sharing class IPM_ObjectHistoryComponentController {
    public SObject myObject {get; set;}//used to store the object
    public Integer recordLimit {get; set;}//used to store record limit
    public static String objectLabel {get;}//used to store object label
    public objectHistoryLine[] objectHistory;//used to object history
    public static final Map<String, Schema.SObjectType> mySObjectTypeMap = Schema.getGlobalDescribe(); //Contains Object Fields and Description
    public static Map<String, Schema.SObjectField> myObjectFieldMap; //Contains Object Fields Name
    public static List<Schema.PicklistEntry> historyFieldPicklistValues;//used to store Picklist value
    
    /****************************************************************************************************************************************************
    @description Generic Functions Which can Return the History of a Record in any object which has History Tracking Enabled  
    @return Object History List
    */  
    public List<objectHistoryLine> getObjectHistory(){
        Id myObjectId = String.valueOf(myObject.get('Id'));
        Schema.DescribeSObjectResult objectDescription = myObject.getSObjectType().getDescribe();
        myObjectFieldMap = objectDescription.fields.getMap();
        objectLabel = String.valueOf(objectDescription.getLabel());
        //Getting the name of the history table
        String objectHistoryTableName = objectDescription.getName();
        //Dropping the 'c' off the end before adding 'History' to get the history tables name
        if (objectDescription.isCustom()){
            objectHistoryTableName = objectHistoryTableName.substring(0, objectHistoryTableName.length()-1);
        }
        objectHistoryTableName = objectHistoryTableName + IPM_ConstantUtils.HISTORY;
        Schema.DescribeFieldResult objectHistoryFieldField = mySObjectTypeMap.get(objectHistoryTableName).getDescribe().fields.getMap().get(IPM_ConstantUtils.FIELD).getDescribe();
        historyFieldPicklistValues = objectHistoryFieldField.getPickListValues();
        list<objectHistoryLine> objectHistory = new list<objectHistoryLine>();
        //String prevDate = '';
        
        if (recordLimit== null){
            recordLimit = 100;
        }
        list<sObject> historyList=new list<sObject>();
        historyList = Database.query( 'SELECT CreatedDate,'+
        'CreatedById,'+
        'Field,'+
        'NewValue,'+
        'OldValue ' +
        'FROM ' + objectHistoryTableName + ' ' +
        'WHERE ParentId =\'' + myObjectId + '\' ' +
        'ORDER BY CreatedDate DESC '+
        'LIMIT ' + String.valueOf(recordLimit));
        for(Integer i = 0; i < historyList.size(); i++){
            sObject historyLine = historyList.get(i);
            if ((historyLine.get(IPM_ConstantUtils.NEW_VALUE) == null && historyLine.get(IPM_ConstantUtils.OLD_VALUE) == null) 
                    || (historyLine.get(IPM_ConstantUtils.NEW_VALUE) != null && !(string.valueOf(historyLine.get(IPM_ConstantUtils.NEW_VALUE)).startsWith(IPM_ConstantUtils.HISTORY_USER_ID) || string.valueOf(historyLine.get(IPM_ConstantUtils.NEW_VALUE)).startsWith(IPM_ConstantUtils.HISTORY_USER_GROUP)))
                    || (historyLine.get(IPM_ConstantUtils.OLD_VALUE) != null && !(string.valueOf(historyLine.get(IPM_ConstantUtils.OLD_VALUE)).startsWith(IPM_ConstantUtils.HISTORY_USER_ID) || string.valueOf(historyLine.get(IPM_ConstantUtils.OLD_VALUE)).startsWith(IPM_ConstantUtils.HISTORY_USER_GROUP)))){
                objectHistoryLine tempHistory = new objectHistoryLine();
                tempHistory.theDate = Date.valueOf(historyLine.get(IPM_ConstantUtils.HISTORY_CREATED_DATE)).format();
                tempHistory.userId = String.valueOf(historyLine.get(IPM_ConstantUtils.HISTORY_CREATED_BY_ID));
                tempHistory.who = String.valueOf(historyLine.get(IPM_ConstantUtils.HISTORY_CREATED_BY_ID));
                //prevDate = String.valueOf(historyLine.get(IPM_ConstantUtils.HISTORY_CREATED_DATE));
                String fieldLabel = IPM_ObjectHistoryComponentController.returnFieldLabel(String.valueOf(historyLine.get(IPM_ConstantUtils.FIELD)));
                // Set the Action value
                if (String.valueOf(historyLine.get(IPM_ConstantUtils.FIELD)) == IPM_ConstantUtils.HISTORY_CREATED) { 
                    tempHistory.action = IPM_ConstantUtils.HISTORY_HAS_CREATED;
                }
                else if (historyLine.get(IPM_ConstantUtils.OLD_VALUE) != null && historyLine.get(IPM_ConstantUtils.NEW_VALUE) == null){ // when deleting a value from a field
                    try {
                        tempHistory.action = IPM_ConstantUtils.HISTORY_DELETED + Date.valueOf(historyLine.get(IPM_ConstantUtils.OLD_VALUE)).format() + ' in <b>' + fieldLabel + '</b>.';
                    } 
                    catch (Exception e){
                        tempHistory.action = IPM_ConstantUtils.HISTORY_DELETED + String.valueOf(historyLine.get(IPM_ConstantUtils.OLD_VALUE)) + ' in <b>' + fieldLabel + '</b>.';
                    }
                }
                else{ 
                    String fromText = '';
                    if (historyLine.get(IPM_ConstantUtils.OLD_VALUE) != null) {
                        try {
                            fromText = ' from ' + Date.valueOf(historyLine.get(IPM_ConstantUtils.OLD_VALUE)).format();
                        } 
                        catch (Exception e) {
                            fromText = ' from ' + String.valueOf(historyLine.get(IPM_ConstantUtils.OLD_VALUE));
                        }
                    }
                    String toText = '';
                    if (historyLine.get(IPM_ConstantUtils.OLD_VALUE) != null) {
                        try {
                            toText = Date.valueOf(historyLine.get(IPM_ConstantUtils.NEW_VALUE)).format();
                        } 
                        catch (Exception e) {
                            toText = String.valueOf(historyLine.get(IPM_ConstantUtils.NEW_VALUE));
                        }
                    }
                    if (toText != ''){
                        tempHistory.action = IPM_ConstantUtils.HISTORY_CHANGED+'<b>' + fieldLabel + '</b>' + fromText + ' to <b>' + toText + '</b>.';
                    }
                    else {
                        tempHistory.action = IPM_ConstantUtils.HISTORY_HAS_UPDATED;// + fieldLabel;
                        tempHistory.fieldName=fieldLabel;
                    }
                }
                objectHistory.add(tempHistory);
            }
        }
        
        List<Id> userIdList = new List<Id>();
        for (objectHistoryLine myHistory : objectHistory){
            userIdList.add(myHistory.userId);
        }
        Map<Id, User> userIdMap = new Map<ID, User>([SELECT Name,SmallPhotoUrl FROM User WHERE Id IN : userIdList]);
        for (objectHistoryLine myHistory : objectHistory){
            if (userIdMap.containsKey(myHistory.userId) & (myHistory.who != '') ){
                myHistory.who = userIdMap.get(myHistory.who).Name;
                myHistory.whoImage = userIdMap.get(myHistory.userId).SmallPhotoUrl;
            }
        }
        return objectHistory;
    } 
    
    /****************************************************************************************************************************************************
    @description To Return Field Label of a Object Field Given a Field API name 
    @param fieldName Object Field Name
    @return Picklist values
    */  
    public Static String returnFieldLabel(String fieldName){
        if (IPM_ObjectHistoryComponentController.myObjectFieldMap.containsKey(fieldName)){
            return IPM_ObjectHistoryComponentController.myObjectFieldMap.get(fieldName).getDescribe().getLabel();
        }
        else {
            for(Schema.PicklistEntry pickList : historyFieldPicklistValues){
                if (pickList.getValue() == fieldName){
                    if (pickList.getLabel() != null){
                        return pickList.getLabel();
                    }
                    else {
                        return pickList.getValue();
                    }
                }
            }
        }
        return '';
    }
    
    /****************************************************************************************************************************************************
    @description Inner Class to store the detail of the object history lines 
    */  
    public class objectHistoryLine {
        public String theDate {get; set;}
        public String who {get; set;}
        public Id userId {get; set;} 
        public String action {get; set;}
        public String whoImage{get; set;}
        public String fieldName{get;set;}
    }
}