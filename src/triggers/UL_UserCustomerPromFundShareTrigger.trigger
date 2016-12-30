/**
 * Unilever (Phase 1 - Sprint 4)
 * @author          Devesh Murdiya
 * @version         1.0
 * @date            06/12/2016
 * @description     trigger to share promotion record with User.
 */
trigger UL_UserCustomerPromFundShareTrigger on UL_UserCustomerProduct__c (after insert,after delete) {
    if(trigger.isinsert){
        List<Id> lstUserCusId = new List<Id>();
        for(UL_UserCustomerProduct__c userCusObj : trigger.new){
            lstUserCusId.add(userCusObj.id);
        }
        /*Future Class callout*/
        UL_UserCustomerPromShareTriggerHandler.userCusenableApexSharing(lstUserCusId);
        /*Future Class callout*/
        UL_UserCustomerFundShareTriggerHandler.userCusenableApexSharing(lstUserCusId);
    }
    else{        
        UL_UserCustomerPromShareTriggerHandler.userCusDisableApexSharing(trigger.old);
        UL_UserCustomerFundShareTriggerHandler.userCusDisableApexSharing(trigger.old);
    }
}