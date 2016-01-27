trigger HLERequest on CPA_HLE_Request__c (before insert, after insert, before update, after update) {

    if(Trigger.isUpdate && Trigger.isBefore){ //for before update trigger 
        //CPA_PWORF_TriggerUtil.recallApproval(trigger.new);//to perform recall Approval process on PWORF record 
        //CPA_PWORF_TriggerUtil.updateSLAData(trigger.new);
    }
    if(Trigger.isUpdate && Trigger.isAfter){ //for after update trigger
         CPA_HLERequest_TriggerUtil.submitforApproval(trigger.old,trigger.new);
         //CPA_PWORF_TriggerUtil.recallApproval(trigger.new);
         
    }
    if(Trigger.isInsert && Trigger.isBefore){ //for before insert trigger
        CPA_HLERequest_TriggerUtil.vDMNameUpdate(trigger.new);//to update the VDM_Name__c on HLE request record
    }
    if(Trigger.isInsert && Trigger.isAfter){ //for after insert trigger
         
    }
    
}