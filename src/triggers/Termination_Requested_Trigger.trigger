trigger Termination_Requested_Trigger on CPA_Termination_Requested__c (before insert) {
    /*if(Trigger.isUpdate && Trigger.isBefore){ //for before update trigger
       
    }*/
    /*if(trigger.isUpdate && trigger.isAfter){
        
     }*/
     If (trigger.isbefore && trigger.isInsert){
           CPA_Termination_Requested_TriggerUtil.updatePwoOnTR(trigger.new);
     }
}