trigger UL_ApprovalThresholdTrigger on UL_Approval_Threshold__c (Before Insert, Before Update) {

if(trigger.isinsert || trigger.isupdate){
UL_ApprovalThresholdHandler.CareerLevel(trigger.new);
}
}