trigger CPA_HLERequest_trigger on CPA_HLE_Request__c (before insert,after insert,before update,after update,before delete,after delete) {
    string CSkey = Trigger.isInsert ?Trigger.new[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger':Trigger.old[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger';
    CPA_Trigger_Pattern__c objHLEPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.HLEREQUESTTRIGERNAME);
    if(objHLEPattern != null && objHLEPattern.chk_Check_Run__c){
    /** Checking for the trigger router flag from custom setting   */
    
        CPA_TriggerFactory.createHandler(CPA_HLE_Request__c.sObjectType);    
    }
}