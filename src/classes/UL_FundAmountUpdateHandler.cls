/***************************************************************
Name: UL_FundAmountUpdateHandler()
Copyright © 2016 Salesforce
======================================================
Purpose:
Handler class for UL_Tactic_trigger on Tactic.
======================================================
History
-------
VERSION: 1.0                                         
AUTHOR: Soumyodeep                   
DATE: 17/11/2016
DETAIL: INITIAL DEV
Description: Update the COMITTED, UNCOMITTED, AVAILABLE TO SPEND and TOTAL SPENT field on the Fund record when the status of the Promotion related to the Fund is changed.                                                            
***************************************************************/
public with Sharing class UL_FundAmountUpdateHandler {

private Static final String APPROVED_STATUS = 'Approved';
private Static final String REJECTED_STATUS = 'Rejected';
private Static final String FORAPPROVAL_STATUS = 'ForApproval';
private Static final String PROMOTION_TRANSACTION = 'Promotion Transaction';
private static final String RECORDTYPE_PROMOTION_TRANSACTION = 'PROMOTION_TRANSACTION';

/*******************************************************************
Purpose: Update the COMITTED, UNCOMITTED, AVAILABLE TO SPEND and TOTAL SPENT field on the Fund record when the status of the Promotion related to the Fund is changed. 
Version 1.0
Parameters: trigger.new(list of type ACCL__Fund_Transaction__c)
Returns: N/A
Throws N/A
********************************************************************/    
    public static void FundAmountUpdate(list<ACCL__Tactic__c> tacticValueList){
     
        set<id> tacticSetId=new set<id>();
        set<id> fundIdSet=new set<id>();
        
        map<id, id> tacticidFundidMap= new map<id, id>();
        map<id, ACCL__Fund__c> tacticIdFundRecordMap= new map<id, ACCL__Fund__c>();
        ACCL__Fund__c mapFundRecord;
        ACCL__Tactic__c tacticRecord;
        ACCL__Fund__c fundRecord;
        id fundRecordId;
        map<id, double> fundidTacticAmountMap= new map<id, double>();
        double mapTacticAmount;
        ACCL__Fund__c fundNewRecord;
        string FundSalesOrg;
        ACCL__Fund_Transaction_Template__c transactionTemplateRecord;
        list<ACCL__Fund_Transaction__c> fundTransactionList = new list<ACCL__Fund_Transaction__c>();
        list<ACCL__Fund_Transaction_Row__c> fundTransactionRowsList= new list<ACCL__Fund_Transaction_Row__c>();
        Map<Id, ACCL__Tactic__c> tacticMap = new Map<Id, ACCL__Tactic__c>();
     try{   
        for(ACCL__Tactic__c tacticLoop:tacticValueList){
            
         tacticSetId.add(tacticLoop.id);
         tacticMap.put(tacticLoop.id, tacticLoop);
        }
        
        
        for(ACCL__Tactic_Fund__c tacticFundLoop:[Select ACCL__Fund__c, ACCL__Tactic__c from ACCL__Tactic_Fund__c where ACCL__Tactic__c In:tacticSetId LIMIT:(Limits.getLimitQueryRows()-Limits.getQueryRows())]){
            
         fundIdSet.add(tacticFundLoop.ACCL__Fund__c);
         tacticidFundidMap.put(tacticFundLoop.ACCL__Tactic__c, tacticFundLoop.ACCL__Fund__c);   
        }
        
        map<id, ACCL__Fund__c> fundMap= new map<id, ACCL__Fund__c>([select ACCL__Amount__c, ACCL__Sales_Org__c, ACCL__Status__c, UL_Available_to_Spend__c, UL_Committed__c, UL_Total_Paid__c, UL_Uncommitted__c From ACCL__Fund__c Where id IN:fundIdSet LIMIT:(Limits.getLimitQueryRows()-Limits.getQueryRows()) For Update]);
        
        for(ACCL__Tactic_Fund__c tcticFudLoop:[Select ACCL__Fund__c, ACCL__Tactic__c from ACCL__Tactic_Fund__c where ACCL__Tactic__c In:tacticSetId]){
            
         mapFundRecord= fundMap.get(tcticFudLoop.ACCL__Fund__c);   
         tacticIdFundRecordMap.put(tcticFudLoop.ACCL__Tactic__c, mapFundRecord);   
        }
        
        Id fundTransactionTemplateId = Schema.SObjectType.ACCL__Fund_Transaction_Template__c.RecordTypeInfosByName.get('Promotion Transaction').RecordTypeId;
        
        map<string, ACCL__Fund_Transaction_Template__c> transactionTemplateMap = new map<string, ACCL__Fund_Transaction_Template__c>();
        
        for(ACCL__Fund_Transaction_Template__c transTempLoop:[select id, name, ACCL__Sales_Org__c, ACCL__Active__c, ACCL__Transaction_Type__c from ACCL__Fund_Transaction_Template__c where RecordTypeId=:fundTransactionTemplateId LIMIT:(Limits.getLimitQueryRows()-Limits.getQueryRows())])
         {
    
         transactionTemplateMap.put(transTempLoop.ACCL__Sales_Org__c, transTempLoop);
         } 
        
        
        
        for(id tacticIdLoop:tacticidFundidMap.keyset()){
            
        tacticRecord=tacticMap.get(tacticIdLoop);
        fundRecordId=tacticidFundidMap.get(tacticIdLoop);
        fundRecord=fundMap.get(fundRecordId);
            
            if(FORAPPROVAL_STATUS.equalsIgnoreCase(tacticRecord.UL_Promotion_Phase__c)){
            if(fundRecord.UL_Committed__c== null && fundRecord.UL_Uncommitted__c==null && FORAPPROVAL_STATUS.equalsIgnoreCase(tacticRecord.UL_Promotion_Phase__c)
                && fundRecord.ACCL__Amount__c>=tacticRecord.ACCL__Amount__c){
                
             fundRecord.UL_Uncommitted__c=tacticRecord.ACCL__Amount__c;
             fundRecord.UL_Available_to_Spend__c=fundRecord.ACCL__Amount__c-tacticRecord.ACCL__Amount__c;
            }
            else if(fundRecord.UL_Uncommitted__c!= null && FORAPPROVAL_STATUS.equalsIgnoreCase(tacticRecord.UL_Promotion_Phase__c) 
                    && fundRecord.UL_Available_to_Spend__c>=tacticRecord.ACCL__Amount__c){
                
             fundRecord.UL_Uncommitted__c=fundRecord.UL_Uncommitted__c+tacticRecord.ACCL__Amount__c;
             fundRecord.UL_Available_to_Spend__c=fundRecord.UL_Available_to_Spend__c-tacticRecord.ACCL__Amount__c;
            }
            else{
              
                tacticRecord.adderror(Label.UL_Tactic_Fund_Amount_Error);
            }
            }
            
            else if(REJECTED_STATUS.equalsIgnoreCase(tacticRecord.UL_Promotion_Phase__c)){
                
            fundRecord.UL_Uncommitted__c=fundRecord.UL_Uncommitted__c-tacticRecord.ACCL__Amount__c;
            fundRecord.UL_Available_to_Spend__c=fundRecord.UL_Available_to_Spend__c+tacticRecord.ACCL__Amount__c;          
            }
            
            
            else {
                if(tacticRecord != null && tacticRecord.UL_Promotion_Phase__c !=null  && APPROVED_STATUS.equalsIgnoreCase(tacticRecord.UL_Promotion_Phase__c)){
                
                    if(fundRecord.UL_Committed__c==Null){
                        
                     fundRecord.UL_Committed__c=tacticRecord.ACCL__Amount__c;
                     fundRecord.UL_Uncommitted__c=fundRecord.UL_Uncommitted__c-tacticRecord.ACCL__Amount__c;
                     fundRecord.UL_Total_Paid__c=tacticRecord.ACCL__Amount__c;
                    }
                
                    else{
                        
                     fundRecord.UL_Committed__c=fundRecord.UL_Committed__c+tacticRecord.ACCL__Amount__c;
                     fundRecord.UL_Uncommitted__c=fundRecord.UL_Uncommitted__c-tacticRecord.ACCL__Amount__c;
                     fundRecord.UL_Total_Paid__c=fundRecord.UL_Total_Paid__c+tacticRecord.ACCL__Amount__c;
                    }
                
                    if(fundidTacticAmountMap.containsKey(fundRecord.id)){
                     
                     mapTacticAmount=fundidTacticAmountMap.get(fundRecord.id);
                     mapTacticAmount=mapTacticAmount+tacticRecord.ACCL__Amount__c;   
                     fundidTacticAmountMap.put(fundRecord.id, mapTacticAmount);   
                    }
                    else{
                        
                     fundidTacticAmountMap.put(fundRecord.id, tacticRecord.ACCL__Amount__c);   
                    }
                }
            }
                        
          fundMap.put(fundRecord.Id, fundRecord);  
        }
        
        database.update(fundMap.values());
        
        for(id updatedFundLoop:fundidTacticAmountMap.keySet()){
            
         fundNewRecord=fundMap.get(updatedFundLoop);
         FundSalesOrg=fundNewRecord.ACCL__Sales_Org__c;
         
         transactionTemplateRecord=transactionTemplateMap.get(FundSalesOrg);
            if(transactionTemplateRecord.ACCL__Sales_Org__c.equalsIgnoreCase(FundSalesOrg)){
                
                ACCL__Fund_Transaction__c fundTransaction = (ACCL__Fund_Transaction__c) UL_Utility.getNewObject(Schema.SObjectType.ACCL__Fund_Transaction__c); //new ACCL__Fund_Transaction__c();
                fundTransaction.ACCL__Fund_Transaction_Template__c=transactionTemplateRecord.id;
                fundTransaction.ACCL__Amount__c=fundidTacticAmountMap.get(updatedFundLoop);
                fundTransaction.ACCL__Target_Fund__c=updatedFundLoop;
                
                fundTransactionList.add(fundTransaction);
                
            }   
        }

        
        database.insert(fundTransactionList);
        
        for(ACCL__Fund_Transaction__c fundTransactionLoop:fundTransactionList){
            
         ACCL__Fund_Transaction_Row__c fundTransactionRows= (ACCL__Fund_Transaction_Row__c)UL_Utility.getNewObject(Schema.SObjectType.ACCL__Fund_Transaction_Row__c); //new ACCL__Fund_Transaction_Row__c();
         fundTransactionRows.ACCL__Amount__c=(-1)*fundTransactionLoop.ACCL__Amount__c;
         fundTransactionRows.ACCL__Fund_Transaction__c=fundTransactionLoop.id;
         fundTransactionRows.ACCL__Target_Fund__c=fundTransactionLoop.ACCL__Target_Fund__c;
            
         fundTransactionRowsList.add(fundTransactionRows);   
        }
        
        database.insert(fundTransactionRowsList);
       }
     catch (Exception ex){
     UL_Utility.logError(ex, UserInfo.getUserId());
     } 
    }  
}