@isTest
public with sharing class AR_Test_RateCardController {
	static testmethod void Test_AR_RateCardController() 
	{
		//current Page 
		test.setCurrentPage(Page.AR_UnileverExperience);
		
		// insert all data required for the page 
		ar_Application__c test_app = TestDataFactory.getApplication();
		test_app.Status__c = 'Incomplete';
		insert test_app;
		
		AR_SessionHandler.SetCookie(test_app.Id);
		ar_Rate_Card__c testcard = new ar_Rate_Card__c();
		insert testcard;
		AR_sObjectHolder tmp_Holder = new AR_sObjectHolder(testcard);
		tmp_Holder.remove();
		
		Test.startTest();
			AR_RateCardController test_Controller = new AR_RateCardController();
			test_Controller.InitPage();
			test_Controller.rateCardObject.obj.put('Role_Description__c','test');
			test_Controller.addNewRateCardObject();
			test_Controller.rateCardObjectList.add(tmp_Holder);
			test_Controller.save();
		Test.stopTest();
		 
		List<ar_Rate_Card__c > test_brSystem;
		test_brSystem = [select id,Role_Description__c from ar_Rate_Card__c  where Application__c = :test_app.id];
		for(ar_Rate_Card__c  f:test_brSystem)
		{
			system.assertEquals('test',f.Role_Description__c, 'Save failed. ar_Experience__c  is not in the System');
		}
		
	}
}