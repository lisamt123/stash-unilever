/**********************************************************************
Name: CPA_LOI_TriggerUtil()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to perform operation on before update event of LOI Trigger
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR                     DATE            DETAIL Description
1.0         Shreyas Mangalvedhekar     11/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_LOI_TriggerUtil{
    public static boolean isSubmitted=false;
    /**
    * Method Name : recallApproval
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform recall Approval process on PWO record
    */
     public static void recallApproval(List<CPA_LOI__c> LOIOldList,List<CPA_LOI__c> newLOIList)    
    { 
        set<ID> settempLOIID = new set<ID>();
       for(CPA_LOI__c objLOITemp: newLOIList){
            
            settempLOIID.add(objLOITemp.Id);
        }
        List<ProcessInstanceWorkitem> piwiList = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem where ProcessInstance.TargetObjectId IN:settempLOIID ];
        for (Integer i = 0; i < newLOIList.size(); i++) {
            if((LOIOldList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.SUBMITTED || LOIOldList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.RESUBMITTED) && (newLOIList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.CANCELLED)){
                for(ProcessInstanceWorkitem piwi:piwiList){
                    if(piwi.ProcessInstance.TargetObjectId == newLOIList[i].id && !isSubmitted ){ 
                        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                        req.setComments('Recalling and unlocking request.');
                        req.setAction(CPA_ConstantsForContractingAppClasses.REMOVED);
                        req.setWorkitemId(piwi.Id);
                        Approval.ProcessResult result =  Approval.process(req);
                        isSubmitted = true;
                    }
                }
            }
        }
    }  
    /**
    * Method Name : submitforApproval
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform submit for  Approval process on PWO record
    */
     public static List<CPA_PWORF__c> submitforApproval(List<CPA_LOI__c> oldLOIList,List<CPA_LOI__c> newLOIList)    
    {
       set<Id> setPworfId = new set<Id>();
       List<CPA_PWORF__c> lstPWORF = new List<CPA_PWORF__c>();
       
       for (Integer i = 0; i < newLOIList.size(); i++) {
            
        if ((oldLOIList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.SUBMITTED &&   newLOIList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.SUBMITTED)|| (oldLOIList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.RESUBMITTED &&   newLOIList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.RESUBMITTED) &&  !isSubmitted) {
             
            // create the new approval request to submit
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitted for approval. Please approve.');
            req.setObjectId(newLOIList[i].Id);
            // submit the approval request for processing
            Approval.ProcessResult result = Approval.process(req);
            // display if the reqeust was successful

            isSubmitted = true;
        }else if(oldLOIList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.CANCELLED &&   newLOIList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.CANCELLED){
                setPworfId.add(newLOIList[i].lkp_PWORF__c);
        }
 
        }
        if(setPworfId !=null && setPworfId.size()>0){
                for(CPA_PWORF__c objPWORF :[select id,chk_LOI_Cancelled__c from CPA_PWORF__c where ID IN:setPworfId]){
                    if(!objPWORF.chk_LOI_Cancelled__c){
                        objPWORF.chk_LOI_Cancelled__c = true;
                        lstPWORF.add(objPWORF);
                    }               
            }
            if(lstPWORF!=null && lstPWORF.size()>0){                
                        //update lstPWORF;
                        return lstPWORF;
                    }
            }
            return null;
    
    }
  /** Method Name : checkforCancel
    * Parameter   : newLOIList
    * Return type : None
    * Author      :  
    * Description : This method restric to create new LOI if first LOI is Cancel
    */  
   /* public static void checkforCancel (List<CPA_LOI__c> newList){
        
        set<ID> setPWORFId = new set<Id>();
        
        for(CPA_LOI__c objLOI : newList){
            setPWORFId.add(objLOI.lkp_PWORF__c);
        }
        
        List<CPA_PWORF__c> listPworf = [Select Id,chk_LOI_Cancelled__c from CPA_PWORF__c where ID IN:setPWORFId AND chk_LOI_Cancelled__c =true ];
        
        for(CPA_LOI__c obj : newList){
            for(CPA_PWORF__c objPWORF :listPworf ){
                if(obj.lkp_PWORF__c == objPWORF.Id  )
                if(!Test.isrunningtest()){
                    //obj.addError('LOI is already cancelled so its not possible to create another LOI, Please respond with PWO.'); 
                    obj.addError('This PWORF contains a Cancelled LOI so its not possible to create another LOI, Please respond with PWO.'); 
                    }               
            }
        }
    }*/
    
    /** Justification: We are prepopulating some values from Parent record, to check whether those fields are not null
     * we have put in multiple if conditions.
     * NPath issue - This method has NPath issues identified in SonarQube. If this is high NPath issue,
     *  Dev team will fix this in next release.
     */
    public static void checklistValueOfLOI(List<CPA_LOI__c> newLOI){
        
        set<Id> setPWORF = new set<ID>();
        map<Id,CPA_PWORF__c> mapPWORF = new map<ID,CPA_PWORF__c>();
        
        for(CPA_LOI__c objNewLOI : newLOI){
                setPWORF.add(objNewLOI.lkp_PWORF__c);
            }
        for(CPA_PWORF__c objPworf : [select id,txta_Title__c,RecordTypeId,mpkl_Project_Phases__c,eml_Unilever_Content_Approver_Email__c, txt_Unilever_Content_Approver_Name__c, eml_Unilever_Budget_Approver_Email__c, txt_Unilever_Budget_Approver_Name__c,txt_Clarity_ID__c,txt_OtherProjectPhases__c from CPA_PWORF__c where ID  IN: setPWORF]){
                mapPWORF.put(objPworf.Id,objPworf);
            }
            
        for(CPA_LOI__c objNewLOI : newLOI){
            CPA_PWORF__c objPWORFTemp = mapPWORF.get(objNewLOI.lkp_PWORF__c);
            if(objPWORFTemp !=null){
                
                
                if(objNewLOI.txt_PWO_title__c == null && objPWORFTemp.txta_Title__c !=null) 
                    objNewLOI.txt_PWO_title__c = objPWORFTemp.txta_Title__c;
                
                if(objNewLOI.txt_Unilever_Clarity_ID__c == null && objPWORFTemp.txt_Clarity_ID__c !=null) 
                    objNewLOI.txt_Unilever_Clarity_ID__c = objPWORFTemp.txt_Clarity_ID__c;
                /*
                JP: Removed the lookup and created text/emal fields             
                                if(objNewLOI.lkp_Unilever_budget_approver__c == null && objPWORFTemp.lkp_Unilever_budget_approver__c !=null) 
                                    objNewLOI.lkp_Unilever_budget_approver__c = objPWORFTemp.lkp_Unilever_budget_approver__c;
                                if(objNewLOI.lkp_Unilever_content_approver__c == null && objPWORFTemp.lkp_Unilever_content_approver__c !=null) 
                                    objNewLOI.lkp_Unilever_content_approver__c = objPWORFTemp.lkp_Unilever_content_approver__c;
                */
                if(objNewLOI.eml_Unilever_Content_Approver_Email__c == null && objPWORFTemp.eml_Unilever_Content_Approver_Email__c !=null) 
                    objNewLOI.eml_Unilever_Content_Approver_Email__c = objPWORFTemp.eml_Unilever_Content_Approver_Email__c;
                if(objNewLOI.txt_Unilever_Content_Approver_Name__c == null && objPWORFTemp.txt_Unilever_Content_Approver_Name__c !=null) 
                    objNewLOI.txt_Unilever_Content_Approver_Name__c = objPWORFTemp.txt_Unilever_Content_Approver_Name__c;

                if(objNewLOI.eml_Unilever_Budget_Approver_Email__c == null && objPWORFTemp.eml_Unilever_Budget_Approver_Email__c !=null) 
                    objNewLOI.eml_Unilever_Budget_Approver_Email__c = objPWORFTemp.eml_Unilever_Budget_Approver_Email__c;
                if(objNewLOI.txt_Unilever_Budget_Approver_Name__c == null && objPWORFTemp.txt_Unilever_Budget_Approver_Name__c !=null) 
                    objNewLOI.txt_Unilever_Budget_Approver_Name__c = objPWORFTemp.txt_Unilever_Budget_Approver_Name__c;
                
                if(objNewLOI.mpkl_Phases_covered_by_WAR__c == null && objPWORFTemp.mpkl_Project_Phases__c !=null)
                    objNewLOI.mpkl_Phases_covered_by_WAR__c = objPWORFTemp.mpkl_Project_Phases__c;
                if(objNewLOI.txt_Other_Phases_Covered_by_W_R__c == null && objPWORFTemp.txt_OtherProjectPhases__c !=null)
                    objNewLOI.txt_Other_Phases_Covered_by_W_R__c = objPWORFTemp.txt_OtherProjectPhases__c;
                //string AllrecordType = CPA_PWORF_Record_type__c.getValues('All').Record_type_id__c;
                Id AllrecordType = Schema.SObjectType.CPA_PWORF__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_PWORF_ALL_RECORDTYPE).getRecordTypeId();
              
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
        
        if (inv.pkl_Approval_Comment_Check__c == CPA_ConstantsForContractingAppClasses.REQUIRED)
        { 
          approvalStatements.put(inv.Id, inv);
          // Reset the field value to null, 
          // so that the check is not repeated,
          // next time the object is updated
          inv.pkl_Approval_Comment_Check__c  = null; 
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
    /*public static List<CPA_LOI__c>  cancelAllLOI(List<CPA_LOI__c> newLOI){
        set<Id> setPWORF = new set<ID>();
        List<CPA_LOI__c> ListnewLOI  = new List<CPA_LOI__c>();
        for(CPA_LOI__c objNewLOI : newLOI){
            if(objNewLOI.pkl_Status__c == CPA_ConstantsForContractingAppClasses.CANCELLED){
                setPWORF.add(objNewLOI.lkp_PWORF__c);
            }
        }
        for(CPA_LOI__c objLoi : [select id,pkl_Status__c from CPA_LOI__c where lkp_PWORF__c  IN: setPWORF and pkl_Status__c !=: CPA_ConstantsForContractingAppClasses.CANCELLED]){
                objLoi.pkl_Status__c = CPA_ConstantsForContractingAppClasses.CANCELLED;
                ListnewLOI.add(objLoi);
            }
        return  ListnewLOI;
    }*/
    
    /** Method Name : getInternalPWOIDFromPWORF
    * Parameter   : newPWO
    * Return type : None
    * Author      : Dinesh Girase  
    * Created on  : 16/02/2016
    * Description : This method gets internal PWO ID from PWORF and maps it to LOI. Calling from before insert trigger
    */
   /*public static void getInternalPWOIDFromPWORF(List<CPA_LOI__c> newLOI){
        /*List<CPA_PWORF__c> pworfs = [SELECT txt_Internal_PWO_ID__c FROM CPA_PWORF__c Where Id =: newLOI[0].lkp_PWORF__c];
        if(pworfs!=null && pworfs.size()>0 && pworfs[0] !=null && pworfs[0].txt_Internal_PWO_ID__c != null){
            newLOI[0].txt_Internal_PWO_ID__c = pworfs[0].txt_Internal_PWO_ID__c;
        }else{
            System.debug('PWO ID not present on PWORF @@@@@######## : ');
        }
        
    }*/
    
    /** Method Name : internalLIOID
    * Parameter   : newLOI
    * Return type : None
    * Author      : Dinesh Girase  
    * Description : This method creates Internal LOI ID for LOI, Internal PWO ID for LOI & PWORF used for search purpose
    */
    /*public static void internalLIOID(List<CPA_LOI__c> newLOI){
        String newInternalPWOID='';
        List<AggregateResult> lstPWO = [SELECT count(ID) newCount FROM CPA_project_work_order__c];
        if(lstPWO[0].get('newCount') != null){
            Integer maxNo = Integer.valueOf(lstPWO[0].get('newCount') + '');
            //Why +1 is because, here we are creating LOI on PWORF, there is no PWO record present
            newInternalPWOID = getInternalID(maxNo+1,'PWO');
            System.debug('newInternalPWOID  ######## : ' + newInternalPWOID );
        }
        
        List<AggregateResult> lstLOI = [SELECT count(ID) newCount FROM CPA_LOI__c];
        if(lstLOI[0].get('newCount') != null){
            Integer maxNo = Integer.valueOf(lstLOI[0].get('newCount') + '');
            String newInternalLOIID = getInternalID(maxNo,'LOI');
            System.debug('newInternalLOIID  ######## : ' + newInternalLOIID );
            newLOI[0].txt_Internal_LOI_ID__c = newInternalLOIID;
            newLOI[0].txt_Internal_PWO_ID__c = newInternalPWOID;
            System.debug('newInternalPWOID ######## : ' + newInternalPWOID);
            
            List<CPA_PWORF__c> pworfs = [SELECT For_Search__c, txt_Internal_PWO_ID__c FROM CPA_PWORF__c Where Id =: newLOI[0].lkp_PWORF__c];
            if(pworfs[0].txt_Internal_PWO_ID__c == null){
                System.debug('txt_Internal_PWO_ID__c is NULL ######## : ');
                pworfs[0].txt_Internal_PWO_ID__c = newInternalPWOID;
                if(pworfs[0].For_Search__c != null){
                    String test = pworfs[0].For_Search__c;
                    System.debug('LOI Search ######## : ' + pworfs[0].For_Search__c);
                    pworfs[0].For_Search__c = test + ', ' + newInternalLOIID;
                }else{
                    System.debug('Else - LOI Search ######## : ' );
                    pworfs[0].For_Search__c = newInternalPWOID + ', ' + newInternalLOIID;
                }
                update pworfs;
            }else{
                System.debug('txt_Internal_PWO_ID__c is NOT NULL ######## : ');
            }
            
        }
    }*/
    
   
    
     /**   Method Name : DOntDelete
    * Parameter   : OldMap
    * Return type : void
    * Author      : jp
    * Description : This method dont allow CR to be deleted
    */
    public static void DontDelete(list<CPA_LOI__c> lstLOI){
        
        for(CPA_LOI__c obj :lstLOI ){
            obj.addError('LOI cant be deleted');
        }
    }
   
}