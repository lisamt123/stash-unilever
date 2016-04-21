public class UID_OrderExchangeRateHandler {
                                                //june 2015         //march 2016
    public static void handleUpdate(List<Order> newList, Map<Id, Order> oldMap) {
        Map<Id, Order> orderMap = new Map<Id, Order>();
                
        for(Order ord : newList) {
            if(ord.EffectiveDate != oldMap.get(ord.Id).EffectiveDate) {
                orderMap.put(ord.Id, ord);                
            }
        }
        
        updateUIDOrderProduct(orderMap);
    }

    //@future
    private static void updateUIDOrderProduct(Map<Id, Order> orderMap) {
        List<UID_Order_Product__c> ordProductList = new List<UID_Order_Product__c>();
        
        for(UID_Order_Product__c ordProd : [SELECT Id, UID_Order__c
                                            FROM UID_Order_Product__c
                                            WHERE UID_Order__c In : orderMap.keySet()]) {
            ordProd.Id = ordProd.Id;
            //ordProd.UID_Effective_Date__c = orderMap.get(ordProd.UID_Order__c).EffectiveDate;
            ordProductList.add(ordProd);
        }
        
        Update ordProductList;
    } 
}