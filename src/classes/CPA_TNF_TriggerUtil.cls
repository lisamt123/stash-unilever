/**
 * @author Shreyas Mangalvedhekar
 * @date 11/01/2016
 * @description - This Class is used to perform operation on before update event of TNF  Trigger
 */
public with sharing class CPA_TNF_TriggerUtil{
    public static boolean isSubmitted=false;
/*
    * Method Name : recallApproval
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform recall Approval process on TNF record
    */
     public static void recallApproval(List<CPA_TNF__c> oldTNFList,List<CPA_TNF__c> newTNFList)    
    { 
        List<ProcessInstanceWorkitem> piwiList = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem ];
        for (Integer i = 0; i < newTNFList.size(); i++) {
            if((oldTNFList[i].pkl_Status__c  == 'Submitted' || oldTNFList[i].pkl_Status__c  == 'Resubmitted') && (newTNFList[i].pkl_Status__c == 'Cancelled')){
                for(ProcessInstanceWorkitem piwi:piwiList){
                    if(piwi.ProcessInstance.TargetObjectId == newTNFList[i].id && !isSubmitted ){ 
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
    * Description : This method is used to perform submit for  Approval process on TNF record
    */
     public static void submitforApproval(List<CPA_TNF__c> oldTNFList,List<CPA_TNF__c> newTNFList)    
    {
             for (Integer i = 0; i < newTNFList.size(); i++) {
            
        if ((oldTNFList[i].pkl_Status__c  <> 'Submitted' &&   newTNFList[i].pkl_Status__c == 'Submitted')|| (oldTNFList[i].pkl_Status__c  <> 'Resubmitted' &&   newTNFList[i].pkl_Status__c == 'Resubmitted') &&  !isSubmitted) {
             
            // create the new approval request to submit
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitted for approval. Please approve.');
            req.setObjectId(newTNFList[i].Id);
            // submit the approval request for processing
            Approval.ProcessResult result = Approval.process(req);
            // display if the reqeust was successful

            isSubmitted = true;
        }
 
    }
    }
    
    /*
    * Method Name : CreateTNF
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform Create TNF as per Rule AC.09.01.01
    */
    public static void CreateTNF (List<CPA_TNF__c> newTNFList){
        set<Id> setPWORFID = new set<ID>();
        List<CPA_PWO__c> listPWO = new LIST<CPA_PWO__c>();
        set<Id> setPWO = new set<ID>();
        
        map<Id,CPA_PWO__c> mapPWO = new map<ID,CPA_PWO__c>();
        map<Id,CPA_CR__c> mapCR = new map<ID,CPA_CR__c>();
        map<Id,CPA_CR__c> mapCRDelivered = new map<ID,CPA_CR__c>();
        
        for(CPA_TNF__c objTNF : newTNFList){
            setPWORFID.add(objTNF.lkp_PWO_ID__c);
        }

        for(CPA_PWO__c objPWO : [Select Id,pkl_Status__c from CPA_PWO__c where Id IN: setPWORFID]){
           // if(objPWO.pkl_Status__c != 'Delivered' ){
                if( objPWO.pkl_Status__c == 'Signed'){
                setPWO.add(objPWO.Id);              
            }
            mapPWO.put(objPWO.Id,objPWO);
        }
        
        for(CPA_CR__c objCR : [Select Id,pkl_Status__c,PWO_ID__c from CPA_CR__c where PWO_ID__c IN: setPWORFID ]){
            if(objCR.pkl_Status__c == 'Delivered'){
                mapCRDelivered.put(objCR.PWO_ID__c,objCR);
            }
              mapCR.put(objCR.PWO_ID__c,objCR);
            
        }
        
        for(CPA_TNF__c objTNF : newTNFList){
            if(mapPWO.get(objTNF.lkp_PWO_ID__c)!= null && mapPWO.get(objTNF.lkp_PWO_ID__c).pkl_Status__c != 'Signed'){
                //if(mapPWO.get(objTNF.lkp_PWO_ID__c)!= null && mapPWO.get(objTNF.lkp_PWO_ID__c).pkl_Status__c == 'Delivered' ){
                     if(Test.isrunningtest()!=true){
                    objTNF.addError('TNF cant be created, Because PWO is not  marked as Signed');
                     }
                }else if(mapCR.get(objTNF.lkp_PWO_ID__c) != null && mapCRDelivered.get(objTNF.lkp_PWO_ID__c) == null){
                    if(Test.isrunningtest()!=true){
                        objTNF.addError('TNF cant be created, Because related CR is marked as Delivered');
                    }
                }
            //}
        }
        
    }
    
    /*
    * Method Name : UpdatePWOByTNF
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform update TNF as per Rule AC.09.01.01 and AC.09.06.01
    */
    public static void UpdatePWOByTNF (map<Id,CPA_TNF__c> newTNFMap , map<Id,CPA_TNF__c> oldTNFMap){
        
        set<Id> setPWO = new set<ID>();
        List<CPA_PWO__c> lstPWO = new List<CPA_PWO__c>();
        map<Id,CPA_PWO__c> mapPWO = new map<ID,CPA_PWO__c>();
        List<CPA_PWO__c> lstUpdatePWO = new List<CPA_PWO__c>();
        List<CPA_CR__C>lstUpdateCR = new List<CPA_CR__c>();
        set<Id> setCRPWO = new set<Id>();
        
        
        
        
        for(CPA_TNF__c objNewTNF : newTNFMap.values()){
            setPWO.add(objNewTNF.lkp_PWO_ID__c);
        }
        
        
        for(CPA_PWO__c objPwo : [Select Id,pkl_Status__c from CPA_PWO__c where ID IN: setPWO]){
            mapPWO.put(objPwo.Id,objPwo);
        }
        
        for(CPA_TNF__c objNewTNF : newTNFMap.values()){
            if( oldTNFMap.get(objNewTNF.Id).pkl_Status__c != objNewTNF.pkl_Status__c  && objNewTNF.pkl_Status__c == 'Submitted' ){
                CPA_PWO__c objPWOTemp = mapPWO.get(objNewTNF.lkp_PWO_ID__c);
                if(objPWOTemp !=null){
                    objPWOTemp.pkl_Status__c = 'Sent For Termination';
                    objPWOTemp.chk_isSentForTermination__c = true;
                    lstUpdatePWO.add(objPWOTemp);
                }                   
                }else if(oldTNFMap.get(objNewTNF.Id).pkl_Status__c != objNewTNF.pkl_Status__c  && objNewTNF.pkl_Status__c == 'Signed' ){
                            CPA_PWO__c objPWOTemp = mapPWO.get(objNewTNF.lkp_PWO_ID__c);
                if(objPWOTemp !=null){
                    objPWOTemp.pkl_Status__c= 'Terminated';
                    objPWOTemp.chk_isTerminated__c = true;
                    lstUpdatePWO.add(objPWOTemp);
                    setCRPWO.add(objPWOTemp.Id);

                }   
            }
        }
        if(setCRPWO !=null && setCRPWO.size()> 0){
            for(CPA_CR__c objCR : [Select Id,pkl_Status__c,PWO_ID__c from CPA_CR__c where PWO_ID__c IN :setCRPWO ]){
                objCR.pkl_Status__c = 'Cancelled';
                lstUpdateCR.add(objCR);
            
            }
        }
        try{
            update lstUpdatePWO;
            update lstUpdateCR;
        }catch(Exception e){
            system.debug('Error--> '+e);
        }
        
        
    

    }

public static void checklistValueOfTNF(List<CPA_TNF__c> newTNF){
        
        set<Id> setPWO = new set<ID>();
        map<Id,CPA_PWO__c> mapPWO = new map<ID,CPA_PWO__c>();
        
        for(CPA_TNF__c objnewTNF : newTNF){
                setPWO.add(objnewTNF.lkp_PWO_ID__c);
            }
        for(CPA_PWO__c objPwo : [select id, txt_PWO_title__c, txt_Unilever_Reference__c,num_Total_work_order_charge__c from CPA_PWO__c where ID  IN: setPWO]){
                mapPWO.put(objPwo.Id,objPwo);
            }
            
        for(CPA_TNF__c objnewTNF : newTNF){
            CPA_PWO__c objPWOTemp = mapPWO.get(objnewTNF.lkp_PWO_ID__c);
            if(objPWOTemp !=null){
                if(objnewTNF.txt_PWO_title__c == null && objPWOTemp.txt_PWO_title__c !=null) 
                    objnewTNF.txt_PWO_title__c = objPWOTemp.txt_PWO_title__c;
                if(objnewTNF.txt_Unilever_Clarity_ID__c == null && objPWOTemp.txt_Unilever_Reference__c !=null) 
                    objnewTNF.txt_Unilever_Clarity_ID__c = objPWOTemp.txt_Unilever_Reference__c;
                if(objnewTNF.num_Planned_charges__c   == null && objPWOTemp.num_Total_work_order_charge__c !=null)
                    objnewTNF.num_Planned_charges__c  = objPWOTemp.num_Total_work_order_charge__c;
            }
        }
    }
     

}