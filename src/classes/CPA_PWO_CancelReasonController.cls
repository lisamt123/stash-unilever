//AC.08.12.01
//AC.10.07.03

public with sharing class CPA_PWO_CancelReasonController{
    Public id pwoId;
    Public CPA_PWO__c pwoRec;
    Public string strReason{get;set;}
    Public List<CPA_CR__c> crRec;
     
    public CPA_PWO_CancelReasonController(ApexPages.StandardController controller) {
        
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
             pwoId= ApexPages.currentPage().getParameters().get('id');
            getRecord(pwoId);
         
        }
      }
      
    public void getRecord(ID pwoId){
       pwoRec = [select id,txta_Reason_for_Cancellation__c,pkl_Status__c  from CPA_PWO__c where id =:pwoId];
       crRec = [select id,ltxta_Reason_for_Cancellation__c,pkl_Status__c,PWO_ID__c  from CPA_CR__c where PWO_ID__c =:pwoId];
       strReason = pwoRec.txta_Reason_for_Cancellation__c;
       
      
      }
      
    public PageReference  SaveCancelReason(){
        pwoRec.txta_Reason_for_Cancellation__c = strReason;
        pwoRec.pkl_Status__c= 'Cancelled';
        update pwoRec;
        if(crRec != null && crRec.size() > 0)
            crCancel(crRec);                
        PageReference ReturnPage = new PageReference('/' + pwoRec.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;  
    }
    public PageReference  CancelReason(){
        PageReference ReturnPage = new PageReference('/' + pwoRec.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;
    
    }
    void crCancel(List<CPA_CR__c> crRecList){
        if(crRecList.size()>0){
            for(CPA_CR__c cr:crRecList){
                cr.ltxta_Reason_for_Cancellation__c = strReason;
                cr.pkl_Status__c= 'Cancelled';
                update cr;
            }
        }
    }
}