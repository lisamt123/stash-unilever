/************************************************************************************************************
 Name: UID_StockCoverTriggerHelperQueue() 
 Copyright © 2016 Salesforce 
 ============================================================================================================ 
 ============================================================================================================ 
 Purpose: 
 1. Set the Stock Cover flag to TRUE in Stocked Product Summary to trigger the Stock Cover calculation using 
 			queueable implementation.
 ============================================================================================================ 
 ============================================================================================================ 
 History 
 --------------------------------------------------------- 
 VERSION    AUTHOR      DATE            DETAIL Description 
 1.0        Barcenas	16/05/2015 :    INITIAL DEVELOPMENT for Stock Cover Calculation
 ************************************************************************************************************/
public with sharing class UID_StockCoverTriggerHelperQueue implements Queueable {
    
    Set<Id> stockedProdIds;
    
    public UID_StockCoverTriggerHelperQueue(Set<Id> stockedProdIds ) {
        this.stockedProdIds = stockedProdIds;
    }
    
    
    public void execute(QueueableContext context) { 
    	//stockDetails will hold the chunk of records to be updated
    	List <UID_Stocked_Product_Summary__c> stockDetails = new List <UID_Stocked_Product_Summary__c>();
        
        //Loop to update Stock Cover flag of Stocked Product Summary by 10
        for(UID_Stocked_Product_Summary__c sPS : [Select Id, 
                                                    UID_Stock_Cover_Calculation_Flag__c
                                                	From UID_Stocked_Product_Summary__c 
                                                	Where UID_Stocked_Product__c IN : stockedProdIds
                                                	AND UID_Stock_Cover_Calculation_Flag__c = false
                                                	LIMIT 10]){
           						 
           						 sPS.UID_Stock_Cover_Calculation_Flag__c = true;
            					 stockDetails.add(sPS);
		}
		    
        if(!stockDetails.isEmpty()){
        	update stockDetails;

        }
        
        //Check for existing records in Stocked Product Summary that needs to be set to True.
		List<UID_Stocked_Product_Summary__c> stockDetailsFalse = [Select Id, 
                                                    UID_Stock_Cover_Calculation_Flag__c
                                                	From UID_Stocked_Product_Summary__c 
                                                	Where UID_Stocked_Product__c IN : stockedProdIds
                                                	AND UID_Stock_Cover_Calculation_Flag__c = false];
        
		Set<Id> stockedProdSumIds = (new Map<Id,UID_Stocked_Product_Summary__c>(stockDetailsFalse)).keySet();  
		
		//If records still exist as above checking, this needs to call again the queueable class.
		if(!stockedProdSumIds.isEmpty() && !Test.isRunningTest()){
        	System.enqueueJob(new UID_StockCoverTriggerHelperQueue(stockedProdIds));
		}
    }
}