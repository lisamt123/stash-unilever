//AC.08.05.03
//AC.09.05.03
//AC.11.05.03


public with sharing Class CPA_PwoCnfTnf_ReturnReasonController{
    Public id pwoId;
    Public CPA_project_work_order__c pwoRec;
    Public string strReason{get;set;}
    Public List<CPA_CR__c> crRec;
    
    public String recordType;
    
     
    public CPA_PwoCnfTnf_ReturnReasonController(ApexPages.StandardController controller) {
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
             pwoId= ApexPages.currentPage().getParameters().get('id');
             recordType = ApexPages.currentPage().getParameters().get('recordType');
            getRecord(pwoId);
         
        }
      }
      
    public void getRecord(ID pwoId){
       pwoRec = [select id,txta_Reason_for_Return__c,txta_TNF_Reason_for_Return__c,txta_CNF_Reason_for_Return__c, pkl_Status__c,CNF_Status__c,TNF_Status__c from CPA_project_work_order__c where id =:pwoId];
      // crRec = [select id,ltxta_Reason_for_Cancellation__c,pkl_Status__c,PWO_ID__c  from CPA_CR__c where PWO_ID__c =:pwoId];
       
         if(recordType == 'PWO'){
            strReason = pwoRec.txta_Reason_for_Return__c;
        }else if(recordType == 'CNF'){
           strReason = pwoRec.txta_CNF_Reason_for_Return__c;
        }else if(recordType == 'TNF'){
          strReason = pwoRec.txta_TNF_Reason_for_Return__c;
        }
      
      }
      
    public PageReference  SaveCancelReason(){
        
        if(recordType == 'PWO'){
            pwoRec.txta_Reason_for_Return__c = strReason;
            pwoRec.pkl_Status__c = 'Returned';
        }else if(recordType == 'CNF'){
            pwoRec.CNF_Status__c = 'Returned';
            pwoRec.txta_CNF_Reason_for_Return__c = strReason;
        }else if(recordType == 'TNF'){
            pwoRec.TNF_Status__c = 'Returned';
            pwoRec.txta_TNF_Reason_for_Return__c = strReason;
        }        
        update pwoRec;
                       
        PageReference ReturnPage = new PageReference('/' + pwoRec.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;  
    }
    public PageReference  CancelReason(){
        PageReference ReturnPage = new PageReference('/' + pwoRec.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;
    
    }
   
}