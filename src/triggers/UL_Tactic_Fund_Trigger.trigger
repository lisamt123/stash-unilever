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
    1.0         Somyodeep    29/11/2016       Initial Development     Handles Tactic Fund before insert and before update events
    ***************************************************************/
    trigger UL_Tactic_Fund_Trigger on ACCL__Tactic_Fund__c (Before Insert, Before Update) {
        if(UL_Utility.IS_TACTIC_FUND_TRIGGER_ENABLED){
             if(trigger.isbefore){
                if(trigger.isinsert){
                system.debug('$$before insert trigger entry check');
                   UL_fundOverspentHandler.overspentCheck(trigger.new);
                } 
                if(trigger.isupdate){
                //system.debug('$$before update trigger entry check');
                //UL_fundOverspentHandler.overspentCheck(trigger.new);
                }
             }
        }
    }