/**
*
* Author:       Carmine Barbuto
* Date:         04/06/2014
* Description:  Test class for cp_RecordDetailController.
*
* --------------
* COVERAGE: 100%
* --------------
*
**/
@isTest
private class cp_RecordDetailControllerTest {
	
	static testMethod void testHostPlanner() {
		// Setup data
        User testUser 		= cp_TestData.getTestUser('System Administrator','Rec');
        insert testUser;
        
        // Planners 
        cp_Planner__c	pl	= cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,'Europe',testUser.Id);
        insert pl;
        
        // Planner Defaults
        cp_PlannerPreference__c defaults 	= new cp_PlannerPreference__c();
        defaults.Planner__c 				= pl.Id;
        insert defaults;

        cp_PlannerPreference__c userDefault = new cp_PlannerPreference__c();
        userDefault.Planner__c 				= pl.Id;
        userDefault.User__c 				= testUser.Id;
        insert userDefault;
        
        System.runAs(testUser) {
        	// Create Event
        	cp_Event__c e = cp_TestData.getTestPlannerEvent();
        	insert e;

        	cp_RecordDetailController controller = new cp_RecordDetailController(new ApexPages.StandardController(e));
        	system.assertEquals(controller.canEdit,true);
    	}
	}

}