/*************************************************************** 
	Name: Win_BrandController
	Copyright © 2016 Accenture
	======================================================
	Purpose:
	-------
	Controller for the page that renders the brand logo
	======================================================
	History
	-------
	VERSION		AUTHOR 			DATE    	DETAIL    		Description
	1.0     	Nicola Tassini 	20/12/2016	Initial Dev 	Brand Controller
***************************************************************/ 
public with sharing class Win_BrandController {

	/**
	 *	Brand field
	 */
    public Win_Brand_Configuration__c brand;

    /**
	 *	Default Controller
	 */
    public Win_BrandController(ApexPages.StandardController controller) {
    	Id brandID = ApexPages.currentPage().getParameters().get('id');

        brand = brandID != null 
        	? [SELECT Id, Name, Logo__c FROM Win_Brand_Configuration__c WHERE Id = :brandID]
        	: new Win_Brand_Configuration__c();
    }

    /**
	 *	Return the brand
	 */
    public Win_Brand_Configuration__c getBrand() {
        return brand;
    }

}