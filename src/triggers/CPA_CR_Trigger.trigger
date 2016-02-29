trigger CPA_CR_Trigger on CPA_CR__c (before insert, after insert, before update, after update, before Delete) {

CPA_Trigger_Pattern__c objCRPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.CRTRIGGERNAME);
	if(objCRPattern != null && objCRPattern.chk_Check_Run__c){
	
	    if(Trigger.isUpdate && Trigger.isBefore){ //for before update trigger
	        
	        CPA_CR_TriggerUtil.previouStatusValue(trigger.old,trigger.new);
	        CPA_CR_TriggerUtil.checklistValueOfCR(trigger.new);
	        CPA_CR_TriggerUtil.requireApprovalComments(trigger.new);
	      //  CPA_CR_TriggerUtil.unlockrecord(trigger.old,trigger.new);
	      CPA_CR_TriggerUtil.calculateDelta(trigger.oldMap,trigger.newMap);
	        
	    }
	    if(Trigger.isUpdate && Trigger.isAfter){ //for after update trigger
	        CPA_CR_TriggerUtil.submitforApproval(trigger.old,trigger.new);
	        CPA_CR_TriggerUtil.recallApproval(trigger.old,trigger.new);
	
	    }
	    if(Trigger.isInsert && Trigger.isBefore){ //for before insert trigger
	       CPA_CR_TriggerUtil.CreateCR(trigger.new);
	       CPA_CR_TriggerUtil.checklistValueOfCR(trigger.new);
	       CPA_CR_TriggerUtil.standaloneCR(trigger.new);
	       //added by Dinesh, remove below comments later on
	       //CPA_CR_TriggerUtil.internalCRID(trigger.new);
	
	    }
	    if(Trigger.isInsert && Trigger.isAfter){ //for after insert trigger
	        CPA_CR_TriggerUtil.newCR(trigger.new);
	    }
	 
	    if(Trigger.isDelete && Trigger.isBefore){ //for before delete trigger
	        CPA_CR_TriggerUtil.DOntDeleteCR(trigger.old);
	    }
	}
}