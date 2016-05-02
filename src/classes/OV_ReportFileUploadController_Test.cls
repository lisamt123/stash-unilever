/**********************************************************************
Name: OV_ReportFileUploadController_Test
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Test for OV_ReportFileUploadController
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Dan Harfleet            24/06/2015      INITIAL DEVELOPMENT
1.1 -   Dan Harfleet            24/06/2015      INITIAL DEVELOPMENT
**********************************************************************/
@isTest
private class OV_ReportFileUploadController_Test {
    static final String reportFileUploadURL = '/apex/ov_reportfileupload';
    static final String deviceTypeLabel = 'device_type';
    static final String reportIdLabel = 'report_id';
    static final String reportLabel = 'report';
    
    @isTest static void testCancel() {
        OV_Report__c report = insertReport('ut report');
        MockServiceWithLibraries service = new MockServiceWithLibraries(report, getMockId());

        PageReference pageReference = new PageReference(reportFileUploadURL);
        Test.setCurrentPage(pageReference);
        ApexPages.currentPage().getParameters().put(deviceTypeLabel, 'T');
        ApexPages.currentPage().getParameters().put(reportIdLabel, report.Id);


        Test.startTest();
        OV_ReportFileUploadController controller = new OV_ReportFileUploadController(service);
        PageReference actualPageReference = controller.cancel();

        Test.stopTest();

        System.assertEquals('/'+report.Id, actualPageReference.getUrl());
    }

    @isTest static void testBack() {
        OV_Report__c report = insertReport('ut report');
        MockServiceWithLibraries service = new MockServiceWithLibraries(report, getMockId());

        PageReference pageReference = new PageReference(reportFileUploadURL);
        Test.setCurrentPage(pageReference);
        ApexPages.currentPage().getParameters().put(deviceTypeLabel, 'T');
        ApexPages.currentPage().getParameters().put(reportIdLabel, report.Id);

        Test.startTest();
        OV_ReportFileUploadController controller = new OV_ReportFileUploadController(service);
        PageReference actualPageReference = controller.backToReport();

        Test.stopTest();
        System.assertEquals('/'+report.Id, actualPageReference.getUrl());
    }


    @isTest static void testUploadError() {
        String reportNameFixture = 'unit-test-report-name';
        OV_Report__c report = insertReport(reportNameFixture);
        MockServiceWithLibraries service = new MockServiceWithLibraries(report, getMockId());

        PageReference pageReference = new PageReference(reportFileUploadURL);
        Test.setCurrentPage(pageReference);
        ApexPages.currentPage().getParameters().put(deviceTypeLabel, 'T');
        ApexPages.currentPage().getParameters().put(reportIdLabel, report.Id);

        ContentVersion localFile = OV_TestingHelper.initContentVersion('this title should not matter', false);
        localFile.pathOnClient = 'foo.txt';

        Test.startTest();
        //code coverage
        OV_ReportFileUploadController c = new OV_ReportFileUploadController();

        OV_ReportFileUploadController controller = new OV_ReportFileUploadController(service);
        controller.file = localFile;

        PageReference actualPageReference = controller.upload();
        System.assertEquals(null, actualPageReference);
        Test.stopTest();
    }

    @isTest static void testUploadStatic() {
        String reportNameFixture = 'unit-test-report-name';
        OV_Report__c report = insertReport(reportNameFixture);
        MockServiceWithLibraries service = new MockServiceWithLibraries(report, getMockId());

        PageReference pageReference = new PageReference(reportFileUploadURL);
        Test.setCurrentPage(pageReference);
        ApexPages.currentPage().getParameters().put(deviceTypeLabel, 'T');
        ApexPages.currentPage().getParameters().put(reportIdLabel, report.Id);

        ContentVersion localFile = OV_TestingHelper.initContentVersion('this title should not matter', false);
        localFile.pathOnClient = 'foo.txt';

        Test.startTest();
        //code coverage
        OV_ReportFileUploadController c = new OV_ReportFileUploadController();

        OV_ReportFileUploadController controller = new OV_ReportFileUploadController(service);
        controller.file = localFile;
        controller.staticOrDynamic = 1;

        PageReference actualPageReference = controller.upload();
        System.assertEquals('/'+report.Id, actualPageReference.getUrl());
        Test.stopTest();
    }

