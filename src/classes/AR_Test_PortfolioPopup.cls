@isTest 
public with sharing class AR_Test_PortfolioPopup {
	static testmethod void Test_AR_PortfolioPopup()
	{
		Test.startTest();
		
		Account Account1 = new Account(
			Name = 'TestAccount'
		);
		Database.insert(Account1);
		
		AR_PortfolioPopup testCon = new AR_PortfolioPopup();
		Account testAgen = testCon.agency;
		testCon.theAgencyId = Account1.Id;
		String tests = testCon.theAgencyId;
		testAgen = testCon.agency;
		Account Testacc2  = testCon.agency;
		List<ar_Experience__c> Testprojects  = testCon.projects;
		
		System.assertEquals(Account1.Id,Testacc2.id,'No Data');
		
		Test.stopTest();
	}
}