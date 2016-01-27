trigger CPA_CNF_Trigger on CPA_CNf__c (after update ,  before Insert) {
    if(Trigger.isUpdate && Trigger.isBefore){ //for before update trigger
        CPA_CNF_TriggerUtil.checklistValueOfCNF(trigger.new);
    }
    if(trigger.isUpdate && trigger.isAfter){
         CPA_CNF_TriggerUtil.submitforApproval(trigger.old,trigger.new);
         CPA_CNF_TriggerUtil.recallApproval(trigger.old,trigger.new);
         CPA_CNF_TriggerUtil.UpdatePWOByCNF (trigger.newMap,trigger.oldMap);
     }
     If (trigger.isbefore && trigger.isInsert){
         CPA_CNF_TriggerUtil.CreateCNF(trigger.new);
     }
}