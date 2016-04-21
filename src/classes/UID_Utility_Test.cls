public class UID_Utility_Test {

    public static UL_Exchange_Rate__c createExchangeRate(Date startDate, 
                                                         Date endDate, 
                                                         String category,
                                                        	Decimal eur,
                                                        	Decimal usd) {
        UL_Exchange_Rate__c exRate = new UL_Exchange_Rate__c();
        exRate.UL_Start_Date__c = startDate;
		exRate.UL_End_Date__c = endDate;
		exRate.UL_Category__c = category;
		exRate.UL_EUR__c = eur;
		exRate.UL_USD__c = usd;
                                                                
        return exRate;
    }
    
    public static UID_Performance__c createPerformance(Account account) {
        UID_Performance__c performance = new UID_Performance__c();
        
        performance.UID_Distributor__c = Account.Id;
        
        return performance;
    }
    
    public static UID_Performance_Line_Item__c createPerformanceLineItem(UID_Performance__c performance,
                                                                        String category,
                                                                        Decimal JBPValue,
                                                                        Date JBPDate,
                                                                        Product2 productDetail) {
        UID_Performance_Line_Item__c pli = new UID_Performance_Line_Item__c();
                                                                            
        pli.UID_IOP__c = performance.Id;
        pli.UID_IOP_Value__c = JBPValue;
        pli.UID_IOP_Date__c = JBPDate;                
		pli.UID_Product__c = productDetail.Id;
		pli.UID_Exchange_Rate_Category__c = category;
                                                                            
        return pli;
    }
}