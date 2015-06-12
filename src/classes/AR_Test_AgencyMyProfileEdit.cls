@isTest 
public with sharing class AR_Test_AgencyMyProfileEdit {
	static testmethod void Test_AgencyMyProfileEdit()
	{
		Account Account1 = new Account(
			Name = 'TestAccount'
		);
		Database.insert(Account1);
		
		ApexPages.StandardController sc = new ApexPages.StandardController(Account1);
		
		ApexPages.currentPage().getParameters().put('id',Account1.Id);
		
		AR_AgencyMyProfileEdit testcls = new AR_AgencyMyProfileEdit(sc);
		
		Account TestAcc2 = testcls.agency;
		testcls.agency = Account1;
		Account TestAcc3 = testcls.agency;
		
		testcls.getFields();
		
		List<ar_Experience__c> testList = testcls.projects;
		
		System.assertEquals(Account1.Id,TestAcc3.Id,'wrong AccountID');
	}
}