public with sharing class CPA_LOI_CancelReasonController {

    Public Id loiId;
    Public CPA_LOI__c loiRec{set;get;}
    Public String strReason{set;get;}
    
    Public CPA_LOI_CancelReasonController(ApexPages.StandardController controller){
    if(ApexPages.currentPage().getParameters().get('Id')!=null){
    loiId=ApexPages.currentPage().getParameters().get('Id');
    getRecord(loiId);
    }
  }  
    Public void getRecord(Id loiId){
    loiRec=[select id,txta_Reason_for_Cancellation__c,pkl_Status__c from CPA_LOI__c where id=:loiId];
    system.debug('loiRec 1>>>>>>>'+loiRec);
    strReason=loiRec.txta_Reason_for_Cancellation__c;
    system.debug('loiRec 2>>>>>>>'+strReason);
   } 
    Public PageReference SaveCancelReason(){
    loiRec.txta_Reason_for_Cancellation__c = strReason;
    system.debug('loiRec 3>>>>>>>'+loiRec.txta_Reason_for_Cancellation__c);
    loiRec.pkl_Status__c= 'Cancelled';
    system.debug('loiRec 4>>>>>>>'+loiRec.pkl_Status__c);
    update loiRec;
    system.debug('loiRec 5>>>>>>>'+loiRec);   
    PageReference ReturnPage = new PageReference('/' + loiRec.id); 
    ReturnPage.setRedirect(true);
    return ReturnPage;
    }
    Public PageReference CancelReason(){
    PageReference ReturnPage = new PageReference ('/'+loiRec.Id);
    return ReturnPage ;
    }
}