/**
 * @author Shreyas Mangalvedhekar
 * @date 11/01/2016
 * @description - This Class is used to perform operation on before update event of LOI Trigger
 */
public class CPA_LOI_TriggerUtil{
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
            if((LOIOldList[i].pkl_Status__c  == 'Submitted' || LOIOldList[i].pkl_Status__c  == 'Resubmitted') && (newLOIList[i].pkl_Status__c == 'Cancelled')){
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
            
        if ((oldLOIList[i].pkl_Status__c  <> 'Submitted' &&   newLOIList[i].pkl_Status__c == 'Submitted')|| (oldLOIList[i].pkl_Status__c  <> 'Resubmitted' &&   newLOIList[i].pkl_Status__c == 'Resubmitted') &&  !isSubmitted) {
             
            // create the new approval request to submit
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitted for approval. Please approve.');
            req.setObjectId(newLOIList[i].Id);
            // submit the approval request for processing
            Approval.ProcessResult result = Approval.process(req);
            // display if the reqeust was successful

            isSubmitted = true;
        }else if(oldLOIList[i].pkl_Status__c  <> 'Cancelled' &&   newLOIList[i].pkl_Status__c == 'Cancelled'){
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
        for(CPA_PWORF__c objPworf : [select id,mpkl_Project_Phases__c,lkp_Unilever_budget_approver__c,lkp_Unilever_content_approver__c,txt_Clarity_ID__c from CPA_PWORF__c where ID  IN: setPWORF]){
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
                if(objNewLOI.mpkl_Phases_covered_by_WAR__c!=null && !objNewLOI.mpkl_Phases_covered_by_WAR__c.containsOnly(objPWORFTemp.mpkl_Project_Phases__c)) 
                        objNewLOI.addError('Only ' + objPWORFTemp.mpkl_Project_Phases__c.replaceAll(';', ', ') + ' Project Phases are allow');
            }
        }
    }

}