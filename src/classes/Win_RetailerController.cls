/*************************************************************** 
	Name: Win_RetailerController
	Copyright © 2016 Accenture
	======================================================
	Purpose:
	-------
	Controller for the page that renders the brand logo
	======================================================
	History
	-------
	VERSION		AUTHOR 			DATE    	DETAIL    		Description
	1.0     	Nicola Tassini 	20/12/2016	Initial Dev 	Retailer Controller
***************************************************************/ 
public with sharing class Win_RetailerController {

	/**
	 *	Reailer field
	 */
    public Win_Retailer__c retail;

    /**
	 *	Default Controller
	 */
    public Win_RetailerController(ApexPages.StandardController controller) {
    	Id retailerID = ApexPages.currentPage().getParameters().get('id');

        retail = retailerID != null 
        	? [SELECT Id, Name, Retailer_Logo__c FROM Win_Retailer__c WHERE Id = :retailerID]
        	: new Win_Retailer__c();
    }

    /**
	 *	Return the retailer
	 */
    public Win_Retailer__c getRetailer() {
        return retail;
    }
}