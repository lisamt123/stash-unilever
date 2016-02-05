/**
 * @author Shreyas Mangalvedhekar
 * @date 11/01/2016
 * @description - This Class is used to perform operation on before update event of CR  Trigger
 */
public class CPA_CR_TriggerUtil{
    public static boolean isSubmitted=false;
/*
    * Method Name : recallApproval
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform recall Approval process on CR record
    */
     public static void recallApproval(List<CPA_CR__c> CROldList,List<CPA_CR__c> newCRList)    
    { 
        List<ProcessInstanceWorkitem> piwiList = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem ];
        for (Integer i = 0; i < newCRList.size(); i++) {
            if((CROldList[i].pkl_Status__c  == 'Submitted' || CROldList[i].pkl_Status__c  == 'Resubmitted') && (newCRList[i].pkl_Status__c == 'Cancelled')){
                for(ProcessInstanceWorkitem piwi:piwiList){
                    if(piwi.ProcessInstance.TargetObjectId == newCRList[i].id && !isSubmitted ){ 
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
    * Method Name : submitforApproval
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform submit for  Approval process on CR record
    */
     public static void submitforApproval(List<CPA_CR__c> oldCRList,List<CPA_CR__c> newCRList)    
    {
             for (Integer i = 0; i < newCRList.size(); i++) {
            
        if ((oldCRList[i].pkl_Status__c  <> 'Submitted' &&   newCRList[i].pkl_Status__c == 'Submitted')|| (oldCRList[i].pkl_Status__c  <> 'Resubmitted' &&   newCRList[i].pkl_Status__c == 'Resubmitted') &&  !isSubmitted) {
             
            // create the new approval request to submit
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitted for approval. Please approve.');
            req.setObjectId(newCRList[i].Id);
            // submit the approval request for processing
            Approval.ProcessResult result = Approval.process(req);
            // display if the reqeust was successful

            isSubmitted = true;
        }
 
    }
    }
    
    /*
    * Method Name : previouStatusValue
    * Parameter   : 
    * Return type : None
    * Description : This method store the previous value of the CR Status field
    */
    public static void previouStatusValue(List<CPA_CR__c> oldCRList,List<CPA_CR__c> newCRList){
        for (Integer i = 0; i < newCRList.size(); i++) {            
            newCRList[i].txt_Previous_Status_Value__c  = oldCRList[i].pkl_Status__c; 
        }
    }
    
 /*
    * Method Name : CreateCR
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform Create CNF as per Rule AC.11.01.01
    */
    public static void CreateCR (List<CPA_CR__c > newCNFList){
        set<Id> setPWOID = new set<ID>();
        map<Id,CPA_project_work_order__c> mapPWO  = new map <ID,CPA_project_work_order__c>();
        for(CPA_CR__c objCR : newCNFList){
            setPWOID.add(objCR.CPA_Project_Work_Order__c);
        }
        for(CPA_project_work_order__c objPWO : [Select Id,pkl_Status__c from CPA_project_work_order__c where Id IN: setPWOID]){
           /* if(objPWO.chk_isCNF_TNF__c == true){
                objPWO.addError('CR cant be created, because CNF is created ');             
            }*/
            mapPWO.put(objPWO.Id,objPWO);
            
        }   
         for(CPA_CR__c objCR : newCNFList){
            if(mapPWO.get(objCR.CPA_Project_Work_Order__c)!= null && (mapPWO.get(objCR.CPA_Project_Work_Order__c).pkl_Status__c == 'Sent For Closure' || mapPWO.get(objCR.CPA_Project_Work_Order__c).pkl_Status__c == 'Closed')){
                objCR.addError('CR cant be created, because PWO is under Closure');  
            }else if(mapPWO.get(objCR.CPA_Project_Work_Order__c)!= null && (mapPWO.get(objCR.CPA_Project_Work_Order__c).pkl_Status__c == 'Sent For Termination' || mapPWO.get(objCR.CPA_Project_Work_Order__c).pkl_Status__c == 'Terminated' || mapPWO.get(objCR.CPA_Project_Work_Order__c).pkl_Status__c == 'Request For Termination')){
                objCR.addError('CR cant be created, because PWO is under Termination');
            }else if(mapPWO.get(objCR.CPA_Project_Work_Order__c)!= null && (mapPWO.get(objCR.CPA_Project_Work_Order__c).pkl_Status__c == 'Cancelled')){
                  objCR.addError('CR cant be created, because PWO is Cancelled');
            } 
        }
     }   
public static void checklistValueOfCR(List<CPA_CR__c> newCR){
        
        set<Id> setPWO = new set<ID>();
        map<Id,CPA_project_work_order__c> mapPWO = new map<ID,CPA_project_work_order__c>();
        
        for(CPA_CR__c objnewCR : newCR){
                setPWO.add(objnewCR.CPA_Project_Work_Order__c);
            }
        for(CPA_project_work_order__c objPwo : [select id, txt_Unilever_Reference__c,fml_Unilever_Project_Name_on_PWORF__c,lkp_Unilever_budget_approver__c,lkp_Unilever_content_approver__c,mpkl_Project_Phases__c,pkl_Region__c from CPA_project_work_order__c where ID  IN: setPWO]){
                mapPWO.put(objPwo.Id,objPwo);
            }
            
        for(CPA_CR__c objnewCR : newCR){
            CPA_project_work_order__c objPWOTemp = mapPWO.get(objnewCR.CPA_Project_Work_Order__c);
            if(objPWOTemp !=null){
                if(objnewCR.txt_Unilever_Reference__c == null && objPWOTemp.txt_Unilever_Reference__c !=null) 
                    objnewCR.txt_Unilever_Reference__c = objPWOTemp.txt_Unilever_Reference__c;
                if(objnewCR.txta_Unilever_Project_Name__c == null && objPWOTemp.fml_Unilever_Project_Name_on_PWORF__c !=null) 
                    objnewCR.txta_Unilever_Project_Name__c = objPWOTemp.fml_Unilever_Project_Name_on_PWORF__c;
                if(objnewCR.lkp_Unilever_budget_approver__c == null && objPWOTemp.lkp_Unilever_budget_approver__c !=null) 
                    objnewCR.lkp_Unilever_budget_approver__c = objPWOTemp.lkp_Unilever_budget_approver__c;
                if(objnewCR.lkp_Unilever_content_approver__c == null && objPWOTemp.lkp_Unilever_content_approver__c !=null)
                    objnewCR.lkp_Unilever_content_approver__c = objPWOTemp.lkp_Unilever_content_approver__c;
                if(objnewCR.pkl_Project_Phases__c == null && objPWOTemp.mpkl_Project_Phases__c !=null)
                    objnewCR.pkl_Project_Phases__c = objPWOTemp.mpkl_Project_Phases__c;
                if(objnewCR.Region_impacted__c   == null && objPWOTemp.pkl_Region__c !=null)
                    objnewCR.Region_impacted__c  = objPWOTemp.pkl_Region__c;
                if(objnewCR.pkl_Project_Phases__c !=null && !objnewCR.pkl_Project_Phases__c.containsOnly(objPWOTemp.mpkl_Project_Phases__c)) 
                        objnewCR.addError('Only ' + objPWOTemp.mpkl_Project_Phases__c.replaceAll(';', ', ') + ' Project Phases are allow');
                if(objnewCR.Region_impacted__c != null && objnewCR.Region_impacted__c != objPWOTemp.pkl_Region__c) 
                        objnewCR.addError('CR can be created for '+objPWOTemp.pkl_Region__c+ ' Region');
            }
        }
    }
/** Method Name : requireApprovalComments
    * Parameter   : newCRList
    * Return type : None
    * Author      : Pooja Kanani  
    * Description : This method make the Approval comments require
    */
    public static void requireApprovalComments(List<CPA_CR__c> newCRList){
 
  // Create a map that stores all the objects that require editing 
  Map<Id, CPA_CR__c> approvalStatements = new Map<Id, CPA_CR__c>{};

  for(CPA_CR__c inv: newCRList)
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
    
    for (CPA_CR__c invs : [SELECT (SELECT ID
                                              FROM ProcessInstances
                                              ORDER BY CreatedDate DESC
                                              LIMIT 1)
                                      FROM CPA_CR__c
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
/*
    * Method Name : unlockrecord
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform unlock record
    */
     public static void unlockrecord(List<CPA_CR__c> oldCRList,List<CPA_CR__c> newCR)    
    { system.debug('newCR>>>>>>>>>'+newCR);
        List<CPA_CR__c> cancelsetId = new List<CPA_CR__c>();
        for (Integer i = 0; i < newCR.size(); i++) {
            if((oldCRList[i].pkl_Status__c  == 'Submitted' || oldCRList[i].pkl_Status__c  == 'Resubmitted') && newCR[i].pkl_Status__c == 'Cancelled'){
                cancelsetId.add(newCR[i]);  
            }       
        }
        system.debug('cancelsetId>>>>>>>>>'+cancelsetId);
        if(cancelsetId !=null && cancelsetId.size()>0){
            Approval.unLockResult[] lrList = Approval.unlock(cancelsetId, false);           
        }
    }


    public static void calculateDelta(map<Id,CPA_CR__c> oldCRList,map<Id,CPA_CR__c> newCR){
        List<CPA_CR__c> lstCR = new List<CPA_CR__c>();
        set<ID>setPWOID = new set<ID>();
        List<CPA_Project_Work_Order__c>listPWO = new List<CPA_project_work_order__c>();
        map<Id,CPA_CR__c>mapPWOIDCR = new map<ID,CPA_CR__c>();
        map<Id,CPA_Project_Work_Order__c>mapPWO = new map<ID,CPA_Project_Work_Order__c>();
        
        for(CPA_CR__c objCR : newCR.values()){
            if(objCR.pkl_Status__c =='Submitted' && oldCRList.get(objCR.Id).pkl_Status__c <> 'Submitted'){
                lstCR.add(objCR);
                setPWOID.add(objCR.CPA_Project_Work_Order__c);
            }
        }
        
    List<CPA_project_work_order__c>lstPWO = [Select ID,num_Expense_charges_of_work_order__c,Name,num_Estimated_Man_days_of_PWO__c,num_Estimated_Value_of_PWO__c,num_Target_Blend_Rate__c,num_Total_work_order_charge__c,num_Authorisation_charges__c,num_Authorisation_man_days__c from CPA_project_work_order__c where ID IN :setPWOID];
        for(CPA_project_work_order__c objPwo : lstPWO){
            mapPWO.put(objPwo.Id,objPwo);
        }
            
    List<CPA_CR__c> lstCR1 = [Select Id,num_Delta_Efforts__c,Name,CPA_Project_Work_Order__c,num_Estimated_Man_days_of_CR__c,num_Estimated_Value_of_CR__c,num_Target_Blend_Rate__c,num_Total_charge_of_CR__c,num_Expense_charges_of_CR__c,pec_Expense__c,num_Authorisation_charges__c,num_Authorisation_man_days__c,num_RMS_value__c  from CPA_CR__c where CPA_Project_Work_Order__c IN:  setPWOID ORDER BY Createddate DESC limit 1];
        for(CPA_CR__c objCR1 : lstCR1){          
            mapPWOIDCR.put(objCR1.CPA_Project_Work_Order__c,objCR1);
        }
        
        for(CPA_CR__c objCRTEmp :lstCR ){
            if(mapPWOIDCR.get(objCRTEmp.CPA_Project_Work_Order__c)==null ){
                if(mapPWO.get(objCRTEmp.CPA_Project_Work_Order__c)!=null){
                    objCRTEmp.num_Delta_Efforts__c = objCRTEmp.num_Estimated_Value_of_CR__c - mapPWO.get(objCRTEmp.CPA_Project_Work_Order__c).num_Estimated_Value_of_PWO__c;
                }else{
                    objCRTEmp.num_Delta_Efforts__c = objCRTEmp.num_Estimated_Value_of_CR__c ;                   
                }
                 
            }else {
                if(mapPWOIDCR.get(objCRTEmp.CPA_Project_Work_Order__c)!=null){
                    objCRTEmp.num_Delta_Efforts__c =objCRTEmp.num_Estimated_Value_of_CR__c  - mapPWOIDCR.get(objCRTEmp.CPA_Project_Work_Order__c).num_Estimated_Value_of_CR__c;
                }else{
                    objCRTEmp.num_Delta_Efforts__c =0;
                }           
            
            }
        }
        
    }
}