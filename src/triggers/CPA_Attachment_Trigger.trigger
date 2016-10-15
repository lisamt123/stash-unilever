trigger CPA_Attachment_Trigger on Attachment  (before insert,after insert,before update,after update,before delete,after delete) {
    string CSkey = Trigger.isInsert ?Trigger.new[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger':Trigger.old[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger';
      CPA_Trigger_Pattern__c objAttachmentPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.ATTACHMENTTRIGERNAME);

    if(objAttachmentPattern != null && objAttachmentPattern.chk_Check_Run__c){
    /** Checking for the trigger router flag from custom setting   */
    
        CPA_TriggerFactory.createHandler(Attachment.sObjectType); 
  }
}