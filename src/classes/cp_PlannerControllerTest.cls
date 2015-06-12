@isTest
public class cp_PlannerControllerTest {
	
	static testMethod void testcp_PlannerController()
	{
		// Set up event data
		cp_TestData.createTestData();

		PageReference plannerPage = Page.cp_Planner;
		Test.setCurrentPageReference(plannerPage);

		Test.startTest();

			// Instaniate controller
			cp_PlannerController plannerCon = new cp_PlannerController();

			// Get default planner for user
			cp_PlannerPreference__c defaultPreference = cp_PlannerController.defaultPreference;

			system.assertEquals(
				[Select Id From cp_Planner__c Order by Name Limit 1][0].Id,
				defaultPreference.Planner__c,
				'Default preference does not match what should be set.'
			);

			// Get page variables
			String month 									= plannerCon.month;
			String year 									= plannerCon.year;
			List<SelectOption> months 						= plannerCon.getMonthValues();
			List<SelectOption> years 						= plannerCon.getYearValues();

			// Test remote action page variables
			String newActionUrl 									= cp_PlannerController.getNewActionUrl();
			String fieldName 										= cp_PlannerController.getFieldType('StartDate__c');
			String pickListString 									= cp_PlannerController.getPicklistValuesAsString('StartDate__c');
			List<cp_PlannerController.CSelect> fieldList 			= cp_PlannerController.getAllFieldList(true);
			List<cp_PlannerController.DropDownItem> plannerOptions 	= cp_PlannerController.getPlannerOptions();
			List<cp_ULE_Contact__c> actionULE						= cp_PlannerController.getActiveULE();


			// Test retrieving of events
			List<String> plannerFilters = new List<String>();
			for (cp_Planner__c planner :[Select Id From cp_Planner__c])
			{
				plannerFilters.add(planner.Id);
			}
			List<String> uleFilters = new List<String>();
			uleFilters.add([Select Id From cp_ULE_Contact__c][0].Id);

			cp_PlannerController.calendarData calendarData = cp_PlannerController.getMyObjectAsJson(
				string.valueOf(system.today().toStartofMonth()).left(10), // Start Date
				string.valueOf(system.today().addMonths(1).toStartOfMonth()).left(10), // End Date
				'Are_Dates_Guarenteed__c = \'Yes\'', // Advanced Filter
				true, // Global checkbox
				plannerFilters, // List of planner selected filters
				uleFilters // List of ULE selected filters
			);

			// Test saving an event (when moving around the calendar)
			String jsonString = '[{"id":"';
			jsonString += [Select Id from cp_Event__c Order by Name Limit 1][0].Id;
			jsonString += '","title":"Foods - TEST PLANNER now activation","start":"2014-6-16 00:00:00","end":"2014-6-16 00:00:00","allDay":true}]';
			cp_PlannerController.saveEventObject(jsonString);

			// validate save
			system.assertEquals(
				date.newInstance(2014,6,16),
				[Select StartDate__c from cp_Event__c Order by Name Limit 1][0].StartDate__c,
				'Event start date not saved'
			);

		Test.stopTest();
	}



}