trigger UL_FundTransactionTrigger on ACSFUL001__Fund_Transaction__c (Before Insert) {
if(trigger.isinsert){
UL_FundTransactionHandler.FundTransfer(trigger.new);
}

}