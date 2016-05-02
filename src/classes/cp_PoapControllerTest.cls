@isTest
public class cp_PoapControllerTest {
	
	static testMethod void testcp_PoapController()
	{
		// Set up event data
		cp_TestData.createTestData();

		PageReference poapPage = Page.cp_PoaP;
		Test.setCurrentPageReference(poapPage);

		Test.startTest();

			// Instaniate controller
			cp_PoapController poapCon = new cp_PoapController();

			// Get default planner for user
			cp_PlannerPreference__c defaultPreference = cp_PoapController.defaultPreference;

			system.assertEquals(
				[Select Id From cp_Planner__c Order by Name Limit 1][0].Id,
				defaultPreference.Planner__c,
				'Default preference does not match what should be set.'
			);

			// Test page variables
			Boolean addGlobal 				= poapCon.addGlobal;
			Boolean globalOnly 				= poapCon.globalOnly;
			List<SelectOption> firstMonths 	= poapCon.getFirstMonthValues();
			List<SelectOption> lastMonths 	= poapCon.getLastMonthValues();
			List<SelectOption> firstYears 	= poapCon.getFirstYearValues();
			List<SelectOption> lastYears 	= poapCon.getLastYearValues();

			// Get event table
			Component.Apex.OutputText eventTable = poapCon.getMyTable();

			// Run page methods
			poapCon.setPlanner();

		Test.stopTest();
	}

}