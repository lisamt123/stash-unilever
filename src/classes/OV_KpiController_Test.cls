@isTest
public class OV_KpiController_Test{
    static final String resultsLabel = 'Results';
    static final String brandLabel = 'brand';
    static final String channelLabel = 'channel';
    static final String customerLabel = 'customer';
    static final String geographyLabel = 'geography';
    static final String categoryLabel = 'category';
    static final String functionLabel = 'function';
    public static final String TILE1_LABEL           = 'Tile 1';
    public static final String SAMPLE_IMAGE_URL      = 'www.test.com/image.png';
    public static final String GRAY_COLOR            = '#ccc';
    public static final String SUBJECT_LABEL         = 'Subject';
    public static final String LABEL_1234            = '1234';

    

    public static testMethod void runGeographyHierarchicalTest(){
        OV_KPI_Dimension_Geography__c geographyParent = new OV_KPI_Dimension_Geography__c(Code__c = LABEL_1234);
        insert geographyParent ;
        
        OV_KPI_Dimension_Geography__c geography = new OV_KPI_Dimension_Geography__c(Parent_Id__c = geographyParent.Id, Code__c = '4321');
        insert geography;
    
        OV_GetKPI_Mapping__c mapping = new OV_GetKPI_Mapping__c(Name='Test', Object_API_Name__c = 'OV_KPI_Dimension_Geography__c', Order__c = 1, Field_API_Name__c = 'Geography__c', IsHierarchical__c = true, Header__c = 'Test');
        insert mapping ;
        
        OV_Wrapper result = OV_KpiController.getFilters();
        system.assertEquals('0', result.status); //0 is success_code
        system.assertEquals(resultsLabel, result.Message);
        system.assertEquals(1, result.data.size());  
    }

    public static testMethod void runGeographyTest(){
        OV_KPI_Dimension_Geography__c geography = new OV_KPI_Dimension_Geography__c(Code__c = LABEL_1234);
        insert geography;
    
        OV_GetKPI_Mapping__c mapping = new OV_GetKPI_Mapping__c(Name='Test', Object_API_Name__c = 'OV_KPI_Dimension_Geography__c',  Order__c = 1, Field_API_Name__c = 'Geography__c', IsHierarchical__c = false, Header__c = 'Test');
        insert mapping ;
        
        OV_Wrapper result = OV_KpiController.getFilters();
        system.assertEquals('0', result.status); //0 is success_code
        system.assertEquals(resultsLabel, result.Message);
        system.assertEquals(1, result.data.size());  
    }

    public static testMethod void runExceptionTest(){
        OV_KPI_Dimension_Geography__c geography = new OV_KPI_Dimension_Geography__c(Code__c = LABEL_1234);
        insert geography;
    
        OV_GetKPI_Mapping__c mapping = new OV_GetKPI_Mapping__c(Name='Test', Object_API_Name__c = 'WrongObjectName',  Order__c = 1, Field_API_Name__c = 'WrongObjectName', IsHierarchical__c = false, Header__c = 'Test');
        insert mapping ;
        
        OV_Wrapper result = OV_KpiController.getFilters();
        system.assertEquals('-1', result.status); //-1 is exception_code
    }

    public static testMethod void runTransactionsTest(){
        OV_KPI_Config__c config = new OV_KPI_Config__c(name = 'Config', Max__c = 1);
        insert config;
        
        List<OV_GetKPI_Mapping__c > mappingList = new List<OV_GetKPI_Mapping__c >();
        mappingList.add(new OV_GetKPI_Mapping__c(Name='kpiName', Header__c = 'KPI Name', Object_API_Name__c = 'KPI_Name__c', Order__c = 1, Field_API_Name__c = 'KPI_Name__c', isDisplayed__c = true));
        insert mappingList;
        
        Map<String, Set<Id>> jsonMap = new Map<String, Set<Id>>();
        String dimensions = JSON.serialize(jsonMap);

        OV_KPI_Dimension_KPI_Name__c kpiName = new OV_KPI_Dimension_KPI_Name__c(Visible_Columns__c='brand;businessUnit;channel;', Code__c = LABEL_1234, Code_Text__c = LABEL_1234);
        insert kpiName;
        
        OV_KPI_Transaction__c tran = new OV_KPI_Transaction__c(Direction__c ='NO CHANGE', Value_Current_Period__c='10', Value_Previous_Period__c = '5', KPI_Name__c=kpiName.Id, KPI_Name_Code__c=LABEL_1234, Source__c='test123', File_Version__c='222', Source_Timestamp__c=Datetime.now(), Data_Tag__c=LABEL_1234);
        insert tran;
        
        OV_Wrapper result = OV_KpiController.getKPITransactions(dimensions);
        //system.assertEquals('0', result.status); //0 is success_code
        system.assertEquals(resultsLabel, result.Message);
        //system.assertEquals(4, result.data.size());  
    }

