trigger CPA_RequirementsDeliverables_Trigger on CPA_Requirements_and_Deliverables__c (before insert,after insert,before update,after update,before delete,after delete) {
 CPA_Trigger_Pattern__c objTriggerFlag = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.REQUIRMENTANDDELIVERABLETRIGERNAME);
    system.debug('objTriggerFlag -->'+objTriggerFlag );
      if(objTriggerFlag != null && objTriggerFlag.chk_Check_Run__c){
            string CSkey = Trigger.isInsert ?Trigger.new[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger':Trigger.old[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger';
        
            /** Checking for the trigger router flag from custom setting   */
            system.debug('CSkey--->'+CSkey  );
            CPA_TriggerFactory.createHandler(CPA_Requirements_and_Deliverables__c.sObjectType);    
      }
}