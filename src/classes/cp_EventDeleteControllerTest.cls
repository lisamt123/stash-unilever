/**
*
* Author:		Carmine Barbuto
* Date:			27/05/2014
* Description:	Test class for cp_EventDeleteController
*
* ---------------------
* COVERAGE: 	   100%
* ---------------------
**/
@isTest
private class cp_EventDeleteControllerTest {
	
	static testmethod void testDeleteAllowed() {
		// User
		User testUser = cp_TestData.getTestUser('System Administrator','CanEdit');
        insert testUser;

		// Planners
		cp_Planner__c	cluster			= cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,'Europe',testUser.Id);
        cp_Planner__c	mco				= cp_TestData.getTestPlanner(cp_PlannerUtility.MCO,'Italy',testUser.Id);
        insert cluster;
        insert mco;

		// Planner Preference
        cp_PlannerPreference__c def 	= new cp_PlannerPreference__c();
        def.Planner__c              	= cluster.Id;
        insert def;	
        cp_PlannerPreference__c curr 	= new cp_PlannerPreference__c();
        curr.Planner__c              	= cluster.Id;
        curr.User__c 				 	= UserInfo.getUserId();
        insert curr;
        cp_PlannerPreference__c tdef 	= new cp_PlannerPreference__c();
        tdef.Planner__c              	= cluster.Id;
        tdef.User__c 				 	= testUser.Id;
        insert tdef;

        // Planner Event
        cp_Event__c e 					= cp_TestData.getTestPlannerEvent();
        insert e;
        cp_Event__c act                 = cp_TestData.getTestPlannerEvent();
        act.Parent_Event__c             = e.Id;
        insert act;

        // Planner Locations
        cp_PlannerLocation__c loc       = cp_TestData.getTestPlannerLocation(e.Id, cluster.Id);
        loc.Activate__c                 = true;
        insert loc;

        act = [SELECT HostPlanner__c FROM cp_Event__c WHERE Id =:act.Id];
        system.assertEquals(act.HostPlanner__c,cluster.Id); // Host planner set to current user preference

        system.runAs(testUser) {
            // Test controller
	        cp_EventDeleteController controller = new cp_EventDeleteController(new Apexpages.standardcontroller(act));
	        controller.confirmDelete();
    	}

    	List<cp_Event__c> temp = [SELECT HostPlanner__c FROM cp_Event__c WHERE Id =:act.Id];
        system.assertEquals(temp.isEmpty(),true);
        List<cp_PlannerLocation__c> locs = [SELECT Activate__c FROM cp_PlannerLocation__c WHERE Id =:loc.Id];
        system.assertEquals(locs.get(0).Activate__c, false);
	}

	static testmethod void testDeleteStopped() {
		// User
		User testUser = cp_TestData.getTestUser('Planner - Central User PLATFORM','NoEdit');
        insert testUser;

		// Planners
		cp_Planner__c	cluster			= cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,'Europe',testUser.Id);
        cp_Planner__c	mco				= cp_TestData.getTestPlanner(cp_PlannerUtility.MCO,'Italy',testUser.Id);
        insert cluster;
        insert mco;

		// Planner Preference
        cp_PlannerPreference__c def 	= new cp_PlannerPreference__c();
        def.Planner__c              	= cluster.Id;
        insert def;	
        cp_PlannerPreference__c curr 	= new cp_PlannerPreference__c();
        curr.Planner__c              	= cluster.Id;
        curr.User__c 				 	= UserInfo.getUserId();
        insert curr;
        cp_PlannerPreference__c tdef 	= new cp_PlannerPreference__c();
        tdef.Planner__c              	= mco.Id;
        tdef.User__c 				 	= testUser.Id;
        insert tdef;

        // Planner Event
        cp_Event__c e 					= cp_TestData.getTestPlannerEvent();
        insert e;

        e = [SELECT HostPlanner__c FROM cp_Event__c WHERE Id =:e.Id];
        system.assertEquals(e.HostPlanner__c,cluster.Id); // Host planner set to current user preference

        system.runAs(testUser) {
            // Test controller
	        cp_EventDeleteController controller = new cp_EventDeleteController(new Apexpages.standardcontroller(e));
	        controller.confirmDelete();
            controller.back();
    	}

    	List<cp_Event__c> temp = [SELECT HostPlanner__c FROM cp_Event__c WHERE Id =:e.Id];
        system.assertEquals(temp.isEmpty(),false);
	}
}