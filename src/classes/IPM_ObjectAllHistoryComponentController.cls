/* Type Name: IPM_ObjectAllHistoryComponentController
Author: Kannan and Samrat 
Created Date: 03-12-2014
Reason: To meet requirements for getting History for Gate Document referred by component*/

public class IPM_ObjectAllHistoryComponentController {

        // External variables Declarations
        public SObject myObject {get; set;}
        public Integer recordLimit {get; set;}
        public static String objectLabel {get;}
        public Id projectId {get; set;}
        public Id sectionId {get;set;}
        
        public Set<Id> myObjectId {get;set;}

        // Internal Variables Declarations
        public objectHistoryLine[] objectHistory; 

        public static final Map<String, Schema.SObjectType> mySObjectTypeMap = Schema.getGlobalDescribe();
        public static Map<String, Schema.SObjectField> myObjectFieldMap;
        public static List<Schema.PicklistEntry> historyFieldPicklistValues;

    /*Type Name: retrieveFinancialTable()
        Parameter(s)
        ReturnType: list
        Reason: This is the generic functions which can return the History of a Record in any object which has History Tracking Enabled */
        public List<objectHistoryLine> getObjectHistory(){

        
            //Id myObjectId = String.valueOf(myObject.get('Id')); //Id from the URL
            Schema.DescribeSObjectResult objectDescription = myObject.getSObjectType().getDescribe();

            
            
            myObjectFieldMap = objectDescription.fields.getMap();
            objectLabel = String.valueOf(objectDescription.getLabel());

            //Get the name of the history table
            String objectHistoryTableName = objectDescription.getName();
            
            //to get the list of Ids
            List <sObject> getRecordIds=Database.query('Select ID from '+objectHistoryTableName+' where IPM_Project_Document__r.IPM_Project__r.Id=\''+projectId+'\'');
            //system.debug('THe Record List'+getRecordIds);
            if(sectionId!=NULL)
            {
                system.debug('SectionID'+sectionId);
                //this part is for the Section Level History
                myObjectId= new Set<ID>{sectionId};
               // myObjectId.add(sectionId);
            }
            else
            { // this part is for Document Level History
                myObjectId = (new Map<Id,SObject>(getRecordIds)).keySet();
            }
            //for(sObject recID : getRecordIds)
            //{ 
                //system.debug
            //  myObjectId.add(recID.Id);
            //}
            //List<Id> myObjectId = Database.query('Select ID from '+objectHistoryTableName);
            system.debug(myObjectId+'List of IDs');
            //upto here
            
            //if we have a custom object we need to drop the 'c' off the end before adding 'History' to get the history tables name
            if (objectDescription.isCustom()){
                objectHistoryTableName = objectHistoryTableName.substring(0, objectHistoryTableName.length()-1);
            }
            objectHistoryTableName = objectHistoryTableName + 'History';

            Schema.DescribeFieldResult objectHistoryFieldField = mySObjectTypeMap.get(objectHistoryTableName).getDescribe().fields.getMap().get('Field').getDescribe();
            historyFieldPicklistValues = objectHistoryFieldField.getPickListValues();

            list<objectHistoryLine> objectHistory = new list<objectHistoryLine>();

            String prevDate = '';
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
            //system.debug('the Query String'+queryString);
            list<sObject> historyList = Database.query(queryString);
            //system.debug('The Retrieved List>>'+historyList);
            for(Integer i = 0; i < historyList.size(); i++){
                sObject historyLine = historyList.get(i);
                if ((historyLine.get('newValue') == null && historyLine.get('oldValue') == null) 
                || (historyLine.get('newValue') != null && !(string.valueOf(historyLine.get('newValue')).startsWith('005') || string.valueOf(historyLine.get('newValue')).startsWith('00G')))
                || (historyLine.get('oldValue') != null && !(string.valueOf(historyLine.get('oldValue')).startsWith('005') || string.valueOf(historyLine.get('oldValue')).startsWith('00G')))){
                        objectHistoryLine tempHistory = new objectHistoryLine();
                        // Set the Date and who performed the action
                        //if (String.valueOf(historyLine.get('CreatedDate')) != prevDate){
                            tempHistory.theDate = Date.valueOf(historyLine.get('CreatedDate')).format();
                            tempHistory.userId = String.valueOf(historyLine.get('CreatedById'));
                            tempHistory.who = String.valueOf(historyLine.get('CreatedById'));
                        //}
                        //else{
                           // tempHistory.theDate = '';
                           // tempHistory.who = '';
                          //  tempHistory.userId = String.valueOf(historyLine.get('CreatedById'));
                        //}
                        prevDate = String.valueOf(historyLine.get('CreatedDate'));

                        // Get the field label
                        String fieldLabel = IPM_ObjectAllHistoryComponentController.returnFieldLabel(String.valueOf(historyLine.get('Field')));
                        
                       // if(String.valueOf(historyLine.getsObject('Parent').get('IPM_Section_Name__c'))!=NULL)
                       // {
                                recordLabel = String.valueOf(historyLine.getsObject('Parent').get('IPM_Section_Name__c'));   
                                recordSequence = String.valueOf(historyLine.getsObject('Parent').get('IPM_Section_Sequence__c'));
                                recordID=String.valueOf(historyLine.getsObject('Parent').get('ID'));
                       // }
                        // Set the Action value
                        if (String.valueOf(historyLine.get('Field')) == 'created') { // on Creation
                            tempHistory.action = recordSequence+' '+recordLabel;
                            tempHistory.actionType='Created By';
                            tempHistory.recordLink=recordID;
                        }
                        else if (historyLine.get('oldValue') != null && historyLine.get('newValue') == null){ // when deleting a value from a field
                        // Format the Date and if there's an error, catch it and re
                            try {
                                tempHistory.action = 'Deleted ' + Date.valueOf(historyLine.get('oldValue')).format() + ' in <b>' + fieldLabel + '</b>.';
                            } catch (Exception e){
                                tempHistory.action = 'Deleted ' + String.valueOf(historyLine.get('oldValue')) + ' in <b>' + fieldLabel + '</b>.';
                            }
                        }
                        else{ // all other scenarios
                            String fromText = '';
                            if (historyLine.get('oldValue') != null) {
                                try {
                                    fromText = ' from ' + Date.valueOf(historyLine.get('oldValue')).format();
                                } catch (Exception e) {
                                    fromText = ' from ' + String.valueOf(historyLine.get('oldValue'));
                                }
                            }

                            String toText = '';
                            if (historyLine.get('oldValue') != null) {
                                try {
                                    toText = Date.valueOf(historyLine.get('newValue')).format();
                                } catch (Exception e) {
                                    toText = String.valueOf(historyLine.get('newValue'));
                                }
                            }
                            if (toText != ''){
                                tempHistory.action = 'Changed ' +recordSequence+' '+recordLabel+' '+fieldLabel + ' ' + fromText + ' to ' + toText + '.';
                                
                            }
                            else {
                                tempHistory.action = recordSequence+' '+recordLabel+' ';
                                tempHistory.recordLink=recordID;
                                tempHistory.actionType='Updated By';
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

        
        /*Type Name: Sting Field Labels()
        Parameter(s)
        ReturnType: list
        Reason:Function to return Field Label of a object field given a Field API name*/

        
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

        // Inner Class to store the detail of the object history lines 
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