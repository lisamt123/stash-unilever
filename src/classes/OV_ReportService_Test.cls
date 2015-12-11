@isTest
global class OV_ReportService_Test{

    static final String brandLabel = 'brand';
    static final String channelLabel = 'channel';
    static final String customerLabel = 'customer';
    static final String geographyLabel = 'geography';
    static final String categoryLabel = 'category';
    static final String functionLabel = 'function';
    public static final String TILE1_LABEL           = 'Tile 1';
    public static final String SAMPLE_IMAGE_URL      = 'www.test.com/image.png';
    public static final String GRAY_COLOR           = '#ccc';
    public static final String SUBJECT_LABEL         = 'Subject';

    public static testMethod Void runTest(){
        User u = OV_TestingHelper.createAdminUser('Test', 'test@test.com', 'test2');
        system.runAs(u){
            OV_Profile__c profile = new OV_Profile__c(User__c = u.Id);
            insert profile;

            OV_KPI_Dimension_KPI_Name__c kpiName = new OV_KPI_Dimension_KPI_Name__c(Visible_Columns__c='brand;businessUnit;channel;', Code__c = TILE1_LABEL,  Code_Text__c = 'LABEL_1234');
            insert kpiName;
        
            List<OV_KPI_Transaction__c> transactions = new List<OV_KPI_Transaction__c>();
            transactions.add(new OV_KPI_Transaction__c(Value_Current_Period__c='10', Value_Previous_Period__c = '5', Direction__c ='NO CHANGE', KPI_Name__c=kpiName.Id, KPI_Name_Code__c=TILE1_LABEL, Source__c='test123', File_Version__c='222', Source_Timestamp__c=Datetime.now(), Data_Tag__c=TILE1_LABEL));
            transactions.add(new OV_KPI_Transaction__c(Value_Current_Period__c='10', Value_Previous_Period__c = '5', Direction__c ='NO CHANGE', KPI_Name__c=kpiName.Id, KPI_Name_Code__c=TILE1_LABEL, Source__c='test123', File_Version__c='222', Source_Timestamp__c=Datetime.now(), Data_Tag__c=TILE1_LABEL));
            insert transactions;
            
            OV_Category__c category1   = OV_TestingHelper.initCategory(categoryLabel, true);
            OV_Geography__c geography1 = OV_TestingHelper.initGeography(geographyLabel, true);
            OV_Function__c function1   = OV_TestingHelper.initFunction(functionLabel, true);
            ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion('Test 1', true);
            ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];
            OV_ContentProxy__c proxy1 = OV_TestingHelper.initContentProxy(document1.Id, 'proxy test title1', contentVersion1.Id, 'www.salesforce.com', true);
            OV_Report__c report       = OV_TestingHelper.initReportWithProxyHeaderFolder('Test Report', category1, function1, geography1, 'Desktop', proxy1.Id, 'Heading 1', 'Folder 1', true);
        
            OV_Shelf__c shelf         = OV_TestingHelper.initShelf('Shelf', SUBJECT_LABEL, true);
            OV_Shelf_Tile__c tile     = OV_TestingHelper.initShelfTile(TILE1_LABEL, GRAY_COLOR, SAMPLE_IMAGE_URL, shelf, true);
            
            OV_ReportService.addReportToFavourites(report.Id,tile.Id);
            List<OV_Report_Favourite__c> favouriteReports = [SELECT Id FROM OV_Report_Favourite__c LIMIT 10000];
            system.assertEquals(1, favouriteReports.size());
            
            OV_ReportService.deleteReportFromFavourites(report.Id);
            favouriteReports = [SELECT Id FROM OV_Report_Favourite__c LIMIT 10000];
            system.assertEquals(0, favouriteReports.size());
            
            OV_ReportService.increaseViewsCounter(report.Id);
            List<OV_Report__c> reports = [SELECT Id, Views__c FROM OV_Report__c LIMIT 1];
            system.assertEquals(1, reports.get(0).Views__c);
        }
    }
}