@isTest
public with sharing class AR_Test_AgencyExpAndExperienceController {
	static testmethod void Test_AR_AgencyExpAndExperienceController() 
	{
		//current Page 
		test.setCurrentPage(Page.AR_AgencyExpAndExpertise);
		
		// insert all data required for the page 
		ar_Application__c test_app = TestDataFactory.getApplication();
		test_app.Status__c = 'Incomplete';
		insert test_app;
		
		Attachment test_att = new Attachment();
		test_att.Name = 'one_test';
		test_att.Body = blob.valueOf('test');
		AR_SessionHandler.SetCookie(test_app.Id);
		
		Test.startTest();
			AR_AgencyExpAndExperienceController test_Controller = new AR_AgencyExpAndExperienceController();
			test_Controller.InitPage();
			test_Controller.agencyExperienceObject.obj.put('Market_Developing_Experience__c','test');
			test_Controller.agencyExperienceObject.getFiles().put('one',test_att);
			test_Controller.agencyExperienceObject.SetFiletoInsert('one');
			test_Controller.save();
		Test.stopTest();
		
		List<ar_Experience__c> test_exSystem;
		test_exSystem = [select id, Market_Developing_Experience__c from ar_Experience__c where Application__c = :test_app.id];
		for(ar_Experience__c f:test_exSystem)
		{
			system.assertEquals('test',f.Market_Developing_Experience__c, 'Save failed. ar_Experience__c is not in the System');
		}
	}
}