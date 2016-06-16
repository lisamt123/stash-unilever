public with sharing class Oblix_AssetHandler implements ITrigger {
 
   public Oblix_AssetHandler() {}
   
   @testVisible
   boolean triggerShouldExecute = true;
   List<Oblix_SOW_Projects__c> lstProjectAgencies = new List<Oblix_SOW_Projects__c>();
   List<Oblix_SOW_Projects__c> lstProjectAgenciesToUpdate = new List<Oblix_SOW_Projects__c>();
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
        if(Trigger.isInsert || Trigger.isUpdate ){
            lstProjectAgencies = Oblix_TR03AssetProjectScoreCalculator.retrieveProjectAgency(Trigger.New);
        }
        if(Trigger.isDelete){
            lstProjectAgencies = Oblix_TR03AssetProjectScoreCalculator.retrieveProjectAgency(Trigger.Old);
        }
    }
        
    public void beforeInsert(SObject so)
    {
        Oblix_AssetHandlerLogic.setEnforceTriggerUpdate((Oblix_Project_Assets__c) so);
        Oblix_AssetHandlerLogic.adjustAssetFields((Oblix_Project_Assets__c) so);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        Oblix_AssetHandlerLogic.setEnforceTriggerUpdate((Oblix_Project_Assets__c) so);
        Oblix_AssetHandlerLogic.adjustAssetFields((Oblix_Project_Assets__c) so);
    }
     

    public void beforeDelete(SObject so)
    {
        return;
    }
    
    public void afterInsert(SObject so) 
    {
        //Fire the trigger on After insert to calculate Project Score Asset
        lstProjectAgenciesToUpdate= Oblix_TR03AssetProjectScoreCalculator.CalculateProjectScore((Oblix_Project_Assets__c)so, Trigger.New, lstProjectAgencies);
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        //Fire the trigger on After Update to calculate Project Score Asset
        lstProjectAgenciesToUpdate = Oblix_TR03AssetProjectScoreCalculator.CalculateProjectScore((Oblix_Project_Assets__c)so, Trigger.New, lstProjectAgencies);
    }
    
    public void afterDelete(SObject so)
    {
        //Fire the trigger on After Delete to re-calculate Project Score Asset
        lstProjectAgenciesToUpdate = Oblix_TR03AssetProjectScoreCalculator.CalculateProjectScore((Oblix_Project_Assets__c)so, Trigger.Old, lstProjectAgencies);
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
        if(triggerShouldExecute && Trigger.isAfter){
                update lstProjectAgenciesToUpdate;
        }
        System.debug('Exiting Oblix_ProjectHandler.andFinally');
    }
}