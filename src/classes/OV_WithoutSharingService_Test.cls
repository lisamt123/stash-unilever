/**********************************************************************
Name: OV_WithoutSharingService_Test
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Test for OV_WithoutSharingService
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             27/10/2015      INITIAL DEVELOPMENT
**********************************************************************/
@isTest
private class OV_WithoutSharingService_Test {
	
	@isTest static void test_method_one() {
		OV_Brand__c brand1 = OV_TestingHelper.initBrand('Brand 1', true);
        OV_Category__c category1 = OV_TestingHelper.initCategory('Category 1', true);
        OV_Comparator__c comparator1 = OV_TestingHelper.initBrandComparator('Comparator 1', true);
        OV_Function__c function1 = OV_TestingHelper.initFunction('Function 1', true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography('Geography 1', true);

        OV_KPI_Name__c kpiName1 = OV_TestingHelper.initKPIName('KPIName1', true);
        OV_KPI_Name__c kpiName2 = OV_TestingHelper.initKPIName('KPIName2', true);
        OV_Report__c report1 = OV_TestingHelper.initReport('Report 1', category1, function1, geography1, 'Desktop', true);

        OV_Report__c rep = [SELECT Views__c FROM OV_Report__c WHERE Id = :report1.Id LIMIT 1];
        System.assertEquals(0, rep.Views__c);

        OV_WithoutSharingService.increaseViewsCounter(rep);

        rep = [SELECT Views__c FROM OV_Report__c WHERE Id = :report1.Id LIMIT 1];

        System.assertEquals(1, rep.Views__c);

        User u = OV_TestingHelper.createAdminUser('test', 'test@test.com', 'test2');
        OV_Profile__c profile = OV_TestingHelper.initProfile('Profile1', u, true);

        System.runAs(u){
            OV_WithoutSharingService.increaseViewsCounter(rep);
        }

        rep = [SELECT Views__c FROM OV_Report__c WHERE Id = :report1.Id LIMIT 1];
         System.assertEquals(2, rep.Views__c);
	}		
}