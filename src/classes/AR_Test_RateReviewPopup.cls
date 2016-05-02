@isTest 
public with sharing class AR_Test_RateReviewPopup {
	static testmethod void Test_RateReviewPopup()
	{
		Test.startTest();
		
		Account Account1 = new Account(
			Name = 'TestAccount'
		);
		Database.insert(Account1);
		AR_RateReviewPopup testcls = new AR_RateReviewPopup();
		testcls.saveReview();
		Account testAgen = testcls.agency;
		testcls.theAgencyId = Account1.Id;
		String tests = testcls.theAgencyId;
		testAgen = testcls.agency;
		Account Testacc2  = testcls.agency;
		
		testcls.rateReview.Review__c = 'test';
		
		testcls.saveReview();
		
		System.assertEquals('test',[Select Review__c From ar_Rating_Review__c where Id = :testcls.rateReview.Id LIMIT 1].Review__c,'No Data');
		
		Test.stopTest();
	}
}