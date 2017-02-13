/*************************************************************** 
	Name: Win_IUploadService
	Copyright © 2016 Accenture
	======================================================
	Purpose:
	-------
	Interface to defiene the required method that each upload service should implement
	======================================================
	History
	-------
	VERSION		AUTHOR 			DATE    	DETAIL    		Description
	1.0     	Nicola Tassini 	22/12/2016	Initial Dev 	First version
***************************************************************/
public interface Win_IUploadService {

	//Recognize if sObject Id is local
	Boolean isLocalId(String id);
	
	//Recognize which DML operation should be done with object: insert, update or delete
	String getOperationType(sObject record);
	
	//Go through the all reference fields of sObject to replace all local Ids with all ids inserted before
	Boolean reassignLocalReferences(sObject recordObject, Map<String, String> assignmentMap);
	
	//Convert JSON string in request item to the sObject
	sObject deserializeSObject(Win_UploadRequestItem requestItem, Map<String, Object> additionalData);
	
	//Fetch new sObject data after DML operation was finished successfully
	sObject getResultSObject(String objectApiName, String objectId);
	
	//Get map of related fields with local ids for the object
	Map<String, String> getUnresolvedRelatedFields(sObject recordObject);
	
	// Check for a given object and operation if the sharing has to be added 
	Boolean shouldForceSharingInDml(sObject sObjectToCheck, String operation);
	
	// Insert forcing sharing
	Database.SaveResult insertForceSharing(sObject sObjectToInsert);
	
	// Update forcing sharing
	Database.SaveResult updateForceSharing(sObject sObjectToUpdate);

}