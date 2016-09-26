public with sharing class BFM_NFSHandler
    implements ITrigger
{   
    public BFM_NFSHandler() {    
    }

    

  
    
    


    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore()
    { 
        set<id> setlinknfs = new set<id>();
        for(BFM_NFS__C nfs: (List<BFM_NFS__C>) trigger.new){
            if(nfs.NFS_Link_Check_Status__c!=null){
                setlinknfs.add(nfs.id);    
            }
        }
        if(setlinknfs.isEmpty()){
            BFM_ValidationController.nfsDuplicateRecordCheck(Trigger.New);  
        }
        if(trigger.isupdate){  
            BFM_NFS_CodeValidations.nfsCheck(Trigger.New);  
        }
    }
    
    public void bulkAfter()
    {
      if(Trigger.isupdate){
      BFM_LinkSES.NFSSESLink(Trigger.New);
        }   
    }
        
    public void beforeInsert(SObject so)
    {
        
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        
    }
     

    public void beforeDelete(SObject so)
    {   
    }
    
    public void afterInsert(SObject so) 
    { 
        
        //BFM_SefazCheck_Utility_CC.sefazcheck(so.id,'ddsfas','CCE',userInfo.getSessionId());
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
    }
    
    public void afterDelete(SObject so)
    {
    }
    
    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally()
    {
        
    }

}