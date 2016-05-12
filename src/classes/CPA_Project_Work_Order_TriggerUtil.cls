/**********************************************************************
Name: CPA_Project_Work_Order_TriggerUtil()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to perform operation on event of CPA_Project_Work_Order_Trigger
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR           DATE            DETAIL Description
1.0         Pooja Kanani     11/01/2016     INITIAL DEVELOPMENT CSR:
1.1         Shreyas M        01/04/2016     Code Update for Pricing Moeal on line number 252 to 255
***********************************************************************/
public with sharing class CPA_Project_Work_Order_TriggerUtil{
    public static boolean isSubmitted=false;
    /*
    * Method Name : recallApproval
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform recall Approval process on PWO record
    */
     public static void recallApproval(List<CPA_project_work_order__c> PWOOldList,List<CPA_project_work_order__c> newPWOList)    
     { 
       set<ID> settempPWOID = new set<ID>();
       for(CPA_project_work_order__c objPWOTemp: newPWOList){
            
            settempPWOID.add(objPWOTemp.Id);
        }
        List<ProcessInstanceWorkitem> piwiList = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem where ProcessInstance.TargetObjectId IN:settempPWOID ];
        for (Integer i = 0; i < newPWOList.size(); i++) {
            if((PWOOldList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.SUBMITTED || PWOOldList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.RESUBMITTED || PWOOldList[i].CNF_Status__c  == CPA_ConstantsForContractingAppClasses.SUBMITTED || PWOOldList[i].CNF_Status__c  == CPA_ConstantsForContractingAppClasses.RESUBMITTED || PWOOldList[i].TNF_Status__c  == CPA_ConstantsForContractingAppClasses.SUBMITTED || PWOOldList[i].TNF_Status__c  == CPA_ConstantsForContractingAppClasses.RESUBMITTED) && (newPWOList[i].pkl_Status__c == 'Cancelled' || newPWOList[i].pkl_Status__c == 'Request For Termination' || newPWOList[i].chk_isCNFcancelled__c || newPWOList[i].chk_isTNFcancelled__c)){
            
                
                for(ProcessInstanceWorkitem piwi:piwiList){
                    if(piwi.ProcessInstance.TargetObjectId == newPWOList[i].id && !isSubmitted ){ 
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
    /*
    * Method Name : submitforApproval
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform submit for  Approval process on PWO record
    */
     public static List<CPA_PWORF__c> submitforApproval(List<CPA_project_work_order__c> oldPWOList,List<CPA_project_work_order__c> newPWOList)    
    {

        set<id> setID = new set<Id>();
        List<CPA_PWORF__c> lstTemp = new List<CPA_PWORF__c>();
        
         for (Integer i = 0; i < newPWOList.size(); i++) {
            if (((oldPWOList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.SUBMITTED &&   newPWOList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.SUBMITTED)|| (oldPWOList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.RESUBMITTED &&   newPWOList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.RESUBMITTED)|| (oldPWOList[i].CNF_Status__c  <> CPA_ConstantsForContractingAppClasses.SUBMITTED &&   newPWOList[i].CNF_Status__c == CPA_ConstantsForContractingAppClasses.SUBMITTED)|| (oldPWOList[i].CNF_Status__c  <> CPA_ConstantsForContractingAppClasses.RESUBMITTED &&   newPWOList[i].CNF_Status__c == CPA_ConstantsForContractingAppClasses.RESUBMITTED) || (oldPWOList[i].TNF_Status__c  <> CPA_ConstantsForContractingAppClasses.SUBMITTED &&   newPWOList[i].TNF_Status__c == CPA_ConstantsForContractingAppClasses.SUBMITTED)|| (oldPWOList[i].TNF_Status__c  <> CPA_ConstantsForContractingAppClasses.RESUBMITTED &&   newPWOList[i].TNF_Status__c == CPA_ConstantsForContractingAppClasses.RESUBMITTED)  ) &&  !isSubmitted) {
                 
                // create the new approval request to submit
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitted for approval. Please approve.');
                req.setObjectId(newPWOList[i].Id);
                // submit the approval request for processing
                
                Approval.ProcessResult result = Approval.process(req);
                // display if the reqeust was successful
                setID.add(newPWOList[i].PWORF_ID__c);
                isSubmitted = true;
            }   
     
        }
        if(setID!=null && setID.size()> 0){
            List<CPA_PWORF__c> lstPWORF  = [Select Id,pkl_Status__c,dat_PWORF_Answered_Date__c from CPA_PWORF__c where Id IN:setID ];
         
             for(CPA_PWORF__c obj : lstPWORF){
                  Approval.unLockResult lrList = Approval.unlock(obj, false);
                 if(obj.pkl_Status__c != 'Answered'){
                     obj.pkl_Status__c = 'Answered';
                     obj.dat_PWORF_Answered_Date__c = System.today();
                     lstTemp.add(obj);  
                 }       
                         
             }
             if(lstTemp!=null && lstTemp.size()>0){
                return lstTemp; 
                Approval.unLockResult[] lrList1 = Approval.unlock(lstTemp, false);
             }
        }
        return null;
        
    }
     /*
    * Method Name : checklistValueOfcontract
    * Parameter   : 
    * Return type : None
    * Description : This method is used to populate values to the contract
    */
    /* Justification: We are pre-populating some values from Parent record, to check whether those fields are not null
     * we have put in multiple if conditions.
     * NPath issue - This method has NPath issues identified in SonarQube. If this is high NPath issue,
     *  Dev team will fix this in next release.
     */   
   public static void checklistValueOfcontract(List<CPA_project_work_order__c> newmapPWO){
    set<Id> setPwoId = new set<Id>();
    set<Id> setPworfId = new set<Id>();
    map<Id,CPA_PWORF__c> mapPWORF = new map<ID,CPA_PWORF__c>();
    map<Id,CPA_CR__c>mapPWOIDCR = new map<ID,CPA_CR__c>();
   // Map<string,CPA_PWORF_Record_type__c> customSettingPworfRT = CPA_PWORF_Record_type__c.getAll(); 
    Id AllrecordType = Schema.SObjectType.CPA_PWORF__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_PWORF_ALL_RECORDTYPE).getRecordTypeId();
    Id RArecordType = Schema.SObjectType.CPA_PWORF__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_PWORF_RA_RECORDTYPE).getRecordTypeId();      
    ID PWORecordtype = Schema.SObjectType.CPA_project_work_order__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_PWO_RecordTypeId ).getRecordTypeId();
    ID CNFRecordtype = Schema.SObjectType.CPA_project_work_order__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_CNF_RecordTypeId ).getRecordTypeId(); ID TNFRecordtype = Schema.SObjectType.CPA_project_work_order__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_TNF_RecordTypeId  ).getRecordTypeId();
    
    if(newmapPWO!= null ){
         for(CPA_project_work_order__c objPWo : newmapPWO){
            setPworfId.add(objPWo.PWORF_ID__c);
            setPWOID.add(objPWo.id);
        }
        for(CPA_CR__c lstCR:[Select Id,name,CPA_Project_Work_Order__c,num_Estimated_Man_days_of_CR__c,num_Total_Resource_Cost_CR__c,num_Discounts__c,num_Varied_Target_Blend_Rate__c,num_Expense_charges_of_CR__c,num_Total_charge_of_CR__c,dt_CR_End_date__c from CPA_CR__c where CPA_Project_Work_Order__c IN:  setPwoId and pkl_Status__c !=:CPA_ConstantsForContractingAppClasses.CANCELLED and pkl_Status__c !=:CPA_ConstantsForContractingAppClasses.RETURNED and pkl_Status__c !=:CPA_ConstantsForContractingAppClasses.SAVED ORDER BY Createddate DESC limit 1]){           
            mapPWOIDCR.put(lstCR.CPA_Project_Work_Order__c,lstCR);
        }
        for(CPA_PWORF__c objPworf : [select id,txt_Internal_PWO_ID__c,mpkl_Project_Phases__c,auto_PWORF_ID__c,txta_Title__c,eml_Unilever_Content_Approver_Email__c, txt_Unilever_Content_Approver_Name__c, eml_Unilever_Budget_Approver_Email__c, txt_Unilever_Budget_Approver_Name__c, eml_Unilever_Finance_BP_Contact_Email__c, txt_Unilever_Finance_BP_Contact_Name__c, txt_Clarity_ID__c,pkl_Region__c,pkl_Project_Scale__c,RecordTypeid,pkl_Business_Area__c,dat_SLA1_Accepted_Date__c,pkl_Pricing_Model__c,dt_Expected_go_live_date__c,dt_Expected_start_date__c,txt_OtherProjectPhases__c  from CPA_PWORF__c where ID  IN: setPworfId]){
            mapPWORF.put(objPworf.Id,objPworf);
        }
        for(CPA_project_work_order__c objPWo : newmapPWO){
            CPA_PWORF__c objPWORFTemp = mapPWORF.get(objPWo.PWORF_ID__c);                 
            if(objPWORFTemp !=null){
                if(objPWo.RecordTypeid == PWORecordtype){
                    if(objPWo.mpkl_Project_Phases__c == null && objPWORFTemp.mpkl_Project_Phases__c !=null)
                        objPWo.mpkl_Project_Phases__c = objPWORFTemp.mpkl_Project_Phases__c;
                    if(objPWo.pkl_Region__c == null && objPWORFTemp.pkl_Region__c !=null)
                        objPWo.pkl_Region__c = objPWORFTemp.pkl_Region__c;
                    if(objPWo.txt_PWO_title__c == null && objPWORFTemp.txta_Title__c !=null) 
                        objPWo.txt_PWO_title__c = objPWORFTemp.txta_Title__c;
                    if(objPWo.txt_Unilever_Reference__c == null && objPWORFTemp.txt_Clarity_ID__c !=null) 
                        objPWo.txt_Unilever_Reference__c = objPWORFTemp.txt_Clarity_ID__c;
                    if(objPWo.txt_Unilever_Project_Name__c == null && objPWORFTemp.txta_Title__c !=null) 
                        objPWo.txt_Unilever_Project_Name__c = objPWORFTemp.txta_Title__c;
                    if(objPWo.dt_Expected_Start_Date__c == null && objPWORFTemp.dt_Expected_start_date__c !=null)
                        objPWo.dt_Expected_Start_Date__c = objPWORFTemp.dt_Expected_start_date__c;
                    if(objPWo.dt_Expected_End_date__c == null && objPWORFTemp.dt_Expected_go_live_date__c !=null)
                        objPWo.dt_Expected_End_date__c = objPWORFTemp.dt_Expected_go_live_date__c;                          

                    autoPopulateValues(objPWo,objPWORFTemp); 
                      if(objPWo.dt_Date_PWORF_accepted__c == null && objPWORFTemp.dat_SLA1_Accepted_Date__c !=null) 
                      {   objPWo.dt_Date_PWORF_accepted__c = objPWORFTemp.dat_SLA1_Accepted_Date__c;
                      }
                    if(objPWORFTemp.pkl_Project_Scale__c != null && objPWORFTemp.RecordTypeid == AllrecordType){
                        if(objPWORFTemp.pkl_Project_Scale__c == 'Small Project (<50 days)') objPWo.mpkl_Project_Classification__c = 'Other';
                        else if(objPWORFTemp.pkl_Project_Scale__c == 'Large Project (>2000 days)') 
                        {
                        objPWo.mpkl_Project_Classification__c = 'Complex';
                        
                        }
                        else if(objPWORFTemp.pkl_Project_Scale__c == 'Low Complexity Project (50 - 500 days)' ) objPWo.mpkl_Project_Classification__c = 'Low Complexity';
                        else if(objPWORFTemp.pkl_Project_Scale__c == 'Standard Project (500 - 2000 days)') objPWo.mpkl_Project_Classification__c = 'Standard';
                        
                        if(objPWo.txt_Other_Project_Phases__c == null && objPWORFTemp.txt_OtherProjectPhases__c !=null)
                            objPWo.txt_Other_Project_Phases__c = objPWORFTemp.txt_OtherProjectPhases__c;
                    }else objPWo.mpkl_Project_Classification__c = 'Resource Augmentation'; 

                if(objPWo.mpkl_Unilever_Innovation_Area__c == null && objPWORFTemp.pkl_Business_Area__c !=null)
                    objPWo.mpkl_Unilever_Innovation_Area__c = objPWORFTemp.pkl_Business_Area__c;
                if(objPWORFTemp.mpkl_Project_Phases__c!= null && objPWo.mpkl_Project_Phases__c!=null && !objPWo.mpkl_Project_Phases__c.containsOnly(objPWORFTemp.mpkl_Project_Phases__c)) 
                    objPWo.addError('Only ' + objPWORFTemp.mpkl_Project_Phases__c.replaceAll(';', ', ') + ' Project Phases are allow');
                if(objPWo.pkl_Region__c!=null && objPWo.pkl_Region__c!=objPWORFTemp.pkl_Region__c) 
                    objPWo.addError('PWO can be created for '+objPWORFTemp.pkl_Region__c+ ' Region');
                }   
            }               
            if(objPWo.RecordTypeid == CNFRecordtype){
                if(objPWo.txt_CNF_Unilever_Clarity_ID__c == null && objPWo.txt_Unilever_Reference__c !=null) 
                    objPWo.txt_CNF_Unilever_Clarity_ID__c = objPWo.txt_Unilever_Reference__c;                            
                autoPopulateValues(objPWo,new CPA_PWORF__c());  
                if(mapPWOIDCR.get(objPWo.id) != null){
                    CPA_CR__c latestCR = mapPWOIDCR.get(objPWo.id);
                    if(objPWo.txt_CNF_CR_number__c == null && latestCR.name != null)
                        objPWo.txt_CNF_CR_number__c = latestCR.name;
                    if(objPWo.num_CNF_Planned_man_days__c == null && latestCR.num_Estimated_Man_days_of_CR__c !=null)
                        objPWo.num_CNF_Planned_man_days__c = latestCR.num_Estimated_Man_days_of_CR__c;
                    if(objPWo.num_CNF_Planned_expenses__c   == null && latestCR.num_Expense_charges_of_CR__c !=null)
                        objPWo.num_CNF_Planned_expenses__c  = latestCR.num_Expense_charges_of_CR__c;
                    if(objPWo.num_CNF_Planned_total_charges__c   == null && latestCR.num_Total_charge_of_CR__c !=null)
                        objPWo.num_CNF_Planned_total_charges__c  = latestCR.num_Total_charge_of_CR__c;
                    if(objPWo.dt_CNF_Planned_PWO_End_Date__c   == null && latestCR.dt_CR_End_date__c !=null)
                        objPWo.dt_CNF_Planned_PWO_End_Date__c  = latestCR.dt_CR_End_date__c;
                    if(objPWo.num_CNF_Planned_fees_inclusive_of_discou__c == null && latestCR.num_Total_Resource_Cost_CR__c  != null){
                        if(latestCR.num_Discounts__c != null){
                            objPWo.num_CNF_Planned_fees_inclusive_of_discou__c = latestCR.num_Total_Resource_Cost_CR__c - latestCR.num_Discounts__c;
                        }else{
                            objPWo.num_CNF_Planned_fees_inclusive_of_discou__c = latestCR.num_Total_Resource_Cost_CR__c;
                        }
                    }   
                    if(objPWo.num_CNF_Planned_Day_rate__c == null && latestCR.num_Varied_Target_Blend_Rate__c != null)
                        objPWo.num_CNF_Planned_Day_rate__c =latestCR.num_Varied_Target_Blend_Rate__c;
                }else{
                    if(objPWo.num_CNF_Planned_man_days__c == null && objPWo.num_Estimated_Man_days_of_PWO__c !=null)
                        objPWo.num_CNF_Planned_man_days__c = objPWo.num_Estimated_Man_days_of_PWO__c;
                    if(objPWo.num_CNF_Planned_expenses__c   == null && objPWo.num_Expense_charges_of_work_order__c !=null)
                        objPWo.num_CNF_Planned_expenses__c  = objPWo.num_Expense_charges_of_work_order__c;
                    if(objPWo.num_CNF_Planned_total_charges__c   == null && objPWo.num_Total_work_order_charge__c !=null)
                        objPWo.num_CNF_Planned_total_charges__c  = objPWo.num_Total_work_order_charge__c;
                    if(objPWo.dt_CNF_Planned_PWO_End_Date__c   == null && objPWo.dt_Expected_End_date__c !=null)
                        objPWo.dt_CNF_Planned_PWO_End_Date__c  = objPWo.dt_Expected_End_date__c;
                    if(objPWo.num_CNF_Planned_fees_inclusive_of_discou__c == null && objPWo.num_Effort_Cost__c  != null){
                        if(objPWo.num_Discounts__c != null){
                            objPWo.num_CNF_Planned_fees_inclusive_of_discou__c = objPWo.num_Effort_Cost__c - objPWo.num_Discounts__c;
                        }else{
                            objPWo.num_CNF_Planned_fees_inclusive_of_discou__c = objPWo.num_Effort_Cost__c;
                        }
                    }   
                    if(objPWo.num_CNF_Planned_Day_rate__c == null && objPWo.num_Varied_Target_Blend_Rate__c != null)
                        objPWo.num_CNF_Planned_Day_rate__c =objPWo.num_Varied_Target_Blend_Rate__c;
                }
            }else if(objPWo.RecordTypeid == TNFRecordtype){
                if(objPWo.txt_TNF_Unilever_Clarity_ID__c == null && objPWo.txt_Unilever_Reference__c !=null) 
                    objPWo.txt_TNF_Unilever_Clarity_ID__c = objPWo.txt_Unilever_Reference__c;
                if(objPWo.num_TNF_Planned_charges__c   == null && objPWo.num_Total_work_order_charge__c !=null)
                    objPWo.num_TNF_Planned_charges__c  = objPWo.num_Total_work_order_charge__c;
            }
        }
    }
}


  /*******************************************************************
    Purpose: This method used to cancel the CR record when PWO is terminated
    Parameters: 
    Returns: PageReference
    Throws [Exceptions]: 
    ********************************************************************/
    public static list<CPA_CR__c> associatedCRCancel(List<CPA_project_work_order__c> oldPWORecList, List<CPA_project_work_order__c> newPWORecList){
        set<Id> setPwoId = new set<Id>();
        for(Integer i = 0; i < newPWORecList.size(); i++){
            if(oldPWORecList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.Terminated &&   newPWORecList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.Terminated){
                setPwoId.add(newPWORecList[i].id);
            }
        }
        List<CPA_CR__c> crRec = [select id,ltxta_Reason_for_Cancellation__c,pkl_Status__c,CPA_Project_Work_Order__c  from CPA_CR__c where pkl_Status__c !='Cancelled' and CPA_Project_Work_Order__c IN:setPwoId];
        if(crRec!= null && crRec.size()>0){
            for(CPA_CR__c cr:crRec){
                cr.ltxta_Reason_for_Cancellation__c = CPA_ConstantsForContractingAppClasses.PWOISTERMINATED;
                cr.pkl_Status__c= CPA_ConstantsForContractingAppClasses.CANCELLED;
            }
            return crRec;
        }
        return null;
    }     
        
        
    /** Method Name : autoPopulateValues
    * Parameter   : newPWO & Pworf object
    * Return type : None
    * Author      : Jayprakash Bharti
    * Description : This method is used to auto-Populate some values in PWO
    */
    public static void autoPopulateValues(CPA_project_work_order__c objPwo, CPA_PWORF__c objPworf){
        
                
        ID PWORecordtype = Schema.SObjectType.CPA_project_work_order__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_PWO_RecordTypeId ).getRecordTypeId();
        ID CNFRecordtype = Schema.SObjectType.CPA_project_work_order__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_CNF_RecordTypeId ).getRecordTypeId();
         //if(objPWo.RecordTypeid == label.CPA_PWO_RecordTypeId){
         if(objPWo.RecordTypeid == PWORecordtype){

            if(objPWo.eml_Unilever_Content_Approver_Email__c == null && objPworf.eml_Unilever_Content_Approver_Email__c !=null){ 
                objPWo.eml_Unilever_Content_Approver_Email__c = objPworf.eml_Unilever_Content_Approver_Email__c;
            }
            if(objPWo.txt_Unilever_Content_Approver_Name__c == null && objPworf.txt_Unilever_Content_Approver_Name__c !=null){ 
                objPWo.txt_Unilever_Content_Approver_Name__c = objPworf.txt_Unilever_Content_Approver_Name__c;
            }
            if(objPWo.eml_Unilever_Budget_Approver_Email__c == null && objPworf.eml_Unilever_Budget_Approver_Email__c !=null){ 
                objPWo.eml_Unilever_Budget_Approver_Email__c = objPworf.eml_Unilever_Budget_Approver_Email__c;
            }
            if(objPWo.txt_Unilever_Budget_Approver_Name__c == null && objPworf.txt_Unilever_Budget_Approver_Name__c !=null){ 
                objPWo.txt_Unilever_Budget_Approver_Name__c = objPworf.txt_Unilever_Budget_Approver_Name__c;
            }
            if(objPWo.eml_Unilever_Finance_BP_Contact_Email__c == null && objPworf.eml_Unilever_Finance_BP_Contact_Email__c !=null){ 
                objPWo.eml_Unilever_Finance_BP_Contact_Email__c = objPworf.eml_Unilever_Finance_BP_Contact_Email__c;
            }
            if(objPWo.txt_Unilever_Finance_BP_Contact_Name__c == null && objPworf.txt_Unilever_Finance_BP_Contact_Name__c !=null){ 
                objPWo.txt_Unilever_Finance_BP_Contact_Name__c = objPworf.txt_Unilever_Finance_BP_Contact_Name__c;
            }
            if((objPWo.pkl_Pricing_Model__c == null || objPWo.pkl_Pricing_Model__c == '-')&& objPworf.pkl_Pricing_Model__c !=null){ 
                objPWo.pkl_Pricing_Model__c = objPworf.pkl_Pricing_Model__c;
            }
        }
      
       else if(objPWo.RecordTypeid == CNFRecordtype){
            if(objPWo.eml_CNF_Unilever_Content_Approver_Email__c == null && objPWo.eml_Unilever_Content_Approver_Email__c !=null){ 
                objPWo.eml_CNF_Unilever_Content_Approver_Email__c = objPWo.eml_Unilever_Content_Approver_Email__c;
            }
            if(objPWo.txt_CNF_Unilever_Content_Approver_Name__c == null && objPWo.txt_Unilever_Content_Approver_Name__c !=null){ 
                objPWo.txt_CNF_Unilever_Content_Approver_Name__c = objPWo.txt_Unilever_Content_Approver_Name__c;
            }
            if(objPWo.eml_CNF_Unilever_Budget_Approver_Email__c == null && objPWo.eml_Unilever_Budget_Approver_Email__c !=null){ 
                objPWo.eml_CNF_Unilever_Budget_Approver_Email__c = objPWo.eml_Unilever_Budget_Approver_Email__c;
            }
            if(objPWo.txt_CNF_Unilever_Budget_Approver_Name__c == null && objPWo.txt_Unilever_Budget_Approver_Name__c !=null){ 
                objPWo.txt_CNF_Unilever_Budget_Approver_Name__c = objPWo.txt_Unilever_Budget_Approver_Name__c;
            }
        }
        
        
    }
 
  /** Method Name : requireApprovalComments
    * Parameter   : newContractList
    * Return type : None
    * Author      : Pooja Kanani  
    * Description : This method make the Approval comments require
    */
    public static void requireApprovalComments(List<CPA_project_work_order__c> newContractList){
 
  // Create a map that stores all the objects that require editing 
  Map<Id, CPA_project_work_order__c> approvalStatements = new Map<Id, CPA_project_work_order__c>{};

  for(CPA_project_work_order__c inv: newContractList)
  {
    // Put all objects for update that require a comment check in a map,
    // so we only have to use 1 SOQL query to do all checks
    
    if (inv.pkl_Approval_Comment_Check__c  == CPA_ConstantsForContractingAppClasses.REQUIRED)
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
    
    for (CPA_project_work_order__c invs : [SELECT (SELECT ID
                                              FROM ProcessInstances
                                              ORDER BY CreatedDate DESC
                                              LIMIT 1)
                                      FROM CPA_project_work_order__c
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
    * Author      : Jayprakash Bharti   
    * Method Name : UpdateTAT
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform recall Approval process on PWO record
    */
    public static List<CPA_TAT__c> UpdateTATObj(List<CPA_project_work_order__c> newPWOList)    
    {
        List<CPA_TAT__c> lstTAT = new List<CPA_TAT__c>();
        for (CPA_project_work_order__c obj : newPWOList) {
            
            CPA_TAT__c tat = new CPA_TAT__c();
            tat.lkp_PWO_ID__c = obj.id;
            tat.TAT_Days__c = 0;
            lstTAT.add(tat);
            //insert(tat);
        }
        return lstTAT;
       
    }
     

    /**   Method Name : DontDelete
    * Parameter   : OldMap
    * Return type : void
    * Author      : JP
    * Description : This method dont allow PWO to be deleted
    */
    public static void DOntDelete(list<CPA_project_work_order__c> lstPWO){
        
        for(CPA_project_work_order__c obj :lstPWO ){
            obj.addError('PWO cant be deleted');
            break;
        }
    }
    
        /**   Method Name : setFirstPWO
    * Parameter   : OldMap
    * Return type : void
    * Author      : JP
    * Description : This method is used to set chk_First_PWO__c
    */
    public static void setFirstPWO(list<CPA_project_work_order__c> lstPWO){
        
       map<Id,List<CPA_project_work_order__c>> mapPWORFTOPWO = new  map<Id,List<CPA_project_work_order__c>>();
                   set<Id> setPWORFID = new set<Id>();
                   for(CPA_project_work_order__c objId: lstPWO){
                             setPWORFID.add(objId.PWORF_ID__c);                       
                   }
                   List<CPA_project_work_order__c> listPriPWO = [Select ID,PWORF_ID__c,chk_First_PWO__c from CPA_project_work_order__c where PWORF_ID__c IN: setPWORFID  AND chk_First_PWO__c = true];
                   
                   for(Id objId: setPWORFID){
                             List<CPA_project_work_order__c> TempList = new List<CPA_project_work_order__c>();
                             for(CPA_project_work_order__c objtemp :listPriPWO ){
                                      if(objtemp.PWORF_ID__c == objId)
                                                TempList.add(objtemp);
                             }
                             mapPWORFTOPWO.put(objId,TempList);
                   }
        for(CPA_project_work_order__c obj :lstPWO ){
            
                             if(mapPWORFTOPWO.get(obj.PWORF_ID__c)!=null && mapPWORFTOPWO.get(obj.PWORF_ID__c).size()>0){
                                      obj.chk_First_PWO__c = false;
                             }else{
                                      obj.chk_First_PWO__c = true;
                             }
                             
            
        }
    }

 

}