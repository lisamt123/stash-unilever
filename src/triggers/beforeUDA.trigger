trigger beforeUDA on CAP_User_Defined_Attribute__c (before insert,before update) {
    CPA_UserDefinedAttributeTriggerUtil.findDuplicate(trigger.new);
}