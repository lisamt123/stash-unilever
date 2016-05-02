@isTest
public with sharing class AR_Test_FinancialsController {
	static testmethod void Test_AR_FinancialsController() 
	{
		//current Page 
		test.setCurrentPage(Page.AR_Financials);
		
		// insert all data required for the page 
		ar_Application__c test_app = TestDataFactory.getApplication();
		test_app.Status__c = 'Incomplete';
		insert test_app;
		
		ar_Competitor__c test_comp = new ar_Competitor__c();
		test_comp.Application__c = test_app.Id;
		test_comp.Brand__c = 'test';
			
		AR_SessionHandler.SetCookie(test_app.Id);
		
		Test.startTest();
			AR_FinancialsController test_Controller = new AR_FinancialsController();
			test_Controller.InitPage();
			
			// make the blank row appear on screen
			test_Controller.addRowToCompetitorObjectList();
			
			for(AR_SObjectHolder f:test_Controller.financialObjectList)
			{
				f.obj.put('Number_of_Clients__c',3);
			}
			for(AR_SObjectHolder c:test_Controller.competitorObjectList)
			{
				c.obj.put('Brand__c','test');
			}
			test_Controller.save();
		Test.stopTest();
		
		List<ar_Financial__c> test_finSystem;
		test_finSystem = [select id, Number_of_Clients__c from ar_Financial__c where Application__c = :test_app.id];
		for(ar_Financial__c f:test_finSystem)
		{
			system.assertEquals(3,f.Number_of_Clients__c, 'Save failed. Financial is not in the System');
		}
		
		List<ar_Competitor__c> test_CompSystem;
		test_CompSystem = [select id, Brand__c from ar_Competitor__c where Application__c = :test_app.id];
		for(ar_Competitor__c c:test_CompSystem)
		{
			system.assertEquals('test',c.Brand__c, 'Save failed. ar_Competitor__c is not in the System');
		}
		
		
	}
}