@isTest
global class OV_KpiDimensionWrapper_Test{
    
    public static testMethod void runTest(){
        OV_KPI_Dimension_KPI_Name__c dimension = new OV_KPI_Dimension_KPI_Name__c (Code__c='test', Code_Text__c = 'LABEL_1234');
        insert dimension;
        OV_KpiDimensionWrapper wrapper = new OV_KpiDimensionWrapper(dimension.Id, 'Name');
        OV_KpiDimensionWrapper childWrapper = new OV_KpiDimensionWrapper(dimension.Id, 'Name');
        wrapper.addChild(childWrapper);
        system.assertEquals(1, wrapper.children.size());
    }
    
}