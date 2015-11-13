@isTest
private class OV_NewShelfTileReportController_Test {
    static final String titleLabel = 'proxy test title';
    static final String mobileLabel = 'mobile';

    public static final String SAMPLE_URL            = 'www.salesforce.com';
    
    @isTest static void testWithShelfTileReport() {
        OV_Category__c category1 = OV_TestingHelper.initCategory('Category 1', true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography('Geography 1', true);
        OV_Function__c function1 = OV_TestingHelper.initFunction('Function 1', true);

        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion('Test 1', true);
        ContentVersion contentVersion2 = OV_TestingHelper.initContentVersion('Test 2', true);
        ContentVersion contentVersion3 = OV_TestingHelper.initContentVersion('Test 3', true);

        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];
        ContentDocument document2 = [select Id from ContentDocument where Id = :contentVersion2.ContentDocumentId limit 1][0];
        ContentDocument document3 = [select Id from ContentDocument where Id = :contentVersion3.ContentDocumentId limit 1][0];
        
        OV_ContentProxy__c proxy1 = OV_TestingHelper.initContentProxy(document1.Id, titleLabel, contentVersion1.Id, SAMPLE_URL, true);
        OV_ContentProxy__c proxy2 = OV_TestingHelper.initContentProxy(document2.Id, titleLabel, contentVersion2.Id, SAMPLE_URL, true);

        OV_Unit__C unit = OV_TestingHelper.initUnit('test2', true);

        OV_Report__c report1 = OV_TestingHelper.initReportWithProxy('Report 1', category1, function1, geography1, mobileLabel, proxy1.Id, true);
        report1.Unit__c = unit.Id;
        OV_Report__c report2 = OV_TestingHelper.initReportWithProxy('Report 2', category1, function1, geography1, mobileLabel, proxy2.Id, true);
        report2.Unit__c = unit.Id;

        OV_Shelf__c shelf1 = OV_TestingHelper.initShelf('Shelf1', 'Subject', true);
        OV_Shelf_Tile__c tile1 = OV_TestingHelper.initShelfTile('Tile 1', '#ccc', 'www.test.com/image.png', shelf1, true);

        OV_ShelfTileReport__c connectReportToTile1 = OV_TestingHelper.initReportToShelfTile(report1, tile1, true);
        OV_ShelfTileReport__c connectReportToTile2 = OV_TestingHelper.initReportToShelfTile(report2, tile1, false);

        ApexPages.StandardController sc = new ApexPages.StandardController(connectReportToTile1);
        OV_NewShelfTileReportController controller = new OV_NewShelfTileReportController(sc);
        controller.calculateSortOrder();

        System.assertEquals(2, controller.record.Sort_Order__c);
    }
    
    @isTest
    static void testWithoutShelfTileReport() {
        OV_Category__c category1 = OV_TestingHelper.initCategory('Category 1', true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography('Geography 1', true);
        OV_Function__c function1 = OV_TestingHelper.initFunction('Function 1', true);

        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion('Test 1', true);
        ContentVersion contentVersion2 = OV_TestingHelper.initContentVersion('Test 2', true);
        ContentVersion contentVersion3 = OV_TestingHelper.initContentVersion('Test 3', true);

        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];
        ContentDocument document2 = [select Id from ContentDocument where Id = :contentVersion2.ContentDocumentId limit 1][0];
        ContentDocument document3 = [select Id from ContentDocument where Id = :contentVersion3.ContentDocumentId limit 1][0];
        
        OV_ContentProxy__c proxy1 = OV_TestingHelper.initContentProxy(document1.Id, titleLabel, contentVersion1.Id, SAMPLE_URL, true);
        OV_ContentProxy__c proxy2 = OV_TestingHelper.initContentProxy(document2.Id, titleLabel, contentVersion2.Id, SAMPLE_URL, true);

        
        OV_Report__c report1 = OV_TestingHelper.initReportWithProxy('Report 1', category1, function1, geography1, mobileLabel, proxy1.Id, false);

        OV_Shelf__c shelf1 = OV_TestingHelper.initShelf('Shelf1', 'Subject', true);
        OV_Shelf_Tile__c tile1 = OV_TestingHelper.initShelfTile('Tile 1', '#ccc', 'www.test.com/image.png', shelf1, true);

        OV_ShelfTileReport__c connectReportToTile1 = OV_TestingHelper.initReportToShelfTile(report1, tile1, false);

        ApexPages.StandardController sc = new ApexPages.StandardController(connectReportToTile1);
        OV_NewShelfTileReportController controller = new OV_NewShelfTileReportController(sc);

        System.assertEquals(1, controller.record.Sort_Order__c);
    }

    @isTest
    static void testWithShelfTileReportInFolderAndOnHeading() {
        OV_Category__c category1 = OV_TestingHelper.initCategory('Category 1', true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography('Geography 1', true);
        OV_Function__c function1 = OV_TestingHelper.initFunction('Function 1', true);

        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion('Test 1', true);
        ContentVersion contentVersion2 = OV_TestingHelper.initContentVersion('Test 2', true);
        ContentVersion contentVersion3 = OV_TestingHelper.initContentVersion('Test 3', true);

        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];
        ContentDocument document2 = [select Id from ContentDocument where Id = :contentVersion2.ContentDocumentId limit 1][0];
        ContentDocument document3 = [select Id from ContentDocument where Id = :contentVersion3.ContentDocumentId limit 1][0];
        
        OV_ContentProxy__c proxy1 = OV_TestingHelper.initContentProxy(document1.Id, titleLabel, contentVersion1.Id, SAMPLE_URL, true);
        OV_ContentProxy__c proxy2 = OV_TestingHelper.initContentProxy(document2.Id, titleLabel, contentVersion2.Id, SAMPLE_URL, true);

        OV_Unit__C unit = OV_TestingHelper.initUnit('test2', true);

        OV_Report__c report1 = OV_TestingHelper.initReportWithProxy('Report 1', category1, function1, geography1, mobileLabel, proxy1.Id, true);
        report1.Report_Heading__c = 'Global';
        report1.Report_Folder__c = 'Skin Care';
        report1.Unit__c = unit.Id;
        update report1;
       
        OV_Report__c report2 = OV_TestingHelper.initReportWithProxy('Report 2', category1, function1, geography1, mobileLabel, proxy2.Id, true);
        report2.Report_Heading__c = 'Global';
        report2.Report_Folder__c = 'Skin Care';
        report2.Unit__c = unit.Id;
        update report2;
       
        OV_Shelf__c shelf1 = OV_TestingHelper.initShelf('Shelf1', 'Subject', true);
        OV_Shelf_Tile__c tile1 = OV_TestingHelper.initShelfTile('Tile 1', '#ccc', 'www.test.com/image.png', shelf1, true);

        OV_ShelfTileReport__c connectReportToTile1 = OV_TestingHelper.initReportToShelfTile(report1, tile1, true);
        OV_ShelfTileReport__c connectReportToTile2 = OV_TestingHelper.initReportToShelfTile(report2, tile1, false);

        ApexPages.StandardController sc = new ApexPages.StandardController(connectReportToTile2);
        OV_NewShelfTileReportController controller = new OV_NewShelfTileReportController(sc);
        controller.calculateSortOrder();
        System.assertEquals(2, controller.record.Sort_Order__c);

        controller.record.Report__c = null;
        controller.calculateSortOrder();        
        System.assertEquals(null, controller.record.Sort_Order__c);
    }
}