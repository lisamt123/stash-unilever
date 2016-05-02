/**********************************************************************
Name: OV_RemoteController_Test
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Test Class test OV_RemoteController
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             25/05/2015      INITIAL DEVELOPMENT
**********************************************************************/
@isTest
private class OV_RemoteController_Test {
    public static final String TEST_EMAIL         = 'test@test.com';

    public static final String CATEGORY1LABEL        = 'Category 1';
    public static final String CATEGORY2LABEL        = 'Category 2';
    public static final String CATEGORY3LABEL        = 'Category 3';
    public static final String CATEGORY4LABEL        = 'Category 4';

    public static final String GEOGRAPHY1LABEL       = 'Geography 1';
    public static final String GEOGRAPHY2LABEL       = 'Geography 2';
    public static final String GEOGRAPHY3LABEL       = 'Geography 3';
    public static final String GEOGRAPHY4LABEL       = 'Geography 4';

    public static final String FUNCTION1LABEL        = 'Function 1';
    public static final String FUNCTION2LABEL        = 'Function 2';
    public static final String FUNCTION3LABEL        = 'Function 3';

    public static final String STRUCTURE_LABEL       = 'structure';

    public static final String REPORT1_LABEL         = 'Report 1';
    public static final String REPORT2_LABEL         = 'Report 2';
    public static final String REPORT3_LABEL         = 'Report 3';
    public static final String REPORT4_LABEL         = 'Report 4';
    public static final String REPORT5_LABEL         = 'Report 5';
    public static final String REPORT6_LABEL         = 'Report 6';
    public static final String REPORT7_LABEL         = 'Report 7';
    public static final String REPORT8_LABEL         = 'Report 7';
    public static final String REPORT9_LABEL         = 'Report 9';
    public static final String REPORT10_LABEL        = 'Report 10';
    public static final String REPORT11_LABEL        = 'Report 11';
    public static final String REPORT12_LABEL        = 'Report 12';

    public static final String DESKTOP_LABEL         = 'Desktop';

    public static final String SUBJECT_LABEL         = 'Subject';
    public static final String BRAND1_LABEL          = 'Brand 1';

    public static final String TEST_LABEL            = 'test';
    public static final String TEST1_LABEL           = 'test1';
    public static final String TEST2_LABEL           = 'test2';

    public static final String SAMPLE_URL            = 'www.salesforce.com';

    public static final String HEADING1_LABEL        = 'Heading1';
    public static final String HEADING2_LABEL        = 'Heading2';
    public static final String HEADING3_LABEL        = 'Heading3';
    public static final String HEADING4_LABEL        = 'Heading4';
    public static final String HEADING5_LABEL        = 'Heading5';
    public static final String HEADING6_LABEL        = 'Heading6';

    public static final String SAMPLE_IMAGE_URL      = 'www.test.com/image.png';

    public static final String SHELFS_LABEL          = 'shelfs';
    public static final String FOLDER1_LABEL         = 'Folder1';
    public static final String FOLDER2_LABEL         = 'Folder2';
    public static final String FOLDER3_LABEL         = 'Folder3';
    public static final String FOLDER4_LABEL         = 'Folder4';
    public static final String FOLDER5_LABEL         = 'Folder5';
    public static final String FOLDER6_LABEL         = 'Folder6';
    public static final String FOLDER7_LABEL         = 'Folder7';

    public static final String TILE1_LABEL           = 'Tile 1';
    public static final String TILE2_LABEL           = 'Tile 2';

    public static final String GRAY_COLOR           = '#ccc';

    public static final String PROFILE1_LABEL       = 'Profile1';

