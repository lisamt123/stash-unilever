trigger SAM_QLI_Trigger on SAM_Quote_Line_Item__c (before insert,after insert,before update,after update,before delete,after delete) {

    SAM_Trigger_Pattern__c objQLIPattern = SAM_Trigger_Pattern__c.getValues(SAM_Constants.QUOTELINEITEMTRIGERNAME);
    System.debug('objQLIPattern.chk_Stop_Trigger_Execution__c - ' + objQLIPattern.chk_Stop_Trigger_Execution__c);
    if(objQLIPattern != null && objQLIPattern.chk_Stop_Trigger_Execution__c){
        SAM_TriggerFactory.createHandler(SAM_Quote_Line_Item__c.sObjectType); 
        System.debug('SAM_Quote_Line_Item__c.sObjectType - ' + SAM_Quote_Line_Item__c.sObjectType);   
    }
}