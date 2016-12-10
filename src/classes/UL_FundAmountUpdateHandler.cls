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


public class UL_FundAmountUpdateHandler {

/*******************************************************************
Purpose: Update the COMITTED, UNCOMITTED, AVAILABLE TO SPEND and TOTAL SPENT field on the Fund record when the status of the Promotion related to the Fund is changed. 
Version 1.0
Parameters: trigger.new(list of type ACSFUL001__Fund_Transaction__c)
Returns: N/A
Throws N/A
********************************************************************/
    
    public static void FundAmountUpdate(list<ACSFUL001__Tactic__c> tacticValueList){
     
        set<id> tacticSetId=new set<id>();
        set<id> fundIdSet=new set<id>();
        map<id, ACSFUL001__Tactic__c> tacticMap= new map<id, ACSFUL001__Tactic__c>();
        //map<id, ACSFUL001__Fund__c> fundMap= new map<id, ACSFUL001__Fund__c>();
        list<ACSFUL001__Tactic_Fund__c> tacticFundList= new list<ACSFUL001__Tactic_Fund__c>();
        map<id, id> tacticidFundidMap= new map<id, id>();
        map<id, ACSFUL001__Fund__c> tacticIdFundRecordMap= new map<id, ACSFUL001__Fund__c>();
        ACSFUL001__Fund__c mapFundRecord;
        ACSFUL001__Tactic__c tacticRecord;
        ACSFUL001__Fund__c fundRecord;
        id fundRecordId;
        map<id, double> fundidTacticAmountMap= new map<id, double>();
        double mapTacticAmount;
        ACSFUL001__Fund__c fundNewRecord;
        string FundSalesOrg;
        ACSFUL001__Transaction_Template__c transactionTemplateRecord;
        list<ACSFUL001__Fund_Transaction__c> fundTransactionList = new list<ACSFUL001__Fund_Transaction__c>();
        list<ACSFUL001__Fund_Transaction_Row__c> fundTransactionRowsList= new list<ACSFUL001__Fund_Transaction_Row__c>();
        
        
        for(ACSFUL001__Tactic__c tacticLoop:tacticValueList){
            
         tacticSetId.add(tacticLoop.id);
         tacticMap.put(tacticLoop.id, tacticLoop);
        }
        
        tacticFundList=[Select  ACSFUL001__Fund__c, ACSFUL001__Tactic__c from ACSFUL001__Tactic_Fund__c where ACSFUL001__Tactic__c In:tacticSetId];
        
        for(ACSFUL001__Tactic_Fund__c tacticFundLoop:tacticFundList){
            
         fundIdSet.add(tacticFundLoop.ACSFUL001__Fund__c);
         tacticidFundidMap.put(tacticFundLoop.ACSFUL001__Tactic__c, tacticFundLoop.ACSFUL001__Fund__c);   
        }
        
        map<id, ACSFUL001__Fund__c> fundMap= new map<id, ACSFUL001__Fund__c>([select ACSFUL001__Amount__c, ACSFUL001__Sales_Org__c, ACSFUL001__Status__c, UL_Available_to_Spend__c, UL_Committed__c, UL_Total_Paid__c, UL_Uncommitted__c From ACSFUL001__Fund__c Where id IN:fundIdSet For Update]);
        
        for(ACSFUL001__Tactic_Fund__c tcticFudLoop:tacticFundList){
            
         mapFundRecord= fundMap.get(tcticFudLoop.ACSFUL001__Fund__c);   
         tacticIdFundRecordMap.put(tcticFudLoop.ACSFUL001__Tactic__c, mapFundRecord);   
        }
        
        Id fundTransactionTemplateId = Schema.SObjectType.ACSFUL001__Transaction_Template__c.RecordTypeInfosByName.get('Promotion Transaction').RecordTypeId;
        
        map<string, ACSFUL001__Transaction_Template__c> transactionTemplateMap = new map<string, ACSFUL001__Transaction_Template__c>();
        
        for(ACSFUL001__Transaction_Template__c transTempLoop:[select id, name, ACSFUL001__Sales_Org__c, ACSFUL001__Active__c, ACSFUL001__Transaction_Type__c from ACSFUL001__Transaction_Template__c where RecordTypeId=:fundTransactionTemplateId])
         {
    
         transactionTemplateMap.put(transTempLoop.ACSFUL001__Sales_Org__c, transTempLoop);
         } 
        
        
        
        for(id tacticIdLoop:tacticidFundidMap.keyset()){
            
        tacticRecord=tacticMap.get(tacticIdLoop);
        fundRecordId=tacticidFundidMap.get(tacticIdLoop);
        fundRecord=fundMap.get(fundRecordId);
            
            if(tacticRecord.UL_Promotion_Phase__c=='ForApproval'){
            if(fundRecord.UL_Committed__c==NUll && fundRecord.UL_Uncommitted__c==NUll && tacticRecord.UL_Promotion_Phase__c=='ForApproval'
                && fundRecord.ACSFUL001__Amount__c>=tacticRecord.ACSFUL001__Amount__c){
                
             fundRecord.UL_Uncommitted__c=tacticRecord.ACSFUL001__Amount__c;
             fundRecord.UL_Available_to_Spend__c=fundRecord.ACSFUL001__Amount__c-tacticRecord.ACSFUL001__Amount__c;
            }
            else if(fundRecord.UL_Uncommitted__c!=NUll && tacticRecord.UL_Promotion_Phase__c=='ForApproval' 
                    && fundRecord.UL_Available_to_Spend__c>=tacticRecord.ACSFUL001__Amount__c){
                
             fundRecord.UL_Uncommitted__c=fundRecord.UL_Uncommitted__c+tacticRecord.ACSFUL001__Amount__c;
             fundRecord.UL_Available_to_Spend__c=fundRecord.UL_Available_to_Spend__c-tacticRecord.ACSFUL001__Amount__c;
            }
            else{
              
                tacticRecord.adderror('Tactic Amount is more than the available amount in the Fund');
            }
            }
            
            else if(tacticRecord.UL_Promotion_Phase__c=='Rejected'){
                
            fundRecord.UL_Uncommitted__c=fundRecord.UL_Uncommitted__c-tacticRecord.ACSFUL001__Amount__c;
            fundRecord.UL_Available_to_Spend__c=fundRecord.UL_Available_to_Spend__c+tacticRecord.ACSFUL001__Amount__c;          
            }
            
            
            else if(tacticRecord.UL_Promotion_Phase__c=='Approved'){
                
                if(fundRecord.UL_Committed__c==Null){
                    
                 fundRecord.UL_Committed__c=tacticRecord.ACSFUL001__Amount__c;
                 fundRecord.UL_Uncommitted__c=fundRecord.UL_Uncommitted__c-tacticRecord.ACSFUL001__Amount__c;
                 fundRecord.UL_Total_Paid__c=tacticRecord.ACSFUL001__Amount__c;
                }
                
                else{
                    
                 fundRecord.UL_Committed__c=fundRecord.UL_Committed__c+tacticRecord.ACSFUL001__Amount__c;
                 fundRecord.UL_Uncommitted__c=fundRecord.UL_Uncommitted__c-tacticRecord.ACSFUL001__Amount__c;
                 fundRecord.UL_Total_Paid__c=fundRecord.UL_Total_Paid__c+tacticRecord.ACSFUL001__Amount__c;
                }
                
                if(fundidTacticAmountMap.containsKey(fundRecord.id)){
                 
                 mapTacticAmount=fundidTacticAmountMap.get(fundRecord.id);
                 mapTacticAmount=mapTacticAmount+tacticRecord.ACSFUL001__Amount__c;   
                 fundidTacticAmountMap.put(fundRecord.id, mapTacticAmount);   
                }
                else{
                    
                 fundidTacticAmountMap.put(fundRecord.id, tacticRecord.ACSFUL001__Amount__c);   
                }
            }
            
                        
          fundMap.put(fundRecord.Id, fundRecord);  
        }
        
        database.update(fundMap.values());
        
        for(id updatedFundLoop:fundidTacticAmountMap.keySet()){
            
         fundNewRecord=fundMap.get(updatedFundLoop);
         FundSalesOrg=fundNewRecord.ACSFUL001__Sales_Org__c;
         
         transactionTemplateRecord=transactionTemplateMap.get(FundSalesOrg);
            if(transactionTemplateRecord.ACSFUL001__Sales_Org__c.equalsIgnoreCase(FundSalesOrg)){
                
                ACSFUL001__Fund_Transaction__c fundTransaction= new ACSFUL001__Fund_Transaction__c();
                fundTransaction.ACSFUL001__Transaction_Template__c=transactionTemplateRecord.id;
                fundTransaction.ACSFUL001__Amount__c=fundidTacticAmountMap.get(updatedFundLoop);
                fundTransaction.ACSFUL001__Target_Fund__c=updatedFundLoop;
                
                fundTransactionList.add(fundTransaction);
                
            }   
        }

        
        database.insert(fundTransactionList);
        
        for(ACSFUL001__Fund_Transaction__c fundTransactionLoop:fundTransactionList){
            
         ACSFUL001__Fund_Transaction_Row__c fundTransactionRows=new ACSFUL001__Fund_Transaction_Row__c();
         fundTransactionRows.ACSFUL001__Amount__c=(-1)*fundTransactionLoop.ACSFUL001__Amount__c;
         fundTransactionRows.ACSFUL001__Fund_Transaction__c=fundTransactionLoop.id;
         fundTransactionRows.ACSFUL001__Target_Fund__c=fundTransactionLoop.ACSFUL001__Target_Fund__c;
            
         fundTransactionRowsList.add(fundTransactionRows);   
        }
        
        database.insert(fundTransactionRowsList);
    }  
       
}