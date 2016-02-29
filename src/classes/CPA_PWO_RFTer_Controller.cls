public with sharing class CPA_PWO_RFTer_Controller{
 
    public ID CPA_PWOID;
     Public CPA_project_work_order__c CPAPwoObject;
     Public string strReason{get;set;}  

    public CPA_PWO_RFTer_Controller(ApexPages.StandardController controller) {
        
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
              CPA_PWOID= ApexPages.currentPage().getParameters().get('id');
            getRecord(CPA_PWOID);     
        }
      }
      
    public void getRecord(ID CPA_PWOID){
       CPAPwoObject = [select id,txta_Request_for_Termination__c,pkl_Status__c  from CPA_project_work_order__c where id =:CPA_PWOID];
       strReason = CPAPwoObject.txta_Request_for_Termination__c;
      }
      
    public PageReference  SaveCancelReason(){
        
      
    
        CPAPwoObject.txta_Request_for_Termination__c = strReason;
        CPAPwoObject.pkl_Status__c= 'Request For Termination';
        update CPAPwoObject;  
        PageReference ReturnPage = new PageReference('/' + CPAPwoObject.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;
    }
    public PageReference  CancelReason(){
        PageReference ReturnPage = new PageReference('/' + CPAPwoObject.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;  
    }
}