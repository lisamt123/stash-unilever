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
   system.debug('crRec 1>>>>>>>'+crRec);
    strReason=crRec.ltxta_Reason_for_Cancellation__c;
    system.debug('crRec 2>>>>>>>'+strReason);
   } 
    Public PageReference SaveCancelReason(){
    crRec.ltxta_Reason_for_Cancellation__c = strReason;
    system.debug('crRec 3>>>>>>>'+crRec.ltxta_Reason_for_Cancellation__c);
    crRec.pkl_Status__c= 'Cancelled';
    system.debug('crRec 4>>>>>>>'+crRec.pkl_Status__c);
    update crRec;
system.debug('crRec 5>>>>>>>'+crRec);   
    PageReference ReturnPage = new PageReference('/' + crRec.id); 
    ReturnPage.setRedirect(true);
    return ReturnPage;
    }
    Public PageReference CancelReason(){
    PageReference ReturnPage = new PageReference ('/'+crRec.Id);
    return ReturnPage ;
    }   
}