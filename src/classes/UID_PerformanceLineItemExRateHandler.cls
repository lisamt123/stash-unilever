public class UID_PerformanceLineItemExRateHandler {

        public void handleExchangeRate(Map<Id, UID_Performance_Line_Item__c> newPerformanceLineItemMap, 
                               Map<Id, UID_Performance_Line_Item__c> oldPerformanceLineItemMap) {
        //Supports only passing of list to Currency Utility class
        //List newPerformanceLineItemMap
        //ID	ExRate	EURID	USDID
        //0001
        //0002
        //--> relateExchangeRates1
        //ID	ExRate	EURID	USDID	
        //0001	ABC
        //0002	DEF
        //--> convertCurrencyAmounts
        //ID	ExRate	EURID	USDID
        //0001	ABC		1		1.2
        //0002	DEF		1		2
        //
    	List<UID_Performance_Line_Item__c> pLIList = UL_CurrencyConversionUtility.relateExchangeRates(newPerformanceLineItemMap.values());
        UL_CurrencyConversionUtility.convertCurrencyAmounts(pLIList);
    }
    
    public void handleExchangeRate1(List<UID_Performance_Line_Item__c> newList) {
        
    	List<UID_Performance_Line_Item__c> pLIList = UL_CurrencyConversionUtility.relateExchangeRates(newList);
        UL_CurrencyConversionUtility.convertCurrencyAmounts(pLIList);
    }
}