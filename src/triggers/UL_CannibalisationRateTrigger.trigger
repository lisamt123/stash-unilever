/***************************************************************
    Name: UL_CannibalisationRateTrigger
    Copyright: Accenture
    ======================================================
    Purpose:
    Trigger on Cannibalisation Rate Object
    ======================================================
    History
    -------
    VERSION     AUTHOR         DATE             DETAIL                 Description
    1.0         Omkar Narkar    29/11/2016       Initial Development    Handles Cabbibalisation Rate before insert event
    ***************************************************************/
    trigger UL_CannibalisationRateTrigger on UL_Cannibalisation_Rate__c (before insert, before update) {
        if(UL_Utility.IS_CANNIBALISATION_RATE_TRIGGER_ENABLED){
            if(trigger.isBefore){
                if(trigger.isInsert || Trigger.isUpdate){
                    UL_CannibalisationRateTriggerHandler.beforeInsert(trigger.new);
                }
            }
        }
    }