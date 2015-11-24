/**
*
* Author:		Carmine Barbuto
* Date:			09/05/2014
* Description:	Test class for cp_PlannerSelectionController class.
*
* -------------------
* COVERAGE:  	  97%
* -------------------
*
**/
@isTest
private class cp_PlannerSelectionControllerTest {
    
    static testMethod void testPlannerSelection() {
	// Setup data
        User testUser = cp_TestData.getTestUser('System Administrator','OptOut');
        insert testUser;
        
        // Planners 
        List<cp_Planner__c> planners    = new List<cp_Planner__c>();
        cp_Planner__c	cluster		= cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,'Europe',testUser.Id);
        cp_Planner__c	mco		    = cp_TestData.getTestPlanner(cp_PlannerUtility.MCO,'Italy',testUser.Id);
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
        cp_PlannerPreference__c defaults = new cp_PlannerPreference__c();
        defaults.Planner__c = mco.Id;
        insert defaults;

        // Event
        cp_Event__c e = cp_TestData.getTestPlannerEvent();
        insert e;

        // Planner Locations
        List<cp_PlannerLocation__c> locs = new List<cp_PlannerLocation__c>();
        locs.add(cp_TestData.getTestPlannerLocation(e.Id, cluster.Id));
        locs.add(cp_TestData.getTestPlannerLocation(e.Id, mco.Id));
        locs.add(cp_TestData.getTestPlannerLocation(e.Id, country.Id));
        locs.add(cp_TestData.getTestPlannerLocation(e.Id, category.Id));
        locs.add(cp_TestData.getTestPlannerLocation(e.Id, expertise.Id));
        //locs.add(cp_TestData.getTestPlannerLocation(e.Id, function.Id));
        insert locs;

        // Test controller
        cp_PlannerSelectionController controller = new cp_PlannerSelectionController(new Apexpages.standardController(e));
        controller.checkEventLocations();
        controller.getAllCategories();
        controller.getAllExpertise();
        controller.getAllFunctions();
        controller.getAllClusters();
        controller.getAllMCOs();
        controller.getAllCountries();
        controller.getJsonTypeCate();
        controller.getJsonTypeExp();
        controller.getJsonTypeFunc();
        controller.getJsonTypeClu();
        controller.getJsonTypeMco();
        controller.getJsonTypeCoun();
        controller.categoryPlanner[0].isSelected    = true;
        controller.functionPlanner[0].isSelected 	= true;
        controller.expertisePlanner[0].isSelected   = true;
        controller.clusterPlanner[0].isSelected 	= false;
        controller.mcoPlanner[0].isSelected 		= true;
        controller.countryPlanner[0].isSelected 	= false;
        controller.saveAll();

        // Check that changes have been saved (initial locations >> 5 now expected 4)
        List<cp_PlannerLocation__c> temp = [SELECT Id FROM cp_PlannerLocation__c WHERE Event__c =:e.Id];
        system.assertEquals(temp.size(),4);

    }

}