    @isTest static void searchServiceMethods() {
            User u = OV_TestingHelper.createAdminUser(TEST_LABEL, TEST_EMAIL, TEST2_LABEL);

            system.runAs(u){

            OV_Profile__c profile = new OV_Profile__c(User__c = u.Id);
            insert profile;

            OV_Brand__c brand1         = OV_TestingHelper.initBrand(BRAND1_LABEL, true);

            OV_Category__c category1   = OV_TestingHelper.initCategory(CATEGORY1LABEL, true);
            OV_Category__c category2   = OV_TestingHelper.initCategory(CATEGORY2LABEL, category1, true);
            OV_Category__c category3   = OV_TestingHelper.initCategory(CATEGORY3LABEL, category2, true);
            OV_Category__c category4   = OV_TestingHelper.initCategory(CATEGORY4LABEL, category3, true);

            OV_Geography__c geography1 = OV_TestingHelper.initGeography(GEOGRAPHY1LABEL, true);
            OV_Geography__c geography2 = OV_TestingHelper.initGeography(GEOGRAPHY2LABEL, geography1, true);
            OV_Geography__c geography3 = OV_TestingHelper.initGeography(GEOGRAPHY3LABEL, geography2, true);

            OV_Function__c function1   = OV_TestingHelper.initFunction(FUNCTION1LABEL, true);
            OV_Function__c function2   = OV_TestingHelper.initFunction(FUNCTION2LABEL, function1, true);
            OV_Function__c function3   = OV_TestingHelper.initFunction(FUNCTION3LABEL, function2, true);

            ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion('Test 1', true);
            ContentVersion contentVersion2 = OV_TestingHelper.initContentVersion('Test 2', true);

            ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];
            ContentDocument document2 = [select Id from ContentDocument where Id = :contentVersion2.ContentDocumentId limit 1][0];

            OV_ContentProxy__c proxy1 = OV_TestingHelper.initContentProxy(document1.Id, 'proxy test title1', contentVersion1.Id, SAMPLE_URL, true);
            OV_ContentProxy__c proxy2 = OV_TestingHelper.initContentProxy(document2.Id, 'proxy test title2', contentVersion2.Id, SAMPLE_URL, true);

            OV_Report__c report1       = OV_TestingHelper.initReportWithProxyHeaderFolder(REPORT1_LABEL, category1, function1, geography1, DESKTOP_LABEL, proxy1.Id, HEADING1_LABEL, FOLDER1_LABEL, true);
            OV_Report__c report2       = OV_TestingHelper.initReportWithProxyHeaderFolder(REPORT2_LABEL, category1, function1, geography1, DESKTOP_LABEL, proxy1.Id, HEADING1_LABEL, '', true);
            OV_Report__c report3       = OV_TestingHelper.initReportWithProxyHeaderFolder(REPORT3_LABEL, category1, function1, geography1, DESKTOP_LABEL, proxy1.Id, HEADING2_LABEL, FOLDER2_LABEL, true);
            OV_Report__c report4       = OV_TestingHelper.initReportWithProxyHeaderFolder(REPORT4_LABEL, category2, function2, geography2, DESKTOP_LABEL, proxy1.Id, HEADING2_LABEL, FOLDER2_LABEL, true);
            OV_Report__c report5       = OV_TestingHelper.initReportWithProxyHeaderFolder(REPORT5_LABEL, category2, function2, geography2, DESKTOP_LABEL, proxy1.Id, HEADING2_LABEL, FOLDER3_LABEL, true);
            OV_Report__c report6       = OV_TestingHelper.initReportWithProxyHeaderFolder(REPORT6_LABEL, category2, function2, geography2, DESKTOP_LABEL, proxy1.Id, HEADING2_LABEL, '', true);
            OV_Report__c report7       = OV_TestingHelper.initReportWithProxyHeaderFolder(REPORT7_LABEL, category3, function3, geography3, DESKTOP_LABEL, proxy2.Id, HEADING4_LABEL, FOLDER5_LABEL, true);
            OV_Report__c report8       = OV_TestingHelper.initReportWithProxyHeaderFolder(REPORT8_LABEL, category3, function3, geography3, DESKTOP_LABEL, proxy2.Id, HEADING4_LABEL, FOLDER5_LABEL, true);
            OV_Report__c report9       = OV_TestingHelper.initReportWithProxyHeaderFolder(REPORT9_LABEL, category4, function3, geography3, DESKTOP_LABEL, proxy2.Id, HEADING5_LABEL, FOLDER6_LABEL, true);
            OV_Report__c report10      = OV_TestingHelper.initReportWithProxyHeaderFolder(REPORT10_LABEL, category4, function3, geography3, DESKTOP_LABEL, proxy2.Id, HEADING6_LABEL, FOLDER7_LABEL, true);
            OV_Report__c report11       = OV_TestingHelper.initReportWithProxyHeaderFolder(REPORT1_LABEL, category1, function1, geography1, DESKTOP_LABEL, proxy1.Id, HEADING1_LABEL, '', true);
            OV_Report__c report12       = OV_TestingHelper.initReportWithProxyHeaderFolder(REPORT1_LABEL, category1, function1, geography1, DESKTOP_LABEL, proxy1.Id, HEADING1_LABEL, FOLDER1_LABEL, true);

            OV_Shelf__c shelf1         = OV_TestingHelper.initShelf('Shelf1', SUBJECT_LABEL, true);
            OV_Shelf__c shelf2         = OV_TestingHelper.initShelf('Shelf2', 'Moment', true);

            OV_Shelf_Tile__c tile1     = OV_TestingHelper.initShelfTile(TILE1_LABEL, GRAY_COLOR, SAMPLE_IMAGE_URL, shelf1, true);
            OV_Shelf_Tile__c tile2     = OV_TestingHelper.initShelfTile(TILE2_LABEL, GRAY_COLOR, SAMPLE_IMAGE_URL, shelf1, true);
            OV_Shelf_Tile__c tile3     = OV_TestingHelper.initShelfTile('Tile 3', GRAY_COLOR, SAMPLE_IMAGE_URL, shelf2, true);
            OV_Shelf_Tile__c tile4     = OV_TestingHelper.initShelfTile('Tile 4', GRAY_COLOR, SAMPLE_IMAGE_URL, shelf2, true);

            OV_ShelfTileReport__c connectReportToTile1 = OV_TestingHelper.initReportToShelfTile(report1, tile1, true);
            OV_ShelfTileReport__c connectReportToTile2 = OV_TestingHelper.initReportToShelfTile(report2, tile2, true);

            OV_ShelfTileReport__c connectReportToTile3 = OV_TestingHelper.initReportToShelfTile(report3, tile2, true);
            OV_ShelfTileReport__c connectReportToTile4 = OV_TestingHelper.initReportToShelfTile(report4, tile2, true);

            OV_ShelfTileReport__c connectReportToTile5 = OV_TestingHelper.initReportToShelfTile(report5, tile2, true);
            OV_ShelfTileReport__c connectReportToTile6 = OV_TestingHelper.initReportToShelfTile(report6, tile2, true);

            OV_ShelfTileReport__c connectReportToTile7 = OV_TestingHelper.initReportToShelfTile(report7, tile3, true);
            OV_ShelfTileReport__c connectReportToTile8 = OV_TestingHelper.initReportToShelfTile(report8, tile4, true);

            OV_ShelfTileReport__c connectReportToTile9 = OV_TestingHelper.initReportToShelfTile(report9, tile4, true);
            OV_ShelfTileReport__c connectReportToTile10 = OV_TestingHelper.initReportToShelfTile(report10, tile4, true);

            OV_ShelfTileReport__c connectReportToTile11 = OV_TestingHelper.initReportToShelfTile(report11, tile1, true);
            OV_ShelfTileReport__c connectReportToTile12 = OV_TestingHelper.initReportToShelfTile(report12, tile1, true);

            OV_Wrapper response1 = OV_RemoteController.search(geography1.Id, '', '', false, SUBJECT_LABEL, DESKTOP_LABEL, false);
            List<OV_Wrapper.ShelfWrapper> l = (List<OV_Wrapper.ShelfWrapper>) response1.data.get(SHELFS_LABEL);
            System.assertEquals(2, l[0].shelfTiles.size());

            OV_Wrapper response8 = OV_RemoteController.search(geography1.Id, '', '', false, SUBJECT_LABEL, TEST_LABEL, false);
            List<OV_Wrapper.ShelfWrapper> l2 = (List<OV_Wrapper.ShelfWrapper>) response8.data.get(SHELFS_LABEL);
            System.assertEquals(2, l2[0].shelfTiles.size());

            OV_Wrapper response2 = OV_RemoteController.search(TEST_LABEL, '', '', false, SUBJECT_LABEL, DESKTOP_LABEL, false);
            System.assertEquals(OV_RemoteController.EXCEPTION_CODE, response2.status);

            OV_Wrapper response3 = OV_RemoteController.getTileReports2('', '', '', false, SUBJECT_LABEL, tile1.Id, DESKTOP_LABEL);
            Map<String,Object> repList = (Map<String,Object>) response3.data.get(STRUCTURE_LABEL);
            System.assertEquals(1, repList.size());

            OV_Wrapper response9 = OV_RemoteController.getTileReports2('', '', '', false, SUBJECT_LABEL, tile1.Id, DESKTOP_LABEL);
            Map<String, Object> repMap = (Map<String, Object>) response9.data.get(STRUCTURE_LABEL);
            OV_Wrapper.FolderLevelWrapper heading = (OV_Wrapper.FolderLevelWrapper) repMap.get(report1.Report_Heading__c);
            System.assertEquals(2, heading.folderLevelMembers.size());

            OV_Wrapper response10 = OV_RemoteController.getTileReports2('', '', '', false, SUBJECT_LABEL, tile1.Id, DESKTOP_LABEL);
            Map<String, Object> repMap2 = (Map<String, Object>) response10.data.get(STRUCTURE_LABEL);
            OV_Wrapper.FolderLevelWrapper heading2 = (OV_Wrapper.FolderLevelWrapper) repMap2.get(report1.Report_Heading__c);
            OV_Wrapper.FolderWrapper folder = (OV_Wrapper.FolderWrapper)heading2.folderLevelMembers[0];
            System.assertEquals(FOLDER1_LABEL, folder.folderName);

            OV_Wrapper response7 = OV_RemoteController.getTileReports2('', '', '', false, SUBJECT_LABEL, tile1.Id, TEST_LABEL);
            Map<String,Object> repList2 = (Map<String,Object>) response7.data.get(STRUCTURE_LABEL);
            System.assertEquals(1, repList2.size());

            OV_Wrapper response5 = OV_RemoteController.getTileReports2(TEST_LABEL, '', '', false, TEST_LABEL, tile1.Id, DESKTOP_LABEL);
            System.assertEquals(OV_RemoteController.EXCEPTION_CODE, response5.status);

            delete report1;

            OV_Wrapper response6 = OV_RemoteController.getReport(report1.Id, '', DESKTOP_LABEL);
            System.assertEquals(OV_RemoteController.EXCEPTION_CODE, response6.status);
            }
    }

    @isTest static void kpiServiceMethods() {
        OV_Brand__c brand1                          = OV_TestingHelper.initBrand(BRAND1_LABEL, true);
        OV_Category__c category1                    = OV_TestingHelper.initCategory(CATEGORY1LABEL, true);
        OV_Comparator__c comparator1                = OV_TestingHelper.initBrandComparator('Comparator 1', true);
        OV_Function__c function1                    = OV_TestingHelper.initFunction(FUNCTION1LABEL, true);
        OV_Geography__c geography1                  = OV_TestingHelper.initGeography(GEOGRAPHY1LABEL, true);

        OV_KPI_Name__c kpiName1                     = OV_TestingHelper.initKPIName('KPIName1', true);
        OV_KPI_Name__c kpiName2                     = OV_TestingHelper.initKPIName('KPIName2', true);
        OV_Report__c report1                        = OV_TestingHelper.initReport(REPORT1_LABEL, category1, function1, geography1, DESKTOP_LABEL, true);
        OV_Report__c report2                        = OV_TestingHelper.initReport(REPORT2_LABEL, category1, function1, geography1, DESKTOP_LABEL, true);
        OV_Report__c report3                        = OV_TestingHelper.initReport(REPORT3_LABEL, category1, function1, geography1, DESKTOP_LABEL, true);
        OV_Report__c report4                        = OV_TestingHelper.initReport(REPORT4_LABEL, category1, function1, geography1, DESKTOP_LABEL, true);

        OV_Shelf__c shelf1                          = OV_TestingHelper.initShelf('Shelf1', SUBJECT_LABEL, true);

        OV_Shelf_Tile__c tile1                      = OV_TestingHelper.initShelfTile(TILE1_LABEL, GRAY_COLOR, SAMPLE_IMAGE_URL, shelf1, true);

        OV_ShelfTileReport__c connectReportToTile1  = OV_TestingHelper.initReportToShelfTile(report1, tile1, true);

        OV_KPI_Element__c kpiElement1               = OV_TestingHelper.initKPIElement('KPIElement1', brand1, comparator1, category1, 'UP', function1, geography1, kpiName1, 1.1, report1, 2.1, 'Week', true);
        OV_KPI_Element__c kpiElement2               = OV_TestingHelper.initKPIElement('KPIElement2', brand1, comparator1, category1, 'UP', function1, geography1, kpiName1, 1.1, report2, 2.1, 'Day', true);
        OV_KPI_Element__c kpiElement3               = OV_TestingHelper.initKPIElement('KPIElement3', brand1, comparator1, category1, 'UP', function1, geography1, kpiName1, 1.1, report3, 2.1, 'Day', true);

        User u                                      = OV_TestingHelper.createAdminUser(TEST_LABEL, TEST_EMAIL, TEST2_LABEL);
        OV_Profile__c profile                       = OV_TestingHelper.initProfile(PROFILE1_LABEL, u, true);

        OV_Wrapper response1                        = OV_RemoteController.getKPINames();
        List<OV_Wrapper.KPINameWrapper> repList     = (List<OV_Wrapper.KPINameWrapper>) response1.data.get('kpiNames');
        System.assertEquals(2, repList.size());

        OV_Wrapper response2                        = OV_RemoteController.getKPIReports(kpiName1.Id);
        List<OV_Wrapper.ReportWrapper> repList2     = (List<OV_Wrapper.ReportWrapper>) response2.data.get('kpiReports');
        System.assertEquals(3, repList2.size());

        OV_Wrapper response3                        = OV_RemoteController.getKPIElements(kpiName1.Id, report1.Id);
        List<OV_Wrapper.KPIElementWrapper> repList3 = (List<OV_Wrapper.KPIElementWrapper>) response3.data.get('kpiElements');
        System.assertEquals(1, repList3.size());

        OV_Wrapper response4;
        System.runAs(u){
            response4 = OV_RemoteController.addKPIElementToMyKPIs(kpiElement1.Id, true);
        }
        System.assertEquals(OV_RemoteController.SUCCESS_CODE, response4.Status);

        OV_Wrapper response5;
        System.runAs(u){
            response5 = OV_RemoteController.getMyKPIElements(geography1.Id, category1.Id, function1.Id, false);
        }
        System.assertEquals(OV_RemoteController.SUCCESS_CODE, response5.Status);

        List<OV_Wrapper.KPIElementWrapper> repList4 = (List<OV_Wrapper.KPIElementWrapper>) response5.data.get('kpiElements');
        System.assertEquals(1, repList4.size());

        OV_Wrapper response9;
        System.runAs(u){
            response9 = OV_RemoteController.deleteMyKPI(kpiElement1.Id);
        }
        System.assertEquals(OV_RemoteController.SUCCESS_CODE, response9.Status);

        OV_Wrapper response6 = OV_RemoteController.getKPIReports(TEST_LABEL);
        System.assertEquals(OV_RemoteController.EXCEPTION_CODE, response6.Status);

        delete kpiName1;
        OV_Wrapper response7 = OV_RemoteController.getKPIElements(TEST_LABEL, report1.Id);
        System.assertEquals(OV_RemoteController.EXCEPTION_CODE, response7.Status);

        OV_Wrapper response8;
        System.runAs(u){
            response8 = OV_RemoteController.addKPIElementToMyKPIs(TEST_LABEL, true);
        }
        System.assertEquals(OV_RemoteController.EXCEPTION_CODE, response8.Status);

        delete report2;

        OV_Wrapper response10;
        System.runAs(u){
            response10 = OV_RemoteController.addReportToFavourites('1111111111', '');
        }
        System.assertEquals(OV_RemoteController.EXCEPTION_CODE, response10.Status);


        OV_Wrapper response11;
        System.runAs(u){
            response11 = OV_RemoteController.addReportToFavourites(report1.Id, tile1.Id);
        }
        System.assertEquals(OV_RemoteController.SUCCESS_CODE, response11.Status);

        OV_Wrapper response12;
        System.runAs(u){
            response12 = OV_RemoteController.deleteReportFromFavourites(report1.Id);
        }
        System.assertEquals(OV_RemoteController.SUCCESS_CODE, response12.Status);

        //OV_Wrapper response13;
        //System.runAs(u){
        //    response13 = OV_RemoteController.deleteReportFromFavourites('1111111111');
        //}
        //System.assertEquals(OV_RemoteController.EXCEPTION_CODE, response13.Status);

        OV_Wrapper response14;
        System.runAs(u){
            response14 = OV_RemoteController.getMyFavouritesReports(geography1.Id, category1.Id, function1.Id, true, DESKTOP_LABEL);
        }
        System.assertEquals(OV_RemoteController.SUCCESS_CODE, response14.Status);

        OV_Wrapper response15;
        System.runAs(u){
            response15 = OV_RemoteController.getMyFavouritesReports(geography1.Id, category1.Id, function1.Id, true, TEST_LABEL);
        }
        System.assertEquals(OV_RemoteController.SUCCESS_CODE, response15.Status);

        OV_Wrapper response17;
        System.runAs(u){
            response17 = OV_RemoteController.getFilters();
        }
        System.assertEquals(OV_RemoteController.SUCCESS_CODE, response17.Status);

        OV_Wrapper response18;
        System.runAs(u){
            response18 = OV_RemoteController.deleteMyKPI(TEST_LABEL);
        }
        System.assertEquals(OV_RemoteController.EXCEPTION_CODE, response18.Status);

        OV_Wrapper response19;
        System.runAs(u){
            response19 = OV_RemoteController.getMyFavouritesReports('111', '222', '333', true, DESKTOP_LABEL);
        }
        System.assertEquals(OV_RemoteController.EXCEPTION_CODE, response19.Status);
    }

    @isTest static void increaseViewCounterMethod() {
        OV_Category__c category1                    = OV_TestingHelper.initCategory(CATEGORY1LABEL, true);
        OV_Function__c function1                    = OV_TestingHelper.initFunction(FUNCTION1LABEL, true);
        OV_Geography__c geography1                  = OV_TestingHelper.initGeography(GEOGRAPHY1LABEL, true);
        OV_Report__c report1                        = OV_TestingHelper.initReport(REPORT1_LABEL, category1, function1, geography1, DESKTOP_LABEL, true);

        User u                                      = OV_TestingHelper.createAdminUser(TEST_LABEL, TEST_EMAIL, TEST2_LABEL);
        OV_Profile__c profile                       = OV_TestingHelper.initProfile(PROFILE1_LABEL, u, true);

        OV_Wrapper response;
        System.runAs(u) {
            System.assertEquals(0, [Select Views__c from OV_Report__c where Id = :report1.Id].Views__c);
            response = OV_RemoteController.increaseViewsCounter(report1.Id);
            System.assertEquals(1, [Select Views__c from OV_Report__c where Id = :report1.Id].Views__c);
            System.assertEquals(OV_RemoteController.SUCCESS_CODE, response.Status);
        }

        System.runAs(u) {
            response = OV_RemoteController.increaseViewsCounter('111111');
            System.assertEquals(OV_RemoteController.EXCEPTION_CODE, response.Status);
        }
    }

    @isTest static void searchServiceWithSavedFiltersMethods() {
        User u                                      = OV_TestingHelper.createAdminUser(TEST_LABEL, TEST_EMAIL, TEST2_LABEL);
        OV_Profile__c profile                       = OV_TestingHelper.initProfile(PROFILE1_LABEL, u, true);

        System.runAs(u){
            OV_Category__c category1   = OV_TestingHelper.initCategory(CATEGORY1LABEL, true);
            OV_Category__c category2   = OV_TestingHelper.initCategory(CATEGORY2LABEL, category1, true);
            OV_Category__c category3   = OV_TestingHelper.initCategory(CATEGORY3LABEL, category2, true);
            OV_Category__c category4   = OV_TestingHelper.initCategory(CATEGORY4LABEL, category3, true);

            OV_Geography__c geography1 = OV_TestingHelper.initGeography(GEOGRAPHY1LABEL, true);
            OV_Geography__c geography2 = OV_TestingHelper.initGeography(GEOGRAPHY2LABEL, geography1, true);
            OV_Geography__c geography3 = OV_TestingHelper.initGeography(GEOGRAPHY3LABEL, geography2, true);

            OV_Function__c function1   = OV_TestingHelper.initFunction(FUNCTION1LABEL, true);
            OV_Function__c function2   = OV_TestingHelper.initFunction(FUNCTION2LABEL, function1, true);
            OV_Function__c function3   = OV_TestingHelper.initFunction(FUNCTION3LABEL, function2, true);

            ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion('Test 1', true);
            ContentVersion contentVersion2 = OV_TestingHelper.initContentVersion('Test 2', true);

            ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];
            ContentDocument document2 = [select Id from ContentDocument where Id = :contentVersion2.ContentDocumentId limit 1][0];

            OV_ContentProxy__c proxy1 = OV_TestingHelper.initContentProxy(document1.Id, 'proxy test title1', contentVersion1.Id, SAMPLE_URL, true);

            OV_Report__c report1       = OV_TestingHelper.initReportWithProxyHeaderFolder(REPORT1_LABEL, category1, function1, geography1, DESKTOP_LABEL, proxy1.Id, HEADING1_LABEL, FOLDER1_LABEL, true);
            OV_Report__c report2       = OV_TestingHelper.initReportWithProxyHeaderFolder(REPORT2_LABEL, category2, function2, geography2, DESKTOP_LABEL, proxy1.Id, HEADING1_LABEL, '', true);

            OV_Shelf__c shelf1         = OV_TestingHelper.initShelf('Shelf1', SUBJECT_LABEL, true);

            OV_Shelf_Tile__c tile1     = OV_TestingHelper.initShelfTile(TILE1_LABEL, GRAY_COLOR, SAMPLE_IMAGE_URL, shelf1, true);
            OV_Shelf_Tile__c tile2     = OV_TestingHelper.initShelfTile(TILE1_LABEL, GRAY_COLOR, SAMPLE_IMAGE_URL, shelf1, true);

            OV_ShelfTileReport__c connectReportToTile1 = OV_TestingHelper.initReportToShelfTile(report1, tile1, true);
            OV_ShelfTileReport__c connectReportToTile2 = OV_TestingHelper.initReportToShelfTile(report2, tile2, true);

            OV_Wrapper response1 = OV_RemoteController.search('', '', '', false, SUBJECT_LABEL, DESKTOP_LABEL, false);
            List<OV_Wrapper.ShelfWrapper> l = (List<OV_Wrapper.ShelfWrapper>) response1.data.get(SHELFS_LABEL);
            System.assertEquals(2, l[0].shelfTiles.size());

            OV_Wrapper response2 = OV_RemoteController.search(geography2.Id, '', '', false, SUBJECT_LABEL, DESKTOP_LABEL, false);
            List<OV_Wrapper.ShelfWrapper> l2 = (List<OV_Wrapper.ShelfWrapper>) response2.data.get(SHELFS_LABEL);
            System.assertEquals(1, l2[0].shelfTiles.size());

            OV_Wrapper response3 = OV_RemoteController.search('', '', '', false, SUBJECT_LABEL, DESKTOP_LABEL, true);
            List<OV_Wrapper.ShelfWrapper> l3 = (List<OV_Wrapper.ShelfWrapper>) response3.data.get(SHELFS_LABEL);
            System.assertEquals(1, l3[0].shelfTiles.size());
        }
    }


    @isTest static void searchSaveUsageEntry(){
        //preparation of data
        OV_Category__c category1 = OV_TestingHelper.initCategory('testCategory', true);
        OV_Function__c function1 = OV_TestingHelper.initFunction('testFunction', null, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography('testGeography', true);
        OV_Unit__c unit1 = OV_TestingHelper.initUnitWithType(TEST1_LABEL, CATEGORY1LABEL, true);
        OV_Shelf__c shelf1 = OV_TestingHelper.initShelfWithColour(TEST1_LABEL, 'color1', 'Moment', true);
        OV_Shelf_Tile__c shelfTile1 = OV_TestingHelper.initShelfTile(TEST1_LABEL, 'testColour', 'World', shelf1, true);
        OV_ContentProxy__c contentProxy1 = OV_TestingHelper.initContentProxy(null, 'testName', null, SAMPLE_URL, true);
        OV_Report__c report1 = OV_TestingHelper.initReportWithProxyAndUnit('testReport', category1, function1, geography1, DESKTOP_LABEL, contentProxy1.Id, unit1.Id, 'Weekly', 'Briefcase', 'TestHeading', 10, 'TestFolder', true);
        OV_ShelfTileReport__c shelfTileReport1 = OV_TestingHelper.initReportToShelfTile(report1, shelfTile1, true);

        Test.startTest();
            OV_Wrapper result = OV_RemoteController.saveUsageEntry(report1.Id, String.valueOf(shelfTile1.Id), 'testOperation', DESKTOP_LABEL, '1');

            List<OV_Report_Usage__c> resultQuery = [
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
                    Unit_Unit_Type__c
                FROM OV_Report_Usage__c LIMIT 2000];

            System.assert( !resultQuery.isEmpty() );
            System.assert( result.message == 'Results' );
            System.assert( result.status == '0' );

        Test.stopTest();
    }

    @isTest static void privilegesHelper(){
        //preparation of data
        OV_Category__c category1 = OV_TestingHelper.initCategory('testCategory', true);
        OV_Function__c function1 = OV_TestingHelper.initFunction('testFunction', null, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography('testGeography', true);
        OV_Unit__c unit1 = OV_TestingHelper.initUnitWithType(TEST1_LABEL, CATEGORY1LABEL, true);
        OV_Shelf__c shelf1 = OV_TestingHelper.initShelfWithColour(TEST1_LABEL, 'color1', 'Moment', true);
        OV_Shelf_Tile__c shelfTile1 = OV_TestingHelper.initShelfTile(TEST1_LABEL, 'testColour', 'World', shelf1, true);
        OV_ContentProxy__c contentProxy1 = OV_TestingHelper.initContentProxy(null, 'testName', null, SAMPLE_URL, true);
        OV_Report__c report1 = OV_TestingHelper.initReportWithProxyAndUnit('testReport', category1, function1, geography1, DESKTOP_LABEL, contentProxy1.Id, unit1.Id, 'Weekly', 'Briefcase', 'TestHeading', 10, 'TestFolder', true);
        OV_ShelfTileReport__c shelfTileReport1 = OV_TestingHelper.initReportToShelfTile(report1, shelfTile1, true);

        OV_Brand__c brand1         = OV_TestingHelper.initBrand(BRAND1_LABEL, true);
        OV_Comparator__c comparator1                = OV_TestingHelper.initBrandComparator('Comparator 1', true);

        OV_KPI_Name__c kpiName1                     = OV_TestingHelper.initKPIName('KPIName1', true);
        OV_KPI_Element__c kpiElement1               = OV_TestingHelper.initKPIElement('KPIElement1', brand1, comparator1, category1, 'UP', function1, geography1, kpiName1, 1.1, report1, 2.1, 'Week', true);


        Profile p = OV_TestingHelper.getUserProfile();
        User u  = OV_TestingHelper.createUser(p, TEST_LABEL, TEST_EMAIL, TEST2_LABEL);
        System.runAs(u) {
            OV_Wrapper response1 = OV_RemoteController.search(geography1.Id, '', '', false, SUBJECT_LABEL, DESKTOP_LABEL, false);
            System.assertEquals(response1.status, '-1');

            OV_Wrapper response2 = OV_RemoteController.getTileReports2('', '', '', false, SUBJECT_LABEL, shelfTile1.Id, DESKTOP_LABEL);
            System.assertEquals(response2.status, '-1');

            OV_Wrapper response3 = OV_RemoteController.getReport(report1.Id, shelfTile1.Id, DESKTOP_LABEL);
            System.assertEquals(response3.status, '-1');

            OV_Wrapper response4 = OV_RemoteController.getKPIReports(kpiName1.Id);
            System.assertEquals(response4.status, '-1');

            OV_Wrapper response5 = OV_RemoteController.getKPIElements(kpiName1.Id, report1.Id);
            System.assertEquals(response5.status, '-1');

            OV_Wrapper response6 = OV_RemoteController.addKPIElementToMyKPIs(kpiElement1.Id, true);
            System.assertEquals(response6.status, '-1');

            OV_Wrapper response7 = OV_RemoteController.deleteMyKPI(kpiElement1.Id);
            System.assertEquals(response7.status, '-1');

            OV_Wrapper response8 = OV_RemoteController.getMyKPIElements(geography1.Id, category1.Id, function1.Id, false);
            System.assertEquals(response8.status, '-1');

            OV_Wrapper response9 = OV_RemoteController.addReportToFavourites(report1.Id, shelfTile1.Id);
            System.assertEquals(response9.status, '-1');

            OV_Wrapper response10 = OV_RemoteController.deleteReportFromFavourites(report1.Id);
            System.assertEquals(response10.status, '-1');

            OV_Wrapper response11 = OV_RemoteController.getMyFavouritesReports(geography1.Id, category1.Id, function1.Id, false, DESKTOP_LABEL);
            System.assertEquals(response11.status, '-1');

            OV_Wrapper response12 = OV_RemoteController.increaseViewsCounter(report1.Id);
            System.assertEquals(response12.status, '-1');

            OV_Wrapper response13 = OV_RemoteController.saveUsageEntry(report1.Id, shelfTile1.Id, 'download', DESKTOP_LABEL, '2');
            System.assertEquals(response13.status, '-1');

        }

    }
}