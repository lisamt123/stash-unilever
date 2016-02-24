/**
 * @Author Dinesh Girase
 * @date 12/01/2016
 * @description - This Class is used to perform various operations for HLE request
 */
public class CPA_HLERequest_TriggerUtil{

    public static boolean isSubmitted = false;

    /*
    * Method Name : submitforApproval
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform submit for  Approval process
    */

    public static void submitforApproval(List<CPA_HLE_Request__c> oldHLEReqList,List<CPA_HLE_Request__c> newHLEReqList){        
        for (Integer i = 0; i < newHLEReqList.size(); i++) {
            
            if ((oldHLEReqList[i].pkl_Status__c  <> ConstantsForContractingAppClasses.SUBMITTED &&   newHLEReqList[i].pkl_Status__c == ConstantsForContractingAppClasses.SUBMITTED)|| (oldHLEReqList[i].pkl_Status__c  <> ConstantsForContractingAppClasses.RESUBMITTED &&   newHLEReqList[i].pkl_Status__c == ConstantsForContractingAppClasses.RESUBMITTED) &&  !isSubmitted) {
                // create the new approval request to submit
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitted for approval. Please approve.');
                req.setObjectId(newHLEReqList[i].Id);
                // submit the approval request for processing
                Approval.ProcessResult result = Approval.process(req);
                // display if the reqeust was successful
    
                isSubmitted = true;
            }
         }
    }
  /*
    * Method Name : recallApproval
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform recall Approval process
    */
     public static void recallApproval(List<CPA_HLE_Request__c> oldHLEReqList,List<CPA_HLE_Request__c> newHLEReqList)    
    { 
       set<ID> settempHLEreqID = new set<ID>();
       for(CPA_HLE_Request__c objHLEReqTemp: newHLEReqList){
            
            settempHLEreqID.add(objHLEReqTemp.Id);
        }
        List<ProcessInstanceWorkitem> piwiList = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem where ProcessInstance.TargetObjectId IN:settempHLEreqID  ];
        for (Integer i = 0; i < newHLEReqList.size(); i++) {
            if((oldHLEReqList[i].pkl_Status__c  == ConstantsForContractingAppClasses.SUBMITTED || oldHLEReqList[i].pkl_Status__c  == ConstantsForContractingAppClasses.RESUBMITTED) && (newHLEReqList[i].pkl_Status__c == 'Cancelled')){
                for(ProcessInstanceWorkitem piwi:piwiList){
                    if(piwi.ProcessInstance.TargetObjectId == newHLEReqList[i].id && !isSubmitted ){ 
                        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                        req.setComments('Recalling and unlocking request.');
                        req.setAction('Removed');
                        req.setWorkitemId(piwi.Id);
                        Approval.ProcessResult result =  Approval.process(req);
                        isSubmitted = true;
                    }
                }
            }
        }
    }    
 /*
    * Method Name : unlockrecord
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform unlock record
    */
     public static void unlockrecord(List<CPA_HLE_Request__c> oldHLEReqList,List<CPA_HLE_Request__c> newHLEReqList)    
    { 
        List<CPA_HLE_Request__c> cancelsetId = new List<CPA_HLE_Request__c>();
        for (Integer i = 0; i < newHLEReqList.size(); i++) {
            if((oldHLEReqList[i].pkl_Status__c  == ConstantsForContractingAppClasses.SUBMITTED || oldHLEReqList[i].pkl_Status__c  == ConstantsForContractingAppClasses.RESUBMITTED) && newHLEReqList[i].pkl_Status__c == 'Cancelled'){
                cancelsetId.add(newHLEReqList[i]);  
            }       
        }
        if(cancelsetId !=null && cancelsetId.size()>0){
            Approval.unLockResult[] lrList = Approval.unlock(cancelsetId, false);           
        }
    }
