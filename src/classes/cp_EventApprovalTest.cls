/**
*
* Author:	Radoslava Radkova
* Date:		04/06/2014
* Description:	Test class for cp_EventApproval class.
*
* -------------------
* COVERAGE:  	  87%
* -------------------
*
**/
@isTest
private class cp_EventApprovalTest
{
	static testmethod void testApproveGlobalEvent()
	{
		User testUser = cp_TestData.getTestUser('System Administrator','Event');
        insert testUser;

		List<cp_Planner__c> planners = new List<cp_Planner__c>();
        cp_Planner__c cluster = cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,'Europe',testUser.Id);
        planners.add(cluster);
        insert planners;

        // Planner Preference
        cp_PlannerPreference__c defaults = new cp_PlannerPreference__c();
        defaults.Planner__c = cluster.Id;
        insert defaults;

        // Event
        cp_Event__c e = cp_TestData.getTestPlannerEvent();
        insert e;

        cp_EventApproval.approveEvent(e.Id);

        List<cp_Event__c> event = [SELECT Id, Activity_Status__c FROM cp_Event__c WHERE Id =: e.id];
        System.assertEquals(event.get(0).Activity_Status__c, cp_EventTriggerHandler.EVENT_STATUS_OFFLINE);

        cp_EventApproval.saveToPlanner(e.Id);

	}

	static testmethod void testApproveLocalEvent()
	{
		User testUser = cp_TestData.getTestUser('System Administrator','Event');
        insert testUser;

		List<cp_Planner__c> planners = new List<cp_Planner__c>();
        cp_Planner__c cluster = cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,'Europe',testUser.Id);
        planners.add(cluster);
        insert planners;

        // Planner Preference
        cp_PlannerPreference__c defaults = new cp_PlannerPreference__c();
        defaults.Planner__c = cluster.Id;
        insert defaults;

        // Event
        cp_Event__c e = cp_TestData.getTestPlannerEvent('Local');
        e.Are_Dates_Guarenteed__c = 'Yes';
        insert e;

        // Planner Locations
        List<cp_PlannerLocation__c> locs = new List<cp_PlannerLocation__c>();
        locs.add(cp_TestData.getTestPlannerLocation(e.Id, cluster.Id));
        insert locs;

        cp_EventApproval.saveToPlanner(e.Id);

        List<cp_Event__c> event = [SELECT Id, Activity_Status__c FROM cp_Event__c WHERE Id =: e.id];
        System.assertEquals(event.get(0).Activity_Status__c, cp_PlannerUtility.CONFIRMED);

        cp_EventApproval.approveEvent(e.Id);
	}

	static testmethod void testApproveGlobalEventWithPlannerLocation()
	{
		User testUser = cp_TestData.getTestUser('System Administrator','Event');
        insert testUser;

		List<cp_Planner__c> planners = new List<cp_Planner__c>();
        cp_Planner__c cluster = cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,'Europe',testUser.Id);
        planners.add(cluster);
        insert planners;

        // Planner Preference
        cp_PlannerPreference__c defaults = new cp_PlannerPreference__c();
        defaults.Planner__c = cluster.Id;
        insert defaults;

        // Event
        cp_Event__c e = cp_TestData.getTestPlannerEvent();
        e.Are_Dates_Guarenteed__c = 'Yes';
        insert e;

        // Planner Locations
        List<cp_PlannerLocation__c> locs = new List<cp_PlannerLocation__c>();
        locs.add(cp_TestData.getTestPlannerLocation(e.Id, cluster.Id));
        insert locs;

        cp_EventApproval.approveEvent(e.Id);

        List<cp_Event__c> event = [SELECT Id, Activity_Status__c FROM cp_Event__c WHERE Id =: e.id];
       	System.assertEquals(cp_EventTriggerHandler.EVENT_STATUS_DRAFT, event.get(0).Activity_Status__c);

        cp_EventApproval.saveToPlanner(e.Id);
	}
	
}