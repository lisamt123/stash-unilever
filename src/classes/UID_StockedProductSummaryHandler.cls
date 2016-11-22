public with sharing class UID_StockedProductSummaryHandler {
    
    public void onBeforeUpdate(Map<Id, UID_Stocked_Product_Summary__c> newStockedProductSummaryMap , Map<Id, UID_Stocked_Product_Summary__c> oldStockedProductSummaryMap){
        UID_StockedProductSummaryTriggerHelper.computeStockCover(newStockedProductSummaryMap.values(), oldStockedProductSummaryMap);
    }
}