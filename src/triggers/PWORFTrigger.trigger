trigger PWORFTrigger on CPA_PWORF__c (before insert, after insert, before update, after update) {

    if(Trigger.isUpdate && Trigger.isBefore){ //for before update trigger - this is inactive at present
        //CPA_PWORF_TriggerUtil.recallApproval(trigger.new);//to perform recall Approval process on PWORF record 
        CPA_PWORF_TriggerUtil.updateSLAData(trigger.new);
        CPA_PWORF_TriggerUtil.AssignProject_requestor(trigger.new); // to assign Project_requestor if not selected
        CPA_PWORF_TriggerUtil.requireApprovalComments(trigger.new);
        //CPA_PWORFAgeing.calcualteAgeing(trigger.new); // to set the Ageing Days.

    }
    if(Trigger.isUpdate && Trigger.isAfter){ //for after update trigger
         CPA_PWORF_TriggerUtil.submitforApproval(trigger.old,trigger.new);
         CPA_PWORF_TriggerUtil.recallApproval(trigger.old,trigger.new);
         //CPA_PWORF_TriggerUtil.updateSLAData(trigger.new);
         CPA_PWORFAgeing.calcualteAgeing(trigger.new); // to set the Ageing Days.
         //Dinesh added below line for search testing, please dont remove this line
         calculationOfBusinessDaysForSLADates.forSearch(trigger.old,trigger.new);
    }
    if(Trigger.isInsert && Trigger.isBefore){ //for before insert trigger
        //CPA_PWORF_TriggerUtil.vDMNameUpdate(trigger.new);//to update the VDM_Name__c on PWORF record
        CPA_PWORF_TriggerUtil.AssignProject_requestor(trigger.new); // to assign Project_requestor if not selected
        
    }
    if(Trigger.isInsert && Trigger.isAfter){ //for after insert trigger
         //CPA_PWORF_TriggerUtil.updateSLAData(trigger.new);
         CPA_PWORFAgeing.calcualteAgeing(trigger.new); // to set the Ageing Days.
    }
    
}