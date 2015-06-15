/*
	Unilever

	Class Name: AR_Test_ProgressBarComponentController

	Created by: Marc Saelzler | 2013-09-20

	Description: To get test coverage for AR_ProgressBarComponentController.

	Timeline
	Date 					| Name 				| Description
	2013-09-20 13:55 (CET)	| Marc Saelzler 	| Initial development.
*/

@isTest(SeeAllData=true)
private class AR_Test_ProgressBarComponentController
{
	static testMethod void AR_Test_GeneralInformationController()
	{
		Test.startTest();
		
		ar_Application__c test_app = TestDataFactory.getApplication();
		
		insert test_app;
		
		Test.setCurrentPage(Page.AR_GeneralInformation);
		
		AR_SessionHandler.SetCookie(test_app.Id);
		
		AR_ProgressBarComponentController test_controller = new AR_ProgressBarComponentController();
		
		AR_GeneralInformationController test_childController = new AR_GeneralInformationController();
		
		test_childController.InitPage();
		
		test_controller.getProgressBar();
		
		test_controller.pageController = test_childController;
		
		test_controller.pageController.currentStep = 1;
		
		test_controller.checkStatus(1);
		
		System.currentPageReference().getParameters().put('nextStep', '2');
		
		test_controller.changeStep();
		
		System.assertEquals(2, test_controller.pageController.currentStep, 'Step change failed. Current step is still 1.');
		
		Test.stopTest();
	}
}