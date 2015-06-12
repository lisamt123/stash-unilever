/*
	Timeline
	Date 					| Name 				| Description
	2013-09-22 22:35 (CET)	| Marc Saelzler 	| Set Agency_Expertise__c to conform to an if clause.
*/

@isTest
public class AR_Test_AgencyDetail {
	
	static testMethod void testAR_AgencyDetailPage()
	{
		// Create test data
		Account agency = TestDataFactory.getAccount('Agency');
		
		agency.Agency_Expertise__c = 'Behaviour Design';
		
		insert agency;
		
		// Instantiate page and controller
		PageReference pageRef = Page.AR_AgencyDetail;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',agency.Id);
		
		AR_AgencyDetail agencyDetailCon = new AR_AgencyDetail(new ApexPages.StandardController(agency));
		
		// Get my rating but fail
		system.assertEquals(agencyDetailCon.yourRating, null, 'You should have no rating yet.'); 
		
		// Let's create some ratings
		ar_Rating_Review__c testReview = TestDataFactory.getReview(agency.Id);
		insert testReview;
		
		// Test the crowd rating is calculating for all fields
		system.assertEquals(agencyDetailCon.crowdRatingMap.size(),6,'We should have a record in the crowdRatingMap for all 6 fields');
		
		// Check for similar agencies, should be none
		system.assertEquals(agencyDetailCon.similarAgencies.size(),0,'There should be no similar agencies');
		
		
	}

}