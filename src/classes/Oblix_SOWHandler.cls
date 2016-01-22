public with sharing class Oblix_SOWHandler implements ITrigger {
 
    public static boolean b_initiated_from_vf_page = false;
    boolean triggerShouldExecute = true;
    List<Marketing_SOW__c> lstMarkBrandCateg = new List<Marketing_SOW__c>();
    //lstOf Marketing Share : to share records with members.
    List<Marketing_SOW__Share> lstMarketingShare = new List<Marketing_SOW__Share>();
    List<Marketing_SOW__Share> lstMarketingShareToDelete = new List<Marketing_SOW__Share>();
    List<Approval.ProcessSubmitRequest> lstApprovalReq = new List<Approval.ProcessSubmitRequest>();
    List<Marketing_SOW__c> lstSowRecordsApproval = new List<Marketing_SOW__c>();    

    Map<Id, MDO_CategoryBrands__c> mids_campaign_id_category_brand = new Map<Id, MDO_CategoryBrands__c>();

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2015-12-25
    * @description  This method is called prior to execution of a BEFORE trigger. 
                    Use this to cache any data required into maps 
                    prior execution of the trigger.
    ********************************************************************************/
    public void bulkBefore()
    {   

        if (Trigger.isInsert){
            // because the VF page already has a logic to handle big and small category - no need to set it via trigger
            if (!b_initiated_from_vf_page)
                mids_campaign_id_category_brand = Oblix_SOWHandlerLogic.retrieveBrandCategoriesForSOW(Trigger.New, NULL);            
        }

        if (Trigger.isUpdate){
            // because the VF page already has a logic to handle big and small category - no need to set it via trigger
            if (!b_initiated_from_vf_page)
                // the list contains the new Marketing_SOW__c which require big & small categories to be adjusted
                mids_campaign_id_category_brand = Oblix_SOWHandlerLogic.retrieveBrandCategoriesForSOW(Trigger.New, (Map<Id,Marketing_SOW__c>) Trigger.oldMap);
        }
    }
    
    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2015-12-25
    * @description  This method is called prior to execution of a AFTER trigger. 
                    Use this to cache any data required into maps 
                    prior execution of the trigger.
    ********************************************************************************/
    public void bulkAfter(){
        set<Id> setOWnerdsIds = new set<Id>();
        List<Marketing_SOW__c> lstSOW = Trigger.New;
        if(Trigger.isInsert || Trigger.isUpdate){
            for(Marketing_SOW__c markSow : lstSOW){
                setOWnerdsIds.add(markSow.OwnerId);
            }
            lstMarketingShareToDelete = Oblix_TR01SOWMarkingSharing.retrieveMarketingShare(Trigger.New, setOWnerdsIds);
        }
        if(Trigger.isUpdate){
            //Start Approval Process Part
             for (Integer i = 0; i < Trigger.new.size(); i++) {
                if (((Marketing_SOW__c)Trigger.old[i]).SOW_Status__c != Oblix_Constants.Lbl_SOWSTATUS_AWAITINGAPPROVAL && ((Marketing_SOW__c)Trigger.new[i]).SOW_Status__c == Oblix_Constants.Lbl_SOWSTATUS_AWAITINGAPPROVAL) {
                    lstSowRecordsApproval.add((Marketing_SOW__c)Trigger.new[i]);
                }
             }
        }    
            
    }
    
        
    public void beforeInsert(SObject so){
        // because the VF page already has a logic to handle big and small category - no need to set it via trigger
        if (!b_initiated_from_vf_page)
            Oblix_SOWHandlerLogic.adjustBrandCategoriesForSOW((Marketing_SOW__c) so, mids_campaign_id_category_brand);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        // because the VF page already has a logic to handle big and small category - no need to set it via trigger
        if (!b_initiated_from_vf_page)
            Oblix_SOWHandlerLogic.adjustBrandCategoriesForSOW((Marketing_SOW__c) so, mids_campaign_id_category_brand);
            //Oblix_TR06SowMarketBrandPopulate.PopulateBrandCategoriesforSOWHandler((Marketing_SOW__c)so, lstMarkBrandCateg);
    }
     

    public void beforeDelete(SObject so)
    {
        return;
    }
    
    public void afterInsert(SObject so) 
    {
        lstMarketingShare = Oblix_TR01SOWMarkingSharing.sowMarketingSharing((Marketing_SOW__c)so, Trigger.New);
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        lstMarketingShare = Oblix_TR01SOWMarkingSharing.sowMarketingSharing((Marketing_SOW__c)so, Trigger.New);
        lstApprovalReq = Oblix_TR02SubmitSOWForApproval.SubmitSowForApproval((Marketing_SOW__c)so, lstSowRecordsApproval);
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
        if(triggerShouldExecute && Trigger.isAfter){
                delete lstMarketingShareToDelete;
                insert lstMarketingShare;
                //for(Approval.ProcessSubmitRequest req : lstApprovalReq){
                //    Approval.ProcessResult result = Approval.process(req);
                //    // display if the reqeust was successful
                    //System.debug('Submitted for approval successfully: '+result.isSuccess());
                //}
        }
        System.debug('Exiting Oblix_ProjectHandler.andFinally');
    }
}