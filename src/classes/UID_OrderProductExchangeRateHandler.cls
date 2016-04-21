public class UID_OrderProductExchangeRateHandler {

    
    public void handleExchangeRate(List<UID_Order_Product__c> newOrderProductList) {
        /*List<UID_Order_Product__c> updatedOrderProductList = new List<UID_Order_Product__c>();
        for(UID_Order_Product__c ordProd : newOrderProductList){
            if((ordProd.UID_Exchange_Rate_Date__c != null)
                || ((ordProd.UID_Invoice_Value__c != null) 
                    && (ordProd.UID_Invoice_Value__c != 0))){
                	updatedOrderProductList.add(ordProd);
            }
           }
        if(!updatedOrderProductList.isEmpty())
        //Supports only passing of list to Currency Utility class
    	List<UID_Order_Product__c> sObjectList = UL_CurrencyConversionUtility.relateExchangeRates(updatedOrderProductList); */
        List<UID_Order_Product__c> sObjectList = UL_CurrencyConversionUtility.relateExchangeRates(newOrderProductList);
    }
    
    public void handleExchangeRate(Map<Id, UID_Order_Product__c> newOrderProductMap, 
                               Map<Id, UID_Order_Product__c> oldOrderProductMap) {
                                   
        /*List<UID_Order_Product__c> updatedOrderProductList = new List<UID_Order_Product__c>();
        for(UID_Order_Product__c ordProd : newOrderProductMap.values()){
            if((ordProd.UID_Exchange_Rate_Date__c != oldOrderProductMap.get(ordProd.Id).UID_Exchange_Rate_Date__c)
                || (ordProd.UID_Invoice_Value__c != oldOrderProductMap.get(ordProd.Id).UID_Invoice_Value__c)){
                	updatedOrderProductList.add(ordProd);
            }
           }
        if(!updatedOrderProductList.isEmpty())
        List<UID_Order_Product__c> sObjectList = UL_CurrencyConversionUtility.relateExchangeRates(updatedOrderProductList);*/
        
        //Supports only passing of list to Currency Utility class
    	List<UID_Order_Product__c> sObjectList = UL_CurrencyConversionUtility.relateExchangeRates(newOrderProductMap.values());
    	
        //try {
        	//update sObjectList;                               
        //} catch(DmlException e) {
          //  e.getCause();            
        //}
        
        //TODO: Create logic for update that will only call Currency Utility class when there's a change in Invoice Value
        //TODO: Invoice Value should have a value in order for calling of Currency Utility class
    }
}