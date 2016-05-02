/**********************************************************************
Name: OV_ReportContentService
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Class provides functions for content version object
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Dan Harfleet            24/06/2015      INITIAL DEVELOPMENT
1.1 -   Maciej Krol             06/08/2015      CHANGES RELATED TO CONTENT PROXY
**********************************************************************/
public with sharing virtual class OV_ReportContentServiceImpl
	implements OV_ReportContentService
{
	// Please note that ContentWorkspaces can not be created as part of a unit test
	// therefore the choice has to be made between adding see all data to the test
	// which will require a library to be present and will only prove that a soql
	// query can be made vs not testing this method and having a slightly lower
	// coverage level. This method is tested by way of functional testing.
	virtual public List<OV_ContentLibrary> listContentLibraries()
	{
		List<OV_ContentLibrary> results = new List<OV_ContentLibrary>();
		for(ContentWorkspace workspace : [select Id, Name from ContentWorkspace LIMIT 2000])
		{
			OV_ContentLibrary library = new OV_ContentLibrary(workspace.Id, workspace.Name);
			results.add(library);
		}
		return results;
	}	

	public ContentVersion findContentVersionById(Id id)
 	{
		if(id == null){
			throwIncorrectValueException('id', 'not null', 'null');
		}

		try{
			List<ContentVersion> contentVersions = [SELECT Id, Title, FileType, FileExtension, ContentDocumentId, LastModifiedDate, ContentSize, PathOnClient FROM ContentVersion WHERE IsLatest = true and Id = :id LIMIT 1];
		
			if(contentVersions.size() == 1){
				ContentVersion contentVersion;
                contentVersion = contentVersions[0];
                return contentVersion;
            }else{
            	throwServiceException('Could not find a ContentVersion with Id:' + id);
            }
		}
		catch(QueryException e)
		{
			throwServiceException('There was a problem finding the ContentVersion with Id:' + id, e);
		}

		return null;
 	}

 	virtual public ContentVersion findContentVersionForContentDocumentId(Id contentDocumentId)
 	{

		if(contentDocumentId == null){
			throwIncorrectValueException('contentDocumentId', 'not null', 'null');
		}

		try{
			List<ContentVersion> contentVersions = [SELECT Id, Title, FileType, FileExtension, ContentDocumentId, LastModifiedDate, ContentSize, PathOnClient FROM ContentVersion WHERE IsLatest = true and ContentDocumentId = :contentDocumentId LIMIT 1];
		
			if(contentVersions.size() == 1){
				ContentVersion contentVersion;
                contentVersion = contentVersions[0];
                return contentVersion;
            }else{
            	throwServiceException('Could not find a ContentVersion with Id:' + contentDocumentId);
            }
		}
		catch(QueryException e)
		{
			throwServiceException('There was a problem finding the ContentVersion with Id:' + contentDocumentId, e);
		}

		return null;
 	}

 	public ContentVersion createContentVersion(ContentVersion candidate)
 	{
		if(candidate == null)
		{
			throwIncorrectValueException('candidate', 'not null', 'null');
		}


 		try
        {
            insert candidate;
        }
        catch(System.DmlException e)
        {
            throwServiceException('There was a problem creating the ContentVersion' + String.valueOf(candidate), e);
        }

 		return candidate;
 	}

  	//added due to content proxy
 	public OV_Report__c updateReportWithContentProxyId(OV_Report__c report, Id contentDocumentId, Integer deviceType){
 		if (contentDocumentId == null || report == null) {
 			throwIncorrectValueException('contentDocumentId or report', 'not null', 'null');
 		}

 		if(!hasPermissionToupdateReportWithContentProxyId(deviceType)){
 			throwServiceException('You do not have permission to update One View Reports');
 		}

 		try{
 			OV_ContentProxy__c contentProxy = [SELECT id FROM OV_ContentProxy__c WHERE ContentDocumentId__c = :contentDocumentId LIMIT 1];

			String fieldName = proxyFieldNameForDeviceType(deviceType);
			report.put(fieldName, contentProxy.Id);

    		update report;
        	
 		}
 		catch(Exception e)
 		{
 			throwServiceException('There was a problem updating OV_Report__c with Id:' + report.Id + 'using contentDocumentId:' + contentDocumentId, e);
 		}
 		 		
        return report;
 	}

 	private String proxyFieldNameForDeviceType(Integer deviceType)
 	{
 		String result = 'Desktop_Content_Proxy__c';
 		if(deviceType == OV_DeviceType.TABLET){
 			result = 'Tablet_Content_Proxy__c';
 		}else if(deviceType == OV_DeviceType.MOBILE){
 			result = 'Mobile_Content_Proxy__c';
 		}
 		return result;
 	}

	virtual public OV_Report__c findReportById(Id reportId)
	{
		if(reportId == null)
		{
			throwIncorrectValueException('reportId', 'not null', 'null');
		}

		if(!hasPermissionToFindReportById())
		{
			throwServiceException('You do not have permission to access One View Reports');
		}

		try{
			List<OV_Report__c> reports = [SELECT Id, Name FROM OV_Report__c WHERE Id = :reportId LIMIT 1];
            if(reports.size() == 1)
            {
            	OV_Report__c report;
                report = reports[0];
                return report;
            }
            else
            {
            	throwServiceException('Could not find an OV_Report__c with Id:' + reportId);
            }
		}
		catch(QueryException e)
		{
			throwServiceException('There was a problem finding the OV_Report__c with Id:' + reportId, e);
		}

		return null;
	}

	private void throwIncorrectValueException(String valueName, String expectedComment, Object actual)
	{
		Exception e = new IncorrectValueException(valueName, expectedComment, actual);
		System.debug(LoggingLevel.ERROR, e.getMessage());
		throw e;
	}

	private void throwServiceException(String message)
	{
		throwServiceException(message, null);
	}

	private void throwServiceException(String message, Exception e)
	{
		System.debug(LoggingLevel.ERROR, message);
		if(e == null)
		{
			throw new ServiceException(message);
		}
		else
		{
			throw new ServiceException(message, e);
		}
	}

	private Boolean hasPermissionToupdateReportWithContentProxyId(Integer deviceType)
	{
		Boolean result = true;
		if(!Schema.sObjectType.OV_Report__c.isUpdateable()){
			result = false;
			System.debug(LoggingLevel.WARN, 'can not update OV_Report__c');
		}

		if(deviceType == OV_DeviceType.DESKTOP && !Schema.sObjectType.OV_Report__c.fields.Desktop_Content_Proxy__c.isUpdateable()){
			result = false;
			System.debug(LoggingLevel.WARN, 'can not update OV_Report__c.Desktop_Content_Proxy__c');
		}

		if(deviceType == OV_DeviceType.TABLET && !Schema.sObjectType.OV_Report__c.fields.Tablet_Content_Proxy__c.isUpdateable()){
			result = false;
			System.debug(LoggingLevel.WARN, 'can not update OV_Report__c.Tablet_Content_Proxy__c');
		}

		if(deviceType == OV_DeviceType.MOBILE && !Schema.sObjectType.OV_Report__c.fields.Mobile_Content_Proxy__c.isUpdateable()){
			result = false;
			System.debug(LoggingLevel.WARN, 'can not update OV_Report__c.Mobile_Content_Proxy__c');
		}

		return result;
	}

	private Boolean hasPermissionToFindReportById()
	{
		Boolean result = true;
		if(!Schema.sObjectType.OV_Report__c.isAccessible())
		{
			result = false;
			System.debug(LoggingLevel.WARN, 'can not access OV_Report');
		}
		if(!Schema.sObjectType.OV_Report__c.fields.Id.isAccessible())
		{
			result = false;
			System.debug(LoggingLevel.WARN, 'can not access Id field');
		}
		if(!Schema.sObjectType.OV_Report__c.fields.Name.isAccessible())
		{
			result = false;
			System.debug(LoggingLevel.WARN, 'can not access Name field');
		}
		return result;
	}

	public virtual class ServiceException extends Exception{}

	public class IncorrectValueException
		extends ServiceException
	{
		public IncorrectValueException(String name, String expected, Object actual)
		{
			this('IncorrectValueException: Expected value not found for ' + name + ', expected' + expected + 'but was ' + String.valueOf(actual));
		}
	}
}