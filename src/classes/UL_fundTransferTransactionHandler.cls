/***************************************************************
    Name: UL_fundTransferTransactionHandler()
    Copyright © 2016 Salesforce
    ======================================================
    Purpose:
    Handler class for UL_FundTransactionTrigger for IsUpdate and Isafter.
    ======================================================
    History
    -------
    VERSION: 1.0                                         
    AUTHOR: Soumyodeep                   
    DATE: 06/12/2016
    DETAIL: INITIAL DEV
    Description:This handler class creates the Fund Transaction rows when a Cross Category transaction is approved.
    Caveat: This calls is not marked with Sharing as the record modified in the trigger is locked by the Approval process, so this class needs to be executed in system context                                                           
*******************************************************************/
public without sharing class UL_fundTransferTransactionHandler{

private Static final String FUND_APPROVED_STATUS = 'Approved';
private Static final String FUND_TRANSFER_TRANSACTION = 'Transfer';

/*******************************************************************
Purpose: On Approval of the Cross Category transaction creates the related Fund Transaction rows record 
Version 1.0
Parameters: trigger.new(list of type ACCL__Fund_Transaction__c)
Returns: N/A
Throws N/A
********************************************************************/ 
public static void UL_transferTransaction(list<ACCL__Fund_Transaction__c> transferTransactionList){

List<ACCL__Fund_Transaction_Row__c>listTransactionRow = new list<ACCL__Fund_Transaction_Row__c>();
set<id> fundIdSet=new set<id>();
ACCL__Fund__c sourceFund;
ACCL__Fund__c targetFund;


for(ACCL__Fund_Transaction__c createFundSetLoop:transferTransactionList){

       
    // Adding the source and the target fund ids to a set
       fundIdSet.add(createFundSetLoop.ACCL__Source_Fund__c);
       fundIdSet.add(createFundSetLoop.ACCL__Target_Fund__c);

}

 // Storing Fund records in a map
map<id, ACCL__Fund__c> FundRecordMap=new map<id, ACCL__Fund__c>([Select id, name, UL_Available_to_Spend__c from ACCL__Fund__c where id in:fundIdSet LIMIT:(Limits.getLimitQueryRows()-Limits.getQueryRows())]);


for(ACCL__Fund_Transaction__c transferTransactionLoop:transferTransactionList){

if(FUND_APPROVED_STATUS.equalsIgnoreCase(transferTransactionLoop.UL_Status__c) && FUND_TRANSFER_TRANSACTION.equalsIgnoreCase(transferTransactionLoop.ACCL__Transaction_Type__c) &&
   transferTransactionLoop.ACCL__Source_Fund__c!=null){
   
   // In case if Transfer transaction,amount will be deducted from the source fund and added in the target fund
       listTransactionRow.add(createTransactionRows(transferTransactionLoop.ACCL__Amount__c,
       transferTransactionLoop.ACCL__Source_Fund__c,transferTransactionLoop.ACCL__Target_Fund__c,transferTransactionLoop.id));
       
       listTransactionRow.add(createTransactionRows((-1)*transferTransactionLoop.ACCL__Amount__c,
       transferTransactionLoop.ACCL__Target_Fund__c,transferTransactionLoop.ACCL__Source_Fund__c,transferTransactionLoop.id));
       
   //Fetching the Fund records
     sourceFund=FundRecordMap.get(transferTransactionLoop.ACCL__Source_Fund__c);
     targetFund=FundRecordMap.get(transferTransactionLoop.ACCL__Target_Fund__c);
     
   //Updating the Available To Spend on the Source and the Target Fund
     sourceFund.UL_Available_to_Spend__c=sourceFund.UL_Available_to_Spend__c-transferTransactionLoop.ACCL__Amount__c;
     targetFund.UL_Available_to_Spend__c=targetFund.UL_Available_to_Spend__c+transferTransactionLoop.ACCL__Amount__c;
     
   FundRecordMap.put(sourceFund.id, sourceFund);
   FundRecordMap.put(targetFund.id, targetFund);
   }
   
}

    try{
    database.insert(listTransactionRow);
    database.update(FundRecordMap.values());
    }
    catch(Exception ex){
        UL_Utility.logError(ex, UserInfo.getUserId());
    }
}

/*******************************************************************
Purpose: Creates the Fund Transaction rows record 
Version 1.0
Parameters: Amount in decimal, Source Fund id, Target Fund id
Returns: N/A
Throws N/A
********************************************************************/ 
private static ACCL__Fund_Transaction_Row__c createTransactionRows(Decimal amount,Id sourceFund,Id targetFund,Id transactionRecord){
        ACCL__Fund_Transaction_Row__c transRow = new ACCL__Fund_Transaction_Row__c();
        transRow.ACCL__Amount__c = amount;
        transRow.ACCL__Source_Fund__c = sourceFund;
        transRow.ACCL__Target_Fund__c = targetFund;
        transRow.ACCL__Fund_Transaction__c = transactionRecord;
        return transRow;
    }

}