trigger UL_ApprovalThresholdTrigger on UL_Approval_Threshold__c (Before Insert, Before Update) {

if(trigger.isinsert){
UL_ApprovalThresholdHandler.NewCareerLevel(trigger.new);
}
if(trigger.isupdate){
UL_ApprovalThresholdHandler.UpdateCareerLevel(trigger.new);
}
}