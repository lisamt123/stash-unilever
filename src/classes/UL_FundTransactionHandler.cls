/***************************************************************
Name: UL_FundTransactionHandler()
Copyright © 2016 Salesforce
======================================================
Purpose:
Handler class for UL_FundTransactionTrigger.
======================================================
History
-------
VERSION: 1.0                                         
AUTHOR: Soumyodeep                   
DATE: 19/10/2016
DETAIL: INITIAL DEV
Description: Check for transfer of money between funds during Cross Category and Transfer Type transaction.                                                            
***************************************************************/

public with sharing class UL_FundTransactionHandler{

private static final String transType = 'Transfer';

/*******************************************************************
Purpose: To compare the Product levels for Source and Target Funds during the Fund Transaction. 
Version 1.0
Parameters: trigger.new(list of type ACSFUL001__Fund_Transaction__c)
Returns: N/A
Throws N/A
********************************************************************/

public static void FundTransfer(list<ACSFUL001__Fund_Transaction__c> ftlist){
   Set<Id> fundIdSet = new Set<Id>();
   Set<Id> templateSet = new Set<Id>();
   
   for(ACSFUL001__Fund_Transaction__c fundTran: ftList){
     fundIdSet.add(fundTran.ACSFUL001__Source_Fund__c);
     fundIdSet.add(fundTran.ACSFUL001__Target_Fund__c);
     templateSet.add(fundTran.ACSFUL001__Transaction_Template__c);
   }
     try{
   Map<Id,ACSFUL001__Fund__c> fundMap = new Map<Id,ACSFUL001__Fund__c>([SELECT ACSFUL001__Anchor_Product__c FROM ACSFUL001__Fund__c WHERE Id IN:fundIdSet LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())]);
   Set<Id> anchProdSet = new Set<Id>();
   For(ACSFUL001__Fund__c fundObj: fundMap.Values()){
     anchProdSet.add(fundObj.ACSFUL001__Anchor_Product__c);
   }
   
   Map<Id,ACSFUL001__Product__c> prodMap = new Map<Id,ACSFUL001__Product__c>([SELECT ACSFUL001__Product_Level__c FROM ACSFUL001__Product__c WHERE id IN:anchProdSet LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())]);
   Map<Id,String> fundLevelMap = new Map<Id,String>();
   ACSFUL001__Product__c tempProd;
   for(ACSFUL001__Fund__c fundObj: fundMap.values()){
       tempProd =  prodMap.get(fundObj.ACSFUL001__Anchor_Product__c);
       if(tempProd !=null){
        fundLevelMap.put(fundObj.id, tempProd.ACSFUL001__Product_Level__c);
       }
   }
    
    String source, target;
    ACSFUL001__Transaction_Template__c  tranTemplate; 
    Map<id, ACSFUL001__Transaction_Template__c> templateMap = new Map<id, ACSFUL001__Transaction_Template__c>([SELECT Id, ACSFUL001__Transaction_Type__c, UL_Cross_Category_Transfer_Allowed__c FROM ACSFUL001__Transaction_Template__c WHERE Id IN:templateSet LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())]);
    
    for(ACSFUL001__Fund_Transaction__c fundTran: ftList){
      tranTemplate = templateMap.get(fundTran.ACSFUL001__Transaction_Template__c); 
      if(tranTemplate == null){
          continue;
      }
      else if(tranTemplate.ACSFUL001__Transaction_Type__c.equalsIgnoreCase(transType)){
             if(tranTemplate.UL_Cross_Category_Transfer_Allowed__c==True && fundLevelMap.get(fundTran.ACSFUL001__Source_Fund__c)!= Null && fundLevelMap.get(fundTran.ACSFUL001__Target_Fund__c)!= Null ){
                 source = fundLevelMap.get(fundTran.ACSFUL001__Source_Fund__c);
                 target= fundLevelMap.get(fundTran.ACSFUL001__Target_Fund__c);
                
                 if(target.equalsIgnoreCase(source)){
                     fundTran.adderror(System.Label.UL_Cross_Category_Error);
                 }
             }
             else if(tranTemplate.UL_Cross_Category_Transfer_Allowed__c==False && fundLevelMap.get(fundTran.ACSFUL001__Source_Fund__c)!= Null && fundLevelMap.get(fundTran.ACSFUL001__Target_Fund__c)!= Null){
                 source = fundLevelMap.get(fundTran.ACSFUL001__Source_Fund__c);
                 target= fundLevelMap.get(fundTran.ACSFUL001__Target_Fund__c);
                
                 if(!target.equalsIgnoreCase(source)){
                     fundTran.adderror(System.Label.UL_Transfer_Error); 
                 }
            } 
      }
 }
 }
 Catch (Exception e){
            //System.debug('An exception occurred getLastLevAcc() block: ' + e.getMessage());
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), 'UL_AccountTriggerHandler', 'getLastLevAcc', 'An Exception occured', e, NULL, NULL, NULL, NULL,UL_Utility.APPLICATION_NAME);
        }  
}
}