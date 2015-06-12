/***
Class: im_NewIssueLauncherController
Description: 
**/
public with sharing class im_NewIssueLauncherController {
	/**
		Empty contstructor
	**/
	public im_NewIssueLauncherController(){}


	/**
		returns the key prefix for the im_Issue__c object
		@return String - the letter prefix code for the im_Issue__c object
	**/
	public String issueObjectPrefix { 
		get {
			Schema.SObjectType sType = Schema.getGlobalDescribe().get('im_Issue__c');
			return sType.getDescribe().getKeyPrefix(); 
		} 
	}
}