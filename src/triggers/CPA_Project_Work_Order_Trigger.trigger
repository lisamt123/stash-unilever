trigger CPA_Project_Work_Order_Trigger on CPA_project_work_order__c (before insert, after insert, before update, after update, before Delete) {

    if(Trigger.isUpdate && Trigger.isBefore){ //for before update trigger
        CPA_Project_Work_Order_TriggerUtil.checklistValueOfcontract(trigger.new);
        CPA_Project_Work_Order_TriggerUtil.requireApprovalComments(trigger.new);
        //CPA_Project_Work_Order_TriggerUtil.latestPWOStatus(trigger.new); // commented by Pooja bcoz of exception
    }
    if(Trigger.isUpdate && Trigger.isAfter){ //for after update trigger
        CPA_Project_Work_Order_TriggerUtil.submitforApproval(trigger.old,trigger.new);
        CPA_Project_Work_Order_TriggerUtil.recallApproval(trigger.old,trigger.new);
    }
    if(Trigger.isInsert && Trigger.isBefore){ //for before insert trigger
       CPA_Project_Work_Order_TriggerUtil.checklistValueOfcontract(trigger.new);
       //Below call added by Dinesh on 9/2 to generate internal POW ID
       //CPA_Project_Work_Order_TriggerUtil.internalPWOID(trigger.new);
       //Dinesh added this line [16/02] to get internal PWO ID from PWORF
       CPA_Project_Work_Order_TriggerUtil.getInternalPWOIDFromPWORF(trigger.new);
       //Below line added by Dinesh for Standalone PWO, later on move this method to trigger util class
       //CPA_StandalonePWOAndCR.createPWORF(trigger.new);
       CPA_Project_Work_Order_TriggerUtil.setFirstPWO(trigger.new);
    }
    
    if(Trigger.isInsert && Trigger.isAfter){ //for after insert trigger
       //CPA_StandalonePWOAndCR.updatePWORFName(trigger.new);
        CPA_Project_Work_Order_TriggerUtil.UpdateTATObj(trigger.new);
        //CPA_Project_Work_Order_TriggerUtil.newPWO(trigger.new);// commented by Pooja bcoz of exception
    }
    
    if(Trigger.isDelete && Trigger.isBefore){ //for before delete trigger
        CPA_Project_Work_Order_TriggerUtil.DOntDelete(trigger.old);
     }
}