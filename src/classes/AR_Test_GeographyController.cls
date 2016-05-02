/*
	Unilever

	Class Name: AR_Test_GeographyController

	Created by: Marc Saelzler | 2013-09-18

	Description: To get test coverage for AR_GeographyController.

	Timeline
	Date 					| Name 				| Description
	2013-09-18 15:35 (CET)	| Marc Saelzler 	| Initial development.
*/

@isTest(SeeAllData=true)
public class AR_Test_GeographyController
{
	static ar_Application__c test_app;
	static AR_GeographyController test_controller;
	static ar_Geography__c ctr_geography;
	static ar_Geography__c[] tmp_geographyList;
	static ar_Geography__c tmp_geography;
	
	static testMethod void AR_Test_GeographyController()
	{
		Test.startTest();
		
		doTestOne();
		doTestTwo();
		doTestThree();
		
		Test.stopTest();
	}
	
	static void doTestOne()
	{
		test_app = TestDataFactory.getApplication();
		
		insert test_app;
		
		Test.setCurrentPage(Page.AR_Geography);
		
		AR_SessionHandler.SetCookie(test_app.Id);
		
		test_controller = new AR_GeographyController();
		
		test_controller.InitPage();
		
		// check if data was loaded
        system.assertNotEquals(null, test_controller.application.getId(), 'Application data was not loaded');
	}
	
	static void doTestTwo()
	{
		doTestOne();
		
		ctr_geography = (ar_Geography__c) test_controller.geographyObject.obj;
		ctr_geography.Country__c = 'Hungary';
		ctr_geography.City__c = 'Budapest';
		ctr_geography.Local_office_working_with_UL_today__c = true;
		
		test_controller.addNewGeographyObject();
		
		test_controller.saveMyData();
		
		tmp_geographyList = [SELECT Id, Country__c, City__c, Local_office_working_with_UL_today__c FROM ar_Geography__c WHERE Application__c =: test_app.Id];
        
        System.assert(!tmp_geographyList.isEmpty(), 'No ar_Geography__c record found.');
	}
	
	static void doTestThree()
	{
		doTestTwo();
		
		tmp_geography = tmp_geographyList.get(0);
        
        System.assertEquals('Hungary', tmp_geography.Country__c, 'Save failed. Country__c is not \'Hungary\'');
        System.assertEquals('Budapest', tmp_geography.City__c, 'Save failed. City__c is not \'Budapest\'');
        System.assertEquals(true, tmp_geography.Local_office_working_with_UL_today__c, 'Save failed. Local_office_working_with_UL_today__c is not \'true\'');
        
        test_controller.geographyObjectList.get(0).remove();
        
        test_controller.saveMyData();
        
        tmp_geographyList = [SELECT Id FROM ar_Geography__c WHERE Application__c =: test_app.Id];
        
        System.assert(tmp_geographyList.isEmpty(), 'ar_Geography__c record found, but should be deleted.');
	}
}