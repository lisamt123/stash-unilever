@isTest
public with sharing class AR_Test_AgencyProfileController {
	static testmethod void Test_AR_AgencyProfileController() 
	{
		//current Page 
		test.setCurrentPage(Page.ar_agencyProfile);
		
		// insert all data required for the page 
		ar_Application__c test_app = TestDataFactory.getApplication();
		test_app.Status__c = 'Incomplete';
		insert test_app;
		
		AR_SessionHandler.SetCookie(test_app.Id);
		
		
		Test.startTest();
			AR_AgencyProfileController test_Controller = new AR_AgencyProfileController();
			test_Controller.InitPage();
			//test_Controller.loadMyFieldSets();
			//test_Controller.loadMyData();
			test_Controller.applicationObject.obj = test_app;
			test_Controller.addRowToProjectObjectList();
			for(AR_sObjectHolder s:test_Controller.projectObjectList)
			{
				s.obj.put('Project_Title__c','test');
			}
			test_Controller.save();
		Test.stopTest();
		List<ar_Experience__c> test_brSystem;
		test_brSystem = [select id,Project_Title__c from ar_Experience__c where Application__c = :test_app.id];
		for(ar_Experience__c f:test_brSystem)
		{
			system.assertEquals('test',f.Project_Title__c, 'Save failed. ar_Fixed_Price_Rate_Card__c is not in the System');
		}
		
	
	}
}