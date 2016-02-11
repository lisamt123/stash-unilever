trigger PWOTrigger on CPA_PWO__c (before insert, after insert, before update, after update) {

   /*if(Trigger.isUpdate && Trigger.isBefore){ //for before update trigger
        CPA_PWO_TriggerUtil.previouStatusValue(trigger.old,trigger.new);
        //CPA_PWO_TriggerUtil.checklistValueOfPWO(trigger.new,Trigger.isInsert,Trigger.isBefore);
    }
    if(Trigger.isUpdate && Trigger.isAfter){ //for after update trigger
        CPA_PWO_TriggerUtil.submitforApproval(trigger.old,trigger.new);
        CPA_PWO_TriggerUtil.recallApproval(trigger.old,trigger.new);
        //CPA_PWO_TriggerUtil.UpdatePworf(trigger.newMap);
    }
    if(Trigger.isInsert && Trigger.isBefore){ //for before insert trigger
    system.debug('trigger.newMap-->'+trigger.new);
       CPA_PWO_TriggerUtil.checklistValueOfPWO(trigger.new,Trigger.isInsert,Trigger.isBefore);
    }*/
    
    /*if(Trigger.isInsert && Trigger.isAfter){ //for after insert trigger

    }*/
    
}