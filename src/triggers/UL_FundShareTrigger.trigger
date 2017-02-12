/***************************************************************
    Name: UL_FundShareTrigger
    Copyright: Accenture
    ======================================================
    Purpose:
    Trigger on Fund Object
    ======================================================
    History
    -------
    VERSION     AUTHOR            DATE             DETAIL                 Description
    1.0         Devesh Murdiya    06/12/2016       Initial Development    Handles Fund after insert event
    ***************************************************************/
    trigger UL_FundShareTrigger on ACCL__Fund__c (after insert) {
        if(UL_Utility.IS_FUND_TRIGGER_ENABLED){
            if(Trigger.isBefore){
                if(Trigger.isInsert){
                    List<Id> fundId = new List<Id>();
                    for(ACCL__Fund__c fundObj : trigger.new){
                        fundId.add(fundObj.id);
                    }
                    /*Future Class callout*/
                    UL_FundShareTriggerHandler.enableApexSharing(fundId);
                }
            }
        }
    }