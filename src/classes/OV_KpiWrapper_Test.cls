@isTest
global class OV_KpiWrapper_Test{

    public static testMethod void runTest(){
        OV_KpiWrapper wrapper = new OV_KpiWrapper('message', 'status' , new Map<String, Object>());
        system.assertEquals('message', wrapper.message);
        
        OV_GetKPI_Mapping__c mp = new OV_GetKPI_Mapping__c(Name = 'Name1', Order__c = 1);
        OV_GetKPI_Mapping__c mp2 = new OV_GetKPI_Mapping__c(Name = 'Name2', Order__c = 2);
        
        OV_KpiWrapper.KPIMappingWrapper kpiWrapper = new OV_KpiWrapper.KPIMappingWrapper(mp);
        OV_KpiWrapper.KPIMappingWrapper kpiWrapper2 = new OV_KpiWrapper.KPIMappingWrapper(mp2);
        
        system.assertEquals(-1, kpiWrapper.compareTo(kpiWrapper2));
        system.assertEquals(1, kpiWrapper2.compareTo(kpiWrapper));
    }
}