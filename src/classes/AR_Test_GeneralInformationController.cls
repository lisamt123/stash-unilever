/*
	Unilever

	Class Name: AR_Test_GeneralInformationController

	Created by: Marc Saelzler | 2013-09-18

	Description: To get test coverage for AR_GeneralInformationController.

	Timeline
	Date 					| Name 				| Description
	2013-09-18 12:38 (CET)	| Marc Saelzler 	| Initial development.
*/

@isTest(SeeAllData=true)
private class AR_Test_GeneralInformationController
{
	static ar_Application__c test_app;
	static AR_GeneralInformationController test_controller;
	static ar_Application__c ctr_application;
	static ar_Shareholder__c ctr_shareholder;
	static ar_Shareholder__c[] tmp_shareholderList;
	static ar_Shareholder__c tmp_shareholder;
	static Date tmp_dateToday;
	static Date tmp_dateTodayPlusOneYear;
	
	static testMethod void AR_Test_GeneralInformationController()
	{
		Test.startTest();
		
		doTestOne();
		doTestTwo();
		doTestThree();
		doTestFour();
		
		Test.stopTest();
	}
		
	static void doTestOne()
	{
		test_app = TestDataFactory.getApplication();
		
		insert test_app;
		
		Test.setCurrentPage(Page.AR_GeneralInformation);
		
		AR_SessionHandler.SetCookie(test_app.Id);
		
		test_controller = new AR_GeneralInformationController();
		
		test_controller.InitPage();
		
		// check if data was loaded
        system.assertNotEquals(null, test_controller.applicationObject.getId(), 'Application data was not loaded');
	}
	
	static void doTestTwo()
	{
		doTestOne();
		
		ctr_application = (ar_Application__c) test_controller.applicationObject.obj;
    	ctr_application.Last_Name__c = 'LastName';
    	ctr_application.Email__c = 'email@test.com';
		
		test_controller.applicationObject.getFiles().put('one', new Attachment(Name = 'TestAttachment', Body = Blob.valueOf('TestBody')));
		test_controller.applicationObject.SetFiletoInsert('one');
		
		test_controller.addRowToShareholderObjectList();
		
		ctr_shareholder = (ar_Shareholder__c) test_controller.shareholderObjectList.get(0).obj;
		ctr_shareholder.Name = 'TestName';
		
		tmp_dateToday = Date.today();
		
		ctr_shareholder.Start_Date_of_Holding__c = tmp_dateToday;
		
		tmp_dateTodayPlusOneYear = Date.today().addYears(1);
		
		ctr_shareholder.End_Date_of_Holding__c = tmp_dateTodayPlusOneYear;
		
		test_controller.saveMyData();
		
		tmp_shareholderList = [SELECT Id, Name, Start_Date_of_Holding__c, End_Date_of_Holding__c FROM ar_Shareholder__c WHERE Application__c =: test_app.Id];
        
        System.assert(!tmp_shareholderList.isEmpty(), 'No ar_Shareholder__c record found.');
	}
	
	static void doTestThree()
	{
        tmp_shareholder = tmp_shareholderList.get(0);
        
        System.assertEquals('TestName', tmp_shareholder.Name, 'Save failed. Name is not \'TestName\'');
        System.assertEquals(tmp_dateToday, tmp_shareholder.Start_Date_of_Holding__c, 'Save failed. Start_Date_of_Holding__c is not today');
        System.assertEquals(tmp_dateTodayPlusOneYear, tmp_shareholder.End_Date_of_Holding__c, 'Save failed. End_Date_of_Holding__c is not today in one year');
	}
	
	static void doTestFour()
	{
		test_controller.shareholderObjectList.get(0).remove();
		
		test_controller.saveMyData();
		
		tmp_shareholderList = [SELECT Id FROM ar_Shareholder__c WHERE Application__c =: test_app.Id];
        
        System.assert(tmp_shareholderList.isEmpty(), 'ar_Shareholder__c record found, but should be deleted.');
	}
	
	static void doTestFive()
	{
		// check if save was successfull
        test_app = [SELECT Id, Last_Name__c, Email__c FROM ar_Application__c WHERE Id =: test_app.Id];
        
        System.assertEquals('LastName', test_app.Last_Name__c, 'Save failed. Last_Name__c is not \'LastName\'');
        System.assertEquals('email@test.com', test_app.Email__c, 'Save failed. Email__c is not \'email@test.com\'');
	}
}