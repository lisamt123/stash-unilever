/**********************************************************************
Name: OV_ReportContentService
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Interface for OV_ReportContentServiceImpl
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Dan Harfleet            24/06/2015      INITIAL DEVELOPMENT
**********************************************************************/
public interface OV_ReportContentService{

	List<OV_ContentLibrary> listContentLibraries();	

	ContentVersion findContentVersionById(Id id);

 	ContentVersion findContentVersionForContentDocumentId(Id contentDocumentId);

 	ContentVersion createContentVersion(ContentVersion candidate);

    OV_Report__c updateReportWithContentProxyId(OV_Report__c report, Id contentDocumentId, Integer deviceType);     	

	OV_Report__c findReportById(Id reportId);
}