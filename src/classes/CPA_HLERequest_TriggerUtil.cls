public class CPA_HLERequest_TriggerUtil{

    public static boolean isSubmitted = false;

    /*
    * Method Name : submitforApproval
    * Parameter   : 
    * Return type : None
    * Description : This method is used to perform submit for  Approval process on PWORF record
    */
    //public static void submitforApproval(List<CPA_HLE_Request__c> oldPWORFList,List<CPA_HLE_Request__c> newPWORFList){
    public static void submitforApproval(List<CPA_HLE_Request__c> oldHLEReqList,List<CPA_HLE_Request__c> newHLEReqList){     
        for (Integer i = 0; i < newHLEReqList.size(); i++) {
            
            if ((oldHLEReqList[i].pkl_Status__c  <> 'Submitted' &&   newHLEReqList[i].pkl_Status__c == 'Submitted')|| (oldHLEReqList[i].pkl_Status__c  <> 'Resubmitted' &&   newHLEReqList[i].pkl_Status__c == 'Resubmitted') &&  !isSubmitted) {
                // create the new approval request to submit
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitted for approval. Please approve.');
                req.setObjectId(newHLEReqList[i].Id);
                // submit the approval request for processing
                Approval.ProcessResult result = Approval.process(req);
                // display if the reqeust was successful
    
                isSubmitted = true;
            }
         }
    }
    
    /*
    * Method Name : vDMNameUpdate
    * Parameter   : 
    * Return type : None
    * Description : This method is to insert the VDM_Name__c on PWORF record
    */
    public static void vDMNameUpdate(List<CPA_HLE_Request__c> newHLEReqList){   
        List<CPA_VDM__c> vdms = [SELECT Id, name FROM CPA_VDM__c];
        //system.debug('pworfs>>>>>>>'+pworfs);
        
        for(CPA_HLE_Request__c hleReq: newHLEReqList){
        
            for(CPA_VDM__c vdm: vdms){
            
                if(hleReq.VDM__c == vdm.id){
                    system.debug('if>>>>' + vdm.name);
                    hleReq.Vendor_Name__c = vdm.name;
                }
            }
        }
    }
}