    public static testMethod void runMaxQueryConditionTest(){
        OV_KPI_Config__c config = new OV_KPI_Config__c(name = 'Config', Max__c = 1);
        insert config;
        
        List<OV_GetKPI_Mapping__c > mappingList = new List<OV_GetKPI_Mapping__c >();
        mappingList.add(new OV_GetKPI_Mapping__c(Name=brandLabel, Header__c = 'Brand', Object_API_Name__c = 'OV_KPI_Dimension_Brand__c',  Order__c = 1, Field_API_Name__c = 'Brand__c', isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='businessUnit', Header__c = 'Business Unit', Object_API_Name__c = 'OV_KPI_Dimension_Business_Unit__c',  Order__c = 1, Field_API_Name__c = 'Business_Unit__c', isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name=channelLabel, Header__c = 'Channel', Object_API_Name__c = 'OV_KPI_Dimension_Channel__c', Order__c = 1, Field_API_Name__c = 'Channel__c', isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name=customerLabel, Header__c = 'Customer', Object_API_Name__c = 'OV_KPI_Dimension_Customer__c', Order__c = 1, Field_API_Name__c = 'Customer__c', isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name=geographyLabel, Header__c = 'Geography', Object_API_Name__c = 'OV_KPI_Dimension_Geography__c', Order__c = 1, Field_API_Name__c = 'Geography__c', isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='kpiName', Header__c = 'KPI Name', Object_API_Name__c = 'OV_KPI_Dimension_KPI_Name__c', Order__c = 1, Field_API_Name__c = 'KPI_Name__c', isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='organisationalUnit', Header__c = 'Org Unit', Object_API_Name__c = 'OV_KPI_Dimension_Organisational_Unit__c', Order__c = 1, Field_API_Name__c = 'Organisational_Unit__c', isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='productCategory', Header__c = 'Product Category', Object_API_Name__c = 'OV_KPI_Dimension_Product_Category__c', Order__c = 1, Field_API_Name__c = 'Product_Category__c', isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='timeRange', Header__c = 'Time Range', Object_API_Name__c = 'OV_KPI_Dimension_Organisational_Time_Range__c', Order__c = 1, Field_API_Name__c = 'Time_Range__c', isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='wlGroup', Header__c = 'WL Group', Object_API_Name__c = 'OV_KPI_Dimension_WL_Group__c', Order__c = 1, Field_API_Name__c = 'WL_Group__c', isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='brandNA', Header__c = 'NA Brand', Object_API_Name__c = 'OV_KPI_Dimension_NA_Brand__c', Order__c = 1, Field_API_Name__c = 'NA_Brand__c', isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='opcoNA', Header__c = 'NA OPCO', Object_API_Name__c = 'OV_KPI_Dimension_NA_OPCO__c', Order__c = 1, Field_API_Name__c = 'NA_OPCO__c', isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='salesOrgNA', Header__c = 'NA Sales Org', Object_API_Name__c = 'OV_KPI_Dimension_NA_Sales_Org__c', Order__c = 1, Field_API_Name__c = 'NA_Sales_Org__c', isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='productCategoryNA', Header__c = 'NA Product Catgory', Object_API_Name__c = 'OV_KPI_Dimension_NAProductCategory__c', Order__c = 1, Field_API_Name__c = 'NA_Product_Category__c', isDisplayed__c = true));
        insert mappingList;
        
        Map<String, Set<Id>> jsonMap = new Map<String, Set<Id>>();
        
        OV_KPI_Dimension_Brand__c brand = new OV_KPI_Dimension_Brand__c(Code__c = LABEL_1234);
        insert brand;
        jsonMap.put(brandLabel, new Set<Id>{brand.Id});
        
        OV_KPI_Dimension_Business_Unit__c bu= new OV_KPI_Dimension_Business_Unit__c(Code__c = LABEL_1234);
        insert bu;
        jsonMap.put('businessUnit', new Set<Id>{bu.Id});
        
        OV_KPI_Dimension_Channel__c channel = new OV_KPI_Dimension_Channel__c(Code__c = LABEL_1234);
        insert channel;
        jsonMap.put(channelLabel, new Set<Id>{channel.Id});
        
        OV_KPI_Dimension_Customer__c customer = new OV_KPI_Dimension_Customer__c(Code__c = LABEL_1234);
        insert customer;
        jsonMap.put(customerLabel, new Set<Id>{customer.Id});
        
        OV_KPI_Dimension_Geography__c geography = new OV_KPI_Dimension_Geography__c(Code__c = LABEL_1234);
        insert geography;
        jsonMap.put(geographyLabel, new Set<Id>{geography.Id});
        
        OV_KPI_Dimension_Org_Unit__c ou = new OV_KPI_Dimension_Org_Unit__c(Code__c = LABEL_1234);
        insert ou;
        jsonMap.put('organisationalUnit', new Set<Id>{ou.Id});
        
        OV_KPI_Dimension_Product_Category__c pc = new OV_KPI_Dimension_Product_Category__c(Code__c = LABEL_1234);
        insert pc;
        jsonMap.put('productCategory', new Set<Id>{pc.Id});
        
        OV_KPI_Dimension_Time_Range__c tr = new OV_KPI_Dimension_Time_Range__c(Code__c = LABEL_1234);
        insert tr;
        jsonMap.put('timeRange', new Set<Id>{tr.Id});
        
        OV_KPI_Dimension_WL_GROUP__c wlGroup = new OV_KPI_Dimension_WL_GROUP__c(Code__c = LABEL_1234);
        insert wlGroup;
        jsonMap.put('wlGroup', new Set<Id>{wlGroup.Id});
        
        OV_KPI_Dimension_NA_Brand__c brandNA = new OV_KPI_Dimension_NA_Brand__c(Code__c = LABEL_1234);
        insert brandNA;
        jsonMap.put('brandNA', new Set<Id>{wlGroup.Id});
        
        OV_KPI_Dimension_NA_OPCO__c opcoNA = new OV_KPI_Dimension_NA_OPCO__c(Code__c = LABEL_1234);
        insert opcoNA;
        jsonMap.put('opcoNA', new Set<Id>{wlGroup.Id});
        
        OV_KPI_Dimension_NAProductCategory__c pCatNA = new OV_KPI_Dimension_NAProductCategory__c(Code__c = LABEL_1234);
        insert pCatNA;
        jsonMap.put('productCategoryNA', new Set<Id>{wlGroup.Id});
        
        OV_KPI_Dimension_NA_Sales_Org__c salesNA = new OV_KPI_Dimension_NA_Sales_Org__c(Code__c = LABEL_1234);
        insert salesNA;
        jsonMap.put('salesOrgNA', new Set<Id>{wlGroup.Id});
        
        OV_KPI_Dimension_KPI_Name__c kpiName = new OV_KPI_Dimension_KPI_Name__c(Visible_Columns__c='brand;businessUnit;channel;', Code__c = LABEL_1234, Code_Text__c = LABEL_1234);
        insert kpiName;
        jsonMap.put('kpiName', new Set<Id>{kpiName.Id});
        
        String dimensions = JSON.serialize(jsonMap);
        
        OV_KPI_Transaction__c tran = new OV_KPI_Transaction__c(Direction__c ='NO CHANGE', KPI_Name__c=kpiName.Id, KPI_Name_Code__c=LABEL_1234, Source__c='test123', File_Version__c='222', Source_Timestamp__c=Datetime.now(), Data_Tag__c=LABEL_1234, Value_Current_Period__c='1.2', Value_Previous_Period__c='2.2');
        insert tran;
        
        OV_Wrapper result = OV_KpiController.getKPITransactions(dimensions );
        system.assertEquals('0', result.status); //0 is success_code
        system.assertEquals(resultsLabel, result.Message);
        system.assertEquals(4, result.data.size());  
    }

