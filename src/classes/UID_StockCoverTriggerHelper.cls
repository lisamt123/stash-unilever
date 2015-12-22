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
 VERSION AUTHOR DATE DETAIL Description 
 1.0 Bolima 13/12/2015 INITIAL DEVELOPMENT for Stock Cover Calculation
 ***********************************************************************/
public class UID_StockCoverTriggerHelper {
    
    private static final String PRIMARY_SALES_RECORDTYPE_NAME = 'Primary Sales';
    private static final String SECONDARY_SALES_RECORDTYPE_NAME = 'Secondary Sales';
    
    /******************************************************************* 
    Purpose: Populate Report Month of Order
    Parameters: List<Orders> new Orders
    Returns: void
    ********************************************************************/    
  
    public static void computeStockCover(List<UID_Stocked_Product__c> newStockedProduct , Map<Id, UID_Stocked_Product__c> oldStockedProduct){
        
        Set <Id> stockedProdIds = new Set <Id>(); 
        //Store Stored Product Record Id 
        for (UID_Stocked_Product__c n : newStockedProduct) {
             if (n.UID_Stock_Cover_Calculation_Flag__c == True && oldStockedProduct.get(n.Id).UID_Stock_Cover_Calculation_Flag__c == False) {
                 stockedProdIds.add(n.Id);
             }
        }  
        
        calculateStockCover(stockedProdIds);
    }
    
