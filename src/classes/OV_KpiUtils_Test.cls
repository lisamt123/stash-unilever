@IsTest
public class OV_KpiUtils_Test {

    public static final String wrongObjectName = 'wrongObjectName';

    public static testMethod void runTest(){
        OV_KpiUtils utils = new OV_KpiUtils();// constructor code coverage
        OV_GetKPI_Mapping__c kpiMapping1 = new OV_GetKPI_Mapping__c(Name='Mapping 1', Object_API_Name__c = wrongObjectName,  Order__c = 1, Field_API_Name__c = wrongObjectName, IsHierarchical__c = false, Header__c = 'Test');
        insert kpiMapping1;
        OV_GetKPI_Mapping__c kpiMapping2 = new OV_GetKPI_Mapping__c(Name='Mapping 2', Object_API_Name__c = wrongObjectName,  Order__c = 1, Field_API_Name__c = wrongObjectName, IsHierarchical__c = false, Header__c = 'Test');
        insert kpiMapping2;
        
        system.assertEquals(2, OV_KpiUtils.getKpiSearchMapping().size());
        system.assertEquals(2, OV_KpiUtils.getKpiSearchMappingCS().size());
    }
}