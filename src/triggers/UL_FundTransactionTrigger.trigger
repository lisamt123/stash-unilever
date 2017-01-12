trigger UL_FundTransactionTrigger on ACCL__Fund_Transaction__c (Before Insert, after insert, after update) {

if(trigger.isbefore && trigger.isinsert){
UL_FundTransactionHandler.FundTransfer(trigger.new);
}

if(trigger.isafter && trigger.isinsert){

UL_fundAmountCalculation.UL_availableToSpendUpdate(trigger.new);
UL_fundTransferAvalbToSpendUpdateHandler.UL_fundTransferTransaction(trigger.new);
}

if(trigger.isafter && trigger.isupdate){

UL_fundTransferTransactionHandler.UL_transferTransaction(trigger.new);
}
}