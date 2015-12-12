/**********************************************************************
Name: OV_FilePreviewController
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Preview for static reports
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Daniel Harfleet         18/06/2015      INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class OV_FilePreviewController {
	public class OVException extends Exception {}

	private static String PARAM_CONTENT_DOCUMENT_ID         = 'contentDocumentId';
	private static String PARAM_CONTENT_DOCUMENT_VERSION_ID = 'contentDocumentVersionId';
	private static String PARAM_SHOW_DOWNLOAD_LINK          = 'showDownloadLink';
	private static String PARAM_SHELF_TILE_ID          		= 'shelfTileId';
	private static String PARAM_REPORT_ID 	         		= 'reportId';

    private static String DESKTOP                           = 'Desktop';

	public Id currentContentVersionId{ get; set; }

    public List<ContentVersion> contentVersionsList{ get{ return this.contentVersions; } }

	private Id contentDocumentId;
	public Id contentVersionId {get; set;}
	private List<ContentVersion> contentVersions;
	public  List<SelectOption> optns{get;set;}
	public String selectedVal{get;set;}
	public Boolean showDownloadLink {get; set;}
	public String shelfTileId{get;set;}
	public String reportId{get;set;}

	public OV_FilePreviewController(){
		Id contentDocumentId = ApexPages.currentPage().getParameters().get(PARAM_CONTENT_DOCUMENT_ID);
		contentVersionId  = ApexPages.currentPage().getParameters().get(PARAM_CONTENT_DOCUMENT_VERSION_ID);
		shelfTileId		 = ApexPages.currentPage().getParameters().get(PARAM_SHELF_TILE_ID);
		reportId		 = ApexPages.currentPage().getParameters().get(PARAM_REPORT_ID);

		if(contentDocumentId == null) {
			ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.FATAL, 'you must supply a content document id using the param:' + PARAM_CONTENT_DOCUMENT_ID) );
		}
		this.contentDocumentId = contentDocumentId;
		this.contentVersions   = loadContentVersions(this.contentDocumentId);

		String showDownloadLinkParam = ApexPages.currentPage().getParameters().get(PARAM_SHOW_DOWNLOAD_LINK);
		if (showDownloadLinkParam == null || showDownloadLinkParam == 'true') {
			showDownloadLink = true;
		}

		init();
	}

    /*******************************************************************
    Purpose: Method for sorting contentversions by version number
    Parameterd Description: created due to fact that versionumber is STRING field
    Parameters: [List<ContentVersion> contentVersions]
    Returns: [List<ContentVersion>]
    ********************************************************************/
    private List<ContentVersion> getSortedContentVersions(List<ContentVersion> contentVersions){
        List<Integer> order = new List<Integer>();
        Map<Integer, ContentVersion> cVMap = new Map<Integer, ContentVersion>();
        for(ContentVersion cV : contentVersions){
            cVMap.put(Integer.valueOf(cV.VersionNumber), cV);
            order.add(Integer.valueOf(cV.VersionNumber));
        }
        //ASC ORDER
        order.sort();

        //Because of DESC order
        List<ContentVersion> sortedContentVersions = new List<ContentVersion>();
        for(Integer i = order.size()-1; i>=0;i--){
            sortedContentVersions.add(cVMap.get(order.get(i)));
        }

        return sortedContentVersions;
    }

	private List<ContentVersion> loadContentVersions(Id contentDocumentId){
		List<ContentVersion> results = new List<ContentVersion>();
		try{
            /*SECURITY - CRUD/FLS Enforcement */
            String [] accessFields = new String [] {'Id', 'Title', 'ContentDocumentId', 'IsLatest', 'VersionNumber', 'LastModifiedDate' };
            OV_SecurityHelper.doPrivilegedOp('ContentVersion', accessFields);
            /*SECURITY - CRUD/FLS Enforcement */

			List<ContentVersion> resultsTmp = [select Id, Title, ContentDocumentId, IsLatest, VersionNumber, LastModifiedDate from ContentVersion where ContentDocumentId = :contentDocumentId order by VersionNumber desc];
            results = getSortedContentVersions(resultsTmp);
			if( results.isEmpty() ) {
			    throw new OVException('No results');
			}

		}catch(Exception e){
			System.debug(LoggingLevel.ERROR, 'OV_FilePreviewController.loadContentVersions.exception:' + e.getMessage());
			results = new List<ContentVersion>();
			ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING, 'There was a problem trying to load versions for the Content') );
		}
		return results;
	}

	private void init(){
		optns = new List<Selectoption>();
		Boolean contentVersionFound = false;

		for(ContentVersion version : this.contentVersions){
			if(version.IsLatest){
				this.currentContentVersionId = version.Id;
			}
			if (version.Id == contentVersionId) {
				contentVersionFound = true;
			}
            String label = version.VersionNumber + ': ' +version.Title + ' ' + version.LastModifiedDate;
            if(version.IsLatest){
            	label = 'Latest ('+version.VersionNumber+'): ' +version.Title + ' ' + version.LastModifiedDate;
            }

            optns.add(new selectOption(version.Id, label));
		}
		if (contentVersionFound) {
			this.currentContentVersionId = contentVersionId;
		}
		if(this.currentContentVersionId == null){
			System.debug(LoggingLevel.ERROR, 'can not find a latest content version - something is wrong');
		}
	}

    public PageReference changeVersion(){
    	List<ContentVersion> cv = [SELECT Id, VersionNumber FROM ContentVersion WHERE Id = :this.currentContentVersionId LIMIT 1];
    	if( !cv.isEmpty() ){
    		if(shelfTileId != null && shelfTileId != '' && reportId != null && reportId != ''){
				OV_ReportUsageService.saveUsageEntry(reportId, shelfTileId, 'detail_view_version_change', DESKTOP, cv[0].VersionNumber);
			}else if(reportId != null && reportId != ''){
				OV_ReportUsageService.saveUsageEntry(reportId, 'Favourite', 'detail_view_version_change', DESKTOP, cv[0].VersionNumber);
			}
    	}
        return null;
    }

    public PageReference logDownload(){
    	List<ContentVersion> cv = [SELECT Id, VersionNumber FROM ContentVersion WHERE Id = :this.currentContentVersionId LIMIT 1];
    	if( !cv.isEmpty() ){
    		if(shelfTileId != null && shelfTileId != '' && reportId != null && reportId != ''){
				OV_ReportUsageService.saveUsageEntry(reportId, shelfTileId, 'detail_download_document_icon', DESKTOP, cv[0].VersionNumber);
			}else if(reportId != null && reportId != ''){
				OV_ReportUsageService.saveUsageEntry(reportId, null, 'detail_download_document_icon', DESKTOP, cv[0].VersionNumber);
			}
    	}

    	return null;
    }
}