@isTest
private class OV_SearchService2_Test {
    public static final String testLabel = 'test';
    public static final String titleLabel = 'proxy test title';
    public static final String subjectsLabel = 'Subjects';

    public static final String SAMPLE_URL            = 'www.salesforce.com';
    public static final String SAMPLE_IMAGE_URL      = 'www.test.com/image.png';

    public static final String REPORT1_LABEL         = 'Report 1';
    public static final String REPORT2_LABEL         = 'Report 2';
    public static final String REPORT3_LABEL         = 'Report 3';
    public static final String REPORT4_LABEL         = 'Report 4';
    public static final String REPORT5_LABEL         = 'Report 5';
    public static final String REPORT6_LABEL         = 'Report 6';

    public static final String MOBILE_LABEL         = 'Mobile';
    public static final String TABLET_LABEL         = 'Tablet';
    public static final String DESKTOP_LABEL        = 'Desktop';
        
    public static final String COLOR_LABEL        = '#ccc';
    public static final String SUBJECT_LABEL        = 'Subject';
    
    @isTest
    static void testDeviceVisibility() {
        User u = OV_TestingHelper.createAdminUser(testLabel, 'test@test.com', 'test2');
        system.runAs(u){
        
        OV_Profile__c profile = new OV_Profile__c(User__c = u.Id);
        insert profile;
        OV_Category__c category1 = OV_TestingHelper.initCategory('Category 1', true);
        OV_Category__c category2 = OV_TestingHelper.initCategory('Category 2', category1, true);
        OV_Category__c category3 = OV_TestingHelper.initCategory('Category 3', category2, true);
        OV_Category__c category4 = OV_TestingHelper.initCategory('Category 4', category3, true);

        OV_Geography__c geography1 = OV_TestingHelper.initGeography('Geography 1', true);
        OV_Geography__c geography2 = OV_TestingHelper.initGeography('Geography 2', geography1, true);
        OV_Geography__c geography3 = OV_TestingHelper.initGeography('Geography 3', geography2, true);

        OV_Function__c function1 = OV_TestingHelper.initFunction('Function 1', true);

        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion('Test 1', true);

        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];
        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, 'proxy test title', contentVersion1.Id, SAMPLE_URL, true);

        OV_Report__c report1 = OV_TestingHelper.initReportWithProxy(REPORT1_LABEL, category1, function1, geography1, DESKTOP_LABEL, proxy.Id, true);
        OV_Report__c report2 = OV_TestingHelper.initReportWithProxy(REPORT2_LABEL, category1, function1, geography1, MOBILE_LABEL, proxy.Id, true);
        OV_Report__c report3 = OV_TestingHelper.initReportWithProxy(REPORT3_LABEL, category1, function1, geography1, TABLET_LABEL, proxy.Id, true);

        OV_Shelf__c shelf1 = OV_TestingHelper.initShelf('Shelf1', SUBJECT_LABEL, true);
        OV_Shelf_Tile__c tile1 = OV_TestingHelper.initShelfTile('Tile 1', COLOR_LABEL, SAMPLE_IMAGE_URL, shelf1, true);

        OV_ShelfTileReport__c connectReportToTile1 = OV_TestingHelper.initReportToShelfTile(report1, tile1, true);
        OV_ShelfTileReport__c connectReportToTile2 = OV_TestingHelper.initReportToShelfTile(report2, tile1, true);
        OV_ShelfTileReport__c connectReportToTile3 = OV_TestingHelper.initReportToShelfTile(report3, tile1, true);

        List<OV_Wrapper.ShelfWrapper> result1 = OV_SearchService2.search(geography1.Id, '', '', false, SUBJECT_LABEL, DESKTOP_LABEL);
        System.assertEquals(1, result1.size());

        List<OV_Wrapper.ShelfWrapper> result2 = OV_SearchService2.search(geography1.Id, category1.Id, function1.Id, false, SUBJECT_LABEL, MOBILE_LABEL);
        System.assertEquals(1, result2.size());

        List<OV_Wrapper.ShelfWrapper> result3 = OV_SearchService2.search(geography1.Id, '', '', true, SUBJECT_LABEL, TABLET_LABEL);
        System.assertEquals(1, result3.size());

