/************************************************************************************************************
 Name: UID_StockedProductSummaryTriggerHelper() 
 Copyright © 2016 Salesforce 
 ====================================================== 
 ====================================================== 
 Purpose: 
 1. Calculate the Stock Cover per Material Id for each Processed Account
 ====================================================== 
 ====================================================== 
 History 
 ------- 
 VERSION    AUTHOR      DATE            DETAIL Description 
 1.0        Barcenas    16/05/2015 :    INITIAL DEVELOPMENT for Stock Cover Calculation
 *************************************************************************************************************/
public with sharing class UID_StockedProductSummaryTriggerHelper {
    
    
    private static final String SECONDARY_SALES_RECORDTYPE_NAME = 'Secondary Sales';
    
    public static void computeStockCover(List<UID_Stocked_Product_Summary__c> newStockedProductSummary , Map<Id, UID_Stocked_Product_Summary__c> oldStockedProductSummary){
        
        List<UID_Stocked_Product_Summary__c> stockedProdSumList = new List<UID_Stocked_Product_Summary__c>();
        Set<Id> stockedProdIds = new Set<Id>();
               
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
        
        for (UID_Stocked_Product_Summary__c n : newStockedProductSummary) {
             if (n.UID_Stock_Cover_Calculation_Flag__c && !oldStockedProductSummary.get(n.Id).UID_Stock_Cover_Calculation_Flag__c) {
                stockedProdSumList.add(n);
                stockedProdIds.add(n.UID_Stocked_Product__c);
             }
        }
        
        Map<Id, UID_Stocked_Product__c> stockedProductMap = new Map<Id, UID_Stocked_Product__c>([SELECT Id, 
        																							UID_Start_Date__c,
        																							UID_Distributor__c,
        																							UID_Report_Date__c 
        																						FROM UID_Stocked_Product__c 
        																						WHERE Id IN :stockedProdIds]);
        
        for(UID_Stocked_Product_Summary__c n :stockedProdSumList){
        	    accountID.add(stockedProductMap.get(n.UID_Stocked_Product__c).UID_Distributor__c);
        		materialID.add(n.UID_Material_ID__c);
	            currentMonth.add(UID_StockProductUtility.getReportMonth(stockedProductMap.get(n.UID_Stocked_Product__c).UID_Start_Date__c, 0));
	            previousMonth.add(UID_StockProductUtility.getReportMonth(stockedProductMap.get(n.UID_Stocked_Product__c).UID_Start_Date__c,-1));
	            last3Months.add(UID_StockProductUtility.getReportMonth(stockedProductMap.get(n.UID_Stocked_Product__c).UID_Start_Date__c,-3));
	            last3Months.add(UID_StockProductUtility.getReportMonth(stockedProductMap.get(n.UID_Stocked_Product__c).UID_Start_Date__c,-2));
	            last3Months.add(UID_StockProductUtility.getReportMonth(stockedProductMap.get(n.UID_Stocked_Product__c).UID_Start_Date__c,-1));
	            
        }
         
        calculateStockCover(stockedProdSumList, stockedProductMap, accountID, materialID, currentMonth, previousMonth, last3Months);
    }
    
    public static void calculateStockCover(List<UID_Stocked_Product_Summary__c> stockedProdSumList,
    											Map<Id, UID_Stocked_Product__c> stockedProductMap, 
    											Set <Id> accountID, 
    											Set <String> materialID, 
    											Set <String> currentMonth,
    											Set <String> previousMonth,
    											Set <String> last3Months) { 
        //Variable Declations    
        Map <String, List <UID_Stocked_Product_Summary__c>> openingStockMap = new Map <String, List<UID_Stocked_Product_Summary__c >>();
        Map <String, List <UID_Order_Product__c>> last3MonthMap = new Map <String, List <UID_Order_Product__c>>();
        Map <String, List <UID_Order_Product__c>> primarySalesMap = new Map <String, List <UID_Order_Product__c>>();
        Map <String, List <UID_Order_Product__c>> secondarySalesMap = new Map <String, List <UID_Order_Product__c>>();
        
        Map <String, List <UID_Stocked_Product_Summary__c>> inQuantityStockMap = new Map <String, List<UID_Stocked_Product_Summary__c >>();
              
        //Store Per Material Total Opening Stock in Map. MaterialID + Account + Report Date
        openingStockMap = UID_StockProductUtility.getStockedProducts(materialID, accountID, previousMonth);
        
        //Store Per Material Total In Quantity Stock in Map. MaterialID + Account + Report Date
        inQuantityStockMap = UID_StockProductUtility.getStockedProducts(materialID, accountID, currentMonth);
        
        //Store Per Material Total Quantity for Secondary Sales in Map. MaterialID + Account + Report Date
        secondarySalesMap = UID_StockProductUtility.getSales(materialID, accountID, currentMonth, SECONDARY_SALES_RECORDTYPE_NAME);
                
        //Store Per Material Total Quantity for the Last 3 Months in Map. MaterialID + Account + Report Date
        last3MonthMap = UID_StockProductUtility.getSales(materialID, accountID, last3Months, SECONDARY_SALES_RECORDTYPE_NAME);
                          
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
        
        for (UID_Stocked_Product_Summary__c sd : stockedProdSumList) {
            Decimal totalOpening = 0;
            Decimal totalPrimary = 0;
            Decimal totalSecondary = 0;
            Decimal month1st = 0;
            Decimal month2nd = 0;
            Decimal month3rd = 0;
                        
            Decimal month1stInvoice = 0;
            Decimal month2ndInvoice = 0;
            Decimal month3rdInvoice = 0;
            
            Decimal total3MonthsSecondaryInvoice = 0;
            
            //A:Opening Stock of the month = Closing stock for last month (M-1)
            String openingStockMapKey = sd.UID_Material_ID__c + stockedProductMap.get(sd.UID_Stocked_Product__c).UID_Distributor__c + UID_StockProductUtility.getReportMonth(stockedProductMap.get(sd.UID_Stocked_Product__c).UID_Report_Date__c, -1);
            totalOpening = UID_StockProductUtility.setTotalStock(openingStockMapKey, openingStockMap, true);
            
            //B: Incoming Qty from Distributor Inventory Report
            String inQuantityMapKey = sd.UID_Material_ID__c + stockedProductMap.get(sd.UID_Stocked_Product__c).UID_Distributor__c + UID_StockProductUtility.getReportMonth(stockedProductMap.get(sd.UID_Stocked_Product__c).UID_Report_Date__c, 0);
            totalPrimary = UID_StockProductUtility.setTotalStock(inQuantityMapKey, inQuantityStockMap, false);
            
            //C:Sales for the month = Secondary Sales for this month (M) from Distributor 
            String secondarySalesMapKey = sd.UID_Material_ID__c + stockedProductMap.get(sd.UID_Stocked_Product__c).UID_Distributor__c + UID_StockProductUtility.getReportMonth(stockedProductMap.get(sd.UID_Stocked_Product__c).UID_Report_Date__c, 0);
            totalSecondary = UID_StockProductUtility.setTotalOrderQuantity(secondarySalesMapKey, secondarySalesMap);
                       
            //D:Closing Stock = A+B-C
            Decimal totalClosing = (totalOpening + totalPrimary) - totalSecondary;
            
            String last3MonthMapKey1 = sd.UID_Material_ID__c + stockedProductMap.get(sd.UID_Stocked_Product__c).UID_Distributor__c + UID_StockProductUtility.getReportMonth(stockedProductMap.get(sd.UID_Stocked_Product__c).UID_Report_Date__c, -1);
            month1st = UID_StockProductUtility.setTotalOrderQuantity(last3MonthMapKey1, last3MonthMap);
			                        
            String last3MonthMapKey2 = sd.UID_Material_ID__c + stockedProductMap.get(sd.UID_Stocked_Product__c).UID_Distributor__c + UID_StockProductUtility.getReportMonth(stockedProductMap.get(sd.UID_Stocked_Product__c).UID_Report_Date__c, -2);
            month2nd = UID_StockProductUtility.setTotalOrderQuantity(last3MonthMapKey2, last3MonthMap);
            
            String last3MonthMap3= sd.UID_Material_ID__c + stockedProductMap.get(sd.UID_Stocked_Product__c).UID_Distributor__c + UID_StockProductUtility.getReportMonth(stockedProductMap.get(sd.UID_Stocked_Product__c).UID_Report_Date__c, -3);
            month3rd = UID_StockProductUtility.setTotalOrderQuantity(last3MonthMap3, last3MonthMap);
            
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
            
            //Summarized invoice value for Past 3 months
            month1stInvoice = UID_StockProductUtility.setTotalSecondaryInvoice(last3MonthMapKey1, last3MonthMap);            
            month2ndInvoice = UID_StockProductUtility.setTotalSecondaryInvoice(last3MonthMapKey2, last3MonthMap);
            month3rdInvoice = UID_StockProductUtility.setTotalSecondaryInvoice(last3MonthMap3, last3MonthMap);
            
            total3MonthsSecondaryInvoice = month1stInvoice + month2ndInvoice + month3rdInvoice;
            sd.UID_Summarized_Invoice_Value__c = total3MonthsSecondaryInvoice;
        }
        
    }
    
}