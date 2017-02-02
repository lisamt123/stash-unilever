/**************************************************************************************************************
* @Trigger          : UL_IIBBTAX_Trigger on IIBBTax__c 
* @Description      : Trigger on IIBB_Tax__c
* @CreatedBy/Date   : Accenture , 30/01/2017
* @Updates By/Date  : 
**************************************************************************************************************/ 
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