/************************************************************************************************************
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
 VERSION    AUTHOR      DATE            DETAIL Description 
 1.0        Bolima      13/12/2015 :    INITIAL DEVELOPMENT for Stock Cover Calculation
 1.1        Barcenas    08/03/2016 :    Updated code to include the computation 
                                            of the Summarized Invoice Value field of Stock Product Summary object 
                                            taken from summarized Invoice Value field of UID Order Product object.
 *************************************************************************************************************/
public with sharing class UID_StockCoverTriggerHelper {
    
    //JB 16/03/2016 BR1.4: 
    public class rankingEntry
        {
            public Decimal totalInvoice{get;set;}
            public String secondarySalesKey{get;set;}
        }
    
    
    private static final String SECONDARY_SALES_RECORDTYPE_NAME = 'Secondary Sales';
    
    //private static Set <Id> stockedProdIds; 
    
    /******************************************************************* 
    Purpose: Populate Report Month of Order
    Parameters: List<Orders> new Orders
    Returns: void
    ********************************************************************/    
  
    public static void computeStockCover(List<UID_Stocked_Product__c> newStockedProduct , Map<Id, UID_Stocked_Product__c> oldStockedProduct){
        
        Set <Id> stockedProdIds = new Set <Id>();
        //stockedProdIds = new Set <Id>(); 
        //Store Stored Product Record Id 
        for (UID_Stocked_Product__c n : newStockedProduct) {
             if (n.UID_Stock_Cover_Calculation_Flag__c && !oldStockedProduct.get(n.Id).UID_Stock_Cover_Calculation_Flag__c) {
                 stockedProdIds.add(n.Id);
             }
        }  
        
        calculateStockCover(stockedProdIds);
        //calculateStockCover();
    }
    
    @future
    public static void calculateStockCover(Set <Id> stockedProdIds) { 
    //public static void calculateStockCover() { 
        //Variable Declations    
        Map <String, List <UID_Stocked_Product_Summary__c>> openingStockMap = new Map <String, List<UID_Stocked_Product_Summary__c >>();
        Map <String, List <UID_Order_Product__c>> last3MonthMap = new Map <String, List <UID_Order_Product__c>>();
        Map <String, List <UID_Order_Product__c>> primarySalesMap = new Map <String, List <UID_Order_Product__c>>();
        Map <String, List <UID_Order_Product__c>> secondarySalesMap = new Map <String, List <UID_Order_Product__c>>();
        
        Map <String, List <UID_Stocked_Product_Summary__c>> inQuantityStockMap = new Map <String, List<UID_Stocked_Product_Summary__c >>();
        
        //JB Added declaration
        Map<string,rankingEntry> totalSecondaryInvoiceMap = new Map<string,rankingEntry>();
        
        
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
        
        //JB 08/03/2016 BR1.4: Added the UID_Summarized_Invoice_Value__c in the Select Statement
        for (UID_Stocked_Product_Summary__c s : [Select Id, 
                                                    UID_Material_ID__c, 
                                                    UID_Stock_Cover__c, 
                                                    UID_Stocked_Product__r.UID_Distributor__c, 
                                                    UID_Stocked_Product__r.UID_Start_Date__c,
                                                    UID_Stocked_Product__r.UID_End_Date__c, 
                                                    UID_Sales_Date__c, 
                                                    UID_Stocked_Product__r.UID_Report_Date__c,
                                                    UID_Summarized_Invoice_Value__c,
                                                    UID_Stock_Product_Summary_Ranking__c 
                                                From UID_Stocked_Product_Summary__c 
                                                Where UID_Stocked_Product__c IN : stockedProdIds]) {
            accountID.add(s.UID_Stocked_Product__r.UID_Distributor__c);
            materialID.add(s.UID_Material_ID__c);
            currentMonth.add(UID_StockProductUtility.getReportMonth(s.UID_Stocked_Product__r.UID_Start_Date__c, 0));
            previousMonth.add(UID_StockProductUtility.getReportMonth(s.UID_Stocked_Product__r.UID_Start_Date__c,-1));
            last3Months.add(UID_StockProductUtility.getReportMonth(s.UID_Stocked_Product__r.UID_Start_Date__c,-3));
            last3Months.add(UID_StockProductUtility.getReportMonth(s.UID_Stocked_Product__r.UID_Start_Date__c,-2));
            last3Months.add(UID_StockProductUtility.getReportMonth(s.UID_Stocked_Product__r.UID_Start_Date__c,-1));
            stockDetails.add(s);
        }
        
        //Store Per Material Total Opening Stock in Map. MaterialID + Account + Report Date
        openingStockMap = UID_StockProductUtility.getStockedProducts(materialID, accountID, previousMonth);
        
        //Store Per Material Total In Quantity Stock in Map. MaterialID + Account + Report Date
        inQuantityStockMap = UID_StockProductUtility.getStockedProducts(materialID, accountID, currentMonth);
        
                
        
        
        //Store Per Material Total Quantity for Secondary Sales in Map. MaterialID + Account + Report Date
        secondarySalesMap = UID_StockProductUtility.getSales(materialID, accountID, currentMonth, SECONDARY_SALES_RECORDTYPE_NAME);
                
        //Store Per Material Total Quantity for the Last 3 Months in Map. MaterialID + Account + Report Date
        //JB 21/03/2016 BR1.4: updated the method being call
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
        
        for (UID_Stocked_Product_Summary__c sd : stockDetails) {
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
            String openingStockMapKey = sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + UID_StockProductUtility.getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, -1);
            totalOpening = UID_StockProductUtility.setTotalStock(openingStockMapKey, openingStockMap, true);
            
            //B: Incoming Qty from Distributor Inventory Report
            String inQuantityMapKey = sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + UID_StockProductUtility.getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, 0);
            totalPrimary = UID_StockProductUtility.setTotalStock(inQuantityMapKey, inQuantityStockMap, false);
            
            
            //C:Sales for the month = Secondary Sales for this month (M) from Distributor 
            String secondarySalesMapKey = sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + UID_StockProductUtility.getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, 0);
            totalSecondary = UID_StockProductUtility.setTotalOrderQuantity(secondarySalesMapKey, secondarySalesMap);
            
            //D:Closing Stock = A+B-C
            Decimal totalClosing = (totalOpening + totalPrimary) - totalSecondary;
            
            String last3MonthMapKey1 = sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + UID_StockProductUtility.getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, -1);
            month1st = UID_StockProductUtility.setTotalOrderQuantity(last3MonthMapKey1, last3MonthMap);
			                        
            String last3MonthMapKey2 = sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + UID_StockProductUtility.getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, -2);
            month2nd = UID_StockProductUtility.setTotalOrderQuantity(last3MonthMapKey2, last3MonthMap);
            
            String last3MonthMap3= sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + UID_StockProductUtility.getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, -3);
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
            
            //JB Summarized invoice value for Past 3 months
            month1stInvoice = UID_StockProductUtility.setTotalSecondaryInvoice(last3MonthMapKey1, last3MonthMap);            
            month2ndInvoice = UID_StockProductUtility.setTotalSecondaryInvoice(last3MonthMapKey2, last3MonthMap);
            month3rdInvoice = UID_StockProductUtility.setTotalSecondaryInvoice(last3MonthMap3, last3MonthMap);
            
            total3MonthsSecondaryInvoice = month1stInvoice + month2ndInvoice + month3rdInvoice;
            sd.UID_Summarized_Invoice_Value__c = total3MonthsSecondaryInvoice; 
            
            rankingEntry rankingEntryRec = new rankingEntry();
            rankingEntryRec.secondarySalesKey = secondarySalesMapKey; 
            rankingEntryRec.totalInvoice = total3MonthsSecondaryInvoice;
                                                
            totalSecondaryInvoiceMap.put(secondarySalesMapKey, rankingEntryRec);
            
        }
        
         	calculateSummarizedInvoiceRanking(totalSecondaryInvoiceMap, stockDetails);
               
        update stockDetails;
    }
        
    /******************************************************************* 
    Purpose: Summarized the Invoice Value for UID Order Product for BR1.4
    Parameters: 
            Map<string,rankingEntry>
    Returns: none
    ********************************************************************/  
    public static void calculateSummarizedInvoiceRanking(Map<string,rankingEntry> totalSecondaryInvoiceMap, List <UID_Stocked_Product_Summary__c> stockDetails){
    	 
        	Map<string,integer> totalSecondaryRankingMap = new Map<string,integer>();
            Map<Decimal,List<String>> rankToNameMap = new Map<Decimal,List<String>>();
            
            for(rankingEntry entry : totalSecondaryInvoiceMap.values()){
                 
                 List<String> temp = (rankToNameMap.containsKey(entry.totalInvoice))
                 					? rankToNameMap.get(entry.totalInvoice)
                 					: new List<String>();
                
                temp.add(entry.secondarySalesKey);
                rankToNameMap.put(entry.totalInvoice, temp);
             }
            
            list<decimal> ranksList = new list<decimal>();
            list<decimal> descendingList = new list<decimal>();
            
            ranksList.addAll(rankToNameMap.keySet());
        
            //sorting to descending order
            ranksList.sort();
            
            for(Integer i = ranksList.size()-1; i>=0;i--){
                descendingList.add(ranksList.get(i)); 
            }
            
            Integer totalSecondaryRankingMapCounter = 1;
            
            for(Decimal rank : descendingList){
                List<String> thisEntryMapList = rankToNameMap.get(rank);
                for(String thisEntryString : thisEntryMapList ){   
                    totalSecondaryRankingMap.put(thisEntryString,totalSecondaryRankingMapCounter);
                    totalSecondaryRankingMapCounter +=1;
                }
            }
            
            for (UID_Stocked_Product_Summary__c sd2 : stockDetails) {
                String secondarySalesMapKey2 = sd2.UID_Material_ID__c + sd2.UID_Stocked_Product__r.UID_Distributor__c + UID_StockProductUtility.getReportMonth(sd2.UID_Stocked_Product__r.UID_Report_Date__c, 0);
                if(totalSecondaryRankingMap.containsKey(secondarySalesMapKey2)){
                    sd2.UID_Stock_Product_Summary_Ranking__c = totalSecondaryRankingMap.get(secondarySalesMapKey2);
                }
            }
            
    }
}