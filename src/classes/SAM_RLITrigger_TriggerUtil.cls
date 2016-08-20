/**********************************************************************
Name: SAM_RLITrigger_TriggerUtil()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: This Class is used to perform operation on event of RLITrigger
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR                 DATE            DETAIL Description
1.0        Pooja Kanani         04/08/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class SAM_RLITrigger_TriggerUtil{

    /*******************************************************************
    Purpose: If the Request_Line_Item is other than Saved status, this method will prevent its deletion
    Parameters: List of SAM_Request_Line_Item__c
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void PreventDelete(list<SAM_Request_Line_Item__c> lstRequest){
        for(SAM_Request_Line_Item__c obj :lstRequest){
            if(obj.pkl_Request_Status__c != null && obj.pkl_Request_Status__c != SAM_Constants.SAVED){
                obj.addError('You are not authorized to delete this record');
            }
        }
    }
    /*******************************************************************
    Purpose: If the Request_Line_Item is other than Saved status, this method will prevent its new Product insert
    Parameters: List of SAM_Request_Line_Item__c
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void PreventNewRecord(list<SAM_Request_Line_Item__c> lstRequest){
        Profile ProfileName = [select Name from profile where id = :userinfo.getProfileId()];
        //if(ProfileName.Name != SAM_Constants.SYSTEM_ADMINISTRATOR){
            Set<Id> ReqID = new Set<Id>(); 
            Map<ID,SAM_Request__c> mapReqIDRecord = new Map<ID,SAM_Request__c>();
            for(SAM_Request_Line_Item__c obj :lstRequest){
                ReqID.add(obj.md_Request_ID__c);
            }
            List<SAM_Request__c> ReqList = [Select id,CreatedById,pkl_Status__c from SAM_Request__c where id=:ReqID];
            for(SAM_Request__c req:ReqList ){
                mapReqIDRecord.put(req.Id,req);
            }
            for(SAM_Request_Line_Item__c obj :lstRequest){
                SAM_Request__c requestRec = mapReqIDRecord.get(obj.md_Request_ID__c);
                if(Userinfo.getUserId() != null && requestRec.CreatedById  != null && (requestRec.CreatedById != Userinfo.getUserId() || (requestRec.pkl_Status__c != SAM_Constants.SAVED && requestRec.pkl_Status__c != SAM_Constants.AWAITINGINFORMATION ))){
                    obj.addError('You are not authorized to add this Product at this status.');
                }
            }
       // }
    }
}