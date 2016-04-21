public class UID_StockedProductSummExRateHandler {
	
    public void handleExchangeRate(List<UID_Stocked_Product_Summary__c> stockedProductSummaryList) {
        //Supports only passing of list to Currency Utility class
    	List<UID_Stocked_Product_Summary__c> newList = UL_CurrencyConversionUtility.relateExchangeRates(stockedProductSummaryList);
    }
    
    public void handleExchangeRate(Map<Id, UID_Stocked_Product_Summary__c> newOrderProductMap, 
                               Map<Id, UID_Stocked_Product_Summary__c> oldOrderProductMap) {
        //Supports only passing of list to Currency Utility class
    	List<UID_Stocked_Product_Summary__c> newList = UL_CurrencyConversionUtility.relateExchangeRates(newOrderProductMap.values());
    }
}