    public static testMethod void runMaxTransactionsTest(){
        
        List<OV_GetKPI_Mapping__c > mappingList = new List<OV_GetKPI_Mapping__c >();
        mappingList.add(new OV_GetKPI_Mapping__c(Name=brandLabel, Header__c = 'Brand', Field_API_Name__c = 'Brand__c', Object_API_Name__c = 'OV_KPI_Dimension_Brand__c',  Order__c = 1, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='businessUnit', Header__c = 'Business Unit', Field_API_Name__c = 'Business_Unit__c', Object_API_Name__c = 'OV_KPI_Dimension_Business_Unit__c',  Order__c = 1, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name=channelLabel, Header__c = 'Channel', Field_API_Name__c = 'Channel__c', Object_API_Name__c = 'OV_KPI_Dimension_Channel__c',  Order__c = 1, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name=customerLabel, Header__c = customerLabel, Field_API_Name__c = 'Customer__c', Object_API_Name__c = 'OV_KPI_Dimension_Customer__c',  Order__c = 1, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name=geographyLabel, Header__c = geographyLabel, Field_API_Name__c = 'Geography__c', Object_API_Name__c = 'OV_KPI_Dimension_Geography__c',  Order__c = 1, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='kpiName', Header__c = 'KPI Name', Field_API_Name__c = 'KPI_Name__c', Object_API_Name__c = 'OV_KPI_Dimension_KPI_Name__c',  Order__c = 1, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='organisationalUnit', Header__c = 'Org Unit', Field_API_Name__c = 'Organisational_Unit__c', Object_API_Name__c = 'OV_KPI_Organisational_Unit__c',  Order__c = 1, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='productCategory', Header__c = 'Product Category', Field_API_Name__c = 'Product_Category__c', Object_API_Name__c = 'OV_KPI_Product_Category__c',  Order__c = 1, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='timeRange', Header__c = 'Time Range', Field_API_Name__c = 'Time_Range__c', Object_API_Name__c = 'OV_KPI_Dimension_Time_Range__c',  Order__c = 1, isDisplayed__c = true));
        mappingList.add(new OV_GetKPI_Mapping__c(Name='wlGroup', Header__c = 'WL Group', Field_API_Name__c = 'WL_Group__c', Object_API_Name__c = 'OV_KPI_Dimension_WL_Group__c',  Order__c = 1, isDisplayed__c = true));
        insert mappingList;
        
        Map<String, Set<Id>> jsonMap = new Map<String, Set<Id>>();
        
        OV_KPI_Dimension_Brand__c brand = new OV_KPI_Dimension_Brand__c(Code__c='test');
        insert brand;
        jsonMap.put(brandLabel, new Set<Id>{brand.Id});
        
        String dimensions = JSON.serialize(jsonMap);

        OV_KPI_Dimension_KPI_Name__c kpiName = new OV_KPI_Dimension_KPI_Name__c(Visible_Columns__c='brand;businessUnit;channel;', Code__c = LABEL_1234, Code_Text__c = LABEL_1234);
        insert kpiName;
        
        List<OV_KPI_Transaction__c> transactions = new List<OV_KPI_Transaction__c>();
        transactions.add(new OV_KPI_Transaction__c(Brand__c = brand.Id, Direction__c ='NO CHANGE', Value_Current_Period__c='10', Value_Previous_Period__c = '5', KPI_Name__c=kpiName.Id, KPI_Name_Code__c=LABEL_1234, Source__c='test123', File_Version__c='222', Source_Timestamp__c=Datetime.now(), Data_Tag__c=LABEL_1234));
        transactions.add(new OV_KPI_Transaction__c(Brand__c = brand.Id, Direction__c ='NO CHANGE', Value_Current_Period__c='10', Value_Previous_Period__c = '5', KPI_Name__c=kpiName.Id, KPI_Name_Code__c=LABEL_1234, Source__c='test123', File_Version__c='222', Source_Timestamp__c=Datetime.now(), Data_Tag__c=LABEL_1234));
        insert transactions;
        
        OV_KPI_Config__c config = new OV_KPI_Config__c(name = 'Config', Max__c = 1);
        insert config;
        

        OV_Wrapper result = OV_KpiController.getKPITransactions(dimensions);
        system.assertEquals('0', result.status); //0 is success_code
        system.assertEquals(resultsLabel, result.Message);
        system.assertEquals(4, result.data.size());  
    }

