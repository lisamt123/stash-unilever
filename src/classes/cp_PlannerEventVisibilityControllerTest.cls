/**
*
* Author:		Carmine Barbuto
* Date:			18/12/2013
* Description:	Test class for cp_PlannerEventVisibilityController class.
*
* -------------------
* COVERAGE:  	 100%
* -------------------
*
**/
@isTest
private class cp_PlannerEventVisibilityControllerTest {

    static testMethod void testVisibilityTable() {
        // Names
        String PLANNER_ONE		= 'Europe';
        
        // Users
        User testUser 			= cp_TestData.getTestUser('System Administrator','VTab');
        insert testUser;
        
        // Planners 
        cp_Planner__c	plOne	= cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,PLANNER_ONE,testUser.Id);
        insert plOne;

        // Planner Preference
        cp_PlannerPreference__c pref    = new cp_PlannerPreference__c();
        pref.Planner__c                 = plOne.Id;
        insert pref;
        
        // Event
        cp_Event__c e 			= cp_TestData.getTestPlannerEvent();
        e.Track_Cluster__c		= PLANNER_ONE;
        insert e;
        cp_Event__c ce          = cp_TestData.getTestPlannerEvent();
        e.Track_Cluster__c      = PLANNER_ONE;
        e.Parent_Event__c       = e.Id;
        insert ce;
        
        // Related lists
        cp_PlannerLocation__c locOne = cp_TestData.getTestPlannerLocation(e.Id, plOne.Id);
        insert locOne;
        cp_PlannerLocation__c locTwo = cp_TestData.getTestPlannerLocation(ce.Id, plOne.Id);
        insert locTwo;

        Test.startTest();

        Test.setCurrentPage(Page.cp_PlannerEventVisibility);
        cp_PlannerEventVisibilityController controller = new cp_PlannerEventVisibilityController(new Apexpages.standardcontroller(e));
        // Check that we display one line for each planner = 1 // skipping duplicates
        system.assertEquals(controller.plList.size(),1);
            
        Test.stopTest();
    }
}