public class BFM_UserCreationRequestHandler implements ITrigger{

    
    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore()
    {   
        Map<Id, BFM_UserCreationRequest__c> oldMap = (Map<Id, BFM_UserCreationRequest__c>)trigger.oldMap;
        Map<Id, BFM_UserCreationRequest__c> newMap = (Map<Id, BFM_UserCreationRequest__c>)trigger.newMap;
    	BFM_UserCreationRequestAttachmentCheck.checkAttachments(oldMap, newMap);
    }
    
    public void bulkAfter()
    {
      
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