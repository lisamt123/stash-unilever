/**********************************************************************
 Name: UID_StockCoverTriggerHandler() 
 Copyright © 2015 Salesforce 
 ====================================================== 
 ====================================================== 
 Purpose: 
 1. Trigger handler for Stock Cover Trigger
 ====================================================== 
 ====================================================== 
 History 
 ------- 
 VERSION AUTHOR DATE DETAIL Description 
 1.0 Bolima 13/12/2015 INITIAL DEVELOPMENT Trigger handler for Stock Cover
 ***********************************************************************/
public class UID_StockCoverTriggerHandler {
    
/******************************************************************* 

   Purpose: trigger handler for before update
   Parameters: Map<Id, UID_Stocked_Product__c> newStockedProductMap, Map<Id, UID_Stocked_Product__c> oldStockedProductMap
   Returns: void
  ********************************************************************/     
    //before update
    public void onAfterUpdate(Map<Id, UID_Stocked_Product__c> newStockedProductMap , Map<Id, UID_Stocked_Product__c> oldStockedProductMap){
        UID_StockCoverTriggerHelper.computeStockCover(newStockedProductMap.values(), oldStockedProductMap);
        UID_StockCoverTriggerHelper.calculateRanking(newStockedProductMap.values(), oldStockedProductMap);
    }
    
}