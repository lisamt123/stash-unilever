/**
 * @author Shreyas Mangalvedhekar
 * @date 11/01/2016
 * @description - This Class is used to perform operation on before update event of LOI Trigger
 */
public with sharing class CPA_LOI_TriggerUtil{
    public static boolean isSubmitted=false;
/*
    * Method Name : recallApproval
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform recall Approval process on PWO record
    */
     public static void recallApproval(List<CPA_LOI__c> LOIOldList,List<CPA_LOI__c> newLOIList)    
    { 
        List<ProcessInstanceWorkitem> piwiList = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem ];
        for (Integer i = 0; i < newLOIList.size(); i++) {
            if((LOIOldList[i].pkl_Status__c  == ConstantsForContractingAppClasses.SUBMITTED || LOIOldList[i].pkl_Status__c  == ConstantsForContractingAppClasses.RESUBMITTED) && (newLOIList[i].pkl_Status__c == ConstantsForContractingAppClasses.CANCELLED)){
                for(ProcessInstanceWorkitem piwi:piwiList){
                    if(piwi.ProcessInstance.TargetObjectId == newLOIList[i].id && !isSubmitted ){ 
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
    * Description : This method is used to perform submit for  Approval process on PWO record
    */
     public static void submitforApproval(List<CPA_LOI__c> oldLOIList,List<CPA_LOI__c> newLOIList)    
    {
       set<Id> setPworfId = new set<Id>();
       List<CPA_PWORF__c> lstPWORF = new List<CPA_PWORF__c>();
       
       for (Integer i = 0; i < newLOIList.size(); i++) {
            
        if ((oldLOIList[i].pkl_Status__c  <> ConstantsForContractingAppClasses.SUBMITTED &&   newLOIList[i].pkl_Status__c == ConstantsForContractingAppClasses.SUBMITTED)|| (oldLOIList[i].pkl_Status__c  <> ConstantsForContractingAppClasses.RESUBMITTED &&   newLOIList[i].pkl_Status__c == ConstantsForContractingAppClasses.RESUBMITTED) &&  !isSubmitted) {
             
            // create the new approval request to submit
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitted for approval. Please approve.');
            req.setObjectId(newLOIList[i].Id);
            // submit the approval request for processing
            Approval.ProcessResult result = Approval.process(req);
            // display if the reqeust was successful

            isSubmitted = true;
        }else if(oldLOIList[i].pkl_Status__c  <> ConstantsForContractingAppClasses.CANCELLED &&   newLOIList[i].pkl_Status__c == ConstantsForContractingAppClasses.CANCELLED){
                setPworfId.add(newLOIList[i].lkp_PWORF__c);
        }
 
        }
        if(setPworfId !=null && setPworfId.size()>0){
                for(CPA_PWORF__c objPWORF :[select id,chk_LOI_Cancelled__c from CPA_PWORF__c where ID IN:setPworfId]){
                    if(objPWORF.chk_LOI_Cancelled__c != true){
                        objPWORF.chk_LOI_Cancelled__c = true;
                        lstPWORF.add(objPWORF);
                    }               
            }
            if(lstPWORF!=null && lstPWORF.size()>0){                
                        update lstPWORF;
                    }
            }
    
    }
    
    public static void checkforCancel (List<CPA_LOI__c> newList){
        
        set<ID> setPWORFId = new set<Id>();
        
        for(CPA_LOI__c objLOI : newList){
            setPWORFId.add(objLOI.lkp_PWORF__c);
        }
        
        List<CPA_PWORF__c> listPworf = [Select Id,chk_LOI_Cancelled__c from CPA_PWORF__c where ID IN:setPWORFId AND chk_LOI_Cancelled__c =true ];
        
        for(CPA_LOI__c obj : newList){
            for(CPA_PWORF__c objPWORF :listPworf ){
                if(obj.lkp_PWORF__c == objPWORF.Id  )
                if(Test.isrunningtest()!=true){
                    //obj.addError('LOI is already cancelled so its not possible to create another LOI, Please respond with PWO.'); 
                    obj.addError('This PWORF contains a Cancelled LOI so its not possible to create another LOI, Please respond with PWO.'); 
                    }               
            }
        }
    }
    
    public static void checklistValueOfLOI(List<CPA_LOI__c> newLOI){
        
        set<Id> setPWORF = new set<ID>();
        map<Id,CPA_PWORF__c> mapPWORF = new map<ID,CPA_PWORF__c>();
        
        for(CPA_LOI__c objNewLOI : newLOI){
                setPWORF.add(objNewLOI.lkp_PWORF__c);
            }
        for(CPA_PWORF__c objPworf : [select id,RecordTypeId ,mpkl_Project_Phases__c,lkp_Unilever_budget_approver__c,lkp_Unilever_content_approver__c,txt_Clarity_ID__c from CPA_PWORF__c where ID  IN: setPWORF]){
                mapPWORF.put(objPworf.Id,objPworf);
            }
            
        for(CPA_LOI__c objNewLOI : newLOI){
            CPA_PWORF__c objPWORFTemp = mapPWORF.get(objNewLOI.lkp_PWORF__c);
            if(objPWORFTemp !=null){
                if(objNewLOI.txt_Unilever_Clarity_ID__c == null && objPWORFTemp.txt_Clarity_ID__c !=null) 
                    objNewLOI.txt_Unilever_Clarity_ID__c = objPWORFTemp.txt_Clarity_ID__c;
                if(objNewLOI.lkp_Unilever_budget_approver__c == null && objPWORFTemp.lkp_Unilever_budget_approver__c !=null) 
                    objNewLOI.lkp_Unilever_budget_approver__c = objPWORFTemp.lkp_Unilever_budget_approver__c;
                if(objNewLOI.lkp_Unilever_content_approver__c == null && objPWORFTemp.lkp_Unilever_content_approver__c !=null) 
                    objNewLOI.lkp_Unilever_content_approver__c = objPWORFTemp.lkp_Unilever_content_approver__c;
                if(objNewLOI.mpkl_Phases_covered_by_WAR__c == null && objPWORFTemp.mpkl_Project_Phases__c !=null)
                    objNewLOI.mpkl_Phases_covered_by_WAR__c = objPWORFTemp.mpkl_Project_Phases__c;
                string AllrecordType = CPA_PWORF_Record_type__c.getValues('All').Record_type_id__c;
                if(objPWORFTemp.RecordTypeId == AllrecordType && objNewLOI.mpkl_Phases_covered_by_WAR__c!=null && !objNewLOI.mpkl_Phases_covered_by_WAR__c.containsOnly(objPWORFTemp.mpkl_Project_Phases__c)) 
                        objNewLOI.addError('Only ' + objPWORFTemp.mpkl_Project_Phases__c.replaceAll(';', ', ') + ' Project Phases are allow');
            }
        }
    }
/** Method Name : requireApprovalComments
    * Parameter   : newLOIList
    * Return type : None
    * Author      : Pooja Kanani  
    * Description : This method make the Approval comments require
    */
    public static void requireApprovalComments(List<CPA_LOI__c> newLOIList){
 
      // Create a map that stores all the objects that require editing 
      Map<Id, CPA_LOI__c> approvalStatements = new Map<Id, CPA_LOI__c>{};

      for(CPA_LOI__c inv: newLOIList)
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
        
        for (CPA_LOI__c invs : [SELECT (SELECT ID
                                                  FROM ProcessInstances
                                                  ORDER BY CreatedDate DESC
                                                  LIMIT 1)
                                          FROM CPA_LOI__c
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
/** Method Name : cancelAllLOI
    * Parameter   : newLOIList
    * Return type : None
    * Author      : Pooja Kanani  
    * Description : This method cancel all LOI
    */
    public static void cancelAllLOI(List<CPA_LOI__c> newLOI){
        set<Id> setPWORF = new set<ID>();
        system.debug('newLOI>>>>>>>>'+newLOI);
        for(CPA_LOI__c objNewLOI : newLOI){
            if(objNewLOI.pkl_Status__c == ConstantsForContractingAppClasses.CANCELLED){
                system.debug('objNewLOI.pkl_Status__c >>>>>>>>'+objNewLOI.pkl_Status__c );
                setPWORF.add(objNewLOI.lkp_PWORF__c);
            }
        }
        system.debug('pooja>>>>>>>>>>'+[select id,pkl_Status__c from CPA_LOI__c where lkp_PWORF__c  IN: setPWORF and pkl_Status__c !=: ConstantsForContractingAppClasses.CANCELLED]);
        for(CPA_LOI__c objLoi : [select id,pkl_Status__c from CPA_LOI__c where lkp_PWORF__c  IN: setPWORF and pkl_Status__c !=: ConstantsForContractingAppClasses.CANCELLED]){
            system.debug('objLoi>>>>>>>>>>'+objLoi);
                objLoi.pkl_Status__c = ConstantsForContractingAppClasses.CANCELLED;
                system.debug('objLoi.pkl_Status__c >>>>>>>>'+objLoi.pkl_Status__c );
                update objLoi;
            }
    }
    
    /** Method Name : internalLIOID
    * Parameter   : newLOI
    * Return type : None
    * Author      : Dinesh Girase  
    * Description : This method creates Internal LOI ID, used for search purpose
    */
    public static void internalLIOID(List<CPA_LOI__c> newLOI){
        List<AggregateResult> lstLOI = [SELECT count(ID) newCount FROM CPA_LOI__c];
        if(lstLOI[0].get('newCount') != null){
            Integer maxNo = Integer.valueOf(lstLOI[0].get('newCount') + '');
            String newInternalPWOID = getInternalPWOID(maxNo);
            System.debug('newInternalPWOID  ######## : ' + newInternalPWOID );
            newLOI[0].txt_Internal_LOI_ID__c = newInternalPWOID;
            System.debug('txt_Internal_LOI_ID__c ######## : ' + newInternalPWOID);
            List<CPA_PWORF__c> pworfs = [SELECT For_Search__c FROM CPA_PWORF__c Where Id =: newLOI[0].lkp_PWORF__c];
            if(pworfs[0].For_Search__c != null){
                String test = pworfs[0].For_Search__c;
                System.debug('LOI Search ######## : ' + pworfs[0].For_Search__c);
                pworfs[0].For_Search__c = test + ', ' + newInternalPWOID;
                update pworfs;
            }
        }
    }
    
    /**   Method Name : getInternalPWOID
    * Parameter   : numSearch
    * Return type : String
    * Author      : Dinesh Girase  
    * Description : This method generates incremental Internal LOI ID
    */
    public static String getInternalPWOID(Integer numSearch){
        String strPWOID='';
        integer intIncrementNum = numSearch + 1;
        if(string.valueof(numSearch).length() == 1)
            strPWOID = 'LOI-0000' + string.valueof(intIncrementNum);
        if(string.valueof(numSearch).length() == 2)
            strPWOID = 'LOI-000' + string.valueof(intIncrementNum);
        if(string.valueof(numSearch).length() == 3)
            strPWOID = 'LOI-00' + string.valueof(intIncrementNum);
        if(string.valueof(numSearch).length() == 4)
            strPWOID = 'LOI-0' + string.valueof(intIncrementNum);
        if(string.valueof(numSearch).length() == 5)
            strPWOID = 'LOI-' + string.valueof(intIncrementNum);
        return strPWOID;
    }
}