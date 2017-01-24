/***************************************************************
Name: UL_fundCloseStatusHandler()
Copyright © 2017 Salesforce
======================================================
Purpose:
Handler class for UL_FundShareTrigger on Fund.
======================================================
History
-------
VERSION: 1.0                                         
AUTHOR: Soumyodeep                   
DATE: 20/11/2016
DETAIL: INITIAL DEV
Description: This prevents a fund from getting closed if that fund is associated with any open transaction or a open promotion.                                                            
***************************************************************/
Public with sharing class UL_fundCloseStatusHandler{
    
 private Static final String FUND_CLOSED_STATUS='Closed';
 private Static final String TRANSACTION_PENDING_APPROVAL='Sent/Pending Approval';


/*******************************************************************
Purpose: Prevents the status of the fund to be moved to Closed if there is a transaction against that fund which is waiting for approval. 
Version 1.0
Parameters: trigger.new(list of type ACCL__Fund__c)
Returns: N/A
Throws N/A
********************************************************************/   
 public static void openTransactionCheck(list<ACCL__Fund__c>fundList){
     
    
   list<ACCL__Fund_Transaction__c> fundTransactionList=new list<ACCL__Fund_Transaction__c>();
   map<id, list<id>> mapFundTransacttion=new map<id, list<id>>();
   map<id, ACCL__Fund_Transaction__c> fundTransactionMap=new map<id, ACCL__Fund_Transaction__c>();
   //ACCL__Fund__c fundRecord;
   id fundTransactionRecordId;
   ACCL__Fund_Transaction__c fundTransactionRecord;
        
   fundTransactionList =[Select id, UL_Status__c, ACCL__Target_Fund__c, ACCL__Source_Fund__c From ACCL__Fund_Transaction__c 
                         Where ACCL__Target_Fund__c In :fundList Or ACCL__Source_Fund__c In :fundList];                         
                              
   for(ACCL__Fund_Transaction__c fundTransactionLoop:fundTransactionList){
        
       if(!mapFundTransacttion.containskey(fundTransactionLoop.ACCL__Source_Fund__c)){
           mapFundTransacttion.put(fundTransactionLoop.ACCL__Source_Fund__c,new list<id>{fundTransactionLoop.id});
       }
       else{
           List<id> lstId = mapFundTransacttion.get(fundTransactionLoop.ACCL__Source_Fund__c);
           lstId.add(fundTransactionLoop.id);
           mapFundTransacttion.put(fundTransactionLoop.ACCL__Source_Fund__c,lstId);
       }
       if(!mapFundTransacttion.containskey(fundTransactionLoop.ACCL__Target_Fund__c)){
           mapFundTransacttion.put(fundTransactionLoop.ACCL__Target_Fund__c,new list<id>{fundTransactionLoop.id});
       }
       else{
           List<id> lstId = mapFundTransacttion.get(fundTransactionLoop.ACCL__Target_Fund__c);
           lstId.add(fundTransactionLoop.id);
           mapFundTransacttion.put(fundTransactionLoop.ACCL__Target_Fund__c,lstId);
       }
        
       fundTransactionMap.put(fundTransactionLoop.id, fundTransactionLoop);
   }
   
   
   for(ACCL__Fund__c fundLoop:fundList){
       if(!mapFundTransacttion.isEmpty() && mapFundTransacttion.containskey(fundLoop.id)){
            for(Id fundTransId : mapFundTransacttion.get(fundLoop.id)){
                if(fundLoop.ACCL__Status__c.equalsIgnoreCase(FUND_CLOSED_STATUS) && fundTransactionMap.get(fundTransId).UL_Status__c.equalsIgnoreCase(TRANSACTION_PENDING_APPROVAL)){
                   fundLoop.ACCL__Status__c.adderror(System.Label.UL_Fund_Open_Transaction_Error);
                }
            }
       }
   }
       
     
 }
 
 /*******************************************************************
Purpose: Prevents the status of the fund to be moved to Closed if that fund is associated with a Open promotion. 
Version 1.0
Parameters: trigger.new(list of type ACCL__Fund__c)
Returns: N/A
Throws N/A
********************************************************************/
 public static void openPromotionCheck(list<ACCL__Fund__c>fundList){
 
  map<id, list<id>> mapOfFundIdTacticIdList= new map<id, list<id>>();
  list <id> tacticIdList=new list<id>();
  map<id, ACCL__Tactic__c> alltacticMap = new map<id, ACCL__Tactic__c>();
  
  list<ACCL__Tactic_Fund__c> fundIdTacticIdlist =[Select ACCL__Fund__c, ACCL__Tactic__c from ACCL__Tactic_Fund__c where ACCL__Fund__c in:fundList];
  
  
  for(ACCL__Tactic_Fund__c fundIdTacticIdLoop:fundIdTacticIdlist){
      if(!mapOfFundIdTacticIdList.containskey(fundIdTacticIdLoop.ACCL__Fund__c)){
         mapOfFundIdTacticIdList.put(fundIdTacticIdLoop.ACCL__Fund__c, new list<id>{fundIdTacticIdLoop.ACCL__Tactic__c});
      }
      
      else{
      list <id> listId=mapOfFundIdTacticIdList.get(fundIdTacticIdLoop.ACCL__Fund__c);
      listId.add(fundIdTacticIdLoop.ACCL__Tactic__c);
      mapOfFundIdTacticIdList.put(fundIdTacticIdLoop.ACCL__Fund__c, listId);
      }
      tacticIdList.add(fundIdTacticIdLoop.ACCL__Tactic__c);
  }
  if(!tacticIdList.isEmpty()){ 
    map<id, ACCL__Tactic__c> tacticMap = new map<id, ACCL__Tactic__c>([Select id, UL_Promotion_Closed__c from ACCL__Tactic__c Where id In:tacticIdList]);
    alltacticMap = tacticMap;
  }
  
  for(ACCL__Fund__c fundLoop:fundList){
      if(!mapOfFundIdTacticIdList.isEmpty() && mapOfFundIdTacticIdList.containskey(fundLoop.id)){
         for(id tacticIdLoop:mapOfFundIdTacticIdList.get(fundLoop.id)){ 
         system.debug('$$2'+tacticIdLoop);
         system.debug('$$1Promostatus'+alltacticMap.get(tacticIdLoop).UL_Promotion_Closed__c);
             if(alltacticMap.containskey(tacticIdLoop) && fundLoop.ACCL__Status__c.equalsIgnoreCase(FUND_CLOSED_STATUS) && alltacticMap.get(tacticIdLoop).UL_Promotion_Closed__c==False){ 
             fundLoop.ACCL__Status__c.adderror(System.Label.UL_Fund_Open_Promotion_Error);
             }
         }
      }
  }
 }
}