        //invalid parameters check
        try {
            List<OV_Wrapper.ShelfWrapper> result5 = OV_SearchService2.search(geography1.Id, 'aaaaaaa', '', true, SUBJECT_LABEL, DESKTOP_LABEL);
        }
        catch(Exception e) {
            system.assert(e.getMessage().contains('Invalid parameters to build query'));
        }
        /*
        List<OV_Wrapper.ReportWrapper> reportList1 = OV_SearchService2.getTileReports(geography1.Id, '', '', false, SUBJECT_LABEL, result1[0].shelfTiles[0].shelfTileId, DESKTOP_LABEL);
        System.assertEquals(1, reportList1.size());

        List<OV_Wrapper.ReportWrapper> reportList2 = OV_SearchService2.getTileReports(geography1.Id, '', '', false, SUBJECT_LABEL, result1[0].shelfTiles[0].shelfTileId, TABLET_LABEL);
        System.assertEquals(1, reportList2.size());

        List<OV_Wrapper.ReportWrapper> reportList3 = OV_SearchService2.getTileReports(geography1.Id, '', '', false, SUBJECT_LABEL, result1[0].shelfTiles[0].shelfTileId, MOBILE_LABEL);
        System.assertEquals(1, reportList3.size());
        */
        //test getTileReports2 method
        Map<String, Object> reportMap1 = OV_SearchService2.getTileReports2(geography1.Id, '', '', false, SUBJECT_LABEL, result1[0].shelfTiles[0].shelfTileId, DESKTOP_LABEL);
        System.assertEquals(1, reportMap1.keySet().size());

        Map<String, Object> reportMap2 = OV_SearchService2.getTileReports2(geography1.Id, '', '', false, SUBJECT_LABEL, result1[0].shelfTiles[0].shelfTileId, TABLET_LABEL);
        System.assertEquals(1, reportMap2.keySet().size());

        Map<String, Object> reportMap3 = OV_SearchService2.getTileReports2(geography1.Id, '', '', false, SUBJECT_LABEL, result1[0].shelfTiles[0].shelfTileId, MOBILE_LABEL);
        System.assertEquals(1, reportMap3.keySet().size());

        //change proxy setting to test static part of methods getTileReports/getTileReports2
        proxy.Url__c = null;
        update proxy;
        /*
        List<OV_Wrapper.ReportWrapper> reportList4 = OV_SearchService2.getTileReports(geography1.Id, '', '', false, SUBJECT_LABEL, result1[0].shelfTiles[0].shelfTileId, DESKTOP_LABEL);
        System.assertEquals(1, reportList4.size());

        List<OV_Wrapper.ReportWrapper> reportList5 = OV_SearchService2.getTileReports(geography1.Id, '', '', false, SUBJECT_LABEL, result1[0].shelfTiles[0].shelfTileId, TABLET_LABEL);
        System.assertEquals(1, reportList5.size());

        List<OV_Wrapper.ReportWrapper> reportList6 = OV_SearchService2.getTileReports(geography1.Id, '', '', false, SUBJECT_LABEL, result1[0].shelfTiles[0].shelfTileId, MOBILE_LABEL);
        System.assertEquals(1, reportList6.size());
        */
        //test getTileReports2 method
        Map<String, Object> reportMap4 = OV_SearchService2.getTileReports2(geography1.Id, '', '', false, SUBJECT_LABEL, result1[0].shelfTiles[0].shelfTileId, DESKTOP_LABEL);
        System.assertEquals(1, reportMap4.keySet().size());

        Map<String, Object> reportMap5 = OV_SearchService2.getTileReports2(geography1.Id, '', '', false, SUBJECT_LABEL, result1[0].shelfTiles[0].shelfTileId, TABLET_LABEL);
        System.assertEquals(1, reportMap5.keySet().size());

