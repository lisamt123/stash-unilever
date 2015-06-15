@isTest 
public with sharing class AR_Test_LandingPage {
	static testmethod void Test_LandingPage()
	{
		Test.startTest();
		
		ar_Agency_Portal_CMS__c testCMS = new ar_Agency_Portal_CMS__c();
		testCMS.title__c = 'test';
		testCMS.body__c = 'test';
		testCMS.order__c = 1;
		testCMS.Type__c = 'Landing Page' ;
		testCMS.Published__c = true;
		insert testCMS;
		
		AR_LandingPage testcon = new AR_LandingPage();
		testcon.init();

		System.assertEquals(testCMS.title__c,testcon.content.title__c,'No Data');
		
		Test.stopTest();
	}
}