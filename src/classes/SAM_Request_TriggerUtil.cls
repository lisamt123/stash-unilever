/**********************************************************************
Name: SAM_Request_TriggerUtil()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: This Class is used to perform operation on event of RequestTrigger
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
    public static void PreventRequestAssignment(list<SAM_Request__c> lstRequest,list<SAM_Request__c> OldlstRequest){
        Set<Id> AssigntoID = new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();

        for (GroupMember m : [Select Id, UserOrGroupId From GroupMember WHERE group.name = 'SAM Team']){
            if (((String)m.UserOrGroupId).startsWith(userType)){
                AssigntoID.add(m.UserOrGroupId);
            }
        }
        for(integer i = 0 ; i < lstRequest.size(); i++){
            if(lstRequest[i].lkp_Assign_To__c != null && OldlstRequest[i].lkp_Assign_To__c <> lstRequest[i].lkp_Assign_To__c && AssigntoID != null && !AssigntoID.contains(lstRequest[i].lkp_Assign_To__c))
               lstRequest[i].lkp_Assign_To__c.addError('You can only Assign the Request to a SAM team member');
            
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
            if(
               (newlstRequest[i].rol_Build_detail_applicable__c>0 || newlstRequest[i].pkl_Build_details_applicable__c == 'Yes')&& 
                oldlstRequest[i].pkl_SAM_team_Status__c != SAM_Constants.CLOSED && 
                newlstRequest[i].pkl_SAM_team_Status__c == SAM_Constants.CLOSED 
               )
            {
                if(Req_attch_Map.get(newlstRequest[i].Id).size()<1){
                    newlstRequest[i].addError('You can not Close the Request without attaching build details with file name "Build_Details"');
                }
                else{ 
                    for(Attachment objAttachment:Req_attch_Map.get(newlstRequest[i].Id)){
                        if(objAttachment == null){
                            newlstRequest[i].addError('You can not Close the Request without attaching build details with file name "Build_Details"');
                        }
                    }
                }
            }
            if(newlstRequest[i].txt_Request_Type__c == SAM_Constants.SAM_RW_PROJECT_REQUEST && oldlstRequest[i].pkl_SAM_team_Status__c != SAM_Constants.AWAITINGCHARGE && newlstRequest[i].pkl_SAM_team_Status__c == SAM_Constants.AWAITINGCHARGE){
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
     
     /*******************************************************************
    Purpose: Method to get list of publishers
    Parameters: List of SAM_Request__c
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
   /*  public static void collectPublishers(list<SAM_Request__c> newlstRequest){
    
   system.debug('Inside Publisher!!!!!!!!!!!!!!!!!');
        Set<Id> requestIdSet = new Set<Id>();
        Set<String> publisherNameSet ;
        List<String> publisherNameList ;
        List<SAM_Request__c> requestFinalList = new List<SAM_Request__c>();
        for(SAM_Request__c obj :newlstRequest){
            requestIdSet.add(obj.Id);
        }
        List<SAM_Request_Line_Item__c> productDetailList = [select id,Name,md_Request_ID__c  from SAM_Request_Line_Item__c where md_Request_ID__c IN: requestIdSet];
        for(SAM_Request__c obj:newlstRequest){
        system.debug('obj.pkl_Status__c!!'+obj.pkl_Status__c+'obj.Id!!'+obj.Id);
        if(obj.pkl_Status__c == 'Quote Approved'){
      //  String publisherNameStr ='';
        publisherNameList = new List<String>();
        publisherNameSet = new Set<String>();
            for(SAM_Request_Line_Item__c ReqLineObj:productDetailList){
        
                 if(obj.Id == ReqLineObj.md_Request_ID__c){
                
                publisherNameSet.add(ReqLineObj.Name);
                }
            }
            system.debug('publisherNameSet!!!'+publisherNameSet);
            
            publisherNameList.addAll(publisherNameSet);
            
            for(String str:publisherNameList){
                publisherNameStr = str+','+publisherNameStr;
            }
            String publisherNameStr = String.Join(new List<String>(publisherNameList),',');
            system.debug('publisherNameStr!!!'+publisherNameStr);
            obj.txt_Sam_Publisher__c= publisherNameStr;
            requestFinalList.add(obj);
            system.debug('requestFinalList!!!!'+requestFinalList);
        }
        
     }
     
    }*/
}