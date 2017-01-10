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
    
    private static final String TRANSACTION_TYPE = 'Transfer';
    
    /*******************************************************************
    Purpose: To compare the Product levels for Source and Target Funds during the Fund Transaction. 
    Version 1.0
    Parameters: trigger.new(list of type ACCL__Fund_Transaction__c)
    Returns: N/A
    Throws N/A
    ********************************************************************/  
    public static void fundTransfer(list<ACCL__Fund_Transaction__c> ftlist){
       Set<Id> fundIdSet = new Set<Id>();
       Set<Id> templateSet = new Set<Id>();
       
       for(ACCL__Fund_Transaction__c fundTran: ftList){
         fundIdSet.add(fundTran.ACCL__Source_Fund__c);
         fundIdSet.add(fundTran.ACCL__Target_Fund__c);
         templateSet.add(fundTran.ACCL__Fund_Transaction_Template__c);
       }
         try{
       Map<Id,ACCL__Fund__c> fundMap = new Map<Id,ACCL__Fund__c>([SELECT ACCL__Anchor_Product__c FROM ACCL__Fund__c WHERE Id IN:fundIdSet LIMIT:(Limits.getLimitQueryRows()-Limits.getQueryRows())]);
       Set<Id> anchProdSet = new Set<Id>();
       For(ACCL__Fund__c fundObj: fundMap.Values()){
         anchProdSet.add(fundObj.ACCL__Anchor_Product__c);
       }
       
       Map<Id,ACCL__Product__c> prodMap = new Map<Id,ACCL__Product__c>([SELECT ACCL__Category__c FROM ACCL__Product__c WHERE id IN:anchProdSet LIMIT:(Limits.getLimitQueryRows()-Limits.getQueryRows())]);
       Map<Id,String> fundLevelMap = new Map<Id,String>();
       ACCL__Product__c tempProd = null;
       for(ACCL__Fund__c fundObj: fundMap.values()){
           tempProd =  prodMap.get(fundObj.ACCL__Anchor_Product__c);
           if(tempProd !=null){
            fundLevelMap.put(fundObj.id, tempProd.ACCL__Category__c);
           }
       }
        
        String source = null;
        String target = null;
        ACCL__Fund_Transaction_Template__c  tranTemplate; 
        Map<id, ACCL__Fund_Transaction_Template__c> templateMap = new Map<id, ACCL__Fund_Transaction_Template__c>([SELECT Id, ACCL__Transaction_Type__c, UL_Cross_Category_Transfer_Allowed__c FROM ACCL__Fund_Transaction_Template__c WHERE Id IN:templateSet LIMIT:(Limits.getLimitQueryRows()-Limits.getQueryRows())]);
        
        for(ACCL__Fund_Transaction__c fundTran: ftList){
          tranTemplate = templateMap.get(fundTran.ACCL__Fund_Transaction_Template__c); 
          if(tranTemplate == null){
              continue;
          }
          else if((!String.isEmpty(tranTemplate.ACCL__Transaction_Type__c)) && TRANSACTION_TYPE.equalsIgnoreCase(tranTemplate.ACCL__Transaction_Type__c)){
                 if(tranTemplate.UL_Cross_Category_Transfer_Allowed__c==True && fundLevelMap.get(fundTran.ACCL__Source_Fund__c)!= Null && fundLevelMap.get(fundTran.ACCL__Target_Fund__c)!= Null ){
                     source = fundLevelMap.get(fundTran.ACCL__Source_Fund__c);
                     target= fundLevelMap.get(fundTran.ACCL__Target_Fund__c);
                    
                     if(target.equalsIgnoreCase(source)){
                         fundTran.adderror(System.Label.UL_Cross_Category_Error);
                     }
                 }
                 else {
                     if(tranTemplate.UL_Cross_Category_Transfer_Allowed__c==False && fundLevelMap.get(fundTran.ACCL__Source_Fund__c)!= Null && fundLevelMap.get(fundTran.ACCL__Target_Fund__c)!= Null){
                         source = fundLevelMap.get(fundTran.ACCL__Source_Fund__c);
                         target= fundLevelMap.get(fundTran.ACCL__Target_Fund__c);
                        
                         if(!target.equalsIgnoreCase(source)){
                             fundTran.adderror(System.Label.UL_Transfer_Error); 
                         }
                     }
                } 
          }
     }
     }
     catch (Exception ex){
                UL_Utility.logError(ex, UserInfo.getUserId());
            }  
    }
    }