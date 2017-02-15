/***************************************************************
    Name: UL_ApprovalThresholdTrigger
    Copyright: Accenture
    ======================================================
    Purpose:
    Trigger on ApprovalThreshold Object
    ======================================================
    History
    -------
    VERSION     AUTHOR         DATE             DETAIL                 Description
    1.0         Badari         29/11/2016       Initial Development    Handles ApprovalThreshold before insert,before update events
    ***************************************************************/
    trigger UL_ApprovalThresholdTrigger on UL_Approval_Threshold__c (Before Insert, Before Update) {
        if(UL_Utility.IS_APPROVAL_THRESHIOLD_TRIGGER_ENABLED){
            if(trigger.isinsert){
                UL_ApprovalThresholdHandler.NewCareerLevel(trigger.new);
            }
            if(trigger.isupdate){
                UL_ApprovalThresholdHandler.UpdateCareerLevel(trigger.new);
            }
        }
    }