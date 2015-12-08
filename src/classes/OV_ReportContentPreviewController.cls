/**********************************************************************
Name: OV_ReportContentPreviewController
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Class for generating preview links
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Dan Harfleet            24/06/2015      INITIAL DEVELOPMENT
1.1 -   Maciej Krol             06/08/2015      CHANGES RELATED TO CONTENT PROXY
**********************************************************************/
public with sharing class OV_ReportContentPreviewController {   
    private static String PARAM_DEVICE_TYPE = 'device_type';
    private static String CONFIG_THUMB_SIZE = OV_ThumbnailPreviewBuilder.DESKTOP; 
 
    public OV_ReportContentPreviewController(ApexPages.StandardController stdController) {        
        init(stdController, new OV_ReportContentServiceImpl());
    }

    public OV_ReportContentPreviewController(ApexPages.StandardController stdController, OV_ReportContentService service) {        
        init(stdController, service);
    }

    public Id desktopContentVersionId { get; set; }

    public Id tabletContentVersionId { get; set; }

    public Id mobileContentVersionId { get; set; }

    public String desktopContentVersionUrl { get; set; }

    public String tabletContentVersionUrl { get; set; }

    public String mobileContentVersionUrl { get; set; }

    public String desktopUrl { get{return OV_ThumbnailPreviewBuilder.prepareURL(CONFIG_THUMB_SIZE, desktopContentVersionId); } }

    public String tabletUrl { get{return OV_ThumbnailPreviewBuilder.prepareURL(CONFIG_THUMB_SIZE, tabletContentVersionId); } }

    public String mobileUrl { get{return OV_ThumbnailPreviewBuilder.prepareURL(CONFIG_THUMB_SIZE, mobileContentVersionId); } }


    /*
     *Sonar Note: npath complexity issue. needs refactoring however leaving for now because of too complicated and time consuming.
     */    
    private void init(ApexPages.StandardController stdController, OV_ReportContentService service) {
        this.report = (OV_Report__c)stdController.getRecord();

        OV_Report__c rep = [SELECT Id, Desktop_Content_Proxy__r.LatestContentVersionId__c, Desktop_Content_Proxy__r.Url__c, Mobile_Content_Proxy__r.LatestContentVersionId__c, Mobile_Content_Proxy__r.Url__c, Tablet_Content_Proxy__r.LatestContentVersionId__c, Tablet_Content_Proxy__r.Url__c FROM OV_Report__c WHERE Id = :this.report.Id LIMIT 1];


        this.desktopContentVersionId = (rep.Desktop_Content_Proxy__c != null && rep.Desktop_Content_Proxy__r.Url__c == null) ? rep.Desktop_Content_Proxy__r.LatestContentVersionId__c : null;
        this.tabletContentVersionId = (rep.Tablet_Content_Proxy__c != null && rep.Tablet_Content_Proxy__r.Url__c == null) ? rep.Tablet_Content_Proxy__r.LatestContentVersionId__c : null;
        this.mobileContentVersionId = (rep.Mobile_Content_Proxy__c != null && rep.Mobile_Content_Proxy__r.Url__c == null) ? rep.Mobile_Content_Proxy__r.LatestContentVersionId__c : null;
       
        this.desktopContentVersionUrl = (rep.Desktop_Content_Proxy__c != null && rep.Desktop_Content_Proxy__r.Url__c != null) ? rep.Desktop_Content_Proxy__r.Url__c : null;
        this.tabletContentVersionUrl = (rep.Tablet_Content_Proxy__c != null && rep.Tablet_Content_Proxy__r.Url__c != null) ? rep.Tablet_Content_Proxy__r.Url__c : null;
        this.mobileContentVersionUrl = (rep.Mobile_Content_Proxy__c != null && rep.Mobile_Content_Proxy__r.Url__c != null) ? rep.Mobile_Content_Proxy__r.Url__c : null;
    }

    private OV_Report__c report;
}