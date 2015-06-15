/**
*
* Author:		Carmine Barbuto
* Date:			12/05/2014
* Description:	Test class for cp_PlannerTriggerHandler class.
*
* -------------------
* COVERAGE:  	 100%
* -------------------
*
**/
@isTest
private class cp_PlannerTriggerHandlerTest {
	
	static testMethod void testPlannerRename() {
		// Setup data
		User testUser = cp_TestData.getTestUser('System Administrator','pRen');
		insert testUser;

		cp_Planner__c cluster = cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,'Europes',testUser.Id);
		insert cluster;

		// Planner Preference
        cp_PlannerPreference__c defaults = new cp_PlannerPreference__c();
        defaults.Planner__c = cluster.Id;
        insert defaults;

        // Event
        cp_Event__c e = cp_TestData.getTestPlannerEvent();
        insert e;

        // Planner Location
        cp_PlannerLocation__c loc = cp_TestData.getTestPlannerLocation(e.Id, cluster.Id);
        insert loc;

        Test.startTest();
        	cluster.Name = 'Europe';
        	update cluster;
        Test.stopTest();

        // Check that also the text roll-up on Planner Event has been updated
        cp_Event__c temp = [SELECT Track_Cluster__c  FROM cp_Event__c WHERE Id =:e.Id];
        system.assertEquals(temp.Track_Cluster__c,'Europe');

	}

	static testMethod void testPlannerDelete() {
		// Setup data
		User testUser = cp_TestData.getTestUser('System Administrator','pDel');
		insert testUser;

		cp_Planner__c cluster = cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,'TEST',testUser.Id);
		insert cluster;

		// Planner Preference
        cp_PlannerPreference__c defaults = new cp_PlannerPreference__c();
        defaults.Planner__c = cluster.Id;
        insert defaults;

        // Event
        cp_Event__c e = cp_TestData.getTestPlannerEvent();
        insert e;

        // Planner Location
        cp_PlannerLocation__c loc = cp_TestData.getTestPlannerLocation(e.Id, cluster.Id);
        insert loc;

        Test.startTest();
        	delete cluster;
        Test.stopTest();

        // Check that also the text roll-up on Planner Event has been updated
        cp_Event__c temp = [SELECT Track_Cluster__c  FROM cp_Event__c WHERE Id =:e.Id];
        system.assertEquals(temp.Track_Cluster__c,null);

	}

}