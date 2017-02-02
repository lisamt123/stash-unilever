/*************************************************************** 
	Name: Win_Dictionary_CC
	Copyright © 2016 Accenture
	======================================================
	Purpose:
	-------
	Support controller to generate the dictionary for the FrontEnd application
	======================================================
	History
	-------
	VERSION		AUTHOR 			DATE    	DETAIL    		Description
	1.0     	Nicola Tassini 	20/12/2016	Initial Dev 	Dictionary Controller
***************************************************************/
public virtual with sharing class Win_Dictionary_CC {

	private final String DICTIONARY_TYPE = 'Dictionary Item';

    public String language {get;set;}
    public List<String> customLabels {get;set;}
    public String contentType {get; set;}

	
	/*
	 * Default Constructor
	 */
    public Win_Dictionary_CC() {
        this.customLabels = new List<String>();
        contentType = 'application/json';
    }

	/*********************************************************************************************
        Purpose: Support controller to generate the dictionary for the FrontEnd application
    *********************************************************************************************/
    public void init() {
        // Query the user' locale
        language = UserInfo.getLanguage();

        // Avoid dupes
        Set<String> customLabelsSet = new Set<String>();
        for(Win_Configuration__mdt dictionaryConfiguration : [SELECT DeveloperName FROM Win_Configuration__mdt 
        	WHERE Win_ConfigurationType__c = :DICTIONARY_TYPE
        	LIMIT 10000]) {
            	customLabelsSet.add(dictionaryConfiguration.DeveloperName.toLowerCase());
		}
		// Prepare the list of labels
		customLabels = new List<String>(customLabelsSet);
    }

}