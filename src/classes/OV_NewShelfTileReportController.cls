/**********************************************************************
Name: OV_NewShelfTileReportController
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Class/service for calculating sort order for shelfs tile reports
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             01/09/2015      INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class OV_NewShelfTileReportController {
	public OV_ShelfTileReport__c record{get;set;}
	public OV_Report__c report{get;set;}
	public String sortOrderMsg{get;set;}

	public OV_NewShelfTileReportController(ApexPages.StandardController standardController) {
		record = (OV_ShelfTileReport__c)standardController.getRecord();
		sortOrderMsg = 'Can\'t calculate sort order field because Report and Shelf should be defined.';
	}

	public void calculateSortOrder(){
		Decimal sortOrder = null;
		if(record.Report__c != null && record.Shelf_Tile__c != null){
			List<OV_Report__c> reports = [SELECT Id, Report_Heading__c, Report_Folder__c, Unit__c, Unit__r.Id, Unit__r.Name FROM OV_Report__c WHERE Id =:record.Report__c LIMIT 1];

			if( !reports.isEmpty() ){
				report = reports[0];
				List<OV_ShelfTileReport__c> shelfTileReports = [SELECT Id, Sort_Order__c, Report__r.Unit__c, Report__r.Unit__r.Name FROM OV_ShelfTileReport__c
																WHERE Report__r.Report_Heading__c = :report.Report_Heading__c
																AND Report__r.Report_Folder__c = :report.Report_Folder__c
																AND Report__r.Unit__c = :report.Unit__c
																AND Shelf_Tile__c =:record.Shelf_Tile__c
																ORDER BY Sort_Order__c DESC NULLS LAST, Report__r.Name DESC, Report__r.CreatedDate DESC LIMIT 1];

				if( !shelfTileReports.isEmpty() ){
					record.Sort_Order__c = shelfTileReports[0].Sort_Order__c +1;
				}else{
					record.Sort_Order__c = 1;
				}
				sortOrderMsg = 'Calculated sort order field:'+record.Sort_Order__c;
				if(report.Unit__c != null){
					sortOrderMsg += ' for unit "'+report.Unit__r.Name+'"';
				}
				if(report.Report_Heading__c != null){
					sortOrderMsg += ' for heading "'+report.Report_Heading__c+'"';
				}
				if(report.Report_Folder__c != null){
					if(report.Report_Heading__c != null){
						sortOrderMsg += ' and';
					}
					sortOrderMsg += ' for folder "'+report.Report_Folder__c+'"';
				}
			}else{
				sortOrderMsg = 'Can\'t calculate sort order field because Report and Shelf should be defined.';
			}
		}else{
			record.Sort_Order__c = null;
			sortOrderMsg = 'Can\'t calculate sort order field because Report and Shelf should be defined.';
		}
	}
}