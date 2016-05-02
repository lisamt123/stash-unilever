@isTest
public with sharing class AR_Test_BusinessBreakdownController {
	static testmethod void Test_AR_BusinessBreakdownController() 
	{
		//current Page 
		test.setCurrentPage(Page.AR_BusinessBreakdown);
		
		// insert all data required for the page 
		ar_Application__c test_app = TestDataFactory.getApplication();
		test_app.Status__c = 'Incomplete';
		insert test_app;
		
		AR_SessionHandler.SetCookie(test_app.Id);
		
		Test.startTest();
			AR_BusinessBreakdownController test_Controller = new AR_BusinessBreakdownController();
			test_Controller.InitPage();
			test_Controller.addRowToRevenueBreakdownObjectList();
			for(AR_sObjectHolder r:test_Controller.revenueBreakdownObjectList)
			{
				r.obj.put('Discipline__c','Digital');
				r.obj.put('Category__c','Email');
				r.obj.put('Revenue_Contribution__c',20);
			}
			test_Controller.save();
		Test.stopTest();
		
		List<ar_Revenue_Breakdown__c> test_brSystem;
		test_brSystem = [select id, Discipline__c,Category__c,Revenue_Contribution__c from ar_Revenue_Breakdown__c where Application__c = :test_app.id];
		for(ar_Revenue_Breakdown__c f:test_brSystem)
		{
			system.assertEquals('Digital',f.Discipline__c, 'Save failed. ar_Revenue_Breakdown__c is not in the System');
			system.assertEquals('Email',f.Category__c, 'Save failed. ar_Revenue_Breakdown__c is not in the System');
			system.assertEquals(20,f.Revenue_Contribution__c, 'Save failed. ar_Revenue_Breakdown__c is not in the System');
		}
	}
	
	
}