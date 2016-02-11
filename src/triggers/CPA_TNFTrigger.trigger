trigger CPA_TNFTrigger on CPA_TNF__c (before insert, after insert, before update, after update) {

    /*if(Trigger.isUpdate && Trigger.isBefore){ //for before update trigger
        CPA_TNF_TriggerUtil.checklistValueOfTNF(trigger.new);
    }
    if(Trigger.isUpdate && Trigger.isAfter){ //for after update trigger
        CPA_TNF_TriggerUtil.submitforApproval(trigger.old,trigger.new);
        CPA_TNF_TriggerUtil.recallApproval(trigger.old,trigger.new);
        CPA_TNF_TriggerUtil.UpdatePWOByTNF (trigger.newMap,trigger.oldMap);
    }
    if(Trigger.isInsert && Trigger.isBefore){ //for before insert trigger
    CPA_TNF_TriggerUtil.CreateTNF(trigger.new);
    CPA_TNF_TriggerUtil.checklistValueOfTNF(trigger.new);
    }*/
    
    /*if(Trigger.isInsert && Trigger.isAfter){ //for after insert trigger

    }*/
}