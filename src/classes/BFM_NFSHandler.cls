public with sharing class BFM_NFSHandler implements ITrigger{   
    
    private Map<Id,BFM_NFS__C> oldMap;
    private Map<Id, BFM_NFS__C> newMap;
    
    public BFM_NFSHandler() {}
    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore() { 
        oldMap = (Map<Id, BFM_NFS__C>)trigger.oldMap;
        newMap = (Map<Id, BFM_NFS__C>)trigger.newMap;
        
        set<id> setlinknfs = new set<id>();
        set<id> setcodevalnfs = new set<id>();
        for(BFM_NFS__C nfs: (List<BFM_NFS__C>) trigger.new){
            if(nfs.NFS_Link_Check_Status__c!=null || nfs.NFS_Status__c=='Invoice Posted' || nfs.NFS_Definitive__c == true || nfs.Request_Cancellation__c == true){
                setlinknfs.add(nfs.id);    
            }
            if(nfs.NFS_Vendor_Check_Status__c=='Vendor Ok' || nfs.NFS_Status__c=='Invoice Posted' || nfs.NFS_Definitive__c == true || nfs.Request_Cancellation__c == true){
                setcodevalnfs.add(nfs.id);    
            }
        }
        
        BFM_ValidationController.nfsDuplicateRecordCheck(Trigger.New,setlinknfs,trigger.isInsert);  
        
        if(trigger.isupdate){  
            BFM_NFS_CodeValidations.nfsCheck(Trigger.New,setcodevalnfs);  
        }
    }
    
    public void bulkAfter() {
        if(Trigger.isupdate){
            //BFM_LinkSES.NFSSESLink(Trigger.New);
            //BFM_NFSValueValidation.NFSTotalValueValidation(Trigger.New);
        }
    }
    
    public void beforeInsert(SObject so) {
        
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){
        
    }
     

    public void beforeDelete(SObject so){   
    }
    
    public void afterInsert(SObject so) { 
        
        //BFM_SefazCheck_Utility_CC.sefazcheck(so.id,'ddsfas','CCE',userInfo.getSessionId());
    }
    
    public void afterUpdate(SObject oldSo, SObject so) {
    }
    
    public void afterDelete(SObject so) {
    }
    
    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally(){
        
    }
}