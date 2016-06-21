public with sharing class Oblix_SplitHandler implements ITrigger {
    
    public Oblix_SplitHandler() {    
    }
    public static boolean b_initiated_from_vf_page = false;
    List<Oblix_SOW_Projects__c> lstProjectSplits = new List<Oblix_SOW_Projects__c>();
    List<Oblix_SOW_Projects__c> lstProjectSplitsOld =  new List<Oblix_SOW_Projects__c>();
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
    }
    
    public void bulkAfter()
    {
        return;
       
    }
        
        
    public void beforeInsert(SObject so)
    {
        Oblix_SplitHandlerLogic.setEnforceTriggerUpdate((Oblix_Marketing_SOW_Project_Splits__c) so);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    { 
        Oblix_SplitHandlerLogic.setEnforceTriggerUpdate((Oblix_Marketing_SOW_Project_Splits__c) so);
    }
     

    public void beforeDelete(SObject so)
    {
        return;
    }
    
    public void afterInsert(SObject so) 
    {
        //if (!b_initiated_from_vf_page)
        //    Oblix_TR05SOWSplitProjectAvoid.SOWSplitProjectAvoid((Oblix_Marketing_SOW_Project_Splits__c) so, Trigger.New, lstProjectSplits);
        ////Oblix_TR05SOWSplitProjectAvoid.UpdateProjectWhenisChanged((Oblix_Marketing_SOW_Project_Splits__c) so, Trigger.New, lstProjectSplits, Trigger.Old, lstProjectSplitsOld);
        return;

    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        //if (!b_initiated_from_vf_page)
        //    Oblix_TR05SOWSplitProjectAvoid.SOWSplitProjectAvoid((Oblix_Marketing_SOW_Project_Splits__c) so, Trigger.New, lstProjectSplits);
        //    //Oblix_TR05SOWSplitProjectAvoid.UpdateProjectWhenisChanged((Oblix_Marketing_SOW_Project_Splits__c) so, Trigger.New, lstProjectSplits, Trigger.Old, lstProjectSplitsOld);
        return;

    }
    
    public void afterDelete(SObject so)
    {
        //if (!b_initiated_from_vf_page)
        //    Oblix_TR05SOWSplitProjectAvoid.SOWSplitProjectAvoid((Oblix_Marketing_SOW_Project_Splits__c) so, Trigger.Old, lstProjectSplits);
        //Oblix_TR05SOWSplitProjectAvoid.UpdateProjectWhenisChanged((Oblix_Marketing_SOW_Project_Splits__c) so, Trigger.New, lstProjectSplits, Trigger.Old, lstProjectSplitsOld);   
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
        //System.debug('Entering FAU_ProgramHandler.andFinally');
        //if(triggerShouldExecute && !b_initiated_from_vf_page){
        //    upsert lstProjectSplits;
        //    if(trigger.isUpdate){
        //        upsert lstProjectSplitsOld;
        //    }
            
        //}
        //System.debug('Exiting Oblix_ProjectHandler.andFinally');
        return;
        
    }
}