/***************************************************************
    Name: UL_ProductTrigger
    Copyright: Accenture
    ======================================================
    Purpose:
    Trigger on Product object 
    ======================================================
    History
    -------
    VERSION     AUTHOR         DATE             DETAIL                 Description
    1.0         Ketan Mehta    24/11/2016       Initial Development    Handles product before insert event
    ***************************************************************/
    trigger UL_ProductTrigger on ACSFUL001__Product__c (before insert) {
        if(trigger.isBefore){
            if(trigger.isInsert){
                UL_ProductTriggerHandler.beforeInsert(trigger.new);
            }
        }
    }