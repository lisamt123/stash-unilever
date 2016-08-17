/**********************************************************************
Name: SAM_Request_GroupMemberShipUtils()
Copyright © 2016 Salesforce
======================================================
======================================================
======================================================
History
-------
VERSION     AUTHOR               DATE            DETAIL Description
1.0         Alok Kumar          19/07/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class SAM_Request_GroupMemberShipUtils {

    /*******************************************************************
    Purpose: This method identifies members from public group
    InvokedBy:Process Builder : SAM Get User Public Groups and Set Requester field
    Parameters: List<string>
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    @InvocableMethod
    public static void GetPublicGroups(List<string> recIds)
    {
     List<string> createdByIds = new List<string>();
     try
     {
        List<SAM_Request__c> requests = [Select Id,CreatedById,ltxt_User_Public_Groups__c From SAM_Request__c where Id in :recIds];
        for(SAM_Request__c request : requests)
        {
            createdByIds.Add(request.CreatedById);
        }
        List<GroupMember> UserGroups = [SELECT UserOrGroupId,Group.DeveloperName FROM GroupMember WHERE UserOrGroupId in :createdByIds];        
        for(SAM_Request__c request : requests)
        {
            request.ltxt_User_Public_Groups__c = '';
            for(GroupMember memberGroup : UserGroups)
            {
                if(memberGroup.UserOrGroupId == request.CreatedById)
                {
                    request.ltxt_User_Public_Groups__c = request.ltxt_User_Public_Groups__c + ',' + memberGroup.Group.DeveloperName;
                }
            }
        }        
        Update requests;
     }
    catch(Exception e)
    {
        System.debug('User Public Groups could NOT be fetched because of error : ' + e.getMessage());
    }
    }
}