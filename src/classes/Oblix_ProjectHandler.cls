public with sharing class Oblix_ProjectHandler implements ITrigger {
     public Oblix_ProjectHandler() {    
    }
    @testVisible
    boolean triggerShouldExecute = true;
    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore()
    {   
        System.debug('Entering Oblix_ProjectHandler.bulkBefore'); 
        /*
        if(triggerShouldExecute){
            if(Trigger.isUpdate) {
                //lstProjectTrigger =  Oblix_TR04ProjectBusinessDriverScore.retrieveProject(trigger.new);
            }
        }
        */
    }
    
    public void bulkAfter()
    {
        return;
    }
        
    public void beforeInsert(SObject so)
    {
        Oblix_TR04ProjectBusinessDriverScore.updateProjectCalculatorFees((Oblix_SOW_Projects__c) so, Trigger.New);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        Oblix_TR04ProjectBusinessDriverScore.updateProjectCalculatorFees((Oblix_SOW_Projects__c) so, Trigger.New);
    }
     

    public void beforeDelete(SObject so)
    { 
        return;  
    }
    
    public void afterInsert(SObject so) 
    {
        return;
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        return;
    }
    
    public void afterDelete(SObject so)
    {
        return;
    }
    
    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this 
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally()
    {
        System.debug('Entering FAU_ProgramHandler.andFinally');
        /*if(triggerShouldExecute){
            //upsert Trigger.New;
        }
        */
        System.debug('Exiting Oblix_ProjectHandler.andFinally');
    }
}