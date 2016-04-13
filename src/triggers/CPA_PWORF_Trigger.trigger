trigger CPA_PWORF_Trigger on CPA_PWORF__c (before insert,after insert,before update,after update,before delete,after delete) {
    CPA_Trigger_Pattern__c objAttachmentPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.PWORFTRIGERNAME);
    system.debug('objAttachmentPattern -->'+objAttachmentPattern );
    if(objAttachmentPattern != null && objAttachmentPattern.chk_Check_Run__c){
        string CSkey = Trigger.isInsert ?Trigger.new[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger':Trigger.old[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger';
        
            /** Checking for the trigger router flag from custom setting   */
            system.debug('CSkey--->'+CSkey  );
            CPA_TriggerFactory.createHandler(CPA_PWORF__c.sObjectType);    
        
    }
}