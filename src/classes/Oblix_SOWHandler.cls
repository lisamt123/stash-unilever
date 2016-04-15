public with sharing class Oblix_SOWHandler implements ITrigger {
 
    //public static boolean b_initiated_from_vf_page = false;

    boolean triggerShouldExecute = true;
    List<Marketing_SOW__c> lstMarkBrandCateg = new List<Marketing_SOW__c>();
    //lstOf Marketing Share : to share records with members.
    //List<Marketing_SOW__Share> lstMarketingShare = new List<Marketing_SOW__Share>();
    //List<Marketing_SOW__Share> lstMarketingShareToDelete = new List<Marketing_SOW__Share>();

    //Map<Id, MDO_CategoryBrands__c> mids_campaign_id_category_brand = new Map<Id, MDO_CategoryBrands__c>();
    Map<String, Set<Id>> brandCatKey_unileverApproverIds_map = new Map<String, Set<Id>>();
    Map<String, Set<Id>> brandCatAGKey_agencyApproverIds_map = new Map<String, Set<Id>>();
    Map<String, List<Oblix_User_Permission__c>> brandCatKey_UserPermissions_map = new Map<String, List<Oblix_User_Permission__c>>();
    List<Marketing_SOW__Share> li_sharesToInsert = new List<Marketing_SOW__Share>();

    /*******************************************************************************
    * @date         2015-12-25
    * @description  This method is called prior to execution of a BEFORE trigger. 
                    Use this to cache any data required into maps 
                    prior execution of the trigger.
    ********************************************************************************/
    public void bulkBefore()
    {   

        if (Trigger.isInsert){
            // because the VF page already has a logic to handle big and small category - no need to set it via trigger
            //if (!b_initiated_from_vf_page)
                //mids_campaign_id_category_brand = Oblix_SOWHandlerLogic.retrieveBrandCategoriesForSOW(Trigger.New, NULL);

            // get all user permissions that define approvers for each brand-category combination of SOWs in this scope
            Oblix_SOWHandlerLogic.retrieveBrandCategoryApprovers(Trigger.New, brandCatKey_unileverApproverIds_map, brandCatAGKey_agencyApproverIds_map);
        }

        if (Trigger.isUpdate){
            // because the VF page already has a logic to handle big and small category - no need to set it via trigger
            //if (!b_initiated_from_vf_page)
            //    // the list contains the new Marketing_SOW__c which require big & small categories to be adjusted
            //    mids_campaign_id_category_brand = Oblix_SOWHandlerLogic.retrieveBrandCategoriesForSOW(Trigger.New, (Map<Id,Marketing_SOW__c>) Trigger.oldMap);

            // if there is a change in brand or small category, need to re-set approvers
            List<Marketing_SOW__c> liso_changed_brand_smallc = new List<Marketing_SOW__c>();
            List<Marketing_SOW__c> newList = (List<Marketing_SOW__c>) Trigger.new;
            for(Marketing_SOW__c sow : newList){
                Marketing_SOW__c oldSow = (Marketing_SOW__c) Trigger.oldMap.get(sow.Id);
                if(sow.OblixBrand__c != oldSow.OblixBrand__c || sow.SmallProductCategory__c != oldSow.SmallProductCategory__c || sow.Oblix_AgencyEstimate__c != oldSow.Oblix_AgencyEstimate__c){
                    liso_changed_brand_smallc.add(sow);
                }
            }
            if(!liso_changed_brand_smallc.isEmpty()){
                Oblix_SOWHandlerLogic.retrieveBrandCategoryApprovers(liso_changed_brand_smallc, brandCatKey_unileverApproverIds_map, brandCatAGKey_agencyApproverIds_map);
            }
        }
    }
    
    /*******************************************************************************
    * @date         2015-12-25
    * @description  This method is called prior to execution of a AFTER trigger. 
                    Use this to cache any data required into maps 
                    prior execution of the trigger.
    ********************************************************************************/
    public void bulkAfter(){
        //set<Id> setOWnerdsIds = new set<Id>();
        //List<Marketing_SOW__c> lstSOW = Trigger.New;
        //if(Trigger.isInsert || Trigger.isUpdate){
        //    for(Marketing_SOW__c markSow : lstSOW){
        //        setOWnerdsIds.add(markSow.OwnerId);
        //    }
        //    //lstMarketingShareToDelete = Oblix_TR01SOWMarkingSharing.retrieveMarketingShare(Trigger.New, setOWnerdsIds);
        //}

        if(Trigger.isInsert){
            //get all user permissions
            brandCatKey_UserPermissions_map = Oblix_SOWHandlerLogic.retrieveUserPermissions(Trigger.new);
        }
        

        if(Trigger.isUpdate || Trigger.isDelete){
            // if there is a change in brand or small category, need to re-calculate sharing
            List<Marketing_SOW__c> liso_changed_brand_smallc = new List<Marketing_SOW__c>();
            List<Marketing_SOW__c> newList = (List<Marketing_SOW__c>) Trigger.new;
            for(Marketing_SOW__c sow : newList){
                Marketing_SOW__c oldSow = (Marketing_SOW__c) Trigger.oldMap.get(sow.Id);
                if(sow.OblixBrand__c != oldSow.OblixBrand__c || sow.SmallProductCategory__c != oldSow.SmallProductCategory__c || sow.OwnerId != oldSow.OwnerId || sow.Oblix_AgencyEstimate__c != oldSow.Oblix_AgencyEstimate__c){
                    liso_changed_brand_smallc.add(sow);
                }
            }
            if(!liso_changed_brand_smallc.isEmpty()){
                brandCatKey_UserPermissions_map = Oblix_SOWHandlerLogic.retrieveUserPermissions(Trigger.new);
                Oblix_SOWHandlerLogic.deleteAllManualSharing(liso_changed_brand_smallc);
            }
        }
            
    }
    
        
    public void beforeInsert(SObject so){
        // because the VF page already has a logic to handle big and small category - no need to set it via trigger
        //if (!b_initiated_from_vf_page)
        //    Oblix_SOWHandlerLogic.adjustBrandCategoriesForSOW((Marketing_SOW__c) so, mids_campaign_id_category_brand);
        // set approvers to SOWs in this scope
        Oblix_SOWHandlerLogic.setSOWApprovers((Marketing_SOW__c) so, brandCatKey_unileverApproverIds_map, brandCatAGKey_agencyApproverIds_map);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        // because the VF page already has a logic to handle big and small category - no need to set it via trigger
        //if (!b_initiated_from_vf_page)
        //    Oblix_SOWHandlerLogic.adjustBrandCategoriesForSOW((Marketing_SOW__c) so, mids_campaign_id_category_brand);
            //Oblix_TR06SowMarketBrandPopulate.PopulateBrandCategoriesforSOWHandler((Marketing_SOW__c)so, lstMarkBrandCateg);

        Marketing_SOW__c sow = (Marketing_SOW__c) so;
        Marketing_SOW__c oldSow = (Marketing_SOW__c) oldSo;
        // set approvers to SOWs in this scope
        if((sow.OblixBrand__c != oldSow.OblixBrand__c) || (sow.SmallProductCategory__c != oldSow.SmallProductCategory__c) || (sow.Oblix_AgencyEstimate__c != oldSow.Oblix_AgencyEstimate__c)){
            Oblix_SOWHandlerLogic.setSOWApprovers(sow, brandCatKey_unileverApproverIds_map, brandCatAGKey_agencyApproverIds_map);
        }
        ////if sow has just been approved,  initiate versioniong process
        //if(sow.SOW_Status__c == Oblix_Utils.SOW_STATUS_APPROVED_BY_AGENCY && oldSow.SOW_Status__c != Oblix_Utils.SOW_STATUS_APPROVED_BY_AGENCY){
        //    Id sowCloneId = Oblix_SOWHandlerLogic.copySOW(sow.Id);
        //    sow.Name += Oblix_SOWHandlerLogic.ORIGINAL_SUFFIX;
        //}
    }
     

    public void beforeDelete(SObject so)
    {
        return;
    }
    
    public void afterInsert(SObject so)
    {
        //lstMarketingShare = Oblix_TR01SOWMarkingSharing.sowMarketingSharing((Marketing_SOW__c)so, Trigger.New);
        List<Marketing_SOW__Share> li_sowShare = Oblix_SOWHandlerLogic.adjustSharing((Marketing_SOW__c) so, brandCatKey_UserPermissions_map);
        li_sharesToInsert.addAll(li_sowShare);
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
        //re-calculate sharing
        Marketing_SOW__c sow = (Marketing_SOW__c) so;
        Marketing_SOW__c oldSow = (Marketing_SOW__c) oldSo;
        if((sow.OblixBrand__c != oldSow.OblixBrand__c) || (sow.SmallProductCategory__c != oldSow.SmallProductCategory__c) || (sow.OwnerId != oldSow.OwnerId) || (sow.Oblix_AgencyEstimate__c != oldSow.Oblix_AgencyEstimate__c)){
            List<Marketing_SOW__Share> li_sowShare = Oblix_SOWHandlerLogic.adjustSharing((Marketing_SOW__c) so, brandCatKey_UserPermissions_map);
            li_sharesToInsert.addAll(li_sowShare);
        }
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
        System.debug('Entering Oblix_SOWHandler.andFinally');
        Set<Id> parentIds = new Set<Id>();
        for(Marketing_SOW__Share newShare : li_sharesToInsert){
            parentIds.add(newShare.ParentId);
        }
        System.debug('li_sharesExisting: ' + JSON.serialize([SELECT Id, ParentId, UserOrGroupId, RowCause, AccessLevel FROM Marketing_SOW__Share WHERE ParentId IN :parentIds]));
        System.debug('li_sharesToInsert: ' + JSON.serialize(li_sharesToInsert));
        System.debug('sows: ' + JSON.serialize(Trigger.new));
        if(!li_sharesToInsert.isEmpty()){
            insert li_sharesToInsert;
        }

        System.debug('Exiting Oblix_SOWHandler.andFinally');
    }
}