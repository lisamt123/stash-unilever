@isTest
global class OV_KpiTransactionFavServiceImpl_Test{

    static final String resultsLabel = 'Results';
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

    public static testMethod void runKpiFavoriteTransactionTest(){
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
        
            OV_Shelf__c shelf1         = OV_TestingHelper.initShelf('Shelf1', SUBJECT_LABEL, true);
            OV_Shelf_Tile__c tile1     = OV_TestingHelper.initShelfTile(TILE1_LABEL, GRAY_COLOR, SAMPLE_IMAGE_URL, shelf1, true);
        
            List<OV_Wrapper.KpiFavouriteTransactionWrapper> transactionWrapperList = new List<OV_Wrapper.KpiFavouriteTransactionWrapper>();
            transactionWrapperList.add(new OV_Wrapper.KpiFavouriteTransactionWrapper(transactions.get(0).Id,true,report.Id));
            transactionWrapperList.add(new OV_Wrapper.KpiFavouriteTransactionWrapper(transactions.get(1).Id,true,report.Id));
            
            OV_GetKPI_Mapping__c mapping = new OV_GetKPI_Mapping__c(Name = 'Mapping', Field_API_Name__c = 'Geography__c',  Object_API_Name__c = 'OV_KPI_Dimension_Geography__c',  Order__c = 1, Header__c = 'Header' );
            insert mapping;
            
            OV_KpiTransactionFavoriteServiceImpl service = new OV_KpiTransactionFavoriteServiceImpl();
            service.addKpisToFavorite(transactionWrapperList);
            
            System.assertEquals(2, service.listFavorites().size());
            
            OV_KPI_Transaction_Favorite__c fList = [SELECT Id, KPI_Transaction__c FROM OV_KPI_Transaction_Favorite__c limit 1];
            service.deleteFavoriteKpi(fList.KPI_Transaction__c);
        }
    } 

    public static testMethod void runKpiFavTransPermissionTest(){
        User u1 = OV_TestingHelper.createAdminUser('Test', 'test@test.com', 'test2');
          
        Profile p = OV_TestingHelper.getUserProfile();
           
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                              LocaleSidKey='en_US', ProfileId = p.Id,
                              TimeZoneSidKey='America/Los_Angeles',     UserName='testpermissionsetuser@testorg.com');
            
        insert u;

        system.runAs(u1){          
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'OV_Consumer'];

            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = u.Id;
            psa.PermissionSetId = ps.Id;
            insert psa;

            PermissionSet ps2 = [SELECT Id FROM PermissionSet WHERE Name = 'One_View_Consumer_KPI'];

            PermissionSetAssignment psa2 = new PermissionSetAssignment();
            psa2.AssigneeId = u.Id;
            psa2.PermissionSetId = ps2.Id;
            insert psa2;
        }        

        system.runAs(u){
            OV_Profile__c profile1 = new OV_Profile__c(User__c = u.Id);
            insert profile1; 

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
            
            OV_Report__c report2       = OV_TestingHelper.initReportWithProxyHeaderFolder('Test Report2', category1, function1, geography1, 'Desktop', proxy1.Id, 'Heading 1', 'Folder 1', true);

            OV_Shelf__c shelf1         = OV_TestingHelper.initShelf('Shelf1', SUBJECT_LABEL, true);
            OV_Shelf_Tile__c tile1     = OV_TestingHelper.initShelfTile(TILE1_LABEL, GRAY_COLOR, SAMPLE_IMAGE_URL, shelf1, true);
        
            List<OV_Wrapper.KpiFavouriteTransactionWrapper> transactionWrapperList = new List<OV_Wrapper.KpiFavouriteTransactionWrapper>();
            transactionWrapperList.add(new OV_Wrapper.KpiFavouriteTransactionWrapper(transactions.get(0).Id,true,report.Id));
            transactionWrapperList.add(new OV_Wrapper.KpiFavouriteTransactionWrapper(transactions.get(1).Id,true,report.Id));
            
            OV_GetKPI_Mapping__c mapping = new OV_GetKPI_Mapping__c(Name = 'Mapping', Field_API_Name__c = 'Geography__c',  Object_API_Name__c = 'OV_KPI_Dimension_Geography__c',  Order__c = 1, Header__c = 'Header' );
            insert mapping;

            OV_KpiTransactionFavoriteServiceImpl service = new OV_KpiTransactionFavoriteServiceImpl();
            service.addKpisToFavorite(transactionWrapperList);   

            System.assertEquals(2, service.listFavorites().size());

            OV_KPI_Transaction_Favorite__c fList = [SELECT Id, KPI_Transaction__c FROM OV_KPI_Transaction_Favorite__c limit 1];
            service.deleteFavoriteKpi(fList.KPI_Transaction__c);  

            System.assertEquals(1, service.listFavorites().size());

            fList = [SELECT Id, KPI_Transaction__c FROM OV_KPI_Transaction_Favorite__c limit 1];  

            service.editKpiTransactionsFavorite(fList.Id, false, null);  

            fList = [SELECT Id, KPI_Transaction__c, Wants_Notifications__c FROM OV_KPI_Transaction_Favorite__c limit 1];  

            System.assertEquals(false, fList.Wants_Notifications__c);
        }        
    }
}