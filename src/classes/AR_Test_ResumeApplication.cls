/*
	Unilever

	Class Name: AR_Test_ResumeApplication

	Created by: Marc Saelzler | 2013-09-20

	Description: Controller for the page AR_ResumeApplication.

	Timeline
	Date 					| Name 				| Description
	2013-09-20 15:30 (CET)	| Marc Saelzler 	| Initial development.
*/

@isTest(SeeAllData=true)
private class AR_Test_ResumeApplication
{
	static testMethod void AR_Test_ResumeApplication()
	{
		Test.startTest();
		
		ar_Application__c test_app = TestDataFactory.getApplication();
		
		test_app.Email__c = 'ResumeApplication@ArTest.com';
		
		insert test_app;
		
		System.assertNotEquals(null, test_app.Id, 'App save failed.');
		
		Test.setCurrentPage(Page.AR_ResumeApplication);
				
		AR_ResumeApplication test_controller = new AR_ResumeApplication();
		
		test_controller.init();
		
		test_controller.email = 'ResumeApplication@ArTest.com';
		test_controller.uniqueKey = test_app.Id;
		
		// Do login
		system.debug(logginglevel.info, 'Do login');
		test_controller.continueApplication();
		
		// Force logout failure
		test_controller.uniqueKey = 'a1b2c3';
		test_controller.continueApplication();
		
		// Force unique key error
		test_controller.uniqueKey = null;
		
		system.debug(logginglevel.info, 'Force unique key error');
		test_controller.continueApplication();
		
		// Force email error
		test_controller.email = null;
		
		system.debug(logginglevel.info, 'Force email error');
		test_controller.continueApplication();
		
		test_controller.init();
		
		System.assertEquals(test_app.Id, AR_SessionHandler.GetAgencyId(), 'Login failed. No cookie set.');
		
		Test.stopTest();
	}
}