public with sharing class OV_ReportFileUploadControllerSFDC {
    /*
    private static String PARAM_TEST_SFDC = 'report_id';
    private static String PARAM_TEST_SFDC_2 = 'report_id';
    private static String PARAM_REPORT_ID = 'report_id';
    private static String PARAM_DEVICE_TYPE = 'device_type';
    private static String ERROR_PARAM_REPORT_ID = 'There has been an error, please click back or go back to the Report';
  private static String ERROR_REPORT_GENERAL = 'There has been an error finding the report';
    private static String ERROR_CONTENT_SIZE = 'The content is too larger (limit is 10Mb)';
    private static PageReference STAY_ON_PAGE = null;


    public OV_ReportFileUploadControllerSFDC()
    {
        OV_ReportContentService service = new OV_ReportContentServiceImpl();
        this.service = service;
        initialize();
    }


    // user to pass in mocks for unit testing
    public OV_ReportFileUploadControllerSFDC(OV_ReportContentService service)
    {
        this.service = service;
        initialize();
    }


    public ContentVersion file { get; set; }

    public List<SelectOption> libraryList{ get{ return libraryOptions; } }

    public Id selectedLibrary{ get; set; }

    public String reportName{ get{ return this.report.Name; } }


    public String deviceTypeName{ get{ return OV_DeviceType.descriptionForType(this.deviceType); } }
    


    //TODO  tag with report attributes ?


    public PageReference upload()
    {
        System.debug(LoggingLevel.DEBUG, 'OV_ReportFileUploadControllerSFDC.upload() start');
        this.file.Title = this.report.Name;
        if(this.selectedLibrary != null)
        {
            this.file.FirstPublishLocationId = selectedLibrary;
        }

        String pathOnClient = this.file.PathOnClient;
        System.debug(LoggingLevel.DEBUG, 'pathOnClient:' + pathOnClient);
        if(pathOnClient == null)
        {
            System.debug(LoggingLevel.ERROR, 'No path on client set');
        }

        try
        {
            ContentVersion thinContentVersion = service.createContentVersion(this.file);
            this.contentVersion = service.findContentVersionById(thinContentVersion.Id);
            Id contentDocumentId = this.contentVersion.ContentDocumentId;
            System.debug(LoggingLevel.DEBUG, 'this.contentVersion.ContentDocumentId:' + contentDocumentId);
            System.debug(LoggingLevel.DEBUG, 'file.ContentDocumentId:' + contentDocumentId);
            this.report = service.updateReportWithContentDocumentId(this.report, contentDocumentId, this.deviceType);
        }
        catch(Exception e)
        {
            System.debug(LoggingLevel.ERROR, e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not create content'));
            System.debug(LoggingLevel.ERROR, 'content size:' + this.file.ContentSize);
            System.debug(LoggingLevel.DEBUG, 'OV_ReportFileUploadControllerSFDC.upload() end in catch block');   
            return STAY_ON_PAGE;
        }
       
        System.debug(LoggingLevel.DEBUG, 'OV_ReportFileUploadControllerSFDC.upload() end');   
        return PageReferenceForBackToReport();
    }


    public PageReference cancel()
    {
        return PageReferenceForBackToReport();
    } 


    public PageReference backToReport()
    { 
        return PageReferenceForBackToReport();
    } 


    private void initialize()
    {        
        Id reportId = ApexPages.currentPage().getParameters().get(PARAM_REPORT_ID);
        
        if(reportId == null)
        {
            System.debug(LoggingLevel.ERROR, 'report_id page param is null');
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.FATAL, ERROR_PARAM_REPORT_ID) );
            return;
        }

        String deviceTypeParameter = ApexPages.currentPage().getParameters().get(PARAM_DEVICE_TYPE);

        if(deviceTypeParameter == null)
        {
            System.debug(LoggingLevel.WARN, 'device_type page param should be supplied, defaulting to DESKTOP');
        }
        
        this.deviceType = OV_DeviceType.typeForParameter(deviceTypeParameter);

        try
        {
            this.file = new ContentVersion();
            this.libraryOptions = buildOptionsForLibraries(service.listContentLibraries());
            this.report = findReportById(reportId); 
        }
        catch(Exception e)
        {
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.FATAL, 'There was a problem initializing the upload page') );
        }

        //System.debug(LoggingLevel.DEBUG, 'initialize - report' + this.report);
        //System.debug(LoggingLevel.DEBUG, 'initialize - report.Id' + this.report.Id);
        //System.debug(LoggingLevel.DEBUG, 'initialize - report.Name' + this.report.Name);

    }


    private List<SelectOption> buildOptionsForLibraries(List<OV_ContentLibrary> libraries)
    {
        List<SelectOption> results = new List<SelectOption>();
        for(OV_ContentLibrary library : libraries)
        {
            SelectOption option = new SelectOption(library.Id, library.Name);
            results.add(option);
        }
        System.debug(LoggingLevel.FINE, this.libraryOptions);
        System.debug(LoggingLevel.DEBUG, results.size());
        return results;
    }


    private OV_Report__c findReportById(Id reportId)
    {
        System.debug(LoggingLevel.DEBUG, 'findReportById.reportId:' + reportId);
            
        OV_Report__c report;

        try
        {
            report = service.findReportById(reportId);
        }
        catch(Exception e)
        {
            System.debug(LoggingLevel.ERROR, e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_REPORT_GENERAL));
        }
        
        return report;
    }
    

    private PageReference PageReferenceForBackToReport()
    {
        return new PageReference('/' + this.report.Id);
    }


    private OV_ReportContentService service;
    private OV_Report__c report;
    private ContentVersion contentVersion;
    private List<SelectOption> libraryOptions;
    private Integer deviceType;
    */

}