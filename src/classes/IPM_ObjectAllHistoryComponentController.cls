/***********************************************************************************************************************************************************
* @author Cognizant
* @date  03/12/2014
* @description To meet requirements for getting History for Gate Document referred by component
*/
public with sharing class IPM_ObjectAllHistoryComponentController {

    // External variables Declarations
    public SObject myObject {get; set;} //Contains Object for Getting History
    public Integer recordLimit {get; set;} //For Record Limit
    public static String objectLabel {get;} //Contains Object Name
    public Id projectId {get; set;} //Contains Project Record Id
    public Id sectionId {get;set;}  //Contains Project Document Section Record Id
    public Set<Id> myObjectId {get;set;} //Set of Object Ids
    
    // Internal Variables Declarations
    public objectHistoryLine[] objectHistory; //Contains Object History Records
    public static final Map<String, Schema.SObjectType> mySObjectTypeMap = Schema.getGlobalDescribe(); //Contains Object Fields and Description
    public static Map<String, Schema.SObjectField> myObjectFieldMap; //Contains Object Fields Name
    public static List<Schema.PicklistEntry> historyFieldPicklistValues; //Contains Object History Field Picklist values

    /****************************************************************************************************************************************************
    @description Generic Functions Which can Return the History of a Record in Any Object Which has History Tracking Enabled 
    @return Object History
    */
    public List<objectHistoryLine> getObjectHistory(){
        
        Schema.DescribeSObjectResult objectDescription = myObject.getSObjectType().getDescribe();
        myObjectFieldMap = new Map<String, Schema.SObjectField>();
        myObjectFieldMap = objectDescription.fields.getMap();
        objectLabel = String.valueOf(objectDescription.getLabel());
        //Getting the name of the history table
        String objectHistoryTableName = objectDescription.getName();
        
        //to get the list of Ids
        List <sObject> getRecordIds=Database.query('SELECT ID FROM '+objectHistoryTableName+' WHERE IPM_Project_Document__r.IPM_Project__r.Id=\''+projectId+'\'');
        if(sectionId!=NULL){
            //this part is for the Section Level History
            myObjectId= new Set<ID>{sectionId};
        }
        else{ 
            // this part is for Document Level History
            myObjectId = new Map<Id,SObject>(getRecordIds).keySet();
        }
        
        //Dropping the 'c' off the end before adding 'History' to get the history tables name
        if (objectDescription.isCustom()){
            objectHistoryTableName = objectHistoryTableName.substring(0, objectHistoryTableName.length()-1);
        }
        objectHistoryTableName = objectHistoryTableName + IPM_ConstantUtils.HISTORY;
        if(mySObjectTypeMap!=null)
        {
            Schema.DescribeFieldResult objectHistoryFieldField = mySObjectTypeMap.get(objectHistoryTableName).getDescribe().fields.getMap().get(IPM_ConstantUtils.FIELD).getDescribe();
            historyFieldPicklistValues = objectHistoryFieldField.getPickListValues();
        }
        list<objectHistoryLine> objectHistory = new list<objectHistoryLine>();
        
        String recordLabel='';
        String recordSequence='';
        String recordID='';
        if (recordLimit== null){
            recordLimit = 100;
        }
        string queryString='SELECT CreatedDate,'+
        'CreatedById,'+
        'Field,'+
        'NewValue,'+
        'OldValue, ' +
        'ParentId, '+
        'Parent.IPM_Section_Name__c, ' +
        'Parent.IPM_Section_Sequence__c '+
        'FROM ' + objectHistoryTableName + ' ' +
        'WHERE ParentId IN :myObjectId' +' '+
        'ORDER BY CreatedDate DESC '+
        'LIMIT ' + String.valueOf(recordLimit);
        list<sObject> historyList=new list<sObject>();
        historyList = Database.query(queryString);
        for(Integer i = 0; i < historyList.size(); i++){
            sObject historyLine = historyList.get(i);
            if ((historyLine.get(IPM_ConstantUtils.NEW_VALUE) == null && historyLine.get(IPM_ConstantUtils.OLD_VALUE) == null) 
                    || (historyLine.get(IPM_ConstantUtils.NEW_VALUE) != null && !(string.valueOf(historyLine.get(IPM_ConstantUtils.NEW_VALUE)).startsWith(IPM_ConstantUtils.HISTORY_USER_ID) || string.valueOf(historyLine.get(IPM_ConstantUtils.NEW_VALUE)).startsWith(IPM_ConstantUtils.HISTORY_USER_GROUP)))
                    || (historyLine.get(IPM_ConstantUtils.OLD_VALUE) != null && !(string.valueOf(historyLine.get(IPM_ConstantUtils.OLD_VALUE)).startsWith(IPM_ConstantUtils.HISTORY_USER_ID) || string.valueOf(historyLine.get(IPM_ConstantUtils.OLD_VALUE)).startsWith(IPM_ConstantUtils.HISTORY_USER_GROUP)))){
                objectHistoryLine tempHistory = new objectHistoryLine();
                // Set the Date and who performed the action
                tempHistory.theDate = Date.valueOf(historyLine.get(IPM_ConstantUtils.HISTORY_CREATED_DATE)).format();
                tempHistory.userId = String.valueOf(historyLine.get(IPM_ConstantUtils.HISTORY_CREATED_BY_ID));
                tempHistory.who = String.valueOf(historyLine.get(IPM_ConstantUtils.HISTORY_CREATED_BY_ID));
               
                // Get the field label
                String fieldLabel = IPM_ObjectAllHistoryComponentController.returnFieldLabel(String.valueOf(historyLine.get(IPM_ConstantUtils.FIELD)));
                
                recordLabel = String.valueOf(historyLine.getsObject(IPM_ConstantUtils.HISTORY_PARENT).get(IPM_ConstantUtils.HISTORY_SECTION_NAME));   
                recordSequence = String.valueOf(historyLine.getsObject(IPM_ConstantUtils.HISTORY_PARENT).get(IPM_ConstantUtils.HISTORY_SECTION_SEQUENCE));
                recordID=String.valueOf(historyLine.getsObject(IPM_ConstantUtils.HISTORY_PARENT).get('ID'));
                // Set the Action value
                if (String.valueOf(historyLine.get(IPM_ConstantUtils.FIELD)) == IPM_ConstantUtils.HISTORY_CREATED) { // on Creation
                    tempHistory.action = recordSequence+' '+recordLabel;
                    tempHistory.actionType=IPM_ConstantUtils.HISTORY_CREATED_BY;
                    tempHistory.recordLink=recordID;
                }
                else if (historyLine.get(IPM_ConstantUtils.OLD_VALUE) != null && historyLine.get(IPM_ConstantUtils.NEW_VALUE) == null){ // when deleting a value from a field
                    // Formatting the Date
                    try {
                        tempHistory.action = IPM_ConstantUtils.HISTORY_DELETED + Date.valueOf(historyLine.get(IPM_ConstantUtils.OLD_VALUE)).format() + ' in <b>' + fieldLabel + '</b>.';
                    } catch (Exception e){
                        tempHistory.action = IPM_ConstantUtils.HISTORY_DELETED + String.valueOf(historyLine.get(IPM_ConstantUtils.OLD_VALUE)) + ' in <b>' + fieldLabel + '</b>.';
                    }
                }
                else{ // all other scenarios
                    String fromText = '';
                    if (historyLine.get(IPM_ConstantUtils.OLD_VALUE) != null) {
                        try {
                            fromText = ' from ' + Date.valueOf(historyLine.get(IPM_ConstantUtils.OLD_VALUE)).format();
                        } catch (Exception e) {
                            fromText = ' from ' + String.valueOf(historyLine.get(IPM_ConstantUtils.OLD_VALUE));
                        }
                    }
                    String toText = '';
                    if (historyLine.get(IPM_ConstantUtils.OLD_VALUE) != null) {
                        try {
                            toText = Date.valueOf(historyLine.get(IPM_ConstantUtils.NEW_VALUE)).format();
                        } catch (Exception e) {
                            toText = String.valueOf(historyLine.get(IPM_ConstantUtils.NEW_VALUE));
                        }
                    }
                    if (toText != ''){
                        tempHistory.action = IPM_ConstantUtils.HISTORY_CHANGED +recordSequence+' '+recordLabel+' '+fieldLabel + ' ' + fromText + ' to ' + toText + '.';
                    }
                    else {
                        tempHistory.action = recordSequence+' '+recordLabel+' ';
                        tempHistory.recordLink=recordID;
                        tempHistory.actionType=IPM_ConstantUtils.HISTORY_UPDATED_BY;
                    }
                }
                // Add to the list
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
    @description To return Field Label of a object field given a Field API name 
    @param fieldName Object Filed Name
    @return Custom Picklist Old Value
    */
    public Static String returnFieldLabel(String fieldName){
        if (IPM_ObjectAllHistoryComponentController.myObjectFieldMap.containsKey(fieldName)){
            return IPM_ObjectAllHistoryComponentController.myObjectFieldMap.get(fieldName).getDescribe().getLabel();
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
        public String recordLink{get;set;}
        public String actionType{get; set;}
    }
}