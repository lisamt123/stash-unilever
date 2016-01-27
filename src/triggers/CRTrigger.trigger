trigger CRTrigger on CPA_CR__c (before insert, after insert, before update, after update) {

    if(Trigger.isUpdate && Trigger.isBefore){ //for before update trigger
        CPA_CR_TriggerUtil.previouStatusValue(trigger.old,trigger.new);
        CPA_CR_TriggerUtil.checklistValueOfCR(trigger.new);
    }
    if(Trigger.isUpdate && Trigger.isAfter){ //for after update trigger
        CPA_CR_TriggerUtil.submitforApproval(trigger.old,trigger.new);
        CPA_CR_TriggerUtil.recallApproval(trigger.old,trigger.new);
    }
    if(Trigger.isInsert && Trigger.isBefore){ //for before insert trigger
       CPA_CR_TriggerUtil.CreateCR(trigger.new);
       CPA_CR_TriggerUtil.checklistValueOfCR(trigger.new);
    }
    /*if(Trigger.isInsert && Trigger.isAfter){ //for after insert trigger

    }*/
    
}