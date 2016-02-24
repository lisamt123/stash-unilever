//AC.08.12.01
//AC.10.07.03

public Class CPA_PwoCnfTnf_CancelReasonController{
    Public id pwoId;
    Public CPA_project_work_order__c pwoRec;
    Public string strReason{get;set;}
    Public List<CPA_CR__c> crRec;
    
    public String recordType;
    
     
    public CPA_PwoCnfTnf_CancelReasonController(ApexPages.StandardController controller) {
        system.debug('In constructor()');
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
             pwoId= ApexPages.currentPage().getParameters().get('id');
             recordType = ApexPages.currentPage().getParameters().get('recordType');
            getRecord(pwoId);
         
        }
      }
      
    public void getRecord(ID pwoId){
       pwoRec = [select id,txta_Reason_for_Cancellation__c,ltxta_CNF_Reason_for_Cancellation__c,txta_TNF_Reason_for_Cancellation__c, pkl_Status__c,CNF_Status__c,TNF_Status__c, chk_isCNFcancelled__c,chk_isTNFcancelled__c from CPA_project_work_order__c where id =:pwoId];
       crRec = [select id,ltxta_Reason_for_Cancellation__c,pkl_Status__c,CPA_Project_Work_Order__c  from CPA_CR__c where CPA_Project_Work_Order__c =:pwoId];
       
         if(recordType == 'PWO'){
            strReason = pwoRec.txta_Reason_for_Cancellation__c;
        }else if(recordType == 'CNF'){
           strReason = pwoRec.ltxta_CNF_Reason_for_Cancellation__c;
        }else if(recordType == 'TNF'){
          strReason = pwoRec.txta_TNF_Reason_for_Cancellation__c;
        }
      
      }
      /*
        pkl_Status__c
        txta_Reason_for_Cancellation__c
        
        CNF_Status__c
        ltxta_CNF_Reason_for_Cancellation__c
        
        TNF_Status__c
        txta_TNF_Reason_for_Cancellation__c
      
      */
      
      
    public PageReference  SaveCancelReason(){
        
        if(recordType == 'PWO'){
            pwoRec.txta_Reason_for_Cancellation__c = strReason;
            pwoRec.pkl_Status__c = 'Cancelled';
        }else if(recordType == 'CNF'){
            pwoRec.CNF_Status__c = null;
            pwoRec.chk_isCNFcancelled__c = true;
            pwoRec.ltxta_CNF_Reason_for_Cancellation__c = strReason;
        }else if(recordType == 'TNF'){
            pwoRec.TNF_Status__c = null;
             pwoRec.chk_isTNFcancelled__c = true;
            pwoRec.txta_TNF_Reason_for_Cancellation__c = strReason;
        }
        
        update pwoRec;
        system.debug(' pwoRec.CNF_Status__c>>>>'+  pwoRec.CNF_Status__c + '  pwoRec.chk_isCNFcancelled__c>>> ' + pwoRec.chk_isCNFcancelled__c);
        system.debug('pwoRec.TNF_Status__c>>>>'+ pwoRec.TNF_Status__c + '  pwoRec.chk_isTNFcancelled__c>>> ' + pwoRec.chk_isTNFcancelled__c);
        system.debug('Sattus now ->>'+pwoRec.pkl_Status__c);
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