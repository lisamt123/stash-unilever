/***************************************************************
    Name: UL_FundTransactionTrigger
    Copyright © 2017 Salesforce
    ======================================================
    Purpose:
    Trigger on Fund Transaction Object
    ======================================================
    History
    -------
    VERSION: 1.0                                         
    AUTHOR: Soumyodeep                   
    DATE: 20/11/2016
    DETAIL: INITIAL DEV
    Description: Checks the FUnd transaction records Before Insert, after insert and after update.                                                            
    ***************************************************************/
    trigger UL_FundTransactionTrigger on ACCL__Fund_Transaction__c (Before Insert, after insert, after update) {
        if(UL_Utility.IS_FUND_TRANSACTION_TRIGGER_ENABLED){
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
    }