    public static testMethod void runTransactionsErrorTest(){

        OV_Wrapper result = OV_KpiController.getKPITransactions('JSONDeserializeError' );
        system.assertEquals('-1', result.status);  //-1 is exception_code
        
        result = OV_KpiController.getFavouriteKPITransactions();
        system.assertEquals('-1', result.status);  //-1 is exception_code
        
        result = OV_KpiController.deleteKpiTransactionFromFavorite('wrong Id');
        system.assertEquals('-1', result.status);  //-1 is exception_code
    }
    
    public static testMethod void runKpiFavoriteTransactionTest(){
        User u = OV_TestingHelper.createAdminUser('Test', 'test@test.com', 'test2');
        system.runAs(u){
            OV_Profile__c profile = new OV_Profile__c(User__c = u.Id);
            insert profile;

            OV_KPI_Dimension_KPI_Name__c kpiName = new OV_KPI_Dimension_KPI_Name__c(Visible_Columns__c='brand;businessUnit;channel;', Code__c = LABEL_1234, Code_Text__c = LABEL_1234);
            insert kpiName;
        
            List<OV_KPI_Transaction__c> transactions = new List<OV_KPI_Transaction__c>();
            transactions.add(new OV_KPI_Transaction__c(Value_Current_Period__c='10', Value_Previous_Period__c = '5', Direction__c ='NO CHANGE', KPI_Name__c=kpiName.Id, KPI_Name_Code__c=LABEL_1234, Source__c='test123', File_Version__c='222', Source_Timestamp__c=Datetime.now(), Data_Tag__c=LABEL_1234));
            transactions.add(new OV_KPI_Transaction__c(Value_Current_Period__c='10', Value_Previous_Period__c = '5', Direction__c ='NO CHANGE', KPI_Name__c=kpiName.Id, KPI_Name_Code__c=LABEL_1234, Source__c='test123', File_Version__c='222', Source_Timestamp__c=Datetime.now(), Data_Tag__c=LABEL_1234));
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
            
            OV_GetKPI_Mapping__c mapping = new OV_GetKPI_Mapping__c(Name = 'Mapping', Field_API_Name__c = 'Geography__c', Object_API_Name__c = 'OV_KPI_Dimension_Geography__c',  Order__c = 1, Header__c = 'Header' );
            insert mapping;
            
            String transactionsJSON = JSON.serialize(transactionWrapperList);
            OV_KpiController.addKpiTransactionsToFavorite(transactionsJSON);
            
            String wrongTransactionsJSON = JSON.serialize(transactions);
            System.assertNotEquals('Results', OV_KpiController.addKpiTransactionsToFavorite(wrongTransactionsJSON).message);
            
            System.assertEquals(2, [SELECT Id FROM OV_KPI_Transaction_Favorite__c LIMIT 1000].size());
            System.assertEquals(1, OV_KpiController.getFavouriteKPITransactions().data.size());
            
            OV_Report_Favourite__c fReport = new OV_Report_Favourite__c(User__c = profile.Id, Colour__c = 'red', Favourite_From_Shelf_Tile__c=tile1.Id);
            insert fReport;
            
            System.assertEquals(1, OV_KpiController.getMyFavouritesReports().data.size());
            System.assertEquals(1, OV_KpiController.getKpiNames().data.size());
            
            System.assertEquals(resultsLabel, OV_KpiController.fireNotifictions('dataTag','version').message);
            System.assertEquals(resultsLabel, OV_KpiController.deleteKpiTransactionFromFavorite(transactions.get(0).Id).message);
            
            OV_KPI_Transaction_Favorite__c tFavourite = new OV_KPI_Transaction_Favorite__c(KPI_Transaction__c = transactions.get(0).Id, User__c = profile.Id);
            insert tFavourite;
            
            OV_KpiController.editKpiTransactionsFavorite(tFavourite.Id, true, report.Id);
            tFavourite = [SELECT Id, Wants_Notifications__c, Report__c FROM OV_KPI_Transaction_Favorite__c WHERE Id =: tFavourite.Id LIMIT 1];
            system.assertEquals(true, tFavourite.Wants_Notifications__c);
            system.assertEquals(report.Id, tFavourite.Report__c);
            
            OV_Wrapper result = OV_KpiController.editKpiTransactionsFavorite(transactions.get(0).Id, true, report.Id);//Id is not avourite transaction Id
            system.assertEquals('-1', result.status);
            
            OV_KpiController c = new OV_KpiController(); // create controller for test code coverage
        }
    }

