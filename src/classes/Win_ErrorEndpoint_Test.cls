/*************************************************************** 
    Name: Win_ErrorEndpoint_Test
    Copyright © 2016 Accenture
    ======================================================
    Purpose:
    -------
    Testing class for the Error API
    ======================================================
    History
    -------
    VERSION     AUTHOR          DATE        DETAIL          Description
    1.0         Nicola Tassini  20/01/2017  Initial Dev     First version
***************************************************************/
@isTest
private class Win_ErrorEndpoint_Test {

	/**
	*	Test the call to the error API, checking if the error have been created
	*/
	@isTest static void testErrorAPI() {
		Win_ErrorRequest request = new Win_ErrorRequest();
		List<Win_ErrorRequest.Win_ErrorRequestItem> errorList = new List<Win_ErrorRequest.Win_ErrorRequestItem>();
		errorList.add(new Win_ErrorRequest.Win_ErrorRequestItem('Error123', 'Error123 Description', 'ERROR'));
		errorList.add(new Win_ErrorRequest.Win_ErrorRequestItem('Error345', 'Error345 Description', 'INFO'));
		errorList.add(new Win_ErrorRequest.Win_ErrorRequestItem('Error345B', 'Error345B Description', 'DEBUG'));
		errorList.add(new Win_ErrorRequest.Win_ErrorRequestItem('Error345A', 'Error345A Description', 'INFOX'));
		errorList.add(new Win_ErrorRequest.Win_ErrorRequestItem('Error678', 'Error678 Description', 'WARNING'));
		request.errorList = errorList;

		Test.startTest();     
		WIN_ErrorEndpoint endpoint = new WIN_ErrorEndpoint();
		WIN_ErrorEndpoint.submitErrors(request);

		Integer total = [SELECT count() FROM Exception_Log__c];
		System.assert(errorList.size() == total);
		Test.stopTest();
    }

	/**
	*	Test the call to the error API, checking if the error have been created
	*/
	@isTest static void testNoErrors() {
		Win_ErrorRequest request = new Win_ErrorRequest();
		List<Win_ErrorRequest.Win_ErrorRequestItem> errorList = new List<Win_ErrorRequest.Win_ErrorRequestItem>();
		request.errorList = errorList;

		Test.startTest();     
		WIN_ErrorEndpoint endpoint = new WIN_ErrorEndpoint();
		WIN_ErrorEndpoint.submitErrors(request);

		Integer total = [SELECT count() FROM Exception_Log__c];
		System.assert(0 == total);
		Test.stopTest();
    }

}