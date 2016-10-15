trigger CPA_CRTrigger on CPA_CR__c (before insert,after insert,before update,after update,before delete,after delete) {
	string CSkey = Trigger.isInsert ?Trigger.new[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger':Trigger.old[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger';
    CPA_Trigger_Pattern__c objCRPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.CRTRIGGERNAME);
    if(objCRPattern != null && objCRPattern.chk_Check_Run__c){
    /** Checking for the trigger router flag from custom setting   */
    
        CPA_TriggerFactory.createHandler(CPA_CR__c.sObjectType); 
	}
}