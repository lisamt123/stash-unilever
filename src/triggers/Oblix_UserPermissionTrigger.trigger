/*****************************************************************************************
* @author       Slavko Skular
* @date         2016-02-07
* @description  Trigger on Oblix_User_Permission__c custom object
*				 - Keeps approvers on SOW records in synch with user permission table
*
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Slavko Skular              2016-02-07          Created

******************************************************************************************/
trigger Oblix_UserPermissionTrigger on Oblix_User_Permission__c (after insert, after update, after delete, after undelete) {
	TriggerFactory.createHandler(Oblix_User_Permission__c.sObjectType);
}