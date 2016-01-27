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
        map<Id,CPA_PWO__c> mapPWO  = new map <ID,CPA_PWO__c>();
        for(CPA_CR__c objCR : newCNFList){
            setPWOID.add(objCR.PWO_ID__c);
        }
        for(CPA_PWO__c objPWO : [Select Id,pkl_Status__c from CPA_PWO__c where Id IN: setPWOID]){
           /* if(objPWO.chk_isCNF_TNF__c == true){
                objPWO.addError('CR cant be created, Because CNF is created ');             
            }*/
            mapPWO.put(objPWO.Id,objPWO);
            
        }   
         for(CPA_CR__c objCR : newCNFList){
            if(mapPWO.get(objCR.PWO_ID__c)!= null && (mapPWO.get(objCR.PWO_ID__c).pkl_Status__c == 'Sent For Closure' || mapPWO.get(objCR.PWO_ID__c).pkl_Status__c == 'Closed')){
                objCR.addError('CR cant be created, Because PWO is under Closure');  
            }else if(mapPWO.get(objCR.PWO_ID__c)!= null && (mapPWO.get(objCR.PWO_ID__c).pkl_Status__c == 'Sent For Termination' || mapPWO.get(objCR.PWO_ID__c).pkl_Status__c == 'Terminated' || mapPWO.get(objCR.PWO_ID__c).pkl_Status__c == 'Request For Termination')){
                objCR.addError('CR cant be created, Because PWO is under Termination');
            }
        }
     }   
public static void checklistValueOfCR(List<CPA_CR__c> newCR){
        
        set<Id> setPWO = new set<ID>();
        map<Id,CPA_PWO__c> mapPWO = new map<ID,CPA_PWO__c>();
        
        for(CPA_CR__c objnewCR : newCR){
                setPWO.add(objnewCR.PWO_ID__c);
            }
        for(CPA_PWO__c objPwo : [select id, txt_Unilever_Reference__c,fml_Unilever_Project_Name_on_PWORF__c,lkp_Unilever_budget_approver__c,lkp_Unilever_content_approver__c,mpkl_Project_Phases__c,pkl_Region__c from CPA_PWO__c where ID  IN: setPWO]){
                mapPWO.put(objPwo.Id,objPwo);
            }
            
        for(CPA_CR__c objnewCR : newCR){
            CPA_PWO__c objPWOTemp = mapPWO.get(objnewCR.PWO_ID__c);
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

}