/*************************************************************** 
    Name: Win_Bootstrap_Test
    Copyright © 2016 Accenture
    ======================================================
    Purpose:
    -------
    Testing class for the bootstrap API
    ======================================================
    History
    -------
    VERSION     AUTHOR          DATE        DETAIL          Description
    1.0         Nicola Tassini  22/12/2016  Initial Dev     First version
***************************************************************/
@isTest
private class Win_Bootstrap_Test {
	
	/**
	*	Test the call to the bootstrap, checking if the dictionary is returned
	*/
	@isTest static void testDictionaryData() {
		Test.startTest();     
		Win_BootstrapResponse resp = new Win_BootstrapResponse(); 
		RestRequest req = new RestRequest(); 

		RestResponse res = new RestResponse();
		req.requestURI = '/WIN/V1/Bootstrap/*';
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;

		Win_BootstrapEndpoint endPoint = new Win_BootstrapEndpoint();
		System.assert(endPoint != null);

		resp = Win_BootstrapEndpoint.doGet();
		System.assert(resp != null);
		System.assert(resp.getDictionary() != null);
		System.assert(resp.getLanguage() != null);
		System.assert(resp.getDictionary().get(Win_BootstrapEndpoint.TEST_KEY).equals(Win_BootstrapEndpoint.TEST_LABEL));

		// The controller has been called
		Win_Dictionary_CC ctrl = new Win_Dictionary_CC();
		ctrl.init();

		Test.stopTest();
    }

    /**
	*	Test the dictionary call throwing the first exception
	*/
	@isTest static void testDictionaryDataExceptionOne() {
		Test.startTest();     
		Win_BootstrapResponse resp = new Win_BootstrapResponse(); 
		System.assert(resp != null);
		RestRequest req = new RestRequest(); 
		System.assert(req != null);

		RestResponse res = new RestResponse();
		req.requestURI = '/WIN/V1/Bootstrap/*';
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;

		Win_BootstrapEndpoint.throwErrorDictionaryOne = true;
		resp = Win_BootstrapEndpoint.doGet();
		Test.stopTest();
    }

    /**
	*	Test the dictionary call throwing the first exception
	*/
	@isTest static void testDictionaryDataExceptionTwo() {
		Test.startTest();     
		Win_BootstrapResponse resp = new Win_BootstrapResponse(); 
		System.assert(resp != null);
		RestRequest req = new RestRequest(); 
		System.assert(req != null);

		RestResponse res = new RestResponse();
		req.requestURI = '/WIN/V1/Bootstrap/*';
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;

		Win_BootstrapEndpoint.throwErrorDictionaryTwo = true;
		resp = Win_BootstrapEndpoint.doGet();
		Test.stopTest();
    }

}