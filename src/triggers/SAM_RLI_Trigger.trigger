trigger SAM_RLI_Trigger on SAM_Request_Line_Item__c (before insert,after insert,before update,after update,before delete,after delete) {

    SAM_Trigger_Pattern__c objRLIPattern = SAM_Trigger_Pattern__c.getValues(SAM_Constants.REQUESTLINEITEMTRIGERNAME);

    if(objRLIPattern != null && objRLIPattern.chk_Stop_Trigger_Execution__c){
        SAM_TriggerFactory.createHandler(SAM_Request_Line_Item__c.sObjectType); 
        System.debug('SAM_Request_Line_Item__c.sObjectType - ' + SAM_Request_Line_Item__c.sObjectType);   
    }
}