trigger CPA_Resource_Requirement_Trigger on CPA_Resource_Requirement__c (before insert,after insert,before update,after update,before delete,after delete) {
 CPA_Trigger_Pattern__c objTriggerFlag = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.RESOURCEREQUIREMENTTRIGERNAME);
string CSkey = Trigger.isInsert ?Trigger.new[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger':Trigger.old[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger';
      if(objTriggerFlag != null && objTriggerFlag.chk_Check_Run__c){        
            /** Checking for the trigger router flag from custom setting   */
            CPA_TriggerFactory.createHandler(CPA_Resource_Requirement__c.sObjectType);    
      }
}