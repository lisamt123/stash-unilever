/**
 * @author Pooja Kanani
 * @date 11/01/2016
 * @description - This Class is used to perform operation on before update event of PWOTrigger
 */
public class CPA_PWO_TriggerUtil{
    public static boolean isSubmitted=false;
/*
    * Method Name : recallApproval
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform recall Approval process on PWO record
    */
     public static void recallApproval(List<CPA_PWO__c> PWOOldList,List<CPA_PWO__c> newPWOList)    
    { 
        List<ProcessInstanceWorkitem> piwiList = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem ];
        for (Integer i = 0; i < newPWOList.size(); i++) {
            if((PWOOldList[i].pkl_Status__c  == 'Submitted' || PWOOldList[i].pkl_Status__c  == 'Resubmitted') && (newPWOList[i].pkl_Status__c == 'Cancelled' || newPWOList[i].pkl_Status__c == 'Sent For Termination' || newPWOList[i].pkl_Status__c == 'Terminated')){
                //PWO.isCancelled__c = true;
                for(ProcessInstanceWorkitem piwi:piwiList){
                    if(piwi.ProcessInstance.TargetObjectId == newPWOList[i].id && !isSubmitted ){ 
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
     public static void submitforApproval(List<CPA_PWO__c> oldPWOList,List<CPA_PWO__c> newPWOList)    
    {

        set<id> setID = new set<Id>();
        List<CPA_PWORF__c> lstTemp = new List<CPA_PWORF__c>();
        
         for (Integer i = 0; i < newPWOList.size(); i++) {
                
            if ((oldPWOList[i].pkl_Status__c  <> 'Submitted' &&   newPWOList[i].pkl_Status__c == 'Submitted')|| (oldPWOList[i].pkl_Status__c  <> 'Resubmitted' &&   newPWOList[i].pkl_Status__c == 'Resubmitted') &&  !isSubmitted) {
                 
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
            List<CPA_PWORF__c> lstPWORF  = [Select Id,pkl_Status__c from CPA_PWORF__c where Id IN:setID ];
         
             for(CPA_PWORF__c obj : lstPWORF){
                 if(obj.pkl_Status__c != 'Answered '){
                     obj.pkl_Status__c = 'Answered ';
                     lstTemp.add(obj);  
                 }       
                         
             }
             if(lstTemp!=null && lstTemp.size()>0){
                update lstTemp; 
             }
        }
        
    }
    
     /*
    * Method Name : UpdatePworf
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform submit for  Approval process on PWO record
    */
    /* public static void UpdatePworf(map<Id,CPA_PWO__c>newMap){
         
         set<id> setID = new set<Id>();
         List<CPA_PWORF__c> lstTemp = new List<CPA_PWORF__c>();
         
             for(CPA_PWO__c objPwo : newMap.values()){
                 setID.add(objPwo.PWORF_ID__c);
             }
         List<CPA_PWORF__c> lstPWORF  = [Select Id,pkl_Status__c from CPA_PWORF__c where Id IN:setID ];
         
         for(CPA_PWORF__c obj : lstPWORF){
             if(obj.pkl_Status__c != 'Answered '){
                 obj.pkl_Status__c = 'Answered ';
                 lstTemp.add(obj);  
             }       
                     
         }
         if(lstTemp!=null && lstTemp.size()>0){
            update lstTemp; 
         }
         
    }*/
     /*
    * Method Name : previouStatusValue
    * Parameter   : 
    * Return type : None
    * Description : This method store the previous value of the PWO Status field
    */
    public static void previouStatusValue(List<CPA_PWO__c> oldPWOList,List<CPA_PWO__c> newPWOList){
        for (Integer i = 0; i < newPWOList.size(); i++) {            
            newPWOList[i].txt_Previous_Status_Value__c  = oldPWOList[i].pkl_Status__c; 
        }
    }

    public static void checklistValueOfPWO(List<CPA_PWO__c> newmapPWO,boolean isInsertPWO ,boolean isBeforePWO){
            set<Id> setPwoId = new set<Id>();
            List<CPA_PWO__c> lstPWO = new List<CPA_PWO__c>();
            map<Id,List<CPA_PWO__c>> mapPWORFIDPWO = new map<Id,List<CPA_PWO__c>>();
            map<Id,CPA_PWORF__c> mapPWORF = new map<ID,CPA_PWORF__c>();
            Map<string,CPA_PWORF_Record_type__c> customSettingPworfRT = CPA_PWORF_Record_type__c.getAll(); 
            system.debug('newmapPWO-->'+newmapPWO);
            if(newmapPWO!= null ){
                 for(CPA_PWO__c objPWo : newmapPWO){
                    setPwoId.add(objPWo.PWORF_ID__c);
                }
                if(isInsertPWO == true && isBeforePWO == true){
                    lstPWO = [Select Id,PWORF_ID__c from CPA_PWO__c where PWORF_ID__c IN:setPwoId];
                    
                    for(ID objID : setPwoId){
                        List<CPA_PWO__c> TempList = new List<CPA_PWO__c>();
                        for(CPA_PWO__c obj : lstPWO){
                            if(objID == obj.PWORF_ID__c){
                                TempList.add(obj);
                            }
                            
                        }
                        mapPWORFIDPWO.put(objID,TempList);
                        
                    }
                }
                for(CPA_PWORF__c objPworf : [select id,txt_Internal_PWO_ID__c,mpkl_Project_Phases__c,auto_PWORF_ID__c,txta_Title__c,lkp_Unilever_budget_approver__c,lkp_Unilever_content_approver__c,lkp_Unilever_Finance_BP_Contact__c,txt_Clarity_ID__c,pkl_Region__c,pkl_Project_Scale__c,RecordTypeid,pkl_Business_Area__c  from CPA_PWORF__c where ID  IN: setPwoId]){
                    mapPWORF.put(objPworf.Id,objPworf);
                }
                for(CPA_PWO__c objPWo : newmapPWO){
                    CPA_PWORF__c objPWORFTemp = mapPWORF.get(objPWo.PWORF_ID__c);
                    if(isInsertPWO == true && isBeforePWO == true){
                        List<CPA_PWO__c> listTemp = mapPWORFIDPWO.get(objPWo.PWORF_ID__c);
                        integer intCount;                   
                        if(listTemp!=null && listTemp.size()>0){
                            intCount = listTemp.size();
                            intCount = intCount+1;
                            objPWo.num_Number_Od_PWO__c = string.valueof(intCount);
                            objPWo.txt_Internal_PWO_ID__c = objPWORFTemp.auto_PWORF_ID__c+ ' - PWO-'+ objPWo.num_Number_Od_PWO__c;
                        }else {
                            objPWo.txt_Internal_PWO_ID__c = objPWORFTemp.txt_Internal_PWO_ID__c;
                            
                        }
                      /*  objPWo.num_Number_Od_PWO__c = string.valueof(intCount);
                        objPWo.txt_Internal_PWO_ID__c = objPWORFTemp.auto_PWORF_ID__c+ ' - PWO-'+ objPWo.num_Number_Od_PWO__c;*/
                        
                    }                    
                    if(objPWORFTemp !=null){
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
                        if(objPWo.lkp_Unilever_budget_approver__c == null && objPWORFTemp.lkp_Unilever_budget_approver__c !=null) 
                            objPWo.lkp_Unilever_budget_approver__c = objPWORFTemp.lkp_Unilever_budget_approver__c;
                        if(objPWo.lkp_Unilever_content_approver__c == null && objPWORFTemp.lkp_Unilever_content_approver__c !=null) 
                            objPWo.lkp_Unilever_content_approver__c = objPWORFTemp.lkp_Unilever_content_approver__c;
                        if(objPWo.lkp_Unilever_Finance_BP_Contact__c == null && objPWORFTemp.lkp_Unilever_Finance_BP_Contact__c !=null) 
                            objPWo.lkp_Unilever_Finance_BP_Contact__c = objPWORFTemp.lkp_Unilever_Finance_BP_Contact__c;
                        if(objPWORFTemp.pkl_Project_Scale__c != null){
                            if(objPWORFTemp.RecordTypeid == customSettingPworfRT.get('All').Record_type_id__c ){
                                if(objPWORFTemp.pkl_Project_Scale__c == 'Small Project (<50 days)') objPWo.mpkl_Project_Classification__c = 'Other';
                                else if(objPWORFTemp.pkl_Project_Scale__c == 'Large Project (>2000 days) Project (<50 days)') objPWo.mpkl_Project_Classification__c = 'Complex';
                                else if(objPWORFTemp.pkl_Project_Scale__c == 'Low Complexity Project (50 - 100 days)' ) objPWo.mpkl_Project_Classification__c = 'Low Complexity';
                                else if(objPWORFTemp.pkl_Project_Scale__c == 'Standard Project (500 - 2000 days)') objPWo.mpkl_Project_Classification__c = 'Standard';
                            }else objPWo.mpkl_Project_Classification__c = 'Resource Augmentation';
                        }
                        if(objPWo.mpkl_Unilever_Innovation_Area__c == null && objPWORFTemp.pkl_Business_Area__c !=null)
                            objPWo.mpkl_Unilever_Innovation_Area__c = objPWORFTemp.pkl_Business_Area__c;
                    }
                    if(objPWo.mpkl_Project_Phases__c!=null && !objPWo.mpkl_Project_Phases__c.containsOnly(objPWORFTemp.mpkl_Project_Phases__c)) 
                        objPWo.addError('Only ' + objPWORFTemp.mpkl_Project_Phases__c.replaceAll(';', ', ') + ' Project Phases are allow');
                    if(objPWo.pkl_Region__c!=null && objPWo.pkl_Region__c!=objPWORFTemp.pkl_Region__c) 
                        objPWo.addError('PWO can be created for '+objPWORFTemp.pkl_Region__c+ ' Region');
                }
            }       
        }

}