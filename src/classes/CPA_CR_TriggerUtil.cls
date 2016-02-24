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
        set<ID> settempCRID = new set<ID>();
       for(CPA_CR__c objCRTemp: newCRList){
            
            settempCRID.add(objCRTemp.Id);
        }
        List<ProcessInstanceWorkitem> piwiList = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem where ProcessInstance.TargetObjectId IN:settempCRID ];

        for (Integer i = 0; i < newCRList.size(); i++) {
            if((CROldList[i].pkl_Status__c  == ConstantsForContractingAppClasses.SUBMITTED  || CROldList[i].pkl_Status__c  == ConstantsForContractingAppClasses.RESUBMITTED) && (newCRList[i].pkl_Status__c == 'Cancelled')){
              for(ProcessInstanceWorkitem piwi:piwiList){
                    if(!isSubmitted ){ 
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
            
        if ((oldCRList[i].pkl_Status__c  <> ConstantsForContractingAppClasses.SUBMITTED &&   newCRList[i].pkl_Status__c == ConstantsForContractingAppClasses.SUBMITTED)|| (oldCRList[i].pkl_Status__c  <> ConstantsForContractingAppClasses.RESUBMITTED &&   newCRList[i].pkl_Status__c == ConstantsForContractingAppClasses.RESUBMITTED) &&  !isSubmitted) {
             
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
            if(!objCR.chk_isStandalone_CR__c){
                setPWOID.add(objCR.CPA_Project_Work_Order__c);
            }
        }
        if(setPWOID.size()>0 && setPWOID!=null){
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
        /*for(CPA_CR__c objCR : newCNFList){
            if(objCR.RecordtypeId == null){
                setPWOID.add(objCR.CPA_Project_Work_Order__c);
            }
        }*/
     }   
public static void checklistValueOfCR(List<CPA_CR__c> newCR){
        
        set<Id> setPWO = new set<ID>();
        map<Id,CPA_project_work_order__c> mapPWO = new map<ID,CPA_project_work_order__c>();
        
        for(CPA_CR__c objnewCR : newCR){
            if(!objnewCR.chk_isStandalone_CR__c){
                setPWO.add(objnewCR.CPA_Project_Work_Order__c);
            }
        }
        if(setPWO.size()>0 && setPWO !=null){  
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
                    if(objPWOTemp.mpkl_Project_Phases__c!= null && objnewCR.pkl_Project_Phases__c !=null && !objnewCR.pkl_Project_Phases__c.containsOnly(objPWOTemp.mpkl_Project_Phases__c)) 
                            objnewCR.addError('Only ' + objPWOTemp.mpkl_Project_Phases__c.replaceAll(';', ', ') + ' Project Phases are allow');
                    if(objPWOTemp.pkl_Region__c != null && objnewCR.Region_impacted__c != null && objnewCR.Region_impacted__c != objPWOTemp.pkl_Region__c) 
                            objnewCR.addError('CR can be created for '+objPWOTemp.pkl_Region__c+ ' Region');
                }
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
            if((oldCRList[i].pkl_Status__c  == ConstantsForContractingAppClasses.SUBMITTED || oldCRList[i].pkl_Status__c  == ConstantsForContractingAppClasses.RESUBMITTED) && newCR[i].pkl_Status__c == 'Cancelled'){
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
        map<Id,CPA_CR__c>mapPWOIDCR = new map<ID,CPA_CR__c>();
        map<Id,CPA_Project_Work_Order__c>mapPWO = new map<ID,CPA_Project_Work_Order__c>();
        
        for(CPA_CR__c objCR : newCR.values()){
            if(objCR.pkl_Status__c == ConstantsForContractingAppClasses.SUBMITTED && oldCRList.get(objCR.Id).pkl_Status__c <> ConstantsForContractingAppClasses.SUBMITTED){
                lstCR.add(objCR);
                if(!objCR.chk_isStandalone_CR__c) setPWOID.add(objCR.CPA_Project_Work_Order__c);
            }
        }
      if(setPWOID.size()>0 && setPWOID!=null){  
        List<CPA_project_work_order__c>lstPWO = [Select ID,num_Expense_charges_of_work_order__c,Name,num_Estimated_Man_days_of_PWO__c,num_Estimated_Value_of_PWO__c,num_Target_Blend_Rate__c,num_Total_work_order_charge__c,num_Authorisation_charges__c,num_Authorisation_man_days__c from CPA_project_work_order__c where ID IN :setPWOID];
            for(CPA_project_work_order__c objPwo : lstPWO){
                mapPWO.put(objPwo.Id,objPwo);
            }
                
            List<CPA_CR__c> lstCR1 = [Select Id,num_Delta_Efforts__c,Name,CPA_Project_Work_Order__c,num_Estimated_Man_days_of_CR__c,num_Estimated_Value_of_CR__c,num_Target_Blend_Rate__c,num_Total_charge_of_CR__c,num_Expense_charges_of_CR__c,pec_Expense__c,num_Authorisation_charges__c,num_Authorisation_man_days__c,num_RMS_value__c  from CPA_CR__c where CPA_Project_Work_Order__c IN:  setPWOID ORDER BY Createddate DESC limit 2];
            system.debug('lstCR1---> '+lstCR1 );
            if(lstCR1 != null && lstCR1.size()==2 && lstCR1[0]!=null && lstCR1[1]!=null){
                 mapPWOIDCR.put(lstCR1[1].CPA_Project_Work_Order__c,lstCR1[1]);
                 system.debug('Inside loop');
            }else if(lstCR1 != null && lstCR1.size()==1 && lstCR1[0]!=null ) {
                mapPWOIDCR.put(lstCR1[0].CPA_Project_Work_Order__c,lstCR1[0]);
                 system.debug('Inside 1111loop');
            }else{
                
                 system.debug('Inside 222loop');
            }
            
            
            for(CPA_CR__c objCRTEmp :lstCR ){
                if(mapPWOIDCR.get(objCRTEmp.CPA_Project_Work_Order__c)==null ){
                    if(mapPWO.get(objCRTEmp.CPA_Project_Work_Order__c)!=null){
                        objCRTEmp.num_Delta_Efforts__c = objCRTEmp.num_Estimated_Value_of_CR__c - mapPWO.get(objCRTEmp.CPA_Project_Work_Order__c).num_Estimated_Value_of_PWO__c;
                        
                        system.debug('Inside Loop');
                    }else{
                        objCRTEmp.num_Delta_Efforts__c = objCRTEmp.num_Estimated_Value_of_CR__c ;  
                        system.debug('Inside Loop1111');                        
                    }
                     
                }else {
                    if(mapPWOIDCR.get(objCRTEmp.CPA_Project_Work_Order__c)!=null){
                        if(mapPWOIDCR.get(objCRTEmp.CPA_Project_Work_Order__c).Id == objCRTEmp.Id){
                            objCRTEmp.num_Delta_Efforts__c = objCRTEmp.num_Estimated_Value_of_CR__c - mapPWO.get(objCRTEmp.CPA_Project_Work_Order__c).num_Estimated_Value_of_PWO__c;
                            objCRTEmp.num_Total_charge_of_CR__c = objCRTEmp.num_Delta_Efforts__c;
                        }
                      else{
                          objCRTEmp.num_Delta_Efforts__c =objCRTEmp.num_Estimated_Value_of_CR__c  - mapPWOIDCR.get(objCRTEmp.CPA_Project_Work_Order__c).num_Estimated_Value_of_CR__c;
                          objCRTEmp.num_Total_charge_of_CR__c = objCRTEmp.num_Delta_Efforts__c;
                      }  
                        
                    }           
                
                }
            }
        }
    }
/*
    * Method Name : standaloneCR
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform Standalone CR as per Rule AC.10.10.03
    */
    public static void standaloneCR(List<CPA_CR__c> newCNFList){
        List<CPA_project_work_order__c> ListnewPWO  = new List<CPA_project_work_order__c>();
        List<CPA_CR__c> ListnewCR  = new List<CPA_CR__c>();
        map<Id,Id> mapPWO = new map<ID,Id>();
        for(CPA_CR__c objCR : newCNFList){
            if(objCR.RecordtypeId == label.Lbl_Standalone_CR_RecordTypeId){             
                CPA_project_work_order__c newPWO =new CPA_project_work_order__c();
                newPWO.RecordtypeId = label.Lbl_Standalone_PWO_RecordTypeId;
                newPWO.lkp_Unilever_budget_approver__c = objCR.lkp_Unilever_budget_approver__c;
                newPWO.lkp_Unilever_content_approver__c  = objCR.lkp_Unilever_content_approver__c;
                newPWO.txt_Unilever_Project_Name__c = objCR.txta_Unilever_Project_Name__c;
                newPWO.txt_Unilever_Reference__c = objCR.txt_Unilever_Reference__c;
                //newPWO.pec_Variance__c = pec_Variance__c;
                newPWO.chk_isStandalone_CR__c = true;
                newPWO.txt_Unilever_Reference__c = objCR.txt_Unilever_Reference__c;
                newPWO.mpkl_Project_Phases__c = objCR.pkl_Project_Phases__c;
                newPWO.txt_PWO_number__c = objCR.PWO_number__c;
                newPWO.pkl_Region__c = objCR.Region_impacted__c;
               // newPWO.num_Varied_Target_Blend_Rate__c = objCR.num_Varied_Target_Blend_Rate__c;
                newPWO.txt_Accenture_Project_Manager__c = objCR.txt_Accenture_Project_Manager__c;
                newPWO.dt_Expected_End_date__c =    objCR.dt_CR_End_date__c;
                newPWO.dt_Expected_Start_Date__c = objCR.dt_CR_Start_Date__c;
                //newPWO.Currency__c = objCR.pkl_Currency__c;
               // newPWO.txt_Other_Currency__c =objCR.txt_Other_Currency__c;
                newPWO.txt_Other_Project_Phases__c = objCR.txt_Other_Project_Phases__c;
                newPWO.pkl_Status__c = 'Saved';
                newPWO.txt_Linked_Standalone_CR__c = objCR.id;
                ListnewPWO.add(newPWO); 
            }
        }
        if(ListnewPWO.size()>0){
        insert ListnewPWO;
        List<CPA_project_work_order__c> lstTemp = new List<CPA_project_work_order__c>();
        for(CPA_project_work_order__c obj : ListnewPWO){
            obj.pkl_Status__c = 'Signed';
            lstTemp.add(obj);
            mapPWO.put(obj.txt_Linked_Standalone_CR__c,obj.ID);         
        }
        update lstTemp;
        for(CPA_CR__c objCR : newCNFList){
            Id pwo = mapPWO.get(objCR.Id);
            objCR.CPA_Project_Work_Order__c = pwo;
            ListnewCR.add(objCR);
        }
        //update ListnewCR;
        }
    }
    
     /** Method Name : internalCRID
    * Parameter   : newCR
    * Return type : None
    * Author      : Dinesh Girase  
    * Description : This method creates Internal CR ID, used for search purpose
    */ 
    
    public static void internalCRID(List<CPA_CR__c> newCR){
       /* List<AggregateResult> lstCR = [SELECT count(ID) newCount FROM CPA_CR__c];
        if(lstCR[0].get('newCount') != null){
            Integer maxNo = Integer.valueOf(lstCR[0].get('newCount') + '');
            String newInternalCRID = getInternalCRID(maxNo);
            System.debug('newInternalCRID ######## : ' + newInternalCRID);
            newCR[0].txt_Internal_CR_ID__c = newInternalCRID;
            System.debug('txt_Internal_CR_ID__c ######## : ' + newInternalCRID);
            List<CPA_project_work_order__c> pwos = [SELECT txt_For_Search__c, PWORF_ID__c FROM CPA_project_work_order__c Where Id =: newCR[0].CPA_Project_Work_Order__c];
            String strPWORFID='';
            if(pwos[0].txt_For_Search__c != null){
                strPWORFID = pwos[0].PWORF_ID__c;
                System.debug('If strPWORFID  ######## : ' + strPWORFID );
                String existingPWOData = pwos[0].txt_For_Search__c;
                System.debug('CR Search ######## : ' + existingPWOData);
                pwos[0].txt_For_Search__c = existingPWOData + ', ' + newInternalCRID;
                update pwos;
            }else{
                strPWORFID = pwos[0].PWORF_ID__c;
                System.debug('Else strPWORFID  ######## : ' + strPWORFID );
                pwos[0].txt_For_Search__c = newInternalCRID;
                update pwos;
            }
            
            List<CPA_PWORF__c> pworfs = [SELECT For_Search__c FROM CPA_PWORF__c Where Id =: strPWORFID];
            
            if(pworfs[0].For_Search__c != null){
                String existingPWORFData = pworfs[0].For_Search__c;
                System.debug('CR Search ######## : ' + existingPWORFData);
                pworfs[0].For_Search__c = existingPWORFData + ', ' + newInternalCRID;
                update pworfs;
            }
        }*/
    }
    
    /**   Method Name : getInternalCRID
    * Parameter   : numSearch
    * Return type : String
    * Author      : Dinesh Girase  
    * Description : This method generates incremental Internal CR ID
    */
    
    /*public static String getInternalCRID(Integer numSearch){
        String strCRID='';
        integer intIncrementNum = numSearch + 1;
        if(string.valueof(numSearch).length() == 1)
            strCRID = 'CR-0000' + string.valueof(intIncrementNum);
        if(string.valueof(numSearch).length() == 2)
            strCRID = 'CR-000' + string.valueof(intIncrementNum);
        if(string.valueof(numSearch).length() == 3)
            strCRID = 'CR-00' + string.valueof(intIncrementNum);
        if(string.valueof(numSearch).length() == 4)
            strCRID = 'CR-0' + string.valueof(intIncrementNum);
        if(string.valueof(numSearch).length() == 5)
            strCRID = 'CR-' + string.valueof(intIncrementNum);
        return strCRID;
    }*/
    
      /**   Method Name : DOntDelete
    * Parameter   : OldMap
    * Return type : void
    * Author      : Shreyas
    * Description : This method dont allow CR to be deleted
    */
    public static void DOntDeleteCR(list<CPA_CR__c> lstCR){
        
        for(CPA_CR__c objCr :lstCR ){
            objCr.addError('CR cant be deleted');
        }
    }
 /**   Method Name : newCR
    * Parameter   : newmap
    * Return type : void
    * Author      : Pooja Kanani
    * Description : This method is used to update PWO with the latest CR number
    */
    public static void newCR(list<CPA_CR__c> newCRList){
        //system.debug('Pooja testing');
        List<CPA_project_work_order__c> lstTemp= new List<CPA_project_work_order__c>();
        set<ID> pwoID = new set<ID>();
        map<ID,String>pwomap = new map<ID,String>();
         for(CPA_CR__c obj :newCRList){         
                    pwoID.add(obj.CPA_Project_Work_Order__c);
                    pwomap.put(obj.CPA_Project_Work_Order__c,obj.name);     
        }
        //system.debug('pwoID>>>'+ pwoID);
        //system.debug('pwomap>>>'+ pwomap);
        if(pwoID!=null && pwoID.size()> 0){
            List<CPA_project_work_order__c> lstPWO  = [Select Id,txt_CNF_CR_number__c from CPA_project_work_order__c where Id IN:pwoID];
            
            for(CPA_project_work_order__c obj : lstPWO){
                Approval.unLockResult lrList = Approval.unlock(obj, false);
                //CPA_project_work_order__c pwo = pworfmap.get(obj.id);
                obj.txt_CNF_CR_number__c = pwomap.get(obj.id);
                //system.debug('obj.LatestPWOID__c>>>pooja'+obj.LatestPWOID__c);
                lstTemp.add(obj);                    
            }
            
            //system.debug('lstTemp>>>pooja'+lstTemp);
            if(lstTemp!=null && lstTemp.size()>0){
                update lstTemp; 
            }
            //system.debug('lstTemp>>pooja'+lstTemp);
        }
    }
   
    
}