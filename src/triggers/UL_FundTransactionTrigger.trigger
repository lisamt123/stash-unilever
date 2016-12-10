trigger UL_FundTransactionTrigger on ACSFUL001__Fund_Transaction__c (Before Insert, after insert) {

if(trigger.isbefore && trigger.isinsert){
UL_FundTransactionHandler.FundTransfer(trigger.new);
}

if(trigger.isafter && trigger.isinsert){

UL_fundAmountCalculation.UL_availableToSpendUpdate(trigger.new);
}
}