/*
	Unilever

	Class Name: AR_Test_SessionHandler

	Created by: Marc Saelzler | 2013-09-19

	Description: To get test coverage for AR_SessionHandler.

	Timeline
	Date 					| Name 				| Description
	2013-09-19 15:48 (CET)	| Marc Saelzler 	| Initial development.
*/

@isTest(SeeAllData=true)
public with sharing class AR_Test_SessionHandler
{
	static testMethod void AR_Test_SessionHandler()
	{
		Test.startTest();
		
		ar_Application__c test_app = TestDataFactory.getApplication();
		
		insert test_app;
		
		AR_SessionHandler.SetCookie(test_app.Id);
		
		System.assertEquals(test_app.Id ,AR_SessionHandler.GetAgencyId(), 'Assertion failed. Id is not set!');
		
		Cookie tmp_cookie = AR_SessionHandler.getCookie(test_app.Id);
		
		AR_SessionHandler.CloseSession();
		
		System.assertEquals(null, AR_SessionHandler.GetAgencyId(), 'Assertion failed. Id is still set!');
		
		Test.stopTest();
	}
}