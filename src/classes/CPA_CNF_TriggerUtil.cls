/**
 * @author Shreyas Mangalvedhekar
 * @date 11/01/2016
 * @desCNFiption - This Class is used to perform operation on before update event of CNF  Trigger
 */
public class CPA_CNF_TriggerUtil{
    public static boolean isSubmitted=false;
/*
    * Method Name : recallApproval
    * Parameter   : 
    * Return type : None
    * DesCNFiption : This method is used to perform recall Approval process on CNF record
    */
     public static void recallApproval(List<CPA_CNF__c> CNFOldList,List<CPA_CNF__c> newCNFList)    
    { 
        List<ProcessInstanceWorkitem> piwiList = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem ];
        for (Integer i = 0; i < newCNFList.size(); i++) {
            if((CNFOldList[i].pkl_Status__c  == 'Submitted' || CNFOldList[i].pkl_Status__c  == 'Resubmitted') && (newCNFList[i].pkl_Status__c == 'Cancelled')){
                for(ProcessInstanceWorkitem piwi:piwiList){
                    if(piwi.ProcessInstance.TargetObjectId == newCNFList[i].id  && !isSubmitted ){ 
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
    * DesCNFiption : This method is used to perform submit for  Approval process on CNF record
    */
     public static void submitforApproval(List<CPA_CNF__c> oldCNFList,List<CPA_CNF__c> newCNFList)    
    {
             for (Integer i = 0; i < newCNFList.size(); i++) {
            
        if ((oldCNFList[i].pkl_Status__c  <> 'Submitted' &&   newCNFList[i].pkl_Status__c == 'Submitted')|| (oldCNFList[i].pkl_Status__c  <> 'Resubmitted' &&   newCNFList[i].pkl_Status__c == 'Resubmitted') &&  !isSubmitted) {
             
            // CNFeate the new approval request to submit
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitted for approval. Please approve.');
            req.setObjectId(newCNFList[i].Id);
            // submit the approval request for processing
            Approval.ProcessResult result = Approval.process(req);
            // display if the reqeust was successful

            isSubmitted = true;
        }
 
    }
    }
    
 /*
    * Method Name : CreateCNF
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform Create CNF as per Rule AC.11.01.01
    */
    public static void CreateCNF (List<CPA_CNF__c > newCNFList){
        set<Id> setPWORFID = new set<ID>();
        List<CPA_PWO__c> listPWO = new LIST<CPA_PWO__c>();
        set<Id> setPWO = new set<ID>();
        
        map<Id,CPA_PWO__c> mapPWO = new map<ID,CPA_PWO__c>();
        map<Id,CPA_CR__c> mapCR = new map<ID,CPA_CR__c>();
        map<Id,CPA_CR__c> mapCR1 = new map<ID,CPA_CR__c>();
        
        
        
        for(CPA_CNF__c objCNF : newCNFList){
            setPWORFID.add(objCNF.PWO_ID__c);
        }

        for(CPA_PWO__c objPWO : [Select Id,pkl_Status__c from CPA_PWO__c where Id IN: setPWORFID]){
            mapPWO.put(objPWO.Id,objPWO);
        }
        
        //for(CPA_CR__c objCR : [Select Id,pkl_Status__c,PWO_ID__c from CPA_CR__c where PWO_ID__c IN: setPWORFID AND (pkl_Status__c != 'Delivered' AND pkl_Status__c != 'Cancelled')]){
        for(CPA_CR__c objCR : [Select Id,pkl_Status__c,PWO_ID__c from CPA_CR__c where PWO_ID__c IN: setPWORFID ]){
                mapCR.put(objCR.PWO_ID__c,objCR);  
                if((objCR.pkl_Status__c == 'Delivered' || objCR.pkl_Status__c == 'Cancelled')){
                    mapCR1.put(objCR.PWO_ID__c,objCR);
                
                }
        }
    
        for(CPA_CNF__c objCNF : newCNFList){
            if((mapPWO.get(objCNF.PWO_ID__c)!= null && mapPWO.get(objCNF.PWO_ID__c).pkl_Status__c != 'Delivered' ) ){ 
                    ObjCNF.addError('CNF cant be created, Because PWO is not yet Delivered');                
            }              
            else if(mapCR.get(objCNF.PWO_ID__c) != null && mapCR1.get(objCNF.PWO_ID__c) == null){
                      ObjCNF.addError('CNF cant be created, Because CR is not marked as Delivered'); 
                }
           
        }
     }
        /*
    * Method Name : UpdatePWOByCNF
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform update CNF as per Rule AC.11.01.01 and AC.11.06.01
    */
    public static void UpdatePWOByCNF (map<Id,CPA_CNF__c> newTNFMap , map<Id,CPA_CNF__c> oldTNFMap){
        
        set<Id> setPWO = new set<ID>();
        List<CPA_PWO__c> lstPWO = new List<CPA_PWO__c>();
        map<Id,CPA_PWO__c> mapPWO = new map<ID,CPA_PWO__c>();
        List<CPA_PWO__c> lstUpdatePWO = new List<CPA_PWO__c>();
        List<CPA_CR__C>lstUpdateCR = new List<CPA_CR__c>();
        
        
        for(CPA_CNF__c objNewCNF : newTNFMap.values()){
            setPWO.add(objNewCNF.PWO_ID__c);
        }        
        
        for(CPA_PWO__c objPwo : [Select Id,pkl_Status__c from CPA_PWO__c where ID IN: setPWO]){
            mapPWO.put(objPwo.Id,objPwo);
        }
        
        for(CPA_CNF__c objNewCNF : newTNFMap.values()){
            if( oldTNFMap.get(objNewCNF.Id).pkl_Status__c != objNewCNF.pkl_Status__c  && objNewCNF.pkl_Status__c == 'Saved' ){
                CPA_PWO__c objPWOTemp = mapPWO.get(objNewCNF.PWO_ID__c);
                if(objPWOTemp !=null){
                    objPWOTemp.pkl_Status__c = 'Sent For Closure';
                    lstUpdatePWO.add(objPWOTemp);
                }                   
                }else if(oldTNFMap.get(objNewCNF.Id).pkl_Status__c != objNewCNF.pkl_Status__c  && objNewCNF.pkl_Status__c == 'Signed' ){
                            CPA_PWO__c objPWOTemp = mapPWO.get(objNewCNF.PWO_ID__c);
                if(objPWOTemp !=null){
                    objPWOTemp.pkl_Status__c= 'Closed';
                    lstUpdatePWO.add(objPWOTemp);
                    

                }   
            }
        }
        
        try{
            update lstUpdatePWO;
            
        }catch(Exception e){
            
        }
        
        
    

    }
public static void checklistValueOfCNF(List<CPA_CNF__c> newCNF){
        
        set<Id> setPWO = new set<ID>();
        map<Id,CPA_PWO__c> mapPWO = new map<ID,CPA_PWO__c>();
        
        for(CPA_CNF__c objnewCNF : newCNF){
                setPWO.add(objnewCNF.PWO_ID__c);
            }
        for(CPA_PWO__c objPwo : [select id, txt_PWO_title__c, txt_Unilever_Reference__c,lkp_Unilever_budget_approver__c,lkp_Unilever_content_approver__c,num_Estimated_Man_days_of_PWO__c,pec_Expense__c,num_Total_work_order_charge__c,dt_Expected_End_date__c from CPA_PWO__c where ID  IN: setPWO]){
                mapPWO.put(objPwo.Id,objPwo);
            }
            
        for(CPA_CNF__c objnewCNF : newCNF){
            CPA_PWO__c objPWOTemp = mapPWO.get(objnewCNF.PWO_ID__c);
            if(objPWOTemp !=null){
                if(objnewCNF.txt_PWO_title__c == null && objPWOTemp.txt_PWO_title__c !=null) 
                    objnewCNF.txt_PWO_title__c = objPWOTemp.txt_PWO_title__c;
                if(objnewCNF.txt_Unilever_Clarity_ID__c == null && objPWOTemp.txt_Unilever_Reference__c !=null) 
                    objnewCNF.txt_Unilever_Clarity_ID__c = objPWOTemp.txt_Unilever_Reference__c;
                if(objnewCNF.lkp_Unilever_budget_approver__c == null && objPWOTemp.lkp_Unilever_budget_approver__c !=null) 
                    objnewCNF.lkp_Unilever_budget_approver__c = objPWOTemp.lkp_Unilever_budget_approver__c;
                if(objnewCNF.lkp_Unilever_content_approver__c == null && objPWOTemp.lkp_Unilever_content_approver__c !=null)
                    objnewCNF.lkp_Unilever_content_approver__c = objPWOTemp.lkp_Unilever_content_approver__c;
                if(objnewCNF.num_Planned_man_days__c == null && objPWOTemp.num_Estimated_Man_days_of_PWO__c !=null)
                    objnewCNF.num_Planned_man_days__c = objPWOTemp.num_Estimated_Man_days_of_PWO__c;
                //if(objnewCNF.num_Planned_expenses__c   == null && objPWOTemp.pec_Expense__c !=null)
                    //objnewCNF.num_Planned_expenses__c  = objPWOTemp.pec_Expense__c;
                if(objnewCNF.num_Planned_total_charges__c   == null && objPWOTemp.num_Total_work_order_charge__c !=null)
                    objnewCNF.num_Planned_total_charges__c  = objPWOTemp.num_Total_work_order_charge__c;
                if(objnewCNF.dt_Planned_PWO_End_Date__c   == null && objPWOTemp.dt_Expected_End_date__c !=null)
                    objnewCNF.dt_Planned_PWO_End_Date__c  = objPWOTemp.dt_Expected_End_date__c;
            }
        }
    }
    
    
    }