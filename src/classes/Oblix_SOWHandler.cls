public with sharing class Oblix_SOWHandler implements ITrigger {
 public Oblix_SOWHandler() {     
    }
    boolean triggerShouldExecute = true;
    List<Marketing_SOW__c> lstMarkBrandCateg = new List<Marketing_SOW__c>();
    //lstOf Marketing Share : to share records with members.
    List<Marketing_SOW__Share> lstMarketingShare = new List<Marketing_SOW__Share>();
    List<Marketing_SOW__Share> lstMarketingShareToDelete = new List<Marketing_SOW__Share>();
    List<Approval.ProcessSubmitRequest> lstApprovalReq = new List<Approval.ProcessSubmitRequest>();
    List<Marketing_SOW__c> lstSowRecordsApproval = new List<Marketing_SOW__c>();
    
    /**
     * bulkBefore
     *
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     */
    public void bulkBefore()
    {   
        System.debug('Entering Oblix_ProjectHandler.bulkBefore'); 
        List<Marketing_SOW__c> lstMarkBrandCateg1 = Trigger.New;
        if(Trigger.isInsert){
            for(Marketing_SOW__c markSow : lstMarkBrandCateg1){
                if(markSow.OblixBrand__c != null){
                    lstMarkBrandCateg.add(markSow);
                }
            }
        }
        if(Trigger.isUpdate){
            for(Marketing_SOW__c markSow : lstMarkBrandCateg1){
                Marketing_SOW__c markSow_tmp = (Marketing_SOW__c)Trigger.oldMap.get(markSow.Id);
                if(markSow.OblixBrand__c != markSow_tmp.OblixBrand__c){
                    lstMarkBrandCateg.add(markSow);
                }
            }
        }
    }
    
    public void bulkAfter()
    {
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
    
        
    public void beforeInsert(SObject so)
    {
        Oblix_TR06SowMarketBrandPopulate.PopulateBrandCategoriesforSOWHandler((Marketing_SOW__c)so, lstMarkBrandCateg);
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        Oblix_TR06SowMarketBrandPopulate.PopulateBrandCategoriesforSOWHandler((Marketing_SOW__c)so, lstMarkBrandCateg);
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
                for(Approval.ProcessSubmitRequest req : lstApprovalReq){
                    Approval.ProcessResult result = Approval.process(req);
                    // display if the reqeust was successful
                    System.debug('Submitted for approval successfully: '+result.isSuccess());
                }
        }
        System.debug('Exiting Oblix_ProjectHandler.andFinally');
    }
}