@isTest
public with sharing class AR_Test_AgencyMyProfileEditProjects {
	static testmethod void Test_AgencyMyProfileEditProjects() 
	{
		//current Page 
		test.setCurrentPage(Page.ar_AgencyMyProfileEditProjects);
		
		// insert all data required for the page 
		Account test_acc = new Account();
		test_acc.Name = 'Test';
		insert test_acc;
	
		Test.startTest();
			AR_AgencyMyProfileEditProjects test_Controller = new AR_AgencyMyProfileEditProjects();
			test_Controller.InitPage();
			test_Controller.addRowToProjectObjectList();
			for(AR_sObjectHolder s:test_Controller.projectObjectList)
			{
				s.obj.put('Project_Title__c','test');
			}
			test_Controller.saveMyData();
		Test.stopTest();
		List<ar_Experience__c> test_brSystem;
		test_brSystem = [select id,Project_Title__c from ar_Experience__c where Agency__c = :test_acc.id];
		for(ar_Experience__c f:test_brSystem)
		{
			system.assertEquals('test',f.Project_Title__c, 'Save failed. ar_Fixed_Price_Rate_Card__c is not in the System');
		}
		
		
	
	}
}