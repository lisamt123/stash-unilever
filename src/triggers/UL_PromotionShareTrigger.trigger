/***************************************************************
    Name: UL_PromotionShareTrigger
    Copyright: Accenture
    ======================================================
    Purpose:
    Trigger PromotionCategory Object
    ======================================================
    History
    -------
    VERSION     AUTHOR             DATE             DETAIL                 Description
    1.0         Devesh Murdiya    06/12/2016        Initial Development    Handles PromotionCategory after insert event
    ***************************************************************/ 
    trigger UL_PromotionShareTrigger on UL_PromotionCategory__c (after insert) {
        if(UL_Utility.IS_PROMOTION_CATEGORY_TRIGGER_ENABLED){
            List<Id> promCatId = new List<Id>();
            for(UL_PromotionCategory__c promCatObj : trigger.new){
                promCatId.add(promCatObj.id);
            }
            /*Future Class callout*/
            UL_PromotionShareTriggerHandler.enableApexSharing(promCatId);
        }
    }