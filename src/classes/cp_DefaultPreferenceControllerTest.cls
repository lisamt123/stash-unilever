/**
*
* Author:		Carmine Barbuto
* Date:			09/05/2014
* Description:	Test class for cp_DefaultPreferenceController
*
* ---------------------
* COVERAGE: 		95%
* ---------------------
**/
@isTest
private class cp_DefaultPreferenceControllerTest {
	
	static testmethod void defaultPreferenceTest() {
		// User
		User testUser = cp_TestData.getTestUser('System Administrator','OptOut');
        insert testUser;

		// Planners 
        List<cp_Planner__c> planners = new List<cp_Planner__c>();
        cp_Planner__c	cluster		= cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,'Europe',testUser.Id);
        cp_Planner__c	mco			= cp_TestData.getTestPlanner(cp_PlannerUtility.MCO,'Italy',testUser.Id);
        cp_Planner__c	country		= cp_TestData.getTestPlanner(cp_PlannerUtility.COUNTRY,'Canada',testUser.Id);
        cp_Planner__c	category	= cp_TestData.getTestPlanner(cp_PlannerUtility.CATEGORY,'Foods',testUser.Id);
        cp_Planner__c	expertise	= cp_TestData.getTestPlanner(cp_PlannerUtility.EXPERTISE,'Campaigns',testUser.Id);
        cp_Planner__c	function	= cp_TestData.getTestPlanner(cp_PlannerUtility.FUNCTION,'Legal',testUser.Id);
        planners.add(cluster);
        planners.add(mco);
        planners.add(country);
        planners.add(category);
        planners.add(expertise);
        planners.add(function);
        insert planners;

        // Planner Preference
        cp_PlannerPreference__c def = new cp_PlannerPreference__c();
        def.Planner__c              = cluster.Id;
        insert def;	

        system.runAs(testUser) {
            system.assertEquals(cp_PlannerUtility.getDefaultPlanner(testUser.Id),cluster.Id);

            // Test controller
	        cp_DefaultPreferenceController controller = new cp_DefaultPreferenceController();
	        controller.selectedPlanner = mco.Id;
	        controller.selectPlanner();
	        controller.backToPlanner();

            // Test controller after preference set
            cp_DefaultPreferenceController controller2 = new cp_DefaultPreferenceController();
    	}

        // Check that default preference has been saved
        cp_PlannerPreference__c pref = [SELECT Planner__c FROM cp_PlannerPreference__c WHERE User__c =:testUser.Id];
        system.assertEquals(pref.Planner__c,mco.Id);
	}
}