/*
    * Method Name : sLAValues
    * Parameter   : 
    * Return type : None
    * Description : This method is used to update SLA data 
    */

    public static void sLAValues(List<CPA_HLE_Request__c> oldHLEReqList,List<CPA_HLE_Request__c> newHLEReqList){
        CPA_HLE_Request_SLAs__c customSettingSLA = CPA_HLE_Request_SLAs__c.getInstance('SLA'); 
        //system.debug('customSettingSLA>' +customSettingSLA );     
        for (Integer i = 0; i < newHLEReqList.size(); i++) {
             //system.debug('oldHLEReqList[i].pkl_Status__c'+oldHLEReqList[i].pkl_Status__c);
             if (oldHLEReqList[i].pkl_Status__c  <> ConstantsForContractingAppClasses.SUBMITTED &&   newHLEReqList[i].pkl_Status__c == ConstantsForContractingAppClasses.SUBMITTED) newHLEReqList[i].dat_Submitted_Date__c = system.today();
             if (oldHLEReqList[i].pkl_Status__c  <> ConstantsForContractingAppClasses.RESUBMITTED &&   newHLEReqList[i].pkl_Status__c == ConstantsForContractingAppClasses.RESUBMITTED) newHLEReqList[i].dat_Resubmitted_Date__c = system.today();
             if (oldHLEReqList[i].pkl_Status__c  <> 'Accepted' &&   newHLEReqList[i].pkl_Status__c == 'Accepted') newHLEReqList[i].Accepted_Date__c = system.today();
            if ((oldHLEReqList[i].pkl_Status__c  <> ConstantsForContractingAppClasses.SUBMITTED &&   newHLEReqList[i].pkl_Status__c == ConstantsForContractingAppClasses.SUBMITTED)|| (oldHLEReqList[i].pkl_Status__c  <> ConstantsForContractingAppClasses.RESUBMITTED &&   newHLEReqList[i].pkl_Status__c == ConstantsForContractingAppClasses.RESUBMITTED)) {
                if(customSettingSLA.HLE_Request_SLA1__c!= null) newHLEReqList[i].num_SLA1__c = customSettingSLA.HLE_Request_SLA1__c;
                else newHLEReqList[i].num_SLA1__c = 0;
                if(customSettingSLA.HLE_Request_SLA2__c!= null) newHLEReqList[i].num_SLA2__c = customSettingSLA.HLE_Request_SLA2__c;
                else newHLEReqList[i].num_SLA2__c = 0;
                 //system.debug('newHLEReqList[i].num_SLA2__c'+newHLEReqList[i].num_SLA2__c);
            }
         }
    }
/** Method Name : requireApprovalComments
    * Parameter   : newHLEReqList
    * Return type : None
    * Author      : Pooja Kanani  
    * Description : This method make the Approval comments require
    */
    public static void requireApprovalComments(List<CPA_HLE_Request__c> newHLEReqList){
 
      // Create a map that stores all the objects that require editing 
      Map<Id, CPA_HLE_Request__c> approvalStatements = new Map<Id, CPA_HLE_Request__c>{};

      for(CPA_HLE_Request__c inv: newHLEReqList)
      {
        // Put all objects for update that require a comment check in a map,
        // so we only have to use 1 SOQL query to do all checks
        
        if (inv.Approval_Comment_Check__c == 'Required')
        { 
          approvalStatements.put(inv.Id, inv);
          // Reset the field value to null, 
          // so that the check is not repeated,
          // next time the object is updated
          inv.Approval_Comment_Check__c = null; 
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
            approvalStatements.get(pi.TargetObjectId).addError(
             'Operation Cancelled: Please provide a reason ' + 
             'for your approval / rejection / Recall!');
          }
        }                                       
      }
    }
    
    
    /**   Method Name : DOntDelete
    * Parameter   : OldMap
    * Return type : void
    * Author      : JP
    * Description : This method dont allow HLE to be deleted
    */
    public static void DontDelete(list<CPA_HLE_Request__c> lstHleReq){
        
        for(CPA_HLE_Request__c obj :lstHleReq ){
            obj.addError('HLE Request cant be deleted');
        }
    }
}