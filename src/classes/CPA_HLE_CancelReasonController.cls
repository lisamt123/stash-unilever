Public Class CPA_HLE_CancelReasonController{
 Public id hleId;
     Public CPA_HLE_Request__c hleRecord;
     Public string strReason{get;set;}  

    public CPA_HLE_CancelReasonController(ApexPages.StandardController controller) {
        
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
              hleId= ApexPages.currentPage().getParameters().get('id');
            getRecord(hleId);     
        }
      }
      
    public void getRecord(ID hleId){
       hleRecord = [select id,  txta_Reason_for_Cancellation__c,pkl_Status__c  from CPA_HLE_Request__c where id =:hleId];
       strReason = hleRecord.txta_Reason_for_Cancellation__c;
      }
      
    public PageReference  SaveCancelReason(){
        hleRecord.txta_Reason_for_Cancellation__c = strReason;
        hleRecord.pkl_Status__c= 'Cancelled';
        //Approval.unLockResult lrList = Approval.unlock(hleRecord.id, true);           
        update hleRecord;  
        PageReference ReturnPage = new PageReference('/' + hleRecord.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;
    }
    public PageReference  CancelReason(){
        PageReference ReturnPage = new PageReference('/' + hleRecord.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;  
    }
}