@isTest
public with sharing class AR_Test_AgencyMyProfileEditGeography {
	static testmethod void Test_AgencyMyProfileEditGeography() 
	{
		//current Page 
		test.setCurrentPage(Page.AR_AgencyMyProfileEditGeography);
		
		// insert all data required for the page 
		Account test_acc = new Account();
		test_acc.Name = 'Test';
		insert test_acc;
		
		Test.startTest();
			AR_AgencyMyProfileEditGeography test_Controller = new AR_AgencyMyProfileEditGeography();
			test_Controller.InitPage();
			//test_Controller.loadMyFieldSets();
			//test_Controller.loadMyData();
			test_Controller.addNewGeographyObject();
			for(AR_sObjectHolder s:test_Controller.geographyObjectList)
			{
				s.obj.put('Country__c','test');
			}
			test_Controller.saveMyData();
		Test.stopTest();
		List<ar_Geography__c> test_GeoSystem;
		test_GeoSystem = [select id,Country__c from ar_Geography__c where Agency__c = :test_acc.id];
		for(ar_Geography__c f:test_GeoSystem)
		{
			system.assertEquals('test',f.Country__c, 'Save failed. ar_Geography__c is not in the System');
		}
		
	
	}
}