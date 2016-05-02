/**********************************************************************
Name: OV_FilePreviewController_Test
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Test Class test OV_FilePreviewController
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             19/06/2015      INITIAL DEVELOPMENT
**********************************************************************/
@isTest
private class OV_FilePreviewController_Test {   
    static final String testLabel1 = 'test1';
    static final String testLabel2 = 'test2';
    
    @isTest static void checkVersion() {
        ContentVersion cObject = OV_TestingHelper.initContentVersion(testLabel1, true);
        ApexPages.currentPage().getParameters().put('contentDocumentId', cObject.ContentDocumentId);

        OV_FilePreviewController controller = new OV_FilePreviewController();
        controller.changeVersion();

        System.assertEquals(cObject.ContentDocumentId, controller.contentVersionsList[0].ContentDocumentId);
        System.assertEquals(cObject.Id, controller.currentContentVersionId);        
    }
    
    @isTest static void testLogDownload() {     
        //preparation of data       
        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion(testLabel1, true);     
        
        OV_Category__c category1 = OV_TestingHelper.initCategory('testCategory', true);
        OV_Function__c function1 = OV_TestingHelper.initFunction('testFunction', null, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography('testGeography', true);
        OV_Unit__c unit1 = OV_TestingHelper.initUnitWithType(testLabel2, 'Category 1', true);
        OV_Shelf__c shelf1 = OV_TestingHelper.initShelfWithColour(testLabel2, 'color1', 'Moment', true);
        OV_Shelf_Tile__c shelfTile1 = OV_TestingHelper.initShelfTile(testLabel2, 'testColour', 'World', shelf1, true);
        OV_ContentProxy__c contentProxy1 = OV_TestingHelper.initContentProxy(contentVersion1.ContentDocumentId, 'testName', contentVersion1.Id, 'www.google.com', true);
        OV_Report__c report1 = OV_TestingHelper.initReportWithProxyAndUnit('testReport', category1, function1, geography1, 'Desktop', contentProxy1.Id, unit1.Id, 'Weekly', 'Briefcase', 'TestHeading', 10, 'TestFolder', true);        
        OV_ShelfTileReport__c shelfTileReport1 = OV_TestingHelper.initReportToShelfTile(report1, shelfTile1, true);
        
        ApexPages.currentPage().getParameters().put('shelfTileId', shelfTile1.Id);
        ApexPages.currentPage().getParameters().put('reportId', report1.Id);
        OV_FilePreviewController controller = new OV_FilePreviewController();
        controller.currentContentVersionId = contentVersion1.Id;
        
        Test.startTest();
            
            PageReference result = controller.logDownload();
            
            System.assert( result == null);
            System.assert( [SELECT Id FROM OV_Report_Usage__c LIMIT 1].size() == 1 );
        
        Test.stopTest();
        controller.changeVersion();
    }
    
    @isTest static void testLogDownloadWithoutShelfTile() {
        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion('test', true);
        
        OV_Category__c category1 = OV_TestingHelper.initCategory('testCategory', true);
        OV_Function__c function1 = OV_TestingHelper.initFunction('testFunction', null, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography('testGeography', true);
        OV_Unit__c unit1 = OV_TestingHelper.initUnitWithType(testLabel2, 'Category 1', true);
        OV_Shelf__c shelf1 = OV_TestingHelper.initShelfWithColour(testLabel2, 'color1', 'Moment', true);
        OV_Shelf_Tile__c shelfTile1 = OV_TestingHelper.initShelfTile(testLabel2, 'testColour', 'World', shelf1, true);
        OV_ContentProxy__c contentProxy1 = OV_TestingHelper.initContentProxy(contentVersion1.ContentDocumentId, 'testName', contentVersion1.Id, 'www.google.com', true);
        OV_Report__c report1 = OV_TestingHelper.initReportWithProxyAndUnit('testReport', category1, function1, geography1, 'Desktop', contentProxy1.Id, unit1.Id, 'Weekly', 'Briefcase', 'TestHeading', 10, 'TestFolder', true);        
        OV_ShelfTileReport__c shelfTileReport1 = OV_TestingHelper.initReportToShelfTile(report1, shelfTile1, true);
        
        //ApexPages.currentPage().getParameters().put('shelfTileId', shelfTile1.Id);
        ApexPages.currentPage().getParameters().put('reportId', report1.Id);
        OV_FilePreviewController controller = new OV_FilePreviewController();
        controller.currentContentVersionId = contentVersion1.Id;
        
        Test.startTest();
            
            PageReference result = controller.logDownload();
            
            System.assert( result == null);
            System.assert( [SELECT Id FROM OV_Report_Usage__c LIMIT 1].size() == 1 );
        
        Test.stopTest();
    }
}