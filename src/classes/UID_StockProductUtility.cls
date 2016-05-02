public with sharing class UID_StockProductUtility {
    
    public Static String getReportMonth(Date sourceDate, Integer numberOfMonths){
        
        Date priorDate = sourceDate.AddMonths(numberOfMonths);
        String dateMonth = String.valueOf(priorDate.month());
        String dateYear = String.valueOf(priorDate.Year());
        String  resultReportMonth = dateMonth + '-' + dateYear;
        
        return resultReportMonth;
    }
    
    public static Map <String, List <UID_Stocked_Product_Summary__c>> getStockedProducts(Set <String> materialID, Set <Id> accountID, Set <String> previousMonth) {
        Map <String, List <UID_Stocked_Product_Summary__c>> openingStockMap = new Map <String, List<UID_Stocked_Product_Summary__c >>();
        
        //Store Per Material Total Opening Stock in Map. MaterialID + Account + Report Date
        for (UID_Stocked_Product_Summary__c os : [SELECT UID_Material_ID__c, 
        											UID_Avail_Quantity__c, 
        											UID_Net_Quantity__c, 
        											UID_In_Quantity__c, 
        											UID_Stocked_Product__r.UID_Distributor__c, 
        											UID_Sales_Date__c, 
        											UID_Stocked_Product__r.UID_Report_Date__c
        										  FROM UID_Stocked_Product_Summary__c 
        										  WHERE UID_Material_ID__c IN : materialID 
        										  AND UID_Stocked_Product__r.UID_Distributor__c IN : accountID 
        										  AND UID_Sales_Date__c IN : previousMonth]) {
            String openingMapID = os.UID_Material_ID__c + os.UID_Stocked_Product__r.UID_Distributor__c + os.UID_Sales_Date__c;
            if(openingStockMap.containsKey(openingMapID)) {
                openingStockMap.get(openingMapID).add(os);
            }
            else {
                List <UID_Stocked_Product_Summary__c> openingList= new List <UID_Stocked_Product_Summary__c >();
                openingList.add(os);
                openingStockMap.put(openingMapID, openingList);
            }   
            
        }        
        return openingStockMap;
    }
    
    public static Map <String, List <UID_Order_Product__c>> getSales(Set <String> materialID, Set <Id> accountID, Set <String> setMonths, String name) {
        
        Map <String, List <UID_Order_Product__c>> salesMap = new Map <String, List <UID_Order_Product__c>>();
        
        //JB 08/03/2016 BR1.4: Added the UID_Invoice_Value__c in the Select Statement
        for(UID_Order_Product__c orderSale : [Select UID_Material_ID__c, 
                                                     UID_Order_Quantity__c, 
                                                     UID_Order__r.UID_Distributor__c, 
                                                     UID_Sales_Date__c, 
                                                     UID_Order__r.UID_Report_Date__c,
                                                     UID_Invoice_Value__c
                                                From UID_Order_Product__c 
                                                WHERE UID_Material_ID__c IN : materialID 
                                                AND UID_Order__r.UID_Distributor__r.Id IN : accountID 
                                                AND UID_Sales_Date__c IN : setMonths 
                                                AND UID_Order__r.RecordType.Name =: name]){
            String mapID = orderSale.UID_Material_ID__c + orderSale.UID_Order__r.UID_Distributor__c + orderSale.UID_Sales_Date__c;
            if(salesMap.containsKey(mapID)) {
                salesMap.get(mapID).add(orderSale);
            }
            else {
                List <UID_Order_Product__c> orderList= new List <UID_Order_Product__c>();
                orderList.add(orderSale);
                salesMap.put(mapID, orderList);
            }
        }
        return salesMap;
    }
    
    public static Decimal setTotalStock(String openingStockMapKey, Map <String, List <UID_Stocked_Product_Summary__c>> openingStockMap, boolean isOpeningStock) {
        Decimal totalStock = 0;
        if(openingStockMap.get(openingStockMapKey) != NULL) {
                for(UID_Stocked_Product_Summary__c ci: openingStockMap.get(openingStockMapKey)){
                    if(isOpeningStock) {
                        //totalStock = totalStock + ci.UID_Avail_Quantity__c;
                        totalStock = totalStock + ci.UID_Net_Quantity__c;                        
                    } else {
                        totalStock = totalStock + ci.UID_In_Quantity__c;
                    }                    
                }
            }
        return totalStock;
    }    
    
    public static Decimal setTotalOrderQuantity(String salesMapKey, Map <String, List<UID_Order_Product__c>> salesMap) {
        Decimal totalOrderQuantity = 0;
        if(salesMap.get(salesMapKey) != NULL) {
            for(UID_Order_Product__c ordItem : salesMap.get(salesMapKey)){
                totalOrderQuantity = totalOrderQuantity + ordItem.UID_Order_Quantity__c;                    
            }
        }
        return totalOrderQuantity;
        
    }
    
    public static Decimal setTotalSecondaryInvoice(String salesMapKey, Map <String, List<UID_Order_Product__c>> salesMap) {
        Decimal totalSecondaryInvoice = 0;
        if(salesMap.get(salesMapKey) != NULL) {
            for(UID_Order_Product__c oi : salesMap.get(salesMapKey)){
                totalSecondaryInvoice = totalSecondaryInvoice + oi.UID_Invoice_Value__c;                    
            }
        }
        return totalSecondaryInvoice;
        
    } 
}