trigger HLERequest on CPA_HLE_Request__c (before insert, after insert, before update, after update) {

    if(Trigger.isUpdate && Trigger.isBefore){ //for before update trigger 
        CPA_HLERequest_TriggerUtil.unlockrecord(trigger.old,trigger.new);//to perform recall Approval process
         CPA_HLERequest_TriggerUtil.sLAValues(trigger.old,trigger.new);
         CPA_HLERequest_TriggerUtil.requireApprovalComments(trigger.new);
    }
    if(Trigger.isUpdate && Trigger.isAfter){ //for after update trigger
         CPA_HLERequest_TriggerUtil.submitforApproval(trigger.old,trigger.new);
         CPA_HLERequest_TriggerUtil.recallApproval(trigger.old,trigger.new);
         
    }
    //if(Trigger.isInsert && Trigger.isBefore){ //for before insert trigger
        
    //}
   //if(Trigger.isInsert && Trigger.isAfter){ //for after insert trigger
         
   // }
    
}