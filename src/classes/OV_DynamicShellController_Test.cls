/**********************************************************************
Name: OV_DynamicShellController_Test
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Test Class test OV_DynamicShellController
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             22/06/2015      INITIAL DEVELOPMENT
**********************************************************************/
@isTest
private class OV_DynamicShellController_Test {
    static final String category1Label = 'Category 1';
    static final String geography1Label = 'Geography 1';
    static final String function1Label = 'Function 1';
    static final String test1Label = 'Test 1';
    static final String titleLabel = 'proxy test title';
    static final String desktopLabel = 'Desktop';
    static final String deviceLabel = 'device';
    static final String testLabel = 'test';

    public static final String REPORT1_LABEL         = 'Report 1';
    public static final String SAMPLE_URL            = 'www.salesforce.com';
    
    @isTest static void testDesktop() {
        Id currentUserId = UserInfo.getUserId();

        OV_Category__c category1 = OV_TestingHelper.initCategory(category1Label, true);

        OV_Geography__c geography1 = OV_TestingHelper.initGeography(geography1Label, true);

        OV_Function__c function1 = OV_TestingHelper.initFunction(function1Label, true);

        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion(test1Label, true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];

        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, titleLabel, contentVersion1.Id, SAMPLE_URL, true);
        system.assertEquals(proxy.ContentDocumentId__c, contentVersion1.ContentDocumentId);
        system.assertEquals(proxy.LatestContentVersionId__c, contentVersion1.Id);

        OV_Report__c report1 = OV_TestingHelper.initReportWithProxy(REPORT1_LABEL, category1, function1, geography1, desktopLabel, proxy.Id, true);

        ApexPages.currentPage().getParameters().put(deviceLabel, desktopLabel);
        ApexPages.StandardController sc = new ApexPages.StandardController(report1);
        
