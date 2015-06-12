/**
*
* Author:		Carmine Barbuto
* Date:			11/12/2013
* Description:	Test class for cp_EventOptOut class.
*
* -------------------
* COVERAGE:  	  90%
* -------------------
*
**/
@isTest
private class cp_EventOptOutTest {

    static testMethod void testOptOutProcess() {
        // Setup data
        String PLANNER_ONE		= 'Europe';
        String PLANNER_TWO		= 'Africa';
        User testUser 			= cp_TestData.getTestUser('System Administrator','OptOut');
        insert testUser;
        
        // Planners 
        cp_Planner__c	plOne	= cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,PLANNER_ONE,testUser.Id);
        insert plOne;
        cp_Planner__c	plTwo	= cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,PLANNER_TWO,testUser.Id);
        insert plTwo;
        
        // Planner Defaults
        cp_PlannerPreference__c defaults = new cp_PlannerPreference__c();
        defaults.Planner__c = plOne.Id;
        insert defaults;
        cp_PlannerPreference__c userDefault = new cp_PlannerPreference__c();
        userDefault.Planner__c = plOne.Id;
        userDefault.User__c = testUser.Id;
        insert userDefault;
        
        // Event
        cp_Event__c e 			= cp_TestData.getTestPlannerEvent();
        insert e;
        // Child event
        cp_Event__c ce          = cp_TestData.getTestPlannerEvent();
        ce.Parent_Event__c      = e.Id;
        insert ce;

        
        // Related lists >> Planner locations
        cp_PlannerLocation__c locOne    = cp_TestData.getTestPlannerLocation(e.Id, plOne.Id);
        insert locOne;
        cp_PlannerLocation__c locTwo    = cp_TestData.getTestPlannerLocation(e.Id, plTwo.Id);
        insert locTwo;
        cp_PlannerLocation__c celocOne  = cp_TestData.getTestPlannerLocation(ce.Id, plOne.Id);
        insert celocOne;
        
        Test.startTest();
        
        System.runAs(testUser) {
           
            Test.setCurrentPage(Page.cp_EventOptOut);
            Apexpages.currentPage().getParameters().put('Id',e.Id);
            
            cp_EventOptOut controller = new cp_EventOptOut();
            controller.optOutReason = 'Test reason';
            controller.saveAll();
            controller.back();
            
            // Check Opt Out from Planner One
            cp_PlannerLocation__c optout = [SELECT OptOut__c FROM cp_PlannerLocation__c WHERE Planner__c =:plOne.Id];
            system.assertEquals(optout.OptOut__c, true);

            // Check child event has been deleted
            List<cp_Event__c> del = [SELECT Id FROM cp_Event__c WHERE Id =:ce.Id];
            system.assertEquals(del.isEmpty(),true);
        }
            
        Test.stopTest();
        
        
    }

    static testMethod void testOptOutError() {
        // Setup data
        String PLANNER_ONE      = 'Europe';
        String PLANNER_TWO      = 'Africa';
        User testUser           = cp_TestData.getTestUser('System Administrator','OptOut');
        insert testUser;
        
        // Planners 
        cp_Planner__c   plOne   = cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,PLANNER_ONE,testUser.Id);
        insert plOne;
        cp_Planner__c   plTwo   = cp_TestData.getTestPlanner(cp_PlannerUtility.CLUSTER,PLANNER_TWO,testUser.Id);
        insert plTwo;
        
        // Planner Defaults
        cp_PlannerPreference__c defaults = new cp_PlannerPreference__c();
        defaults.Planner__c = plOne.Id;
        insert defaults;
        cp_PlannerPreference__c userDefault = new cp_PlannerPreference__c();
        userDefault.Planner__c = plOne.Id;
        userDefault.User__c = testUser.Id;
        insert userDefault;
        
        // Event
        cp_Event__c e           = cp_TestData.getTestPlannerEvent();
        insert e;
        // Child event
        cp_Event__c ce          = cp_TestData.getTestPlannerEvent();
        ce.Parent_Event__c      = e.Id;
        insert ce;

        
        // Related lists >> Planner locations
        cp_PlannerLocation__c locOne    = cp_TestData.getTestPlannerLocation(e.Id, plOne.Id);
        insert locOne;
        cp_PlannerLocation__c locTwo    = cp_TestData.getTestPlannerLocation(e.Id, plTwo.Id);
        insert locTwo;
        cp_PlannerLocation__c celocOne  = cp_TestData.getTestPlannerLocation(ce.Id, plOne.Id);
        insert celocOne;
        
        Test.startTest();
        
        System.runAs(testUser) {
           
            Test.setCurrentPage(Page.cp_EventOptOut);
            Apexpages.currentPage().getParameters().put('Id',e.Id);
            
            cp_EventOptOut controller = new cp_EventOptOut();
            controller.saveAll();
            controller.back();
            
            // Check Opt Out from Planner One
            cp_PlannerLocation__c optout = [SELECT OptOut__c FROM cp_PlannerLocation__c WHERE Planner__c =:plOne.Id AND Event__c = :e.Id];
            system.assertEquals(optout.OptOut__c, false);

            // Check child event has been deleted
            List<cp_Event__c> del = [SELECT Id FROM cp_Event__c WHERE Id =:ce.Id];
            system.assertEquals(del.isEmpty(),false);
        }
            
        Test.stopTest();        
        
    }
    
}