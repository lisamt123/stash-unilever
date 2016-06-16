/**********************************************************************
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
<<<<<<< HEAD
 VERSION AUTHOR DATE DETAIL Description 
 1.0 Bolima 13/12/2015 INITIAL DEVELOPMENT for Stock Cover Calculation
 ***********************************************************************/
public with sharing class UID_StockCoverTriggerHelper {
    
    private static final String SECONDARY_SALES_RECORDTYPE_NAME = 'Secondary Sales';
    
    //private static Set <Id> stockedProdIds; 
    
    /******************************************************************* 
    Purpose: Populate Report Month of Order
    Parameters: List<Orders> new Orders
    Returns: void
    ********************************************************************/    
  
=======
 VERSION    AUTHOR      DATE            DETAIL Description 
 1.0        Bolima      13/12/2015 :    INITIAL DEVELOPMENT for Stock Cover Calculation
 1.1        Barcenas    08/03/2016 :    Updated code to include the computation 
                                            of the Summarized Invoice Value field of Stock Product Summary object 
                                            taken from summarized Invoice Value field of UID Order Product object.
 1.2        Barcenas    12/05/2016 :    Updated code to transfer the trigger on the Stocked Product Summary and 
 											have the update passed to Queueable class
 *************************************************************************************************************/
public with sharing class UID_StockCoverTriggerHelper {
    
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
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
    
<<<<<<< HEAD
    @future
    public static void calculateStockCover(Set <Id> stockedProdIds) { 
    //public static void calculateStockCover() { 
        //Variable Declations    
        Map <String, List <UID_Stocked_Product_Summary__c>> openingStockMap = new Map <String, List<UID_Stocked_Product_Summary__c >>();
        Map <String, List <UID_Order_Product__c>> last3MonthMap = new Map <String, List <UID_Order_Product__c>>();
        Map <String, List <UID_Order_Product__c>> primarySalesMap = new Map <String, List <UID_Order_Product__c>>();
        Map <String, List <UID_Order_Product__c>> secondarySalesMap = new Map <String, List <UID_Order_Product__c>>();
        
        Map <String, List <UID_Stocked_Product_Summary__c>> inQuantityStockMap = new Map <String, List<UID_Stocked_Product_Summary__c >>();
        
        //Fetch All Stocked Product Details
        List <UID_Stocked_Product_Summary__c> stockDetails = new List <UID_Stocked_Product_Summary__c>();
        
        //Store Stored Product Account Id
        Set <Id> accountID = new Set <Id> ();
        //Store Stored Product Material Id
        Set <String> materialID = new Set <String> ();
        //Store Previous Month Sales Date
        Set <String> previousMonth = new Set <String> ();
        //Store Current Month Sales Date
        Set <String> currentMonth = new Set <String> ();
        //Store Last Three (3) Sales Date
        Set <String> last3Months = new Set <String> ();
        
        
        for (UID_Stocked_Product_Summary__c s : [Select Id, UID_Material_ID__c, UID_Stock_Cover__c, UID_Stocked_Product__r.UID_Distributor__c, UID_Stocked_Product__r.UID_Start_Date__c,
        UID_Stocked_Product__r.UID_End_Date__c, UID_Sales_Date__c, UID_Stocked_Product__r.UID_Report_Date__c From UID_Stocked_Product_Summary__c Where UID_Stocked_Product__c IN : stockedProdIds]) {
            accountID.add(s.UID_Stocked_Product__r.UID_Distributor__c);
            materialID.add(s.UID_Material_ID__c);
            currentMonth.add(getReportMonth(s.UID_Stocked_Product__r.UID_Start_Date__c, 0));
            previousMonth.add(getReportMonth(s.UID_Stocked_Product__r.UID_Start_Date__c,-1));
            last3Months.add(getReportMonth(s.UID_Stocked_Product__r.UID_Start_Date__c,-3));
            last3Months.add(getReportMonth(s.UID_Stocked_Product__r.UID_Start_Date__c,-2));
            last3Months.add(getReportMonth(s.UID_Stocked_Product__r.UID_Start_Date__c,-1));
            stockDetails.add(s);
        }
        
        //Store Per Material Total Opening Stock in Map. MaterialID + Account + Report Date
        openingStockMap = getStockedProducts(materialID, accountID, previousMonth);
        
        //Store Per Material Total In Quantity Stock in Map. MaterialID + Account + Report Date
        inQuantityStockMap = getStockedProducts(materialID, accountID, currentMonth);
        
                
        
        
        //Store Per Material Total Quantity for Secondary Sales in Map. MaterialID + Account + Report Date
        secondarySalesMap = getSales(materialID, accountID, currentMonth, SECONDARY_SALES_RECORDTYPE_NAME);
                
        //Store Per Material Total Quantity for the Last 3 Months in Map. MaterialID + Account + Report Date
        last3MonthMap = getLast3Month(materialID, accountID, last3Months);
                          
         /* Stock Cover Formula Version 1.0
         * 
         * A:Opening Stock of the month = Closing stock for last month (M-1)
         * B:Shipments received in same calendar month = Primary Sales for this month(M)
         * C:Sales for the month = Secondary Sales for this month (M) from Distributor 
         * 
         * D:Closing Stock = A+B-C
         * E:Last 3 month Rolling Avg Sales less DT Margin =  (Secondary Sales in M-1+  Secondary Sales in M-2 +Secondary Sales in M-3)/3
         * F:Stock Cover = (D/E) * 30
         */
        
        for (UID_Stocked_Product_Summary__c sd : stockDetails) {
            Decimal totalOpening = 0;
            Decimal totalPrimary = 0;
            Decimal totalSecondary = 0;
            Decimal month1st = 0;
            Decimal month2nd = 0;
            Decimal month3rd = 0;
            
            //A:Opening Stock of the month = Closing stock for last month (M-1)
            String openingStockMapKey = sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, -1);
            totalOpening = setTotalStock(openingStockMapKey, openingStockMap, true);
            
            //B: Incoming Qty from Distributor Inventory Report
            String inQuantityMapKey = sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, 0);
            totalPrimary = setTotalStock(inQuantityMapKey, inQuantityStockMap, false);
            
            
            //C:Sales for the month = Secondary Sales for this month (M) from Distributor 
            String secondarySalesMapKey = sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, 0);
            totalSecondary = setTotal(secondarySalesMapKey, secondarySalesMap);
            
            //D:Closing Stock = A+B-C
            Decimal totalClosing = (totalOpening + totalPrimary) - totalSecondary;
            String last3MonthMapKey1 = sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, -1);
            month1st = setMonth(last3MonthMapKey1, last3MonthMap);
                        
            String last3MonthMapKey2 = sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, -2);
            month2nd = setMonth(last3MonthMapKey2, last3MonthMap);
            
            String last3MonthMap3= sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, -3);
            month3rd = setMonth(last3MonthMap3, last3MonthMap);
            
            //E:Last 3 month Rolling Avg Sales less DT Margin =  (Secondary Sales in M-1+  Secondary Sales in M-2 +Secondary Sales in M-3)/3
            Decimal totallast3Mont = (month1st + month2nd + month3rd) / 3;
            //F:Stock Cover = (D/E) * 30
            
            Decimal stockCover = 0;
            if(totallast3Mont == 0) {
                stockCover = totalClosing;
            } else {
                stockCover = (totalClosing / totallast3Mont) * 30;
            }
            
            sd.UID_Stock_Cover__c = stockCover;
                        
        }
        
        update stockDetails;
    }
    
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
        for (UID_Stocked_Product_Summary__c os : [Select UID_Material_ID__c, UID_Avail_Quantity__c, UID_Net_Quantity__c, UID_In_Quantity__c, UID_Stocked_Product__r.UID_Distributor__c, UID_Sales_Date__c, UID_Stocked_Product__r.UID_Report_Date__c
        From UID_Stocked_Product_Summary__c Where UID_Material_ID__c IN : materialID AND UID_Stocked_Product__r.UID_Distributor__c IN : accountID AND UID_Sales_Date__c IN : previousMonth])
        {
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
    
    public static Map <String, List <UID_Order_Product__c>> getSales(Set <String> materialID, Set <Id> accountID, Set <String> currentMonth, String name) {
        
        Map <String, List <UID_Order_Product__c>> salesMap = new Map <String, List <UID_Order_Product__c>>();
        for(UID_Order_Product__c orderSale : [Select UID_Material_ID__c, UID_Order_Quantity__c, UID_Order__r.UID_Distributor__c, UID_Sales_Date__c, UID_Order__r.UID_Report_Date__c
        From UID_Order_Product__c WHERE UID_Material_ID__c IN : materialID AND UID_Order__r.UID_Distributor__r.Id IN : accountID AND UID_Sales_Date__c IN : currentMonth AND UID_Order__r.RecordType.Name =: name])
        {
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
    
    public static Map <String, List <UID_Order_Product__c>> getLast3Month(Set <String> materialID, Set <Id> accountID, Set <String> last3Months) {
        Map <String, List <UID_Order_Product__c>> last3MonthMap = new Map <String, List <UID_Order_Product__c>>();
        
        //Store Per Material Total Quantity for the Last 3 Months in Map. MaterialID + Account + Report Date
        for (UID_Order_Product__c lm : [Select UID_Material_ID__c, UID_Order_Quantity__c, UID_Order__r.UID_Distributor__c, UID_Sales_Date__c, UID_Order__r.UID_Report_Date__c
                             From UID_Order_Product__c WHERE UID_Material_ID__c IN : materialID AND UID_Order__r.UID_Distributor__c IN : accountID AND UID_Sales_Date__c IN : last3Months AND UID_Order__r.RecordType.Name =: SECONDARY_SALES_RECORDTYPE_NAME])
        {
            String last3MapID = lm.UID_Material_ID__c + lm.UID_Order__r.UID_Distributor__c + lm.UID_Sales_Date__c;
            if(last3MonthMap.containsKey(last3MapID )) {
                last3MonthMap.get(last3MapID).add(lm);
            }
            else{
                List <UID_Order_Product__c> last3List= new List <UID_Order_Product__c>();
                last3List.add(lm);
                last3MonthMap.put(last3MapID, last3List);
            }     
        }
        return last3MonthMap;
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
    
    public static Decimal setTotal(String salesMapKey, Map <String, List<UID_Order_Product__c>> salesMap) {
        Decimal totalPrimary = 0;
        if(salesMap.get(salesMapKey) != NULL) {
            for(UID_Order_Product__c ordItem : salesMap.get(salesMapKey)){
                totalPrimary = totalPrimary + ordItem.UID_Order_Quantity__c;                    
            }
        }
        return totalPrimary;
        
    }
    
    public static Decimal setMonth(String last3MonthMapKey, Map <String, List <UID_Order_Product__c>> last3MonthMap) {
        Decimal month = 0;
        if(last3MonthMap.get(last3MonthMapKey) != NULL) {
                for(UID_Order_Product__c ordItem: last3MonthMap.get(last3MonthMapKey)){
                    month = month  + ordItem.UID_Order_Quantity__c;                    
                }
            }
		return month;		
=======
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
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
    }
          
}