    @future
    public static void calculateStockCover(Set <Id> stockedProdIds) { 
        //Variable Declations    
        Map <String, List <UID_Stocked_Product_Summary__c>> openingStockMap = new Map <String, List<UID_Stocked_Product_Summary__c >>();
        Map <String, List <OrderItem>> last3MonthMap = new Map <String, List <OrderItem>>();
        Map <String, List <OrderItem>> last2MonthMap = new Map <String, List <OrderItem>>();
        Map <String, List <OrderItem>> last1MonthMap = new Map <String, List <OrderItem>>();
        Map <String, List <OrderItem>> primarySalesMap = new Map <String, List <OrderItem>>();
        Map <String, List <OrderItem>> secondarySalesMap = new Map <String, List <OrderItem>>();
        
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
        //Store Last Two (2) Sales Date
        Set <String> last2Months = new Set <String> ();
        //Store Last Two (1) Sales Date
        Set <String> last1Months = new Set <String> ();
        
        
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
        for (UID_Stocked_Product_Summary__c os : [Select UID_Material_ID__c, UID_Avail_Quantity__c, UID_Stocked_Product__r.UID_Distributor__c, UID_Sales_Date__c, UID_Stocked_Product__r.UID_Report_Date__c
        From UID_Stocked_Product_Summary__c Where UID_Material_ID__c IN : materialID AND UID_Stocked_Product__r.UID_Distributor__c IN : accountID AND UID_Sales_Date__c IN : previousMonth])
        {
            String openingMapID = os.UID_Material_ID__c + os.UID_Stocked_Product__r.UID_Distributor__c + os.UID_Sales_Date__c;
            if(openingStockMap .containsKey(openingMapID)) {
                openingStockMap.get(openingMapID).add(os);
            }
            else if(!openingStockMap.containsKey(openingMapID)) {
                List <UID_Stocked_Product_Summary__c> openingList= new List <UID_Stocked_Product_Summary__c >();
                openingList.add(os);
                openingStockMap.put(openingMapID, openingList);
            }   
            
        }
        
        //Store Per Material Total Quantity for Primary Sales in Map. MaterialID + Account + Report Date
        for (OrderItem ps : [Select UID_Material_ID__c, UID_Order_Quantity__c, Order.UID_Distributor__c, UID_Sales_Date__c, Order.UID_Report_Date__c
        From OrderItem WHERE UID_Material_ID__c IN : materialID AND Order.UID_Distributor__r.Id IN : accountID AND UID_Sales_Date__c IN : currentMonth AND order.RecordType.Name =: PRIMARY_SALES_RECORDTYPE_NAME])
        {
            String primaryMapID = ps.UID_Material_ID__c + ps.Order.UID_Distributor__c + ps.UID_Sales_Date__c;
            if(primarySalesMap.containsKey(primaryMapID)) {
                primarySalesMap.get(primaryMapID).add(ps);
            }
            else if(!primarySalesMap.containsKey(primaryMapID)) {
                List <OrderItem> primaryList= new List <OrderItem>();
                primaryList.add(ps);
                primarySalesMap.put(primaryMapID, primaryList);
            }   
        }
        
        //Store Per Material Total Quantity for Secondary Sales in Map. MaterialID + Account + Report Date
        for (OrderItem ss : [Select UID_Material_ID__c, UID_Order_Quantity__c, Order.UID_Distributor__c, UID_Sales_Date__c, Order.UID_Report_Date__c
        From OrderItem WHERE UID_Material_ID__c IN : materialID AND Order.UID_Distributor__r.Id IN : accountID AND UID_Sales_Date__c IN : currentMonth AND order.RecordType.Name =: SECONDARY_SALES_RECORDTYPE_NAME])
        {
            String secondaryMapID = ss.UID_Material_ID__c + ss.Order.UID_Distributor__c + ss.UID_Sales_Date__c;
            if(secondarySalesMap.containsKey(secondaryMapID)) {
                secondarySalesMap.get(secondaryMapID).add(ss);
            }
            else if(!secondarySalesMap.containsKey(secondaryMapID)) {
                List <OrderItem> secondaryList= new List <OrderItem>();
                secondaryList.add(ss);
                secondarySalesMap.put(secondaryMapID, secondaryList);
            }  
        }
        
        //Store Per Material Total Quantity for the Last 3 Months in Map. MaterialID + Account + Report Date
        for (OrderItem lm : [Select UID_Material_ID__c, UID_Order_Quantity__c, Order.UID_Distributor__c, UID_Sales_Date__c, Order.UID_Report_Date__c
        From OrderItem WHERE UID_Material_ID__c IN : materialID AND Order.UID_Distributor__c IN : accountID AND UID_Sales_Date__c IN : last3Months AND order.RecordType.Name =: SECONDARY_SALES_RECORDTYPE_NAME])
        {
            String last3MapID = lm.UID_Material_ID__c + lm.Order.UID_Distributor__c + lm.UID_Sales_Date__c;
            if(last3MonthMap.containsKey(last3MapID )) {
                last3MonthMap.get(last3MapID).add(lm);
            }
            else if(!last3MonthMap.containsKey(last3MapID)) {
                List <OrderItem> last3List= new List <OrderItem>();
                last3List.add(lm);
                last3MonthMap.put(last3MapID, last3List);
            }     
        }
        
        
                  
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
            if(openingStockMap.get(sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, -1)) != NULL) {
                for(UID_Stocked_Product_Summary__c ci: openingStockMap.get(sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, -1))){
                    if(ci.UID_Avail_Quantity__c != NULL){
                        totalOpening = totalOpening + ci.UID_Avail_Quantity__c;
                    }
                }
            }
         
            //B:Shipments received in same calendar month = Primary Sales for this month(M)
            if(primarySalesMap.get(sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, 0)) != NULL) {
                for(OrderItem ps: primarySalesMap.get(sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, 0))){
                    if(ps.UID_Order_Quantity__c != NULL){
                        totalPrimary = totalPrimary + ps.UID_Order_Quantity__c;
                    }
                }
            }
            
            //C:Sales for the month = Secondary Sales for this month (M) from Distributor 
            if(secondarySalesMap.get(sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, 0)) != NULL) {
                for(OrderItem ps: secondarySalesMap.get(sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, 0))){
                    if(ps.UID_Order_Quantity__c != NULL){
                        totalSecondary = totalSecondary + ps.UID_Order_Quantity__c;
                    }
                }
            }
            
            //D:Closing Stock = A+B-C
            Decimal totalClosing = (totalOpening + totalPrimary) - totalSecondary;
            
            if(last3MonthMap.get(sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, -1)) != NULL) {
                for(OrderItem ps: last3MonthMap.get(sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, -1))){
                    if(ps.UID_Order_Quantity__c != NULL){
                        month1st = month1st  + ps.UID_Order_Quantity__c;
                    }
                }
            }
            
            if(last3MonthMap.get(sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, -2)) != NULL) {
                for(OrderItem ps: last3MonthMap.get(sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, -2))){
                    if(ps.UID_Order_Quantity__c != NULL){
                        month2nd = month2nd  + ps.UID_Order_Quantity__c;
                    }
                }
            }
            
            if(last3MonthMap.get(sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, -3)) != NULL) {
                for(OrderItem ps: last3MonthMap.get(sd.UID_Material_ID__c + sd.UID_Stocked_Product__r.UID_Distributor__c + getReportMonth(sd.UID_Stocked_Product__r.UID_Report_Date__c, -3))){
                    if(ps.UID_Order_Quantity__c != NULL){
                        month3rd = month3rd  + ps.UID_Order_Quantity__c;
                    }
                }
            }
            
            //E:Last 3 month Rolling Avg Sales less DT Margin =  (Secondary Sales in M-1+  Secondary Sales in M-2 +Secondary Sales in M-3)/3
            Decimal totallast3Mont = (month1st + month2nd + month3rd) / 3;
            //F:Stock Cover = (D/E) * 30
            Decimal stockCover = (totalClosing / (totallast3Mont == 0 ? 1 : totallast3Mont)) * 30;
            
            sd.UID_Stock_Cover__c = stockCover;
        }
        
        update stockDetails;
    }
    
    public Static String getReportMonth(Date sourceDate, Integer numberOfMonths){
        
        system.debug('Entering getReportMonth: ' + sourceDate + numberOfMonths);
        
        Date priorDate = sourceDate.AddMonths(numberOfMonths);
        String dateMonth = String.valueOf(priorDate.month());
        String dateYear = String.valueOf(priorDate.Year());
        String  resultReportMonth = dateMonth + '-' + dateYear;
        
        system.debug('Exiting getReportMonth: '+ resultReportMonth);
        
        return resultReportMonth;
    }

}