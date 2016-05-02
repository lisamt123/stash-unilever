/*
	Unilever

	Class Name: AR_Test_RegistrationController

	Created by: Marc Saelzler | 2013-09-18

	Description: To get test coverage for AR_RegistrationController.

	Timeline
	Date 					| Name 				| Description
	2013-09-19 12:06 (CET)	| Marc Saelzler 	| Initial development.
*/

@isTest(SeeAllData=true)
private class AR_Test_RegistrationController
{
	static testMethod void AR_Test_RegistrationController()
	{
		Test.startTest();
		
		Test.setCurrentPage(Page.AR_Registration);
		
		Test.setMock(HttpCalloutMock.class, new AR_CaptchaHttpMock(false));
		
		AR_RegistrationController test_controller = new AR_RegistrationController();
		
		AR_SObjectHolder tmp_sObjHolder = test_controller.ApplicationObject;
		
		test_controller.InitPage();
		
		test_controller.SaveApplication();
		
		//Note: App id is null and the save process could not be completed because 'Captcha' returns false which aborts the save process.
		System.assertEquals(null, tmp_sObjHolder.obj.id, 'Save failed. Application id is not null.');
		
		Test.setCurrentPage(Page.AR_Registration);
		
		Test.setMock(HttpCalloutMock.class, new AR_CaptchaHttpMock(true));
		
		test_controller = new AR_RegistrationController();
		
		test_controller.InitPage();
		
		test_controller.SaveApplication();
		
		tmp_sObjHolder = test_controller.ApplicationObject;
		 
		//Note: App id is null and the save process could not be completed because 'Captcha' returns false which aborts the save process.
		//System.assertNotEquals(null, tmp_sObjHolder.obj.id, 'Save failed. Application id is null.');
		
		test_controller.goOnWithTheProcess();
		
		test_controller.Logout();
		
		System.assertEquals(null, AR_SessionHandler.GetAgencyId(), 'Logout failed. Application id is still set.');
		
		Test.stopTest();
	}
}