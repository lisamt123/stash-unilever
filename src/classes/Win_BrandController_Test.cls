/*************************************************************** 
	Name: Win_BrandController_Test
	Copyright © 2016 Accenture
	======================================================
	Purpose:
	-------
	Controller for the page that renders the brand logo
	======================================================
	History
	-------
	VERSION		AUTHOR 			DATE    	DETAIL    		Description
	1.0     	Nicola Tassini 	20/12/2016	Initial Dev 	Brand Controller Test
***************************************************************/ 
@isTest
private class Win_BrandController_Test {
	
	/**
	*	Check the returned brand
	*/
	@isTest static void testBrandController() {
		String brandID = 'XYZ123';

		Win_Brand_Configuration__c brandConfig = new Win_Brand_Configuration__c();
		brandConfig.Brand_External_Id__c = 'WINGS124122131231';
		brandConfig.Brand_Id__c = brandID;
		brandConfig.Country_Id__c = 'IT_IT';
		brandConfig.Logo__c = 'https://www.salesforce.com';
		insert brandConfig;

		PageReference brandLogoPage = Page.Win_BrandLogoPage;
		Test.setCurrentPageReference(brandLogoPage);
		ApexPages.currentPage().getParameters().put('id', brandConfig.Id);

		ApexPages.StandardController sc = new ApexPages.StandardController(brandConfig);
		Win_BrandController ctrl = new Win_BrandController(sc);

		System.assert(ctrl.getBrand() != null);
		System.assert(ctrl.getBrand().Id == brandConfig.Id);
	}

	/**
	*	Null brand
	*/
	@isTest static void testBrandControllerNull() {
		PageReference brandLogoPage = Page.Win_BrandLogoPage;
		Test.setCurrentPageReference(brandLogoPage);
		ApexPages.currentPage().getParameters().put('id', null);

		ApexPages.StandardController sc = new ApexPages.StandardController(new Win_Brand_Configuration__c());
		Win_BrandController ctrl = new Win_BrandController(sc);

		System.assert(ctrl.getBrand() != null);
	}

}