        Map<String, Object> reportMap6 = OV_SearchService2.getTileReports2(geography1.Id, '', '', false, SUBJECT_LABEL, result1[0].shelfTiles[0].shelfTileId, MOBILE_LABEL);
        System.assertEquals(1, reportMap6.keySet().size());
        }
    }
       

    @isTest
    static void testReportDetails() {
        User u = OV_TestingHelper.createAdminUser(testLabel, 'test@test.com', 'test2');
        system.runAs(u){
        
        OV_Profile__c profile = new OV_Profile__c(User__c = u.Id);
        insert profile;
        
        OV_Category__c category1 = OV_TestingHelper.initCategory('Category 1', true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography('Geography 1', true);
        OV_Function__c function1 = OV_TestingHelper.initFunction('Function 1', true);
        
        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion('Test 1', true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];
        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, titleLabel, contentVersion1.Id, SAMPLE_URL, true);

        //OV_Report__c report1 = OV_TestingHelper.initReport(REPORT1_LABEL, category1, function1, geography1, DESKTOP_LABEL, true);
        OV_Report__c report1 = OV_TestingHelper.initReportWithProxy(REPORT1_LABEL, category1, function1, geography1, DESKTOP_LABEL, proxy.Id, true);
        OV_Report__c report2 = OV_TestingHelper.initReportWithProxy(REPORT2_LABEL, category1, function1, geography1, MOBILE_LABEL, proxy.Id, true);
        OV_Report__c report3 = OV_TestingHelper.initReportWithProxy(REPORT3_LABEL, category1, function1, geography1, TABLET_LABEL, proxy.Id, true);

        OV_Shelf__c shelf1 = OV_TestingHelper.initShelf('Shelf1', SUBJECT_LABEL, true);
        OV_Shelf_Tile__c tile1 = OV_TestingHelper.initShelfTile('Tile 1', COLOR_LABEL, SAMPLE_IMAGE_URL, shelf1, true);

        OV_ShelfTileReport__c connectReportToTile1 = OV_TestingHelper.initReportToShelfTile(report1, tile1, true);
        OV_ShelfTileReport__c connectReportToTile2 = OV_TestingHelper.initReportToShelfTile(report2, tile1, true);
        OV_ShelfTileReport__c connectReportToTile3 = OV_TestingHelper.initReportToShelfTile(report3, tile1, true);

        FeedItem chatterItem = new FeedItem(ParentId = report1.Id, Body = testLabel);
        insert chatterItem;

        //desktop not static
        OV_Wrapper.ReportWrapper result = OV_SearchService2.getReportDetails(report1.Id, tile1.Id, DESKTOP_LABEL);
        System.assertEquals(result.reportTitle, report1.Name);

        //mobile not static
        OV_Wrapper.ReportWrapper result1 = OV_SearchService2.getReportDetails(report2.Id, tile1.Id, MOBILE_LABEL);
        System.assertEquals(result1.reportTitle, report2.Name);

        //tablet not static
        OV_Wrapper.ReportWrapper result2 = OV_SearchService2.getReportDetails(report3.Id, tile1.Id, TABLET_LABEL);
        System.assertEquals(result2.reportTitle, report3.Name);

        OV_Shelf__c shelf2 = OV_TestingHelper.initShelf('Shelf2', SUBJECT_LABEL, true);
        OV_Shelf_Tile__c tile2 = OV_TestingHelper.initShelfTile('Tile 2', COLOR_LABEL, SAMPLE_IMAGE_URL, shelf2, true);        

        //ContentWorkspace testWorkspace = [SELECT Id FROM ContentWorkspace WHERE Name = 'test']; 
        //create ContentVersion add it to library
        ContentVersion contentVersion2 = OV_TestingHelper.initContentVersion('Test 2', true);

        //ContentWorkspaceDoc newWorkspaceDoc = new ContentWorkspaceDoc();
        //newWorkspaceDoc.ContentWorkspaceId = testWorkspace.Id; 
        //newWorkspaceDoc.ContentDocumentId = contentVersion2.ContentDocumentId;
        //insert newWorkspaceDoc;

        ContentDocument document2 = [select Id, LatestPublishedVersionId from ContentDocument where Id = :contentVersion2.ContentDocumentId limit 1][0];

        OV_ContentProxy__c proxy1 = OV_TestingHelper.initContentProxy(document2.Id, 'proxy test title 2', document2.LatestPublishedVersionId, null, true);        
        
        OV_Report__c report4 = OV_TestingHelper.initReport(REPORT4_LABEL, category1, function1, geography1, DESKTOP_LABEL, false);
        report4.Desktop_Content_Proxy__c = proxy1.Id;

        OV_Report__c report5 = OV_TestingHelper.initReport(REPORT5_LABEL, category1, function1, geography1, MOBILE_LABEL, false);
        report5.ContentDocumentMobile__c = contentVersion2.Id;
        report5.Mobile_Content_Proxy__c = proxy1.Id;

        OV_Report__c report6 = OV_TestingHelper.initReport(REPORT6_LABEL, category1, function1, geography1, TABLET_LABEL, false);
        report6.ContentDocumentTablet__c = contentVersion2.Id;
        report6.Tablet_Content_Proxy__c = proxy1.Id;

        List<OV_Report__c> reportToInsert = new List<OV_Report__c>();
        reportToInsert.add(report4);
        reportToInsert.add(report5);
        reportToInsert.add(report6);
        insert reportToInsert;

        OV_ShelfTileReport__c connectReportToTile4 = OV_TestingHelper.initReportToShelfTile(report4, tile2, true);
        OV_ShelfTileReport__c connectReportToTile5 = OV_TestingHelper.initReportToShelfTile(report5, tile2, true);
        OV_ShelfTileReport__c connectReportToTile6 = OV_TestingHelper.initReportToShelfTile(report6, tile2, true);

        //desktop static
        OV_Wrapper.ReportWrapper result3 = OV_SearchService2.getReportDetails(report4.Id, tile2.Id, DESKTOP_LABEL);
        System.assertEquals(result3.reportTitle, report4.Name);

        //mobile static
        OV_Wrapper.ReportWrapper result4 = OV_SearchService2.getReportDetails(report5.Id, tile2.Id, MOBILE_LABEL);
        System.assertEquals(result4.reportTitle, report5.Name);

        //tablet static
        OV_Wrapper.ReportWrapper result5 = OV_SearchService2.getReportDetails(report6.Id, tile2.Id, TABLET_LABEL);
        System.assertEquals(result5.reportTitle, report6.Name);

        try {
            OV_Wrapper.ReportWrapper result6 = OV_SearchService2.getReportDetails('123', tile1.Id, '');
        }
        catch(Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('No results for this id');
            System.assertEquals(true, expectedExceptionThrown);
        }
        }
    }
   
    @isTest
    static void testFavourite() {
        User u = OV_TestingHelper.createAdminUser(testLabel, 'test@test.com', 'test2');
        system.runAs(u){
        
        OV_Profile__c profile = new OV_Profile__c(User__c = u.Id);
        insert profile;
        
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
        OV_ContentProxy__c proxy3 = OV_TestingHelper.initContentProxy(document3.Id, titleLabel, contentVersion3.Id, SAMPLE_URL, true);

        OV_Shelf__c shelf1 = OV_TestingHelper.initShelf('Shelf1', SUBJECT_LABEL, true);
        OV_Shelf_Tile__c tile1 = OV_TestingHelper.initShelfTile('Tile 1', COLOR_LABEL, SAMPLE_IMAGE_URL, shelf1, true);

        OV_Report__c report1 = OV_TestingHelper.initReportWithProxy(REPORT1_LABEL, category1, function1, geography1, DESKTOP_LABEL, proxy1.Id, true);
        report1.Favourite_From_Shelf_Tile__c = tile1.Id;
        update report1;
        
        OV_Report__c report2 = OV_TestingHelper.initReportWithProxy(REPORT2_LABEL, category1, function1, geography1, MOBILE_LABEL, proxy2.Id, true);
        report2.Favourite_From_Shelf_Tile__c = tile1.Id;
        update report2;
        
        OV_Report__c report3 = OV_TestingHelper.initReportWithProxy(REPORT3_LABEL, category1, function1, geography1, TABLET_LABEL, proxy3.Id, true);
        report3.Favourite_From_Shelf_Tile__c = tile1.Id;
        update report3;

        OV_ShelfTileReport__c connectReportToTile1 = OV_TestingHelper.initReportToShelfTile(report1, tile1, true);
        OV_ShelfTileReport__c connectReportToTile2 = OV_TestingHelper.initReportToShelfTile(report2, tile1, true);
        OV_ShelfTileReport__c connectReportToTile3 = OV_TestingHelper.initReportToShelfTile(report3, tile1, true);                

        OV_RemoteController.addReportToFavourites(report1.Id, tile1.Id);
        OV_RemoteController.addReportToFavourites(report2.Id, tile1.Id);
        OV_RemoteController.addReportToFavourites(report3.Id, tile1.Id);

        FeedItem chatterItem = new FeedItem(ParentId = report1.Id, Body = testLabel);
        insert chatterItem;                

        Map<String,List<OV_Wrapper.ReportWrapper>> repMap = OV_SearchService2.getMyFavouritesReports(geography1.Id, category1.Id, function1.Id, true, DESKTOP_LABEL);
        List<OV_Wrapper.ReportWrapper> repList = repMap.get(subjectsLabel);        
        System.assertEquals(repList.size(), 1);
        System.assertEquals(repList[0].reportTitle, REPORT1_LABEL);

        Map<String,List<OV_Wrapper.ReportWrapper>> repMap2 = OV_SearchService2.getMyFavouritesReports(geography1.Id, category1.Id, function1.Id, false, MOBILE_LABEL);
        List<OV_Wrapper.ReportWrapper> repList2 = repMap2.get(subjectsLabel);       
        System.assertEquals(repList2.size(), 1);
        System.assertEquals(repList2[0].reportTitle, REPORT2_LABEL);

        Map<String,List<OV_Wrapper.ReportWrapper>> repMap3 = OV_SearchService2.getMyFavouritesReports(geography1.Id, category1.Id, function1.Id, false, TABLET_LABEL);
        List<OV_Wrapper.ReportWrapper> repList3 = repMap3.get(subjectsLabel);               
        System.assertEquals(repList3.size(), 1);
        System.assertEquals(repList3[0].reportTitle, REPORT3_LABEL);

        //modify all proxy to test static part of getFavouritesReports
        proxy1.Url__c = null;
        proxy2.Url__c = null;
        proxy3.Url__c = null;

        List<OV_ContentProxy__c> proxyToUpdate = new List<OV_ContentProxy__c>();
        proxyToUpdate.add(proxy1);
        proxyToUpdate.add(proxy2);
        proxyToUpdate.add(proxy3);

        update proxyToUpdate;

        repMap = OV_SearchService2.getMyFavouritesReports(geography1.Id, category1.Id, function1.Id, true, DESKTOP_LABEL);
        repList = repMap.get(subjectsLabel);
        
        System.assertEquals(repList.size(), 1);
        System.assertEquals(repList[0].reportTitle, REPORT1_LABEL);

        repMap2 = OV_SearchService2.getMyFavouritesReports(geography1.Id, category1.Id, function1.Id, false, MOBILE_LABEL);
        repList2 = repMap2.get(subjectsLabel);
        System.assertEquals(repList2.size(), 1);
        System.assertEquals(repList2[0].reportTitle, REPORT2_LABEL);

        repMap3 = OV_SearchService2.getMyFavouritesReports(geography1.Id, category1.Id, function1.Id, false, TABLET_LABEL);
        repList3 = repMap3.get(subjectsLabel);
        System.assertEquals(repList3.size(), 1);
        System.assertEquals(repList3[0].reportTitle, REPORT3_LABEL);
        }
        //try {
        //    Map<String,List<OV_Wrapper.ReportWrapper>> favouriteMap = OV_SearchService2.getMyFavouritesReports(geography1.Name, category1.Name, function1.Name, true, DESKTOP_LABEL);
        //    List<OV_Wrapper.ReportWrapper> favouriteList = favouriteMap.get('Subjects');
        //}
        //catch(Exception e) {
        //    Boolean expectedExceptionThrown = e.getMessage().contains('Get favourite search method returns no results. Invalid parameters to build query');
        //    System.assertEquals(true, expectedExceptionThrown);
        //}
    }   
}