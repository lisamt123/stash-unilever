trigger CPA_Project_Work_Order_Triggers on CPA_project_work_order__c (before insert,after insert,before update,after update,before delete,after delete) {
	string CSkey = Trigger.isInsert ?Trigger.new[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger':Trigger.old[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger';
    CPA_Trigger_Pattern__c objPWOPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.PWOTRIGGERNAME);
    if(objPWOPattern != null && objPWOPattern.chk_Check_Run__c){
    /** Checking for the trigger router flag from custom setting   */
    
        CPA_TriggerFactory.createHandler(CPA_project_work_order__c.sObjectType);    
    }
}