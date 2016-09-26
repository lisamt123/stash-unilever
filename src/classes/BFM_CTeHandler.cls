public with sharing class BFM_CTeHandler implements ITrigger
{   
    public BFM_CTeHandler() {    
    }


    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore()
    {   
    BFM_ValidationController.cteDuplicateRecordCheck(Trigger.New);
      if(trigger.isupdate){
        BFM_companyvendorcheck.companycodeandvendorcheck(Trigger.New);
        }  
    }
    
    public void bulkAfter()
    {
       if(Trigger.isupdate){
      BFM_LinkSES.cteSESLink(Trigger.New);
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
    BFM_SefazCheck_Utility_CC.sefazcheck(so.id,'ddsfas','CTE',userInfo.getSessionId());
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