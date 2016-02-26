trigger PWORFTrigger on CPA_PWORF__c (before insert, after insert, before update, after update, before Delete) {

    if(Trigger.isUpdate && Trigger.isBefore){ //for before update trigger - this is inactive at present
        //CPA_PWORF_TriggerUtil.recallApproval(trigger.new);//to perform recall Approval process on PWORF record 
        CPA_PWORF_TriggerUtil.updateSLAData(trigger.new);
        //CPA_PWORF_TriggerUtil.AssignProject_requestor(trigger.new); // to assign Project_requestor if not selected
        CPA_PWORF_TriggerUtil.requireApprovalComments(trigger.new);
        //CPA_PWORFAgeing.calcualteAgeing(trigger.new); // to set the Ageing Days.
        //Dinesh added below code [17/02] to generate internal PWO ID
        //later on move this method to CPA_PWORF_TriggerUtil class
        calculationOfBusinessDaysForSLADates.generateInternalPWOID(trigger.old,trigger.new);
    }
    if(Trigger.isUpdate && Trigger.isAfter){ //for after update trigger
    if(trigger.new[0].isApprovalProcessStarted__c){
            Approval.unLockResult lrList = Approval.unlock(trigger.new[0].id, false);           
        }
         CPA_PWORF_TriggerUtil.submitforApproval(trigger.old,trigger.new);
         CPA_PWORF_TriggerUtil.recallApproval(trigger.old,trigger.new);
         //CPA_PWORF_TriggerUtil.updateSLAData(trigger.new);
        // CPA_PWORFAgeing.calcualteAgeing(trigger.new); // to set the Ageing Days.
         //Dinesh added below line for search testing, please dont remove this line
         //9/2 - commented because, generating PWO ID either from LIO or PWO
         //calculationOfBusinessDaysForSLADates.forSearch(trigger.old,trigger.new);
    }
   /* if(Trigger.isInsert && Trigger.isBefore){ //for before insert trigger
        //CPA_PWORF_TriggerUtil.vDMNameUpdate(trigger.new);//to update the VDM_Name__c on PWORF record
        //CPA_PWORF_TriggerUtil.AssignProject_requestor(trigger.new); // to assign Project_requestor if not selected
        
    }*/
    if(Trigger.isInsert && Trigger.isAfter){ //for after insert trigger
         //CPA_PWORF_TriggerUtil.updateSLAData(trigger.new);
        // CPA_PWORFAgeing.calcualteAgeing(trigger.new); // to set the Ageing Days.
    }
    if(Trigger.isDelete && Trigger.isBefore){ //for before delete trigger
        CPA_PWORF_TriggerUtil.DontDelete(trigger.old);
    }
}