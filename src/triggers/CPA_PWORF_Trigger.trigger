trigger CPA_PWORF_Trigger on CPA_PWORF__c (before insert, after insert, before update, after update, before Delete) {

CPA_Trigger_Pattern__c objAttachmentPattern = CPA_Trigger_Pattern__c.getValues(CPA_ConstantsForContractingAppClasses.PWORFTRIGERNAME);
		if(objAttachmentPattern != null && objAttachmentPattern.chk_Check_Run__c){
	   
	    if(Trigger.isUpdate && Trigger.isBefore){ //for before update trigger - this is inactive at present
	        //CPA_PWORF_TriggerUtil.recallApproval(trigger.new);//to perform recall Approval process on PWORF record 
	        CPA_PWORF_TriggerUtil.updateSLAData(trigger.new);
	        //CPA_PWORF_TriggerUtil.AssignProject_requestor(trigger.new); // to assign Project_requestor if not selected
	        CPA_PWORF_TriggerUtil.requireApprovalComments(trigger.new);
	        //CPA_PWORFAgeing.calcualteAgeing(trigger.new); // to set the Ageing Days.
	        //Dinesh added below code [17/02] to generate internal PWO ID
	        //later on move this method to CPA_PWORF_TriggerUtil class
	        CPA_CalculationOfBusinessDaysForSLADates.generateInternalPWOID(trigger.old,trigger.new);
	    }
	    if(Trigger.isUpdate && Trigger.isAfter){ //for after update trigger
	        Approval.unLockResult lrList;
	        if(trigger.new[0].isApprovalProcessStarted__c){
	            lrList = Approval.unlock(trigger.new[0].id, false); 
	            if (lrList.isSuccess()) {
	                //Operation was successful, so get the ID of the record that was processed
	                System.debug('Successfully locked account with ID: ' + lrList.getId());
	            }          
	        }
	         CPA_PWORF_TriggerUtil.submitforApproval(trigger.old,trigger.new);
	         CPA_PWORF_TriggerUtil.recallApproval(trigger.old,trigger.new);
	         //CPA_PWORF_TriggerUtil.updateSLAData(trigger.new);
	        // CPA_PWORFAgeing.calcualteAgeing(trigger.new); // to set the Ageing Days.
	         //Dinesh added below line for search testing, please dont remove this line
	         //9/2 - commented because, generating PWO ID either from LIO or PWO
	         //CPA_CalculationOfBusinessDaysForSLADates.forSearch(trigger.old,trigger.new);
	    }
	   /*if(Trigger.isInsert && Trigger.isBefore){ //for before insert trigger
	        //CPA_PWORF_TriggerUtil.vDMNameUpdate(trigger.new);//to update the VDM_Name__c on PWORF record
	        //CPA_PWORF_TriggerUtil.AssignProject_requestor(trigger.new); // to assign Project_requestor if not selected
	        
	    }*/
	    
	    //if(Trigger.isInsert && Trigger.isAfter){ //for after insert trigger
	         //CPA_PWORF_TriggerUtil.updateSLAData(trigger.new);
	        // CPA_PWORFAgeing.calcualteAgeing(trigger.new); // to set the Ageing Days.
	    //}
	    
	    if(Trigger.isDelete && Trigger.isBefore){ //for before delete trigger
	        CPA_PWORF_TriggerUtil.DontDelete(trigger.old);
	    }
	}
}