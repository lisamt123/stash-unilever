/**********************************************************************
Name: OV_ReportUsageService_Test
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Test Class test OV_ReportUsageService_Test
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             22/06/2015      INITIAL DEVELOPMENT
**********************************************************************/
@isTest
private class OV_ReportUsageService_Test {
    static final String testCategoryLabel = 'testCategory';
    static final String testGeographyLabel = 'testGeography';
    static final String test1Label = 'test1';
    static final String testReportLabel = 'testReport';
    static final String testOperationLabel = 'testOperation';
    static final String testMyViewLabel = 'My View';

    public static final String WEEKLYLABEL   = 'Weekly';

    @isTest static void testSaveUsageEntryWithShelf() {
        //preparation of data

        OV_Category__c category1 = OV_TestingHelper.initCategory(testCategoryLabel, true);
        OV_Function__c function1 = OV_TestingHelper.initFunction('testFunction', null, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography(testGeographyLabel, true);
        OV_Unit__c unit1 = OV_TestingHelper.initUnitWithType(test1Label, 'Category 1', true);
        OV_Shelf__c shelf1 = OV_TestingHelper.initShelfWithColour(test1Label, 'color1', 'Moment', true);
        OV_Shelf_Tile__c shelfTile1 = OV_TestingHelper.initShelfTile(test1Label, 'testColour', 'World', shelf1, true);
        OV_ContentProxy__c contentProxy1 = OV_TestingHelper.initContentProxy(null, 'testName', null, 'www.google.com', true);
        OV_Report__c report1 = OV_TestingHelper.initReportWithProxyAndUnit(testReportLabel, category1, function1, geography1, 'Desktop', contentProxy1.Id, unit1.Id, WEEKLYLABEL, 'Briefcase', 'TestHeading', 10, 'TestFolder', true);
        OV_ShelfTileReport__c shelfTileReport1 = OV_TestingHelper.initReportToShelfTile(report1, shelfTile1, true);

        Test.startTest();
            OV_ReportUsageService.saveUsageEntry(report1.Id, String.valueOf(shelfTile1.Id), testOperationLabel, 'Desktop', '1');

            List<OV_Report_Usage__c> result = [
                SELECT
                    Operation__c,
                    Device_Type__c,
                    OneView_Report_Details_Category__c,
                    OneView_Report_Details_Code__c,
                    OneView_Report_Details_Frequency__c,
                    OneView_Report_Details_Geography__c,
                    OneView_Report_Details_Name__c,
                    OneView_Report_Details_Reporting_Period__c,
                    OneView_Report_Details_Unit_Code__c,
                    Shelf_Code__c,
                    Shelf_Name__c,
                    Shelf_Tile_Code__c,
                    Shelf_Tile_Name__c,
                    Unit_Unit_Name__c,
                    Unit_Unit_Type__c,
                    Source__c
                FROM OV_Report_Usage__c LIMIT 2000];

            System.assert( !result.isEmpty() );
            System.assert( result[0].Operation__c == testOperationLabel );
            System.assert( result[0].Device_Type__c == 'Desktop' );
            System.assert( result[0].OneView_Report_Details_Category__c == testCategoryLabel );
            System.assert( result[0].OneView_Report_Details_Code__c == String.valueOf(report1.Id));
            System.assert( result[0].OneView_Report_Details_Frequency__c == WEEKLYLABEL);
            System.assert( result[0].OneView_Report_Details_Geography__c == testGeographyLabel);
            System.assert( result[0].OneView_Report_Details_Name__c == testReportLabel);
            System.assert( result[0].OneView_Report_Details_Reporting_Period__c.startsWith('Week -'));
            System.assert( result[0].OneView_Report_Details_Unit_Code__c == String.valueOf(unit1.Id) );
            System.assert( result[0].Shelf_Code__c == String.valueOf(shelfTile1.Id) );
            System.assert( result[0].Shelf_Name__c  == shelfTile1.Name);
            System.assert( result[0].Shelf_Tile_Code__c  == String.valueOf(shelfTile1.Id));
            System.assert( result[0].Shelf_Tile_Name__c  == shelfTile1.Name);
            System.assert( result[0].Unit_Unit_Name__c   == unit1.Name);
            System.assert( result[0].Unit_Unit_Type__c   == unit1.Type__c);
            System.assert( result[0].Source__c   == 'Shelf Tile' );

        Test.stopTest();
    }

    @isTest static void testSaveUsageEntryWithoutShelf() {
        //preparation of data

        OV_Category__c category1 = OV_TestingHelper.initCategory(testCategoryLabel, true);
        OV_Function__c function1 = OV_TestingHelper.initFunction('testFunction', null, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography(testGeographyLabel, true);
        OV_Unit__c unit1 = OV_TestingHelper.initUnitWithType(test1Label, 'Category 1', true);
        OV_Shelf__c shelf1 = OV_TestingHelper.initShelfWithColour(test1Label, 'color1', 'Moment', true);
        OV_Shelf_Tile__c shelfTile1 = OV_TestingHelper.initShelfTile(test1Label, 'testColour', 'World', shelf1, true);
        OV_ContentProxy__c contentProxy1 = OV_TestingHelper.initContentProxy(null, 'testName', null, 'www.google.com', true);
        OV_Report__c report1 = OV_TestingHelper.initReportWithProxyAndUnit(testReportLabel, category1, function1, geography1, 'Tablet', contentProxy1.Id, unit1.Id, WEEKLYLABEL, 'Briefcase', 'TestHeading', 10, 'TestFolder', true);
        OV_ShelfTileReport__c shelfTileReport1 = OV_TestingHelper.initReportToShelfTile(report1, shelfTile1, true);

        Test.startTest();
            OV_ReportUsageService.saveUsageEntry(report1.Id, null, testOperationLabel, 'Tablet', '1');

            List<OV_Report_Usage__c> result = [
                SELECT
                    Operation__c,
                    Device_Type__c,
                    OneView_Report_Details_Category__c,
                    OneView_Report_Details_Code__c,
                    OneView_Report_Details_Frequency__c,
                    OneView_Report_Details_Geography__c,
                    OneView_Report_Details_Name__c,
                    OneView_Report_Details_Reporting_Period__c,
                    OneView_Report_Details_Unit_Code__c,
                    Shelf_Code__c,
                    Shelf_Name__c,
                    Shelf_Tile_Code__c,
                    Shelf_Tile_Name__c,
                    Unit_Unit_Name__c,
                    Unit_Unit_Type__c,
                    Source__c
                FROM OV_Report_Usage__c LIMIT 2000];

            System.assert( !result.isEmpty() );
            System.assert( result[0].Operation__c == testOperationLabel );
            System.assert( result[0].Device_Type__c == 'Tablet' );
            System.assert( result[0].OneView_Report_Details_Category__c == testCategoryLabel );
            System.assert( result[0].OneView_Report_Details_Code__c == String.valueOf(report1.Id));
            System.assert( result[0].OneView_Report_Details_Frequency__c == WEEKLYLABEL);
            System.assert( result[0].OneView_Report_Details_Geography__c == testGeographyLabel);
            System.assert( result[0].OneView_Report_Details_Name__c == testReportLabel);
            System.assert( result[0].OneView_Report_Details_Reporting_Period__c.startsWith('Week -'));
            System.assert( result[0].OneView_Report_Details_Unit_Code__c == String.valueOf(unit1.Id) );
            System.assert( result[0].Shelf_Code__c == testMyViewLabel );
            System.assert( result[0].Shelf_Name__c  == testMyViewLabel );
            System.assert( result[0].Shelf_Tile_Code__c  == testMyViewLabel );
            System.assert( result[0].Shelf_Tile_Name__c  == testMyViewLabel );
            System.assert( result[0].Unit_Unit_Name__c   == unit1.Name);
            System.assert( result[0].Unit_Unit_Type__c   == unit1.Type__c);
            System.assert( result[0].Source__c   == 'Favorite');


        Test.stopTest();
    }
}