/**********************************************************************
Name: OV_ReportContentServiceImpl_Test
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Tests for OV_ReportContentService
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Dan Harfleet            24/06/2015      INITIAL DEVELOPMENT
1.1 -   Maciej Krol             06/08/2015      CHANGES RELATED TO CONTENT PROXY
**********************************************************************/
@isTest
private class OV_ReportContentServiceImpl_Test {
    public static final String SAMPLE_ID        = '001xa000003DIlo';
    public static final String TEST_NAME        = 'test';
    public static final String PERMISSION_EXC_MSG   = 'You do not have permission to update One View Reports';
    public static final String ENUSLOCALE            = 'en_US';


    @isTest static void testDesktop() {
        Id currentUserId = UserInfo.getUserId();

        OV_Category__c category1 = OV_TestingHelper.initCategory('Category 1', true);

        OV_Geography__c geography1 = OV_TestingHelper.initGeography('Geography 1', true);

        OV_Function__c function1 = OV_TestingHelper.initFunction('Function 1', true);

        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion('Test 1', true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];

        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, 'proxy test title', contentVersion1.Id, 'www.google.com', true);
        system.assertEquals(proxy.ContentDocumentId__c, contentVersion1.ContentDocumentId);
        system.assertEquals(proxy.LatestContentVersionId__c, contentVersion1.Id);

        OV_Report__c report1 = OV_TestingHelper.initReportWithProxy('Report 1', category1, function1, geography1, 'Desktop', proxy.Id, true);

        ApexPages.currentPage().getParameters().put('device', 'Desktop');
        ApexPages.StandardController sc = new ApexPages.StandardController(report1);
        
