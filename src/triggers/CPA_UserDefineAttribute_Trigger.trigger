trigger CPA_UserDefineAttribute_Trigger on CPA_User_Defined_Attribute__c (before insert,before update) {
    string CSkey = Trigger.isInsert ?Trigger.new[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger':Trigger.old[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger';
    CPA_Trigger_Pattern__c objAttachmentPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.UDATRIGGER);
    if(objAttachmentPattern != null && objAttachmentPattern.chk_Check_Run__c){
        CPA_TriggerFactory.createHandler(CPA_User_Defined_Attribute__c.sObjectType); 
  }
}