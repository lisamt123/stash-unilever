/**
 * Unilever (Phase 1 - Sprint 4)
 * @author          Devesh Murdiya
 * @version         1.0
 * @date            06/12/2016
 * @description     trigger to share Fund record with User.
 */
trigger UL_FundShareTrigger on ACCL__Fund__c (after insert, Before Update) {
    if(trigger.isafter && trigger.isInsert){
        List<Id> fundId = new List<Id>();
        for(ACCL__Fund__c fundObj : trigger.new){
            fundId.add(fundObj.id);
        }
        /*Future Class callout*/
        UL_FundShareTriggerHandler.enableApexSharing(fundId);
    }
    else if(trigger.isbefore && trigger.isupdate){
    
        UL_fundCloseStatusHandler.openTransactionCheck(trigger.new);
        UL_fundCloseStatusHandler.openPromotionCheck(trigger.new);
    }
}