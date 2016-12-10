/***************************************************************
Name: UL_fundAmountCalculation()
Copyright © 2016 Salesforce
==============================================================
Purpose:
Handler class for UL_FundTransactionTrigger on FundTransaction
==============================================================
History
-------
VERSION: 1.0                                         
AUTHOR: Soumyodeep                   
DATE: 21/11/2016
DETAIL: INITIAL DEV
Description: Update the AVAILABLE TO SPEND field on the Fund record when transaction is done on the Funds.                                                            
***************************************************************/


public with sharing class UL_fundAmountCalculation{

/*******************************************************************
Purpose: Updates the AVAILABLE TO SPEND field on the Fund record only when transaction between funds happen or money is added to fund or taken out of it. 
Version 1.0
Parameters: trigger.new(list of type ACSFUL001__Fund_Transaction__c)
Returns: N/A
Throws N/A
********************************************************************/

public static void UL_availableToSpendUpdate(list<ACSFUL001__Fund_Transaction__c> fundTransactionList){

set<id> targetFundIdSet=new set<id>();
set<id> sourceFundIdSet=new set<id>(); 
set<id> transactionIdSet=new set<id>();
map<id, id> transactionIdFundIdMap= new map<id, id>();
map<id, ACSFUL001__Fund_Transaction__c> transactionRecordMap=new map<id, ACSFUL001__Fund_Transaction__c>();
//map<id, ACSFUL001__Fund__c> targetFundRecordMap=new map<id, ACSFUL001__Fund__c>();
//map<id, ACSFUL001__Fund__c> sourceFundRecordMap=new map<id, ACSFUL001__Fund__c>();
//map<id, ACSFUL001__Transaction_Template__c> transactionTemplateMap=new map<id, ACSFUL001__Transaction_Template__c>();
ACSFUL001__Fund__c targetFundRecord;
ACSFUL001__Fund__c sourceFundRecord;
ACSFUL001__Transaction_Template__c transactionTemplateRecord;

for(ACSFUL001__Fund_Transaction__c transactionLoop:fundTransactionList){

transactionIdSet.add(transactionLoop.id);
targetFundIdSet.add(transactionLoop.ACSFUL001__Target_Fund__c);
transactionIdFundIdMap.put(transactionLoop.id, transactionLoop.ACSFUL001__Target_Fund__c);
transactionRecordMap.put(transactionLoop.id, transactionLoop);

if (transactionLoop.ACSFUL001__Source_Fund__c!=Null){

sourceFundIdSet.add(transactionLoop.ACSFUL001__Source_Fund__c);
}
}

map<id, ACSFUL001__Fund__c> targetFundRecordMap=new map<id, ACSFUL001__Fund__c>([select id, name, ACSFUL001__Amount__c, UL_Committed__c, UL_Uncommitted__c, UL_Available_to_Spend__c From ACSFUL001__Fund__c Where id IN:targetFundIdSet]);
map<id, ACSFUL001__Fund__c> sourceFundRecordMap=new map<id, ACSFUL001__Fund__c>([select id, name, ACSFUL001__Amount__c, UL_Committed__c, UL_Uncommitted__c, UL_Available_to_Spend__c From ACSFUL001__Fund__c Where id IN:sourceFundIdSet]);

Id fundTransactionTemplateId = Schema.SObjectType.ACSFUL001__Transaction_Template__c.RecordTypeInfosByName.get('Fund Transaction').RecordTypeId;

map<id, ACSFUL001__Transaction_Template__c> transactionTemplateMap=new map<id, ACSFUL001__Transaction_Template__c>([select id, name, ACSFUL001__Active__c, ACSFUL001__Sales_Org__c, ACSFUL001__Transaction_Type__c, RecordTypeId from ACSFUL001__Transaction_Template__c where RecordTypeId=:fundTransactionTemplateId]);



for(ACSFUL001__Fund_Transaction__c transactionListLoop:fundTransactionList){


targetFundRecord=targetFundRecordMap.get(transactionListLoop.ACSFUL001__Target_Fund__c);
transactionTemplateRecord=transactionTemplateMap.get(transactionListLoop.ACSFUL001__Transaction_Template__c);

//system.debug('$$$record type id'+transactionTemplateRecord);

if(transactionTemplateRecord == null){
    
    return;
}

if(transactionTemplateRecord.RecordTypeId==fundTransactionTemplateId){
if(transactionListLoop.ACSFUL001__Source_Fund__c==Null){

if(transactionListLoop.ACSFUL001__Transaction_Type__c=='Initial'){

targetFundRecord.UL_Available_to_Spend__c=targetFundRecord.UL_Available_to_Spend__c+transactionListLoop.ACSFUL001__Amount__c;
}

else if(transactionListLoop.ACSFUL001__Transaction_Type__c=='Adjustment'){

targetFundRecord.UL_Available_to_Spend__c=targetFundRecord.UL_Available_to_Spend__c-transactionListLoop.ACSFUL001__Amount__c;
}

targetFundRecordMap.put(targetFundRecord.id, targetFundRecord);
}

// /*Commented out as this functionality will be done by the UL_fundTransferTransactionHandler class for trigger on Fund transaction object on update of
// Transfer type transaction to Approved */
  
//else if(transactionListLoop.ACSFUL001__Source_Fund__c!=Null){

//sourceFundRecord=sourceFundRecordMap.get(transactionListLoop.ACSFUL001__Source_Fund__c);
//sourceFundRecord.UL_Available_to_Spend__c=sourceFundRecord.UL_Available_to_Spend__c-transactionListLoop.ACSFUL001__Amount__c;
//targetFundRecord.UL_Available_to_Spend__c=targetFundRecord.UL_Available_to_Spend__c+transactionListLoop.ACSFUL001__Amount__c;

//targetFundRecordMap.put(targetFundRecord.id, targetFundRecord);
//sourceFundRecordMap.put(sourceFundRecord.id, sourceFundRecord);
//}
}
}

 database.update(targetFundRecordMap.values());
 
// /*Commented out as this functionality will be done by the UL_fundTransferTransactionHandler class for trigger on Fund transaction object on update of
// Transfer type transaction to Approved */
 
 //if(!sourceFundRecordMap.isEmpty()){
 
 //database.update(sourceFundRecordMap.values());
 //}


}
}