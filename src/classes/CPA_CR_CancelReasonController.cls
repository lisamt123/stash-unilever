Public Class CPA_CR_CancelReasonController{
    Public Id crId;
    Public CPA_CR__c crRec{set;get;}
    Public String strReason{set;get;}
    
    Public CPA_CR_CancelReasonController(ApexPages.StandardController controller){
    if(ApexPages.currentPage().getParameters().get('Id')!=null){
    crId=ApexPages.currentPage().getParameters().get('Id');
    getRecord(crId);
    }
  }  
    Public void getRecord(Id crId){
    crRec=[select id,ltxta_Reason_for_Cancellation__c,pkl_Status__c from CPA_CR__c where id=:crId];
   // system.debug('crRec >>>>>>>'+crRec);
    strReason=crRec.ltxta_Reason_for_Cancellation__c;
    //    system.debug('crRec >>>>>>>'+crRec);
   } 
    Public PageReference SaveCancelReason(){
    crRec.ltxta_Reason_for_Cancellation__c = strReason;
    crRec.pkl_Status__c= 'Cancelled';
    update crRec;  
    PageReference ReturnPage = new PageReference('/' + crRec.id); 
    ReturnPage.setRedirect(true);
    return ReturnPage;
    }
    Public PageReference CancelReason(){
    PageReference ReturnPage = new PageReference ('/'+crRec.Id);
    return ReturnPage ;
    }   
}