    public static testMethod void privilegesHelperTest(){
        Profile p = OV_TestingHelper.getUserProfile();
        User u  = OV_TestingHelper.createUser(p, TILE1_LABEL, 'test@test1.com', TILE1_LABEL);
        OV_Profile__c profile = new OV_Profile__c(User__c = u.Id);
        insert profile;

        OV_KPI_Config__c config = new OV_KPI_Config__c(name = 'Config', Max__c = 1);
        insert config;

        OV_KPI_Dimension_KPI_Name__c kpiName = new OV_KPI_Dimension_KPI_Name__c(Visible_Columns__c='brand;businessUnit;channel;', Code__c = LABEL_1234, Code_Text__c = LABEL_1234);
            insert kpiName;
        
        List<OV_GetKPI_Mapping__c > mappingList = new List<OV_GetKPI_Mapping__c >();
        mappingList.add(new OV_GetKPI_Mapping__c(Name='kpiName', Header__c = 'KPI Name', Object_API_Name__c = 'KPI_Name__c', Order__c = 1, Field_API_Name__c = 'KPI_Name__c', isDisplayed__c = true));
        insert mappingList;
        
        Map<String, Set<Id>> jsonMap = new Map<String, Set<Id>>();
        String dimensions = JSON.serialize(jsonMap);
        
        OV_KPI_Transaction__c tran = new OV_KPI_Transaction__c(Value_Current_Period__c='10', Value_Previous_Period__c = '5', Direction__c ='NO CHANGE', KPI_Name__c=kpiName.Id, KPI_Name_Code__c=LABEL_1234, Source__c='test123', File_Version__c='222', Source_Timestamp__c=Datetime.now(), Data_Tag__c=LABEL_1234);
        insert tran;
        
        OV_Category__c category1   = OV_TestingHelper.initCategory(categoryLabel, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography(geographyLabel, true);
        OV_Function__c function1   = OV_TestingHelper.initFunction(functionLabel, true);
        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion('Test 1', true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];
        OV_ContentProxy__c proxy1 = OV_TestingHelper.initContentProxy(document1.Id, 'proxy test title1', contentVersion1.Id, 'www.salesforce.com', true);
        OV_Report__c report       = OV_TestingHelper.initReportWithProxyHeaderFolder('Test Report', category1, function1, geography1, 'Desktop', proxy1.Id, 'Heading 1', 'Folder 1', true);
    
        OV_Shelf__c shelf1         = OV_TestingHelper.initShelf('Shelf1', SUBJECT_LABEL, true);
        OV_Shelf_Tile__c tile1     = OV_TestingHelper.initShelfTile(TILE1_LABEL, GRAY_COLOR, SAMPLE_IMAGE_URL, shelf1, true);
    
        OV_KPI_Transaction_Favorite__c tFavourite = new OV_KPI_Transaction_Favorite__c(KPI_Transaction__c = tran.Id, User__c = profile.Id);
        insert tFavourite;

        List<OV_Wrapper.KpiFavouriteTransactionWrapper> transactionWrapperList = new List<OV_Wrapper.KpiFavouriteTransactionWrapper>();
        transactionWrapperList.add(new OV_Wrapper.KpiFavouriteTransactionWrapper(tran.Id,true,report.Id));

        String transactionsJSON = JSON.serialize(transactionWrapperList);

        System.runAs(u) {
            System.assertEquals('-1', OV_KpiController.getKpiNames().status);
            System.assertEquals('-1', OV_KpiController.getKPITransactions(dimensions).status);
            System.assertEquals('-1', OV_KpiController.addKpiTransactionsToFavorite(transactionsJSON).status);
            System.assertEquals('-1', OV_KpiController.editKpiTransactionsFavorite(tFavourite.Id, true, report.Id).status);
            System.assertEquals('-1', OV_KpiController.getFavouriteKPITransactions().status);
            System.assertEquals('-1', OV_KpiController.deleteKpiTransactionFromFavorite(tFavourite.Id).status);    
        }
    }

}