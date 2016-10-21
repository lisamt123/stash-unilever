/**********************************************************************
Name: CPA_CR_TriggerUtil()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to perform operation on before update event of CR  Trigger
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR                     DATE            DETAIL Description
1.0         Shreyas Mangalvedhekar     11/01/2016     INITIAL DEVELOPMENT CSR:
1.1         Shreyas                    10/03/2016     Replaceing Custom label with query on line 351   
1.2         Shreyas                    15/03/2016     Updating Delta calculation
***********************************************************************/
public with sharing class CPA_CR_TriggerUtil{
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
            if((CROldList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.SUBMITTED  || CROldList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.RESUBMITTED) && (newCRList[i].pkl_Status__c == 'Cancelled')){
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
            
        if ((oldCRList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.SUBMITTED &&   newCRList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.SUBMITTED)|| (oldCRList[i].pkl_Status__c  <> CPA_ConstantsForContractingAppClasses.RESUBMITTED &&   newCRList[i].pkl_Status__c == CPA_ConstantsForContractingAppClasses.RESUBMITTED) &&  !isSubmitted) {
             
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
        
     } 
     
     /* Justification: We are prepopulating some values from Parent record, to check whether those fields are not null
     * we have put in multiple if conditions.
     * NPath issue - This method has NPath issues identified in SonarQube. If this is high NPath issue,
     *  Dev team will fix this in next release.
     */
    public static void checklistValueOfCR(List<CPA_CR__c> newCR){
        
        set<Id> setPWO = new set<ID>();
        map<Id,CPA_project_work_order__c> mapPWO = new map<ID,CPA_project_work_order__c>();
        
        for(CPA_CR__c objnewCR : newCR){
            if(!objnewCR.chk_isStandalone_CR__c){
                setPWO.add(objnewCR.CPA_Project_Work_Order__c);
            }
        }       
        if(setPWO.size()>0 && setPWO !=null){
            changeRecordHistory(newCR,setPWO);
            for(CPA_project_work_order__c objPwo : [select id, txt_Unilever_Reference__c,fml_Unilever_Project_Name_on_PWORF__c,eml_Unilever_Content_Approver_Email__c, txt_Unilever_Content_Approver_Name__c, eml_Unilever_Budget_Approver_Email__c, txt_Unilever_Budget_Approver_Name__c,mpkl_Project_Phases__c,pkl_Region__c,txt_PWO_number__c,txt_Other_Project_Phases__c from CPA_project_work_order__c where ID  IN: setPWO]){
                    mapPWO.put(objPwo.Id,objPwo);
                }
                
            for(CPA_CR__c objnewCR : newCR){
                CPA_project_work_order__c objPWOTemp = mapPWO.get(objnewCR.CPA_Project_Work_Order__c);
                if(objPWOTemp !=null){
                    
                    if(objnewCR.txta_Unilever_Project_Name__c == null && objPWOTemp.fml_Unilever_Project_Name_on_PWORF__c !=null) 
                        objnewCR.txta_Unilever_Project_Name__c = objPWOTemp.fml_Unilever_Project_Name_on_PWORF__c;                  
                 
                                        
                    if(objnewCR.eml_Unilever_Content_Approver_Email__c == null && objPWOTemp.eml_Unilever_Content_Approver_Email__c !=null) 
                        objnewCR.eml_Unilever_Content_Approver_Email__c = objPWOTemp.eml_Unilever_Content_Approver_Email__c;
                    if(objnewCR.txt_Unilever_Content_Approver_Name__c == null && objPWOTemp.txt_Unilever_Content_Approver_Name__c !=null) 
                        objnewCR.txt_Unilever_Content_Approver_Name__c = objPWOTemp.txt_Unilever_Content_Approver_Name__c;

                    if(objnewCR.eml_Unilever_Budget_Approver_Email__c == null && objPWOTemp.eml_Unilever_Budget_Approver_Email__c !=null) 
                        objnewCR.eml_Unilever_Budget_Approver_Email__c = objPWOTemp.eml_Unilever_Budget_Approver_Email__c;
                    if(objnewCR.txt_Unilever_Budget_Approver_Name__c == null && objPWOTemp.txt_Unilever_Budget_Approver_Name__c !=null) 
                        objnewCR.txt_Unilever_Budget_Approver_Name__c = objPWOTemp.txt_Unilever_Budget_Approver_Name__c;
                    
                    
                    if(objnewCR.pkl_Project_Phases__c == null && objPWOTemp.mpkl_Project_Phases__c !=null)
                        objnewCR.pkl_Project_Phases__c = objPWOTemp.mpkl_Project_Phases__c;
                    if(objnewCR.txt_Other_Project_Phases__c == null && objPWOTemp.txt_Other_Project_Phases__c !=null)
                        objnewCR.txt_Other_Project_Phases__c = objPWOTemp.txt_Other_Project_Phases__c;
                    if(objnewCR.Region_impacted__c   == null && objPWOTemp.pkl_Region__c !=null)
                        objnewCR.Region_impacted__c  = objPWOTemp.pkl_Region__c;
                    if(objPWOTemp.mpkl_Project_Phases__c!= null && objnewCR.pkl_Project_Phases__c !=null && !objnewCR.pkl_Project_Phases__c.containsOnly(objPWOTemp.mpkl_Project_Phases__c)) 
                            objnewCR.addError('Only ' + objPWOTemp.mpkl_Project_Phases__c.replaceAll(';', ', ') + ' Project Phases are allow');
                    if(objPWOTemp.pkl_Region__c != null && objnewCR.Region_impacted__c != null && objnewCR.Region_impacted__c != objPWOTemp.pkl_Region__c) 
                            objnewCR.addError('CR can be created for '+objPWOTemp.pkl_Region__c+ ' Region');
                        objnewCR.PWO_number__c = objPWOTemp.txt_PWO_number__c;
                       
                }
            }
        }
    }
    /** Method Name : changeRecordHistory
    * Parameter   : newCR
    * Return type : None
    * Author      : Pooja Kanani
    * Created on  : 15/04/2016
    * Description : This method per populate change record history
    */
public static void changeRecordHistory(List<CPA_CR__c> newCRList, Set<ID> setPWOID){
        Map<ID,List<CPA_CR__c>> PWO_CR_Map = new Map<ID,List<CPA_CR__c>>();
        integer CRcount = 0;        
        
        for (CPA_project_work_order__c pwo : [SELECT ID,(SELECT id FROM CRs__r) FROM CPA_project_work_order__c WHERE ID IN :setPWOID]){
            if(pwo.CRs__r != NULL && pwo.CRs__r.size()>0){ 
                //CRcount  = pwo.CRs__r.size();
                PWO_CR_Map.put(pwo.ID,pwo.CRs__r); 
            }
        }
        for(CPA_CR__c cr:newCRList){
            List<CPA_CR__c>relatedAllCR = new List<CPA_CR__c>();
            relatedAllCR = PWO_CR_Map.get(cr.CPA_Project_Work_Order__c);
            if(relatedAllCR!=null && relatedAllCR.size()>0){
            CRcount  = relatedAllCR.size();
            }
            if(CRcount==1){ cr.mpkl_Change_Record_history__c = '1st Change';
            }else if(CRcount==2){cr.mpkl_Change_Record_history__c = '2nd Change';
            }else if(CRcount==3){cr.mpkl_Change_Record_history__c ='3rd Change';
            }else if(CRcount>=4){cr.mpkl_Change_Record_history__c = '4th Change';}          
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
    
    if (inv.pkl_Approval_Comment_Check__c == 'Required')
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
    { 
        List<CPA_CR__c> cancelsetId = new List<CPA_CR__c>();
        for (Integer i = 0; i < newCR.size(); i++) {
            if((oldCRList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.SUBMITTED || oldCRList[i].pkl_Status__c  == CPA_ConstantsForContractingAppClasses.RESUBMITTED) && newCR[i].pkl_Status__c == 'Cancelled'){
                cancelsetId.add(newCR[i]);  
            }       
        }
        
        if(cancelsetId !=null && cancelsetId.size()>0){
            Approval.unLockResult[] lrList = Approval.unlock(cancelsetId, false);           
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
        
        Id StandaloneCRRecordType = Schema.SObjectType.CPA_CR__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_Standalone_CR_RecordTypeId).getRecordTypeId();
        ID StandaloneRecordtype = Schema.SObjectType.CPA_project_work_order__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_Standalone_PWO_RecordTypeId).getRecordTypeId();
        
        for(CPA_CR__c objCR : newCNFList){
            if(objCR.RecordtypeId == StandaloneCRRecordType){             
                CPA_project_work_order__c newPWO =new CPA_project_work_order__c();
                
                newPWO.RecordtypeId = StandaloneRecordtype;
                
                newPWO.eml_Unilever_Content_Approver_Email__c = objCR.eml_Unilever_Content_Approver_Email__c;
                newPWO.txt_Unilever_Content_Approver_Name__c = objCR.txt_Unilever_Content_Approver_Name__c;
                newPWO.eml_Unilever_Budget_Approver_Email__c = objCR.eml_Unilever_Budget_Approver_Email__c; 
                newPWO.txt_Unilever_Budget_Approver_Name__c = objCR.txt_Unilever_Budget_Approver_Name__c;

                
                newPWO.txt_Unilever_Project_Name__c = objCR.txta_Unilever_Project_Name__c;
                newPWO.txt_Standalone_PWO_clarity_ID__c = objCR.txt_Unilever_Reference__c;
                
                newPWO.chk_isStandalone_CR__c = true;
               // newPWO.txt_Unilever_Reference__c = objCR.txt_Unilever_Reference__c;
                newPWO.mpkl_Project_Phases__c = objCR.pkl_Project_Phases__c;
                newPWO.txt_PWO_number__c = objCR.PWO_number__c;
                newPWO.pkl_Region__c = objCR.Region_impacted__c;
               
                newPWO.txt_Accenture_Project_Manager__c = objCR.txt_Accenture_Project_Manager__c;
                newPWO.dt_Expected_End_date__c =    objCR.dt_CR_End_date__c;
                newPWO.dt_Expected_Start_Date__c = objCR.dt_CR_Start_Date__c;
               
               
                newPWO.txt_Other_Project_Phases__c = objCR.txt_Other_Project_Phases__c;
                newPWO.pkl_Status__c = 'Saved';
                newPWO.txt_Linked_Standalone_CR__c = objCR.id;
                newPWO.txt_PWORFDelta_Cost_Centre__c=objCR.txt_PWORFDelta_Cost_Centre__c;
                newPWO.dt_PWORFDelta_Expected_go_live_date__c=objCR.dt_PWORFDelta_Expected_go_live_date__c;
                newPWO.dt_PWORFDelta_Expected_start_date__c=objCR.dt_PWORFDelta_Expected_start_date__c;
                newPWO.pkl_PWORFDelta_Landscap__c=objCR.pkl_PWORFDelta_Landscape__c;
                newPWO.PWORFDelta_OtherProcess_Office_Area_E2E__c=objCR.PWORFDelta_OtherProcess_Office_Area_E2E__c;
                newPWO.txt_Other_PWORFDelta_Request_Type__c=objCR.txt_Other_PWORFDelta_Request_Type__c;
                newPWO.pkl_PWORFDelta_Process_Office_Area_E2E__c=objCR.pkl_PWORFDelta_Process_Office_Area_E2E__c;
                newPWO.eml_PWORFDelta_Project_requestor_email__c=objCR.eml_PWORFDelta_Project_requestor_email__c;
                newPWO.txt_PWORFDelta_Project_requestor_name__c=objCR.txt_PWORFDelta_Project_requestor_name__c;
                newPWO.pkl_PWORFDelta_Project_Scale__c=objCR.pkl_PWORFDelta_Project_Scale__c;
                newPWO.pkl_PWORFDelta_Request_Type__c=objCR.pkl_PWORFDelta_Request_Type__c;
                newPWO.em_PWORFDeltaUnileverprojectmanagerEmail__c=objCR.em_PWORFDeltaUnileverprojectmanagerEmail__c;
                newPWO.txt_PWORFDeltaUnileverprojectmanagerName__c=objCR.txt_PWORFDeltaUnileverprojectmanagerName__c;
                newPWO.txt_Accenture_Project_Manager__c=objCR.txt_PWODelta_Accenture_Project_Manager__c;
                newPWO.pkl_Billing_Details__c=objCR.mpkl_PWODelta_Billing_Details__c;
                newPWO.txt_Other_Billing_Details__c=objCR.txt_PWODelta_Other_Billing_Details__c;
                
                newPWO.txt_Other_Innovation_Area__c=objCR.txt_PWODelta_Other_Innovation_Area__c;
                newPWO.pkl_Pricing_Model__c=objCR.pkl_PWORFDelta_Pricing_Model__c;
                newPWO.mpkl_Project_Classification__c=objCR.pkl_PWODelta_Project_Classification__c;
                newPWO.dt_Project_Initiation_Date__c=objCR.dt_PWODelta_Project_Initiation_Date__c;
                newPWO.txt_PWO_title__c=objCR.txta_PWORFDelta_Title__c;
                newPWO.eml_Unilever_Finance_BP_Contact_Email__c=objCR.PWORFDelta_UnileverFinanceBPContactemail__c;
                newPWO.txt_Unilever_Finance_BP_Contact_Name__c=objCR.txtPWORFDelt_UnileverFinanceBPContactnam__c;
                newPWO.mpkl_Unilever_Innovation_Area__c=objCR.mpkl_PWODelta_Unilever_Innovation_Area__c;
                ListnewPWO.add(newPWO); 
            }
        }
        if(ListnewPWO.size()>0){
        insert ListnewPWO;
        List<CPA_project_work_order__c> lstTemp = new List<CPA_project_work_order__c>();
        for(CPA_project_work_order__c obj : ListnewPWO){
            obj.pkl_Status__c = 'Signed';
            obj.txt_Previous_Status_Value__c = 'Signed';
            lstTemp.add(obj);
            mapPWO.put(obj.txt_Linked_Standalone_CR__c,obj.ID);         
        }
        update lstTemp;
        for(CPA_CR__c objCR : newCNFList){
            Id pwo = mapPWO.get(objCR.Id);
            objCR.CPA_Project_Work_Order__c = pwo;
            ListnewCR.add(objCR);
        }
        
        }
    }
    

    
    /**Method Name : DOntDelete
    * Parameter    : OldMap
    * Return type  : void
    * Author       : Shreyas
    * Description  : This method dont allow CR to be deleted
    */
    public static void DOntDeleteCR(list<CPA_CR__c> lstCR){
        
        for(CPA_CR__c objCr :lstCR ){
            objCr.addError('CR cant be deleted');
        }
    }
    /**Method Name : newCR
    * Parameter    : newmap
    * Return type  : void
    * Author       : Pooja Kanani
    * Description  : This method is used to update PWO with the latest CR number
    */
    /*public static void newCR(list<CPA_CR__c> newCRList){
        List<CPA_project_work_order__c> lstTemp= new List<CPA_project_work_order__c>();
        set<ID> pwoID = new set<ID>();
        map<ID,String>pwomap = new map<ID,String>();
         for(CPA_CR__c obj :newCRList){         
                    pwoID.add(obj.CPA_Project_Work_Order__c);
                    pwomap.put(obj.CPA_Project_Work_Order__c,obj.name);     
        }
        if(pwoID!=null && pwoID.size()> 0){
            List<CPA_project_work_order__c> lstPWO  = [Select Id,txt_CNF_CR_number__c from CPA_project_work_order__c where Id IN:pwoID];
            
            for(CPA_project_work_order__c obj : lstPWO){
                Approval.unLockResult lrList = Approval.unlock(obj, false);
                
                obj.txt_CNF_CR_number__c = pwomap.get(obj.id);
                
                lstTemp.add(obj);                    
            }
            
            if(lstTemp!=null && lstTemp.size()>0){
                update lstTemp; 
            }
        }
    }*/
    
    /**Method Name : calculateDelta
    * Parameter    : oldCRList1, newCR1
    * Return type  : void
    * Author       : Shreyas Mangalvedhekar
    * Description  : This method is used to calculate the delta
    */
    public static void calculateDelta(List<CPA_CR__c> oldCRList1,List<CPA_CR__c> newCR1){
        
        
        map<Id,CPA_CR__c> oldCRList = new map<Id,CPA_CR__c> ();
        map<Id,CPA_CR__c> newCR= new map<Id,CPA_CR__c> ();
        
        
        for(CPA_CR__c obj1 : oldCRList1){
            oldCRList.put(obj1.Id,obj1);
        }
        for(CPA_CR__c obj2 :newCR1 ){
            newCR.put(obj2.id,obj2);
        }
        
        List<CPA_CR__c> lstCR = new List<CPA_CR__c>();
        set<ID>setPWOID = new set<ID>();
        map<Id,CPA_CR__c>mapPWOIDCR = new map<ID,CPA_CR__c>();
        map<Id,CPA_Project_Work_Order__c>mapPWO = new map<ID,CPA_Project_Work_Order__c>();
        
        for(CPA_CR__c objCR : newCR.values()){
            if((objCR.pkl_Status__c == CPA_ConstantsForContractingAppClasses.SUBMITTED && oldCRList.get(objCR.Id).pkl_Status__c <> CPA_ConstantsForContractingAppClasses.SUBMITTED)||(objCR.pkl_Status__c == CPA_ConstantsForContractingAppClasses.RESUBMITTED && oldCRList.get(objCR.Id).pkl_Status__c <> CPA_ConstantsForContractingAppClasses.RESUBMITTED)){
                lstCR.add(objCR);
                if(!objCR.chk_isStandalone_CR__c) setPWOID.add(objCR.CPA_Project_Work_Order__c);
            }
        }
      if(setPWOID.size()>0 && setPWOID!=null){  
        List<CPA_project_work_order__c>lstPWO = [Select ID,num_Expense_charges_of_work_order__c,Name,num_Estimated_Man_days_of_PWO__c,num_Estimated_Value_of_PWO__c,num_Target_Blend_Rate__c,num_Total_work_order_charge__c,num_Authorisation_charges__c,num_Authorisation_man_days__c,num_Effort_Cost__c from CPA_project_work_order__c where ID IN :setPWOID];
            for(CPA_project_work_order__c objPwo : lstPWO){
                mapPWO.put(objPwo.Id,objPwo);
            }
                
            List<CPA_CR__c> lstCR1 = [Select Id,num_Delta_Efforts__c,Name,CPA_Project_Work_Order__c,num_Estimated_Man_days_of_CR__c,num_Estimated_Value_of_CR__c,num_Target_Blend_Rate__c,num_Total_charge_of_CR__c,num_Expense_charges_of_CR__c,pec_Expense__c,num_Authorisation_charges__c,num_Authorisation_man_days__c,num_RMS_value__c,num_Effort_Cost__c,pkl_Status__c,num_Total_Resource_Cost_CR__c,num_Total_Expenses_of_CR__c  from CPA_CR__c where CPA_Project_Work_Order__c IN:  setPWOID and pkl_Status__c !=:CPA_ConstantsForContractingAppClasses.CANCELLED and pkl_Status__c !=:CPA_ConstantsForContractingAppClasses.RETURNED and pkl_Status__c !=:CPA_ConstantsForContractingAppClasses.SAVED ORDER BY Createddate DESC limit 2];
            
            if(lstCR1 != null && lstCR1.size()==2 && lstCR1[0]!=null && lstCR1[1]!=null){
                 mapPWOIDCR.put(lstCR1[1].CPA_Project_Work_Order__c,lstCR1[1]);
                
            }else if(lstCR1 != null && lstCR1.size()==1 && lstCR1[0]!=null ) {
                mapPWOIDCR.put(lstCR1[0].CPA_Project_Work_Order__c,lstCR1[0]);
                 
            }
            
            
            for(CPA_CR__c objCRTEmp :lstCR ){
                if(mapPWOIDCR.get(objCRTEmp.CPA_Project_Work_Order__c)==null ){
                    if(mapPWO.get(objCRTEmp.CPA_Project_Work_Order__c)!=null && mapPWO.get(objCRTEmp.CPA_Project_Work_Order__c).num_Estimated_Value_of_PWO__c!=null){
                       objCRTEmp.num_Total_Expenses_of_CR__c = objCRTEmp.num_Expense_charges_of_CR__c - mapPWO.get(objCRTEmp.CPA_Project_Work_Order__c).num_Expense_charges_of_work_order__c;
                        objCRTEmp.num_Delta_Efforts__c = objCRTEmp.num_Estimated_Man_days_of_CR__c - mapPWO.get(objCRTEmp.CPA_Project_Work_Order__c).num_Estimated_Man_days_of_PWO__c;
                        objCRTEmp.num_Total_charge_of_CR__c = objCRTEmp.num_Estimated_Value_of_CR__c - mapPWO.get(objCRTEmp.CPA_Project_Work_Order__c).num_Estimated_Value_of_PWO__c;
                        objCRTEmp.num_Total_Resource_Efforts_CR__c = objCRTEmp.num_Estimated_Man_days_of_CR__c - mapPWO.get(objCRTEmp.CPA_Project_Work_Order__c).num_Estimated_Man_days_of_PWO__c;
                        objCRTEmp.num_Effort_Cost__c = objCRTEmp.num_Effort_Cost__c - mapPWO.get(objCRTEmp.CPA_Project_Work_Order__c).num_Effort_Cost__c;
                    }else if(objCRTEmp.num_Estimated_Value_of_CR__c !=null){
                        Decimal intCostResource = 0;
                        intCostResource = objCRTEmp.num_Effort_Cost__c;
                        objCRTEmp.num_Delta_Efforts__c = objCRTEmp.num_Estimated_Value_of_CR__c ;  
                        objCRTEmp.num_Effort_Cost__c = intCostResource;
                        objCRTEmp.num_Total_Expenses_of_CR__c = objCRTEmp.num_Expense_charges_of_CR__c;                 
                    }else {
                        objCRTEmp.num_Delta_Efforts__c =0;
                    }
                     
                }else {
                    if(mapPWOIDCR.get(objCRTEmp.CPA_Project_Work_Order__c)!=null){
                        if(mapPWOIDCR.get(objCRTEmp.CPA_Project_Work_Order__c).Id == objCRTEmp.Id && mapPWO.get(objCRTEmp.CPA_Project_Work_Order__c).num_Estimated_Value_of_PWO__c!= null){
                            objCRTEmp.num_Delta_Efforts__c = objCRTEmp.num_Estimated_Man_days_of_CR__c - mapPWO.get(objCRTEmp.CPA_Project_Work_Order__c).num_Estimated_Man_days_of_PWO__c;
                           
                           objCRTEmp.num_Total_charge_of_CR__c = objCRTEmp.num_Estimated_Value_of_CR__c - mapPWO.get(objCRTEmp.CPA_Project_Work_Order__c).num_Estimated_Value_of_PWO__c;
                            objCRTEmp.num_Effort_Cost__c = objCRTEmp.num_Effort_Cost__c - mapPWO.get(objCRTEmp.CPA_Project_Work_Order__c).num_Effort_Cost__c;
                            objCRTEmp.num_Total_Resource_Efforts_CR__c = objCRTEmp.num_Estimated_Man_days_of_CR__c - mapPWO.get(objCRTEmp.CPA_Project_Work_Order__c).num_Estimated_Man_days_of_PWO__c;
                            objCRTEmp.num_Total_Expenses_of_CR__c = objCRTEmp.num_Expense_charges_of_CR__c - mapPWO.get(objCRTEmp.CPA_Project_Work_Order__c).num_Expense_charges_of_work_order__c;
                        } else if(mapPWOIDCR.get(objCRTEmp.CPA_Project_Work_Order__c).Id == objCRTEmp.Id && mapPWO.get(objCRTEmp.CPA_Project_Work_Order__c).num_Estimated_Value_of_PWO__c== null){
                            objCRTEmp.num_Delta_Efforts__c = 0;
                            objCRTEmp.num_Total_charge_of_CR__c = objCRTEmp.num_Estimated_Value_of_CR__c;
                            objCRTEmp.num_Total_Expenses_of_CR__c = objCRTEmp.num_Expense_charges_of_CR__c; 
                        }
                      else{
                          if(mapPWOIDCR.get(objCRTEmp.CPA_Project_Work_Order__c).num_Estimated_Value_of_CR__c != null){
                          objCRTEmp.num_Delta_Efforts__c =objCRTEmp.num_Estimated_Man_days_of_CR__c  - mapPWOIDCR.get(objCRTEmp.CPA_Project_Work_Order__c).num_Estimated_Man_days_of_CR__c;
                          
                          objCRTEmp.num_Effort_Cost__c = objCRTEmp.num_Effort_Cost__c - mapPWOIDCR.get(objCRTEmp.CPA_Project_Work_Order__c).num_Total_Resource_Cost_CR__c; 
                          objCRTEmp.num_Total_Resource_Efforts_CR__c = objCRTEmp.num_Estimated_Man_days_of_CR__c - mapPWOIDCR.get(objCRTEmp.CPA_Project_Work_Order__c).num_Estimated_Man_days_of_CR__c;
                          objCRTEmp.num_Total_Expenses_of_CR__c = objCRTEmp.num_Expense_charges_of_CR__c - mapPWOIDCR.get(objCRTEmp.CPA_Project_Work_Order__c).num_Expense_charges_of_CR__c;
                          objCRTEmp.num_Total_charge_of_CR__c = objCRTEmp.num_Estimated_Value_of_CR__c - mapPWOIDCR.get(objCRTEmp.CPA_Project_Work_Order__c).num_Estimated_Value_of_CR__c;
                        } 
                      }  
                        
                    }           
                
                }
            }
        }
    }
   /*
    * Method Name : CalculatePOWCost
    * Parameter   : 
    * Return type : None
    * Description : This method is used to Calculate POW
    */
     public static List<CPA_project_work_order__c> CalculatePOWCost(List<CPA_CR__c> oldCRList,List<CPA_CR__c> newCRList)    
    {
     set<ID> setCRID = new set<Id>();
     set<ID> setPWOID = new set<Id>();   
     map<ID,list<CPA_CR__c>> mapPWOtoListCR = new map<ID,list<CPA_CR__c>>();
     map<Id,CPA_project_work_order__c> mapPWO = new map<ID,CPA_project_work_order__c>();
     List<CPA_project_work_order__c> listPWOUpdate = new List<CPA_project_work_order__c> ();
     List<CPA_CR__c> listCR   = new List<CPA_CR__c> ();
     
      for (Integer i = 0; i < newCRList.size(); i++) {
        if (oldCRList[i].pkl_Status__c  <> newCRList[i].pkl_Status__c) {
            setCRID.add(newCRList[i].Id);
            if(newCRList[i].CPA_project_work_order__c !=null){
                setPWOID.add(newCRList[i].CPA_project_work_order__c);
            }
        }
 
    }
        
        if(setPWOID !=null){
            listCR = [Select Id,num_Total_charge_of_CR__c,CPA_project_work_order__c,pkl_Status__c from CPA_CR__c where CPA_project_work_order__c IN: setPWOID];   
            for(CPA_project_work_order__c objPWOMap : [Select Id,num_Total_work_order_charge__c,num_Estimated_Value_of_PWO__c from CPA_project_work_order__c where ID IN: setPWOID]){
                mapPWO.put(objPWOMap.Id,objPWOMap);
            }   
            for (ID objPWOID :setPWOID ){
                List<CPA_CR__c> lstTemp = new List<CPA_CR__c>();
                for(CPA_CR__c objCR : listCR){
                    if(objCR.CPA_project_work_order__c == objPWOID){
                        lstTemp.add(objCR);
                    }
                }
                mapPWOtoListCR.put(objPWOID,lstTemp);           
            }
            for(ID objPWOID :setPWOID){
                double dobCosttoadd = 0;
                double dobCosttoSub = 0;
                for(CPA_CR__c objCR : mapPWOtoListCR.get(objPWOID)){
                    if(objCR.pkl_Status__c == CPA_ConstantsForContractingAppClasses.SUBMITTED || objCR.pkl_Status__c == CPA_ConstantsForContractingAppClasses.RESUBMITTED || objCR.pkl_Status__c == CPA_ConstantsForContractingAppClasses.ACCEPTED || objCR.pkl_Status__c == CPA_ConstantsForContractingAppClasses.SIGNED || objCR.pkl_Status__c == CPA_ConstantsForContractingAppClasses.SentForClosure  || objCR.pkl_Status__c == CPA_ConstantsForContractingAppClasses.DELIVERED){
                     //Dinesh added this null check to avoid null pointer exception
                     //when we import CR and try to proceed.
                     //14/04/2016 - Dinesh commented it as no need to modify code for data migration
                     //if(objCR.num_Total_charge_of_CR__c != null){
                         dobCosttoadd = dobCosttoadd + objCR.num_Total_charge_of_CR__c;
                     //}
                 }
                }
                if( mapPWO.get(objPWOID) !=null ){
                    CPA_project_work_order__c objPWOUpdate = mapPWO.get(objPWOID);
                    if(mapPWO.get(objPWOID).num_Estimated_Value_of_PWO__c!= null){
                        objPWOUpdate.num_Total_work_order_charge__c = (objPWOUpdate.num_Estimated_Value_of_PWO__c + dobCosttoadd);
                        listPWOUpdate.add(objPWOUpdate);
                    }
                    
                    system.debug('objPWOUpdate-->'+objPWOUpdate);
                }       
                
            }
        }
    
    
    if(listPWOUpdate!=null && listPWOUpdate.size()>0){
        return listPWOUpdate;
    }
    
    return null;        
        
    }
     /** Method Name : checkPWOTermination
    * Parameter   : newCRList,oldCRList
    * Return type : None
    * Author      : Shreyas Mangalvedhekar  
    * Description : This method make the Approval comments require
    */
    public static void checkPWOTermination(List<CPA_CR__c> newCRList,List<CPA_CR__c> oldCRList){
 
  // Create a map that stores all the objects that require editing 
  Map<Id, CPA_CR__c> approvalStatements = new Map<Id, CPA_CR__c>{};
  Map<Id, CPA_CR__c> oldCRS = new Map<Id, CPA_CR__c>{};
  set<Id> setPWO = new set<ID>();
  map<ID,CPA_project_work_order__c> mapPWO = new map<ID,CPA_project_work_order__c> ();
  
  for(CPA_CR__c objCR1 :oldCRList ){
      oldCRS.put(objCR1.Id,objCR1);
  }
  for(CPA_CR__c objCR: newCRList){
      setPWO.add(objCR.CPA_project_work_order__c);
  }
  for(CPA_project_work_order__c ojPWO : [Select Id, pkl_Status__c from CPA_project_work_order__c where Id IN:setPWO]){
      mapPWO.put(ojPWO.Id,ojPWO);
  }
  for(CPA_CR__c inv: newCRList)
  {
    // Put all objects for update that require a comment check in a map,
    // so we only have to use 1 SOQL query to do all checks
    CPA_project_work_order__c objPWO = mapPWO.get(inv.CPA_project_work_order__c);
    if ( objPWO !=null && ((inv.pkl_Status__c == CPA_ConstantsForContractingAppClasses.ACCEPTED && oldCRS.get(inv.Id).pkl_Status__c != CPA_ConstantsForContractingAppClasses.ACCEPTED) || (inv.pkl_Status__c == CPA_ConstantsForContractingAppClasses.RETURNED  && oldCRS.get(inv.Id).pkl_Status__c != CPA_ConstantsForContractingAppClasses.RETURNED) )&&(objPWO.pkl_Status__c ==CPA_ConstantsForContractingAppClasses.REQUESTFORTERMINATION || objPWO.pkl_Status__c ==CPA_ConstantsForContractingAppClasses.SentForTermination || objPWO.pkl_Status__c ==CPA_ConstantsForContractingAppClasses.Terminated  ))
    { 
      approvalStatements.put(inv.Id, inv);      
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
      
        approvalStatements.get(pi.TargetObjectId).addError(
         '<br/><br/><Strong style= "color:red">Error: </Strong><b>CR Cannot be Accepted / Returned, as PWO set for Termination</b><br/><br/>');
      
    }                                       
  }
}
}