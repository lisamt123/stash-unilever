/**
 * Unilever (Phase 1 - Sprint 4)
 * @author          Devesh Murdiya
 * @version         1.0
 * @date            06/12/2016
 * @description     trigger to share promotion record with User.
 */
trigger UL_PromotionShareTrigger on UL_PromotionCategory__c (after insert) {
    List<Id> promCatId = new List<Id>();
    for(UL_PromotionCategory__c promCatObj : trigger.new){
        promCatId.add(promCatObj.id);
    }
    /*Future Class callout*/
    UL_PromotionShareTriggerHandler.enableApexSharing(promCatId);
}