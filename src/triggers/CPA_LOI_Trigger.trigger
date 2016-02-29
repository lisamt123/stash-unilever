trigger CPA_LOI_Trigger on CPA_LOI__c (before insert, after insert, before update, after update,  before Delete) {

CPA_Trigger_Pattern__c objLOIPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.LOITRIGGERNAME);
	if(objLOIPattern != null && objLOIPattern.chk_Check_Run__c){
    if(Trigger.isUpdate && Trigger.isBefore){ //for before update trigger
        CPA_LOI_TriggerUtil.checklistValueOfLOI(trigger.new);
        CPA_LOI_TriggerUtil.requireApprovalComments(trigger.new);
       
    }
    if(Trigger.isUpdate && Trigger.isAfter){ //for after update trigger
        CPA_LOI_TriggerUtil.submitforApproval(trigger.old,trigger.new);
        CPA_LOI_TriggerUtil.recallApproval(trigger.old,trigger.new);
        CPA_LOI_TriggerUtil.cancelAllLOI(trigger.new);
    }
    if(Trigger.isInsert && Trigger.isBefore){ //for before insert trigger
        CPA_LOI_TriggerUtil.checkforCancel(trigger.new);
        CPA_LOI_TriggerUtil.checklistValueOfLOI(trigger.new);
        //added by dinesh to generate internal LOI ID and internal PWO ID
        CPA_LOI_TriggerUtil.internalLIOID(trigger.new);
        //Below line added by Dinesh [16/02]
        CPA_LOI_TriggerUtil.getInternalPWOIDFromPWORF(trigger.new);
    }
    
    //if(Trigger.isInsert && Trigger.isAfter){ //for after insert trigger
        //added by dinesh
        //CPA_LOI_TriggerUtil.internalLIOID(trigger.new);
    //}
    
    if(Trigger.isDelete && Trigger.isBefore){ //for before delete trigger
        trigger.old[0].addError('LOI cant be deleted');   
        CPA_LOI_TriggerUtil.DontDelete(trigger.old);        
    }
	}
}