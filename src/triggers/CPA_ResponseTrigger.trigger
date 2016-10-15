trigger CPA_ResponseTrigger on CPA_Query_comment__c (before insert,after insert,before update,after update,before delete,after delete) {
  string CSkey = Trigger.isInsert ?Trigger.new[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger':Trigger.old[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger';
    CPA_Trigger_Pattern__c objCRPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.QUERYCOMMENTTRIGERNAME);
   //CPA_Trigger_Pattern__c objCRPattern = CPA_Trigger_Pattern__c.getValues('CPA_Query_comment');
    if(objCRPattern != null && objCRPattern.chk_Check_Run__c){
    /** Checking for the trigger router flag from custom setting */ 
    
        CPA_TriggerFactory.createHandler(CPA_Query_comment__c.sObjectType); 
  }
   /* if(Trigger.isInsert && Trigger.isBefore){ //for before insert trigger
        CPA_Queries_TriggerUtil.assigneduser(trigger.new);
    }*/
}