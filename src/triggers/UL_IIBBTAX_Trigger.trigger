/***************************************************************
    Name: UL_IIBBTAX_Trigger
    Copyright: Accenture
    ======================================================
    Purpose:
    Trigger on IIBBTax__c Object
    ======================================================
    History
    -------
    VERSION     AUTHOR         DATE             DETAIL                 Description
    1.0         Dotz Eleonora  30/01/2017       Initial Development     Handles IIBBTAX before insert/update events
    ***************************************************************/
    trigger UL_IIBBTAX_Trigger on IIBBTax__c (before insert, before update) {
        if(UL_Utility.IS_IIBBTAX_TRIGGER_ENABLED){
            if (trigger.isBefore){
                if (trigger.isInsert){
                    UL_IIBBTax_TriggerHandler.overlapcheck(trigger.new);
                }
                if (trigger.isUpdate){
                    UL_IIBBTax_TriggerHandler.overlapcheck(trigger.new);       
                }
             }
         }
    }