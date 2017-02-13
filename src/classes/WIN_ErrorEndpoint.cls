/*************************************************************** 
	Name: WIN_ErrorEndpoint
	Copyright © 2016 Accenture
	======================================================
	Purpose:
	-------
	Endpoint to push errors from the Wings app to Salesforce
	======================================================
	History
	-------
	VERSION		AUTHOR 			DATE    	DETAIL    		Description
	1.0     	Nicola Tassini 	20/01/2017	Initial Dev 	Error endpoint
***************************************************************/
@RestResource(urlMapping = '/WIN/V1/Error/*')
global with sharing class WIN_ErrorEndpoint {
	public WIN_ErrorEndpoint() {}

	/*********************************************************************************************
        Purpose: Submit multiple errors from the Wings app to Salesforce
        Returns: Response with an indication of the success or error
    *********************************************************************************************/
    @HttpPost
    webservice static Win_ErrorResponse submitErrors(Win_ErrorRequest request) {
    	Win_ErrorResponse result = new Win_ErrorResponse();
    	List<Exception_Log__c> exceptionsToStore = parseExceptions(request);

    	if(exceptionsToStore != null && exceptionsToStore.size() > 0) { 
	    	Win_Utils.logExceptions(exceptionsToStore);
	    	result.setStatus(Win_WebServiceResponse.SUCCESS);
    	} else {
    		result.setStatus(Win_WebServiceResponse.CLIENT_GENERIC_ERROR);
    		result.setError('Missing errors');
    	}
    	return result;
    }

    /*********************************************************************************************
        Purpose: Map the error level, making sure it's one of the pre-defined levels
        Returns: Error Level
    *********************************************************************************************/
    private static String mapErrorLevel(String errorLevel) {
    	return Win_Utils.EXCEPTION_LEVEL_ERROR.equalsIgnoreCase(errorLevel) 
	    		? Win_Utils.EXCEPTION_LEVEL_ERROR
	    		: Win_Utils.EXCEPTION_LEVEL_WARNING.equalsIgnoreCase(errorLevel)
	    			? Win_Utils.EXCEPTION_LEVEL_WARNING
	    			: Win_Utils.EXCEPTION_LEVEL_INFO.equalsIgnoreCase(errorLevel)
	    				? Win_Utils.EXCEPTION_LEVEL_INFO
	    				: Win_Utils.EXCEPTION_LEVEL_DEBUG.equalsIgnoreCase(errorLevel)
	    					? Win_Utils.EXCEPTION_LEVEL_DEBUG
	    					: Win_Utils.EXCEPTION_LEVEL_ERROR;
    }

    /*********************************************************************************************
        Purpose: Transform the input in given exceptions
        Returns: Exceptions
    *********************************************************************************************/
    private static List<Exception_Log__c> parseExceptions(Win_ErrorRequest request) {
    	List<Exception_Log__c> exceptions = new List<Exception_Log__c>();

    	// Span across all exceptions 
    	if(request != null && request.errorList != null) {
    		Exception_Log__c exc = null;

    		for(Win_ErrorRequest.Win_ErrorRequestItem requestItem : request.errorList) {
    			if(requestItem != null 
    				&& requestItem.errorArea != null && requestItem.errorArea.length() > 0
    				&& requestItem.errorLevel != null && requestItem.errorLevel.length() > 0) {
    				exc = new Exception_Log__c();
    				exc.Running_User__c = UserInfo.getUserId();
    				exc.Class_Name__c = 'WIN_ErrorEndpoint';
    				exc.Exception_Type__c = new Win_Exception().getTypeName();
    				exc.Method_Name__c = requestItem.errorArea;
    				exc.Exception_Message__c = requestItem.errorDescription;
    				exc.DebugLevel__c = mapErrorLevel(requestItem.errorLevel);
    				exc.Application_Name__c = Win_Utils.APP_NAME;

    				exceptions.add(exc);
    			}
    		}
    	}

    	return exceptions;
    }

}