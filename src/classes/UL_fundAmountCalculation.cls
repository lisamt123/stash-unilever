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

private Static final String TRANSACTION_TYPE_ADJUSTMENT = 'Adjustment';
private Static final String TRANSACTION_TYPE_INITIAL = 'Initial';
private Static final String TYPE_FUND_TRANSACTION = 'Fund Transaction';
private Static final String RECORDTYPE_FUND_TRANSACTION = 'TYPE_FUND_TRANSACTION';

/*******************************************************************
Purpose: Updates the AVAILABLE TO SPEND field on the Fund record only when transaction between funds happen or money is added to fund or taken out of it. 
Version 1.0
Parameters: trigger.new(list of type ACCL__Fund_Transaction__c)
Returns: N/A
Throws N/A
********************************************************************/
public static void ul_availableToSpendUpdate(list<ACCL__Fund_Transaction__c> fundTransactionList){

set<id> targetFundIdSet=new set<id>();
set<id> sourceFundIdSet=new set<id>(); 
set<id> transactionIdSet=new set<id>();
map<id, id> transactionIdFundIdMap= new map<id, id>();
map<id, ACCL__Fund_Transaction__c> transactionRecordMap=new map<id, ACCL__Fund_Transaction__c>();
ACCL__Fund__c targetFundRecord = null;
ACCL__Fund_Transaction_Template__c transactionTemplateRecord = null;

try{

    for(ACCL__Fund_Transaction__c transactionLoop:fundTransactionList){
    
        transactionIdSet.add(transactionLoop.id);
        targetFundIdSet.add(transactionLoop.ACCL__Target_Fund__c);
        transactionIdFundIdMap.put(transactionLoop.id, transactionLoop.ACCL__Target_Fund__c);
        transactionRecordMap.put(transactionLoop.id, transactionLoop);
    
        if (transactionLoop.ACCL__Source_Fund__c != null){
            sourceFundIdSet.add(transactionLoop.ACCL__Source_Fund__c);
        }
    }

    map<id, ACCL__Fund__c> targetFundRecordMap=new map<id, ACCL__Fund__c>([select id, name, ACCL__Amount__c, UL_Committed__c, UL_Uncommitted__c, UL_Available_to_Spend__c From ACCL__Fund__c Where id IN:targetFundIdSet LIMIT:(Limits.getLimitQueryRows()-Limits.getQueryRows())]);
    map<id, ACCL__Fund__c> sourceFundRecordMap=new map<id, ACCL__Fund__c>([select id, name, ACCL__Amount__c, UL_Committed__c, UL_Uncommitted__c, UL_Available_to_Spend__c From ACCL__Fund__c Where id IN:sourceFundIdSet LIMIT:(Limits.getLimitQueryRows()-Limits.getQueryRows())]);

    Id fundTransactionTemplateId = Schema.SObjectType.ACCL__Fund_Transaction_Template__c.RecordTypeInfosByName.get('Fund Transaction').RecordTypeId;

    map<id, ACCL__Fund_Transaction_Template__c> transactionTemplateMap=new map<id, ACCL__Fund_Transaction_Template__c>([select id, name, ACCL__Active__c, ACCL__Sales_Org__c, ACCL__Transaction_Type__c, RecordTypeId from ACCL__Fund_Transaction_Template__c where RecordTypeId=:fundTransactionTemplateId LIMIT:(Limits.getLimitQueryRows()-Limits.getQueryRows())]);

    for(ACCL__Fund_Transaction__c transactionListLoop:fundTransactionList){
    
        
        targetFundRecord=targetFundRecordMap.get(transactionListLoop.ACCL__Target_Fund__c);
        transactionTemplateRecord=transactionTemplateMap.get(transactionListLoop.ACCL__Fund_Transaction_Template__c);
        
        if(transactionTemplateRecord == null){
            return;
        }
        
        if(transactionTemplateRecord.RecordTypeId==fundTransactionTemplateId){
            if(transactionListLoop.ACCL__Source_Fund__c == null){
            
                if(transactionListLoop.ACCL__Transaction_Type__c != UL_Utility.STRING_NULL &&  transactionListLoop.ACCL__Transaction_Type__c.equalsIgnoreCase(TRANSACTION_TYPE_INITIAL)){
                    targetFundRecord.UL_Available_to_Spend__c=targetFundRecord.UL_Available_to_Spend__c+transactionListLoop.ACCL__Amount__c;
                }
                else {
                    if(transactionListLoop.ACCL__Transaction_Type__c != UL_Utility.STRING_NULL && transactionListLoop.ACCL__Transaction_Type__c.equalsIgnoreCase(TRANSACTION_TYPE_ADJUSTMENT)){
                        targetFundRecord.UL_Available_to_Spend__c=targetFundRecord.UL_Available_to_Spend__c-transactionListLoop.ACCL__Amount__c;
                    }
                }           
                
                targetFundRecordMap.put(targetFundRecord.id, targetFundRecord);
            }
        }
    }

    database.update(targetFundRecordMap.values());
    }catch (Exception ex){
        UL_Utility.logError(ex, UserInfo.getUserId());
    }
  }
}