        OV_DynamicShellController controller = new OV_DynamicShellController(sc);
        System.assertEquals(controller.srcUrl, report1.Desktop_Content_Proxy__r.Url__c);
    }   

    @isTest(SeeAllData=true) 
    static void testListContentLibraries() {
        // difficult to do in unit tests
        OV_ReportContentService service = new OV_ReportContentServiceImpl();
        List<OV_ContentLibrary> result;

        Test.startTest();
            result = service.listContentLibraries();
        Test.stopTest();

        System.assert(result != null);
        System.assert(result.size() > 0);
    }

    @isTest static void testFindContentVersionById() {
        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion('test1', null, true);
        ContentVersion contentVersion2 = OV_TestingHelper.initContentVersion('test2', null, true);
        Id parentId = contentVersion1.ContentDocumentId;
        ContentVersion contentVersion3 = OV_TestingHelper.initContentVersion('test3', parentId, true);

        OV_ReportContentService service = new OV_ReportContentServiceImpl();

        Test.startTest();
        ContentVersion actual = service.findContentVersionById(contentVersion3.Id);
        Test.stopTest();

        System.assertEquals(actual.Id, contentVersion3.Id);
        System.assertEquals(actual.ContentDocumentId, contentVersion3.ContentDocumentId);
        System.assertEquals(actual.PathOnClient, contentVersion3.PathOnClient);
    }

    @isTest static void testFindContentVersionByIdError() {
        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion('test1', null, true);
        ContentVersion contentVersion2 = OV_TestingHelper.initContentVersion('test2', null, true);
        Id parentId = contentVersion1.ContentDocumentId;
        ContentVersion contentVersion3 = OV_TestingHelper.initContentVersion('test3', parentId, true);

        //delete contentVersion3;
        
        String prefix = ContentVersion.sObjectType.getDescribe().getKeyPrefix();
        Id wrongId = prefix + 'e000000XRIb0';
                
        OV_ReportContentService service = new OV_ReportContentServiceImpl();

        Test.startTest();
        Boolean isException = false;
        try{
            ContentVersion actual = service.findContentVersionById(SAMPLE_ID);
        } catch (Exception e){
            isException = true;
        }
        system.assertEquals(true, isException);
        Test.stopTest();
    }

    @isTest static void testFindContentVersionByIdNull() {
        OV_ReportContentService service = new OV_ReportContentServiceImpl();

        Exception expectedException;
        String expectedMessage = 'IncorrectValueException: Expected value not found for id, expectednot nullbut was null';

        Test.startTest();
        try
        {
            ContentVersion actual = service.findContentVersionById(null);
        }
        catch(Exception e)
        {
            expectedException = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, expectedException);
        System.assertEquals(expectedException.getMessage(), expectedMessage);
    }

    @isTest static void testFindContentVersionByIdIncorrect() {
        OV_ReportContentService service = new OV_ReportContentServiceImpl();
        Id incorrectId = Id.valueOf(SAMPLE_ID);

        Exception expectedException;
        String expectedMessage = 'Could not find a ContentVersion with Id';


        Test.startTest();
        try
        {
            ContentVersion actual = service.findContentVersionById(incorrectId);
        }
        catch(Exception e)
        {
            expectedException = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, expectedException);
        System.assert(expectedException.getMessage().startsWith(expectedMessage));
    }

    @isTest static void testFindContentVersionForContentDocumentId() {
        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion('test1', null, true);
        ContentVersion contentVersion2 = OV_TestingHelper.initContentVersion('test2', null, true);
        Id parentId = contentVersion1.ContentDocumentId;
        ContentVersion contentVersion3 = OV_TestingHelper.initContentVersion('test3', parentId, true);

        OV_ReportContentService service = new OV_ReportContentServiceImpl();

        Test.startTest();
        ContentVersion actual = service.findContentVersionForContentDocumentId(contentVersion3.ContentDocumentId);
        Test.stopTest();

        System.assertEquals(contentVersion3.Id, actual.Id);
        System.assertEquals(contentVersion3.ContentDocumentId, actual.ContentDocumentId);
        System.assertEquals(contentVersion3.PathOnClient, actual.PathOnClient);
    }


    @isTest static void testFindContentVersionForContentDocumentIdNull() {
        OV_ReportContentService service = new OV_ReportContentServiceImpl();

        Exception expectedException;
        String expectedMessage = 'IncorrectValueException: Expected value not found for contentDocumentId, expectednot nullbut was null';

        Test.startTest();
        try
        {
            ContentVersion actual = service.findContentVersionForContentDocumentId(null);
        }
        catch(Exception e)
        {
            expectedException = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, expectedException);
        System.assertEquals(expectedException.getMessage(), expectedMessage);
    }

    @isTest static void testFindContentVersionForContentDocumentIdWrong() {
        OV_ReportContentService service = new OV_ReportContentServiceImpl();

        Id incorrectId = Id.valueOf(SAMPLE_ID);

        Exception expectedException;
        String expectedMessage = 'Could not find a ContentVersion with Id';

        Test.startTest();
        try
        {
            ContentVersion actual = service.findContentVersionForContentDocumentId(incorrectId);
        }
        catch(Exception e)
        {
            expectedException = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, expectedException);
        System.assert(expectedException.getMessage().startsWith(expectedMessage));
    }

    @isTest static void testCreateContentVersion() {
        ContentVersion contentVersion = OV_TestingHelper.initContentVersion(TEST_NAME, null, false);

        OV_ReportContentService service = new OV_ReportContentServiceImpl();

        Test.startTest();
        ContentVersion actual = service.createContentVersion(contentVersion);
        Test.stopTest();

        System.assertEquals(actual.Title, TEST_NAME);
    }

    @isTest static void testCreateContentVersionNull() {
        OV_ReportContentService service = new OV_ReportContentServiceImpl();
        Exception expectedException;

        Test.startTest();

        try
        {
            ContentVersion actual = service.createContentVersion(null);
        }
        catch(Exception e)
        {
            expectedException = e;
        }

        Test.stopTest();

        System.assertNotEquals(null, expectedException);
        System.assertEquals(expectedException.getMessage(), 'IncorrectValueException: Expected value not found for candidate, expectednot nullbut was null');
    }

    @isTest static void testCreateContentVersionOtherException() {

        ContentVersion contentVersion = OV_TestingHelper.initContentVersion(TEST_NAME, null, false);
        contentVersion.Title = null;
        contentVersion.PathOnClient = null;
        contentVersion.versionData = null;

        OV_ReportContentService service = new OV_ReportContentServiceImpl();
        Exception expectedException;

        Test.startTest();

        try
        {
            ContentVersion actual = service.createContentVersion(contentVersion);
        }
        catch(Exception e)
        {
            expectedException = e;
        }

        Test.stopTest();

        System.assertNotEquals(null, expectedException);
        System.assertEquals(expectedException.getMessage(), 'There was a problem creating the ContentVersionContentVersion:{Title=null, PathOnClient=null, VersionData=null}');
    }

    //@isTest static void testUpdateReportWithContentProxyId() {
    //  OV_Category__c category1 = OV_TestingHelper.initCategory('Category 1', true);

 //       OV_Geography__c geography1 = OV_TestingHelper.initGeography('Geography 1', true);

 //       OV_Function__c function1 = OV_TestingHelper.initFunction('Function 1', true);

 //       ContentVersion contentVersion = OV_TestingHelper.initContentVersion('Test 1', true);
 //       ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion.ContentDocumentId limit 1][0];     

 //       OV_Report__c reportFixture = OV_TestingHelper.initReport('Report 1', category1, function1, geography1, 'Desktop', contentVersion.Id, true);

 //         Id expectedContentDocumentId = contentVersion.ContentDocumentId;

 //         OV_ReportContentService service = new OV_ReportContentServiceImpl();

    //  Test.startTest();
 //         OV_Report__c updatedReport = service.updateReportWithContentProxyId(reportFixture, expectedContentDocumentId, OV_DeviceType.DESKTOP);
    //  Test.stopTest();

    //  OV_Report__c requeriedReport = [SELECT Id, Desktop_Content_Proxy__r.ContentDocumentId__c FROM OV_Report__c where Id = :reportFixture.Id];

    //  System.assertEquals(expectedContentDocumentId, updatedReport.Desktop_Content_Proxy__r.ContentDocumentId__c);
    //  System.assertEquals(expectedContentDocumentId, requeriedReport.Desktop_Content_Proxy__r.ContentDocumentId__c);
    //}


    //@isTest static void testUpdateReportWithContentDocumentIdTablet() {

    //  ContentVersion contentVersion = OV_TestingHelper.initContentVersion(TEST_NAME, null, true);

    //  String reportNameFixture = 'report name fixture';
    //  OV_Report__c reportFixture = insertReport(reportNameFixture);

 //         Id expectedContentDocumentId = contentVersion.ContentDocumentId;


 //         OV_ReportContentService service = new OV_ReportContentServiceImpl();

    //  Test.startTest();
 //         OV_Report__c updatedReport = service.updateReportWithContentDocumentId(reportFixture, expectedContentDocumentId, OV_DeviceType.TABLET);
    //  Test.stopTest();

    //  OV_Report__c requeriedReport = [SELECT Id, ContentDocumentTablet__c FROM OV_Report__c where Id = :reportFixture.Id];

    //  System.assertEquals(expectedContentDocumentId, updatedReport.ContentDocumentTablet__c);
    //  System.assertEquals(expectedContentDocumentId, requeriedReport.ContentDocumentTablet__c);
    //  System.assertEquals(reportNameFixture, reportFixture.Name);
    //  System.assertEquals(reportNameFixture, updatedReport.Name);

    //}

    //@isTest static void testUpdateReportWithContentDocumentIdMobile() {

    //  ContentVersion contentVersion = OV_TestingHelper.initContentVersion(TEST_NAME, null, true);

    //  String reportNameFixture = 'report name fixture';
    //  OV_Report__c reportFixture = insertReport(reportNameFixture);

 //         Id expectedContentDocumentId = contentVersion.ContentDocumentId;


 //         OV_ReportContentService service = new OV_ReportContentServiceImpl();

    //  Test.startTest();
 //         OV_Report__c updatedReport = service.updateReportWithContentDocumentId(reportFixture, expectedContentDocumentId, OV_DeviceType.MOBILE);
    //  Test.stopTest();

    //  OV_Report__c requeriedReport = [SELECT Id, ContentDocumentMobile__c, ContentDocumentTablet__c FROM OV_Report__c where Id = :reportFixture.Id];

    //  System.assertEquals(expectedContentDocumentId, updatedReport.ContentDocumentMobile__c);
    //  System.assertEquals(expectedContentDocumentId, requeriedReport.ContentDocumentMobile__c);
    //  System.assertEquals(reportNameFixture, reportFixture.Name);
    //  System.assertEquals(reportNameFixture, updatedReport.Name);
    //}

    //@isTest static void testUpdateReportWithContentDocumentIdWrongId()
    //{
    //  ContentVersion contentVersion = OV_TestingHelper.initContentVersion(TEST_NAME, null, true);

    //  String reportNameFixture = 'report name fixture';
    //  OV_Report__c reportFixture = insertReport(reportNameFixture);

 //         Id incorrectId = Id.valueOf(SAMPLE_ID);

    //  Exception expectedException;
    //  String expectedMessage = 'is not a valid ContentDocumentId';

 //         OV_ReportContentService service = new OV_ReportContentServiceImpl();

    //  Test.startTest();
 //         try
    //  {
    //      OV_Report__c updatedReport = service.updateReportWithContentDocumentId(reportFixture, incorrectId, OV_DeviceType.DESKTOP);
    //  }
    //  catch(Exception e)
    //  {
    //      expectedException = e;
    //  }
    //  Test.stopTest();

    //  System.assertNotEquals(null, expectedException);
    //  System.assert(expectedException.getMessage().endsWith(expectedMessage), 'Received message: ' + expectedException.getMessage() + ' Expected: ' + expectedMessage);
    //}


    @isTest static void testUpdateReportWithContentDocumentIdNull()
    {
        OV_ReportContentService service = new OV_ReportContentServiceImpl();

        Exception expectedException;
        String expectedMessage = 'IncorrectValueException: Expected value not found for contentDocumentId or report, expectednot nullbut was null';

        Test.startTest();
        try
        {
            OV_Report__c updatedReport = service.updateReportWithContentProxyId(null, null, OV_DeviceType.DESKTOP);
        }
        catch(Exception e)
        {
            expectedException = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, expectedException);
        System.assert(expectedException.getMessage().endsWith(expectedMessage));
    }


    @isTest static void testFindReportById()
    {
        String reportNameFixture = 'report name fixture';
        OV_Report__c reportFixture = insertReport(reportNameFixture);

        OV_ReportContentService service = new OV_ReportContentServiceImpl();

        Test.startTest();
        OV_Report__c actual = service.findReportById(reportFixture.Id);
        Test.stopTest();

        System.assertEquals(reportFixture.Id, actual.Id);
        System.assertEquals(reportFixture.Name, actual.Name);
    }


    @isTest static void testFindReportByNull()
    {
        Exception expectedException;
        String expectedMessage = 'IncorrectValueException: Expected value not found for reportId, expectednot nullbut was null';

        OV_ReportContentService service = new OV_ReportContentServiceImpl();

        Test.startTest();
        try
        {
            OV_Report__c actual = service.findReportById(null);
        }
        catch(Exception e)
        {
            expectedException = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, expectedException);
        System.assertEquals(expectedException.getMessage(), expectedMessage);
    }


    @isTest static void testFindReportByWrongId()
    {
        Exception expectedException;
        String expectedMessage = 'Could not find an OV_Report__c with Id';
        Id wrongId = Id.valueOf(SAMPLE_ID);

        OV_ReportContentService service = new OV_ReportContentServiceImpl();

        Test.startTest();
        try
        {
            OV_Report__c actual = service.findReportById(wrongId);
        }
        catch(Exception e)
        {
            expectedException = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, expectedException);
        System.assert(expectedException.getMessage().startsWith(expectedMessage));
    }


    @isTest static void testUpdateReportWithContentDocumentIdPermissionForDesktop()
    {
        OV_Report__c report = insertReport(TEST_NAME);
        Id insignificantId = Id.valueOf(SAMPLE_ID);

        String expectedMessage = PERMISSION_EXC_MSG;
        Exception expectedException;
        User user = createBadUser();

        OV_ReportContentService service = new OV_ReportContentServiceImpl();

        Test.startTest();
        System.runAs(user) {
            try
            {
                service.updateReportWithContentProxyId(report, insignificantId, OV_DeviceType.DESKTOP);

            }
            catch(Exception e)
            {
                expectedException = e;
            }
        }

        Test.stopTest();

        System.assertNotEquals(null, expectedException);
        System.assertEquals(expectedException.getMessage(), expectedMessage);
    }

    @isTest static void testUpdateReportWithContentDocumentIdPermissionForMobile()
    {
        OV_Report__c report = insertReport(TEST_NAME);
        Id insignificantId = Id.valueOf(SAMPLE_ID);

        String expectedMessage = PERMISSION_EXC_MSG;
        Exception expectedException;
        User user = createBadUser();

        OV_ReportContentService service = new OV_ReportContentServiceImpl();


        Test.startTest();
        System.runAs(user) {
            try
            {
                service.updateReportWithContentProxyId(report, insignificantId, OV_DeviceType.MOBILE);
            }
            catch(Exception e)
            {
                expectedException = e;
            }
        }

        Test.stopTest();

        System.assertNotEquals(null, expectedException);
        System.assertEquals(expectedException.getMessage(), expectedMessage);
    }

    @isTest static void testUpdateReportWithContentDocumentIdPermissionForTablet()
    {
        OV_Report__c report = insertReport(TEST_NAME);
        Id insignificantId = Id.valueOf(SAMPLE_ID);

        String expectedMessage = PERMISSION_EXC_MSG;
        Exception expectedException;
        User user = createBadUser();

        OV_ReportContentService service = new OV_ReportContentServiceImpl();


        Test.startTest();
        System.runAs(user) {
            try
            {
                service.updateReportWithContentProxyId(report, insignificantId, OV_DeviceType.TABLET);
            }
            catch(Exception e)
            {
                expectedException = e;
            }
        }

        Test.stopTest();

        System.assertNotEquals(null, expectedException);
        System.assertEquals(expectedException.getMessage(), expectedMessage);
    }

    @isTest static void testUpdateReportWithContentDocumentIdWithSysAdmin()
    {
        OV_Report__c report = insertReport(TEST_NAME);
        ContentVersion contentVersion1 = OV_TestingHelper.initContentVersion('Test 1', true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion1.ContentDocumentId limit 1][0];
        
        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, 'proxy test title', contentVersion1.Id, 'www.google.com', true);
        System.debug('document1: ' + document1);
        System.debug('proxy: ' + proxy);

        String expectedMessage = PERMISSION_EXC_MSG;
        Exception expectedException;
        User user = createSystemAdministratorUser();

        OV_ReportContentService service = new OV_ReportContentServiceImpl();
        OV_Report__c resultDesktop;
        OV_Report__c resultMobile;
        OV_Report__c resultTablet;

        Test.startTest();
        System.runAs(user) {
            try
            {
                resultDesktop = service.updateReportWithContentProxyId(report, document1.Id, OV_DeviceType.DESKTOP);
                resultMobile = service.updateReportWithContentProxyId(report, document1.Id, OV_DeviceType.MOBILE);
                resultTablet = service.updateReportWithContentProxyId(report, document1.Id, OV_DeviceType.TABLET);
            }
            catch(Exception e)
            {
                expectedException = e;
            }
        }

        Test.stopTest();

        System.assertEquals(null, expectedException);
        System.assertEquals(resultDesktop.Desktop_Content_Proxy__c, proxy.Id);
        System.assertEquals(resultMobile.Mobile_Content_Proxy__c, proxy.Id);
        System.assertEquals(resultTablet.Tablet_Content_Proxy__c, proxy.Id);
    }


    @isTest static void testFindReportByIdPermission()
    {
        Id insignificantId = Id.valueOf(SAMPLE_ID);

        String expectedMessage = 'You do not have permission to access One View Reports';
        Exception expectedException;
        User user = createBadUser();

        OV_ReportContentService service = new OV_ReportContentServiceImpl();

        Test.startTest();
        System.runAs(user) {
            try
            {
                service.findReportById(insignificantId);
            }
            catch(Exception e)
            {
                expectedException = e;
            }
        }

        Test.stopTest();

        System.assertNotEquals(null, expectedException);
        System.assertEquals(expectedException.getMessage(), expectedMessage);
    }


    //=== Candidate methods for extracting to OV_TestingHelper.cls

    private static OV_Report__c insertReport(String reportName)
    {
        return initReport(reportName, true);
    }

    private static OV_Report__c initReport(String reportName, Boolean insertFlag)
    {
        OV_Category__c categoryFixture = OV_TestingHelper.initCategory('Category 1', true);
        OV_Function__c functionFixture = OV_TestingHelper.initFunction('Function 1', true);
        OV_Geography__c geographyFixture = OV_TestingHelper.initGeography('Geography 1', true);
        return OV_TestingHelper.initReport(reportName, categoryFixture, functionFixture, geographyFixture, 'Desktop', insertFlag);
    }

    private static User createBadUser()
    {
        Profile profile = [SELECT Id FROM Profile WHERE Name='Chatter Free User' LIMIT 1];
        User u = new User(
            alias = TEST_NAME,
            email = 'a@b.com',
            lastname = 'uLastName',
            profileId = profile.Id,
            username = 'abc@sfdcOV.sfdc1',
            emailencodingkey = 'UTF-8',
            languagelocalekey = ENUSLOCALE,
            localesidkey = ENUSLOCALE,
            timezonesidkey='America/Los_Angeles'
        );

        u.UserPermissionsSFContentUser = null;
        insert u;
        return u;
    }

    private static User createSystemAdministratorUser()
    {
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User u = new User(
            alias = TEST_NAME,
            email = 'a@b.com',
            lastname = 'uLastName',
            profileId = profile.Id,
            username = 'abc@sfdcOV.sfdc1',
            emailencodingkey = 'UTF-8',
            languagelocalekey = ENUSLOCALE,
            localesidkey = ENUSLOCALE,
            timezonesidkey='America/Los_Angeles'
        );

        u.UserPermissionsSFContentUser = null;
        insert u;
        return u;
    }
}