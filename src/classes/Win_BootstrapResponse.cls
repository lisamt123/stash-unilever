/*************************************************************** 
	Name: Win_BootstrapResponse
	Copyright © 2016 Accenture
	======================================================
	Purpose:
	-------
	Support class for the response of the Bootstrap endpoint
	======================================================
	History
	-------
	VERSION		AUTHOR 			DATE    	DETAIL    		Description
	1.0     	Nicola Tassini 	20/12/2016	Initial Dev 	Bootstrap response
***************************************************************/ 
global with sharing class Win_BootstrapResponse {


	// Container for all the translated labels
	private Map<String, String> dictionary;

	// Language information
	private String language;

	/**
	 *	Default constructor
	 */
	public Win_BootstrapResponse() {
		dictionary = new Map<String, String>();
		language = 'en';
	}

	/**
	 *	Setter for the dictionary
	 */
	public void setDictionary(Map<String, String> dictionary) {
		this.dictionary = dictionary;
	}

	/**
	 *	Setter for the language
	 */
	public void setLanguage(String language) {
		this.language = language;
	}

	/**
	 *	Getter for the dictionary
	 */
	public Map<String, String> getDictionary() {
		return this.dictionary;
	}

	/**
	 *	Getter for the language
	 */
	public String getLanguage() {
		return this.language;
	}

}