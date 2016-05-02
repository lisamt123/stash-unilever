public with sharing class Oblix_ProjectHandler implements ITrigger {
    
    public Oblix_ProjectHandler() {  
    }
    @testVisible
    public static boolean triggerShouldExecute = true;

    //private Map<Id, String> mids_campaign_id_hub_summary_text = new Map<Id, String>();
    //private Map<Id, String> mids_campaign_id_asset_deliverables_text = new Map<Id, String>();
    //private List<Oblix_SOW_Projects__c> lstCampaignsWithQueryField = new List<Oblix_SOW_Projects__c>();
    //private List<Oblix_Calculator__c> lstCountryBoxNumberCalculator = new List<Oblix_Calculator__c>();
    //private List<Oblix_Marketing_SOW_Project_Splits__c> lstSplitProject = new List<Oblix_Marketing_SOW_Project_Splits__c>();
    //private List<Oblix_Calculator__c> lstCalculatorBoxRange = new List<Oblix_Calculator__c>();
    //private Map<Id,List<Oblix_Marketing_SOW_Project_Splits__c>> mid_liso_projects_ids_with_related_project_splits ;

    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore()
    {   
        System.debug('Entering Oblix_ProjectHandler.bulkBefore execution'); 
        if(Oblix_ProjectHandler.triggerShouldExecute){
            if(Trigger.isInsert) {

                Oblix_ProjectHandlerLogic.retrieveCampaignForAdjustment(Trigger.New);

                //System.debug('Entering Trigger beforeInsert'); 
                //mids_campaign_id_hub_summary_text = Oblix_ProjectHandlerLogic.retrieveCampaignHubSummary(Trigger.New);
                //mids_campaign_id_asset_deliverables_text = Oblix_ProjectHandlerLogic.retrieveAssetDeliverables(Trigger.New);

                //Oblix_ProjectHandlerLogic.populateCampaignsWithRelatedSplits(Trigger.New);                
                //lstCampaignsWithQueryField = Oblix_TR04ProjectBusinessDriverScore.getCampaignsByIds(Trigger.New);
                //lstSplitProject = Oblix_TR04ProjectBusinessDriverScore.getSplitsByProjects(Trigger.New);
                //lstCountryBoxNumberCalculator  = Oblix_TR04ProjectBusinessDriverScore.getOblixCalculators(Trigger.New, lstSplitProject);
                //lstCalculatorBoxRange = Oblix_TR04ProjectBusinessDriverScore.getCalculatorBoxRange();

                //// get a map of project parent and the related project splits in scope
                //mid_liso_projects_ids_with_related_project_splits = Oblix_TR04ProjectBusinessDriverScore.getProjectAndTheRelatedProjectSplits(Trigger.New);

            }
        }
        
        if(Oblix_ProjectHandler.triggerShouldExecute){
            if(Trigger.isUpdate) {
                System.debug('Entering Trigger beforeUpdate'); 

                Oblix_ProjectHandlerLogic.retrieveCampaignForAdjustment(Trigger.New);

                //mids_campaign_id_hub_summary_text = Oblix_ProjectHandlerLogic.retrieveCampaignHubSummary(Trigger.New);
                //mids_campaign_id_asset_deliverables_text = Oblix_ProjectHandlerLogic.retrieveAssetDeliverables(Trigger.New);
                //Oblix_ProjectHandlerLogic.populateCampaignsWithRelatedSplits(Trigger.New);                


                //lstCampaignsWithQueryField = Oblix_TR04ProjectBusinessDriverScore.getCampaignsByIds(Trigger.New);
                //lstSplitProject = Oblix_TR04ProjectBusinessDriverScore.getSplitsByProjects(Trigger.New);
                //lstCountryBoxNumberCalculator  = Oblix_TR04ProjectBusinessDriverScore.getOblixCalculators(Trigger.New, lstSplitProject);
                //lstCalculatorBoxRange = Oblix_TR04ProjectBusinessDriverScore.getCalculatorBoxRange();

                //// get a map of project parent and the related project splits in scope
                //mid_liso_projects_ids_with_related_project_splits = Oblix_TR04ProjectBusinessDriverScore.getProjectAndTheRelatedProjectSplits(Trigger.New);
            }
        }
    }
    
    public void bulkAfter()
    {
        return;
    }
        
    public void beforeInsert(SObject so)
    {
        if (Oblix_ProjectHandler.triggerShouldExecute){

            //Oblix_ProjectHandlerLogic.adjustCampaignHubSummary((Oblix_SOW_Projects__c) so , mids_campaign_id_hub_summary_text);
            //Oblix_ProjectHandlerLogic.adjustAssetDeliverables((Oblix_SOW_Projects__c) so , mids_campaign_id_asset_deliverables_text);

            Oblix_ProjectHandlerLogic.adjustCampaignFields((Oblix_SOW_Projects__c) so);

            //Oblix_TR04ProjectBusinessDriverScore.updateProjectCalculatorFees((Oblix_SOW_Projects__c) so, Trigger.New
            //    , lstCampaignsWithQueryField, lstCountryBoxNumberCalculator,lstCalculatorBoxRange,mid_liso_projects_ids_with_related_project_splits);
        }
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        if (Oblix_ProjectHandler.triggerShouldExecute){
            //Oblix_ProjectHandlerLogic.adjustCampaignHubSummary((Oblix_SOW_Projects__c) so , mids_campaign_id_hub_summary_text);
            //Oblix_ProjectHandlerLogic.adjustAssetDeliverables((Oblix_SOW_Projects__c) so , mids_campaign_id_asset_deliverables_text);
            
            Oblix_ProjectHandlerLogic.adjustCampaignFields((Oblix_SOW_Projects__c) so);

            //Oblix_TR04ProjectBusinessDriverScore.updateProjectCalculatorFees((Oblix_SOW_Projects__c) so, Trigger.New
            //    , lstCampaignsWithQueryField, lstCountryBoxNumberCalculator,lstCalculatorBoxRange,mid_liso_projects_ids_with_related_project_splits);
        }
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

        System.debug('Exiting Oblix_ProjectHandler.andFinally');
    }
}