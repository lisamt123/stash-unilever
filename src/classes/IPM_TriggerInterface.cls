public Interface IPM_TriggerInterface extends ITrigger
{     
    
    // Use these methods for bulk invocations which are context aware.     
    void bulkBeforeInsert(List<sObject> newTriggerList);     
    void bulkBeforeUpdate(List<sObject> oldTriggerList,List<sObject> newTriggerList);      
    void bulkBeforeDelete(List<sObject> oldTriggerList);      
    
    // Use these methods for bulk invocations for after which are context aware.     
    void bulkAfterInsert(List<sObject> newTriggerList);     
    void bulkAfterUpdate(List<sObject> oldTriggerList,List<sObject> newTriggerList);     
    void bulkAfterDelete(List<sObject> oldTriggerList);               
    
    // This is where existing Logic which involves complicated code which is not 'context - aware' can be incorporated.     
    void executeLegacyImplementation();          
    
    // Perform any post operations after the trigger logic has been implemented.     
    void postProcessing(); 
    
    // Skip Handler Execution Method
    void skipHandlerExecution(Boolean flag);
    
    boolean validateHandlerExecution();
    
}