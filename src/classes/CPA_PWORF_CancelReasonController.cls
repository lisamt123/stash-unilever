public with sharing Class CPA_PWORF_CancelReasonController{
     Public id pworfId;
     Public CPA_PWORF__c pworfRec;
     Public List<CPA_project_work_order__c> pwoRec;
     Public List<CPA_LOI__c> loiRec;
     Public List<CPA_CR__c> crRec;
     Public List<Id> pwoIdList;
     Public string strReason{get;set;}
    
    public CPA_PWORF_CancelReasonController(ApexPages.StandardController controller) {
        
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
              pworfId= ApexPages.currentPage().getParameters().get('id');
            getRecord(pworfId);
         
        }
      }
      
    public void getRecord(ID pworfId){
        pworfRec = [select id,ltxt_Reason_for_Cancellation__c,pkl_Status__c,isCancelled__c  from CPA_PWORF__c where id =:pworfId];
        pwoRec = [select id,txta_Reason_for_Cancellation__c,pkl_Status__c,PWORF_ID__c  from CPA_project_work_order__c  where PWORF_ID__c =:pworfId];      
        loiRec =[select id,txta_Reason_for_Cancellation__c,pkl_Status__c,lkp_PWORF__c  from CPA_LOI__c where lkp_PWORF__c =:pworfId];
        Id profileId=userinfo.getProfileId();
      
        strReason = pworfRec.ltxt_Reason_for_Cancellation__c;
      }
      
    public PageReference  SaveCancelReason(){
        List<id> pwoIdList = new List<id>();
        if(pwoRec.size()>0){
            for(CPA_project_work_order__c pwo:pwoRec){
                pwoIdList.add(pwo.id);
            }
        }
        if(pwoIdList.size() > 0){
            crRec = [select id,ltxta_Reason_for_Cancellation__c,pkl_Status__c,PWO_ID__c  from CPA_CR__c where PWO_ID__c =:pwoIdList];
        }
        
        if(pwoRec!=null && pwoRec.size() > 0)
            pwoCancel(pwoRec);
        if(loiRec != null && loiRec.size() > 0)
            loiCancel(loiRec);  
        if(crRec != null && crRec.size() > 0)
            crCancel(crRec);
        if(pworfRec != null)
            pworfCancel(pworfRec);
        PageReference ReturnPage = new PageReference('/' + pworfRec.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;          
    }
        
        
        
    
    public PageReference  CancelReason(){
        PageReference ReturnPage = new PageReference('/' + pworfRec.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;
    
    }
    void pworfCancel(CPA_PWORF__c pworfRecord){
        pworfRecord.ltxt_Reason_for_Cancellation__c = strReason;
        pworfRecord.pkl_Status__c= 'Cancelled';
        pworfRecord.isCancelled__c= true;
        update pworfRecord;
    }
    void pwoCancel(List<CPA_project_work_order__c> pwoRecList){
        List<CPA_project_work_order__c> pwoList = new List<CPA_project_work_order__c>();
        if(pwoRecList.size()>0){
            for(CPA_project_work_order__c pwo:pwoRecList){
                pwo.txta_Reason_for_Cancellation__c = strReason;
                pwo.pkl_Status__c= 'Cancelled';
                pwoList.add(pwo);
            }
            update pwoList;
        }
    }
    void loiCancel(List<CPA_LOI__c> loiRecList){
        List<CPA_LOI__c> loiList = new List<CPA_LOI__c>();
        if(loiRecList.size()>0){
            for(CPA_LOI__c loi:loiRecList){
                loi.txta_Reason_for_Cancellation__c = strReason;
                loi.pkl_Status__c= 'Cancelled';
                loiList.add(loi);
            }
            update loiList;
        }
    }
    void crCancel(List<CPA_CR__c> crRecList){
        List<CPA_CR__c> crList = new List<CPA_CR__c>();
        if(crRecList.size()>0){
            for(CPA_CR__c cr:crRecList){
                cr.ltxta_Reason_for_Cancellation__c = strReason;
                cr.pkl_Status__c= 'Cancelled';
                crList.add(cr);
            }
            update crList;
        }
    }
}