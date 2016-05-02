@isTest
private class OV_KpiNotificationFormatter_Test {
    static final String brandLabel = 'brand';
    static final String channelLabel = 'channel';
    static final String geographyLabel = 'geography';
    static final String categoryLabel = 'category';
    static final String functionLabel = 'function';
    public static final String TILE1_LABEL           = 'Tile 1';
    public static final String SAMPLE_IMAGE_URL      = 'www.test.com/image.png';
    public static final String GRAY_COLOR           = '#ccc';
    public static final String SUBJECT_LABEL         = 'Subject';

    @isTest
    public static void runKpiFavoriteTransactionTest(){
        User u = OV_TestingHelper.createAdminUser('Test', 'test@test.com', 'test2');
        system.runAs(u){
            OV_Profile__c profile = new OV_Profile__c(User__c = u.Id);
            insert profile;

            OV_KPI_Dimension_KPI_Name__c kpiName = new OV_KPI_Dimension_KPI_Name__c(Visible_Columns__c='brand;channel;', Code__c = TILE1_LABEL,  Code_Text__c = 'LABEL_1234');
            insert kpiName;

            OV_KPI_Dimension_Brand__c brandDim = new OV_KPI_Dimension_Brand__c(Code__c=TILE1_LABEL, Name='123');
            insert brandDim;

            OV_KPI_Dimension_Channel__c channelDim = new OV_KPI_Dimension_Channel__c(Code__c=TILE1_LABEL, Name='321');
            insert channelDim;
        
            OV_KPI_Transaction__c transact = new OV_KPI_Transaction__c(Brand__c=brandDim.Id, Channel__c=channelDim.Id, Value_Current_Period__c='10', Value_Previous_Period__c = '5', Direction__c ='NO CHANGE', KPI_Name__c=kpiName.Id, KPI_Name_Code__c=TILE1_LABEL, Source__c='test123', File_Version__c='222', Source_Timestamp__c=Datetime.now(), Data_Tag__c=TILE1_LABEL);
            insert transact;
            
            OV_Category__c category1   = OV_TestingHelper.initCategory(categoryLabel, true);
            OV_Geography__c geography1 = OV_TestingHelper.initGeography(geographyLabel, true);
            OV_Function__c function1   = OV_TestingHelper.initFunction(functionLabel, true);
            ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion('Test 1', true);
            ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];
            OV_ContentProxy__c proxy1 = OV_TestingHelper.initContentProxy(document1.Id, 'proxy test title1', contentVersion1.Id, 'www.salesforce.com', true);
            OV_Report__c report       = OV_TestingHelper.initReportWithProxyHeaderFolder('Test Report', category1, function1, geography1, 'Desktop', proxy1.Id, 'Heading 1', 'Folder 1', true);
        
            OV_Shelf__c shelf1         = OV_TestingHelper.initShelf('Shelf1', SUBJECT_LABEL, true);
            OV_Shelf_Tile__c tile1     = OV_TestingHelper.initShelfTile(TILE1_LABEL, GRAY_COLOR, SAMPLE_IMAGE_URL, shelf1, true);
        
            List<OV_Wrapper.KpiFavouriteTransactionWrapper> transactionWrapperList = new List<OV_Wrapper.KpiFavouriteTransactionWrapper>();
            transactionWrapperList.add(new OV_Wrapper.KpiFavouriteTransactionWrapper(transact.Id,true,report.Id));
            
            OV_GetKPI_Mapping__c mapping = new OV_GetKPI_Mapping__c(Name = brandLabel, Field_API_Name__c = 'Brand__c',  Object_API_Name__c = 'OV_KPI_Dimension_Brand__c',  Order__c = 1, Header__c = 'Header' );
            insert mapping;

            OV_GetKPI_Mapping__c mapping2 = new OV_GetKPI_Mapping__c(Name = channelLabel,  Field_API_Name__c = 'Channel__c',  Object_API_Name__c = 'OV_KPI_Dimension_Channel__c',  Order__c = 1, Header__c = 'Header' );
            insert mapping2;
            
            OV_KpiTransactionFavoriteServiceImpl service = new OV_KpiTransactionFavoriteServiceImpl();
            service.addKpisToFavorite(transactionWrapperList);
            
            System.assertEquals(1, service.listFavorites().size());

            OV_KPI_Transaction_Favorite__c fav = [SELECT Id, KPI_Transaction__r.Brand__c, KPI_Transaction__r.Brand__r.Name, KPI_Transaction__r.Channel__c, KPI_Transaction__r.Channel__r.Name, KPI_Transaction__r.KPI_Name__r.Visible_Columns__c, Wants_Notifications__c, Chatter_Update_Message__c, User__r.User__c FROM OV_KPI_Transaction_Favorite__c LIMIT 1];
            OV_KpiNotificationFormatter formatter = new OV_KpiNotificationFormatter();
            System.assert(formatter.formatMessage(fav).contains(brandDim.Name+', '+channelDim.Name));
        }
    } 
}