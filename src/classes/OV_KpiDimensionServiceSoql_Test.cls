@isTest
global class OV_KpiDimensionServiceSoql_Test{
    
    public static testMethod void runTest(){
        OV_KpiDimensionServiceSoql instance = new OV_KpiDimensionServiceSoql(); //for code coverage
    
        OV_KPI_Dimension_KPI_Name__c dimension = new OV_KPI_Dimension_KPI_Name__c (Code__c='test', Code_Text__c = 'LABEL_1234');
        insert dimension;
        system.assertEquals(1, OV_KpiDimensionServiceSoql.getKPINames().size());
    }
    
}