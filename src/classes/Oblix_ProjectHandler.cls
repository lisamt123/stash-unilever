public with sharing class Oblix_ProjectHandler implements ITrigger {
     public Oblix_ProjectHandler() {    
    }
    @testVisible
    boolean triggerShouldExecute = true;
    private Map<Id, String> mids_campaign_id_hub_summary_text = new Map<Id, String>();
    private Map<Id, String> mids_campaign_id_asset_deliverables_text = new Map<Id, String>();

    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore()
    {   
        System.debug('Entering Oblix_ProjectHandler.bulkBefore execution'); 
        
        if(triggerShouldExecute){
            if(Trigger.isInsert) {
                System.debug('Entering Trigger beforeInsert'); 
                mids_campaign_id_hub_summary_text = Oblix_ProjectHandlerLogic.retrieveCampaignHubSummary(Trigger.New);
                mids_campaign_id_asset_deliverables_text = Oblix_ProjectHandlerLogic.retrieveAssetDeliverables(Trigger.New);
            }
        }
        
        if(triggerShouldExecute){
            if(Trigger.isUpdate) {
                System.debug('Entering Trigger beforeUpdate'); 
                mids_campaign_id_hub_summary_text = Oblix_ProjectHandlerLogic.retrieveCampaignHubSummary(Trigger.New);
                mids_campaign_id_asset_deliverables_text = Oblix_ProjectHandlerLogic.retrieveAssetDeliverables(Trigger.New);
            }
        }
    }
    
    public void bulkAfter()
    {
        return;
    }
        
    public void beforeInsert(SObject so)
    {
        Oblix_ProjectHandlerLogic.adjustCampaignHubSummary((Oblix_SOW_Projects__c) so , mids_campaign_id_hub_summary_text);
        Oblix_ProjectHandlerLogic.adjustAssetDeliverables((Oblix_SOW_Projects__c) so , mids_campaign_id_asset_deliverables_text);

        // temp shahin deactivating this
        Oblix_TR04ProjectBusinessDriverScore.updateProjectCalculatorFees((Oblix_SOW_Projects__c) so, Trigger.New);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        Oblix_ProjectHandlerLogic.adjustCampaignHubSummary((Oblix_SOW_Projects__c) so , mids_campaign_id_hub_summary_text);
        Oblix_ProjectHandlerLogic.adjustAssetDeliverables((Oblix_SOW_Projects__c) so , mids_campaign_id_asset_deliverables_text);
        
        // temp shahin deactivating this
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