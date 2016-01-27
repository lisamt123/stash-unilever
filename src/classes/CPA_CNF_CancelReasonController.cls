public class CPA_CNF_CancelReasonController {
 Public id cnfId{get;set;}
     Public CPA_CNF__c cnfRec;
     Public string strReason{get;set;}
    Public CPA_PWO__c pwoRec;

    public CPA_CNF_CancelReasonController(ApexPages.StandardController controller) {
        
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
              cnfId= ApexPages.currentPage().getParameters().get('id');
            getRecord(cnfId);
         
        }
      }
      
    public void getRecord(ID pwoId){
       cnfRec = [select id,ltxta_Reason_for_Cancellation__c,pkl_Status__c,PWO_ID__c  from CPA_CNF__c where id =:cnfId];
       strReason = cnfRec.ltxta_Reason_for_Cancellation__c;
       pwoRec = [select id,txt_Previous_Status_Value__c,pkl_Status__c  from CPA_PWO__c where id =:cnfRec.PWO_ID__c];
      }
      
    public PageReference  SaveCancelReason(){
       
                cnfRec.ltxta_Reason_for_Cancellation__c = strReason;
                cnfRec.pkl_Status__c= 'Cancelled';
                update cnfRec;
                pwoRec.pkl_Status__c=pwoRec.txt_Previous_Status_Value__c;
                update pwoRec;              
                PageReference ReturnPage = new PageReference('/' + cnfRec.id); 
                ReturnPage.setRedirect(true); 
                return ReturnPage;  
            
    }
    public PageReference  CancelReason(){
        PageReference ReturnPage = new PageReference('/' + cnfRec.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;
    
    }
    
}