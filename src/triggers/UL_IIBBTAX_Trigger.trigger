trigger UL_IIBBTAX_Trigger on IIBBTax__c (before insert, before update) {
    if (trigger.isBefore){
        if (trigger.isInsert){
            UL_IIBBTax_TriggerHandler.overlapcheck(trigger.new);
        }
        if (trigger.isUpdate){
            UL_IIBBTax_TriggerHandler.overlapcheck(trigger.new);       
        }
     }
   
}