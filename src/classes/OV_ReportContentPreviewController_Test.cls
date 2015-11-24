/**********************************************************************
Name: OV_ReportContentPreviewController_Test
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Tests for OV_ReportContentPreviewController
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Dan Harfleet            24/06/2015      INITIAL DEVELOPMENT
1.1 -   Maciej Krol             06/08/2015      CHANGES RELATED TO CONTENT PROXY
**********************************************************************/
@isTest
private class OV_ReportContentPreviewController_Test {
	@isTest static void testDesktop(){
		String pageName = '/apex/OV_ContentPreviewDesktop';

        OV_Category__c category1 = OV_TestingHelper.initCategory('Category 1', true);

        OV_Geography__c geography1 = OV_TestingHelper.initGeography('Geography 1', true);

        OV_Function__c function1 = OV_TestingHelper.initFunction('Function 1', true);

        ContentVersion contentVersion = OV_TestingHelper.initContentVersion('Test 1', true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion.ContentDocumentId limit 1][0];

        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, 'proxy test title', contentVersion.Id, '', true);
        OV_Report__c report = OV_TestingHelper.initReportWithProxy('Report 1', category1, function1, geography1, 'Desktop', proxy.Id, true);

		PageReference pageReference = new PageReference(pageName);
		Test.setCurrentPage(pageReference);
		ApexPages.StandardController standardController = new ApexPages.StandardController(report);

		Test.startTest();

		OV_ReportContentPreviewController controller
			 = new OV_ReportContentPreviewController(standardController);

		Test.stopTest();

		System.assertEquals(controller.desktopContentVersionId, contentVersion.Id);
		System.assert(controller.desktopUrl.startsWith('/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=068'));
	}

	@isTest static void testTablet(){
		String pageName = '/apex/OV_ContentPreviewTablet';

		OV_Category__c category1 = OV_TestingHelper.initCategory('Category 1', true);

        OV_Geography__c geography1 = OV_TestingHelper.initGeography('Geography 1', true);

        OV_Function__c function1 = OV_TestingHelper.initFunction('Function 1', true);

        ContentVersion contentVersion = OV_TestingHelper.initContentVersion('Test 1', true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion.ContentDocumentId limit 1][0];

        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, 'proxy test title', contentVersion.Id, '', true);
        OV_Report__c report = OV_TestingHelper.initReportWithProxy('Report 1', category1, function1, geography1, 'Tablet', proxy.Id, true);

		PageReference pageReference = new PageReference(pageName);
		Test.setCurrentPage(pageReference);
		ApexPages.StandardController standardController = new ApexPages.StandardController(report);

		Test.startTest();

		OV_ReportContentPreviewController controller
			 = new OV_ReportContentPreviewController(standardController);

		Test.stopTest();

		System.assertEquals(controller.tabletContentVersionId, contentVersion.Id);
		System.assert(
			controller.tabletUrl.startsWith('/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=068'),
			'URL is: ' + controller.tabletUrl + ' Expected: /sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=068'
		);
	}

	@isTest static void testMobile(){
		String pageName = '/apex/OV_ContentPreviewMobile';

		OV_Category__c category1 = OV_TestingHelper.initCategory('Category 1', true);

        OV_Geography__c geography1 = OV_TestingHelper.initGeography('Geography 1', true);

        OV_Function__c function1 = OV_TestingHelper.initFunction('Function 1', true);

        ContentVersion contentVersion = OV_TestingHelper.initContentVersion('Test 1', true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion.ContentDocumentId limit 1][0];

        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, 'proxy test title', contentVersion.Id, 'www.google.com', true);
        OV_Report__c report = OV_TestingHelper.initReportWithProxy('Report 1', category1, function1, geography1, 'Mobile', proxy.Id, true);

        system.debug('********* r:' + report);

		PageReference pageReference = new PageReference(pageName);
		Test.setCurrentPage(pageReference);
		ApexPages.StandardController standardController = new ApexPages.StandardController(report);

		Test.startTest();

		OV_ReportContentPreviewController controller = new OV_ReportContentPreviewController(standardController, new OV_ReportContentServiceImpl());

		Test.stopTest();

		System.assertEquals(controller.mobileContentVersionId, null);		
	}
    /*
	@isTest static void testConstructError(){
		String pageName        = '/apex/OV_ContentPreviewMobile';

		OV_Category__c category1 = OV_TestingHelper.initCategory('Category 1', true);

        OV_Geography__c geography1 = OV_TestingHelper.initGeography('Geography 1', true);

        OV_Function__c function1 = OV_TestingHelper.initFunction('Function 1', true);

        ContentVersion contentVersion = OV_TestingHelper.initContentVersion('Test 1', true);
        ContentDocument document1 = [select Id from ContentDocument where Id = :contentVersion.ContentDocumentId limit 1][0];

        OV_ContentProxy__c proxy = OV_TestingHelper.initContentProxy(document1.Id, 'proxy test title', contentVersion.Id, 'www.google.com', true);
        OV_Report__c report = OV_TestingHelper.initReportWithProxy('Report 1', category1, function1, geography1, 'Mobile', proxy.Id, true);

		PageReference pageReference = new PageReference(pageName);
		Test.setCurrentPage(pageReference);
		ApexPages.StandardController standardController = new ApexPages.StandardController(report);

		Test.startTest();
		OV_ReportContentPreviewController controller
			 	= new OV_ReportContentPreviewController(standardController, new MockService());

		Boolean messageFound = false;
		ApexPages.Message[] pageMessages = ApexPages.getMessages();
		for(ApexPages.Message message : pageMessages) {

			System.debug(LoggingLevel.DEBUG, message.getSummary());
		    if(message.getSummary() == 'Could not find content' && message.getSeverity() == ApexPages.Severity.ERROR) {
		        messageFound = true;
		    }
		}

		Test.stopTest();

		System.assert(messageFound);

	}
    */

	public class MockService extends OV_ReportContentServiceImpl {
		override public ContentVersion findContentVersionForContentDocumentId(Id contentDocumentId)
 		{
 			throw new MockException('ExceptionFixture');
 			return null;
 		}
	}

	public class MockException extends Exception{}
}