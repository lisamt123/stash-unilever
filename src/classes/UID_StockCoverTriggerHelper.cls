/************************************************************************************************************
 Name: UID_StockCoverTriggerHelper() 
 Copyright © 2015 Salesforce 
 ====================================================== 
 ====================================================== 
 Purpose: 
 1. Calculate the Stock Cover per Material Id for each Processed Account
 ====================================================== 
 ====================================================== 
 History 
 ------- 
 VERSION    AUTHOR      DATE            DETAIL Description 
 1.0        Bolima      13/12/2015 :    INITIAL DEVELOPMENT for Stock Cover Calculation
 1.1        Barcenas    08/03/2016 :    Updated code to include the computation 
                                            of the Summarized Invoice Value field of Stock Product Summary object 
                                            taken from summarized Invoice Value field of UID Order Product object.
 1.2        Barcenas    12/05/2016 :    Updated code to transfer the trigger on the Stocked Product Summary and 
 											have the update passed to Queueable class
 *************************************************************************************************************/
public with sharing class UID_StockCoverTriggerHelper {
    
    public static void computeStockCover(List<UID_Stocked_Product__c> newStockedProduct , Map<Id, UID_Stocked_Product__c> oldStockedProduct){
        
        Set <Id> stockedProdIds = new Set <Id>();
        
        for (UID_Stocked_Product__c n : newStockedProduct) {
             if (n.UID_Stock_Cover_Calculation_Flag__c && !oldStockedProduct.get(n.Id).UID_Stock_Cover_Calculation_Flag__c) {
                 stockedProdIds.add(n.Id);
             }
        }  
        
       if(!stockedProdIds.isEmpty()){
        	ID jobID = System.enqueueJob(new UID_StockCoverTriggerHelperQueue(stockedProdIds));
       }
    }
    
    public static void calculateRanking(List<UID_Stocked_Product__c> newStockedProduct , Map<Id, UID_Stocked_Product__c> oldStockedProduct){
        
        Set <Id> stockedProdIds = new Set <Id>();
        
        for (UID_Stocked_Product__c n : newStockedProduct) {
             if (n.UID_Summarized_Invoice_Ranking_Flag__c && !oldStockedProduct.get(n.Id).UID_Summarized_Invoice_Ranking_Flag__c){
             	stockedProdIds.add(n.Id);
             }
        }  
        
       if(!stockedProdIds.isEmpty()){
        	ID jobID = System.enqueueJob(new UID_StockCoverTriggerHelperRankingQueue(stockedProdIds));
       }
    }
          
}