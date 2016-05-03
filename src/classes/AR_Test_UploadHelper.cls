/*
	Unilever

	Class Name: AR_Test_UploadHelper

	Created by: Marc Saelzler | 2013-09-20

	Description: Controller for the page AR_UploadHelper.

	Timeline
	Date 					| Name 				| Description
	2013-09-20 16:44 (CET)	| Marc Saelzler 	| Initial development.
*/

@isTest(SeeAllData=true)
private class AR_Test_UploadHelper
{
	static testMethod void AR_Test_UploadHelper()
	{
		Test.startTest();
		
		ar_Application__c test_app = TestDataFactory.getApplication();
		
		insert test_app;
		
		System.assertNotEquals(null, test_app.Id, 'App save failed.');
		
		AR_UploadHelper test_controller = new AR_UploadHelper();
		
		String tmp_strValue = test_controller.a_fileName;
		test_controller.a_fileName = 'FileName';
		
		tmp_strValue = test_controller.a_fileNamePrefix;
		test_controller.a_fileNamePrefix = 'one';
		
		Boolean tmp_boolValue = test_controller.a_reupload;
		
		test_controller.a_holder = new AR_SObjectHolder(test_app);
		test_controller.a_body = Blob.valueOf('BODY!');
		
		Test.stopTest();
	}
}