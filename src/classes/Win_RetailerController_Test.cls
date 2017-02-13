/*************************************************************** 
	Name: Win_RetailerController_Test
	Copyright © 2016 Accenture
	======================================================
	Purpose:
	-------
	Controller for the page that renders the brand logo
	======================================================
	History
	-------
	VERSION		AUTHOR 			DATE    	DETAIL    		Description
	1.0     	Nicola Tassini 	20/12/2016	Initial Dev 	Retailer Controller Test
***************************************************************/ 
@isTest
private class Win_RetailerController_Test {

	/**
	*	Check the returned retailer
	*/
	@isTest static void testBrandController() {
		String retailID = 'XYZ123';

		Win_Retailer__c retail = new Win_Retailer__c();
		retail.Retailer_External_Id__c = 'WINGS124122131231';
		retail.Retailer_ID__c = retailID;
		retail.Country_ID__c = 'IT_IT';
		retail.National_Sales__c = 'IT_ITesting 123';
		retail.Sales_Uplift__c = 'IT_ITesting';
		retail.Retailer_Logo__c = 'https://www.salesforce.com';
		insert retail;

		PageReference retailerLogoPage = Page.Win_Retailer_Logo_Page;
		Test.setCurrentPageReference(retailerLogoPage);
		ApexPages.currentPage().getParameters().put('id', retail.Id);

		ApexPages.StandardController sc = new ApexPages.StandardController(retail);
		Win_RetailerController ctrl = new Win_RetailerController(sc);

		System.assert(ctrl.getRetailer() != null);
		System.assert(ctrl.getRetailer().Id == retail.Id);
	}

	/**
	*	Null retailer
	*/
	@isTest static void testBrandControllerNull() {
		PageReference retailerLogoPage = Page.Win_Retailer_Logo_Page;
		Test.setCurrentPageReference(retailerLogoPage);
		ApexPages.currentPage().getParameters().put('id', null);

		ApexPages.StandardController sc = new ApexPages.StandardController(new Win_Retailer__c());
		Win_RetailerController ctrl = new Win_RetailerController(sc);

		System.assert(ctrl.getRetailer() != null);
	}

}