        OV_DynamicShellController controller = new OV_DynamicShellController(sc);
        System.assertEquals(controller.srcUrl, report1.Desktop_Content_Proxy__r.Url__c);
    }

    @isTest static void testMobile() {
        Id currentUserId = UserInfo.getUserId();

        OV_Category__c category1 = OV_TestingHelper.initCategory(category1Label, true);

        OV_Geography__c geography1 = OV_TestingHelper.initGeography(geography1Label, true);

        OV_Function__c function1 = OV_TestingHelper.initFunction(function1Label, true);

        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion(test1Label, true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];

        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, titleLabel, contentVersion1.Id, SAMPLE_URL, true);
        system.assertEquals(proxy.ContentDocumentId__c, contentVersion1.ContentDocumentId);
        system.assertEquals(proxy.LatestContentVersionId__c, contentVersion1.Id);

        OV_Report__c report1 = OV_TestingHelper.initReportWithProxy(REPORT1_LABEL, category1, function1, geography1, 'Mobile', proxy.Id, true);

        ApexPages.currentPage().getParameters().put(deviceLabel, 'Mobile');
        ApexPages.StandardController sc = new ApexPages.StandardController(report1);
        
        OV_DynamicShellController controller = new OV_DynamicShellController(sc);
        System.assertEquals(controller.srcUrl, report1.Mobile_Content_Proxy__r.Url__c);
    }

    @isTest static void testTablet() {
        Id currentUserId = UserInfo.getUserId();

        OV_Category__c category1 = OV_TestingHelper.initCategory(category1Label, true);

        OV_Geography__c geography1 = OV_TestingHelper.initGeography(geography1Label, true);

        OV_Function__c function1 = OV_TestingHelper.initFunction(function1Label, true);

        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion(test1Label, true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];

        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, titleLabel, contentVersion1.Id, SAMPLE_URL, true);
        system.assertEquals(proxy.ContentDocumentId__c, contentVersion1.ContentDocumentId);
        system.assertEquals(proxy.LatestContentVersionId__c, contentVersion1.Id);

        OV_Report__c report1 = OV_TestingHelper.initReportWithProxy(REPORT1_LABEL, category1, function1, geography1, 'Tablet', proxy.Id, true);

        ApexPages.currentPage().getParameters().put(deviceLabel, 'Tablet');
        ApexPages.StandardController sc = new ApexPages.StandardController(report1);
        
        OV_DynamicShellController controller = new OV_DynamicShellController(sc);
        System.assertEquals(controller.srcUrl, report1.Tablet_Content_Proxy__r.Url__c);
    }

    @isTest static void testDefault() {
        Id currentUserId = UserInfo.getUserId();

        OV_Category__c category1 = OV_TestingHelper.initCategory(category1Label, true);

        OV_Geography__c geography1 = OV_TestingHelper.initGeography(geography1Label, true);

        OV_Function__c function1 = OV_TestingHelper.initFunction(function1Label, true);

        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion(test1Label, true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];

        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, titleLabel, contentVersion1.Id, SAMPLE_URL, true);
        system.assertEquals(proxy.ContentDocumentId__c, contentVersion1.ContentDocumentId);
        system.assertEquals(proxy.LatestContentVersionId__c, contentVersion1.Id);

        OV_Report__c report1 = OV_TestingHelper.initReportWithProxy(REPORT1_LABEL, category1, function1, geography1, 'Tablet', proxy.Id, true);

        ApexPages.StandardController sc = new ApexPages.StandardController(report1);
        delete report1;
        OV_DynamicShellController controller = new OV_DynamicShellController(sc);
        
    }

    @isTest static void testSharing() {
        Profile profile = OV_TestingHelper.getUserProfile();
        User u;

        User u2 = new User(
            alias = testLabel,  
            email = 'test@test2.com', 
            lastname = testLabel,
            profileId = profile.Id,
            username = 'test2@ov.com',
            emailencodingkey = 'UTF-8',
            languagelocalekey = 'en_US', 
            localesidkey = 'en_US',
            timezonesidkey='America/Los_Angeles'
        );

        system.runas(u2) {
            u = OV_TestingHelper.createUser(profile, testLabel, 'test@test.com', testLabel); 
            PermissionSet permSet = [Select Id from PermissionSet where Name = 'OV_Consumer' LIMIT 1];        
            PermissionSetAssignment permSetAssignment = new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = permSet.Id);
            insert permSetAssignment;  
        }
                
        Test.startTest();
        OV_Category__c category1 = OV_TestingHelper.initCategory(category1Label, true);

        OV_Geography__c geography1 = OV_TestingHelper.initGeography(geography1Label, true);

        OV_Function__c function1 = OV_TestingHelper.initFunction(function1Label, true);

        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion(test1Label, true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];

        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, titleLabel, contentVersion1.Id, SAMPLE_URL, true);
        system.assertEquals(proxy.ContentDocumentId__c, contentVersion1.ContentDocumentId);
        system.assertEquals(proxy.LatestContentVersionId__c, contentVersion1.Id);

        OV_Report__c report1 = OV_TestingHelper.initReportWithProxy(REPORT1_LABEL, category1, function1, geography1, desktopLabel, proxy.Id, true);

        OV_Report__Share reportShare = new OV_Report__Share();
        reportShare.ParentId = report1.Id;
        reportShare.UserOrGroupId = u.Id;
        reportShare.AccessLevel = 'Read';
        reportShare.RowCause = Schema.OV_Report__Share.RowCause.Manual;
        insert reportShare;

        System.runAs(u){
            ApexPages.currentPage().getParameters().put(deviceLabel, desktopLabel);
            ApexPages.StandardController sc = new ApexPages.StandardController(report1);        
            OV_DynamicShellController controller = new OV_DynamicShellController(sc);
            System.assertEquals(controller.srcUrl, report1.Desktop_Content_Proxy__r.Url__c);
        }
        Test.stopTest();        
    }
}