    @isTest static void testUploadDynamic() {
        String reportNameFixture = 'unit-test-report-name';
        OV_Report__c report = insertReport(reportNameFixture);
        MockServiceWithLibraries service = new MockServiceWithLibraries(report, getMockId());

        PageReference pageReference = new PageReference(reportFileUploadURL);
        Test.setCurrentPage(pageReference);
        ApexPages.currentPage().getParameters().put(deviceTypeLabel, 'T');
        ApexPages.currentPage().getParameters().put(reportIdLabel, report.Id);

        ContentVersion localFile = OV_TestingHelper.initContentVersion('this title should not matter', false);
        localFile.pathOnClient = 'foo.txt';

        Test.startTest();
        //code coverage
        OV_ReportFileUploadController c = new OV_ReportFileUploadController();

        OV_ReportFileUploadController controller = new OV_ReportFileUploadController(service);
        controller.file = localFile;
        controller.staticOrDynamic = 2;

        PageReference actualPageReference = controller.upload();
        System.assertEquals('/'+report.Id, actualPageReference.getUrl());
        Test.stopTest();
    }

    @isTest static void testDeviceTypeNameTablet() {
        OV_Report__c report = insertReport(reportLabel);

        PageReference pageReference = new PageReference(reportFileUploadURL);
        Test.setCurrentPage(pageReference);
        ApexPages.currentPage().getParameters().put(deviceTypeLabel, 'T');
        ApexPages.currentPage().getParameters().put(reportIdLabel, report.Id);

        Id idFixture = getMockId();
        MockServiceWithLibraries service = new MockServiceWithLibraries(idFixture);

        Test.startTest();
        OV_ReportFileUploadController controller = new OV_ReportFileUploadController(service);
        String actualDeviceType = controller.deviceTypeName;

        Test.stopTest();

        String expectedDeviceType = 'Tablet';

        System.assertEquals(expectedDeviceType, actualDeviceType);
    }

    @isTest static void testDeviceTypeNameDesktop() {
        OV_Report__c report = insertReport(reportLabel);

        PageReference pageReference = new PageReference(reportFileUploadURL);
        Test.setCurrentPage(pageReference);
        ApexPages.currentPage().getParameters().put(deviceTypeLabel, 'D');
        ApexPages.currentPage().getParameters().put(reportIdLabel, report.Id);

        Id idFixture = getMockId();
        MockServiceWithLibraries service = new MockServiceWithLibraries(idFixture);

        Test.startTest();
        OV_ReportFileUploadController controller = new OV_ReportFileUploadController(service);
        String actualDeviceType = controller.deviceTypeName;

        Test.stopTest();

        String expectedDeviceType = 'Desktop';

        System.assertEquals(expectedDeviceType, actualDeviceType);
    }


    @isTest static void testDeviceTypeNameMobile() {
        OV_Report__c report = insertReport(reportLabel);

        PageReference pageReference = new PageReference(reportFileUploadURL);
        Test.setCurrentPage(pageReference);
        ApexPages.currentPage().getParameters().put(deviceTypeLabel, 'M');
        ApexPages.currentPage().getParameters().put(reportIdLabel, report.Id);

        Id idFixture = getMockId();
        MockServiceWithLibraries service = new MockServiceWithLibraries(idFixture);

        Test.startTest();
        OV_ReportFileUploadController controller = new OV_ReportFileUploadController(service);
        String actualDeviceType = controller.deviceTypeName;

        Test.stopTest();

        String expectedDeviceType = 'Mobile';

        System.assertEquals(expectedDeviceType, actualDeviceType);
    }


    @isTest static void testDeviceTypeNameNoParam() {
        OV_Report__c report = insertReport(reportLabel);

        PageReference pageReference = new PageReference(reportFileUploadURL);
        Test.setCurrentPage(pageReference);

        ApexPages.currentPage().getParameters().put(reportIdLabel, report.Id);

        Id idFixture = getMockId();
        MockServiceWithLibraries service = new MockServiceWithLibraries(idFixture);

        Test.startTest();
        OV_ReportFileUploadController controller = new OV_ReportFileUploadController(service);
        String actualDeviceType = controller.deviceTypeName;

        Test.stopTest();

        String expectedDeviceType = 'Desktop';

        System.assertEquals(expectedDeviceType, actualDeviceType);
    }

