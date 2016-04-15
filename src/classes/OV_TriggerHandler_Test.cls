/**********************************************************************
Name: OV_TriggerHandler_Test
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Test Class test OV_SearchService
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             09/06/2015      INITIAL DEVELOPMENT
**********************************************************************/
@IsTest
private class OV_TriggerHandler_Test {
    static final String category1Label = 'Category 1';
    static final String function1Label = 'Function 1';
    static final String geography1Label = 'Geography 1';
    static final String desktopLabel = 'Desktop';
    static final String test1Label = 'Test 1';
    static final String proxyTitleLabel = 'proxy test title';
    static final String sampleTitleLabel = 'some sample title';

    public static final String REPORT1_LABEL         = 'Report 1';
    public static final String REPORT2_LABEL         = 'Report 2';
    public static final String REPORT3_LABEL         = 'Report 3';
    public static final String REPORT4_LABEL         = 'Report 4';

    public static final String SAMPLE_URL            = 'www.salesforce.com';
    
    @isTest static void test_method_one() {
        OV_Brand__c brand1 = OV_TestingHelper.initBrand('Brand 1', true);
        OV_Category__c category1 = OV_TestingHelper.initCategory(category1Label, true);
        OV_Comparator__c comparator1 = OV_TestingHelper.initBrandComparator('Comparator 1', true);
        OV_Function__c function1 = OV_TestingHelper.initFunction(function1Label, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography(geography1Label, true);

        OV_KPI_Name__c kpiName1 = OV_TestingHelper.initKPIName('KPIName1', true);
        OV_KPI_Name__c kpiName2 = OV_TestingHelper.initKPIName('KPIName2', true);
        OV_Report__c report1 = OV_TestingHelper.initReport(REPORT1_LABEL, category1, function1, geography1, desktopLabel, true);
        OV_Report__c report2 = OV_TestingHelper.initReport(REPORT2_LABEL, category1, function1, geography1, desktopLabel, true);
        OV_Report__c report3 = OV_TestingHelper.initReport(REPORT3_LABEL, category1, function1, geography1, desktopLabel, true);
        OV_Report__c report4 = OV_TestingHelper.initReport(REPORT4_LABEL, category1, function1, geography1, desktopLabel, true);

        List<OV_KPI_Element__c> listOfElements = new List<OV_KPI_Element__c>();
        for(Integer i=0;i<1200;i++){
            OV_KPI_Element__c kpiElement1 = OV_TestingHelper.initKPIElement('KPIElement1', brand1, comparator1, category1, 'UP', function1, geography1, kpiName1, 1.1, report1, 2.1, 'Week', false);
            listOfElements.add(kpiElement1);
        }
        insert listOfElements;

        User u = OV_TestingHelper.createAdminUser('test', 'test@test.com', 'test2');
        OV_Profile__c profile = OV_TestingHelper.initProfile('Profile1', u, true);

        User u2 = OV_TestingHelper.createAdminUser('test2', 'test2@test.com', 'test3');
        OV_Profile__c profile2 = OV_TestingHelper.initProfile('Profile2', u2, true);

        List<OV_KPI_Element_Interest__c> listOfInterest = new List<OV_KPI_Element_Interest__c>();
        for(OV_KPI_Element__c e : listOfElements){
            OV_KPI_Element_Interest__c interest = new OV_KPI_Element_Interest__c();
            interest.KPI_Element__c = e.Id;
            interest.User__c = profile.Id;
            interest.Wants_Notifications__c = true;
            listOfInterest.add(interest);
        }

        for(OV_KPI_Element__c e : listOfElements){
            OV_KPI_Element_Interest__c interest = new OV_KPI_Element_Interest__c();
            interest.KPI_Element__c = e.Id;
            interest.User__c = profile2.Id;
            interest.Wants_Notifications__c = true;
            listOfInterest.add(interest);
        }

        insert listOfInterest;

        Set<Id> elementInterestIds = new Set<Id>();
        for(OV_KPI_Element_Interest__c i : listOfInterest){
            elementInterestIds.add(i.Id);
        }

        for(OV_KPI_Element__c e : listOfElements){
            e.KPI_Value__c = 1.11;
            
        }

        update listOfElements;

        List<FeedItem> feeds = [SELECT ContentFileName FROM FeedItem WHERE ParentId IN :elementInterestIds];
        System.assertEquals(0, feeds.size()); //FeedItems cannot be generated in tests 
    }

    @isTest
    static void contentProxyHandler_Test() {
        OV_Category__c category1 = OV_TestingHelper.initCategory(category1Label, true);
        OV_Function__c function1 = OV_TestingHelper.initFunction(function1Label, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography(geography1Label, true);
        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion(test1Label, true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];

        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, proxyTitleLabel, contentVersion1.Id, SAMPLE_URL, true);
        system.assertEquals(proxy.ContentDocumentId__c, contentVersion1.ContentDocumentId);
        system.assertEquals(proxy.LatestContentVersionId__c, contentVersion1.Id);

        OV_Report__c report1 = OV_TestingHelper.initReport(REPORT1_LABEL, category1, function1, geography1, desktopLabel, false);
        report1.Desktop_Content_Proxy__c = proxy.Id;
        insert report1;

        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = sampleTitleLabel;
        contentVersion.PathOnClient = '/some sample title.txt';
        contentVersion.versionData = Blob.valueOf(sampleTitleLabel);
        contentVersion.ContentDocumentId  = document1.Id;
        contentVersion.ReasonForChange = 'test purposese';
        insert contentVersion;

        proxy.Title__c = 'proxy test title the second';
        proxy.LatestContentVersionId__c = contentVersion.Id;
        update proxy;

        system.assertEquals(contentVersion.Id, [SELECT LatestContentVersionId__c FROM OV_ContentProxy__c where Id = :proxy.Id].LatestContentVersionId__c);
        system.assertEquals(1, [SELECT Id from OV_Report__c where Desktop_Content_Proxy__c = :proxy.Id].size());
    }
    
    @isTest
    static void contentProxyHandlerAfterUpdate_Test(){
        OV_Category__c category1 = OV_TestingHelper.initCategory(category1Label, true);
        OV_Function__c function1 = OV_TestingHelper.initFunction(function1Label, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography(geography1Label, true);
        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion(test1Label, true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];

        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, proxyTitleLabel, contentVersion1.Id, SAMPLE_URL, true);
        system.assertEquals(proxy.ContentDocumentId__c, contentVersion1.ContentDocumentId);
        system.assertEquals(proxy.LatestContentVersionId__c, contentVersion1.Id);
        

        OV_Report__c report1 = OV_TestingHelper.initReport(REPORT1_LABEL, category1, function1, geography1, desktopLabel, false);
        report1.Desktop_Content_Proxy__c = proxy.Id;
        insert report1;
        
        OV_Report__c report2 = OV_TestingHelper.initReport(REPORT1_LABEL, category1, function1, geography1, desktopLabel, false);
        report2.Mobile_Content_Proxy__c = proxy.Id;
        insert report2;
        
        OV_Report__c report3 = OV_TestingHelper.initReport(REPORT1_LABEL, category1, function1, geography1, desktopLabel, false);
        report3.Tablet_Content_Proxy__c = proxy.Id;
        insert report3;
        
        EntitySubscription entitySubscription1 = OV_TestingHelper.initEntitySubscription(UserInfo.getUserId(), report1.Id, true);
        EntitySubscription entitySubscription2 = OV_TestingHelper.initEntitySubscription(UserInfo.getUserId(), report2.Id, true);
        EntitySubscription entitySubscription3 = OV_TestingHelper.initEntitySubscription(UserInfo.getUserId(), report3.Id, true);

        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = sampleTitleLabel;
        contentVersion.PathOnClient = '/some sample title.txt';
        contentVersion.versionData = Blob.valueOf(sampleTitleLabel);
        contentVersion.ContentDocumentId  = document1.Id;
        contentVersion.ReasonForChange = 'test purposese';
        insert contentVersion;

        proxy.Title__c = 'proxy test title the second';
        proxy.LatestContentVersionId__c = contentVersion.Id;
        update proxy;

        system.assertEquals(contentVersion.Id, [SELECT LatestContentVersionId__c FROM OV_ContentProxy__c where Id = :proxy.Id].LatestContentVersionId__c);
        system.assertEquals(1, [SELECT Id from OV_Report__c where Desktop_Content_Proxy__c = :proxy.Id].size());
    }
    

    @isTest
    static void handleDocumentContentDeleteTest() {
        
        OV_Trigger_Enablement__c triggerSwitchCustomSetting = OV_Trigger_Enablement__c.getOrgDefaults();
        triggerSwitchCustomSetting.ContentDocument__c = true;
        triggerSwitchCustomSetting.ContentProxy__c = true;     
        triggerSwitchCustomSetting.KPIElement__c = true;   
        insert triggerSwitchCustomSetting;

        OV_Category__c category1 = OV_TestingHelper.initCategory(category1Label, true);
        OV_Function__c function1 = OV_TestingHelper.initFunction(function1Label, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography(geography1Label, true);
        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion(test1Label, true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];
        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, proxyTitleLabel, contentVersion1.Id, SAMPLE_URL, true);

        OV_Report__c report1 = OV_TestingHelper.initReport(REPORT1_LABEL, category1, function1, geography1, desktopLabel, false);
        report1.Desktop_Content_Proxy__c = proxy.Id;
        insert report1;

        system.assertEquals(1, [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :document1.Id].size());
        system.assertEquals(1, [SELECT Id from OV_ContentProxy__c where ContentDocumentId__c = :document1.Id].size());
        system.assertEquals(1, [SELECT Id from OV_Report__c where Desktop_Content_Proxy__c = :proxy.Id].size());
        delete document1;

        //validate that content document and proxy are deleted from database
        system.assertEquals(0, [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :document1.Id].size());
        system.assertEquals(0, [SELECT Id from OV_ContentProxy__c where ContentDocumentId__c = :document1.Id].size());
    }

    @isTest
    static void handleDocumentConenteUndeleteTest() {
        OV_Trigger_Enablement__c triggerSwitchCustomSetting = OV_Trigger_Enablement__c.getOrgDefaults();
        triggerSwitchCustomSetting.ContentDocument__c = true;
        triggerSwitchCustomSetting.ContentProxy__c = true;     
        triggerSwitchCustomSetting.KPIElement__c = true;   
        insert triggerSwitchCustomSetting;

        OV_Category__c category1 = OV_TestingHelper.initCategory(category1Label, true);
        OV_Function__c function1 = OV_TestingHelper.initFunction(function1Label, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography(geography1Label, true);

        //create content version and add it to library
        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion(test1Label, true);

        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];
        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, proxyTitleLabel, contentVersion1.Id, SAMPLE_URL, true);

        OV_Report__c report1 = OV_TestingHelper.initReport(REPORT1_LABEL, category1, function1, geography1, desktopLabel, false);
        report1.Desktop_Content_Proxy__c = proxy.Id;
        insert report1;

        system.assertEquals(1, [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :document1.Id].size());
        system.assertEquals(1, [SELECT Id from OV_ContentProxy__c where ContentDocumentId__c = :document1.Id].size());
        system.assertEquals(1, [SELECT Id from OV_Report__c where Desktop_Content_Proxy__c = :proxy.Id].size());
        delete document1;

        //validate that content document and proxy are deleted from database
        system.assertEquals(0, [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :document1.Id].size());
        system.assertEquals(0, [SELECT Id from OV_ContentProxy__c where ContentDocumentId__c = :document1.Id].size());

        undelete document1;
        //verify undelete
        system.assertEquals(1, [SELECT Id from OV_ContentProxy__c where ContentDocumentId__c = :document1.Id].size());
    }
    
