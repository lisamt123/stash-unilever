/***************************************************************
    Name: UL_UserCustomerPromFundShareTrigger
    Copyright: Accenture
    ======================================================
    Purpose:
    Trigger on UserCustomerProduct Object
    ======================================================
    History
    -------
    VERSION     AUTHOR            DATE             DETAIL                 Description
    1.0         Devesh Murdiya    06/12/2016       Initial Development    Handles UserCustomerProduct after insert/delete events
    ***************************************************************/ 
    trigger UL_UserCustomerPromFundShareTrigger on UL_UserCustomerProduct__c (after insert,after delete) {
        if(UL_Utility.IS_USER_CUSTOMER_PROMOTION_SHARE_TRIGGER_ENABLED){
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
    }