/**********************************************************************
Name: OV_KPIService_Test
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Test Class test OV_KPIService
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             28/05/2015      INITIAL DEVELOPMENT
**********************************************************************/

@isTest
private class OV_KPIService_Test {
	
	@isTest static void tesMyKPI() {
        OV_Brand__c brand1 = OV_TestingHelper.initBrand('Brand 1', true);
        OV_Category__c category1 = OV_TestingHelper.initCategory('Category 1', true);
        OV_Comparator__c comparator1 = OV_TestingHelper.initBrandComparator('Comparator 1', true);
        OV_Function__c function1 = OV_TestingHelper.initFunction('Function 1', true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography('Geography 1', true);

        OV_KPI_Name__c kpiName1 = OV_TestingHelper.initKPIName('KPIName1', true);
        OV_KPI_Name__c kpiName2 = OV_TestingHelper.initKPIName('KPIName2', true);
        OV_Report__c report1 = OV_TestingHelper.initReport('Report 1', category1, function1, geography1, 'Desktop', true);
        OV_Report__c report2 = OV_TestingHelper.initReport('Report 2', category1, function1, geography1, 'Mobile', true);
        OV_Report__c report3 = OV_TestingHelper.initReport('Report 3', category1, function1, geography1, 'Tablet', true);
        OV_Report__c report4 = OV_TestingHelper.initReport('Report 4', category1, function1, geography1, 'Tablet', true);

        OV_KPI_Element__c kpiElement1 = OV_TestingHelper.initKPIElement('KPIElement1', brand1, comparator1, category1, 'UP', function1, geography1, kpiName1, 1.1, report1, 2.1, 'Week', true);
        OV_KPI_Element__c kpiElement2 = OV_TestingHelper.initKPIElement('KPIElement2', brand1, comparator1, category1, 'UP', function1, geography1, kpiName1, 1.1, report2, 2.1, 'Day', true);
        OV_KPI_Element__c kpiElement3 = OV_TestingHelper.initKPIElement('KPIElement3', brand1, comparator1, category1, 'UP', function1, geography1, kpiName1, 1.1, report3, 2.1, 'Day', true);

        List<OV_Wrapper.KPINameWrapper> kpiNamesList = OV_KPIService.getKPINames();
        System.assertEquals(2, kpiNamesList.size());
        System.assertEquals(kpiName1.Name, kpiNamesList[0].kpiNameName);
        System.assertEquals(kpiName2.Name, kpiNamesList[1].kpiNameName);

        List<OV_Wrapper.ReportWrapper> reports = OV_KPIService.getReports(kpiName1.Id);
        System.assertEquals(3, reports.size());

        List<OV_Wrapper.KPIElementWrapper> kpiElementsList = OV_KPIService.getKPIElements(kpiName1.Id, report1.Id);
        System.assertEquals(1, kpiElementsList.size());
        System.assertEquals(report1.Id, kpiElementsList[0].kpiElementReportId);

        User u = OV_TestingHelper.createAdminUser('test', 'test@test.com', 'test2');
        OV_Profile__c profile = OV_TestingHelper.initProfile('Profile1', u, true);

        System.runAs(u){
            OV_KPIService.addKPIElementToMyKPIs(kpiElementsList[0].kpiElementId, true);
        }
        
        List<OV_KPI_Element_Interest__c> objIntrests = [SELECT Id, KPI_Element__c, User__c, Wants_Notifications__c FROM OV_KPI_Element_Interest__c WHERE KPI_Element__c =:kpiElementsList[0].kpiElementId];
        System.assertEquals(1, objIntrests.size());
        System.assertEquals(profile.Id, objIntrests[0].User__c);

        List<OV_Wrapper.KPIElementWrapper> myKpis;
        System.runAs(u){
            myKpis = OV_KPIService.getMyKPIElements('', '', '', false);
        }
        System.assertEquals(1, myKpis.size());
        System.assertEquals(brand1.Id, myKpis[0].kpiElementBrandId);

        System.runAs(u){
            OV_KPIService.deleteMyKPI(myKpis[0].kpiElementId);
            myKpis = OV_KPIService.getMyKPIElements('', '', '', false);
        }
        System.assertEquals(0, myKpis.size());
	}
}