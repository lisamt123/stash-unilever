public with sharing class CPA_PWORF_WithholdReasonController{
 Public id loiId;
     Public CPA_PWORF__c loiRec;
     Public string strReason{get;set;}  

    public CPA_PWORF_WithholdReasonController(ApexPages.StandardController controller) {
        
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
              loiId= ApexPages.currentPage().getParameters().get('id');
            getRecord(loiId);     
        }
      }
      
    public void getRecord(ID loiId){
       loiRec = [select id,txta_Reason_for_Return__c,pkl_Status__c  from CPA_PWORF__c where id =:loiId];
       strReason = loiRec.txta_Reason_for_Return__c;
      }
      
    public PageReference  SaveCancelReason(){
        loiRec.txta_Reason_for_Return__c = strReason;
        loiRec.pkl_Status__c= 'Withhold';
        update loiRec;  
        PageReference ReturnPage = new PageReference('/' + loiRec.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;
    }
    public PageReference  CancelReason(){
        PageReference ReturnPage = new PageReference('/' + loiRec.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;  
    }
}