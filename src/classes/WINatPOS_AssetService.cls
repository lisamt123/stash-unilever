/**********************************************************************
Name: WINatPOS_AssetService
Copyright © 2015 Unilever.
============================================================================
============================================================================
Purpose: Webservice class responsible for communication with buttons from standard layout
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Pawel Niedziela        23/11/2015     INITIAL DEVELOPMENT
**********************************************************************/
global without sharing class WINatPOS_AssetService {
	
	/*******************************************************************
	Purpose: Method is deleting given Asset__c if user has right to do it
	Parameters: [String assetId]
	Returns: [String]
	Throws [Exceptions]: [optional] 
	********************************************************************/
	webservice static String deleteAsset(String assetId) {
		
		String errorMessages = '';
		
		Profile systemAdminProfile = [select Id, Name from Profile where Name = 'System Administrator' LIMIT 1];
		
		List<Asset__c> assetToDelete = [
											SELECT 
												Id, 
												Additional_Owner_1__c, 
												Additional_Owner_2__c,
												OwnerId
											FROM Asset__c 
											WHERE Id =:assetId ];

		if(!assetToDelete.isEmpty() && (UserInfo.getProfileId() == systemAdminProfile.Id || assetToDelete[0].OwnerId == UserInfo.getUserId() || assetToDelete[0].Additional_Owner_1__c == UserInfo.getUserId() || assetToDelete[0].Additional_Owner_2__c == UserInfo.getUserId())){
			delete assetToDelete;
		}else{
			errorMessages += 'Insufficient Privileges to delete this record.';
		}
		
	    return errorMessages;
	}
}