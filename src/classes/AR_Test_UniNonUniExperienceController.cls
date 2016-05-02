@isTest
public with sharing class AR_Test_UniNonUniExperienceController {
	static testmethod void AR_UniNonUniExperienceController() 
	{
		//current Page 
		test.setCurrentPage(Page.AR_UnileverExperience);
		
		// insert all data required for the page 
		ar_Application__c test_app = TestDataFactory.getApplication();
		test_app.Status__c = 'Incomplete';
		insert test_app;
		
		AR_SessionHandler.SetCookie(test_app.Id);
		
		Test.startTest();
			AR_UniNonUniExperienceController test_Controller = new AR_UniNonUniExperienceController();
			test_Controller.InitPage();
			test_Controller.agencyULExperienceObject.obj.put('unilever_non_unilever__c','Unilever');
			test_Controller.agencyULExperienceObject.obj.put('Project_Title__c','Test');
			test_Controller.addNewExperience();
			test_Controller.agencyULExperienceObject.obj.put('unilever_non_unilever__c','Non-Unilever');
			test_Controller.agencyULExperienceObject.obj.put('Project_Title__c','Test');
			test_Controller.addNewExperience();
			test_Controller.save();
		 Test.stopTest();
		
		List<ar_Experience__c > test_brSystem;
		test_brSystem = [select id,Project_Title__c from ar_Experience__c  where Application__c = :test_app.id];
		for(ar_Experience__c  f:test_brSystem)
		{
			system.assertEquals('Test',f.Project_Title__c, 'Save failed. ar_Experience__c  is not in the System');
		}
		
	}
}