    @isTest
    static void handleDocumentContentDeleteWithEntitiesTest() {
        OV_Trigger_Enablement__c triggerSwitchCustomSetting = OV_Trigger_Enablement__c.getOrgDefaults();
        triggerSwitchCustomSetting.ContentDocument__c = true;
        triggerSwitchCustomSetting.ContentProxy__c = true;     
        triggerSwitchCustomSetting.KPIElement__c = true;   
        insert triggerSwitchCustomSetting;


        OV_Category__c category1 = OV_TestingHelper.initCategory(category1Label, true);
        OV_Function__c function1 = OV_TestingHelper.initFunction(function1Label, true);
        OV_Geography__c geography1 = OV_TestingHelper.initGeography(geography1Label, true);
        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion(test1Label, true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];
        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, proxyTitleLabel, contentVersion1.Id, SAMPLE_URL, true);
        
        
        OV_Report__c report1 = OV_TestingHelper.initReport(REPORT1_LABEL, category1, function1, geography1, desktopLabel, false);
        report1.Desktop_Content_Proxy__c = proxy.Id;
        insert report1;
        
        EntitySubscription entitySubscription = OV_TestingHelper.initEntitySubscription(UserInfo.getUserId(), report1.Id, true);

        system.assertEquals(1, [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :document1.Id].size());
        system.assertEquals(1, [SELECT Id from OV_ContentProxy__c where ContentDocumentId__c = :document1.Id].size());
        system.assertEquals(1, [SELECT Id from OV_Report__c where Desktop_Content_Proxy__c = :proxy.Id].size());
        delete document1;

        //validate that content document and proxy are deleted from database
        system.assertEquals(0, [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :document1.Id].size());
        system.assertEquals(0, [SELECT Id from OV_ContentProxy__c where ContentDocumentId__c = :document1.Id].size());
    }
    
}