    @isTest static void testNoReportError() {
        OV_Report__c report = insertReport(reportLabel);

        PageReference pageReference = new PageReference(reportFileUploadURL);
        Test.setCurrentPage(pageReference);
        ApexPages.currentPage().getParameters().put(deviceTypeLabel, 'M');
        ApexPages.currentPage().getParameters().put(reportIdLabel, report.Id);

        delete report;

        OV_ReportContentServiceImpl service = new OV_ReportContentServiceImpl();

        Test.startTest();
        OV_ReportFileUploadController controller = new OV_ReportFileUploadController(service);
        //String actualDeviceType = controller.deviceTypeName;
        
        PageReference actualPageReference = controller.upload();
        System.assertEquals(null, actualPageReference);
        
        Test.stopTest();

        //System.assertEquals(expectedDeviceType, actualDeviceType);
    }

    @isTest static void testSelectedLibrary(){
        Id idFixture = getMockId();

        MockServiceWithLibraries service = new MockServiceWithLibraries(idFixture);

        Test.startTest();
        OV_ReportFileUploadController controller = new OV_ReportFileUploadController(service);
        controller.selectedLibrary = idFixture;
        Id selectedLibrary = controller.selectedLibrary;

        Test.stopTest();

        System.assertEquals(idFixture, selectedLibrary);
    }


    @isTest static void testLibraryList(){
        OV_Report__c report = insertReport(reportLabel);

        PageReference pageReference = new PageReference(reportFileUploadURL);
        Test.setCurrentPage(pageReference);
        ApexPages.currentPage().getParameters().put(deviceTypeLabel, 'T');
        ApexPages.currentPage().getParameters().put(reportIdLabel, report.Id);

        Id idFixture = getMockId();
        MockServiceWithLibraries service = new MockServiceWithLibraries(idFixture);

        Test.startTest();
        OV_ReportFileUploadController controller = new OV_ReportFileUploadController(service);
        List<SelectOption> options = controller.libraryList;

        Test.stopTest();

        System.assertEquals(1, options.size());
        SelectOption option = options[0];
        System.assertEquals('unit test library', option.getLabel());
        System.assertEquals(idFixture, option.getValue());
        controller.changeStaticDynamic();
        String name = controller.reportName;
        
    }

    private static Id getMockId(){
        User someUser = OV_TestingHelper.createAdminUser('ausr', 'admin@test.com', 'Test Admin User');
        return someUser.Id;
    }

    public class MockServiceWithLibraries extends OV_ReportContentServiceImpl
    {
        Id mockId;
        
        public MockServiceWithLibraries(OV_Report__c reportToReturn, Id someId)
        {
            this.reportToReturn = reportToReturn;
            this.mockId = someId;
        }
        
        public MockServiceWithLibraries(Id someId)
        {
            this.mockId = someId;
        }

        override public List<OV_ContentLibrary> listContentLibraries()
        {

            List<OV_ContentLibrary> libraries = new List<OV_ContentLibrary>();
            libraries.add(new OV_ContentLibrary(Id.valueOf(mockId),'unit test library'));
            return libraries;
        }
        
        override public OV_Report__c findReportById(Id reportId)
        {
            return this.reportToReturn;
        }

        private OV_Report__c reportToReturn;
    }

    private static OV_Report__c insertReport(String reportName) {
        return initReport(reportName, true);
    }

    private static OV_Report__c initReport(String reportName, Boolean insertFlag) {

        OV_Category__c categoryFixture = OV_TestingHelper.initCategory('Category 1', true);
        OV_Function__c functionFixture = OV_TestingHelper.initFunction('Function 1', true);
        OV_Geography__c geographyFixture = OV_TestingHelper.initGeography('Geography 1', true);
        return OV_TestingHelper.initReport(reportName, categoryFixture, functionFixture, geographyFixture, 'Desktop', insertFlag);
    }
}