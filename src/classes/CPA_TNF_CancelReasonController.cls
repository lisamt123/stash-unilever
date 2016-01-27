//AC.09.07.01
public Class CPA_TNF_CancelReasonController{
    Public id tnfId;
    Public CPA_TNF__c tnfRec;
    Public string strReason{get;set;}
    Public string profileName;
    Public CPA_PWO__c pwoRec;
    Public List<CPA_CR__c> crRec;
    
    public CPA_TNF_CancelReasonController(ApexPages.StandardController controller) {
        
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
            tnfId= ApexPages.currentPage().getParameters().get('id');
            getRecord(tnfId);
         
        }
      }
      
    public void getRecord(ID pwoId){
        tnfRec = [select id,txta_Reason_for_Cancellation__c,pkl_Status__c,lkp_PWO_ID__c  from CPA_TNF__c where id =:tnfId];
        strReason = tnfRec.txta_Reason_for_Cancellation__c;
        Id profileId=userinfo.getProfileId();
        profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        pwoRec = [select id,txt_Previous_Status_Value__c,pkl_Status__c  from CPA_PWO__c where id =:tnfRec.lkp_PWO_ID__c];
        crRec = [select id,txt_Previous_Status_Value__c,pkl_Status__c,PWO_ID__c  from CPA_CR__c where PWO_ID__c =:pwoRec.id];
    }
      
    public PageReference  SaveCancelReason(){
                tnfRec.txta_Reason_for_Cancellation__c = strReason;
                tnfRec.pkl_Status__c= 'Cancelled';
                update tnfRec;  
                pwoRec.pkl_Status__c=pwoRec.txt_Previous_Status_Value__c;
                update pwoRec;
                crCancel(crRec);
                PageReference ReturnPage = new PageReference('/' + tnfRec.id); 
                ReturnPage.setRedirect(true); 
                return ReturnPage;       
    }
    public PageReference  CancelReason(){
        PageReference ReturnPage = new PageReference('/' + tnfRec.id); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;
    
    }
    void crCancel(List<CPA_CR__c> crRecList){
        if(crRecList.size()>0){
            for(CPA_CR__c cr:crRecList){
                cr.pkl_Status__c=cr.txt_Previous_Status_Value__c;
                update cr;
            }
        }
    }
}