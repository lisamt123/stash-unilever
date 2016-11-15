@isTest
public class AR_Test_AgencyGridView {
	
	static testMethod void testARAgencyGridViewPage()
	{
		createData();
		
		// Instantiate page and controller
		PageReference pageRef = Page.AR_AgencyGridView;
        Test.setCurrentPage(pageRef);
		AR_AgencyGridView agencyGridCon = new AR_AgencyGridView();
		
		// Make sure the 2 agencies are found, and only 1 featured
		system.assertEquals(agencyGridCon.agencies.size(),2,'There should be 2 agencies found');
		system.assertEquals(agencyGridCon.featuredAgencies.size(),1,'There should be 1 featured agency.');
		system.assertEquals(agencyGridCon.filterApplied,false,'There should be no filters yet.');
		
		// Now let's do some filtering
		
		// Filter on name, first don't find.
		agencyGridCon.searchText = 'No agency whoops.';
		agencyGridCon.filterAgencies();
		system.assertEquals(agencyGridCon.agencies.size(),0,'We should return no agencies.');
		agencyGridCon.clearFilters();
		
		// Now actually find something.
		agencyGridCon.searchText = 'Test Account';
		agencyGridCon.filterAgencies();
		system.assertEquals(agencyGridCon.agencies.size(),2,'We should return 2 agencies.');
		agencyGridCon.clearFilters();
		
		// Now lets filter on some options
		agencyGridCon.expertiseSelectedOptions.add('Behaviour Design');
		agencyGridCon.categorySelectedOptions.add('Home Care');
		agencyGridCon.brandSelectedOptions.add('Test Brand');
		agencyGridCon.locationSelectedOptions.add('Test City');
		agencyGridCon.filterAgencies();
		system.assertEquals(agencyGridCon.filterApplied,true,'The flag should say a filter is applied');
		system.assertEquals(agencyGridCon.agencies.size(),1,'We should return only 1 agency now');
		
		// Now let's just clear one of these filters
		agencyGridCon.removeFilterString = 'Test City';
		agencyGridCon.removeFilter();
		system.assertEquals(agencyGridCon.agencies.size(),1,'We should still be on 1 agency.');
		
		// Let's test the pagination methods too
		agencyGridCon.nextPage();
		agencyGridCon.previousPage();
		agencyGridCon.goToPage = 1;
		agencyGridCon.goToPage();
		
	}
	
	private static void createData()
	{
		// Let's create a few agencies with related information
		Account agency = TestDataFactory.getAccount('Agency');
		agency.Agency_Expertise__c = 'Behaviour Design';
		agency.Discipline__c = 'Design';
		insert agency;
		
		Account agency1 = TestDataFactory.getAccount('Agency');
		agency1.Featured__c = false;
		agency1.Agency_Expertise__c = 'Digital Build';
		agency1.Discipline__c = 'Design';
		insert agency1;
		
		ar_Geography__c agencyGeo = TestDataFactory.getGeography();
		agencyGeo.City__c = 'Test City';
		agencyGeo.Agency__c = agency.Id;
		insert agencyGeo;
		
		ar_Geography__c agencyGeo1 = TestDataFactory.getGeography();
		agencyGeo1.City__c = 'City Test';
		agencyGeo1.Agency__c = agency1.Id;
		insert agencyGeo1;
		
		ar_Experience__c agencyExp = TestDataFactory.getExpertise(null);
		agencyExp.RecordTypeId = TestDataFactory.recordTypeMap.get('Experience');
		agencyExp.Agency__c = agency.Id;
		agencyExp.Brand__c = 'Test Brand';
		agencyExp.Category__c = 'Home Care';
		insert agencyExp;

	}

}