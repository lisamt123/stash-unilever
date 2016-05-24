/**********************************************************************
Name: CPA_HLERequest_TriggerUtil()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to perform various operations for HLE request
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Pooja K       12/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_HLERequest_TriggerUtil{

    public static boolean isSubmitted = false;

    /*******************************************************************
    Purpose: This method is used to perform submit for  Approval process
    Parameters: oldHLEReqList, newHLEReqList
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void submitforApproval(List<CPA_HLE_Request__c> oldHLEReqList,List<CPA_HLE_Request__c> newHLEReqList){        
        for (Integer i = 0; i < newHLEReqList.size(); i++) {
            
            if ((oldHLEReqList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.SUBMITTED &&   newHLEReqList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.SUBMITTED)|| (oldHLEReqList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.RESUBMITTED &&   newHLEReqList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.RESUBMITTED) &&  !isSubmitted) {
                // create the new approval request to submit
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments(CPA_ConstantsForContractingAppClasses.SUBMITFORAPPROVAL);
                req.setObjectId(newHLEReqList[i].Id);
                // submit the approval request for processing
                Approval.ProcessResult result = Approval.process(req);
                // display if the reqeust was successful
                isSubmitted = true;
            }
         }
    }
    
    /*******************************************************************
    Purpose: This method is used to perform recall Approval process
    Parameters: oldHLEReqList, newHLEReqList
    Returns: 
    Throws [Exceptions]: 
    Modified - Added custom label to fix SonarQube issue (System.Label.CPA_Recall_and_Unlock)
    ********************************************************************/
    public static void recallApproval(List<CPA_HLE_Request__c> oldHLEReqList,List<CPA_HLE_Request__c> newHLEReqList)    
    { 
       set<ID> settempHLEreqID = new set<ID>();
       for(CPA_HLE_Request__c objHLEReqTemp: newHLEReqList){
            settempHLEreqID.add(objHLEReqTemp.Id);
        }
        List<ProcessInstanceWorkitem> piwiList = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem where ProcessInstance.TargetObjectId IN:settempHLEreqID  ];
        for (Integer i = 0; i < newHLEReqList.size(); i++) {
            if((oldHLEReqList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.SUBMITTED || oldHLEReqList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.RESUBMITTED) && (newHLEReqList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.CANCELLED)){
                for(ProcessInstanceWorkitem piwi:piwiList){
                    if(piwi.ProcessInstance.TargetObjectId == newHLEReqList[i].id && !isSubmitted ){ 
                        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                        req.setComments(System.Label.CPA_Recall_and_Unlock);
                        req.setAction(CPA_ConstantsForContractingAppClasses.REMOVED);
                        req.setWorkitemId(piwi.Id);
                        Approval.ProcessResult result =  Approval.process(req);
                        isSubmitted = true;
                    }
                }
            }
        }
    }
        
    /*******************************************************************
    Purpose: This method is used to perform unlock record
    Parameters: oldHLEReqList, newHLEReqList
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void unlockrecord(List<CPA_HLE_Request__c> oldHLEReqList,List<CPA_HLE_Request__c> newHLEReqList)    
    { 
        List<CPA_HLE_Request__c> cancelsetId = new List<CPA_HLE_Request__c>();
        for (Integer i = 0; i < newHLEReqList.size(); i++) {
            if((oldHLEReqList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.SUBMITTED || oldHLEReqList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.RESUBMITTED) && newHLEReqList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.CANCELLED){
                cancelsetId.add(newHLEReqList[i]);  
            }       
        }
        if(cancelsetId !=null && cancelsetId.size()>0){
            Approval.unLockResult[] lrList = Approval.unlock(cancelsetId, false);           
        }
    }

    /*******************************************************************
    Purpose: This method is used to update SLA data
    Parameters: oldHLEReqList, newHLEReqList
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void sLAValues(List<CPA_HLE_Request__c> oldHLEReqList,List<CPA_HLE_Request__c> newHLEReqList){
        CPA_HLE_Request_SLAs__c customSettingSLA = CPA_HLE_Request_SLAs__c.getInstance('SLA'); 
        for (Integer i = 0; i < newHLEReqList.size(); i++) {
             
             if (oldHLEReqList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.SUBMITTED &&   newHLEReqList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.SUBMITTED) {
                 newHLEReqList[i].dat_Submitted_Date__c = system.today();
             }
             if (oldHLEReqList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.RESUBMITTED &&   newHLEReqList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.RESUBMITTED){ 
                 newHLEReqList[i].dat_Resubmitted_Date__c = system.today();
             }
             if (oldHLEReqList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.ACCEPTED &&   newHLEReqList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.ACCEPTED){ 
                 newHLEReqList[i].Accepted_Date__c = system.today();
             }
            if ((oldHLEReqList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.SUBMITTED &&   newHLEReqList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.SUBMITTED)|| (oldHLEReqList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.RESUBMITTED &&   newHLEReqList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.RESUBMITTED)) {
                if(customSettingSLA.HLE_Request_SLA1__c!= null){ 
                    newHLEReqList[i].num_SLA1__c = customSettingSLA.HLE_Request_SLA1__c;
                }else {
                    newHLEReqList[i].num_SLA1__c = 0;
                }
                if(customSettingSLA.HLE_Request_SLA2__c!= null){ 
                    newHLEReqList[i].num_SLA2__c = customSettingSLA.HLE_Request_SLA2__c;
                }else {
                    newHLEReqList[i].num_SLA2__c = 0;
                }
            }
         }
    }

    /*******************************************************************
    Purpose: This method make the Approval comments require
    Parameters: newHLEReqList
    Returns: 
    Throws [Exceptions]: 
    Modified - Added custom label to fix SonarQube issue (System.Label.CPA_Operation_Cancelled)
    ********************************************************************/
    public static void requireApprovalComments(List<CPA_HLE_Request__c> newHLEReqList){
 
      // Create a map that stores all the objects that require editing 
      Map<Id, CPA_HLE_Request__c> approvalStatements = new Map<Id, CPA_HLE_Request__c>{};

      for(CPA_HLE_Request__c inv: newHLEReqList)
      {
        // Put all objects for update that require a comment check in a map,
        // so we only have to use 1 SOQL query to do all checks
        
        if (inv.pkl_Approval_Comment_Check__c == CPA_ConstantsForContractingAppClasses.REQUIRED)
        { 
          approvalStatements.put(inv.Id, inv);
          // Reset the field value to null, 
          // so that the check is not repeated,
          // next time the object is updated
          inv.pkl_Approval_Comment_Check__c = null; 
        }
      }  
       
      if (!approvalStatements.isEmpty())  
      {
        // If there are some approvals to be reviewed for approval, then
        // get the most recent process instance for each object.
        List<Id> processInstanceIds = new List<Id>{};
        
        for (CPA_HLE_Request__c invs : [SELECT (SELECT ID
                                                  FROM ProcessInstances
                                                  ORDER BY CreatedDate DESC
                                                  LIMIT 1)
                                          FROM CPA_HLE_Request__c
                                          WHERE ID IN :approvalStatements.keySet()])
        {
            processInstanceIds.add(invs.ProcessInstances[0].Id);
        }
          
        // Now that we have the most recent process instances, we can check
        // the most recent process steps for comments.  
        for (ProcessInstance pi : [SELECT TargetObjectId,
                                       (SELECT Id, StepStatus, Comments 
                                        FROM Steps
                                        ORDER BY CreatedDate DESC
                                        LIMIT 1 )
                                   FROM ProcessInstance
                                   WHERE Id IN :processInstanceIds
                                   ORDER BY CreatedDate DESC])
        {
          // If no comment exists, then prevent the object from saving.                 
          if ((pi.Steps[0].Comments == null || 
               pi.Steps[0].Comments.trim().length() == 0))
          {
              approvalStatements.get(pi.TargetObjectId).addError(System.Label.CPA_Operation_Cancelled);
            //approvalStatements.get(pi.TargetObjectId).addError(
            // 'Operation Cancelled: Please provide a reason ' + 
            // 'for your approval / rejection / Recall!');
          }
        }                                       
      }
    }
    
    /*******************************************************************
    Purpose: This method dont allow HLE to be deleted
    Parameters: lstHleReq
    Returns: 
    Throws [Exceptions]: 
    Modified - Added custom label to fix SonarQube issue - (System.Label.CPA_HLE_Request_cant_be_deleted)
    ********************************************************************/
    public static void DontDelete(list<CPA_HLE_Request__c> lstHleReq){
        for(CPA_HLE_Request__c obj :lstHleReq ){
            obj.addError(System.Label.CPA_HLE_Request_cant_be_deleted);
        }
    }
    
  /** Method Name : restricSMTULPMToAcceptReject
    * Parameter   : newHLEReqList,oldHLEReqList
    * Return type : None
    * Author      : Pooja Kanani  
    * Description : This method restric SMT/ULPM to accept/reject HLE request
    */
    public static void restricSMTULPMToAcceptReject(List<CPA_HLE_Request__c> newHLEReqList,List<CPA_HLE_Request__c> oldHLEReqList){
 
  // Create a map that stores all the objects that require editing 
  Map<Id, CPA_HLE_Request__c> approvalStatements = new Map<Id, CPA_HLE_Request__c>{};
  map<id,CPA_HLE_Request__c> mapOldMap = new map<Id,CPA_HLE_Request__c>();
  
  for(CPA_HLE_Request__c objTemp : oldHLEReqList)
  {
      mapOldMap.put(objTemp.Id,objTemp);
  }
  Boolean user_has_permission = false;              
    
        List<PermissionSetAssignment> lstcurrentUserPerSet =    [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() ];
        for ( PermissionSetAssignment psa : lstcurrentUserPerSet ) {
                string permission = psa.PermissionSet.Name;
                if (permission.CONTAINS(CPA_ConstantsForContractingAppClasses.CPAADM)){
                    user_has_permission = true;
                    break;
                }
            system.debug('permission>>'+permission);
            }
            system.debug('user_has_permission>>'+user_has_permission);
                    
            for(CPA_HLE_Request__c inv:newHLEReqList){ 
                if(!user_has_permission && ((inv.pkl_Status__c==CPA_ConstantsForContractingAppClasses.ACCEPTED && mapOldMap.get(inv.Id).pkl_Status__c!=CPA_ConstantsForContractingAppClasses.ACCEPTED)|| (inv.pkl_Status__c==CPA_ConstantsForContractingAppClasses.RETURNED && mapOldMap.get(inv.Id).pkl_Status__c!= CPA_ConstantsForContractingAppClasses.RETURNED))){
                    approvalStatements.put(inv.Id, inv);                     
                }
            }
        system.debug('approvalStatements>>'+approvalStatements);
  if (approvalStatements != null && !approvalStatements.isEmpty())  
  {
    // If there are some approvals to be reviewed for approval, then
    // get the most recent process instance for each object.
    List<Id> processInstanceIds = new List<Id>{};
    
    for (CPA_HLE_Request__c invs : [SELECT (SELECT ID
                                              FROM ProcessInstances
                                              ORDER BY CreatedDate DESC
                                              LIMIT 1)
                                      FROM CPA_HLE_Request__c
                                      WHERE ID IN :approvalStatements.keySet()])
    {
        processInstanceIds.add(invs.ProcessInstances[0].Id);
    }
      if(processInstanceIds!=null){  
    // Now that we have the most recent process instances, we can check
    // the most recent process steps for comments.  
    for (ProcessInstance pi : [SELECT TargetObjectId,
                                   (SELECT Id, StepStatus, Comments 
                                    FROM Steps
                                    ORDER BY CreatedDate DESC
                                    LIMIT 1 )
                               FROM ProcessInstance
                               WHERE Id IN :processInstanceIds
                               ORDER BY CreatedDate DESC])
    {       
      // If no comment exists, then prevent the object from saving.                 

           approvalStatements.get(pi.TargetObjectId).addError('<br/><br/><Strong style= "color:red">Error: </Strong><b>HLE request can be Accepted/Returned/Recall by Vendor only.<br/>Please raise a query with vendor for recalling this form using Query section. </b><br/><br/>');
       }
    }                                       
  }
}
}