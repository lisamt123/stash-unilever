/*************************************************************** 
	Name: Win_BootstrapEndpoint
	Copyright © 2016 Accenture
	======================================================
	Purpose:
	-------
	Provide all the required information to the Wings2.0 mobile app, currently:
	- Dictionary of translated labels
	======================================================
	History
	-------
	VERSION		AUTHOR 			DATE    	DETAIL    		Description
	1.0     	Nicola Tassini 	20/12/2016	Initial Dev 	Bootstrap endpoint
***************************************************************/
@RestResource(urlMapping = '/WIN/V1/Bootstrap/*')
global with sharing class Win_BootstrapEndpoint {

	public Win_BootstrapEndpoint() {}

    public static String TEST_KEY = 'wings_store_list_visits';
    public static String TEST_LABEL = 'VISITS';
    public static Boolean throwErrorDictionaryOne = false;
    public static Boolean throwErrorDictionaryTwo = false;


	/*********************************************************************************************
        Purpose: Expose an HTTP GET Resource with the contents of the bootstrap
        Returns: bootstrap information
    *********************************************************************************************/
	@HTTPGet
    webservice static Win_BootstrapResponse doGet() {
    	// init the result data structure
    	Win_BootstrapResponse bootstrap = new Win_BootstrapResponse();

    	// Fill in the dictionary
    	bootstrap.setDictionary(retrieveDictionary());
        bootstrap.setLanguage(UserInfo.getLanguage());

    	return bootstrap;
    }

	/*********************************************************************************************
        Purpose: Return the list of labels from the appropriate dictionary
        Returns: dictionary map
    *********************************************************************************************/
    private static Map<String,String> retrieveDictionary() {
    	// Get the translation from the related VF page
        String dictionaryJSON = null;
        try {
            dictionaryJSON = !Test.IsRunningTest() ? Page.Win_Dictionary.getContent().toString() : 
                '{"'+TEST_KEY+'":"'+TEST_LABEL+'","wings_store_list_value_sales_volume":"VALUE/SALES VOLUME"}';

            if(throwErrorDictionaryOne) {
                integer manualException = 10/0;
            }
        } catch(Exception vfException) {
        	Win_Utils.logException('Win_BootstrapEndpoint', 'retrieveDictionary', 
        		'Error invoking the dictionary VF page', vfException, Win_Utils.EXCEPTION_LEVEL_ERROR);
        }

        try {
            if(throwErrorDictionaryTwo) {
                integer manualException = 10/0;
            }
            return (Map<String,String>) JSON.deserialize(dictionaryJSON, Map<String,String>.class);
        } catch (Exception deserializeException) {
        	Win_Utils.logException('Win_BootstrapEndpoint', 'retrieveDictionary', 
        		'Error deserialising the dictionary VF page', deserializeException, Win_Utils.EXCEPTION_LEVEL_ERROR);
            return null;
        }
    }
}