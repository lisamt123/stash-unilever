/**********************************************************************
Name: SAM_Request_TriggerUtil()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to perform operation on before update event of RequestTrigger
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR                 DATE            DETAIL Description
1.0         Dineshisng Girase    18/07/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class SAM_Request_TriggerUtil{

    /*******************************************************************
    Purpose: If the request is other than Saved status, this method will prevent its delition
    Parameters: List of SAM_Request__c
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void PreventDelete(list<SAM_Request__c> lstRequest){
        //System.debug('lstRequest ##### ' + lstRequest);
        for(SAM_Request__c obj :lstRequest){
            System.debug('Status ##### ' + obj.pkl_Status__c);
            if(obj.pkl_Status__c != null && obj.pkl_Status__c != SAM_Constants.SAVED)
                obj.addError('You are not authorized to delete this record');
        }
    }
    
/*******************************************************************
    Purpose: SAM admin can only Assign the request to SAM team member
    Parameters: List of SAM_Request__c
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void PreventRequestAssignment(list<SAM_Request__c> lstRequest){
        Set<Id> AssigntoID = new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();

        for (GroupMember m : [Select Id, UserOrGroupId From GroupMember WHERE group.name = 'SAM Team']){
            if (((String)m.UserOrGroupId).startsWith(userType)){
                AssigntoID.add(m.UserOrGroupId);
            }
        }
        for(SAM_Request__c obj :lstRequest){
            if(obj.lkp_Assign_To__c != null && AssigntoID != null && !AssigntoID.contains(obj.lkp_Assign_To__c))
                obj.lkp_Assign_To__c.addError('You can only Assign the Request to a SAM team member');
        }
    }
/*******************************************************************
    Purpose: Request can not be modify after it is closed
    Parameters: List of SAM_Request__c
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void PreventEditAfterClose(list<SAM_Request__c> newlstRequest, list<SAM_Request__c> oldlstRequest){
        
        for(integer i = 0 ; i < newlstRequest.size(); i++){
            if(newlstRequest[i].pkl_Status__c != null && oldlstRequest[i].pkl_Status__c != null && newlstRequest[i].pkl_Status__c == SAM_Constants.CLOSED && oldlstRequest[i].pkl_Status__c == SAM_Constants.CLOSED)
                newlstRequest[i].addError('You can not modify the Closed Request');
        }
    } 

/*******************************************************************
    Purpose: Change the Request Status if Next Action Picklist value changed
    Parameters: List of SAM_Request__c
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void StatusUpdate(list<SAM_Request__c> newlstRequest, list<SAM_Request__c> oldlstRequest){
        
        for(integer i = 0 ; i < newlstRequest.size(); i++){
            newlstRequest[i].pkl_Status__c = newlstRequest[i].pkl_SAM_Requester_Status__c;                           
          /*  if(newlstRequest[i].pkl_SAM_Requester_Status__c != null && newlstRequest[i].pkl_SAM_Requester_Status__c <> oldlstRequest[i].pkl_SAM_Requester_Status__c )
            {
                newlstRequest[i].pkl_Status__c = newlstRequest[i].pkl_SAM_Requester_Status__c;                           
            }
            else if(newlstRequest[i].pkl_SAM_Finance_Status__c != null && newlstRequest[i].pkl_SAM_Finance_Status__c <> oldlstRequest[i].pkl_SAM_Finance_Status__c )
            {
                newlstRequest[i].pkl_Status__c = newlstRequest[i].pkl_SAM_Finance_Status__c;
            }
            else if(newlstRequest[i].pkl_SAM_team_Status__c != null && newlstRequest[i].pkl_SAM_team_Status__c <> oldlstRequest[i].pkl_SAM_team_Status__c )
            {
                if(newlstRequest[i].pkl_SAM_team_Status__c == 'On Hold')
                {
                    newlstRequest[i].txt_Status_Before_On_Hold__c = oldlstRequest[i].pkl_Status__c;
                    newlstRequest[i].pkl_Status__c = newlstRequest[i].pkl_SAM_team_Status__c;
                }
                else if(newlstRequest[i].pkl_SAM_team_Status__c == 'Resume')
                {
                    newlstRequest[i].pkl_Status__c = newlstRequest[i].txt_Status_Before_On_Hold__c;
                }
                else
                {
                    newlstRequest[i].pkl_Status__c = newlstRequest[i].pkl_SAM_team_Status__c; 
                }               
            }*/
           /* if(newlstRequest[i].pkl_Status__c != null && newlstRequest[i].pkl_Status__c <> oldlstRequest[i].pkl_Status__c ){
                newlstRequest[i].pkl_SAM_Requester_Status__c = null;
                newlstRequest[i].pkl_SAM_Finance_Status__c = null;
                newlstRequest[i].pkl_SAM_team_Status__c = null;
            }*/
                
        }
    } 
    /*******************************************************************
    Purpose: Reset all Next Action picklist values
    Parameters: List of SAM_Request__c
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void ResetNextActionPicklists(list<SAM_Request__c> newlstRequest, list<SAM_Request__c> oldlstRequest)
    {
        for(integer i = 0 ; i < newlstRequest.size(); i++)
        {
           if(newlstRequest[i].pkl_Status__c != null && newlstRequest[i].pkl_Status__c <> oldlstRequest[i].pkl_Status__c )
           {
                newlstRequest[i].pkl_SAM_Requester_Status__c = null;
                newlstRequest[i].pkl_SAM_Finance_Status__c = null;
                newlstRequest[i].pkl_SAM_team_Status__c = null;
           }
        }
    }
    /*******************************************************************
    Purpose: Request can not Closed without attaching buil details
    Parameters: List of SAM_Request__c
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void validationForBuildDetail(list<SAM_Request__c> newlstRequest, list<SAM_Request__c> oldlstRequest){
        Set<Id> requestId = new Set<Id>();
        Map<ID,List<Attachment>> Req_attch_Map = new Map<ID,List<Attachment>>();
		Map<ID,List<Attachment>> Req_attch_Approval_EmailsMap = new Map<ID,List<Attachment>>();
        for(SAM_Request__c obj :newlstRequest){
            requestId.add(obj.Id);
        }
        List<Attachment> lstAttachmentBuild_Details = [SELECT ContentType,Id,Name,ParentId  FROM Attachment WHERE Name LIKE 'Build_Details%' and ParentId IN:requestId];
        List<Attachment> lstAttachmentApproval_Emails = [SELECT ContentType,Id,Name,ParentId  FROM Attachment WHERE Name LIKE 'Approval_Emails%' and ParentId IN:requestId];
        for(Id objID : requestId){
            List<Attachment> lstTempd = new List<Attachment>();
			List<Attachment> lstTempdApproval_Emails = new List<Attachment>();
            for(Attachment objAttachment : lstAttachmentBuild_Details){
                if(objAttachment.ParentId == objID){
                    lstTempd.add(objAttachment);
                }
            }
            Req_attch_Map.put(objID,lstTempd);
			for(Attachment objAttachment : lstAttachmentApproval_Emails){
                if(objAttachment.ParentId == objID){
                    lstTempdApproval_Emails.add(objAttachment);
                }
            }
            Req_attch_Approval_EmailsMap.put(objID,lstTempdApproval_Emails);
			
        }
        for(integer i = 0 ; i < newlstRequest.size(); i++){   
            if(newlstRequest[i].rol_Build_detail_applicable__c>0 && oldlstRequest[i].pkl_Status__c != SAM_Constants.CLOSED && newlstRequest[i].pkl_Status__c == SAM_Constants.CLOSED){
                if(Req_attch_Map.get(newlstRequest[i].Id).size()<1){
                    newlstRequest[i].addError('You can not Closed the Request without attaching build details');
                }
                else{ 
                    for(Attachment objAttachment:Req_attch_Map.get(newlstRequest[i].Id)){
                        if(objAttachment == null){
                            newlstRequest[i].addError('You can not Closed the Request without attaching build details');
                        }
                    }
                }
            }
			if(oldlstRequest[i].pkl_Status__c != SAM_Constants.AWAITINGCHARGE && newlstRequest[i].pkl_Status__c == SAM_Constants.AWAITINGCHARGE){
				if(Req_attch_Approval_EmailsMap.get(newlstRequest[i].Id).size()<1){
                    newlstRequest[i].addError(' You can not Send the Request for  Cross charge without Budget and Invoice approval email attached with file name "Approval_Emails".');
                }
                else{ 
                    for(Attachment objAttachment:Req_attch_Approval_EmailsMap.get(newlstRequest[i].Id)){
                        if(objAttachment == null){
                            newlstRequest[i].addError(' You can not Send the Request for  Cross charge without Budget and Invoice approval email attached with file name "Approval_Emails".');
                        }
                    }
                }
				
			} 
        }
     }
}